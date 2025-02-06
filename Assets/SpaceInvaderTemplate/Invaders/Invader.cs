using System;
using System.Collections;
using System.Collections.Generic;
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

    internal Action<Invader> onDestroy;

    public Vector2Int GridIndex { get; private set; }

    public void Initialize(Vector2Int gridIndex)
    {
        this.GridIndex = gridIndex;
        _gameManager = GameObject.Find("GameManager").GetComponent<GameManager>();
        _player = GameObject.Find("Player");
    }

    public void OnDestroy()
    {
        onDestroy?.Invoke(this);
    }

    public void OnTriggerEnter2D(Collider2D collision)
    {
        if(collision.gameObject.tag != collideWithTag) { return; }

        /*if (collision.tag == collideWithTag)
        {
            
        }*/
        
        Destroy(gameObject);
        Destroy(collision.gameObject);
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
