using System.Runtime.InteropServices;
using UnityEngine;

public class SoundManager : MonoBehaviour
{
    [SerializeField] private AudioClip[] sounds;
    
    [SerializeField] private AudioSource[] audioSources;

    /*public void PlaySound(int clip, float pitch)
    {
        foreach (AudioSource source in audioSources)
        {
            if (!source.isPlaying)
            {
                source.clip = sounds[clip];
                source.pitch = pitch;
                source.Play();
            }
        }
    }*/
    
    public AudioSource PlaySound(int clip, float pitch)
    {
        foreach (AudioSource source in audioSources)
        {
            if (!source.isPlaying)
            {
                source.clip = sounds[clip];
                source.pitch = pitch;
                source.Play();
                return source;
                break;
            }
        }
        return null;
    }

    public void StopSound(AudioSource source)
    {
        source.Stop();
    }
}
