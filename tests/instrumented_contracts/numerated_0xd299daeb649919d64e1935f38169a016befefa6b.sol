1 pragma solidity ^0.4.7;
2 
3 contract bet_various_v2{
4     enum State { Started, Locked }
5   State public state = State.Started;
6   struct Guess{
7     address addr;
8     uint    guess;
9   }
10   uint arraysize=1000;
11   uint constant maxguess=1000000;
12   uint bettingprice = 0.01 ether;
13   uint statusprice = 0.01 ether;
14   Guess[1000] guesses;
15   uint    numguesses = 0;
16   bytes32 curhash = '';
17   
18   uint stasticsarrayitems = 20;
19   uint[20] statistics;
20 
21   uint _gameindex = 1;
22   
23   struct Winner{
24     address addr;
25   }
26   Winner[1000] winnners;
27   uint    numwinners = 0;
28 
29   modifier inState(State _state) {
30       require(state == _state);
31       _;
32   }
33  
34   address developer = 0x0;
35   event SentPrizeToWinner(address winner, uint money, uint guess, uint gameindex, uint lotterynumber, uint timestamp);
36   event SentDeveloperFee(uint amount, uint balance);
37 
38   function bet_various_v2() 
39   {
40     if(developer==address(0)){
41       developer = msg.sender;
42     }
43   }
44 
45   function setBettingCondition(uint _contenders, uint _bettingprice)
46   {
47     if(msg.sender != developer)
48       return;
49   	arraysize  = _contenders;
50   	if(arraysize>1000)
51   	  arraysize = 1000;
52   	bettingprice = _bettingprice;
53   }
54   
55   function getMaxContenders() constant returns(uint){
56   	return arraysize;
57   }
58 
59   function getBettingPrice() constant returns(uint){
60   	return bettingprice;
61   }
62     
63   function findWinners(uint value) returns (uint)
64   {
65     numwinners = 0;
66     uint lastdiff = maxguess;
67     uint i = 0;
68     int diff = 0;
69     uint guess = 0;
70     for (i = 0; i < numguesses; i++) {
71       diff = (int)((int)(value)-(int)(guesses[i].guess));
72       if(diff<0)
73         diff = diff*-1;
74       if(lastdiff>(uint)(diff)){
75         guess = guesses[i].guess;
76         lastdiff = (uint)(diff);
77       }
78     }
79     
80     for (i = 0; i < numguesses; i++) {
81       diff = (int)((int)(value)-(int)(guesses[i].guess));
82       if(diff<0)
83         diff = diff*-1;
84       if(lastdiff==uint(diff)){
85         winnners[numwinners++].addr = guesses[i].addr;
86       }
87     }
88     return guess;
89   }
90   
91   function getDeveloperAddress() constant returns(address)
92   {
93     return developer;
94   }
95   
96   function getDeveloperFee() constant returns(uint)
97   {
98     uint developerfee = this.balance/100;
99     return developerfee;
100   }
101   
102   function getBalance() constant returns(uint)
103   {
104      return this.balance;
105   }
106   
107   function getLotteryMoney() constant returns(uint)
108   {
109     uint developerfee = getDeveloperFee();
110     uint prize = (this.balance - developerfee)/(numwinners<1?1:numwinners);
111     return prize;
112   }
113 
114   function getBettingStastics() 
115     payable
116     returns(uint[20])
117   {
118     require(msg.value == statusprice); // 0.01 eth
119     return statistics;
120   }
121   
122   function getBettingStatus()
123     constant
124     returns (uint, uint, uint, uint, uint)
125   {
126     return ((uint)(state), numguesses, getLotteryMoney(), this.balance, bettingprice);
127   }
128   
129   function setStatusPrice(uint value)
130   {
131       if(msg.sender != developer)
132         return;
133       statusprice = value;
134   }
135   function finish()
136   {
137     if(msg.sender != developer)
138       return;
139     _finish();
140   }
141   
142   function _finish() private
143   {
144     state = State.Locked;
145 
146     uint lotterynumber = (uint(curhash)+block.timestamp)%(maxguess+1);
147     // now that we know the random number was safely generate, let's do something with the random number..
148     var guess = findWinners(lotterynumber);
149     uint prize = getLotteryMoney();
150     uint remain = this.balance - (prize*numwinners);
151     for (uint i = 0; i < numwinners; i++) {
152       address winner = winnners[i].addr;
153       winner.transfer(prize);
154       SentPrizeToWinner(winner, prize, guess, _gameindex, lotterynumber, block.timestamp);
155     }
156     // give delveoper the money left behind
157     SentDeveloperFee(remain, this.balance);
158     developer.transfer(remain); 
159     
160     numguesses = 0;
161     for (i = 0; i < stasticsarrayitems; i++) {
162       statistics[i] = 0;
163     }
164     _gameindex++;
165     state = State.Started;
166   }
167 
168   function addguess(uint guess) 
169     inState(State.Started)
170     payable
171   {
172     require(msg.value == bettingprice);
173     
174     uint divideby = maxguess/stasticsarrayitems;
175     curhash = sha256(block.timestamp, block.coinbase, block.difficulty, curhash);
176     if((uint)(numguesses+1)<=arraysize) {
177       guesses[numguesses++] = Guess(msg.sender, guess);
178       uint statindex = guess / divideby;
179       if(statindex>=stasticsarrayitems) statindex = stasticsarrayitems-1;
180       statistics[statindex] ++;
181       if((uint)(numguesses)>=arraysize){
182         _finish();
183       }
184     }
185   }
186 }