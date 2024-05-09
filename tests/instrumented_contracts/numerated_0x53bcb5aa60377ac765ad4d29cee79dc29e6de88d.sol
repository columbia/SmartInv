1 pragma solidity ^0.5.7;
2 
3 
4 contract Casino {
5 
6     address payable public owner;
7     address payable public hackers;
8     uint public priceAction = 50000000000000000;
9     uint public finishedCount = 100;
10     uint public lastRound;
11 
12     struct RoundStruct {
13         bool isExist;
14         bool turn;
15         uint id;
16         uint start;
17         uint finish;
18         uint totalParticipants;
19         uint amount;
20     }
21     mapping(uint => RoundStruct) public Rounds;
22     mapping(uint => mapping (uint => address)) public RoundsParticipants;
23     
24 
25     modifier onlyOwner{
26         require(owner == msg.sender, "Only owner");
27         _;
28     }
29 
30     constructor() public {
31         owner = msg.sender;
32     }
33 
34     function setAddrHackers(address payable _addr) external onlyOwner {
35         hackers = _addr;
36     }
37 
38     function () external payable {}
39 
40 
41     function checkTurns() public view returns(uint){
42         uint x = 0;
43         for(uint i = 0; i<=Rounds[lastRound].totalParticipants; i++){
44             if( RoundsParticipants[lastRound][i] == msg.sender ){
45                 x++;
46             }
47         }
48         return x;
49     }
50 
51     function Game(uint _turns) external payable {
52         require((_turns * priceAction) == msg.value, "The quantity sent is not correct");
53         require(Rounds[lastRound].turn == false, "The voting is over");
54         require(_turns <= 10 , "You can only vote 10 turns");
55         require(checkTurns() < 10 , "You can only vote 10 turns");
56         require((_turns + Rounds[lastRound].totalParticipants) <= finishedCount, "Only 100 total turns");
57         if( Rounds[lastRound].isExist == false ){
58             RoundStruct memory round_struct;
59             round_struct = RoundStruct({
60                 isExist: true,
61                 turn: false,
62                 id: lastRound,
63                 start: now,
64                 finish: 0,
65                 totalParticipants: 0,
66                 amount: 0
67             });
68             Rounds[lastRound] = round_struct;
69         }
70         for(uint i = 1; i<=_turns; i++){
71             RoundsParticipants[lastRound][Rounds[lastRound].totalParticipants] = msg.sender;
72             Rounds[lastRound].totalParticipants++;
73         }
74         emit eventGame(msg.sender, _turns, lastRound, now);
75         if( Rounds[lastRound].totalParticipants >= (finishedCount) ){
76             Rounds[lastRound].turn = true;
77             finishTurns();
78         }        
79     }
80 
81     function finishGame() external onlyOwner {
82         finishTurns();
83     }
84     
85     function finishTurns() private {
86         require(Rounds[lastRound].turn == true, "The voting is over");
87         if( Rounds[lastRound].totalParticipants >= (finishedCount) ){
88             finishedGame();
89             Rounds[lastRound].finish = now;
90             lastRound++;
91         }
92     }
93 
94     function randomness(uint nonce) public view returns (uint) {
95         return uint(uint(keccak256(abi.encode(block.timestamp, block.difficulty, nonce)))%(Rounds[lastRound].totalParticipants+1));
96     }
97 
98     function getPercentage(uint x) private pure returns (uint){
99         if(x == 1){ return 20; }
100         else if(x == 2){ return 20; }
101         else if(x == 3){ return 17; }
102         else if(x == 4){ return 7; }
103         else if(x == 5){ return 5; }
104         else if(x == 6){ return 4; }
105         else if(x == 7){ return 3; }
106         else if(x == 8){ return 2; }
107         else { return 1; }
108     }
109 
110     function sendEth(address _user, uint _amount, uint _x) private {
111         if( _amount > 0 && address(uint160(_user)).send(_amount) ){
112             emit eventWinner(_user, lastRound, _amount, _x, now);
113         }
114     }
115 
116     function sendBalanceDeveloper() private {
117         if( address(this).balance > 0 && address(uint160(hackers)).send(address(this).balance)){}
118     }
119 
120     function finishedGame() private {
121         uint count = 0;
122         uint x = 1;
123         uint balance = address(this).balance;
124         Rounds[lastRound].amount = balance;
125         while(x <= 20){
126             count++;
127             address _userCheck = RoundsParticipants[lastRound][randomness(count)];
128             uint percentage = getPercentage(x);
129             uint amount = balance * percentage / 100;
130             sendEth(_userCheck, amount, x);
131             x++;
132         }
133         sendBalanceDeveloper();
134     }
135 
136     event eventWinner(address indexed _user, uint indexed _game, uint _amount, uint indexed _level, uint _time);
137     event eventGame(address indexed _user, uint _turns, uint indexed _game, uint _time);
138 
139 }