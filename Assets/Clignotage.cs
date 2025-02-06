using UnityEngine;
using UnityEngine.Rendering.Universal;
using System.Collections;

public class Clignotage : MonoBehaviour
{
    private Light2D spot;
    public float minInterval = 1.25f;  // Intervalle minimum pour s'éteindre
    public float maxInterval = 2.5f;  // Intervalle maximum pour s'éteindre
    public float minOnTime = 2.5f;    // Temps minimum allumé avant de pouvoir s'éteindre

    void Start()
    {
        spot = GetComponent<Light2D>();
        StartCoroutine(BlinkLight());
    }

    IEnumerator BlinkLight()
    {
        while (true)
        {
            spot.enabled = true;  // Allumer la lumière
            yield return new WaitForSeconds(minOnTime); // Attendre au moins 2 secondes

            float randomOffTime = Random.Range(minInterval, maxInterval); // Générer un délai aléatoire avant de s'éteindre
            yield return new WaitForSeconds(randomOffTime);

            spot.enabled = false; // Éteindre la lumière
            float randomOnTime = Random.Range(minInterval, maxInterval); // Générer un délai aléatoire avant de se rallumer
            yield return new WaitForSeconds(randomOnTime);
        }
    }
}
