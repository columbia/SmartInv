1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 contract SafeMath {
8 
9     uint constant DAY_IN_SECONDS = 86400;
10 
11     function mul(uint256 a, uint256 b) constant internal returns (uint256) {
12         uint256 c = a * b;
13         assert(a == 0 || c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) constant internal returns (uint256) {
18         assert(b != 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) constant internal returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) constant internal returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 
35     function mulByFraction(uint256 number, uint256 numerator, uint256 denominator) internal returns (uint256) {
36         return div(mul(number, numerator), denominator);
37     }
38 
39     // ICO date bonus calculation
40     function dateBonus(uint startIco) internal returns (uint256) {
41 
42         // day from ICO start
43         uint daysFromStart = (now - startIco) / DAY_IN_SECONDS + 1;
44 
45         if(daysFromStart >= 1  && daysFromStart <= 14) return 20; // +20% tokens
46         if(daysFromStart >= 15 && daysFromStart <= 28) return 15; // +20% tokens
47         if(daysFromStart >= 29 && daysFromStart <= 42) return 10; // +10% tokens
48         if(daysFromStart >= 43)                        return 5;  // +5% tokens
49 
50         // no discount
51         return 0;
52     }
53 
54 }
55 
56 
57 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
58 /// @title Abstract token contract - Functions to be implemented by token contracts.
59 
60 contract AbstractToken {
61     // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions
62     function totalSupply() constant returns (uint256) {}
63     function balanceOf(address owner) constant returns (uint256 balance);
64     function transfer(address to, uint256 value) returns (bool success);
65     function transferFrom(address from, address to, uint256 value) returns (bool success);
66     function approve(address spender, uint256 value) returns (bool success);
67     function allowance(address owner, address spender) constant returns (uint256 remaining);
68 
69     event Transfer(address indexed from, address indexed to, uint256 value);
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71     event Issuance(address indexed to, uint256 value);
72 }
73 
74 contract StandardToken is AbstractToken {
75     /*
76      *  Data structures
77      */
78     mapping (address => uint256) balances;
79     mapping (address => bool) ownerAppended;
80     mapping (address => mapping (address => uint256)) allowed;
81     uint256 public totalSupply;
82     address[] public owners;
83 
84     /*
85      *  Read and write storage functions
86      */
87     /// @dev Transfers sender's tokens to a given address. Returns success.
88     /// @param _to Address of token receiver.
89     /// @param _value Number of tokens to transfer.
90     function transfer(address _to, uint256 _value) returns (bool success) {
91         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
92             balances[msg.sender] -= _value;
93             balances[_to] += _value;
94             if(!ownerAppended[_to]) {
95                 ownerAppended[_to] = true;
96                 owners.push(_to);
97             }
98             Transfer(msg.sender, _to, _value);
99             return true;
100         }
101         else {
102             return false;
103         }
104     }
105 
106     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
107     /// @param _from Address from where tokens are withdrawn.
108     /// @param _to Address to where tokens are sent.
109     /// @param _value Number of tokens to transfer.
110     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
111         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
112             balances[_to] += _value;
113             balances[_from] -= _value;
114             allowed[_from][msg.sender] -= _value;
115             if(!ownerAppended[_to]) {
116                 ownerAppended[_to] = true;
117                 owners.push(_to);
118             }
119             Transfer(_from, _to, _value);
120             return true;
121         }
122         else {
123             return false;
124         }
125     }
126 
127     /// @dev Returns number of tokens owned by given address.
128     /// @param _owner Address of token owner.
129     function balanceOf(address _owner) constant returns (uint256 balance) {
130         return balances[_owner];
131     }
132 
133     /// @dev Sets approved amount of tokens for spender. Returns success.
134     /// @param _spender Address of allowed account.
135     /// @param _value Number of approved tokens.
136     function approve(address _spender, uint256 _value) returns (bool success) {
137         allowed[msg.sender][_spender] = _value;
138         Approval(msg.sender, _spender, _value);
139         return true;
140     }
141 
142     /*
143      * Read storage functions
144      */
145     /// @dev Returns number of allowed tokens for given address.
146     /// @param _owner Address of token owner.
147     /// @param _spender Address of token spender.
148     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
149         return allowed[_owner][_spender];
150     }
151 
152 }
153 
154 
155 contract ShiftCashToken is StandardToken, SafeMath {
156     /*
157      * Token meta data
158      */
159     string public constant name = "ShiftCashToken";
160     string public constant symbol = "SCASH";
161     uint public constant decimals = 18;
162 
163     // tottal supply
164 
165     address public icoContract = 0x0;
166     /*
167      * Modifiers
168      */
169 
170     modifier onlyIcoContract() {
171         // only ICO contract is allowed to proceed
172         require(msg.sender == icoContract);
173         _;
174     }
175 
176     /*
177      * Contract functions
178      */
179 
180     /// @dev Contract is needed in icoContract address
181     /// @param _icoContract Address of account which will be mint tokens
182     function ShiftCashToken(address _icoContract) {
183         assert(_icoContract != 0x0);
184         icoContract = _icoContract;
185         totalSupply = 0;
186     }
187 
188     /// @dev Burns tokens from address. It's can be applied by account with address this.icoContract
189     /// @param _from Address of account, from which will be burned tokens
190     /// @param _value Amount of tokens, that will be burned
191     function burnTokens(address _from, uint _value) onlyIcoContract {
192         assert(_from != 0x0);
193         require(_value > 0);
194 
195         balances[_from] = sub(balances[_from], _value);
196         totalSupply = sub(totalSupply, _value);
197     }
198 
199     /// @dev Adds tokens to address. It's can be applied by account with address this.icoContract
200     /// @param _to Address of account to which the tokens will pass
201     /// @param _value Amount of tokens
202     function emitTokens(address _to, uint _value) onlyIcoContract {
203         assert(_to != 0x0);
204         require(_value > 0);
205 
206         balances[_to] = add(balances[_to], _value);
207 
208         totalSupply = add(totalSupply, _value);
209 
210         if(!ownerAppended[_to]) {
211             ownerAppended[_to] = true;
212             owners.push(_to);
213         }
214 
215         Transfer(msg.sender, _to, _value);
216 
217     }
218 
219     function getOwner(uint index) constant returns (address, uint256) {
220         return (owners[index], balances[owners[index]]);
221     }
222 
223     function getOwnerCount() constant returns (uint) {
224         return owners.length;
225     }
226 
227 }
228 
229 
230 contract ShiftCashIco is SafeMath {
231     /*
232      * ICO meta data
233      */
234     ShiftCashToken public shiftcashToken;
235     AbstractToken public preIcoToken;
236 
237     enum State{
238         Pause,
239         Init,
240         Running,
241         Stopped,
242         Migrated
243     }
244 
245     State public currentState = State.Pause;
246 
247     uint public startIcoDate = 0;
248 
249     // Address of account to which ethers will be tranfered in case of successful ICO
250     address public escrow;
251     // Address of manager
252     address public icoManager;
253     // Address of a account, that will transfer tokens from pre-ICO
254     address public tokenImporter = 0x0;
255     // Addresses of founders and bountyOwner
256     address public founder1;
257     address public bountyOwner;
258 
259 
260     // BASE = 10^18
261     uint constant BASE = 1000000000000000000;
262 
263     //  5 778 000 SCASH tokens
264     uint public constant supplyLimit = 5778000 * BASE;
265 
266     //  86 670 SCASH is token for bountyOwner
267     uint public constant bountyOwnersTokens = 86670 * BASE;
268 
269     // 1 ETH = 450 SCASH
270     uint public constant PRICE = 450;
271 
272     // 2018.07.05 07:00 UTC
273     // founders' reward time
274     uint public foundersRewardTime = 1530774000;
275 
276     // Amount of imported tokens from pre-ICO
277     uint public importedTokens = 0;
278     // Amount of sold tokens on ICO
279     uint public soldTokensOnIco = 0;
280     // Amount of issued tokens on pre-ICO
281     uint public constant soldTokensOnPreIco = 69990267262342250546086;
282     // Tokens to founders can be sent only if sentTokensToFounder == false and time > foundersRewardTime
283     bool public sentTokensToFounder = false;
284     // Tokens to bounty owner can be sent only after ICO
285     bool public sentTokensToBountyOwner = false;
286 
287     uint public etherRaised = 0;
288 
289     /*
290      * Modifiers
291      */
292 
293     modifier whenInitialized() {
294         // only when contract is initialized
295         require(currentState >= State.Init);
296         _;
297     }
298 
299     modifier onlyManager() {
300         // only ICO manager can do this action
301         require(msg.sender == icoManager);
302         _;
303     }
304 
305     modifier onIcoRunning() {
306         // Checks, if ICO is running and has not been stopped
307         require(currentState == State.Running);
308         _;
309     }
310 
311     modifier onIcoStopped() {
312         // Checks if ICO was stopped or deadline is reached
313         require(currentState == State.Stopped);
314         _;
315     }
316 
317     modifier notMigrated() {
318         // Checks if base can be migrated
319         require(currentState != State.Migrated);
320         _;
321     }
322 
323     modifier onlyImporter() {
324         // only importer contract is allowed to proceed
325         require(msg.sender == tokenImporter);
326         _;
327     }
328 
329     /// @dev Constructor of ICO. Requires address of icoManager,
330     /// @param _icoManager Address of ICO manager
331     /// @param _preIcoToken Address of pre-ICO contract
332     function ShiftCashIco(address _icoManager, address _preIcoToken) {
333         assert(_preIcoToken != 0x0);
334         assert(_icoManager != 0x0);
335 
336         shiftcashToken = new ShiftCashToken(this);
337         icoManager = _icoManager;
338         preIcoToken = AbstractToken(_preIcoToken);
339     }
340 
341     /// @dev Initialises addresses of founders, tokens owner, escrow.
342     /// Initialises balances of tokens owner
343     /// @param _founder1 Address of founder 1
344     /// @param _escrow Address of escrow
345     function init(address _founder1, address _escrow) onlyManager {
346         assert(currentState != State.Init);
347         assert(_founder1 != 0x0);
348         assert(_escrow != 0x0);
349         founder1 = _founder1;
350         escrow = _escrow;
351         currentState = State.Init;
352     }
353 
354     /// @dev Sets new state
355     /// @param _newState Value of new state
356     function setState(State _newState) public onlyManager
357     {
358         currentState = _newState;
359         if(currentState == State.Running) {
360             startIcoDate = now;
361         }
362     }
363 
364     /// @dev Sets new manager. Only manager can do it
365     /// @param _newIcoManager Address of new ICO manager
366     function setNewManager(address _newIcoManager) onlyManager {
367         assert(_newIcoManager != 0x0);
368         icoManager = _newIcoManager;
369     }
370 
371     /// @dev Sets bounty owner. Only manager can do it
372     /// @param _bountyOwner Address of Bounty owner
373     function setBountyOwner(address _bountyOwner) onlyManager {
374         assert(_bountyOwner != 0x0);
375         bountyOwner = _bountyOwner;
376     }
377 
378     // saves info if account's tokens were imported from pre-ICO
379     mapping (address => bool) private importedFromPreIco;
380 
381     /// @dev Imports account's tokens from pre-ICO. It can be done only by user, ICO manager or token importer
382     /// @param _account Address of account which tokens will be imported
383     function importTokens(address _account) {
384         // only token holder or manager can do migration
385         require(msg.sender == icoManager || msg.sender == _account);
386         require(!importedFromPreIco[_account]);
387 
388         uint preIcoBalance = preIcoToken.balanceOf(_account);
389 
390         if (preIcoBalance > 0) {
391             shiftcashToken.emitTokens(_account, preIcoBalance);
392             importedTokens = add(importedTokens, preIcoBalance);
393         }
394 
395         importedFromPreIco[_account] = true;
396     }
397 
398     /// @dev Buy quantity of tokens depending on the amount of sent ethers.
399     /// @param _buyer Address of account which will receive tokens
400     function buyTokens(address _buyer) private {
401         assert(_buyer != 0x0);
402         require(msg.value > 0);
403 
404         uint tokensToEmit = msg.value * PRICE;
405         //calculate date bonus
406         uint bonusPercent = dateBonus(startIcoDate);
407         //total bonus tokens
408 
409         if(bonusPercent > 0){
410             tokensToEmit =  tokensToEmit + mulByFraction(tokensToEmit, bonusPercent, 100);
411         }
412 
413         require(add(soldTokensOnIco, tokensToEmit) <= supplyLimit);
414 
415         soldTokensOnIco = add(soldTokensOnIco, tokensToEmit);
416 
417         //emit tokens to token holder
418         shiftcashToken.emitTokens(_buyer, tokensToEmit);
419 
420         etherRaised = add(etherRaised, msg.value);
421 
422         if(this.balance > 0) {
423             require(escrow.send(this.balance));
424         }
425 
426     }
427 
428     /// @dev Fall back function
429     function () payable onIcoRunning {
430         buyTokens(msg.sender);
431     }
432 
433     /// @dev Burn tokens from accounts only in state "not migrated". Only manager can do it
434     /// @param _from Address of account
435     function burnTokens(address _from, uint _value) onlyManager notMigrated {
436         shiftcashToken.burnTokens(_from, _value);
437     }
438 
439     /// @dev Partial withdraw. Only manager can do it
440     function withdrawEther(uint _value) onlyManager {
441         require(_value > 0);
442         escrow.transfer(_value);
443     }
444 
445     /// @dev Ether withdraw. Only manager can do it
446     function withdrawAllEther() onlyManager {
447         if(this.balance > 0) {
448             escrow.transfer(this.balance);
449         }
450     }
451 
452     ///@dev Send tokens to bountyOwner depending on crowdsale results. Can be send only after ICO.
453     function sendTokensToBountyOwner() onlyManager whenInitialized {
454         require(!sentTokensToBountyOwner);
455 
456         //Calculate total tokens sold on pre-ICO and ICO
457         uint tokensSold = add(soldTokensOnIco, soldTokensOnPreIco);
458 
459         //Calculate bounty tokens depending on total tokens sold
460         uint bountyTokens = mulByFraction(tokensSold, 15, 1000); // 1.5%
461 
462         shiftcashToken.emitTokens(bountyOwner, bountyTokens);
463 
464         sentTokensToBountyOwner = true;
465     }
466 
467     /// @dev Send tokens to founders. Can be sent only after shiftcashToken.rewardTime() (2018.07.05 0:00 UTC)
468     function sendTokensToFounders() onlyManager whenInitialized {
469         require(!sentTokensToFounder && now >= foundersRewardTime);
470 
471         //Calculate total tokens sold on pre-ICO and ICO
472         uint tokensSold = add(soldTokensOnIco, soldTokensOnPreIco);
473 
474         //Calculate founder reward depending on total tokens sold
475         uint totalRewardToFounder = mulByFraction(tokensSold, 1000, 10000); // 10%
476 
477         shiftcashToken.emitTokens(founder1, totalRewardToFounder);
478 
479         sentTokensToFounder = true;
480     }
481 }