using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : MonoBehaviour {

    [SerializeField]
    private float bulletSpeed;

    [SerializeField]
    private Player_Score playerScore;

	// Use this for initialization
	void Start () {
        playerScore = GameObject.FindGameObjectWithTag("Player").GetComponent<Player_Score>();
	}
	
	// Update is called once per frame
	void Update () {
        transform.Translate(Vector3.right * bulletSpeed * Time.deltaTime);

        if (transform.position.x >= 90.0f)
        {
            gameObject.SetActive(false);
        }

    }

    private void OnCollisionEnter2D(Collision2D collision)
    {

        if (collision.gameObject.CompareTag("Enemy"))
        {
            collision.gameObject.SetActive(false);
            gameObject.SetActive(false);
            playerScore.IncreaseScore(20);
        }
    }
}
