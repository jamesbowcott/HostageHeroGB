using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enemy_Jump : MonoBehaviour
{

    [SerializeField]
    [Tooltip("The latest time the enemy will jump after being alive")]
    private float maxJumpTime;

    private float timer;
    private float jumpTime;

    private bool hasJumped;

    private Animator animator;

    private float force = 20.0f;

    private void Start()
    {
        animator = GetComponent<Animator>();
    }

    private void OnEnable()
    {
        timer = 0.0f;
        jumpTime = Random.Range(0, maxJumpTime);
        hasJumped = false;
    }

    // Update is called once per frame
    void Update()
    {

        if (timer >= jumpTime && !hasJumped)
        {
            Jump();
        }
        else
        {
            timer += Time.deltaTime;
        }

    }

    private void Jump()
    {
        animator.SetBool("isJumping", true);
        gameObject.GetComponent<Rigidbody2D>().AddForce(Vector2.up * force, ForceMode2D.Impulse);
        hasJumped = true;
    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.CompareTag("Floor"))
        {
            animator.SetBool("isJumping", false);
        }
    }
}
