using System;
using System.Collections.Generic;
using TMPro;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UIElements;

[DefaultExecutionOrder(-100)]
public class GameManager : MonoBehaviour
{
    public enum DIRECTION { Right = 0, Up = 1, Left = 2, Down = 3 }

    public static GameManager Instance = null;

    [SerializeField] private Vector2 bounds;
    private Bounds Bounds => new Bounds(transform.position, new Vector3(bounds.x, bounds.y, 1000f));

    [SerializeField] private float gameOverHeight;
    
    //Lancement jeu avec une touche and reset after win
    private bool _isGameStarted = false;
    [SerializeField] private List<GameObject> _uiElements = new List<GameObject>();
    [SerializeField] private GameObject _wave;
    [SerializeField] private GameObject _newWave;
    
    //Scoring
    private int _playerScore = 0;
    [SerializeField] private TextMeshProUGUI _scoreText;
    

    void Awake()
    {
        Instance = this;
    }

    private void Update()
    {
        if (!_isGameStarted && Input.GetKeyDown(KeyCode.Space))
        {
            foreach (GameObject uiElement in _uiElements) {uiElement.SetActive(false);}
            _wave.SetActive(true);
            _isGameStarted = true;
        }
        
        _scoreText.text = $"Score: {_playerScore}";
    }

    public void UpdatePlayerScore()
    {
        _playerScore++;
    }

    public void StartNewWave()
    {
        _newWave = Instantiate(_wave, transform.position + new Vector3(0, 1.75f, 0), Quaternion.identity);
        Destroy(_wave);
        _wave = _newWave;
        //_wave.SetActive(true);
    }

    public Vector3 KeepInBounds(Vector3 position)
    {
        return Bounds.ClosestPoint(position);
    }

    public float KeepInBounds(float position, DIRECTION side)
    {
        switch (side)
        {
            case DIRECTION.Right: return Mathf.Min(position, Bounds.max.x);
            case DIRECTION.Up: return Mathf.Min(position, Bounds.max.y);
            case DIRECTION.Left: return Mathf.Max(position, Bounds.min.x);
            case DIRECTION.Down: return Mathf.Max(position, Bounds.min.y);
            default: return position;
        }
    }

    public bool IsInBounds(Vector3 position)
    {
        return Bounds.Contains(position);
    }

    public bool IsInBounds(Vector3 position, DIRECTION side)
    {
        switch (side)
        {
            case DIRECTION.Right: case DIRECTION.Left: return IsInBounds(position.x, side);
            case DIRECTION.Up: case DIRECTION.Down: return IsInBounds(position.y, side);
            default: return false;
        }
    }

    public bool IsInBounds(float position, DIRECTION side)
    {
        switch (side)
        {
            case DIRECTION.Right: return position <= Bounds.max.x;
            case DIRECTION.Up: return position <= Bounds.max.y;
            case DIRECTION.Left: return position >= Bounds.min.x;
            case DIRECTION.Down: return position >= Bounds.min.y;
            default: return false;
        }
    }

    public bool IsBelowGameOver(float position)
    {        
        return position < transform.position.y + (gameOverHeight - bounds.y * 0.5f);
    }

    public void PlayGameOver()
    {
        Debug.Log("Game Over");
        Time.timeScale = 0f;
    }

    public void OnDrawGizmos()
    {
        Gizmos.color = Color.gray;
        Gizmos.DrawWireCube(transform.position, new Vector3(bounds.x, bounds.y, 0f));

        Gizmos.color = Color.yellow;
        Gizmos.DrawLine(
            transform.position + Vector3.up * (gameOverHeight - bounds.y * 0.5f) - Vector3.right * bounds.x * 0.5f,
            transform.position + Vector3.up * (gameOverHeight - bounds.y * 0.5f) + Vector3.right * bounds.x * 0.5f);
    }
}
