using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Font_Fix : MonoBehaviour {

    [SerializeField]
    private Font[] fonts;

	// Use this for initialization
	void Start () {
        foreach (Font font in fonts)
        {
            font.material.mainTexture.filterMode = FilterMode.Point;
        }
		
	}

}
