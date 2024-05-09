1 pragma solidity ^0.4.18;
2 
3 contract BeggarBetting {
4 
5     struct MatchBettingInfo {    
6         address better;
7         uint256 matchId;
8         uint homeTeamScore;
9         uint awayTeamScore;     
10         uint bettingPrice;  
11     }
12 
13     struct BetterBettingInfo {    
14         uint256 matchId;
15         uint homeTeamScore;
16         uint awayTeamScore;     
17         uint bettingPrice;
18         bool isWinner; 
19         bool hasReceivedPrize;
20         uint256 winningPrize;
21         uint numOfWinners;   
22         uint numOfBetters;   
23     }
24 
25     address public owner;
26     mapping(uint256 => MatchBettingInfo[]) public matchBettingInfo;  
27     mapping(address => BetterBettingInfo[]) public betterBettingInfo;
28     mapping(address => uint256) public betterBalance;
29     mapping(address => uint) public betterNumWinning;
30     uint numOfPanhandler;
31     uint numOfVagabond;
32     uint numOfTramp;
33     uint numOfMiddleClass;
34 
35     /**
36      * Constructor function
37      *
38      * Create the owner of the contract on first initialization
39      */
40     function BeggarBetting() {
41         owner = msg.sender;
42     }
43 
44     /**
45      * Fallback function
46      */
47     function () payable {}
48 
49     /**
50      * Store betting data submitted by the user
51      *
52      * Send `msg.value` to this contract
53      *
54      * @param _matchId The matchId to store
55      * @param _homeTeamScore The home team score to store
56      * @param _awayTeamScore The away team score to store
57      * @param _bettingPrice The betting price to store
58      */  
59     function placeBet(uint256 _matchId, uint _homeTeamScore, uint _awayTeamScore, uint _bettingPrice) public payable returns (bool) {  
60         require(_bettingPrice == msg.value); // Check ether send by sender is equal to bet amount
61         bool result = checkDuplicateMatchId(msg.sender, _matchId, _bettingPrice);    
62         // Revert if the sender has already placed this bet
63         if (result) {
64             revert();
65         }                                                                                                  
66         matchBettingInfo[_matchId].push(MatchBettingInfo(msg.sender, _matchId, _homeTeamScore, _awayTeamScore, _bettingPrice)); // Store this match's betting info        
67         betterBettingInfo[msg.sender].push(BetterBettingInfo(_matchId, _homeTeamScore, _awayTeamScore, _bettingPrice, false, false, 0, 0, 0)); // Store this better's betting info                                                                                                         
68         address(this).transfer(msg.value); // Send the user's betting price to this contract
69         return true;
70     }
71  
72     /**
73      * Claim winning prize by the user
74      *
75      * Send `winningPrize` to 'msg.sender' from this contract
76      *
77      * @param _matchId The matchId to find winners
78      * @param _homeTeamScore The home team score to find matching score
79      * @param _awayTeamScore The away team score to find matching score
80      * @param _bettingPrice The betting price to find matching price
81      */  
82     function claimPrizes(uint256 _matchId, uint _homeTeamScore, uint _awayTeamScore, uint _bettingPrice) public returns (bool) {
83         uint totalNumBetters = matchBettingInfo[_matchId].length;  
84         uint numOfBetters = 0;
85         uint numOfWinners = 0;
86         uint256 winningPrize = 0;
87         uint commissionToOwner = 0;  
88         bool result = checkPrizeAlreadyReceived(msg.sender, _matchId, _bettingPrice);        
89         // Revert if the sender has already received the prize
90         if (result) {
91             revert();
92         }          
93         // Find matching scores among betters who betted for this match & price
94         for (uint j = 0; j < totalNumBetters; j++) {  
95             if (matchBettingInfo[_matchId][j].bettingPrice == _bettingPrice) {
96                 numOfBetters++;
97                 if (matchBettingInfo[_matchId][j].homeTeamScore == _homeTeamScore && matchBettingInfo[_matchId][j].awayTeamScore == _awayTeamScore) {          
98                     numOfWinners++;
99                 }    
100             }
101         }   
102         // msg.sender is the only winner, gets all the prize and gives a 7% commission to the owner
103         if (numOfWinners == 1) {      
104             commissionToOwner = _bettingPrice * numOfBetters * 7 / 100;  
105             betterBalance[msg.sender] = (_bettingPrice * numOfBetters) - commissionToOwner;
106             winningPrize = (_bettingPrice * numOfBetters) - commissionToOwner;
107         // One more winner, divide it equally and gives a 7% commission to the owner
108         } else if (numOfWinners > 1) {
109             commissionToOwner = ((_bettingPrice * numOfBetters) / numOfWinners) * 7 / 100;  
110             betterBalance[msg.sender] = ((_bettingPrice * numOfBetters) / numOfWinners) - commissionToOwner;
111             winningPrize = ((_bettingPrice * numOfBetters) / numOfWinners) - commissionToOwner;   
112         }
113     
114         sendCommissionToOwner(commissionToOwner);
115         withdraw();
116         afterClaim(_matchId, _bettingPrice, winningPrize, numOfWinners, numOfBetters);
117     
118         return true;
119     }
120 
121     /**
122      * Send 7% commission to the contract owner
123      *
124      * Send `_commission` to `owner` from the winner's prize
125      *
126      * @param _commission The commission to be sent to the contract owner
127      */
128     function sendCommissionToOwner(uint _commission) private {    
129         require(address(this).balance >= _commission); 
130         owner.transfer(_commission);
131     }
132 
133     /**
134      * Send winning prize to the winner
135      *
136      * Send `balance` to `msg.sender` from the contract
137      */
138     function withdraw() private {
139         uint256 balance = betterBalance[msg.sender];    
140         require(address(this).balance >= balance); 
141         betterBalance[msg.sender] -= balance;
142         msg.sender.transfer(balance);
143     }
144 
145     /**
146      * Modify winner's betting information after receiving the prize
147      *
148      * Change hasReceivedPrize to true to process info panel
149      *
150      * @param _matchId The matchId to find msg.sender's info to modify
151      * @param _bettingPrice The betting price to find msg.sender's info to modify
152      * @param _winningPrize The winning prize to assign value to msg.sender's final betting info
153      * @param _numOfWinners The number of winners to assign value to msg.sender's final betting info
154      * @param _numOfBetters The number of betters to assign value to msg.sender's final betting info
155      */ 
156     function afterClaim(uint256 _matchId, uint _bettingPrice, uint256 _winningPrize, uint _numOfWinners, uint _numOfBetters) private {
157         uint numOfBettingInfo = betterBettingInfo[msg.sender].length;
158 
159         for (uint i = 0; i < numOfBettingInfo; i++) {
160             if (betterBettingInfo[msg.sender][i].matchId == _matchId && betterBettingInfo[msg.sender][i].bettingPrice == _bettingPrice) {
161                 betterBettingInfo[msg.sender][i].hasReceivedPrize = true;
162                 betterBettingInfo[msg.sender][i].winningPrize = _winningPrize;
163                 betterBettingInfo[msg.sender][i].numOfWinners = _numOfWinners;
164                 betterBettingInfo[msg.sender][i].numOfBetters = _numOfBetters;
165             }
166         }    
167 
168         betterNumWinning[msg.sender] += 1;
169         CheckPrivilegeAccomplishment(betterNumWinning[msg.sender]);        
170     }
171 
172     /**
173      * Find the msg.sender's number of winnings and increment the privilege if it matches
174      *
175      * Increment one of the privileges if numWinning matches
176      */
177     function CheckPrivilegeAccomplishment(uint numWinning) public {
178         if (numWinning == 3) {
179             numOfPanhandler++;
180         }
181         if (numWinning == 8) {
182             numOfVagabond++;
183         }
184         if (numWinning == 15) {
185             numOfTramp++;
186         }
187         if (numWinning == 21) {
188             numOfMiddleClass++;
189         }
190     }
191 
192     /**
193      * Prevent the user from submitting the same bet again
194      *
195      * Send `_commission` to `owner` from the winner's prize
196      *
197      * @param _better The address of the sender
198      * @param _matchId The matchId to find the msg.sender's betting info
199      * @param _bettingPrice The betting price to find the msg.sender's betting info
200      */
201     function checkDuplicateMatchId(address _better, uint256 _matchId, uint _bettingPrice) public view returns (bool) {
202         uint numOfBetterBettingInfo = betterBettingInfo[_better].length;
203       
204         for (uint i = 0; i < numOfBetterBettingInfo; i++) {
205             if (betterBettingInfo[_better][i].matchId == _matchId && betterBettingInfo[_better][i].bettingPrice == _bettingPrice) {
206                 return true;
207             }
208         }
209 
210         return false;
211     }
212 
213     /**
214      * Add extra security to prevent the user from trying to receive the winning prize again
215      *
216      * @param _better The address of the sender
217      * @param _matchId The matchId to find the msg.sender's betting info
218      * @param _bettingPrice The betting price to find the msg.sender's betting info
219      */
220     function checkPrizeAlreadyReceived(address _better, uint256 _matchId, uint _bettingPrice) public view returns (bool) {
221         uint numOfBetterBettingInfo = betterBettingInfo[_better].length;
222         // Find if the sender address has already received the prize
223         for (uint i = 0; i < numOfBetterBettingInfo; i++) {
224             if (betterBettingInfo[_better][i].matchId == _matchId && betterBettingInfo[_better][i].bettingPrice == _bettingPrice) {
225                 if (betterBettingInfo[_better][i].hasReceivedPrize) {
226                     return true;
227                 }
228             }
229         }
230 
231         return false;
232     }    
233 
234     /**
235      * Constant function to return the user's previous records
236      *
237      * @param _better The better's address to search betting info
238      */
239     function getBetterBettingInfo(address _better) public view returns (uint256[], uint[], uint[], uint[]) {
240         uint length = betterBettingInfo[_better].length;
241         uint256[] memory matchId = new uint256[](length);
242         uint[] memory homeTeamScore = new uint[](length);
243         uint[] memory awayTeamScore = new uint[](length);
244         uint[] memory bettingPrice = new uint[](length);   
245 
246         for (uint i = 0; i < length; i++) {
247             matchId[i] = betterBettingInfo[_better][i].matchId;
248             homeTeamScore[i] = betterBettingInfo[_better][i].homeTeamScore;
249             awayTeamScore[i] = betterBettingInfo[_better][i].awayTeamScore;
250             bettingPrice[i] = betterBettingInfo[_better][i].bettingPrice;   
251         }
252 
253         return (matchId, homeTeamScore, awayTeamScore, bettingPrice);
254     }
255 
256     /**
257      * Constant function to return the user's previous records
258      *
259      * @param _better The better's address to search betting info
260      */
261     function getBetterBettingInfo2(address _better) public view returns (bool[], bool[], uint256[], uint[], uint[]) {
262         uint length = betterBettingInfo[_better].length;  
263         bool[] memory isWinner = new bool[](length);
264         bool[] memory hasReceivedPrize = new bool[](length);
265         uint256[] memory winningPrize = new uint256[](length);
266         uint[] memory numOfWinners = new uint[](length);
267         uint[] memory numOfBetters = new uint[](length);
268 
269         for (uint i = 0; i < length; i++) {     
270             isWinner[i] = betterBettingInfo[_better][i].isWinner;
271             hasReceivedPrize[i] = betterBettingInfo[_better][i].hasReceivedPrize;
272             winningPrize[i] = betterBettingInfo[_better][i].winningPrize;
273             numOfWinners[i] = betterBettingInfo[_better][i].numOfWinners;
274             numOfBetters[i] = betterBettingInfo[_better][i].numOfBetters;
275         }
276 
277         return (isWinner, hasReceivedPrize, winningPrize, numOfWinners, numOfBetters);
278     }
279 
280     /**
281      * Load the number of participants for the same match and betting price
282      *
283      * @param _matchId The matchId to find number of participants
284      * @param _bettingPrice The betting price to find number of participants
285      */
286     function getNumOfBettersForMatchAndPrice(uint _matchId, uint _bettingPrice) public view returns(uint) {
287         uint numOfBetters = matchBettingInfo[_matchId].length;    
288         uint count = 0;
289 
290         for (uint i = 0; i < numOfBetters; i++) {   
291             if (matchBettingInfo[_matchId][i].bettingPrice == _bettingPrice) {
292                 count++;
293             }
294         }
295     
296         return count;    
297     }
298 
299     /**
300      * Get the number of winnings of the user
301      *
302      * @param _better The address of the user
303      */
304     function getBetterNumOfWinnings(address _better) public view returns(uint) {
305         return betterNumWinning[_better];    
306     }
307 
308     /**
309      * Return the current number of accounts who have reached each privileges
310      */
311     function getInfoPanel() public view returns(uint, uint, uint, uint) {      
312         return (numOfPanhandler, numOfVagabond, numOfTramp, numOfMiddleClass);    
313     }
314 }