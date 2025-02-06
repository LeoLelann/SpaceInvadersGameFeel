using UnityEngine;

public class PupilFollow : MonoBehaviour
{
    public Transform player;
    public float maxDistance = 0.2f;

    private Vector3 initialPosition;

    void Start()
    {
        initialPosition = transform.localPosition;
    }

    void Update()
    {
        Vector3 direction = (player.position - transform.position).normalized;
        Vector3 newPosition = initialPosition + player.position * maxDistance/*(direction * maxDistance)*/;
        transform.localPosition = newPosition;
    }
}