using UnityEngine;

[ExecuteInEditMode]
public sealed class EarthSunlightSetter : MonoBehaviour
{
    public Light _sunlight;

    MaterialPropertyBlock _prop;

    void LateUpdate()
    {
        if (_sunlight == null) return;

        if (_prop == null) _prop = new MaterialPropertyBlock();

        var r = GetComponent<MeshRenderer>();
        r.GetPropertyBlock(_prop);
        _prop.SetVector("_SunDirection", _sunlight.transform.forward);
        r.SetPropertyBlock(_prop);
    }
}
