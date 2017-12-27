using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SphereBehaviour : MonoBehaviour {

	Rigidbody _rb;
	// Use this for initialization
	void Start () {
		_rb = GetComponent<Rigidbody> ();
		_rb.AddForce (new Vector3(0, 0, 2000));
	}
	
	// Update is called once per frame
	void FixedUpdate () {
		
	}
}
