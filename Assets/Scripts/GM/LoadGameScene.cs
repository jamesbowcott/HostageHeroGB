using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadGameScene : MonoBehaviour {

	void Update () {

        if (Input.GetButton("Interact"))
        {
            SceneManager.LoadScene(1);
        }
		
	}
}
