using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player_Controller : MonoBehaviour
{


    [SerializeField]
    private bool isJumping = false;

    [SerializeField]
    private float force = 20.0f;

    private Animator animator;
    [SerializeField]
    private float jumpDelay;

    [SerializeField]
    private GameObject GM;

    [SerializeField]
    private AudioClip[] jumpSounds;
    private AudioSource audioSource;

    // Use this for initialization
    void Start()
    {
        audioSource = GetComponent<AudioSource>();
        animator = gameObject.GetComponent<Animator>();
        jumpDelay = 0.0f;
    }

    // Update is called once per frame
    void Update()
    {

        if (Input.GetAxis("Jump") > 0 && !isJumping)
        {
            isJumping = true;
            Jump();
        }

        if (isJumping)
        {
            if (jumpDelay < 1.0f)
            {
                jumpDelay += Time.deltaTime;
            }
        }

    }

    void Jump()
    {
        animator.SetBool("isJumping", true);
        gameObject.GetComponent<Rigidbody2D>().AddForce(Vector2.up * force, ForceMode2D.Impulse);
        audioSource.clip = jumpSounds[Random.Range(0, jumpSounds.Length - 1)];
        audioSource.Play();
    }

    private void OnCollisionStay2D(Collision2D collision)
    {
        if (collision.gameObject.CompareTag("Floor"))
        {
            if (jumpDelay > 1.0f)
            {
                isJumping = false;
                animator.SetBool("isJumping", false);
                jumpDelay = 0.0f;
            }

        }
        else if (collision.gameObject.CompareTag("Box"))
        {
            GM.GetComponent<Game_State>().GameOver();
        }
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.CompareTag("Enemy"))
        {
            GM.GetComponent<Game_State>().GameOver();
        }
    }
}
