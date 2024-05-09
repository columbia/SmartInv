1 pragma solidity ^0.4.11;
2 contract simplelottery {
3     enum State { Started, Locked }
4     State public state = State.Started;
5     struct Guess{
6       address addr;
7       //uint    guess;
8     }
9     uint arraysize=1000;
10     uint constant maxguess=1000000;
11     uint bettingprice = 1 ether;
12     Guess[1000] guesses;
13     uint    numguesses = 0;
14     bytes32 curhash = '';
15     uint _gameindex = 1;
16     uint _starttime = 0;
17     modifier inState(State _state) {
18       require(state == _state);
19       _;
20     }
21     address developer = 0x0;
22     address _winner   = 0x0;
23     event SentPrizeToWinner(address winner, uint money, uint gameindex, uint lotterynumber, uint starttime, uint finishtime);
24     event SentDeveloperFee(uint amount, uint balance);
25     
26     function simplelottery() 
27     {
28       if(developer==address(0)){
29         developer = msg.sender;
30         state = State.Started;
31         _starttime = block.timestamp;
32       }
33     }
34     
35     function setBettingCondition(uint _contenders, uint _bettingprice)
36     {
37       if(msg.sender != developer)
38         return;
39       arraysize  = _contenders;
40       if(arraysize>1000)
41         arraysize = 1000;
42       bettingprice = _bettingprice;
43     }
44     
45     function findWinner(uint value)
46     {
47       uint i = value % numguesses;
48       _winner = guesses[i].addr;
49     }
50     
51       function getMaxContenders() constant returns(uint){
52       return arraysize;
53     }
54 
55     function getBettingPrice() constant returns(uint){
56       return bettingprice;
57     }
58 
59     function getDeveloperAddress() constant returns(address)
60     {
61       return developer;
62     }
63     
64     function getDeveloperFee() constant returns(uint)
65     {
66       uint developerfee = this.balance/100;
67       return developerfee;
68     }
69     
70     function getBalance() constant returns(uint)
71     {
72        return this.balance;
73     }
74     
75     function getLotteryMoney() constant returns(uint)
76     {
77       uint developerfee = getDeveloperFee();
78       uint prize = (this.balance - developerfee);
79       return prize;
80     }
81 
82     function getBettingStatus()
83       constant
84       returns (uint, uint, uint, uint, uint, uint, uint)
85     {
86       return ((uint)(state), _gameindex, _starttime, numguesses, getLotteryMoney(), this.balance, bettingprice);
87     }
88 
89 
90 
91     function finish()
92     {
93       if(msg.sender != developer)
94         return;
95       _finish();
96     }
97     
98     function _finish() private
99     {
100       state = State.Locked;
101       uint block_timestamp = block.timestamp;
102       uint lotterynumber = (uint(curhash)+block_timestamp)%(maxguess+1);
103       findWinner(lotterynumber);
104       uint prize = getLotteryMoney();
105       uint numwinners = 1;
106       uint remain = this.balance - (prize*numwinners);
107 
108       _winner.transfer(prize);
109       SentPrizeToWinner(_winner, prize, _gameindex, lotterynumber, _starttime, block_timestamp);
110 
111       // give delveoper the money left behind
112       developer.transfer(remain); 
113       SentDeveloperFee(remain, this.balance);
114       numguesses = 0;
115       _gameindex++;
116       state = State.Started;
117       _starttime = block.timestamp;
118     }
119     
120     function () payable
121     {
122         _addguess();
123     }
124 
125     function addguess() 
126       inState(State.Started)
127       payable
128     {
129       _addguess();
130     }
131     
132     function _addguess() private
133       inState(State.Started)
134     {
135       require(msg.value >= bettingprice);
136       curhash = sha256(block.timestamp, block.coinbase, block.difficulty, curhash);
137       if((uint)(numguesses+1)<=arraysize) {
138         guesses[numguesses++].addr = msg.sender;
139         if((uint)(numguesses)>=arraysize){
140           _finish();
141         }
142       }
143     }
144 }