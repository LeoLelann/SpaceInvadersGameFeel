using UnityEngine;
using UnityEngine.Rendering.Universal;
using System.Collections;

public class Clignotage : MonoBehaviour
{
    [SerializeField] private SoundManager _soundManager;
    
    private Light2D spot;
    public float minInterval = 1.25f;  // Intervalle minimum avant extinction
    public float maxInterval = 2.5f;   // Intervalle maximum avant extinction
    public float minOnTime = 2.5f;     // Temps minimum allum� avant extinction
    public float flickerDuration = 0.5f; // Dur�e du clignotement fr�n�tique
    public float flickerSpeed = 0.1f;  // Vitesse du clignotement fr�n�tique

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
            spot.enabled = true;  // Rester allum�
            yield return new WaitForSeconds(minOnTime); // Attendre le temps minimum allum�

            // Attendre un d�lai al�atoire avant d'�teindre
            float randomOffTime = Random.Range(minInterval, maxInterval);
            yield return new WaitForSeconds(randomOffTime);

            // Clignotement rapide avant extinction compl�te
            yield return StartCoroutine(FlickerEffect());
            spot.enabled = false; // �teindre compl�tement

            // Attendre un d�lai al�atoire avant de rallumer
            float randomOnTime = Random.Range(minInterval, maxInterval);
            yield return new WaitForSeconds(randomOnTime);
        }
    }

    IEnumerator FlickerEffect()
    {
        _soundManager.PlaySound(8, 1);
        
        float elapsedTime = 0f;
        while (elapsedTime < flickerDuration)
        {
            spot.enabled = !spot.enabled; // Alterner l'�tat de la lumi�re
            yield return new WaitForSeconds(flickerSpeed); // Attendre un court instant
            elapsedTime += flickerSpeed;
        }
    }
}
