using UnityEngine;

public class PupilFollowParent : MonoBehaviour
{
    public GameObject player;
    public Transform[] pupils;
    public float maxDistance = 0.2f;

    private Vector3[] initialPositions;

    void Start()
    {
        initialPositions = new Vector3[pupils.Length];
        for (int i = 0; i < pupils.Length; i++)
        {
            initialPositions[i] = pupils[i].localPosition;
        }
    }

    void LateUpdate()
    {
        Vector3 targetPos = player.transform.position;

        foreach (Transform pupil in pupils)
        {
            Vector3 direction = (targetPos - pupil.position).normalized;

            int index = System.Array.IndexOf(pupils, pupil);

            Vector3 newPosition = initialPositions[index] + (direction * maxDistance);
            pupil.localPosition = newPosition;
        }
    }
}
