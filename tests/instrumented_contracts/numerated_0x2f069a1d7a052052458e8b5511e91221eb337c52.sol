1 /**
2  * @title NumberLottery
3  * @dev NumberLottery contract starts with a random,
4  * hashed number that the player can try to guess. If the guess is correct,
5  * they receive the balance of the contract as a reward (including their bet).
6  * If they guess incorrectly, the contract keeps the player's bet amount. Have fun!
7  */
8  
9 pragma solidity ^0.4.19;
10 contract NumberLottery 
11 {
12   // creates random number between 1 - 10 on contract creation
13   uint256 private  randomNumber = uint256( keccak256(now) ) % 10 + 1;
14   uint256 public prizeFund;
15   uint256 public minBet = 0.1 ether;
16   address owner = msg.sender;
17 
18   struct GameHistory 
19   {
20     address player;
21     uint256 number;
22   }
23   
24   GameHistory[] public log;
25 
26   modifier onlyOwner() 
27   {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   // 0.1 ether is a pretty good bet amount but if price changes, this will be useful
33   function changeMinBet(uint256 _newMinBet) 
34   external 
35   onlyOwner 
36   {
37     minBet = _newMinBet;
38   }
39 
40   function StartGame(uint256 _number) 
41   public 
42   payable 
43   {
44       if(msg.value >= minBet && _number <= 10)
45       {
46           GameHistory gameHistory;
47           gameHistory.player = msg.sender;
48           gameHistory.number = _number;
49           log.push(gameHistory);
50           
51           // if player guesses correctly, transfer contract balance
52           // else the player's bet is automatically added to the reward / contract balance
53           if (_number == randomNumber) 
54           {
55               msg.sender.transfer(this.balance);
56           }
57           
58           randomNumber = uint256( keccak256(now) ) % 10 + 1;
59           prizeFund = this.balance;
60       }
61   }
62 
63   function withdaw(uint256 _am) 
64   public 
65   onlyOwner 
66   {
67     owner.transfer(_am);
68   }
69 
70   function() public payable { }
71 
72 }