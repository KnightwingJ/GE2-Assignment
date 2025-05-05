# GE2-Assignment
Games Engines 2 Assignment. Dog Park
# Introduction
This project emulates a dog park. It features 5 instances of a dog character scene that contains the behavious script. When the program first begins each dogs behaviour is set to wander, this means that they will wander around the scene. The player has three options to change their behaviours using the keyboard.
### P - Whistle
This will emit a whistle sound that then changes the behaviour to Arrive, prompting the dogs to move toward the player's position and stop just before them. If this button is pressed again, the dogs return to their wandering behaviour
### O - Go
This button will change the dog's behaviour to path following, which will cause the dogs to follow the path that has been created. As this is complete path the dogs will continue to follow it until their behaviour is changed.
### T - Fetch
This will throw a ball from the player's position forward, once it has stopped moving, the dogs will begin to seek the position of the ball. Once one of the dogs has got the ball, the dogs will return to wandering.
<b/>An avoidance behaviour has also been implemented to ensure the dogs do not collide with each other or other collision objects, such as the trees and walls arround the area.
<b/><b/>

