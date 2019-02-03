using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Player_Score : MonoBehaviour
{

    [SerializeField]
    private Text UIText;

    private int score;

    [SerializeField]
    private AudioClip[] scoreClips;

    private AudioSource audioSource;

    // Use this for initialization
    void Start()
    {
        audioSource = GetComponent<AudioSource>();
        score = 0;
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.CompareTag("Box"))
        {
            audioSource.clip = scoreClips[Random.Range(0, scoreClips.Length - 1)];
            audioSource.Play();
            IncreaseScore(10);
        }

    }

    public void IncreaseScore(int amount)
    {
        score += amount;
        UIText.text = score.ToString();
    }
}
