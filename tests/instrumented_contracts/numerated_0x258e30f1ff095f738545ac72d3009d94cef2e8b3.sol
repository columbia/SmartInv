1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
6     if (_a == 0) {
7       return 0;
8     }
9 
10     c = _a * _b;
11     assert(c / _a == _b);
12     return c;
13   }
14 
15   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
16     return _a / _b;
17   }
18 
19   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
20     assert(_b <= _a);
21     return _a - _b;
22   }
23 
24   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
25     c = _a + _b;
26     assert(c >= _a);
27     return c;
28   }
29 }
30 
31 
32 contract Lottery{
33     using SafeMath for uint256;
34 
35     address public lastWinner;
36     address public owner;
37     uint256 public jackpot;
38     uint256 public MaxPlayers;
39     uint256 public completedGames;
40     address[] public players;
41     
42     constructor() public {
43          owner = msg.sender;
44          MaxPlayers = 10;
45     }
46 
47     function UpdateNumPlayers (uint256 num) public {
48         if (owner != msg.sender || num < 3 || num >= 1000) revert();
49         MaxPlayers = num;
50     }
51     
52      function () payable public  {
53         if(msg.value < .01 ether) revert();
54         players.push(msg.sender);
55         jackpot += msg.value;
56         if (players.length >= MaxPlayers) RandomWinner();
57     }
58 
59     function getPlayers() public view returns(address[]) {
60         return players;
61     }
62     
63     function random() private view returns (uint){
64         return uint(keccak256(abi.encodePacked(block.difficulty, now, msg.sender, players)));
65     }
66 
67     function RandomWinner()  private {
68         if (players.length < MaxPlayers) revert();
69         uint256 fee = SafeMath.div(address(this).balance, 100);
70         lastWinner = players[random() % players.length];
71         
72         lastWinner.transfer(address(this).balance - fee);
73         owner.transfer(fee);
74         delete players;
75         jackpot = 0;
76         
77         completedGames++;
78     }
79 
80 }