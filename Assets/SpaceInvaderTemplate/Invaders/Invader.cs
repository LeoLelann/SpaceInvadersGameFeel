using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class Invader : MonoBehaviour
{
    //Scoring
    private GameManager _gameManager;
    private GameObject _player;
    [SerializeField] private GameObject _eyeL;
    [SerializeField] private GameObject _eyeR;
    
    [SerializeField] private Bullet bulletPrefab = null;
    [SerializeField] private Transform shootAt = null;
    [SerializeField] private string collideWithTag = "Player";

    [SerializeField] private Material deathMat;
    [SerializeField] private float timeToDestroy;
    SpriteRenderer spriteRenderer;
    private Collider2D col;


    internal Action<Invader> onDestroy;

    public Vector2Int GridIndex { get; private set; }

    public void Initialize(Vector2Int gridIndex)
    {
        this.GridIndex = gridIndex;
        _gameManager = GameObject.Find("GameManager").GetComponent<GameManager>();
        _player = GameObject.Find("Player");
        spriteRenderer = GetComponent<SpriteRenderer>();
        col = GetComponent<Collider2D>();
    }

    public void OnDestroy()
    {
        onDestroy?.Invoke(this);
        Destroy(gameObject);
    }
    public void Death()
    {
        col.enabled = false;
        foreach (Transform child in transform)
        {
            child.gameObject.SetActive(false);
        }
        spriteRenderer.material = deathMat;

        StartCoroutine(DeathAnimation());
        //float[] intensity = deathMat.GetFloatArray("Intensity_Max");
    }

    private IEnumerator DeathAnimation()
    {
        float elapsedTime = 0f;
        float startValue = 0f;
        float endValue = 4f;

        while (elapsedTime < timeToDestroy)
        {
            elapsedTime += Time.deltaTime;
            float lerpValue = Mathf.Lerp(startValue, endValue, elapsedTime / timeToDestroy);
            spriteRenderer.material.SetFloat("_Intensity_Max", lerpValue);
            yield return null;
        }

        OnDestroy();
    }

    public void OnTriggerEnter2D(Collider2D collision)
    {
        if(collision.gameObject.tag != collideWithTag) { return; }

        /*if (collision.tag == collideWithTag)
        {
            
        }*/
        
        Destroy(collision.gameObject);
        //Destroy(gameObject);
        Death();
        _gameManager.UpdatePlayerScore();
    }

    public void Shoot()
    {
        Instantiate(bulletPrefab, shootAt.position, Quaternion.identity);
    }
    
    void Update()
    {
        Vector3 Look1 = _eyeL.transform.InverseTransformPoint(_player.transform.position);
        Vector3 Look2 = _eyeR.transform.InverseTransformPoint(_player.transform.position);
        float angle1 = Mathf.Atan2(Look1.y, Look1.x) * Mathf.Rad2Deg + 90;
        float angle2 = Mathf.Atan2(Look2.y, Look2.x) * Mathf.Rad2Deg + 90;
        
        _eyeL.transform.Rotate(0, 0, angle1);
        _eyeR.transform.Rotate(0, 0, angle2);

        Debug.Log(_player.transform.position);
    }
}
