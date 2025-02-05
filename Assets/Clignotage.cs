using UnityEngine;
using UnityEngine.Rendering.Universal;
using System.Collections;

public class Clignotage : MonoBehaviour
{
    private Light2D spot;
    public float minInterval = 1.25f;  // Intervalle minimum pour s'�teindre
    public float maxInterval = 2.5f;  // Intervalle maximum pour s'�teindre
    public float minOnTime = 2.5f;    // Temps minimum allum� avant de pouvoir s'�teindre

    void Start()
    {
        spot = GetComponent<Light2D>();
        StartCoroutine(BlinkLight());
    }

    IEnumerator BlinkLight()
    {
        while (true)
        {
            spot.enabled = true;  // Allumer la lumi�re
            yield return new WaitForSeconds(minOnTime); // Attendre au moins 2 secondes

            float randomOffTime = Random.Range(minInterval, maxInterval); // G�n�rer un d�lai al�atoire avant de s'�teindre
            yield return new WaitForSeconds(randomOffTime);

            spot.enabled = false; // �teindre la lumi�re
            float randomOnTime = Random.Range(minInterval, maxInterval); // G�n�rer un d�lai al�atoire avant de se rallumer
            yield return new WaitForSeconds(randomOnTime);
        }
    }
}
