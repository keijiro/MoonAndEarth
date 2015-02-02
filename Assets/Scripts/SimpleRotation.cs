using UnityEngine;
using System.Collections;

public class SimpleRotation : MonoBehaviour
{
    public float angularVelocity = 10.0f;
    public Vector3 rotationAxis = Vector3.up;

    void Update()
    {
        transform.localRotation = Quaternion.AngleAxis(angularVelocity * Time.deltaTime, rotationAxis) * transform.localRotation;
    }
}
