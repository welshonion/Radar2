using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using UnityEngine.UI;

public class RadarController : MonoBehaviour
{
    public Image rend;
    float angleinfo = 0;

    // Start is called before the first frame update
    void Start()
    {
        rend = GameObject.Find("RadarImage").GetComponent<Image>();
        
    }

    // Update is called once per frame
    void Update()
    {
        transform.Rotate(new Vector3(0, 1, 0));
        angleinfo = (int)(transform.localEulerAngles.y + 181)%360;
        //Debug.Log(angleinfo);
        rend.material.SetFloat("_FValue", angleinfo);


    }
}
