#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float2 position [[attribute(0)]];
    float2 uv [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float2 uv;
};

vertex VertexOut vertexShader(VertexIn in [[stage_in]]) {
    VertexOut out;
    out.position = float4(in.position, 0.0, 1.0);
    out.uv = in.uv;
    return out;
}

float gaussianBlur(texture2d<float> tex, float2 uv, float blurRadius) {
    float result = 0.0;
    float kernel[5] = {0.06136, 0.24477, 0.38774, 0.24477, 0.06136};
    float2 texelSize = float2(1.0) / float2(tex.get_width(), tex.get_height());
    
    for (int i = -2; i <= 2; i++) {
        float2 offset = float2(float(i) * blurRadius * texelSize.x, 0.0);
        result += tex.sample(bilinear_sampler, uv + offset).r * kernel[i + 2];
    }
    
    return result;
}

fragment float4 fragmentShader(VertexOut in [[stage_in]],
                               texture2d<float> inputTexture [[texture(0)]],
                               sampler textureSampler [[sampler(0)]]) {
    float blurFactor = gaussianBlur(inputTexture, in.uv, 1.5);
    
    float specular = pow(max(dot(float3(0.0, 0.0, 1.0), float3(0.0, 1.0, 0.0)), 0.0), 32.0);
    float3 color = float3(0.8, 0.9, 1.0) * blurFactor + float3(1.0) * specular * 0.3;
    
    return float4(color, 0.85);
}
