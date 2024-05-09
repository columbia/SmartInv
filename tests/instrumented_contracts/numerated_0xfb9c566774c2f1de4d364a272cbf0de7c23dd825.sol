1 pragma solidity ^0.4.8;
2 
3 // @address 0xc0f29cdf021e0900ab6ad8d5c4cd86268d5eb715,0x1317d2b6d164ddf98f63ea54719efaee8d244457
4 // @address 0x5445c6027129EdC7677834dc7F3f5E1f00141D2D
5 // @multisig 0x664fEdFC0C9EdC1D8F50F5C11a13f3C5AC7a05E2
6 // The implementation for the Game ICO smart contract was inspired by
7 // the Ethereum token creation tutorial, the FirstBlood token, and the BAT token.
8 // compiler: 0.4.17+commit.bdeb9e52
9 
10 /*
11 1. Contract Address: 0x5445c6027129EdC7677834dc7F3f5E1f00141D2D
12 0x1c4aca13875aef724f7256beb66dbd6c720fa34c
13 
14 2. Official Site URL:https://www.game.com/
15 
16 3. Link to download a 28x28png icon logo:https://ic.game.com/download/gameico_28.png
17 
18 4. Official Contact Email Address:ico@game.com
19 
20 5. Link to blog (optional):
21 
22 6. Link to reddit (optional):
23 
24 7. Link to slack (optional):https://gameico.slack.com/
25 
26 8. Link to facebook (optional):https://www.facebook.com/Gamecom-2055954348021983/
27 
28 9. Link to twitter (optional):@gamecom666
29 
30 10. Link to bitcointalk (optional):
31 
32 11. Link to github (optional):https://github.com/GameLeLe
33 
34 12. Link to telegram (optional):https://t.me/gameico
35 
36 13. Link to whitepaper (optional):https://ic.game.com/download/Game.com-Whitepaper_EN.pdf
37 */
38 
39 ///////////////
40 // SAFE MATH //
41 ///////////////
42 
43 contract SafeMath {
44 
45     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
46         uint256 z = x + y;
47         require((z >= x) && (z >= y));
48         return z;
49     }
50 
51     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
52         require(x >= y);
53         uint256 z = x - y;
54         return z;
55     }
56 
57     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
58         uint256 z = x * y;
59         require((x == 0)||(z/x == y));
60         return z;
61     }
62 
63 }
64 
65 
66 ////////////////////
67 // STANDARD TOKEN //
68 ////////////////////
69 
70 contract Token {
71     uint256 public totalSupply;
72     function balanceOf(address _owner) constant public returns (uint256 balance);
73     function transfer(address _to, uint256 _value) public returns (bool success);
74     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
75     function approve(address _spender, uint256 _value) public returns (bool success);
76     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
77     event Transfer(address indexed _from, address indexed _to, uint256 _value);
78     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
79 }
80 
81 /*  ERC 20 token */
82 contract StandardToken is Token {
83 
84     mapping (address => uint256) balances;
85     //pre ico locked balance
86     mapping (address => uint256) lockedBalances;
87     mapping (address => uint256) initLockedBalances;
88 
89     mapping (address => mapping (address => uint256)) allowed;
90     bool allowTransfer = false;
91 
92     function transfer(address _to, uint256 _value) public returns (bool success){
93         if (balances[msg.sender] >= _value && _value > 0 && allowTransfer) {
94             balances[msg.sender] -= _value;
95             balances[_to] += _value;
96             Transfer(msg.sender, _to, _value);
97             return true;
98         } else {
99             return false;
100         }
101     }
102 
103     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
104         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0 && allowTransfer) {
105             balances[_to] += _value;
106             balances[_from] -= _value;
107             allowed[_from][msg.sender] -= _value;
108             Transfer(_from, _to, _value);
109             return true;
110         } else {
111             return false;
112         }
113     }
114 
115     function balanceOf(address _owner) constant public returns (uint256 balance){
116         return balances[_owner] + lockedBalances[_owner];
117     }
118 
119     function approve(address _spender, uint256 _value) public returns (bool success){
120         allowed[msg.sender][_spender] = _value;
121         Approval(msg.sender, _spender, _value);
122         return true;
123     }
124 
125     function allowance(address _owner, address _spender) constant public returns (uint256 remaining){
126         return allowed[_owner][_spender];
127     }
128 }
129 
130 /////////////////////
131 //GAME.COM ICO TOKEN//
132 /////////////////////
133 
134 contract GameICO is StandardToken, SafeMath {
135     // Descriptive properties
136     string public constant name = "Test Token";
137     string public constant symbol = "CTG";
138     uint256 public constant decimals = 18;
139     string public version = "1.0";
140 
141     // Account for ether proceed.
142     address public etherProceedsAccount = 0x0;
143     address public multiWallet = 0x0;
144 
145     //owners
146     mapping (address => bool) public isOwner;
147     address[] public owners;
148 
149     // These params specify the start, end, min, and max of the sale.
150     bool public isFinalized;
151 
152     uint256 public window0TotalSupply = 0;
153     uint256 public window1TotalSupply = 0;
154     uint256 public window2TotalSupply = 0;
155     uint256 public window3TotalSupply = 0;
156 
157     uint256 public window0StartTime = 0;
158     uint256 public window0EndTime = 0;
159     uint256 public window1StartTime = 0;
160     uint256 public window1EndTime = 0;
161     uint256 public window2StartTime = 0;
162     uint256 public window2EndTime = 0;
163     uint256 public window3StartTime = 0;
164     uint256 public window3EndTime = 0;
165 
166     // setting the capacity of every part of ico
167     uint256 public preservedTokens = 1300000000 * 10**decimals;
168     uint256 public window0TokenCreationCap = 200000000 * 10**decimals;
169     uint256 public window1TokenCreationCap = 200000000 * 10**decimals;
170     uint256 public window2TokenCreationCap = 300000000 * 10**decimals;
171     uint256 public window3TokenCreationCap = 0 * 10**decimals;
172 
173     // Setting the exchange rate for the ICO.
174     uint256 public window0TokenExchangeRate = 5000;
175     uint256 public window1TokenExchangeRate = 4000;
176     uint256 public window2TokenExchangeRate = 3000;
177     uint256 public window3TokenExchangeRate = 0;
178 
179     uint256 public preICOLimit = 0;
180     bool public instantTransfer = false;
181 
182     // Events for logging refunds and token creation.
183     event CreateGameIco(address indexed _to, uint256 _value);
184     event PreICOTokenPushed(address indexed _buyer, uint256 _amount);
185     event OwnerAddition(address indexed owner);
186     event OwnerRemoval(address indexed owner);
187 
188     modifier ownerExists(address owner) {
189         require(isOwner[owner]);
190         _;
191     }
192 
193     // constructor
194     function GameICO() public
195     {
196         totalSupply             = 2000000000 * 10**decimals;
197         isFinalized             = false;
198         etherProceedsAccount    = msg.sender;
199     }
200     function adjustTime(
201     uint256 _window0StartTime, uint256 _window0EndTime,
202     uint256 _window1StartTime, uint256 _window1EndTime,
203     uint256 _window2StartTime, uint256 _window2EndTime)
204     public{
205         require(msg.sender == etherProceedsAccount);
206         window0StartTime = _window0StartTime;
207         window0EndTime = _window0EndTime;
208         window1StartTime = _window1StartTime;
209         window1EndTime = _window1EndTime;
210         window2StartTime = _window2StartTime;
211         window2EndTime = _window2EndTime;
212     }
213     function adjustSupply(
214     uint256 _window0TotalSupply,
215     uint256 _window1TotalSupply,
216     uint256 _window2TotalSupply)
217     public{
218         require(msg.sender == etherProceedsAccount);
219         window0TotalSupply = _window0TotalSupply * 10**decimals;
220         window1TotalSupply = _window1TotalSupply * 10**decimals;
221         window2TotalSupply = _window2TotalSupply * 10**decimals;
222     }
223     function adjustCap(
224     uint256 _preservedTokens,
225     uint256 _window0TokenCreationCap,
226     uint256 _window1TokenCreationCap,
227     uint256 _window2TokenCreationCap)
228     public{
229         require(msg.sender == etherProceedsAccount);
230         preservedTokens = _preservedTokens * 10**decimals;
231         window0TokenCreationCap = _window0TokenCreationCap * 10**decimals;
232         window1TokenCreationCap = _window1TokenCreationCap * 10**decimals;
233         window2TokenCreationCap = _window2TokenCreationCap * 10**decimals;
234     }
235     function adjustRate(
236     uint256 _window0TokenExchangeRate,
237     uint256 _window1TokenExchangeRate,
238     uint256 _window2TokenExchangeRate)
239     public{
240         require(msg.sender == etherProceedsAccount);
241         window0TokenExchangeRate = _window0TokenExchangeRate;
242         window1TokenExchangeRate = _window1TokenExchangeRate;
243         window2TokenExchangeRate = _window2TokenExchangeRate;
244     }
245     function setProceedsAccount(address _newEtherProceedsAccount)
246     public{
247         require(msg.sender == etherProceedsAccount);
248         etherProceedsAccount = _newEtherProceedsAccount;
249     }
250     function setMultiWallet(address _newWallet)
251     public{
252         require(msg.sender == etherProceedsAccount);
253         multiWallet = _newWallet;
254     }
255     function setPreICOLimit(uint256 _preICOLimit)
256     public{
257         require(msg.sender == etherProceedsAccount);
258         preICOLimit = _preICOLimit;
259     }
260     function setInstantTransfer(bool _instantTransfer)
261     public{
262         require(msg.sender == etherProceedsAccount);
263         instantTransfer = _instantTransfer;
264     }
265     function setAllowTransfer(bool _allowTransfer)
266     public{
267         require(msg.sender == etherProceedsAccount);
268         allowTransfer = _allowTransfer;
269     }
270     function addOwner(address owner)
271     public{
272         require(msg.sender == etherProceedsAccount);
273         isOwner[owner] = true;
274         owners.push(owner);
275         OwnerAddition(owner);
276     }
277     function removeOwner(address owner)
278     public{
279         require(msg.sender == etherProceedsAccount);
280         isOwner[owner] = false;
281         OwnerRemoval(owner);
282     }
283 
284     function preICOPush(address buyer, uint256 amount)
285     public{
286         require(msg.sender == etherProceedsAccount);
287 
288         uint256 tokens = 0;
289         uint256 checkedSupply = 0;
290         checkedSupply = safeAdd(window0TotalSupply, amount);
291         require(window0TokenCreationCap >= checkedSupply);
292         assignLockedBalance(buyer, amount);
293         window0TotalSupply = checkedSupply;
294         PreICOTokenPushed(buyer, amount);
295     }
296     function lockedBalanceOf(address _owner) constant public returns (uint256 balance) {
297         return lockedBalances[_owner];
298     }
299     function initLockedBalanceOf(address _owner) constant public returns (uint256 balance) {
300         return initLockedBalances[_owner];
301     }
302     function unlockBalance(address _owner, uint256 prob)
303     public
304     ownerExists(msg.sender)
305     returns (bool){
306         uint256 shouldUnlockedBalance = 0;
307         shouldUnlockedBalance = initLockedBalances[_owner] * prob / 100;
308         if(shouldUnlockedBalance > lockedBalances[_owner]){
309             shouldUnlockedBalance = lockedBalances[_owner];
310         }
311         balances[_owner] += shouldUnlockedBalance;
312         lockedBalances[_owner] -= shouldUnlockedBalance;
313         return true;
314     }
315 
316     function () payable public{
317         create();
318     }
319     function create() internal{
320         require(!isFinalized);
321         require(msg.value >= 0.01 ether);
322         uint256 tokens = 0;
323         uint256 checkedSupply = 0;
324 
325         if(window0StartTime != 0 && window0EndTime != 0 && time() >= window0StartTime && time() <= window0EndTime){
326             if(preICOLimit > 0){
327                 require(msg.value >= preICOLimit);
328             }
329             tokens = safeMult(msg.value, window0TokenExchangeRate);
330             checkedSupply = safeAdd(window0TotalSupply, tokens);
331             require(window0TokenCreationCap >= checkedSupply);
332             assignLockedBalance(msg.sender, tokens);
333             window0TotalSupply = checkedSupply;
334             if(multiWallet != 0x0 && instantTransfer) multiWallet.transfer(msg.value);
335             CreateGameIco(msg.sender, tokens);
336         }else if(window1StartTime != 0 && window1EndTime!= 0 && time() >= window1StartTime && time() <= window1EndTime){
337             tokens = safeMult(msg.value, window1TokenExchangeRate);
338             checkedSupply = safeAdd(window1TotalSupply, tokens);
339             require(window1TokenCreationCap >= checkedSupply);
340             balances[msg.sender] += tokens;
341             window1TotalSupply = checkedSupply;
342             if(multiWallet != 0x0 && instantTransfer) multiWallet.transfer(msg.value);
343             CreateGameIco(msg.sender, tokens);
344         }else if(window2StartTime != 0 && window2EndTime != 0 && time() >= window2StartTime && time() <= window2EndTime){
345             tokens = safeMult(msg.value, window2TokenExchangeRate);
346             checkedSupply = safeAdd(window2TotalSupply, tokens);
347             require(window2TokenCreationCap >= checkedSupply);
348             balances[msg.sender] += tokens;
349             window2TotalSupply = checkedSupply;
350             if(multiWallet != 0x0 && instantTransfer) multiWallet.transfer(msg.value);
351             CreateGameIco(msg.sender, tokens);
352         }else{
353             require(false);
354         }
355 
356     }
357 
358     function time() internal returns (uint) {
359         return block.timestamp;
360     }
361 
362     function today(uint startTime) internal returns (uint) {
363         return dayFor(time(), startTime);
364     }
365 
366     function dayFor(uint timestamp, uint startTime) internal returns (uint) {
367         return timestamp < startTime ? 0 : safeSubtract(timestamp, startTime) / 24 hours + 1;
368     }
369 
370     function withDraw(uint256 _value) public{
371         require(msg.sender == etherProceedsAccount);
372         if(multiWallet != 0x0){
373             if (!multiWallet.send(_value)) require(false);
374         }else{
375             if (!etherProceedsAccount.send(_value)) require(false);
376         }
377     }
378 
379     function finalize() public{
380         require(!isFinalized);
381         require(msg.sender == etherProceedsAccount);
382         isFinalized = true;
383         if(multiWallet != 0x0){
384             assignLockedBalance(multiWallet, totalSupply- window0TotalSupply- window1TotalSupply - window2TotalSupply);
385             if (!multiWallet.send(this.balance)) require(false);
386         }else{
387             assignLockedBalance(etherProceedsAccount, totalSupply- window0TotalSupply- window1TotalSupply - window2TotalSupply);
388             if (!etherProceedsAccount.send(this.balance)) require(false);
389         }
390     }
391 
392     function assignLockedBalance(address _owner, uint256 val) private{
393         initLockedBalances[_owner] += val;
394         lockedBalances[_owner] += val;
395     }
396 }