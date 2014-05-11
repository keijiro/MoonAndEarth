import UnityEngine

class SimpleRotation(MonoBehaviour):
    public angularVelocity = 10.0
    public rotationAxis = Vector3.up

    def Update():
        transform.localRotation = Quaternion.AngleAxis(angularVelocity * Time.deltaTime, rotationAxis) * transform.localRotation
