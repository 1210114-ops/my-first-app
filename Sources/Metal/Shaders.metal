#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
    float2 texCoords [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float2 texCoords;
};

// 頂點著色器
vertex VertexOut glass_vertex(VertexIn in [[stage_in]]) {
    VertexOut out;
    out.position = in.position;
    out.texCoords = in.texCoords;
    return out;
}

// 片段著色器：液態玻璃背景渲染
fragment float4 glass_fragment(VertexOut in [[stage_in]],
                               texture2d<float> texture [[texture(0)]]) {
    constexpr sampler textureSampler(coord::normalized, filter::linear);
    
    // 基礎採樣
    float4 color = texture.sample(textureSampler, in.texCoords);
    
    // 模擬玻璃厚度高光感 (Glass Specular Highlight)
    float highlight = pow(in.texCoords.y, 2.0) * 0.15;
    color.rgb += float3(highlight);
    
    // 半透明玻璃 Alpha 混合
    color.a = 0.85;
    
    return color;
}
