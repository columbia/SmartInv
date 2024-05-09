1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 
8 contract SafeMath {
9 
10     uint constant DAY_IN_SECONDS = 86400;
11     uint constant BASE = 1000000000000000000;
12 
13     function mul(uint256 a, uint256 b) constant internal returns (uint256) {
14         uint256 c = a * b;
15         assert(a == 0 || c / a == b);
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) constant internal returns (uint256) {
20         assert(b != 0); // Solidity automatically throws when dividing by 0
21         uint256 c = a / b;
22         assert(a == b * c + a % b); // There is no case in which this doesn't hold
23         return c;
24     }
25 
26     function sub(uint256 a, uint256 b) constant internal returns (uint256) {
27         assert(b <= a);
28         return a - b;
29     }
30 
31     function add(uint256 a, uint256 b) constant internal returns (uint256) {
32         uint256 c = a + b;
33         assert(c >= a);
34         return c;
35     }
36 
37     function mulByFraction(uint256 number, uint256 numerator, uint256 denominator) internal returns (uint256) {
38         return div(mul(number, numerator), denominator);
39     }
40 
41     // ICO date bonus calculation
42     function dateBonus(uint roundIco, uint endIco, uint256 amount) internal returns (uint256) {
43         if(endIco >= now && roundIco == 0){
44             return add(amount,mulByFraction(amount, 15, 100));
45         }else{
46             return amount;
47         }
48     }
49 
50 }
51 
52 
53 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
54 /// @title Abstract token contract - Functions to be implemented by token contracts.
55 contract AbstractToken {
56     // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions
57     function totalSupply() constant returns (uint256) {}
58     function balanceOf(address owner) constant returns (uint256 balance);
59     function transfer(address to, uint256 value) returns (bool success);
60     function transferFrom(address from, address to, uint256 value) returns (bool success);
61     function approve(address spender, uint256 value) returns (bool success);
62     function allowance(address owner, address spender) constant returns (uint256 remaining);
63 
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66     event Issuance(address indexed to, uint256 value);
67 }
68 
69 contract StandardToken is AbstractToken {
70     /*
71      *  Data structures
72      */
73     mapping (address => uint256) balances;
74     mapping (address => bool) ownerAppended;
75     mapping (address => mapping (address => uint256)) allowed;
76     uint256 public totalSupply;
77     address[] public owners;
78 
79     /*
80      *  Read and write storage functions
81      */
82     /// @dev Transfers sender's tokens to a given address. Returns success.
83     /// @param _to Address of token receiver.
84     /// @param _value Number of tokens to transfer.
85     function transfer(address _to, uint256 _value) returns (bool success) {
86         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
87             balances[msg.sender] -= _value;
88             balances[_to] += _value;
89             if(!ownerAppended[_to]) {
90                 ownerAppended[_to] = true;
91                 owners.push(_to);
92             }
93             Transfer(msg.sender, _to, _value);
94             return true;
95         }
96         else {
97             return false;
98         }
99     }
100 
101     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
102     /// @param _from Address from where tokens are withdrawn.
103     /// @param _to Address to where tokens are sent.
104     /// @param _value Number of tokens to transfer.
105     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
106         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
107             balances[_to] += _value;
108             balances[_from] -= _value;
109             allowed[_from][msg.sender] -= _value;
110             if(!ownerAppended[_to]) {
111                 ownerAppended[_to] = true;
112                 owners.push(_to);
113             }
114             Transfer(_from, _to, _value);
115             return true;
116         }
117         else {
118             return false;
119         }
120     }
121 
122     /// @dev Returns number of tokens owned by given address.
123     /// @param _owner Address of token owner.
124     function balanceOf(address _owner) constant returns (uint256 balance) {
125         return balances[_owner];
126     }
127 
128     /// @dev Sets approved amount of tokens for spender. Returns success.
129     /// @param _spender Address of allowed account.
130     /// @param _value Number of approved tokens.
131     function approve(address _spender, uint256 _value) returns (bool success) {
132         allowed[msg.sender][_spender] = _value;
133         Approval(msg.sender, _spender, _value);
134         return true;
135     }
136 
137     /*
138      * Read storage functions
139      */
140     /// @dev Returns number of allowed tokens for given address.
141     /// @param _owner Address of token owner.
142     /// @param _spender Address of token spender.
143     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
144         return allowed[_owner][_spender];
145     }
146 }
147 
148 
149 contract RobotTradingToken is StandardToken, SafeMath {
150     /*
151      * Token meta data
152      */
153      
154     string public constant name = "Robot Trading";
155     string public constant symbol = "RTD";
156     uint public constant decimals = 18;
157 
158     // tottal supply
159 
160     address public icoContract = 0x0;
161     /*
162      * Modifiers
163      */
164 
165     modifier onlyIcoContract() {
166         // only ICO contract is allowed to proceed
167         require(msg.sender == icoContract);
168         _;
169     }
170 
171     /*
172      * Contract functions
173      */
174 
175     /// @dev Contract is needed in icoContract address
176     /// @param _icoContract Address of account which will be mint tokens
177     function RobotTradingToken(address _icoContract) {
178         assert(_icoContract != 0x0);
179         icoContract = _icoContract;
180     }
181 
182     /// @dev Burns tokens from address. It's can be applied by account with address this.icoContract
183     /// @param _from Address of account, from which will be burned tokens
184     /// @param _value Amount of tokens, that will be burned
185     function burnTokens(address _from, uint _value) onlyIcoContract {
186         assert(_from != 0x0);
187         require(_value > 0);
188 
189         balances[_from] = sub(balances[_from], _value);
190     }
191 
192     /// @dev Adds tokens to address. It's can be applied by account with address this.icoContract
193     /// @param _to Address of account to which the tokens will pass
194     /// @param _value Amount of tokens
195     function emitTokens(address _to, uint _value) onlyIcoContract {
196         assert(_to != 0x0);
197         require(_value > 0);
198 
199         balances[_to] = add(balances[_to], _value);
200 
201         if(!ownerAppended[_to]) {
202             ownerAppended[_to] = true;
203             owners.push(_to);
204         }
205 
206     }
207 
208     function getOwner(uint index) constant returns (address, uint256) {
209         return (owners[index], balances[owners[index]]);
210     }
211 
212     function getOwnerCount() constant returns (uint) {
213         return owners.length;
214     }
215 
216 }
217 
218 
219 contract RobotTradingIco is SafeMath {
220     /*
221      * ICO meta data
222      */
223     RobotTradingToken public robottradingToken;
224 
225     enum State{
226         Init,
227         Pause,
228         Running,
229         Stopped,
230         Migrated
231     }
232 
233     State public currentState = State.Pause;
234 
235     string public constant name = "Robot Trading ICO";
236 
237     // Addresses of founders and other level
238     address public accManager;
239     address public accFounder;
240     address public accPartner;
241     address public accCompany;
242     address public accRecive;
243 
244     // 10,000 M RDT tokens
245     uint public supplyLimit = 10000000000000000000000000000;
246 
247     // BASE = 10^18
248     uint constant BASE = 1000000000000000000;
249 
250     // current round ICO
251     uint public roundICO = 0;
252 
253     struct RoundStruct {
254         uint round;//ICO round 0 is preICO other is normal ICO
255         uint price;//ICO price for this round 1 ETH = 10000 RDT
256         uint supply;//total supply start at 1%
257         uint recive;//total recive ETH
258         uint soldTokens;//total tokens sold
259         uint sendTokens;//total tokens sold
260         uint dateStart;//start ICO date
261         uint dateEnd; //end ICO date
262     }
263 
264     RoundStruct[] public roundData;
265 
266     bool public sentTokensToFounder = false;
267     bool public sentTokensToPartner = false;
268     bool public sentTokensToCompany = false;
269 
270     uint public tokensToFunder = 0;
271     uint public tokensToPartner = 0;
272     uint public tokensToCompany = 0;
273     uint public etherRaised = 0;
274 
275     /*
276      * Modifiers
277      */
278 
279     modifier whenInitialized() {
280         // only when contract is initialized
281         require(currentState >= State.Init);
282         _;
283     }
284 
285     modifier onlyManager() {
286         // only ICO manager can do this action
287         require(msg.sender == accManager);
288         _;
289     }
290 
291     modifier onIcoRunning() {
292         // Checks, if ICO is running and has not been stopped
293         require(currentState == State.Running);
294         _;
295     }
296 
297     modifier onIcoStopped() {
298         // Checks if ICO was stopped or deadline is reached
299         require(currentState == State.Stopped);
300         _;
301     }
302 
303     modifier notMigrated() {
304         // Checks if base can be migrated
305         require(currentState != State.Migrated);
306         _;
307     }
308 
309     /// @dev Constructor of ICO. Requires address of accManager,
310     /// @param _accManager Address of ICO manager
311     function RobotTradingIco(address _accManager) {
312         assert(_accManager != 0x0);
313 
314         robottradingToken = new RobotTradingToken(this);
315         accManager = _accManager;
316     }
317 
318     /// @dev Initialises addresses of founders, tokens owner, accRecive.
319     /// Initialises balances of tokens owner
320     /// @param _founder Address of founder
321     /// @param _partner Address of partner
322     /// @param _company Address of company
323     /// @param _recive Address of recive
324     function init(address _founder, address _partner, address _company, address _recive) onlyManager {
325         assert(currentState != State.Init);
326         assert(_founder != 0x0);
327         assert(_recive != 0x0);
328 
329         accFounder = _founder;
330         accPartner = _partner;
331         accCompany = _company;
332         accRecive = _recive;
333 
334         currentState = State.Init;
335     }
336 
337     /// @dev Sets new state
338     /// @param _newState Value of new state
339     function setState(State _newState) public onlyManager
340     {
341         currentState = _newState;
342         if(currentState == State.Running) {
343             roundData[roundICO].dateStart = now;
344         }
345     }
346     /// @dev Sets new round ico
347     function setNewIco(uint _round, uint _price, uint _startDate, uint _endDate,  uint _newAmount) public onlyManager  whenInitialized {
348  
349         require(roundData.length == _round);
350 
351         RoundStruct memory roundStruct;
352         roundData.push(roundStruct);
353 
354         roundICO = _round; // round 1 input 1
355         roundData[_round].round = _round;
356         roundData[_round].price = _price;
357         roundData[_round].supply = mul(_newAmount, BASE); //input 10000 got 10000 token for this ico
358         roundData[_round].recive = 0;
359         roundData[_round].soldTokens = 0;
360         roundData[_round].sendTokens = 0;
361         roundData[_round].dateStart = _startDate;
362         roundData[_round].dateEnd = _endDate;
363 
364     }
365 
366 
367     /// @dev Sets manager. Only manager can do it
368     /// @param _accManager Address of new ICO manager
369     function setManager(address _accManager) onlyManager {
370         assert(_accManager != 0x0);
371         accManager = _accManager;
372     }
373 
374     /// @dev Buy quantity of tokens depending on the amount of sent ethers.
375     /// @param _buyer Address of account which will receive tokens
376     function buyTokens(address _buyer) private {
377         assert(_buyer != 0x0 && roundData[roundICO].dateEnd >= now && roundData[roundICO].dateStart <= now);
378         require(msg.value > 0);
379 
380         uint tokensToEmit =  mul(msg.value, roundData[roundICO].price);
381 
382         if(roundICO==0){
383             tokensToEmit =  dateBonus(roundICO, roundData[roundICO].dateEnd, tokensToEmit);
384         }
385         require(add(roundData[roundICO].soldTokens, tokensToEmit) <= roundData[roundICO].supply);
386         roundData[roundICO].soldTokens = add(roundData[roundICO].soldTokens, tokensToEmit);
387  
388         //emit tokens to token holder
389         robottradingToken.emitTokens(_buyer, tokensToEmit);
390         etherRaised = add(etherRaised, msg.value);
391     }
392 
393     /// @dev Fall back function ~50k-100k gas
394     function () payable onIcoRunning {
395         buyTokens(msg.sender);
396     }
397 
398     /// @dev Burn tokens from accounts only in state "not migrated". Only manager can do it
399     /// @param _from Address of account
400     function burnTokens(address _from, uint _value) onlyManager notMigrated {
401         robottradingToken.burnTokens(_from, _value);
402     }
403 
404     /// @dev Partial withdraw. Only manager can do it
405     function withdrawEther(uint _value) onlyManager {
406         require(_value > 0);
407         assert(_value <= this.balance);
408         // send 123 to get 1.23
409         accRecive.transfer(_value * 10000000000000000); // 10^16
410     }
411 
412     /// @dev Ether withdraw. Only manager can do it
413     function withdrawAllEther() onlyManager {
414         if(this.balance > 0)
415         {
416             accRecive.transfer(this.balance);
417         }
418     }
419 
420     ///@dev Send tokens to Partner.
421     function sendTokensToPartner() onlyManager whenInitialized {
422         require(!sentTokensToPartner);
423 
424         uint tokensSold = add(roundData[0].soldTokens, roundData[1].soldTokens);
425         uint partnerTokens = mulByFraction(supplyLimit, 11, 100); // 11%
426 
427         tokensToPartner = sub(partnerTokens,tokensSold);
428         robottradingToken.emitTokens(accPartner, partnerTokens);
429         sentTokensToPartner = true;
430     }
431 
432     /// @dev Send limit tokens to Partner. Can't be sent no more limit 11%
433     function sendLimitTokensToPartner(uint _value) onlyManager whenInitialized {
434         require(!sentTokensToPartner);
435         uint partnerLimit = mulByFraction(supplyLimit, 11, 100); // calc token 11%
436         uint partnerReward = sub(partnerLimit, tokensToPartner); // calc token <= 11%
437         uint partnerValue = mul(_value, BASE); // send 123 to get 123 token no decimel
438 
439         require(partnerReward >= partnerValue);
440         tokensToPartner = add(tokensToPartner, partnerValue);
441         robottradingToken.emitTokens(accPartner, partnerValue);
442     }
443 
444     /// @dev Send all tokens to founders. Can't be sent no more limit 30%
445     function sendTokensToCompany() onlyManager whenInitialized {
446         require(!sentTokensToCompany);
447 
448         //Calculate founder reward depending on total tokens sold
449         uint companyLimit = mulByFraction(supplyLimit, 30, 100); // calc token 30%
450         uint companyReward = sub(companyLimit, tokensToCompany); // 30% - tokensToCompany = amount for company
451 
452         require(companyReward > 0);
453 
454         tokensToCompany = add(tokensToCompany, companyReward);
455 
456         robottradingToken.emitTokens(accCompany, companyReward);
457         sentTokensToCompany = true;
458     }
459 
460     /// @dev Send limit tokens to company. Can't be sent no more limit 30%
461     function sendLimitTokensToCompany(uint _value) onlyManager whenInitialized {
462         require(!sentTokensToCompany);
463         uint companyLimit = mulByFraction(supplyLimit, 30, 100); // calc token 30%
464         uint companyReward = sub(companyLimit, tokensToCompany); // calc token <= 30%
465         uint companyValue = mul(_value, BASE); // send 123 to get 123 token no decimel
466 
467         require(companyReward >= companyValue);
468         tokensToCompany = add(tokensToCompany, companyValue);
469         robottradingToken.emitTokens(accCompany, companyValue);
470     }
471 
472     /// @dev Send all tokens to founders. 
473     function sendAllTokensToFounder(uint _round) onlyManager whenInitialized {
474         require(roundData[_round].soldTokens>=1);
475 
476         uint icoToken = add(roundData[_round].soldTokens,roundData[_round].sendTokens);
477         uint icoSupply = roundData[_round].supply;
478 
479         uint founderValue = sub(icoSupply, icoToken);
480 
481         roundData[_round].sendTokens = add(roundData[_round].sendTokens, founderValue);
482         tokensToFunder = add(tokensToFunder,founderValue);
483         robottradingToken.emitTokens(accFounder, founderValue);
484     }
485 
486     /// @dev Send limit tokens to founders. 
487     function sendLimitTokensToFounder(uint _round, uint _value) onlyManager whenInitialized {
488         require(roundData[_round].soldTokens>=1);
489 
490         uint icoToken = add(roundData[_round].soldTokens,roundData[_round].sendTokens);
491         uint icoSupply = roundData[_round].supply;
492 
493         uint founderReward = sub(icoSupply, icoToken);
494         uint founderValue = mul(_value, BASE); // send 123 to get 123 token no decimel
495 
496         require(founderReward >= founderValue);
497 
498         roundData[_round].sendTokens = add(roundData[_round].sendTokens, founderValue);
499         tokensToFunder = add(tokensToFunder,founderValue);
500         robottradingToken.emitTokens(accFounder, founderValue);
501     }
502 
503     /// @dev inc Supply tokens . Can't be inc no more 35%
504     function incSupply(uint _percent) onlyManager whenInitialized {
505         require(_percent<=35);
506         supplyLimit = add(supplyLimit,mulByFraction(supplyLimit, _percent, 100));
507     }
508 
509 }