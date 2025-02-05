using UnityEngine;
using UnityEngine.Rendering.Universal;


public class Clignotage : MonoBehaviour
{
    private Light2D spot;
  

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        spot = GetComponent<Light2D>();
        spot.enabled=false;
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
