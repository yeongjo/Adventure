using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour {

	public Transform playerCameraTrans;
	public float amount = 0.1f;
	public float movementSpeed = 1;
	public float mouseLerpSpeed = 1;
	CharacterController cc;
	Vector3 viewRotation;
	// Use this for initialization
	void Start () {
		cc = GetComponent<CharacterController> ();
	}
	
	// Update is called once per frame
	void Update () {
		cc.SimpleMove (Input.GetAxis ("Horizontal")*movementSpeed*Time.deltaTime * transform.right+Input.GetAxis ("Vertical")*movementSpeed*Time.deltaTime*transform.forward);
		Vector3 mouseDelta = new Vector3(Input.GetAxis("Mouse Y")*Time.deltaTime*amount,Input.GetAxis ("Mouse X")*amount*Time.deltaTime,0);
		//playerCameraTrans.rotation = Quaternion.Lerp(playerCameraTrans.rotation,Quaternion.Euler(playerCameraTrans.eulerAngles+mouseDelta),Time.deltaTime*mouseLerpSpeed);
		playerCameraTrans.eulerAngles = new Vector3(Mathf.Clamp(Mathf.Lerp(playerCameraTrans.eulerAngles.x,playerCameraTrans.eulerAngles.x-mouseDelta.x,Time.deltaTime*mouseLerpSpeed),0,80),playerCameraTrans.eulerAngles.y,0);
		transform.eulerAngles = new Vector3 (0, Mathf.LerpAngle(transform.eulerAngles.y, transform.eulerAngles.y+mouseDelta.y*.6f, mouseLerpSpeed), 0);

	}
}
