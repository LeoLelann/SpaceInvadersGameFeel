using UnityEngine;
using UnityEngine.Events;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using Unity.VisualScripting;

public class ShakeScreen : MonoBehaviour
{

    [SerializeField] bool button;
    [SerializeField] AnimationCurve ShakeCurve;
    [SerializeField] private Wave wave;
    [SerializeField] GameObject player;

    [Header("")]
    [SerializeField] private float distToShake1 = 4f;
    [SerializeField] private float distToShake2 = 2f;
    [SerializeField] private float distToShake3 = 1f;

    [SerializeField] float _duration1;
    [SerializeField] float _duration2;
    [SerializeField] float _duration3;
    [SerializeField] float _shakeOnDyingDuration;

    [SerializeField] float _timeBtwShake1;
    [SerializeField] float _timeBtwShake2;
    [SerializeField] float _timeBtwShake3;



    private Vector3 _startPos;
    private Vector3 _bottomInvadersPos;
    private float _elapsedTime;
    private float _power;
    private bool _isShaking1;
    private bool _isShaking2;
    private bool _isShaking3;
    private bool _hasReachShake1 = false;
    private bool _hasReachShake2 = false;
    private bool _hasReachShake3 = false;
    private Coroutine currentShake;
    //private float _invadersRaw;

    private void Start()
    {
        button = false;
        _startPos = this.transform.position;
        _elapsedTime = 0f;
        _isShaking1 = false;
        _isShaking2 = false;
        _isShaking3 = false;
    }

    private void Update()
    {
        //_bottomInvadersPos = wave.InvaderPerRow[0].position;
        if (button)
        {
            button = false;
            StartCoroutine(Shake1());
        }
        //wave.GetRowPosition();

        float lowestInvaderY = wave.GetLowestRowPosition();
        float distance = Mathf.Abs(lowestInvaderY - player.transform.position.y);
        Debug.Log(distance);
        if (distance <= distToShake3 && !_isShaking3)
        {
            StopCurrentShake();
            _isShaking3 = true;
            currentShake = StartCoroutine(Shake3());
        }
        else if (distance <= distToShake2 && !_isShaking2)
        {
            StopCurrentShake();
            _isShaking2 = true;
            currentShake = StartCoroutine(Shake2());
        }
        else if (distance <= distToShake1 && !_isShaking1)
        {
            _isShaking1 = true;
            currentShake = StartCoroutine(Shake1());
        }
        //Debug.DrawLine(player.transform.position, new Vector3(0,distToShake3,0), Color.blue);
    }


    private void StopCurrentShake()
    {
        if (currentShake != null)
        {
            StopCoroutine(currentShake);
            transform.position = _startPos;
            _isShaking1 = false;
            _isShaking2 = false;
            _isShaking3 = false;
        }
    }
    IEnumerator Shake1()
    {
        Debug.Log("Shake1");

        _elapsedTime = 0f;   
        while (_elapsedTime < _duration1)
        {
            _elapsedTime += Time.deltaTime;
            _power = ShakeCurve.Evaluate(_elapsedTime / _duration1);
            transform.position = _startPos + Random.insideUnitSphere * _power;
            yield return null;
        }
        transform.position = _startPos;
        yield return new WaitForSeconds(_timeBtwShake1);
        StopCurrentShake();
        _isShaking1 = false;
    }
    IEnumerator Shake2()
    {
        _hasReachShake1 = true;
        Debug.Log("Shake2");

        _elapsedTime = 0f;

        while (_elapsedTime < _duration2)
        {
            _elapsedTime += Time.deltaTime;
            _power = ShakeCurve.Evaluate(_elapsedTime / _duration2);
            transform.position = _startPos + Random.insideUnitSphere * _power;
            yield return null;
        }
        transform.position = _startPos;
        yield return new WaitForSeconds(_timeBtwShake2);
        StopCurrentShake();
        _isShaking2 = false;
    }
    IEnumerator Shake3()
    {
        _hasReachShake2 = true;
        Debug.Log("Shake3");
        _elapsedTime = 0f;

        while (_elapsedTime < _duration3)
        {
            _elapsedTime += Time.deltaTime;
            _power = ShakeCurve.Evaluate(_elapsedTime / _duration3);
            transform.position = _startPos + Random.insideUnitSphere * _power;
            yield return null;
        }
        transform.position = _startPos;
        yield return new WaitForSeconds(_timeBtwShake3);
        StopCurrentShake();
        _isShaking3 = false;
    }
}