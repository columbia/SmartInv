1 pragma solidity ^0.4.7;
2 
3 /*
4  1. Aim is to guess the closest Lottery number which is from 0 to 1000000. The closest gueser gets all the money!.
5  2. 1% of the bet goes to the developer.
6  3. Once 1000th user bet, the Lottery checks who guessed the closest number.
7  4. Lottery number is based on the Random number.
8  5. The user with closest number gets all money.
9 */
10 
11 contract bet1000 {
12   enum State { Started, Locked }
13   State public state = State.Started;
14   struct Guess{
15     address addr;
16     uint    guess;
17   }
18   uint constant arraysize=1000;
19   uint constant maxguess=1000000;
20   uint bettingprice = 0.01 ether;
21   Guess[1000] guesses;
22   uint    numguesses = 0;
23   bytes32 curhash = '';
24   
25   uint stasticsarrayitems = 20;
26   uint[20] statistics;
27 
28   uint _gameindex = 1;
29   
30   struct Winner{
31     address addr;
32   }
33   Winner[1000] winnners;
34   uint    numwinners = 0;
35 
36   modifier inState(State _state) {
37       require(state == _state);
38       _;
39   }
40  
41   address constant developer = 0x001973f023e4c03ef60ea34084b63e7790d463e595;
42   event SentPrizeToWinner(address winner, uint money, uint guess, uint gameindex, uint lotterynumber, uint timestamp);
43   event SentDeveloperFee(uint amount, uint balance);
44 
45   function bet1000(uint _bettingprice) 
46   {
47     bettingprice = _bettingprice;
48   }
49   
50 //   function stringToUint(string s) constant returns (uint result) {
51 //     bytes memory b = bytes(s);
52 //     uint i;
53 //     result = 0;
54 //     for (i = 0; i < b.length; i++) {
55 //       uint c = uint(b[i]);
56 //       if (c >= 48 && c <= 57) {
57 //         result = result * 10 + (c - 48);
58 //       }
59 //     }
60 //   }
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
90   function getDeveloperFee() constant returns(uint)
91   {
92     uint developerfee = this.balance/100;
93     return developerfee;
94   }
95   
96   function getBalance() constant returns(uint)
97   {
98      return this.balance;
99   }
100   
101   function getLotteryMoney() constant returns(uint)
102   {
103     uint developerfee = getDeveloperFee();
104     uint prize = (this.balance - developerfee)/(numwinners<1?1:numwinners);
105     return prize;
106   }
107 
108   function getBettingStastics() 
109     payable
110     returns(uint[20])
111   {
112     require(msg.value == bettingprice*3);
113     return statistics;
114   }
115   
116   function getBettingStatus()
117     constant
118     returns (uint, uint, uint, uint, uint)
119   {
120     return ((uint)(state), numguesses, getLotteryMoney(), this.balance, bettingprice);
121   }
122   
123   function finish()
124   {
125     state = State.Locked;
126 
127     uint lotterynumber = (uint(curhash)+block.timestamp)%(maxguess+1);
128     // now that we know the random number was safely generate, let's do something with the random number..
129     var guess = findWinners(lotterynumber);
130     uint prize = getLotteryMoney();
131     uint remain = this.balance - (prize*numwinners);
132     for (uint i = 0; i < numwinners; i++) {
133       address winner = winnners[i].addr;
134       winner.transfer(prize);
135       SentPrizeToWinner(winner, prize, guess, _gameindex, lotterynumber, block.timestamp);
136     }
137     // give delveoper the money left behind
138     SentDeveloperFee(remain, this.balance);
139     developer.transfer(remain); 
140     
141     numguesses = 0;
142     for (i = 0; i < stasticsarrayitems; i++) {
143       statistics[i] = 0;
144     }
145     _gameindex++;
146     state = State.Started;
147   }
148 
149   function addguess(uint guess) 
150     inState(State.Started)
151     payable
152   {
153     require(msg.value == bettingprice);
154     
155     uint divideby = maxguess/stasticsarrayitems;
156     curhash = sha256(block.timestamp, block.coinbase, block.difficulty, curhash);
157     if((uint)(numguesses+1)<=arraysize) {
158       guesses[numguesses++] = Guess(msg.sender, guess);
159       uint statindex = guess / divideby;
160       if(statindex>=stasticsarrayitems) statindex = stasticsarrayitems-1;
161       statistics[statindex] ++;
162       if((uint)(numguesses)>=arraysize){
163         finish();
164       }
165     }
166   }
167   
168 //   function getCurHash() returns (uint)
169 //   {
170 //       Winner(this, 0, 0, (uint)(curhash));
171 //       return (uint)(curhash);
172 //   }
173 }
174 
175 contract bet1000_001eth is bet1000(0.01 ether){
176   function bet1000_001eth(){ 
177   }
178 }