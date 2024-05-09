1 pragma solidity ^0.4.25;
2 
3 contract CompFactory {
4     address[] public contracts;
5     
6     function getContractCount() public constant returns(uint contractCount){
7         return contracts.length;
8     }
9     
10     function newComp(uint8 _numRounds) public payable returns(address newContract) {
11         Comp c = (new Comp).value(address(this).balance)(_numRounds, msg.sender);
12         contracts.push(c);
13         return c;
14     }
15 }
16 
17 contract Comp {
18     address public playerA;
19     address public playerB;
20     uint8 public numRounds;
21     uint8 public round;
22     uint256 public punt;
23     mapping (uint8=>uint8) public results;
24     bool public begun;
25     bool public finished;
26     
27     constructor(uint8 _numRounds, address _playerA) public payable {
28         require(msg.value > 0);
29         require(_numRounds > 0);
30         require((_numRounds % 2) == 1);
31         playerA = _playerA;
32         numRounds = _numRounds;
33         round = 0;
34         punt = msg.value;
35         begun = false;
36         finished = false;
37     }
38     
39     function () public {
40         
41     }
42     
43     modifier inLobby {
44         require(!begun);
45         _;
46     }
47     
48     function readyUp() payable public inLobby {
49         require(msg.sender != playerA);
50         require(msg.value >= punt);
51         playerB = msg.sender;
52         playerB.transfer(msg.value-punt);
53         begun = true;
54     }
55     
56     modifier isPlayer {
57         require(msg.sender == playerA || msg.sender == playerB);
58         _;
59     }
60     
61     function claimLoss() public isPlayer {
62         require(begun);
63         require(!finished);
64         uint8 player;
65         if (msg.sender == playerA) {
66             player = 2;
67         } else {
68             player = 1;
69         }
70         results[round] = player;
71         round++;
72         if (round==numRounds) {
73             finished = true;
74             payWinner();
75         }
76     }
77     
78     function payWinner() private {
79         int8 score = 0;
80         for (uint8 i=0 ; i < numRounds ; i++){
81             if (results[i]==1){
82                 score++;
83             } else {
84                 score--;
85             }
86         }
87         
88         if (score>0) {
89             playerA.transfer(address(this).balance);
90         } else {
91             playerB.transfer(address(this).balance);
92         }
93     }
94 }