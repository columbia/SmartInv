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
18 5. Link to blog (optional):
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
137     string public constant name = "Game.com Token";
138     string public constant symbol = "GTC";
139     uint256 public constant decimals = 18;
140     string public version = "1.0";
141 
142     // Account for ether proceed.
143     address public etherProceedsAccount = 0x0;
144     address public multiWallet = 0x0;
145 
146     //owners
147     mapping (address => bool) public isOwner;
148     address[] public owners;
149 
150     // These params specify the start, end, min, and max of the sale.
151     bool public isFinalized;
152 
153     uint256 public window0TotalSupply = 0;
154     uint256 public window1TotalSupply = 0;
155     uint256 public window2TotalSupply = 0;
156     uint256 public window3TotalSupply = 0;
157 
158     uint256 public window0StartTime = 0;
159     uint256 public window0EndTime = 0;
160     uint256 public window1StartTime = 0;
161     uint256 public window1EndTime = 0;
162     uint256 public window2StartTime = 0;
163     uint256 public window2EndTime = 0;
164     uint256 public window3StartTime = 0;
165     uint256 public window3EndTime = 0;
166 
167     // setting the capacity of every part of ico
168     uint256 public preservedTokens = 1300000000 * 10**decimals;
169     uint256 public window0TokenCreationCap = 200000000 * 10**decimals;
170     uint256 public window1TokenCreationCap = 200000000 * 10**decimals;
171     uint256 public window2TokenCreationCap = 300000000 * 10**decimals;
172     uint256 public window3TokenCreationCap = 0 * 10**decimals;
173 
174     // Setting the exchange rate for the ICO.
175     uint256 public window0TokenExchangeRate = 5000;
176     uint256 public window1TokenExchangeRate = 4000;
177     uint256 public window2TokenExchangeRate = 3000;
178     uint256 public window3TokenExchangeRate = 0;
179 
180     uint256 public preICOLimit = 0;
181     bool public instantTransfer = false;
182 
183     // Events for logging refunds and token creation.
184     event CreateGameIco(address indexed _to, uint256 _value);
185     event PreICOTokenPushed(address indexed _buyer, uint256 _amount);
186     event UnlockBalance(address indexed _owner, uint256 _amount);
187     event OwnerAddition(address indexed owner);
188     event OwnerRemoval(address indexed owner);
189 
190     modifier ownerExists(address owner) {
191         require(isOwner[owner]);
192         _;
193     }
194 
195     // constructor
196     function GameICO() public
197     {
198         totalSupply             = 2000000000 * 10**decimals;
199         isFinalized             = false;
200         etherProceedsAccount    = msg.sender;
201     }
202     function adjustTime(
203     uint256 _window0StartTime, uint256 _window0EndTime,
204     uint256 _window1StartTime, uint256 _window1EndTime,
205     uint256 _window2StartTime, uint256 _window2EndTime)
206     public{
207         require(msg.sender == etherProceedsAccount);
208         window0StartTime = _window0StartTime;
209         window0EndTime = _window0EndTime;
210         window1StartTime = _window1StartTime;
211         window1EndTime = _window1EndTime;
212         window2StartTime = _window2StartTime;
213         window2EndTime = _window2EndTime;
214     }
215     function adjustSupply(
216     uint256 _window0TotalSupply,
217     uint256 _window1TotalSupply,
218     uint256 _window2TotalSupply)
219     public{
220         require(msg.sender == etherProceedsAccount);
221         window0TotalSupply = _window0TotalSupply * 10**decimals;
222         window1TotalSupply = _window1TotalSupply * 10**decimals;
223         window2TotalSupply = _window2TotalSupply * 10**decimals;
224     }
225     function adjustCap(
226     uint256 _preservedTokens,
227     uint256 _window0TokenCreationCap,
228     uint256 _window1TokenCreationCap,
229     uint256 _window2TokenCreationCap)
230     public{
231         require(msg.sender == etherProceedsAccount);
232         preservedTokens = _preservedTokens * 10**decimals;
233         window0TokenCreationCap = _window0TokenCreationCap * 10**decimals;
234         window1TokenCreationCap = _window1TokenCreationCap * 10**decimals;
235         window2TokenCreationCap = _window2TokenCreationCap * 10**decimals;
236     }
237     function adjustRate(
238     uint256 _window0TokenExchangeRate,
239     uint256 _window1TokenExchangeRate,
240     uint256 _window2TokenExchangeRate)
241     public{
242         require(msg.sender == etherProceedsAccount);
243         window0TokenExchangeRate = _window0TokenExchangeRate;
244         window1TokenExchangeRate = _window1TokenExchangeRate;
245         window2TokenExchangeRate = _window2TokenExchangeRate;
246     }
247     function setProceedsAccount(address _newEtherProceedsAccount)
248     public{
249         require(msg.sender == etherProceedsAccount);
250         etherProceedsAccount = _newEtherProceedsAccount;
251     }
252     function setMultiWallet(address _newWallet)
253     public{
254         require(msg.sender == etherProceedsAccount);
255         multiWallet = _newWallet;
256     }
257     function setPreICOLimit(uint256 _preICOLimit)
258     public{
259         require(msg.sender == etherProceedsAccount);
260         preICOLimit = _preICOLimit;
261     }
262     function setInstantTransfer(bool _instantTransfer)
263     public{
264         require(msg.sender == etherProceedsAccount);
265         instantTransfer = _instantTransfer;
266     }
267     function setAllowTransfer(bool _allowTransfer)
268     public{
269         require(msg.sender == etherProceedsAccount);
270         allowTransfer = _allowTransfer;
271     }
272     function addOwner(address owner)
273     public{
274         require(msg.sender == etherProceedsAccount);
275         isOwner[owner] = true;
276         owners.push(owner);
277         OwnerAddition(owner);
278     }
279     function removeOwner(address owner)
280     public{
281         require(msg.sender == etherProceedsAccount);
282         isOwner[owner] = false;
283         OwnerRemoval(owner);
284     }
285 
286     function preICOPush(address buyer, uint256 amount)
287     public{
288         require(msg.sender == etherProceedsAccount);
289 
290         uint256 tokens = 0;
291         uint256 checkedSupply = 0;
292         checkedSupply = safeAdd(window0TotalSupply, amount);
293         require(window0TokenCreationCap >= checkedSupply);
294         assignLockedBalance(buyer, amount);
295         window0TotalSupply = checkedSupply;
296         PreICOTokenPushed(buyer, amount);
297     }
298     function lockedBalanceOf(address _owner) constant public returns (uint256 balance) {
299         return lockedBalances[_owner];
300     }
301     function initLockedBalanceOf(address _owner) constant public returns (uint256 balance) {
302         return initLockedBalances[_owner];
303     }
304     function unlockBalance(address _owner, uint256 prob)
305     public
306     ownerExists(msg.sender)
307     returns (bool){
308         uint256 shouldUnlockedBalance = 0;
309         shouldUnlockedBalance = initLockedBalances[_owner] * prob / 100;
310         if(shouldUnlockedBalance > lockedBalances[_owner]){
311             shouldUnlockedBalance = lockedBalances[_owner];
312         }
313         balances[_owner] += shouldUnlockedBalance;
314         lockedBalances[_owner] -= shouldUnlockedBalance;
315         UnlockBalance(_owner, shouldUnlockedBalance);
316         return true;
317     }
318 
319     function () payable public{
320         create();
321     }
322     function create() internal{
323         require(!isFinalized);
324         require(msg.value >= 0.01 ether);
325         uint256 tokens = 0;
326         uint256 checkedSupply = 0;
327 
328         if(window0StartTime != 0 && window0EndTime != 0 && time() >= window0StartTime && time() <= window0EndTime){
329             if(preICOLimit > 0){
330                 require(msg.value >= preICOLimit);
331             }
332             tokens = safeMult(msg.value, window0TokenExchangeRate);
333             checkedSupply = safeAdd(window0TotalSupply, tokens);
334             require(window0TokenCreationCap >= checkedSupply);
335             assignLockedBalance(msg.sender, tokens);
336             window0TotalSupply = checkedSupply;
337             if(multiWallet != 0x0 && instantTransfer) multiWallet.transfer(msg.value);
338             CreateGameIco(msg.sender, tokens);
339         }else if(window1StartTime != 0 && window1EndTime!= 0 && time() >= window1StartTime && time() <= window1EndTime){
340             tokens = safeMult(msg.value, window1TokenExchangeRate);
341             checkedSupply = safeAdd(window1TotalSupply, tokens);
342             require(window1TokenCreationCap >= checkedSupply);
343             balances[msg.sender] += tokens;
344             window1TotalSupply = checkedSupply;
345             if(multiWallet != 0x0 && instantTransfer) multiWallet.transfer(msg.value);
346             CreateGameIco(msg.sender, tokens);
347         }else if(window2StartTime != 0 && window2EndTime != 0 && time() >= window2StartTime && time() <= window2EndTime){
348             tokens = safeMult(msg.value, window2TokenExchangeRate);
349             checkedSupply = safeAdd(window2TotalSupply, tokens);
350             require(window2TokenCreationCap >= checkedSupply);
351             balances[msg.sender] += tokens;
352             window2TotalSupply = checkedSupply;
353             if(multiWallet != 0x0 && instantTransfer) multiWallet.transfer(msg.value);
354             CreateGameIco(msg.sender, tokens);
355         }else{
356             require(false);
357         }
358 
359     }
360 
361     function time() internal returns (uint) {
362         return block.timestamp;
363     }
364 
365     function today(uint startTime) internal returns (uint) {
366         return dayFor(time(), startTime);
367     }
368 
369     function dayFor(uint timestamp, uint startTime) internal returns (uint) {
370         return timestamp < startTime ? 0 : safeSubtract(timestamp, startTime) / 24 hours + 1;
371     }
372 
373     function withDraw(uint256 _value) public{
374         require(msg.sender == etherProceedsAccount);
375         if(multiWallet != 0x0){
376             multiWallet.transfer(_value);
377         }else{
378             etherProceedsAccount.transfer(_value);
379         }
380     }
381 
382     function finalize() public{
383         require(!isFinalized);
384         require(msg.sender == etherProceedsAccount);
385         isFinalized = true;
386         if(multiWallet != 0x0){
387             assignLockedBalance(multiWallet, totalSupply- window0TotalSupply- window1TotalSupply - window2TotalSupply);
388             if(this.balance > 0) multiWallet.transfer(this.balance);
389         }else{
390             assignLockedBalance(etherProceedsAccount, totalSupply- window0TotalSupply- window1TotalSupply - window2TotalSupply);
391             if(this.balance > 0) etherProceedsAccount.transfer(this.balance);
392         }
393     }
394 
395     function supply() constant public returns (uint256){
396         return window0TotalSupply + window1TotalSupply + window2TotalSupply;
397     }
398 
399     function assignLockedBalance(address _owner, uint256 val) private{
400         initLockedBalances[_owner] += val;
401         lockedBalances[_owner] += val;
402     }
403 
404 }