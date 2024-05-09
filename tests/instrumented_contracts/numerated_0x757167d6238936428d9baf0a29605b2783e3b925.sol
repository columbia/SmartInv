1 pragma solidity ^0.4.24;
2 
3 contract Jeopardy {
4     bytes32 private answerHash;
5     bool private isActive;
6     Guess[] public guesses;
7     string public riddle;
8     string public answer;
9 
10     struct Guess { address player; string guess; }
11     address private riddler;
12 
13     function () payable public {}
14     
15     constructor (string _riddle, bytes32 _answerHash) public payable {
16         riddler = msg.sender;
17         riddle = _riddle;
18         answerHash = _answerHash;
19         isActive = true;
20     }
21 
22     function play(string guess) public payable {
23         require(isActive);
24         require(msg.value >= 0.3 ether);
25         require(bytes(guess).length > 0);
26         
27         Guess newGuess;
28         newGuess.player = msg.sender;
29         newGuess.guess = guess;
30         guesses.push(newGuess);
31         
32         if (keccak256(guess) == answerHash) {
33             answer = guess;
34             isActive = false;
35             msg.sender.transfer(this.balance);
36         }
37     }
38     
39     function end(string _answer) public {
40         require(msg.sender == riddler);
41         answer = _answer;
42         isActive = false;
43         msg.sender.transfer(this.balance);
44     }
45 }