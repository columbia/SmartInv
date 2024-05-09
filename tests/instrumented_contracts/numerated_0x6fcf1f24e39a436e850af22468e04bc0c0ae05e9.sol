1 pragma solidity >0.5.13;
2 
3 contract FronrunGame {
4     address public owner;
5 
6     uint public index = 0;
7 
8     mapping(address => uint) public successfulCallCount;
9     mapping(address => uint) public unsuccessfulCallCount;
10 
11     address player1;
12     address player2;
13 
14     modifier onlyOwner() {
15         require(owner == msg.sender, "Only the owner is allowed.");
16         _;
17     }
18 
19     constructor () public {
20         owner = msg.sender;
21     }
22 
23     function resetGame(address _player1, address _player2) onlyOwner public {
24         successfulCallCount[_player1] = 0;
25         successfulCallCount[_player2] = 0;
26 
27         unsuccessfulCallCount[_player1] = 0;
28         unsuccessfulCallCount[_player2] = 0;
29 
30         index = 0;
31     }
32 
33     function callMe(uint _index) public {
34         bool first = false;
35 
36         if (_index == index) {
37             successfulCallCount[msg.sender]++;
38             index++;
39             first = true;
40         } else {
41             unsuccessfulCallCount[msg.sender]++;
42         }
43 
44         emit NextIndex(index);
45         emit First(first);
46     }
47 
48     function showStats(address _player) public view returns (uint, uint, uint) {
49         return (
50             successfulCallCount[_player],
51             unsuccessfulCallCount[_player],
52             index
53         );
54     }
55 
56     event NextIndex(uint index);
57     event First(bool first);
58 }