1 pragma solidity ^0.4.24;
2 //
3 // Answer the riddle and win the jackpot
4 // To play, call the play() method with your guess and 0.25 ether
5 //
6 // Hint: Check the previous guesses to avoid wrong answers
7 //
8 contract Riddle {
9     bytes32 private answerHash;
10     bool private isActive;
11     Guess[] public guesses;
12     string public riddle;
13     string public answer;
14 
15     struct Guess { address player; string guess; }
16     address private riddler;
17 
18     function () payable public {}
19     
20     constructor (string _riddle, bytes32 _answerHash) public payable {
21         riddler = msg.sender;
22         riddle = _riddle;
23         answerHash = _answerHash;
24         isActive = true;
25     }
26 
27     function play(string guess) public payable {
28         require(isActive);
29         require(msg.value >= 0.25 ether);
30         require(bytes(guess).length > 0);
31         
32         Guess newGuess;
33         newGuess.player = msg.sender;
34         newGuess.guess = guess;
35         guesses.push(newGuess);
36         
37         if (keccak256(guess) == answerHash) {
38             answer = guess;
39             isActive = false;
40             msg.sender.transfer(this.balance);
41         }
42     }
43     
44     function end(string _answer) public {
45         require(msg.sender == riddler);
46         answer = _answer;
47         isActive = false;
48         msg.sender.transfer(this.balance);
49     }
50 }