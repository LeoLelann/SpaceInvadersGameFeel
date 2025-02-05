using UnityEngine;
using UnityEngine.Events;
using System.Collections;
using UnityEditor;

public class ShakeScreen : MonoBehaviour
{

    [SerializeField] bool button;
    [SerializeField] AnimationCurve ShakeCurve;
    [SerializeField] float _duration;

    private Vector3 _startPos;
    private float _elapsedTime;
    private float _power;

    private void Start()
    {
        button = false;
        _startPos = this.transform.position;
        _elapsedTime = 0f;
    }

    private void Update()
    {
        if (button)
        {
            button = false;
            StartCoroutine(Shake());
        }
        Debug.Log(_elapsedTime);
    }

    IEnumerator Shake()
    {
        _elapsedTime = 0f;   

        while (_elapsedTime < _duration)
        {
            _elapsedTime += Time.deltaTime;
            _power = ShakeCurve.Evaluate(_elapsedTime / _duration);
            transform.position = _startPos + Random.insideUnitSphere * _power;
            yield return null;
        }
        transform.position = _startPos;  
    }
}


