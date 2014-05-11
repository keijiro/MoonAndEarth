import UnityEngine

class SphereBuilder(MonoBehaviour): 
    public segments = 64
    public rings = 32

    def Awake():
        mesh = Mesh()

        vcount = rings * (segments + 1)

        vertices  = array(Vector3, vcount)
        normals   = array(Vector3, vcount)
        tangents  = array(Vector4, vcount)
        texcoords = array(Vector2, vcount)

        vi = 0

        for ri in range(rings):

            v = 1.0 * ri / (rings - 1)
            theta = Mathf.PI * (v - 0.5)
            y = Mathf.Sin(theta)
            l_xz = Mathf.Cos(theta)

            for si in range(segments + 1):

                u = 1.0 * si / segments
                phi = Mathf.PI * 2 * (u - 0.5)
                x = Mathf.Cos(phi) * l_xz
                z = Mathf.Sin(phi) * l_xz

                normal = Vector3(x, y, z)
                tangent = Vector3.Cross(normal, Vector3.up).normalized

                vertices[vi] = normal * 0.5
                normals[vi] = normal
                tangents[vi] = Vector4(tangent.x, tangent.y, tangent.z, 1)
                texcoords[vi] = Vector2(u, v)

                vi++

        indices = array(int, (rings - 1) * segments * 6)
        ii = 0
        vi = 0

        for ri in range(rings - 1):
            for si in range(segments):
                indices[ii++] = vi
                indices[ii++] = vi + segments + 1
                indices[ii++] = vi + 1

                indices[ii++] = vi + segments + 1
                indices[ii++] = vi + segments + 2
                indices[ii++] = vi + 1

                vi++
            vi++

        mesh.vertices = vertices
        mesh.normals = normals
        mesh.tangents = tangents
        mesh.uv = texcoords
        mesh.SetIndices(indices, MeshTopology.Triangles, 0)

        GetComponent[of MeshFilter]().mesh = mesh
