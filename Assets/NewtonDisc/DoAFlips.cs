using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DoAFlips : MonoBehaviour
{
    // Start is called before the first frame update
    Vector3 MouseStart;
    Vector3 MouseEnd;
    public float forceConstant = 5;
    public int maxAngularVelocity = 40;
    int rotationDirection;
    Rigidbody rb;
    Material NewtonDiscEffectMat;
    void Start()
    {
        rb = GetComponent<Rigidbody>();
        rb.maxAngularVelocity = maxAngularVelocity;
        NewtonDiscEffectMat = GetComponent<MeshRenderer>().material;
    }

    void Update()
    {

        if(rb.angularVelocity.magnitude > 0)
        {

            float ratio = rb.angularVelocity.magnitude / maxAngularVelocity;
            NewtonDiscEffectMat.SetFloat("_Angle", ratio*360*rotationDirection);

        }

        if (Input.GetMouseButtonDown(0))
        {
            MouseStart = Input.mousePosition;
        }


        if (Input.GetMouseButtonUp(0))
        {
            MouseEnd = Input.mousePosition;

            float distance = Vector3.Distance(MouseEnd, MouseStart);
            rotationDirection = (MouseEnd.x>MouseStart.x) ? -1 : 1;
            rb.AddTorque(transform.up * distance * forceConstant * rotationDirection);


        }

    }
}
