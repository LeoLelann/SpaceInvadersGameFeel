using UnityEngine;
using UnityEngine.Rendering.Universal;
using System.Collections;

public class Clignotage : MonoBehaviour
{
    private Light2D spot;
    public float minInterval = 1.25f;  // Intervalle minimum avant extinction
    public float maxInterval = 2.5f;   // Intervalle maximum avant extinction
    public float minOnTime = 2.5f;     // Temps minimum allumé avant extinction
    public float flickerDuration = 0.5f; // Durée du clignotement frénétique
    public float flickerSpeed = 0.1f;  // Vitesse du clignotement frénétique

    void Start()
    {
        spot = GetComponent<Light2D>();
        StartCoroutine(BlinkLight());
    }

    IEnumerator BlinkLight()
    {
        while (true)
        {
            // Clignotement rapide avant allumage complet
            yield return StartCoroutine(FlickerEffect());
            spot.enabled = true;  // Rester allumé
            yield return new WaitForSeconds(minOnTime); // Attendre le temps minimum allumé

            // Attendre un délai aléatoire avant d'éteindre
            float randomOffTime = Random.Range(minInterval, maxInterval);
            yield return new WaitForSeconds(randomOffTime);

            // Clignotement rapide avant extinction complète
            yield return StartCoroutine(FlickerEffect());
            spot.enabled = false; // Éteindre complètement

            // Attendre un délai aléatoire avant de rallumer
            float randomOnTime = Random.Range(minInterval, maxInterval);
            yield return new WaitForSeconds(randomOnTime);
        }
    }

    IEnumerator FlickerEffect()
    {
        float elapsedTime = 0f;
        while (elapsedTime < flickerDuration)
        {
            spot.enabled = !spot.enabled; // Alterner l'état de la lumière
            yield return new WaitForSeconds(flickerSpeed); // Attendre un court instant
            elapsedTime += flickerSpeed;
        }
    }
}
