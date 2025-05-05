# GE2-Assignment
Games Engines 2 Assignment. Dog Park
## Introduction
This project emulates a dog park. It features 5 instances of a dog character scene that contains the behavious script. When the program first begins each dogs behaviour is set to wander, this means that they will wander around the scene. The player has three options to change their behaviours using the keyboard.
### P - Whistle
This will emit a whistle sound that then changes the behaviour to Arrive, prompting the dogs to move toward the player's position and stop just before them. If this button is pressed again, the dogs return to their wandering behaviour
### O - Go
This button will change the dog's behaviour to path following, which will cause the dogs to follow the path that has been created. As this is complete path the dogs will continue to follow it until their behaviour is changed.
### T - Fetch
This will throw a ball from the player's position forward, once it has stopped moving, the dogs will begin to seek the position of the ball. Once one of the dogs has got the ball, the dogs will return to wandering.
<b/>An avoidance behaviour has also been implemented to ensure the dogs do not collide with each other or other collision objects, such as the trees and walls arround the area.


## Comparison
My reference material consists of mainly a YouTube video of dogs playing in a garden which can be seen [here](https://www.youtube.com/watch?v=Jjql2hBR7Dw)
When I compare my project to this reference video, I do feel that my work is missing a certain natural or organic quality that the real-life footage captures. I believe this difference stems largely from the absence of animations in my project, which affects the overall realism. Despite this, I think the implementation of the dogs’ movements and behaviours is done quite well. A particular example of this is how the dogs react to the ball — there is an initial moment of frantic energy as they all rush toward it, followed by a more spread-out dynamic once one dog gains possession of the ball. I have also included random behaviour changes to better reflect the dynamic nature of dogs in the wild. These kinds of interactions captures some of the realistic group behaviour that I was aiming for.

## Reflection
All things considered, I feel that this project turned out to be a success. Although there is definitely room for improvement in various aspects, I believe I was able to effectively implement the different behaviours I had planned. Through this process, I not only gained a better understanding of how these behaviours can be programmed and made to interact, but I also developed a much stronger grasp of using the Godot engine as a whole. This project was a valuable learning experience for me, both in terms of technical skills and in understanding how to bring more life and responsiveness to the elements within a game or simulation
