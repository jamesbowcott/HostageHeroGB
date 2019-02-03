using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player_Shoot : MonoBehaviour {

    [SerializeField]
    private GameObject bulletPrefab;

    private GameObject[] bulletPool;

	// Use this for initialization
	void Start () {

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
                bulletPool[i].transform.position = transform.position;
                bulletPool[i].SetActive(true);
                break;
            }
        }
    }
}
