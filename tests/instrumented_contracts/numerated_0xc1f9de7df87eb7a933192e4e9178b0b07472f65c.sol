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
64 deadlineParticipation=1485995280;
65 deadlineVoting=1486600080;
66 participationFee=70000000000000000;
67 votingFee=7000000000000000;
68 prizeOwner=1000;
69 prizeReferee=0;
70 prizeWinners.push(8000);
71 nLuckyVoters=1;
72 
73 
74 uint16 sumPrizes = prizeOwner;
75 for(uint i = 0; i < prizeWinners.length; i++) {
76 sumPrizes += prizeWinners[i];
77 }
78 if(sumPrizes>10000) 
79 throw;
80 else if(sumPrizes<10000 && nLuckyVoters == 0)//make sure everything is paid out
81 throw;
82 }
83  /**
84      * adds msg.sender to the list of participants if the deadline was not yet met and the participation fee is paid
85      * */
86     function participate() payable {
87         if(msg.value<participationFee)
88             throw;
89         else if (now >= deadlineParticipation) 
90             throw;
91         else if (participated[msg.sender])
92             throw;
93         else {
94             participants.push(msg.sender);
95             participated[msg.sender]=true;
96             //if the winners list is smaller than the prize list, push the candidate
97             if(winners.length < prizeWinners.length) winners.push(msg.sender);
98         }    
99     }
100 
101     /**
102      * adds msg.sender to the voter list and updates vote related mappings if msg.value is enough, the vote is done between the deadlines and the voter didn't vote already
103      */
104     function vote(address candidate) payable{
105         if(msg.value<votingFee) 
106             throw;
107         else if(now<deadlineParticipation || now >=deadlineVoting)
108             throw;
109         else if(voted[msg.sender])//voter did already vote
110             throw;
111         else{
112             voters.push(msg.sender);
113             voted[msg.sender] = true;
114             numVotes[candidate]++;
115             
116             for(var i = 0; i<winners.length; i++){//from the first to the last
117                 if(winners[i]==candidate) break;//the candidate remains on the same position
118                 if(numVotes[candidate]>numVotes[winners[i]]){//candidate is better
119                     //else, usually winners[i+1]==candidate, because usually a candidate just improves by one ranking
120                     //however, if there are multiple candidates with the same amount of votes, it might be otherwise
121                     for(var j = getCandidatePosition(candidate, i+1); j>i; j--){
122                        winners[j]=winners[j-1];  
123                     }
124                     winners[i]=candidate;
125                     break;
126                 }
127             }
128         }
129     }
130   
131   function getCandidatePosition(address candidate, uint startindex) internal returns (uint){
132     for(uint i = startindex; i < winners.length; i++){
133       if(winners[i]==candidate) return i;
134     }
135     return winners.length-1;
136   }
137     
138     /**
139      * only called by referee, does not delete the participant from the list, but keeps him from winning (because of inappropiate content), only in contract if a referee exists
140      * */
141     function disqualify(address candidate){
142         if(msg.sender==referee)
143             disqualified[candidate]=true;
144     }
145     
146     /**
147      * only callable by referee. in case he disqualified the wrong participant
148      * */
149     function requalify(address candidate){
150         if(msg.sender==referee)
151             disqualified[candidate]=false;
152     }
153     
154     /**
155      * only callable after voting deadline, distributes the prizes, fires event?
156      * */
157     function close(){
158         // if voting already ended and the contract has not been closed yet
159         if(now>=deadlineVoting&&totalPrize==0){
160             determineLuckyVoters();
161             if(this.balance>10000) distributePrizes(); //more than 10000 wei so every party gets at least 1 wei (if s.b. gets 0.01%)
162             ContestClosed(totalPrize, winners, luckyVoters);
163         }
164     }
165     
166     /**
167      * Determines the winning voters
168      * */
169     function determineLuckyVoters() constant {
170         if(nLuckyVoters>=voters.length)
171             luckyVoters = voters;
172         else{
173              mapping (uint => bool) chosen;
174             uint nonce=1;
175      
176             uint rand;
177             for(uint i = 0; i < nLuckyVoters; i++){
178                 do{
179                     rand = randomNumberGen(nonce, voters.length);
180                     nonce++;
181                 }while (chosen[rand]);
182                 
183                 chosen[rand] = true;
184                 luckyVoters.push(voters[rand]);
185             }
186         }
187     }
188     
189     /**
190      * creates a random number in [0,range)
191      * */
192     function randomNumberGen(uint nonce, uint range) internal constant returns(uint){
193         return uint(block.blockhash(block.number-nonce))%range;
194     }
195     
196     /**
197      * distribites the contract balance amongst the creator, wthe winners, the lucky voters, the referee and the provider
198      * */
199     function distributePrizes() internal{
200         
201         if(!c4c.send(this.balance/10000*c4cfee))  throw;
202         totalPrize = this.balance;
203         if(prizeOwner!=0 && !owner.send(totalPrize/10000*prizeOwner)) throw;
204         if(prizeReferee!=0 && !referee.send(totalPrize/10000*prizeReferee)) throw;
205         for (uint8 i = 0; i < winners.length; i++)
206             if(prizeWinners[i]!=0 && !winners[i].send(totalPrize/10000*prizeWinners[i])) throw;
207         if (luckyVoters.length>0){//if anybody voted
208             if(this.balance>luckyVoters.length){//if there is ether left to be distributed amongst the lucky voters
209                 uint amount = this.balance/luckyVoters.length;
210                 for(uint8 j = 0; j < luckyVoters.length; j++)
211                     if(!luckyVoters[j].send(amount))  throw;
212             }
213         }
214         else if(!owner.send(this.balance)) throw;//if there is no lucky voter, give remainder to the owner
215     }
216     
217     /**
218      * returns the total vote count
219      * */
220     function getTotalVotes() constant returns(uint){
221         return voters.length;
222     }
223 }