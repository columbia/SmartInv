1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title GuessNumber
5  * @dev My first smart contract! GuessNumber contract starts with a random,
6  * hashed number that the player can try to guess. If the guess is correct,
7  * they receive the balance of the contract as a reward (including their bet).
8  * If they guess incorrectly, the contract keeps the player's bet amount. Have fun!
9  */
10 contract GuessNumber {
11   // creates random number between 1 - 10 on contract creation
12   uint256 private randomNumber = uint256( keccak256(now) ) % 10 + 1;
13   uint256 public lastPlayed;
14   uint256 public minBet = 0.1 ether;
15   address owner;
16 
17   struct GuessHistory {
18     address player;
19     uint256 number;
20   }
21 
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26   
27   function GuessNumber() public {
28     owner = msg.sender;
29   }
30 
31   // 0.1 ether is a pretty good bet amount but if price changes, this will be useful
32   function changeMinBet(uint256 _newMinBet) external onlyOwner {
33     minBet = _newMinBet;
34   }
35 
36   function guessNumber(uint256 _number) public payable {
37     require(msg.value >= minBet && _number <= 10);
38 
39     GuessHistory guessHistory;
40     guessHistory.player = msg.sender;
41     guessHistory.number = _number;
42 
43     // if player guesses correctly, transfer contract balance
44     // else the player's bet is automatically added to the reward / contract balance
45     if (_number == randomNumber) {
46       msg.sender.transfer(this.balance);
47     }
48 
49     lastPlayed = now;
50   }
51 
52   function kill() public onlyOwner {
53     selfdestruct(owner);
54   }
55 
56   function() public payable { }
57 
58 }