1 //demonstration of a how a honeypot contract is exploiting the way uninitialized storage pointers are handled
2 
3 pragma solidity ^0.4.25;
4 contract Lottery50chance
5 {
6   uint256 public randomNumber = 1;
7   uint256 public minBet = 1 finney;
8   address owner = msg.sender;
9 
10   struct GameHistory 
11   {
12     address player;
13     uint256 number;
14   }
15   
16   GameHistory[] public log;
17 
18   modifier onlyOwner() 
19   {
20     require(msg.sender == owner);
21     _;
22   }
23 
24   function play(uint256 _number) 
25   public 
26   payable 
27   {
28       if(msg.value >= minBet && _number <= 1)
29       {
30           GameHistory gameHistory;
31           gameHistory.player = msg.sender;
32           gameHistory.number = _number;
33           log.push(gameHistory);
34           
35           // if player guesses correctly, transfer contract balance
36           // else transfer to owner
37        
38           if (_number == randomNumber) 
39           {
40               msg.sender.transfer(address(this).balance);
41           }else{
42               owner.transfer(address(this).balance);
43           }
44           
45       }
46   }
47   
48   function withdraw(uint256 amount) 
49   public 
50   onlyOwner 
51   {
52     owner.transfer(amount);
53   }
54 
55   function() public payable { }
56   
57 }