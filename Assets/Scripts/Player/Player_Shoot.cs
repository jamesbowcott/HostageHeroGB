using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player_Shoot : MonoBehaviour {

    [SerializeField]
    private GameObject bulletPrefab;

    private GameObject[] bulletPool;

    [SerializeField]
    private AudioClip[] shootSounds;
    private AudioSource audioSource;

    // Use this for initialization
    void Start () {

        audioSource = GetComponent<AudioSource>();

        bulletPool = new GameObject[2];
        for (int i = 0; i < bulletPool.Length; i++)
        {
            bulletPool[i] = Instantiate(bulletPrefab);
            bulletPool[i].SetActive(false);
        }

    }
	
	// Update is called once per frame
	void Update () {
		
        if (Input.GetButtonDown("Fire"))
        {
            SpawnBullet();
        }


	}

    void SpawnBullet()
    {
        for (int i = 0; i < bulletPool.Length; i++)
        {
            if (!bulletPool[i].activeInHierarchy)
            {
                audioSource.clip = shootSounds[Random.Range(0, shootSounds.Length - 1)];
                audioSource.Play();
                bulletPool[i].transform.position = transform.position;
                bulletPool[i].SetActive(true);
                break;
            }
        }
    }
}
