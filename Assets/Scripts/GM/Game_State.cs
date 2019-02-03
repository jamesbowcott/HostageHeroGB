using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Game_State : MonoBehaviour {

    private AudioSource audioSource;

    [Header("Game Over")]
    [SerializeField]
    private AudioClip gameOverSound;
    [SerializeField]
    private GameObject gameOverText;
    private bool gameOver;

    private void Start()
    {
        audioSource = GetComponent<AudioSource>();
    }

    private void Update()
    {
        if (gameOver)
        {
            if (Input.GetButton("Interact"))
            {
                SceneManager.LoadScene(1);
                Time.timeScale = 1.0f;
            }
        }
    }

    public void GameOver()
    {
        Time.timeScale = 0;
        audioSource.clip = gameOverSound;
        audioSource.Play();
        gameOverText.SetActive(true);
        gameOver = true;
    }
}
