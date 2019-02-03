using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Obstacle_Spawner : MonoBehaviour {

    [SerializeField]
    private GameObject boxPrefab;
    [SerializeField]
    private GameObject enemyPrefab;

    private GameObject[] boxPool;
    private GameObject[] enemyPool;

    private List<GameObject[]> obstaclePools;

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
        enemyPool = new GameObject[5];

        obstaclePools = new List<GameObject[]>();
        obstaclePools.Add(boxPool);
        obstaclePools.Add(enemyPool);

        for (int i = 0; i < boxPool.Length; i++)
        {
            boxPool[i] = Instantiate(boxPrefab);
            boxPool[i].SetActive(false);
            boxPool[i].transform.parent = transform;

            enemyPool[i] = Instantiate(enemyPrefab);
            enemyPool[i].SetActive(false);
            enemyPool[i].transform.parent = transform;
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

        var pool = obstaclePools[Random.Range(0, obstaclePools.Count)];

        for (int i = 0; i < pool.Length; i++)
        {
            if (!pool[i].activeInHierarchy)
            {
                pool[i].transform.position = transform.position;
                pool[i].GetComponent<Obstacle_Movement>().SetMovementSpeed(movementSpeed);
                pool[i].SetActive(true);
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

    void IncreaseTimeScale(float amount)
    {
        Time.timeScale += amount;
    }
}
