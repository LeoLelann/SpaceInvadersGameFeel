using UnityEngine;

public class LookAt : MonoBehaviour
{
    [SerializeField] GameObject player;
    void Update()
    {
        Vector3 Look = transform.InverseTransformPoint(player.transform.position);
        float angle = Mathf.Atan2(Look.y, Look.x) * Mathf.Rad2Deg + 90;
        
        transform.Rotate(0, 0, angle);

        Debug.Log(player.transform.position.x);

        //transform.LookAt(player.transform.position);
    }
}
