1 /**
2 * The contract defining the contest, allowing participation and voting.
3 * Participation is only possible before the participation deadline.
4 * Voting is only allowed after the participation deadline was met and before the voting deadline expires.
5 * As soon as voting is over, the contest may be closed, resultig in the distribution od the prizes.
6 * The referee may disable certain participants, if their content is inappropiate.
7 *
8 * Copyright (c) 2016 Jam Data, Julia Altenried
9 * */
10 pragma solidity ^0.4.7;
11 contract Contest {
12 /** An ID derived from the contest meta data, so users can verify which contract belongs to which contest **/
13 uint public id;
14 /** The contest creator**/
15 address owner;
16 /** The referee deciding if content is appropiate **/
17 address public referee;
18 /** The providers address **/
19 address public c4c;
20 /** List of all participants **/
21 address[] public participants;
22 /** List of all voters **/
23 address[] public voters;
24 /** List of the winning participants */
25 address[] public winners;
26 /** List of the voters that won a prize */
27 address[] public luckyVoters;
28 /** The sum of the prizes paid out */
29 uint public totalPrize;
30 /** to efficiently check if somebody already participated **/
31 mapping(address=>bool) public participated;
32 /** to efficiently check if somebody already voted **/
33 mapping(address=>bool) public voted;
34 /** number of votes per candidate (think about it, maybe it’s better to count afterwards) **/
35 mapping(address=>uint) public numVotes;
36 /** disqualified participants**/
37 mapping(address => bool) public disqualified;
38 /** timestamp of the participation deadline**/
39 uint public deadlineParticipation;
40 /** timestamp of the voting deadline**/
41 uint public deadlineVoting;
42 /** participation fee **/
43 uint128 public participationFee;
44 /** voting fee**/
45 uint128 public votingFee;
46 /** provider fee **/
47 uint16 public c4cfee;
48 /** prize distribution **/
49 uint16 public prizeOwner;
50 uint16 public prizeReferee;
51 uint16[] public prizeWinners;
52 //rest for voters, how many?
53 uint8 public nLuckyVoters;
54 
55 /** fired when contest is closed **/
56 event ContestClosed(uint prize, address[] winners, address[] votingWinners);
57 
58 /** sets owner, referee, c4c, prizes (in percent with two decimals), deadlines **/
59 function Contest() payable{
60 c4c = 0x87b0de512502f3e86fd22654b72a640c8e0f59cc;
61 c4cfee = 1000;
62 owner = msg.sender;
63 
64 deadlineParticipation=1505085660;
65 deadlineVoting=1505960340;
66 participationFee=12000000000000000;
67 votingFee=3000000000000000;
68 prizeOwner=400;
69 prizeReferee=0;
70 prizeWinners.push(6045);
71 nLuckyVoters=6;
72 
73 
74 uint16 sumPrizes = prizeOwner;
75 for(uint i = 0; i < prizeWinners.length; i++) {
76 sumPrizes += prizeWinners[i];
77 }
78 if(sumPrizes>10000)
79 throw;
80 else if(sumPrizes < 10000 && nLuckyVoters == 0)//make sure everything is paid out
81 throw;
82 }
83 
84 /**
85 * adds msg.sender to the list of participants if the deadline was not yet met and the participation fee is paid
86 * */
87 function participate() payable {
88 if(msg.value < participationFee)
89 throw;
90 else if (now >= deadlineParticipation)
91 throw;
92 else if (participated[msg.sender])
93 throw;
94 else if (msg.sender!=tx.origin) //contract could decline money sending or have an expensive fallback function, only wallets should be able to participate
95 throw;
96 else {
97 participants.push(msg.sender);
98 participated[msg.sender]=true;
99 //if the winners list is smaller than the prize list, push the candidate
100 if(winners.length < prizeWinners.length) winners.push(msg.sender);
101 }
102 }
103 
104 /**
105 * adds msg.sender to the voter list and updates vote related mappings if msg.value is enough, the vote is done between the deadlines and the voter didn't vote already
106 */
107 function vote(address candidate) payable{
108 if(msg.value < votingFee)
109 throw;
110 else if(now < deadlineParticipation || now >=deadlineVoting)
111 throw;
112 else if(voted[msg.sender])//voter did already vote
113 throw;
114 else if (msg.sender!=tx.origin) //contract could decline money sending or have an expensive fallback function, only wallets should be able to vote
115 throw;
116 else if(!participated[candidate]) //only voting for actual participants
117 throw;
118 else{
119 voters.push(msg.sender);
120 voted[msg.sender] = true;
121 numVotes[candidate]++;
122 
123 for(var i = 0; i < winners.length; i++){//from the first to the last
124 if(winners[i]==candidate) break;//the candidate remains on the same position
125 if(numVotes[candidate]>numVotes[winners[i]]){//candidate is better
126 //else, usually winners[i+1]==candidate, because usually a candidate just improves by one ranking
127 //however, if there are multiple candidates with the same amount of votes, it might be otherwise
128 for(var j = getCandidatePosition(candidate, i+1); j>i; j--){
129 winners[j]=winners[j-1];
130 }
131 winners[i]=candidate;
132 break;
133 }
134 }
135 }
136 }
137 
138 function getCandidatePosition(address candidate, uint startindex) internal returns (uint){
139 for(uint i = startindex; i < winners.length; i++){
140 if(winners[i]==candidate) return i;
141 }
142 return winners.length-1;
143 }
144 
145 /**
146 * only called by referee, does not delete the participant from the list, but keeps him from winning (because of inappropiate content), only in contract if a referee exists
147 * */
148 function disqualify(address candidate){
149 if(msg.sender==referee)
150 disqualified[candidate]=true;
151 }
152 
153 /**
154 * only callable by referee. in case he disqualified the wrong participant
155 * */
156 function requalify(address candidate){
157 if(msg.sender==referee)
158 disqualified[candidate]=false;
159 }
160 
161 /**
162 * only callable after voting deadline, distributes the prizes, fires event?
163 * */
164 function close(){
165 // if voting already ended and the contract has not been closed yet
166 if(now>=deadlineVoting&&totalPrize==0){
167 determineLuckyVoters();
168 if(this.balance>10000) distributePrizes(); //more than 10000 wei so every party gets at least 1 wei (if s.b. gets 0.01%)
169 ContestClosed(totalPrize, winners, luckyVoters);
170 }
171 }
172 
173 /**
174 * Determines the winning voters
175 * */
176 function determineLuckyVoters() constant {
177 if(nLuckyVoters>=voters.length)
178 luckyVoters = voters;
179 else{
180 mapping (uint => bool) chosen;
181 uint nonce=1;
182 
183 uint rand;
184 for(uint i = 0; i < nLuckyVoters; i++){
185 do{
186 rand = randomNumberGen(nonce, voters.length);
187 nonce++;
188 }while (chosen[rand]);
189 
190 chosen[rand] = true;
191 luckyVoters.push(voters[rand]);
192 }
193 }
194 }
195 
196 /**
197 * creates a random number in [0,range)
198 * */
199 function randomNumberGen(uint nonce, uint range) internal constant returns(uint){
200 return uint(block.blockhash(block.number-nonce))%range;
201 }
202 
203 /**
204 * distribites the contract balance amongst the creator, wthe winners, the lucky voters, the referee and the provider
205 * */
206 function distributePrizes() internal{
207 
208 if(!c4c.send(this.balance/10000*c4cfee)) throw;
209 totalPrize = this.balance;
210 if(prizeOwner!=0 && !owner.send(totalPrize/10000*prizeOwner)) throw;
211 if(prizeReferee!=0 && !referee.send(totalPrize/10000*prizeReferee)) throw;
212 for (uint8 i = 0; i < winners.length; i++)
213 if(prizeWinners[i]!=0 && !winners[i].send(totalPrize/10000*prizeWinners[i])) throw;
214 if (luckyVoters.length>0){//if anybody voted
215 if(this.balance>luckyVoters.length){//if there is ether left to be distributed amongst the lucky voters
216 uint amount = this.balance/luckyVoters.length;
217 for(uint8 j = 0; j < luckyVoters.length; j++)
218 if(!luckyVoters[j].send(amount)) throw;
219 }
220 }
221 else if(!owner.send(this.balance)) throw;//if there is no lucky voter, give remainder to the owner
222 }
223 
224 /**
225 * returns the total vote count
226 * */
227 function getTotalVotes() constant returns(uint){
228 return voters.length;
229 }
230 }