# DragToSpeak


<video controls="controls" playsinline="playsinline" src="https://willwa.de/uploads/2024/edited-dragtospeak.mp4" width="600" height="337" poster="https://willwa.de/uploads/2024/c0364ceed9.png" preload="none"></video>
 
## Introduction

DragToSpeak is a SwiftUI-based application designed to assist individuals, particularly those with complex disabilities, communicate through a letter selection interface. The app features a drag-to-select mechanism for letter selection and integrates Apple's word prediction engine to correct errors and enhance communication efficiency.

## Features

- **Two methods for selecting**: Users can select letters by dragging their finger or a pointer across the screen. To detect letters, we have a change in the angle of drag mode (pros: should work for fast dragging but have problems with double letters) or a dwell mode (pros: fewer errors - set your dwell time to something like 0.5)
- **Speech output** using inbuilt TTS in iOS (Settings -> Accessibility -> Spoken Content )


## Why not?

- **Keyguards or Touchguides**? These are perfect for a lot of people, but for some, lifting their finger and getting used to this is just too much to get used to. 
- **Swype, SwiftKey and others (eg Gboard)?** Try these, and typically, you have to lift your finger to select the predicted word, and errors have to be corrected with taps. Also, these are hard to make fullscreen and adapt the layout to reduce learning for a user coming from a paper-based system
- **Dasher?** Dasher is a continuous gesture system, and it's super efficient. But - it can be hard to learn


## Authors

- Written by [@willwade](https://www.github.com/willwade) with OpenAI ChatGPT v4 Aug 3rd, 2023 build https://help.openai.com/en/articles/6825453-chatgpt-release-notes
- Adapted and improved by [@gavinhenderson](https://github.com/gavinhenderson)

