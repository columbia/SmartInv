1 pragma solidity ^0.4.18;
2 
3 
4 contract Ownable {
5   address public owner;
6 
7 
8   /**
9    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
10    * account.
11    */
12   function Ownable() public {
13     owner = msg.sender;
14   }
15 
16 
17   /**
18    * @dev Throws if called by any account other than the owner.
19    */
20   modifier onlyOwner() {
21     require(msg.sender == owner);
22     _;
23   }
24 
25 
26   /**
27    * @dev Allows the current owner to transfer control of the contract to a newOwner.
28    * @param newOwner The address to transfer ownership to.
29    */
30   function transferOwnership(address newOwner) public onlyOwner {
31     if (newOwner != address(0)) {
32       owner = newOwner;
33     }
34   }
35 
36 }
37 
38 contract DefconPro is Ownable {
39   event Defcon(uint64 blockNumber, uint16 defconLevel);
40 
41   uint16 public defcon = 5;//default defcon level of 5 means everything is cool, no problems
42 
43   //if defcon is set to 4 or lower then function is paused
44   modifier defcon4() {//use this for high risk functions
45     require(defcon > 4);
46     _;
47   }
48 
49   //if defcon is set to 3 or lower then function is paused
50   modifier defcon3() {
51     require(defcon > 3);
52     _;
53   }
54   
55   //if defcon is set to 2 or lower then function is paused
56    modifier defcon2() {
57     require(defcon > 2);
58     _;
59   }
60   
61   //if defcon is set to 1 or lower then function is paused
62   modifier defcon1() {//use this for low risk functions
63     require(defcon > 1);
64     _;
65   }
66 
67   //set the defcon level, 5 is unpaused, 1 is EVERYTHING is paused
68   function setDefconLevel(uint16 _defcon) onlyOwner public {
69     defcon = _defcon;
70     Defcon(uint64(block.number), _defcon);
71   }
72 
73 }
74 
75 
76 contract bigBankLittleBank is DefconPro {
77     
78     using SafeMath for uint;
79     
80     uint public houseFee = 2; //Fee is 2%
81     uint public houseCommission = 0; //keeps track of commission
82     uint public bookKeeper = 0; //keeping track of what the balance should be to tie into auto pause script if it doesn't match contracte balance
83     
84     bytes32 emptyBet = 0x0000000000000000000000000000000000000000000000000000000000000000;
85     
86     //main event, listing off winners/losers
87     event BigBankBet(uint blockNumber, address indexed winner, address indexed loser, uint winningBetId1, uint losingBetId2, uint total);
88     //event to show users deposit history
89     event Deposit(address indexed user, uint amount);
90     //event to show users withdraw history
91     event Withdraw(address indexed user, uint amount);
92     
93     //Private struct that keeps track of each users bet
94     BetBank[] private betBanks;
95     
96     //bet Struct
97     struct BetBank {
98         bytes32 bet;
99         address owner;
100     }
101  
102     //gets the user balance, requires that the user be the msg.sender, should make it a bit harder to get users balance
103     function userBalance() public view returns(uint) {
104         return userBank[msg.sender];
105     }
106     
107     //setting up internal bank struct, should prevent prying eyes from seeing other users banks
108     mapping (address => uint) public userBank;
109 
110     //main deposit function
111     function depositBank() public defcon4 payable {
112         if(userBank[msg.sender] == 0) {//if the user doesn't have funds
113             userBank[msg.sender] = msg.value;//make balance = the funds
114         } else {
115             userBank[msg.sender] = (userBank[msg.sender]).add(msg.value);//if user already has funds, add to what exists
116         }
117         bookKeeper = bookKeeper.add(msg.value);//bookkeeper to prevent catastrophic exploits from going too far
118         Deposit(msg.sender, msg.value);//broadcast the deposit event
119     }
120     
121     //widthdraw what is in users bank
122     function withdrawBank(uint amount) public defcon2 returns(bool) {
123         require(userBank[msg.sender] >= amount);//require that the user has enough to withdraw
124         bookKeeper = bookKeeper.sub(amount);//update the bookkeeper
125         userBank[msg.sender] = userBank[msg.sender].sub(amount);//reduce users account balance
126         Withdraw(msg.sender, amount);//broadcast Withdraw event
127         (msg.sender).transfer(amount);//transfer the amount to user
128         return true;
129     }
130     
131     //create a bet
132     function startBet(uint _bet) public defcon3 returns(uint betId) {
133         require(userBank[msg.sender] >= _bet);//require user has enough to create the bet
134         require(_bet > 0);
135         userBank[msg.sender] = (userBank[msg.sender]).sub(_bet);//reduce users bank by the bet amount
136         uint convertedAddr = uint(msg.sender);
137         uint combinedBet = convertedAddr.add(_bet)*7;
138         BetBank memory betBank = BetBank({//birth the bet token
139             bet: bytes32(combinedBet),//_bet,
140             owner: msg.sender
141         });
142         //push new bet and get betId
143         betId = betBanks.push(betBank).sub(1);//push the bet token and get the Id
144     }
145    
146     //internal function to delete the bet token
147     function _endBetListing(uint betId) private returns(bool){
148         delete betBanks[betId];//delete that token
149     }
150     
151     //bet a users token against another users token
152     function betAgainstUser(uint _betId1, uint _betId2) public defcon3 returns(bool){
153         require(betBanks[_betId1].bet != emptyBet && betBanks[_betId2].bet != emptyBet);//require that both tokens are active and hold funds
154         require(betBanks[_betId1].owner == msg.sender || betBanks[_betId2].owner == msg.sender); //require that the user submitting is the owner of one of the tokens
155         require(betBanks[_betId1].owner != betBanks[_betId2].owner);//prevent a user from betting 2 tokens he owns, prevent possible exploits
156         require(_betId1 != _betId2);//require that user doesn't bet token against itself
157     
158         //unhash the bets to calculate winner
159         uint bet1ConvertedAddr = uint(betBanks[_betId1].owner);
160         uint bet1 = (uint(betBanks[_betId1].bet)/7).sub(bet1ConvertedAddr);
161         uint bet2ConvertedAddr = uint(betBanks[_betId2].owner);
162         uint bet2 = (uint(betBanks[_betId2].bet)/7).sub(bet2ConvertedAddr);  
163         
164         uint take = (bet1).add(bet2);//calculate the total rewards for winning
165         uint fee = (take.mul(houseFee)).div(100);//calculate the fee
166         houseCommission = houseCommission.add(fee);//add fee to commission
167         if(bet1 != bet2) {//if no tie
168             if(bet1 > bet2) {//if betId1 wins
169                 _payoutWinner(_betId1, _betId2, take, fee);//payout betId1
170             } else {
171                 _payoutWinner(_betId2, _betId1, take, fee);//payout betId2
172             }
173         } else {//if its a tie
174             if(_random() == 0) {//choose a random winner
175                 _payoutWinner(_betId1, _betId2, take, fee);//payout betId1
176             } else {
177                 _payoutWinner(_betId2, _betId1, take, fee);//payout betId2
178             }
179         }
180         return true;
181     }
182 
183     //internal function to pay out the winner
184     function _payoutWinner(uint winner, uint loser, uint take, uint fee) private returns(bool) {
185         BigBankBet(block.number, betBanks[winner].owner, betBanks[loser].owner, winner, loser, take.sub(fee));//broadcast the BigBankBet event
186         address winnerAddr = betBanks[winner].owner;//save the winner address
187         _endBetListing(winner);//end the token
188         _endBetListing(loser);//end the token
189         userBank[winnerAddr] = (userBank[winnerAddr]).add(take.sub(fee));//pay out the winner
190         return true;
191     }
192     
193     //set the fee
194     function setHouseFee(uint newFee)public onlyOwner returns(bool) {
195         require(msg.sender == owner);//redundant require owner
196         houseFee = newFee;//set the house fee
197         return true;
198     }
199     
200     //withdraw the commission
201     function withdrawCommission()public onlyOwner returns(bool) {
202         require(msg.sender == owner);//again redundant owner check because who trusts modifiers
203         bookKeeper = bookKeeper.sub(houseCommission);//update ;the bookKeeper
204         uint holding = houseCommission;//get the commission balance
205         houseCommission = 0;//empty the balance
206         owner.transfer(holding);//transfer to owner
207         return true;
208     }
209     
210     //random function for tiebreaker
211     function _random() private view returns (uint8) {
212         return uint8(uint256(keccak256(block.timestamp, block.difficulty))%2);
213     }
214     
215     //get amount of active bet tokens
216     function _totalActiveBets() private view returns(uint total) {
217         total = 0;
218         for(uint i=0; i<betBanks.length; i++) {//loop through bets 
219             if(betBanks[i].bet != emptyBet && betBanks[i].owner != msg.sender) {//if there is a bet and the owner is not the msg.sender
220                 total++;//increase quantity
221             }
222         }
223     }
224     
225     //get list of active bet tokens
226     function listActiveBets() public view returns(uint[]) {
227         uint256 total = _totalActiveBets();
228         if (total == 0) {
229             return new uint256[](0);
230         } else {
231             uint256[] memory result = new uint256[](total);
232             uint rc = 0;
233             for (uint idx=0; idx < betBanks.length; idx++) {//loop through bets
234                 if(betBanks[idx].bet != emptyBet && betBanks[idx].owner != msg.sender) {//if there is a bet and the owner is not the msg.sender
235                     result[rc] = idx;//add token to list
236                     rc++;
237                 }
238             }
239         }
240         return result;
241     }
242     
243     //total open bets of user
244     function _totalUsersBets() private view returns(uint total) {
245         total = 0;
246         for(uint i=0; i<betBanks.length; i++) {//loop through bets
247             if(betBanks[i].owner == msg.sender && betBanks[i].bet != emptyBet) {//if the bet is over 0 and the owner is msg.sender
248                 total++;//increase quantity
249             }
250         }
251     }
252     
253     //get list of active bet tokens
254     function listUsersBets() public view returns(uint[]) {
255         uint256 total = _totalUsersBets();
256         if (total == 0) {
257             return new uint256[](0);
258         } else {
259             uint256[] memory result = new uint256[](total);
260             uint rc = 0;
261             for (uint idx=0; idx < betBanks.length; idx++) {//loop through bets
262                 if(betBanks[idx].owner == msg.sender && betBanks[idx].bet != emptyBet) {//if the bet is over 0 and owner is msg.sender
263                     result[rc] = idx;//add to list
264                     rc++;
265                 }
266             }
267         }
268         return result;
269     }
270     
271 }
272 
273 
274 
275 
276 /**
277  * @title SafeMath
278  * @dev Math operations with safety checks that throw on error
279  */
280 library SafeMath {
281 
282   /**
283   * @dev Multiplies two numbers, throws on overflow.
284   */
285   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
286     if (a == 0) {
287       return 0;
288     }
289     c = a * b;
290     assert(c / a == b);
291     return c;
292   }
293 
294   /**
295   * @dev Integer division of two numbers, truncating the quotient.
296   */
297   function div(uint256 a, uint256 b) internal pure returns (uint256) {
298     // assert(b > 0); // Solidity automatically throws when dividing by 0
299     // uint256 c = a / b;
300     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
301     return a / b;
302   }
303 
304   /**
305   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
306   */
307   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
308     assert(b <= a);
309     return a - b;
310   }
311 
312   /**
313   * @dev Adds two numbers, throws on overflow.
314   */
315   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
316     c = a + b;
317     assert(c >= a);
318     return c;
319   }
320 }