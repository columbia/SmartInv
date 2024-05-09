1 pragma solidity ^0.4.21;
2 
3 contract SafeMath {
4     
5     uint256 constant MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
6 
7     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
8         require(x <= MAX_UINT256 - y);
9         return x + y;
10     }
11 
12     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
13         require(x >= y);
14         return x - y;
15     }
16 
17     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
18         if (y == 0) {
19             return 0;
20         }
21         require(x <= (MAX_UINT256 / y));
22         return x * y;
23     }
24 }
25 contract Owned {
26     address public owner;
27     address public newOwner;
28 
29     function Owned() public{
30         owner = msg.sender;
31     }
32 
33     modifier onlyOwner {
34         assert(msg.sender == owner);
35         _;
36     }
37 
38     function transferOwnership(address _newOwner) public onlyOwner {
39         require(_newOwner != owner);
40         newOwner = _newOwner;
41     }
42 
43     function acceptOwnership() public {
44         require(msg.sender == newOwner);
45         emit OwnerUpdate(owner, newOwner);
46         owner = newOwner;
47         newOwner = 0x0;
48     }
49 
50     event OwnerUpdate(address _prevOwner, address _newOwner);
51 }
52 contract IERC20Token {
53 
54     /// @return total amount of tokens
55     function totalSupply() constant returns (uint256 supply) {}
56 
57     /// @param _owner The address from which the balance will be retrieved
58     /// @return The balance
59     function balanceOf(address _owner) constant returns (uint256 balance) {}
60 
61     /// @notice send `_value` token to `_to` from `msg.sender`
62     /// @param _to The address of the recipient
63     /// @param _value The amount of token to be transferred
64     /// @return Whether the transfer was successful or not
65     function transfer(address _to, uint256 _value) returns (bool success) {}
66 
67     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
68     /// @param _from The address of the sender
69     /// @param _to The address of the recipient
70     /// @param _value The amount of token to be transferred
71     /// @return Whether the transfer was successful or not
72     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
73 
74     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
75     /// @param _spender The address of the account able to transfer the tokens
76     /// @param _value The amount of wei to be approved for transfer
77     /// @return Whether the approval was successful or not
78     function approve(address _spender, uint256 _value) returns (bool success) {}
79 
80     /// @param _owner The address of the account owning tokens
81     /// @param _spender The address of the account able to transfer the tokens
82     /// @return Amount of remaining tokens allowed to spent
83     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}   
84 
85     event Transfer(address indexed _from, address indexed _to, uint256 _value);
86     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
87 }
88 
89 contract CreditGAMEInterface {
90     function isGameApproved(address _gameAddress) view public returns(bool);
91     function createLock(address _winner, uint _totalParticipationAmount, uint _tokenLockDuration) public;
92     function removeFailedGame() public;
93     function removeLock() public;
94     function cleanUp() public;
95     function checkIfLockCanBeRemoved(address _gameAddress) public view returns(bool);
96 }
97 
98 
99 contract LuckyTree is Owned, SafeMath{
100     
101     uint public leafPrice;
102     uint public gameStart;
103     uint public gameDuration;
104     uint public tokenLockDuration;
105     uint public totalParticipationAmount;
106     uint public totalLockedAmount;
107     uint public numberOfLeafs;
108     uint public participantIndex;
109     bool public fundsTransfered;
110     address public winner;
111     mapping(uint => address) public participants;
112     mapping(uint => uint) public participationAmount;
113     mapping(address => bool) public hasParticipated;
114     mapping(address => bool) public hasWithdrawn;
115     mapping(address => uint) public participantIndexes;
116     mapping(uint => address) public leafOwners;
117     
118     event GameWinner(address winner);
119     event GameEnded(uint block);
120     event GameStarted(uint block);
121     event GameFailed(uint block);
122     event GameLocked(uint block);
123     event GameUnlocked(uint block);
124     
125     enum state{
126         pending,
127         running,
128         paused,
129         finished,
130         closed,
131         claimed
132     }
133     
134     state public gameState;
135     
136     //SET BEFORE DEPLOY
137     address public tokenAddress = 0xfc6b46d20584a7f736c0d9084ab8b1a8e8c01a38;
138     address public creditGameAddress = 0x7f135d5d5c1d2d44cf6abb7d09735466ba474799;
139 
140     /**
141      *leafPrice = price in crb for one leafPrice
142      * _gamestart = block.number when the game _gamestart
143      * _gameduration = block.number when game ends
144      * _tokenLockDuration = number of block for when the tokens are locked
145      */
146     function LuckyTree(
147         uint _leafPrice,
148         uint _gameStart,
149         uint _gameDuration,
150         uint _tokenLockDuration) public{
151         
152         leafPrice = _leafPrice;
153         gameStart = _gameStart;
154         gameDuration = _gameDuration;
155         tokenLockDuration = _tokenLockDuration;
156         
157         gameState = state.pending;
158         totalParticipationAmount = 0;
159         numberOfLeafs = 0;
160         participantIndex = 0;
161         fundsTransfered = false;
162         winner = 0x0;
163     }
164     
165     /**
166      * Generate random winner.
167      * 
168      **/
169     function random() internal view returns(uint){
170         return uint(keccak256(block.number, block.difficulty, numberOfLeafs));
171     }
172     
173     /**
174      * Set token address.
175      * 
176      **/
177     function setTokenAddress(address _tokenAddress) public onlyOwner{
178         tokenAddress = _tokenAddress;
179     }
180     
181     /**
182      * Set game address.
183      * 
184      **/
185     function setCreditGameAddress(address _creditGameAddress) public onlyOwner{
186         creditGameAddress = _creditGameAddress;
187     }
188     
189     /**
190      * Method called when game ends. 
191      * Check that more than 1 wallet contributed
192      **/
193     function pickWinner() internal{
194         if(numberOfLeafs > 0){
195             if(participantIndex == 1){
196                 //a single account contributed - just transfer funds back
197                 IERC20Token(tokenAddress).transfer(leafOwners[0], totalParticipationAmount);
198                 hasWithdrawn[leafOwners[0]] = true;
199                 CreditGAMEInterface(creditGameAddress).removeFailedGame();
200                 emit GameFailed(block.number);
201             }else{
202                 uint leafOwnerIndex = random() % numberOfLeafs;
203                 winner = leafOwners[leafOwnerIndex];
204                 emit GameWinner(winner);
205                 lockFunds(winner);
206                 
207             }
208         }
209         gameState = state.closed;
210     }
211     
212     /**
213      * Method called when winner is picked
214      * Funds are transferred to game contract and lock is created by calling game contract
215      **/
216     function lockFunds(address _winner) internal{
217         require(totalParticipationAmount != 0);
218         //transfer and lock tokens on game contract
219         IERC20Token(tokenAddress).transfer(creditGameAddress, totalParticipationAmount);
220         CreditGAMEInterface(creditGameAddress).createLock(_winner, totalParticipationAmount, tokenLockDuration);
221         totalLockedAmount = totalParticipationAmount;
222         emit GameLocked(block.number);
223     }
224     
225     /**
226      * Method for manually Locking fiunds
227      **/
228     function manualLockFunds() public onlyOwner{
229         require(totalParticipationAmount != 0);
230         require(CreditGAMEInterface(creditGameAddress).isGameApproved(address(this)) == true);
231         require(gameState == state.closed);
232         //pick winner
233         pickWinner();
234     }
235     
236     /**
237      * To manually allow game locking
238      */
239     function closeGame() public onlyOwner{
240         gameState = state.closed;
241     }
242     
243     /**
244      * Method called by participants to unlock and transfer their funds 
245      * First call to method transfers tokens from game contract to this contractđ
246      * Last call to method cleans up the game contract
247      **/
248     function unlockFunds() public {
249         require(gameState == state.closed);
250         require(hasParticipated[msg.sender] == true);
251         require(hasWithdrawn[msg.sender] == false);
252         
253         if(fundsTransfered == false){
254             require(CreditGAMEInterface(creditGameAddress).checkIfLockCanBeRemoved(address(this)) == true);
255             CreditGAMEInterface(creditGameAddress).removeLock();
256             fundsTransfered = true;
257             emit GameUnlocked(block.number);
258         }
259         
260         hasWithdrawn[msg.sender] = true;
261         uint index = participantIndexes[msg.sender];
262         uint amount = participationAmount[index];
263         IERC20Token(tokenAddress).transfer(msg.sender, amount);
264         totalLockedAmount = IERC20Token(tokenAddress).balanceOf(address(this));
265         if(totalLockedAmount == 0){
266             gameState = state.claimed;
267             CreditGAMEInterface(creditGameAddress).cleanUp();
268         }
269     }
270     
271     /**
272      * Check internall balance of this.
273      * 
274      **/
275     function checkInternalBalance() public view returns(uint256 tokenBalance) {
276         return IERC20Token(tokenAddress).balanceOf(address(this));
277     }
278     
279     /**
280      * Implemented token interface to transfer tokens to this.
281      * 
282      **/
283     function receiveApproval(address _from, uint256 _value, address _to, bytes _extraData) public {
284         require(_to == tokenAddress);
285         require(_value == leafPrice);
286         require(gameState != state.closed);
287         //check if game approved;
288         require(CreditGAMEInterface(creditGameAddress).isGameApproved(address(this)) == true);
289 
290         uint tokensToTake = processTransaction(_from, _value);
291         IERC20Token(tokenAddress).transferFrom(_from, address(this), tokensToTake);
292     }
293 
294     /**
295      * Calibrate game state and take tokens.
296      * 
297      **/
298     function processTransaction(address _from, uint _value) internal returns (uint) {
299         require(gameStart <= block.number);
300         
301         uint valueToProcess = 0;
302         
303         if(gameStart <= block.number && gameDuration >= block.number){
304             if(gameState != state.running){
305                 gameState = state.running;
306                 emit GameStarted(block.number);
307             }
308             // take tokens
309             leafOwners[numberOfLeafs] = _from;
310             numberOfLeafs++;
311             totalParticipationAmount += _value;
312             
313             //check if contributed before
314             if(hasParticipated[_from] == false){
315                 hasParticipated[_from] = true;
316                 
317                 participants[participantIndex] = _from;
318                 participationAmount[participantIndex] = _value;
319                 participantIndexes[_from] = participantIndex;
320                 participantIndex++;
321             }else{
322                 uint index = participantIndexes[_from];
323                 participationAmount[index] = participationAmount[index] + _value;
324             }
325             
326             valueToProcess = _value;
327             return valueToProcess;
328         //If block.number over game duration, pick winner
329         }else if(gameDuration < block.number){
330             gameState = state.finished;
331             pickWinner();
332             return valueToProcess;
333         }
334     }
335 
336     /**
337      * Return all variables needed for dapp in a single call
338      * 
339      **/
340     function getVariablesForDapp() public view returns(uint, uint, uint, uint, uint, uint, state){
341       return(leafPrice, gameStart, gameDuration, tokenLockDuration, totalParticipationAmount, numberOfLeafs, gameState);
342     }
343 
344     /**
345      * Manually send tokens to this.
346      * 
347      **/
348     function manuallyProcessTransaction(address _from, uint _value) onlyOwner public {
349         require(_value == leafPrice);
350         require(IERC20Token(tokenAddress).balanceOf(address(this)) >= _value + totalParticipationAmount);
351 
352         if(gameState == state.running && block.number < gameDuration){
353             uint tokensToTake = processTransaction(_from, _value);
354             IERC20Token(tokenAddress).transferFrom(_from, address(this), tokensToTake);
355         }
356 
357     }
358 
359     /**
360      * Salvage tokens from this.
361      * 
362      **/
363     function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner public {
364         require(_tokenAddress != tokenAddress);
365         IERC20Token(_tokenAddress).transfer(_to, _amount);
366     }
367 
368     /**
369      * Kill contract if needed
370      * 
371      **/
372     function killContract() onlyOwner public {
373       selfdestruct(owner);
374     }
375 }