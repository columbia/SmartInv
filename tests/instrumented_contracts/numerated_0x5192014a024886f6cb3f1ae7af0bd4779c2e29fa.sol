1 pragma solidity ^0.4.21;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 contract MMaker is owned {
21     
22     mapping (uint8 => address) players;
23     
24     
25     
26     function MMaker() public {
27         state = LotteryState.Accepting;
28     }
29     
30     uint8 number;
31     
32     enum LotteryState { Accepting, Finished }
33     
34     LotteryState state; 
35     uint8 public maxnumber  = 55;
36     uint public minAmount = 20000000000000000;
37     
38     
39     function enroll() public payable {
40         require(state == LotteryState.Accepting);
41         require(msg.value >= minAmount);
42         number += 1;
43         require(number<=maxnumber);
44         players[number] = (msg.sender);
45         if (number == maxnumber){
46             state = LotteryState.Finished;
47         }
48     }
49     
50     function setMaxNumber(uint8 newNumber) public onlyOwner {
51         maxnumber = newNumber;
52     }
53     
54     function setMinAmount(uint newAmount) public onlyOwner {
55         minAmount = newAmount;
56     }
57 
58     function lastPlayer() public view returns (uint8 _number, address _Player){
59         _Player = players[number];
60         _number = number;
61     }
62     
63     function determineWinner() public onlyOwner {
64         
65         
66         uint8 winningNumber = randomtest();
67         
68         distributeFunds(winningNumber);
69     }
70     function startOver() public onlyOwner{
71       
72       for (uint8 i=1; i<number; i++){
73         delete (players[i]);
74         }
75         number = 0;
76         state = LotteryState.Accepting;
77         
78     }
79     
80     function distributeFunds(uint8 winningNumber) private {
81         owner.transfer(this.balance/10);
82         players[winningNumber].transfer(this.balance);
83     
84     }
85     
86     
87     function randomtest() internal returns(uint8){
88         uint8 inter =  uint8(uint256(keccak256(block.timestamp))%number);
89         //return inter;
90         return uint8(uint256(keccak256(players[inter]))%number);
91     }
92     
93     
94 }