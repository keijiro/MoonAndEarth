using UnityEngine;
using System.Collections;

public class SphereBuilder : MonoBehaviour
{
    public int segments = 64;
    public int rings = 32;

    void Awake()
    {
        var vcount = rings * (segments + 1);

        var vertices  = new Vector3[vcount];
        var normals   = new Vector3[vcount];
        var tangents  = new Vector4[vcount];
        var texcoords = new Vector2[vcount];

        var vi = 0;

        for (var ri = 0; ri < rings; ri++)
        {
            var v = (float)ri / (rings - 1);
            var theta = Mathf.PI * (v - 0.5f);

            var y    = Mathf.Sin(theta);
            var l_xz = Mathf.Cos(theta);

            for (var si = 0; si < segments + 1; si++)
            {
                var u = (float)si / segments;
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

        var indices = new int[(rings - 1) * segments * 6];
        var ii = 0;
        vi = 0;

        for (var ri = 0; ri < rings - 1; ri++)
        {
            for (var si = 0; si < segments; si++)
            {
                indices[ii++] = vi;
                indices[ii++] = vi + segments + 1;
                indices[ii++] = vi + 1;

                indices[ii++] = vi + segments + 1;
                indices[ii++] = vi + segments + 2;
                indices[ii++] = vi + 1;

                vi++;
            }

            vi++;
        }

        var mesh = new Mesh();

        mesh.vertices = vertices;
        mesh.normals = normals;
        mesh.tangents = tangents;
        mesh.uv = texcoords;
        mesh.SetIndices(indices, MeshTopology.Triangles, 0);

        GetComponent<MeshFilter>().sharedMesh = mesh;
    }
}
