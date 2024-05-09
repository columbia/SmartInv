1 pragma solidity ^0.4.7;
2 
3 contract bet_various{
4     enum State { Started, Locked }
5   State public state = State.Started;
6   struct Guess{
7     address addr;
8     uint    guess;
9   }
10   uint arraysize=1000;
11   uint constant maxguess=1000000;
12   uint bettingprice = 0.01 ether;
13   Guess[1000] guesses;
14   uint    numguesses = 0;
15   bytes32 curhash = '';
16   
17   uint stasticsarrayitems = 20;
18   uint[20] statistics;
19 
20   uint _gameindex = 1;
21   
22   struct Winner{
23     address addr;
24   }
25   Winner[1000] winnners;
26   uint    numwinners = 0;
27 
28   modifier inState(State _state) {
29       require(state == _state);
30       _;
31   }
32  
33   address developer = 0x0;
34   event SentPrizeToWinner(address winner, uint money, uint guess, uint gameindex, uint lotterynumber, uint timestamp);
35   event SentDeveloperFee(uint amount, uint balance);
36 
37   function bet_various() 
38   {
39     if(developer==address(0)){
40       developer = msg.sender;
41     }
42   }
43 
44   function setBettingCondition(uint _contenders, uint _bettingprice)
45   {
46     if(msg.sender != developer)
47       return;
48   	arraysize  = _contenders;
49   	if(arraysize>1000)
50   	  arraysize = 1000;
51   	bettingprice = _bettingprice;
52   }
53   
54   function getMaxContenders() constant returns(uint){
55   	return arraysize;
56   }
57 
58   function getBettingPrice() constant returns(uint){
59   	return bettingprice;
60   }
61     
62   function findWinners(uint value) returns (uint)
63   {
64     numwinners = 0;
65     uint lastdiff = maxguess;
66     uint i = 0;
67     int diff = 0;
68     uint guess = 0;
69     for (i = 0; i < numguesses; i++) {
70       diff = (int)((int)(value)-(int)(guesses[i].guess));
71       if(diff<0)
72         diff = diff*-1;
73       if(lastdiff>(uint)(diff)){
74         guess = guesses[i].guess;
75         lastdiff = (uint)(diff);
76       }
77     }
78     
79     for (i = 0; i < numguesses; i++) {
80       diff = (int)((int)(value)-(int)(guesses[i].guess));
81       if(diff<0)
82         diff = diff*-1;
83       if(lastdiff==uint(diff)){
84         winnners[numwinners++].addr = guesses[i].addr;
85       }
86     }
87     return guess;
88   }
89   
90   function getDeveloperAddress() constant returns(address)
91   {
92     return developer;
93   }
94   
95   function getDeveloperFee() constant returns(uint)
96   {
97     uint developerfee = this.balance/100;
98     return developerfee;
99   }
100   
101   function getBalance() constant returns(uint)
102   {
103      return this.balance;
104   }
105   
106   function getLotteryMoney() constant returns(uint)
107   {
108     uint developerfee = getDeveloperFee();
109     uint prize = (this.balance - developerfee)/(numwinners<1?1:numwinners);
110     return prize;
111   }
112 
113   function getBettingStastics() 
114     payable
115     returns(uint[20])
116   {
117     require(msg.value == bettingprice*3);
118     return statistics;
119   }
120   
121   function getBettingStatus()
122     constant
123     returns (uint, uint, uint, uint, uint)
124   {
125     return ((uint)(state), numguesses, getLotteryMoney(), this.balance, bettingprice);
126   }
127   
128   function finish()
129   {
130     state = State.Locked;
131 
132     uint lotterynumber = (uint(curhash)+block.timestamp)%(maxguess+1);
133     // now that we know the random number was safely generate, let's do something with the random number..
134     var guess = findWinners(lotterynumber);
135     uint prize = getLotteryMoney();
136     uint remain = this.balance - (prize*numwinners);
137     for (uint i = 0; i < numwinners; i++) {
138       address winner = winnners[i].addr;
139       winner.transfer(prize);
140       SentPrizeToWinner(winner, prize, guess, _gameindex, lotterynumber, block.timestamp);
141     }
142     // give delveoper the money left behind
143     SentDeveloperFee(remain, this.balance);
144     developer.transfer(remain); 
145     
146     numguesses = 0;
147     for (i = 0; i < stasticsarrayitems; i++) {
148       statistics[i] = 0;
149     }
150     _gameindex++;
151     state = State.Started;
152   }
153 
154   function addguess(uint guess) 
155     inState(State.Started)
156     payable
157   {
158     require(msg.value == bettingprice);
159     
160     uint divideby = maxguess/stasticsarrayitems;
161     curhash = sha256(block.timestamp, block.coinbase, block.difficulty, curhash);
162     if((uint)(numguesses+1)<=arraysize) {
163       guesses[numguesses++] = Guess(msg.sender, guess);
164       uint statindex = guess / divideby;
165       if(statindex>=stasticsarrayitems) statindex = stasticsarrayitems-1;
166       statistics[statindex] ++;
167       if((uint)(numguesses)>=arraysize){
168         finish();
169       }
170     }
171   }
172 }