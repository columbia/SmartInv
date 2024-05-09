1 pragma solidity ^0.4.8;
2 
3 // @address 0xb70835d7822ebb9426b56543e391846c107bd32c
4 // @multisig
5 // The implementation for the Game ICO smart contract was inspired by
6 // the Ethereum token creation tutorial, the FirstBlood token, and the BAT token.
7 // compiler: 0.4.17+commit.bdeb9e52
8 
9 /*
10 1. Contract Address: 0xb70835d7822ebb9426b56543e391846c107bd32c
11 
12 2. Official Site URL:https://www.game.com/
13 
14 3. Link to download a 28x28png icon logo:https://ic.game.com/download/gameico_28.png
15 
16 4. Official Contact Email Address:ico@game.com
17 
18 5. Link to blog (optional):https://medium.com/@Game.com
19 
20 6. Link to reddit (optional):
21 
22 7. Link to slack (optional):https://gameico.slack.com/
23 
24 8. Link to facebook (optional):https://www.facebook.com/Gamecom-2055954348021983/
25 
26 9. Link to twitter (optional):@gamecom666
27 
28 10. Link to bitcointalk (optional):
29 
30 11. Link to github (optional):https://github.com/GameLeLe
31 
32 12. Link to telegram (optional):https://t.me/gameico
33 
34 13. Link to whitepaper (optional):https://ic.game.com/download/Game.com-Whitepaper_EN.pdf
35 */
36 
37 ///////////////
38 // SAFE MATH //
39 ///////////////
40 
41 contract SafeMath {
42 
43     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
44         uint256 z = x + y;
45         require((z >= x) && (z >= y));
46         return z;
47     }
48 
49     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
50         require(x >= y);
51         uint256 z = x - y;
52         return z;
53     }
54 
55     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
56         uint256 z = x * y;
57         require((x == 0)||(z/x == y));
58         return z;
59     }
60 
61 }
62 
63 
64 ////////////////////
65 // STANDARD TOKEN //
66 ////////////////////
67 
68 contract Token {
69     uint256 public totalSupply;
70     function balanceOf(address _owner) constant public returns (uint256 balance);
71     function transfer(address _to, uint256 _value) public returns (bool success);
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
73     function approve(address _spender, uint256 _value) public returns (bool success);
74     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
75     event Transfer(address indexed _from, address indexed _to, uint256 _value);
76     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
77 }
78 
79 /*  ERC 20 token */
80 contract StandardToken is Token {
81 
82     mapping (address => uint256) balances;
83     //pre ico locked balance
84     mapping (address => uint256) lockedBalances;
85     mapping (address => uint256) initLockedBalances;
86 
87     mapping (address => mapping (address => uint256)) allowed;
88     bool allowTransfer = false;
89 
90     function transfer(address _to, uint256 _value) public returns (bool success){
91         if (balances[msg.sender] >= _value && _value > 0 && allowTransfer) {
92             balances[msg.sender] -= _value;
93             balances[_to] += _value;
94             Transfer(msg.sender, _to, _value);
95             return true;
96         } else {
97             return false;
98         }
99     }
100 
101     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
102         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0 && allowTransfer) {
103             balances[_to] += _value;
104             balances[_from] -= _value;
105             allowed[_from][msg.sender] -= _value;
106             Transfer(_from, _to, _value);
107             return true;
108         } else {
109             return false;
110         }
111     }
112 
113     function balanceOf(address _owner) constant public returns (uint256 balance){
114         return balances[_owner] + lockedBalances[_owner];
115     }
116     function availableBalanceOf(address _owner) constant public returns (uint256 balance){
117         return balances[_owner];
118     }
119 
120     function approve(address _spender, uint256 _value) public returns (bool success){
121         allowed[msg.sender][_spender] = _value;
122         Approval(msg.sender, _spender, _value);
123         return true;
124     }
125 
126     function allowance(address _owner, address _spender) constant public returns (uint256 remaining){
127         return allowed[_owner][_spender];
128     }
129 }
130 
131 /////////////////////
132 //GAME.COM ICO TOKEN//
133 /////////////////////
134 
135 contract GameICO is StandardToken, SafeMath {
136     // Descriptive properties
137     string public constant name = "Test Token";
138     
139     string public constant symbol = "CTG";
140     uint256 public constant decimals = 18;
141     string public version = "1.0";
142 
143     // Account for ether proceed.
144     address public etherProceedsAccount = 0x0;
145     address public multiWallet = 0x0;
146 
147     //owners
148     mapping (address => bool) public isOwner;
149     address[] public owners;
150 
151     // These params specify the start, end, min, and max of the sale.
152     bool public isFinalized;
153 
154     uint256 public window0TotalSupply = 0;
155     uint256 public window1TotalSupply = 0;
156     uint256 public window2TotalSupply = 0;
157     uint256 public window3TotalSupply = 0;
158 
159     uint256 public window0StartTime = 0;
160     uint256 public window0EndTime = 0;
161     uint256 public window1StartTime = 0;
162     uint256 public window1EndTime = 0;
163     uint256 public window2StartTime = 0;
164     uint256 public window2EndTime = 0;
165     uint256 public window3StartTime = 0;
166     uint256 public window3EndTime = 0;
167 
168     // setting the capacity of every part of ico
169     uint256 public preservedTokens = 1300000000 * 10**decimals;
170     uint256 public window0TokenCreationCap = 200000000 * 10**decimals;
171     uint256 public window1TokenCreationCap = 200000000 * 10**decimals;
172     uint256 public window2TokenCreationCap = 300000000 * 10**decimals;
173     uint256 public window3TokenCreationCap = 0 * 10**decimals;
174 
175     // Setting the exchange rate for the ICO.
176     uint256 public window0TokenExchangeRate = 5000;
177     uint256 public window1TokenExchangeRate = 4000;
178     uint256 public window2TokenExchangeRate = 3000;
179     uint256 public window3TokenExchangeRate = 0;
180 
181     uint256 public preICOLimit = 0;
182     bool public instantTransfer = false;
183 
184     // Events for logging refunds and token creation.
185     event CreateGameIco(address indexed _to, uint256 _value);
186     event PreICOTokenPushed(address indexed _buyer, uint256 _amount);
187     event UnlockBalance(address indexed _owner, uint256 _amount);
188     event OwnerAddition(address indexed owner);
189     event OwnerRemoval(address indexed owner);
190 
191     modifier ownerExists(address owner) {
192         require(isOwner[owner]);
193         _;
194     }
195 
196     // constructor
197     function GameICO() public
198     {
199         totalSupply             = 2000000000 * 10**decimals;
200         isFinalized             = false;
201         etherProceedsAccount    = msg.sender;
202     }
203     function adjustTime(
204     uint256 _window0StartTime, uint256 _window0EndTime,
205     uint256 _window1StartTime, uint256 _window1EndTime,
206     uint256 _window2StartTime, uint256 _window2EndTime)
207     public{
208         require(msg.sender == etherProceedsAccount);
209         window0StartTime = _window0StartTime;
210         window0EndTime = _window0EndTime;
211         window1StartTime = _window1StartTime;
212         window1EndTime = _window1EndTime;
213         window2StartTime = _window2StartTime;
214         window2EndTime = _window2EndTime;
215     }
216     function adjustSupply(
217     uint256 _window0TotalSupply,
218     uint256 _window1TotalSupply,
219     uint256 _window2TotalSupply)
220     public{
221         require(msg.sender == etherProceedsAccount);
222         window0TotalSupply = _window0TotalSupply * 10**decimals;
223         window1TotalSupply = _window1TotalSupply * 10**decimals;
224         window2TotalSupply = _window2TotalSupply * 10**decimals;
225     }
226     function adjustCap(
227     uint256 _preservedTokens,
228     uint256 _window0TokenCreationCap,
229     uint256 _window1TokenCreationCap,
230     uint256 _window2TokenCreationCap)
231     public{
232         require(msg.sender == etherProceedsAccount);
233         preservedTokens = _preservedTokens * 10**decimals;
234         window0TokenCreationCap = _window0TokenCreationCap * 10**decimals;
235         window1TokenCreationCap = _window1TokenCreationCap * 10**decimals;
236         window2TokenCreationCap = _window2TokenCreationCap * 10**decimals;
237     }
238     function adjustRate(
239     uint256 _window0TokenExchangeRate,
240     uint256 _window1TokenExchangeRate,
241     uint256 _window2TokenExchangeRate)
242     public{
243         require(msg.sender == etherProceedsAccount);
244         window0TokenExchangeRate = _window0TokenExchangeRate;
245         window1TokenExchangeRate = _window1TokenExchangeRate;
246         window2TokenExchangeRate = _window2TokenExchangeRate;
247     }
248     function setProceedsAccount(address _newEtherProceedsAccount)
249     public{
250         require(msg.sender == etherProceedsAccount);
251         etherProceedsAccount = _newEtherProceedsAccount;
252     }
253     function setMultiWallet(address _newWallet)
254     public{
255         require(msg.sender == etherProceedsAccount);
256         multiWallet = _newWallet;
257     }
258     function setPreICOLimit(uint256 _preICOLimit)
259     public{
260         require(msg.sender == etherProceedsAccount);
261         preICOLimit = _preICOLimit;
262     }
263     function setInstantTransfer(bool _instantTransfer)
264     public{
265         require(msg.sender == etherProceedsAccount);
266         instantTransfer = _instantTransfer;
267     }
268     function setAllowTransfer(bool _allowTransfer)
269     public{
270         require(msg.sender == etherProceedsAccount);
271         allowTransfer = _allowTransfer;
272     }
273     function addOwner(address owner)
274     public{
275         require(msg.sender == etherProceedsAccount);
276         isOwner[owner] = true;
277         owners.push(owner);
278         OwnerAddition(owner);
279     }
280     function removeOwner(address owner)
281     public{
282         require(msg.sender == etherProceedsAccount);
283         isOwner[owner] = false;
284         OwnerRemoval(owner);
285     }
286 
287     function preICOPush(address buyer, uint256 amount)
288     public{
289         require(msg.sender == etherProceedsAccount);
290 
291         uint256 tokens = 0;
292         uint256 checkedSupply = 0;
293         checkedSupply = safeAdd(window0TotalSupply, amount);
294         require(window0TokenCreationCap >= checkedSupply);
295         assignLockedBalance(buyer, amount);
296         window0TotalSupply = checkedSupply;
297         PreICOTokenPushed(buyer, amount);
298     }
299     function lockedBalanceOf(address _owner) constant public returns (uint256 balance) {
300         return lockedBalances[_owner];
301     }
302     function initLockedBalanceOf(address _owner) constant public returns (uint256 balance) {
303         return initLockedBalances[_owner];
304     }
305     function unlockBalance(address _owner, uint256 prob)
306     public
307     ownerExists(msg.sender)
308     returns (bool){
309         uint256 shouldUnlockedBalance = 0;
310         shouldUnlockedBalance = initLockedBalances[_owner] * prob / 100;
311         if(shouldUnlockedBalance > lockedBalances[_owner]){
312             shouldUnlockedBalance = lockedBalances[_owner];
313         }
314         balances[_owner] += shouldUnlockedBalance;
315         lockedBalances[_owner] -= shouldUnlockedBalance;
316         UnlockBalance(_owner, shouldUnlockedBalance);
317         return true;
318     }
319 
320     function () payable public{
321         create();
322     }
323     function create() internal{
324         require(!isFinalized);
325         require(msg.value >= 0.01 ether);
326         uint256 tokens = 0;
327         uint256 checkedSupply = 0;
328 
329         if(window0StartTime != 0 && window0EndTime != 0 && time() >= window0StartTime && time() <= window0EndTime){
330             if(preICOLimit > 0){
331                 require(msg.value >= preICOLimit);
332             }
333             tokens = safeMult(msg.value, window0TokenExchangeRate);
334             checkedSupply = safeAdd(window0TotalSupply, tokens);
335             require(window0TokenCreationCap >= checkedSupply);
336             assignLockedBalance(msg.sender, tokens);
337             window0TotalSupply = checkedSupply;
338             if(multiWallet != 0x0 && instantTransfer) multiWallet.transfer(msg.value);
339             CreateGameIco(msg.sender, tokens);
340         }else if(window1StartTime != 0 && window1EndTime!= 0 && time() >= window1StartTime && time() <= window1EndTime){
341             tokens = safeMult(msg.value, window1TokenExchangeRate);
342             checkedSupply = safeAdd(window1TotalSupply, tokens);
343             require(window1TokenCreationCap >= checkedSupply);
344             balances[msg.sender] += tokens;
345             window1TotalSupply = checkedSupply;
346             if(multiWallet != 0x0 && instantTransfer) multiWallet.transfer(msg.value);
347             CreateGameIco(msg.sender, tokens);
348         }else if(window2StartTime != 0 && window2EndTime != 0 && time() >= window2StartTime && time() <= window2EndTime){
349             tokens = safeMult(msg.value, window2TokenExchangeRate);
350             checkedSupply = safeAdd(window2TotalSupply, tokens);
351             require(window2TokenCreationCap >= checkedSupply);
352             balances[msg.sender] += tokens;
353             window2TotalSupply = checkedSupply;
354             if(multiWallet != 0x0 && instantTransfer) multiWallet.transfer(msg.value);
355             CreateGameIco(msg.sender, tokens);
356         }else{
357             require(false);
358         }
359 
360     }
361 
362     function time() internal returns (uint) {
363         return block.timestamp;
364     }
365 
366     function today(uint startTime) internal returns (uint) {
367         return dayFor(time(), startTime);
368     }
369 
370     function dayFor(uint timestamp, uint startTime) internal returns (uint) {
371         return timestamp < startTime ? 0 : safeSubtract(timestamp, startTime) / 24 hours + 1;
372     }
373 
374     function withDraw(uint256 _value) public{
375         require(msg.sender == etherProceedsAccount);
376         if(multiWallet != 0x0){
377             multiWallet.transfer(_value);
378         }else{
379             etherProceedsAccount.transfer(_value);
380         }
381     }
382 
383     function finalize() public{
384         require(!isFinalized);
385         require(msg.sender == etherProceedsAccount);
386         isFinalized = true;
387         if(multiWallet != 0x0){
388             assignLockedBalance(multiWallet, totalSupply- window0TotalSupply- window1TotalSupply - window2TotalSupply);
389             if(this.balance > 0) multiWallet.transfer(this.balance);
390         }else{
391             assignLockedBalance(etherProceedsAccount, totalSupply- window0TotalSupply- window1TotalSupply - window2TotalSupply);
392             if(this.balance > 0) etherProceedsAccount.transfer(this.balance);
393         }
394     }
395 
396     function supply() constant public returns (uint256){
397         return window0TotalSupply + window1TotalSupply + window2TotalSupply;
398     }
399 
400     function assignLockedBalance(address _owner, uint256 val) private{
401         initLockedBalances[_owner] += val;
402         lockedBalances[_owner] += val;
403     }
404 
405 }