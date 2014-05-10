import UnityEngine
#import System.Collections

class SphereBuilder(MonoBehaviour): 
    public udiv = 10
    public vdiv = 10

    def Awake():
        mesh = Mesh()

        verts = array(Vector3, vdiv * (udiv + 1))
        uvs = array(Vector2, vdiv * (udiv + 1))
        vi = 0

        for v in range(vdiv):
            rv = Mathf.PI * (1.0 * v / (vdiv - 1) - 0.5)
            dy = Mathf.Sin(rv)
            dl = Mathf.Cos(rv)
            for u in range(udiv + 1):
                ru = Mathf.PI * 2 * (1.0 * u / udiv - 0.5)
                dx = Mathf.Cos(ru) * dl
                dz = Mathf.Sin(ru) * dl
                uvs[vi] = Vector2(1.0 * u / udiv, 1.0 * v / (vdiv - 1))
                verts[vi++] = Vector3(dx, dy, dz) * 0.5

        idxs = array(int, (vdiv - 1) * udiv * 6)
        ii = 0
        vi = 0

        for v in range(vdiv - 1):
            for u in range(udiv):
                idxs[ii++] = vi
                idxs[ii++] = vi + udiv + 1
                idxs[ii++] = vi + 1

                idxs[ii++] = vi + udiv + 1
                idxs[ii++] = vi + udiv + 2
                idxs[ii++] = vi + 1

                vi++
            vi++

        mesh.vertices = verts
        mesh.uv = uvs
        mesh.SetIndices(idxs, MeshTopology.Triangles, 0)

        GetComponent[of MeshFilter]().mesh = mesh
