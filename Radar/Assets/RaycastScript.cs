using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using UnityEngine.UI;

public class RaycastScript : MonoBehaviour
{

    public float raser_distance_area = 200.0f;

    public Image rendray;
    float[] hoge = new float[360];
    int angleinfo_ray = 0;


    // Start is called before the first frame update
    void Start()
    {
        rendray = GameObject.Find("RadarImage").GetComponent<Image>();
        for (int i = 0; i < 360; i++)
        {
            hoge[i] = 0.0f;
        }
        rendray.material.SetFloatArray("_FDIST", hoge);

    }

    // Update is called once per frame
    void Update()
    {
        Ray ray = new Ray(transform.position, transform.forward);
        RaycastHit hit;

        angleinfo_ray = ((int)(transform.localEulerAngles.y)+180)%360;
        //Debug.Log(angleinfo_ray);


        if (Physics.Raycast(ray,out hit, raser_distance_area))
        {
            //Debug.Log(hit.collider.gameObject.transform.position);
            Debug.Log(hit.distance);
            hoge[angleinfo_ray] = (hit.distance / raser_distance_area) -2.0f;
            //Debug.Log(hoge[angleinfo_ray]);
            rendray.material.SetFloatArray("_FDIST", hoge);

        }
        else
        {
            hoge[angleinfo_ray] = 0.0f;
            //rendray.material.SetFloatArray("_FDIST", hoge);
        }



        //rendray.material.SetFloatArray("_FDIST", hoge);

        Debug.DrawRay(ray.origin, ray.direction*10, Color.red, 3.0f);
    }
}
