using UnityEngine;
using System.Collections;

public class MipMapBias : MonoBehaviour
{
    public Texture[] textures;
    public float bias = -0.1f;

	void Awake()
    {
        foreach (var t in textures)
            t.mipMapBias = bias;
	}
}
