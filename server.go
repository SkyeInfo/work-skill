package main

import (
	"bytes"
	"fmt"
	"os/exec"
	"regexp"
	"strconv"
)

func getTheMuteTime(url string) (muteTime float64, integratedLoudness float64, err error) {
	cmdArguments := []string{"-i", url, "-filter_complex", "ebur128", "-c:v", "copy", "-f", "null", "/dev/null"}
	command := exec.Command("ffmpeg", cmdArguments...)
	var out bytes.Buffer
	var errOut bytes.Buffer
	command.Stdout = &out
	command.Stderr = &errOut

	err = command.Start()

	if err != nil {
		fmt.Println(err)
	}

	if err = command.Wait(); err != nil {
		fmt.Println(err.Error())
	}

	result := errOut.String()

	reg1 := regexp.MustCompile(`t:[\s]*(\d+[\.\d+]*)\s+TARGET:(-\d+)\sLUFS\s+M:([-\s]*\d+\.\d)\s+S:([-\s]*\d+\.\d)\s+I:\s+([-\s]*\d+\.\d)\sLUFS\s+LRA:\s+(\d+\.\d)\sLU`)
	if reg1 == nil { //解释失败，返回nil
		fmt.Println("regexp err")
		return
	}

	result1 := reg1.FindAllStringSubmatch(result, -1)

	// fmt.Println("result1 = ", result1)

	if len(result1) == 0 {
		fmt.Println("result1 is empty")
		return
	}

	for _, v := range result1 {
		time, _ := strconv.ParseFloat(v[1], 10)
		volume, _ := strconv.ParseFloat(v[5], 10)

		//fmt.Println(time, volume)

		if volume > -70.0 {
			muteTime = time
			break
		}
	}

	reg2 := regexp.MustCompile(`\s+I:\s+([-+\s]\d+\.\d) LUFS`)
	if reg2 == nil { //解释失败，返回nil
		fmt.Println("regexp err")
		return
	}

	result2 := reg2.FindAllStringSubmatch(result, -1)

	loudness := result2[len(result2)-1][1]

	integratedLoudness, _ = strconv.ParseFloat(loudness, 10)
	return muteTime, integratedLoudness, nil
}

func main() {
	url := "https://videosy.soyoung.com/1895da515fc028ad6524a399894f2ab8_6362fcb7.mp4"
	muteTime, integratedLoudness, err := getTheMuteTime(url)
	fmt.Println(muteTime)
	fmt.Println(integratedLoudness)
	fmt.Println(err)
}
