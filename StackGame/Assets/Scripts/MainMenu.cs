using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class MainMenu : MonoBehaviour {

    public Text scoreText;

	// Use this for initialization
	void Start () {
        scoreText.text = PlayerPrefs.GetInt("score").ToString();
	}

    public void ToGame() {

        SceneManager.LoadScene("GameScene");
    }

    void Update() {

        if (Input.GetKeyDown(KeyCode.Escape))
            Application.Quit();
    
    }
}
