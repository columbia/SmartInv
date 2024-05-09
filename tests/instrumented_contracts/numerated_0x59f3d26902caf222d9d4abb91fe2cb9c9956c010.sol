1 pragma solidity ^0.4.24;
2 
3 contract QuizQuest {
4     bytes32 private answerHash;
5     bool private isActive;
6     Guess[] public PreviousGuesses;
7     string public Riddle;
8     string public Answer;
9 
10     struct Guess { address player; string guess; }
11     address private riddler;
12 
13     function () payable public {}
14     
15     function Quiz(string _riddle, string _answer) public payable {
16         if (riddler == 0x0) {
17             riddler = msg.sender;
18             Riddle = _riddle;
19             answerHash = keccak256(_answer);
20             isActive = true;
21         }
22     }
23 
24     function Play(string guess) public payable {
25         require(isActive && msg.value >= 0.5 ether);
26         if (bytes(guess).length == 0) return;
27         
28         Guess newGuess;
29         newGuess.player = msg.sender;
30         newGuess.guess = guess;
31         PreviousGuesses.push(newGuess);
32         
33         if (keccak256(guess) == answerHash) {
34             Answer = guess;
35             isActive = false;
36             msg.sender.transfer(this.balance);
37         }
38     }
39     
40     function End(string _answer) public {
41         require(msg.sender == riddler);
42         Answer = _answer;
43         isActive = false;
44         msg.sender.transfer(this.balance);
45     }
46 }