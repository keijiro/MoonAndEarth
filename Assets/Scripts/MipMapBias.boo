import UnityEngine

class MipMapBias(MonoBehaviour):
    public textures as (Texture)
    public bias = -1.0

    def Awake():
        for t in textures:
            t.mipMapBias = bias
