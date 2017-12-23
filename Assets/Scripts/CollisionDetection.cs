using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollisionDetection : MonoBehaviour {

	Renderer _r;

	[SerializeField]
	float _waveAmplitude = 1.0f;

	[SerializeField]
	float _waveAmplitudeModifier = 0.005f;

	[SerializeField]
	float _waveSpread = 1.0f;

	[SerializeField]
	float _attenuationDamper = 2.0f;

	float _waveDistance = 1.0f;

	float _startTime;

	Coroutine _coroutine;

	// Use this for initialization
	void Start () {
		_r = GetComponent<Renderer> ();
	}

	void OnCollisionEnter(Collision other) {
		if (other.rigidbody) {
			_waveAmplitude = Mathf.Clamp01(other.rigidbody.velocity.magnitude * _waveAmplitudeModifier);

			_r.sharedMaterial.SetFloat ("_OffsetX", other.transform.position.x);
			_r.sharedMaterial.SetFloat ("_OffsetZ", other.transform.position.z);

			if (_coroutine != null) {
				StopCoroutine (_coroutine);
				_coroutine = null;
			}
			_coroutine = StartCoroutine (WaveAttenuate ());
		}
	}

	IEnumerator WaveAttenuate () {
		float passedTime = 0.0f;

		_startTime = Time.time;
		while(_waveAmplitude > 0.0f) {
			passedTime = (Time.time - _startTime) / _attenuationDamper;
			_waveAmplitude = Mathf.Lerp (1.0f, 0.0f, passedTime);
			_waveDistance = Mathf.Lerp (0.0f, 200.0f, passedTime);

			_r.sharedMaterial.SetFloat ("_Amplitude", _waveAmplitude);
			_r.sharedMaterial.SetFloat ("_WaveTravelDistance", _waveDistance);
			yield return null;
		}
	}
}
