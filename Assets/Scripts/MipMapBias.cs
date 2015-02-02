using UnityEngine;
using System.Collections;

public class MipMapBias : MonoBehaviour
{
    public Texture[] textures;
    public float bias = -1.0f;

    void Awake()
    {
        foreach (var t in textures)
            t.mipMapBias = bias;
    }
}
