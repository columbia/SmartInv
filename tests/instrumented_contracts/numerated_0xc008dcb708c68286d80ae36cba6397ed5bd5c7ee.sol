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
64 deadlineParticipation=1485858780;
65 deadlineVoting=1486463580;
66 participationFee=100000000000000000;
67 votingFee=0000000000000000;
68 prizeOwner=955;
69 prizeReferee=0;
70 prizeWinners.push(6045);
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
83 
84 /**
85      * adds msg.sender to the list of participants if the deadline was not yet met and the participation fee is paid
86      * */
87     function participate() payable {
88         if(msg.value<participationFee)
89             throw;
90         else if (now >= deadlineParticipation) 
91             throw;
92         else if (participated[msg.sender])
93             throw;
94         else {
95             participants.push(msg.sender);
96             participated[msg.sender]=true;
97             //if the winners list is smaller than the prize list, push the candidate
98             if(winners.length < prizeWinners.length) winners.push(msg.sender);
99         }    
100     }
101 
102     /**
103      * adds msg.sender to the voter list and updates vote related mappings if msg.value is enough, the vote is done between the deadlines and the voter didn't vote already
104      */
105     function vote(address candidate) payable{
106         if(msg.value<votingFee) 
107             throw;
108         else if(now<deadlineParticipation || now >=deadlineVoting)
109             throw;
110         else if(voted[msg.sender])//voter did already vote
111             throw;
112         else{
113             voters.push(msg.sender);
114             voted[msg.sender] = true;
115             numVotes[candidate]++;
116             
117             for(var i = 0; i<winners.length; i++){//from the first to the last
118                 if(winners[i]==candidate) break;//the candidate remains on the same position
119                 if(numVotes[candidate]>numVotes[winners[i]]){//candidate is better
120                     //else, usually winners[i+1]==candidate, because usually a candidate just improves by one ranking
121                     //however, if there are multiple candidates with the same amount of votes, it might be otherwise
122                     for(var j = getCandidatePosition(candidate, i+1); j>i; j--){
123                        winners[j]=winners[j-1];  
124                     }
125                     winners[i]=candidate;
126                     break;
127                 }
128             }
129         }
130     }
131   
132   function getCandidatePosition(address candidate, uint startindex) internal returns (uint){
133     for(uint i = startindex; i < winners.length; i++){
134       if(winners[i]==candidate) return i;
135     }
136     return winners.length-1;
137   }
138     
139     /**
140      * only called by referee, does not delete the participant from the list, but keeps him from winning (because of inappropiate content), only in contract if a referee exists
141      * */
142     function disqualify(address candidate){
143         if(msg.sender==referee)
144             disqualified[candidate]=true;
145     }
146     
147     /**
148      * only callable by referee. in case he disqualified the wrong participant
149      * */
150     function requalify(address candidate){
151         if(msg.sender==referee)
152             disqualified[candidate]=false;
153     }
154     
155     /**
156      * only callable after voting deadline, distributes the prizes, fires event?
157      * */
158     function close(){
159         // if voting already ended and the contract has not been closed yet
160         if(now>=deadlineVoting&&totalPrize==0){
161             determineLuckyVoters();
162             if(this.balance>10000) distributePrizes(); //more than 10000 wei so every party gets at least 1 wei (if s.b. gets 0.01%)
163             ContestClosed(totalPrize, winners, luckyVoters);
164         }
165     }
166     
167     /**
168      * Determines the winning voters
169      * */
170     function determineLuckyVoters() constant {
171         if(nLuckyVoters>=voters.length)
172             luckyVoters = voters;
173         else{
174              mapping (uint => bool) chosen;
175             uint nonce=1;
176      
177             uint rand;
178             for(uint i = 0; i < nLuckyVoters; i++){
179                 do{
180                     rand = randomNumberGen(nonce, voters.length);
181                     nonce++;
182                 }while (chosen[rand]);
183                 
184                 chosen[rand] = true;
185                 luckyVoters.push(voters[rand]);
186             }
187         }
188     }
189     
190     /**
191      * creates a random number in [0,range)
192      * */
193     function randomNumberGen(uint nonce, uint range) internal constant returns(uint){
194         return uint(block.blockhash(block.number-nonce))%range;
195     }
196     
197     /**
198      * distribites the contract balance amongst the creator, wthe winners, the lucky voters, the referee and the provider
199      * */
200     function distributePrizes() internal{
201         
202         if(!c4c.send(this.balance/10000*c4cfee))  throw;
203         totalPrize = this.balance;
204         if(prizeOwner!=0 && !owner.send(totalPrize/10000*prizeOwner)) throw;
205         if(prizeReferee!=0 && !referee.send(totalPrize/10000*prizeReferee)) throw;
206         for (uint8 i = 0; i < winners.length; i++)
207             if(prizeWinners[i]!=0 && !winners[i].send(totalPrize/10000*prizeWinners[i])) throw;
208         if (luckyVoters.length>0){//if anybody voted
209             if(this.balance>luckyVoters.length){//if there is ether left to be distributed amongst the lucky voters
210                 uint amount = this.balance/luckyVoters.length;
211                 for(uint8 j = 0; j < luckyVoters.length; j++)
212                     if(!luckyVoters[j].send(amount))  throw;
213             }
214         }
215         else if(!owner.send(this.balance)) throw;//if there is no lucky voter, give remainder to the owner
216     }
217     
218     /**
219      * returns the total vote count
220      * */
221     function getTotalVotes() constant returns(uint){
222         return voters.length;
223     }
224 }