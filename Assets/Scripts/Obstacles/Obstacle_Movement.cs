using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Obstacle_Movement : MonoBehaviour {

    [SerializeField]
    private float movementSpeed;
	
	// Update is called once per frame
	void Update () {

        transform.Translate(Vector3.left * movementSpeed * Time.deltaTime);

        if (transform.position.x <= -20.0f)
        {
            gameObject.SetActive(false);
        }
		
	}

    public void SetMovementSpeed(float speed)
    {
        movementSpeed = speed;
    }
}
