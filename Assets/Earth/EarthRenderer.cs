using UnityEngine;
using UnityEngine.Rendering;

[ExecuteInEditMode]
public class EarthRenderer : MonoBehaviour
{
    #region Public Properties

    // cloud color
    [SerializeField]
    Color _cloudColor = Color.white;

    public Color cloudColor {
        get { return _cloudColor; }
        set { _cloudColor = value; }
    }

    // atmospheric rim color
    [SerializeField, ColorUsage(true, true, 0, 8, 0.125f, 3)]
    Color _rimColor = Color.white;

    public Color rimColor {
        get { return _rimColor; }
        set { _rimColor = value; }
    }

    // exponential coefficient for rim color
    [SerializeField, Range(0.01f, 20.0f)]
    float _rimExponent = 3.2f;

    public float rimExponent {
        get { return _rimExponent; }
        set { _rimExponent = value; }
    }

    // sea color
    [SerializeField]
    Color _seaColor = new Color(0, 0, 1, 0);

    public Color seaColor {
        get { return _seaColor; }
        set { _seaColor = value; }
    }

    // base color saturation
    [SerializeField, Range(0, 2)]
    float _colorSaturation = 1;

    public float colorSaturation {
        get { return _colorSaturation; }
        set { _colorSaturation = value; }
    }

    // light color of night side
    [SerializeField, ColorUsage(true, true, 0, 8, 0.125f, 3)]
    Color _nightLightColor = new Color(0.22f, 0.2f, 0.15f, 1);

    public Color nightLightColor {
        get { return _nightLightColor; }
        set { _nightLightColor = value; }
    }

    // smoothness coefficient
    [SerializeField, Range(0, 1)]
    float _smoothness = 0.5f;

    public float smoothness {
        get { return _smoothness; }
        set { _smoothness = value; }
    }

    // normal map scale factor
    [SerializeField, Range(0, 1)]
    float _normalScale = 0.5f;

    public float normalScale {
        get { return _normalScale; }
        set { _normalScale = value; }
    }

    // cast shadow option
    [SerializeField]
    ShadowCastingMode _castShadows;

    public ShadowCastingMode shadowCastingMode {
        get { return _castShadows; }
        set { _castShadows = value; }
    }

    // receive shadow option
    [SerializeField]
    bool _receiveShadows = true;

    public bool receiveShadows {
        get { return _receiveShadows; }
        set { _receiveShadows = value; }
    }

    #endregion

    #region Fixed Settings

    [SerializeField]
    int _segments = 64;

    [SerializeField]
    int _rings = 32;

    [SerializeField]
    Shader _baseShader;

    [SerializeField]
    Shader _atmosphereShader;

    #endregion

    #region Internal Objects

    Mesh _mesh;
    Material _baseMaterial;
    Material _atmosphereMaterial;
    bool _needsReset = true;

    #endregion

    #region Public Methods

    public void NotifyConfigChange()
    {
        _needsReset = true;
    }

    #endregion

    #region Internal Methods

    Material CreateMaterial(Shader shader)
    {
        var material = new Material(shader);
        material.hideFlags = HideFlags.DontSave;
        return material;
    }

    Mesh CreateMesh()
    {
        var vcount = _rings * (_segments + 1);

        var vertices  = new Vector3[vcount];
        var normals   = new Vector3[vcount];
        var tangents  = new Vector4[vcount];
        var texcoords = new Vector2[vcount];

        var vi = 0;

        for (var ri = 0; ri < _rings; ri++)
        {
            var v = (float)ri / (_rings - 1);
            var theta = Mathf.PI * (v - 0.5f);

            var y    = Mathf.Sin(theta);
            var l_xz = Mathf.Cos(theta);

            for (var si = 0; si < _segments + 1; si++)
            {
                var u = (float)si / _segments;
                var phi = Mathf.PI * 2 * (u - 0.25f);

                var x = Mathf.Cos(phi) * l_xz;
                var z = Mathf.Sin(phi) * l_xz;

                var normal = new Vector3(x, y, z);
                var tangent = Vector3.Cross(normal, Vector3.up).normalized;

                vertices [vi] = normal * 0.5f;
                normals  [vi] = normal;
                tangents [vi] = new Vector4(tangent.x, tangent.y, tangent.z, 1);
                texcoords[vi] = new Vector2(u, v);

                vi++;
            }
        }

        var indices = new int[(_rings - 1) * _segments * 6];
        var ii = 0;
        vi = 0;

        for (var ri = 0; ri < _rings - 1; ri++)
        {
            for (var si = 0; si < _segments; si++)
            {
                indices[ii++] = vi;
                indices[ii++] = vi + _segments + 1;
                indices[ii++] = vi + 1;

                indices[ii++] = vi + _segments + 1;
                indices[ii++] = vi + _segments + 2;
                indices[ii++] = vi + 1;

                vi++;
            }

            vi++;
        }

        var mesh = new Mesh();
        mesh.hideFlags = HideFlags.DontSave;

        mesh.vertices = vertices;
        mesh.normals = normals;
        mesh.tangents = tangents;
        mesh.uv = texcoords;
        mesh.SetIndices(indices, MeshTopology.Triangles, 0);
        mesh.Optimize();

        mesh.bounds = new Bounds(Vector3.zero, Vector3.one);

        return mesh;
    }

    void ResetResources()
    {
        if (_mesh == null)
            _mesh = CreateMesh();

        if (_baseMaterial == null)
            _baseMaterial = CreateMaterial(_baseShader);

        if (_atmosphereMaterial == null)
            _atmosphereMaterial = CreateMaterial(_atmosphereShader);

        _needsReset = false;
    }

    #endregion

    #region MonoBehaviour Functions

    void Reset()
    {
        _needsReset = true;
    }

    void OnDestroy()
    {
        if (_mesh)
            DestroyImmediate(_mesh);

        if (_baseMaterial)
            DestroyImmediate(_baseMaterial);

        if (_atmosphereMaterial)
            DestroyImmediate(_atmosphereMaterial);
    }

    void Update()
    {
        if (_needsReset) ResetResources();

        _baseMaterial.SetColor("_SeaColor", _seaColor);
        _baseMaterial.SetFloat("_Saturation", _colorSaturation);
        _baseMaterial.SetFloat("_Glossiness", _smoothness);
        _baseMaterial.SetColor("_CloudColor", _cloudColor);
        _baseMaterial.SetFloat("_NormalScale", _normalScale);

        _atmosphereMaterial.SetFloat("_RimPower", _rimExponent);
        _atmosphereMaterial.SetColor("_RimColor", _rimColor);
        _atmosphereMaterial.SetColor("_NightColor", _nightLightColor);

        Graphics.DrawMesh(
            _mesh, transform.localToWorldMatrix,
            _baseMaterial, 0, null, 0, null,
            _castShadows, _receiveShadows);

        Graphics.DrawMesh(
            _mesh, transform.localToWorldMatrix,
            _atmosphereMaterial, 0, null, 0, null,
            _castShadows, _receiveShadows);
    }

    #endregion
}
