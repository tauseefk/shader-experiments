using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.iOS;

public class iOSCameraController : MonoBehaviour {

	// Use this for initialization
	void Start () {
//		transform.LookAt (GameObject.FindGameObjectWithTag("Ball").transform);
//		GetComponent<Camera>().transform.position = new Vector3(0, 0, 0);
	}
	
	// Update is called once per frame
	void Update () {
		GyroModifyCamera();
	}

	void GyroModifyCamera()
	{
		transform.rotation = GyroToUnity(Input.gyro.attitude);
	}

	private static Quaternion GyroToUnity(Quaternion q)
	{
		return new Quaternion(q.x, q.y, -q.z, -q.w);
	}
}
