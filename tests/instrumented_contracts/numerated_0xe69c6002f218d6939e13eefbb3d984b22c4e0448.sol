1 pragma solidity ^0.4.23;
2 
3 /*
4 * Zethell.
5 *
6 * Written June 2018 for Zethr (https://www.zethr.io) by Norsefire.
7 * Special thanks to oguzhanox and Etherguy for assistance with debugging.
8 *
9 */
10 
11 contract ZTHReceivingContract {
12     function tokenFallback(address _from, uint _value, bytes _data) public returns (bool);
13 }
14 
15 contract ZTHInterface {
16     function transfer(address _to, uint _value) public returns (bool);
17     function approve(address spender, uint tokens) public returns (bool);
18 }
19 
20 contract Zethell is ZTHReceivingContract {
21     using SafeMath for uint;
22 
23     address private owner;
24     address private bankroll;
25 
26     // How much of the current token balance is reserved as the house take?
27     uint    private houseTake;
28     
29     // How many tokens are currently being played for? (Remember, this is winner takes all)
30     uint    public tokensInPlay;
31     
32     // The token balance of the entire contract.
33     uint    public contractBalance;
34     
35     // Which address is currently winning?
36     address public currentWinner;
37 
38     // What time did the most recent clock reset happen?
39     uint    public gameStarted;
40     
41     // What time will the game end if the clock isn't reset?
42     uint    public gameEnds;
43     
44     // Is betting allowed? (Administrative function, in the event of unforeseen bugs)
45     bool    public gameActive;
46 
47     address private ZTHTKNADDR;
48     address private ZTHBANKROLL;
49     ZTHInterface private     ZTHTKN;
50 
51     mapping (uint => bool) validTokenBet;
52     mapping (uint => uint) tokenToTimer;
53 
54     // Fire an event whenever the clock runs out and a winner is determined.
55     event GameEnded(
56         address winner,
57         uint tokensWon,
58         uint timeOfWin
59     );
60 
61     // Might as well notify everyone when the house takes its cut out.
62     event HouseRetrievedTake(
63         uint timeTaken,
64         uint tokensWithdrawn
65     );
66 
67     // Fire an event whenever someone places a bet.
68     event TokensWagered(
69         address _wagerer,
70         uint _wagered,
71         uint _newExpiry
72     );
73 
74     modifier onlyOwner {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     modifier onlyBankroll {
80         require(msg.sender == bankroll);
81         _; 
82     }
83 
84     modifier onlyOwnerOrBankroll {
85         require(msg.sender == owner || msg.sender == bankroll);
86         _;
87     }
88 
89     constructor(address ZethrAddress, address BankrollAddress) public {
90 
91         // Set Zethr & Bankroll address from constructor params
92         ZTHTKNADDR = ZethrAddress;
93         ZTHBANKROLL = BankrollAddress;
94 
95         // Set starting variables
96         owner         = msg.sender;
97         bankroll      = ZTHBANKROLL;
98         currentWinner = ZTHBANKROLL;
99 
100         // Approve "infinite" token transfer to the bankroll, as part of Zethr game requirements.
101         ZTHTKN = ZTHInterface(ZTHTKNADDR);
102         ZTHTKN.approve(ZTHBANKROLL, 2**256 - 1);
103 
104         // To start with, we only allow bets of 5, 10, 25 or 50 ZTH.
105         validTokenBet[5e18]  = true;
106         validTokenBet[10e18] = true;
107         validTokenBet[25e18] = true;
108         validTokenBet[50e18] = true;
109 
110         // Logarithmically decreasing time 'bonus' associated with higher amounts of ZTH staked.
111         tokenToTimer[5e18]  = 24 hours;
112         tokenToTimer[10e18] = 18 hours;
113         tokenToTimer[25e18] = 10 hours;
114         tokenToTimer[50e18] = 6 hours;
115         
116         // Set the initial timers to contract genesis.
117         gameStarted = now;
118         gameEnds    = now;
119         gameActive  = true;
120     }
121     
122     // Zethr dividends gained are sent to Bankroll later
123     function() public payable {  }
124 
125     // If the contract receives tokens, bundle them up in a struct and fire them over to _stakeTokens for validation.
126     struct TKN { address sender; uint value; }
127     function tokenFallback(address _from, uint _value, bytes /* _data */) public returns (bool){
128         TKN memory          _tkn;
129         _tkn.sender       = _from;
130         _tkn.value        = _value;
131         _stakeTokens(_tkn);
132         return true;
133     }
134 
135     // First, we check to see if the tokens are ZTH tokens. If not, we revert the transaction.
136     // Next - if the game has already ended (i.e. your bet was too late and the clock ran out)
137     //   the staked tokens from the previous game are transferred to the winner, the timers are
138     //   reset, and the game begins anew.
139     // If you're simply resetting the clock, the timers are reset accordingly and you are designated
140     //   the current winner. A 1% cut will be taken for the house, and the rest deposited in the prize
141     //   pool which everyone will be playing for. No second place prizes here!
142     function _stakeTokens(TKN _tkn) private {
143    
144         require(gameActive); 
145         require(_zthToken(msg.sender));
146         require(validTokenBet[_tkn.value]);
147         
148         if (now > gameEnds) { _settleAndRestart(); }
149 
150         address _customerAddress = _tkn.sender;
151         uint    _wagered         = _tkn.value;
152 
153         uint rightNow      = now;
154         uint timePurchased = tokenToTimer[_tkn.value];
155         uint newGameEnd    = rightNow.add(timePurchased);
156 
157         gameStarted   = rightNow;
158         gameEnds      = newGameEnd;
159         currentWinner = _customerAddress;
160 
161         contractBalance = contractBalance.add(_wagered);
162         uint houseCut   = _wagered.div(100);
163         uint toAdd      = _wagered.sub(houseCut);
164         houseTake       = houseTake.add(houseCut);
165         tokensInPlay    = tokensInPlay.add(toAdd);
166 
167         emit TokensWagered(_customerAddress, _wagered, newGameEnd);
168 
169     }
170 
171     // In the event of a game restart, subtract the tokens which were being played for from the balance,
172     //   transfer them to the winner (if the number of tokens is greater than zero: sly edge case).
173     // If there is *somehow* any Ether in the contract - again, please don't - it is transferred to the
174     //   bankroll and reinvested into Zethr at the standard 33% rate.
175     function _settleAndRestart() private {
176         gameActive      = false;
177         uint payment = tokensInPlay/2;
178         contractBalance = contractBalance.sub(payment);
179 
180         if (tokensInPlay > 0) { ZTHTKN.transfer(currentWinner, payment);
181             if (address(this).balance > 0){
182                 ZTHBANKROLL.transfer(address(this).balance);
183             }}
184 
185         emit GameEnded(currentWinner, payment, now);
186 
187         // Reset values.
188         tokensInPlay  = tokensInPlay.sub(payment);
189         gameActive    = true;
190     }
191 
192     // How many tokens are in the contract overall?
193     function balanceOf() public view returns (uint) {
194         return contractBalance;
195     }
196 
197     // Administrative function for adding a new token-time pair, should there be demand.
198     function addTokenTime(uint _tokenAmount, uint _timeBought) public onlyOwner {
199         validTokenBet[_tokenAmount] = true;
200         tokenToTimer[_tokenAmount]  = _timeBought;
201     }
202 
203     // Administrative function to REMOVE a token-time pair, should one fall out of use. 
204     function removeTokenTime(uint _tokenAmount) public onlyOwner {
205         validTokenBet[_tokenAmount] = false;
206         tokenToTimer[_tokenAmount]  = 232 days;
207     }
208 
209     // Function to pull out the house cut to the bankroll if required (i.e. to seed other games).
210     function retrieveHouseTake() public onlyOwnerOrBankroll {
211         uint toTake = houseTake;
212         houseTake = 0;
213         contractBalance = contractBalance.sub(toTake);
214         ZTHTKN.transfer(bankroll, toTake);
215 
216         emit HouseRetrievedTake(now, toTake);
217     }
218 
219     // If, for any reason, betting needs to be paused (very unlikely), this will freeze all bets.
220     function pauseGame() public onlyOwner {
221         gameActive = false;
222     }
223 
224     // The converse of the above, resuming betting if a freeze had been put in place.
225     function resumeGame() public onlyOwner {
226         gameActive = true;
227     }
228 
229     // Administrative function to change the owner of the contract.
230     function changeOwner(address _newOwner) public onlyOwner {
231         owner = _newOwner;
232     }
233 
234     // Administrative function to change the Zethr bankroll contract, should the need arise.
235     function changeBankroll(address _newBankroll) public onlyOwner {
236         bankroll = _newBankroll;
237     }
238 
239     // Is the address that the token has come from actually ZTH?
240     function _zthToken(address _tokenContract) private view returns (bool) {
241        return _tokenContract == ZTHTKNADDR;
242     }
243 }
244 
245 // And here's the boring bit.
246 
247 /**
248  * @title SafeMath
249  * @dev Math operations with safety checks that throw on error
250  */
251 library SafeMath {
252 
253     /**
254     * @dev Multiplies two numbers, throws on overflow.
255     */
256     function mul(uint a, uint b) internal pure returns (uint) {
257         if (a == 0) {
258             return 0;
259         }
260         uint c = a * b;
261         assert(c / a == b);
262         return c;
263     }
264 
265     /**
266     * @dev Integer division of two numbers, truncating the quotient.
267     */
268     function div(uint a, uint b) internal pure returns (uint) {
269         // assert(b > 0); // Solidity automatically throws when dividing by 0
270         uint c = a / b;
271         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
272         return c;
273     }
274 
275     /**
276     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
277     */
278     function sub(uint a, uint b) internal pure returns (uint) {
279         assert(b <= a);
280         return a - b;
281     }
282 
283     /**
284     * @dev Adds two numbers, throws on overflow.
285     */
286     function add(uint a, uint b) internal pure returns (uint) {
287         uint c = a + b;
288         assert(c >= a);
289         return c;
290     }
291 }