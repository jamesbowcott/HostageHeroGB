using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Obstacle_Spawner : MonoBehaviour {

    [SerializeField]
    private GameObject boxPrefab;

    private GameObject[] boxPool;

    [SerializeField]
    private float movementSpeed;

    private int spawnCounter;

    [SerializeField]
    private float respawnTimeMax;
    private float respawnTime;
    private float respawnTimeMin;


	// Use this for initialization
	void Start () {

        respawnTimeMin = 2.0f;

        boxPool = new GameObject[5];
        for (int i = 0; i < boxPool.Length; i++)
        {
            boxPool[i] = Instantiate(boxPrefab);
            boxPool[i].SetActive(false);
        }
		
	}
	
	// Update is called once per frame
	void Update () {

        if (respawnTime > 0.0f)
        {
            respawnTime -= Time.deltaTime;
        }
        else
        {
            respawnTime = Random.Range(respawnTimeMin, respawnTimeMax);
            SpawnObstacle();
        }
		
	}

    void SpawnObstacle()
    {
        for (int i = 0; i < boxPool.Length; i++)
        {
            if (!boxPool[i].activeInHierarchy)
            {
                boxPool[i].transform.position = transform.position;
                boxPool[i].GetComponent<Obstacle_Movement>().SetMovementSpeed(movementSpeed);
                boxPool[i].SetActive(true);
                break;
            }
        }

        spawnCounter++;
        if (spawnCounter % 5 == 0)
        {
            print("increase!");
            if (Time.timeScale < 7.0f) IncreaseTimeScale(0.5f);
        }
    }

    void IncreaseMovementSpeed(float amount)
    {
        movementSpeed += amount;

        for (int i = 0; i < boxPool.Length; i++)
        {
            if (boxPool[i].activeInHierarchy)
            {
                boxPool[i].GetComponent<Obstacle_Movement>().SetMovementSpeed(movementSpeed);
            }
        }

    }

    void IncreaseTimeScale(float amount)
    {
        Time.timeScale += amount;
    }
}
