1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 contract SafeMath {
8   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   function Ownable() public {
52     owner = msg.sender;
53   }
54 
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) public onlyOwner {
70     require(newOwner != address(0));
71     OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 
75 }
76 // accepted from zeppelin-solidity https://github.com/OpenZeppelin/zeppelin-solidity
77 /*
78  * ERC20 interface
79  * see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract ERC20 {
82   uint public totalSupply;
83   function balanceOf(address _who) public constant returns (uint);
84   function allowance(address _owner, address _spender) public constant returns (uint);
85 
86   function transfer(address _to, uint _value) public returns (bool ok);
87   function transferFrom(address _from, address _to, uint _value) public returns (bool ok);
88   function approve(address _spender, uint _value) public returns (bool ok);
89   event Transfer(address indexed from, address indexed to, uint value);
90   event Approval(address indexed owner, address indexed spender, uint value);
91 }
92 contract Haltable is Ownable {
93 
94     // @dev To Halt in Emergency Condition
95     bool public halted = false;
96     //empty contructor
97     function Haltable() public {}
98 
99     // @dev Use this as function modifier that should not execute if contract state Halted
100     modifier stopIfHalted {
101       require(!halted);
102       _;
103     }
104 
105     // @dev Use this as function modifier that should execute only if contract state Halted
106     modifier runIfHalted{
107       require(halted);
108       _;
109     }
110 
111     // @dev called by only owner in case of any emergecy situation
112     function halt() onlyOwner stopIfHalted public {
113         halted = true;
114     }
115     // @dev called by only owner to stop the emergency situation
116     function unHalt() onlyOwner runIfHalted public {
117         halted = false;
118     }
119 }
120 
121 contract UpgradeAgent is SafeMath {
122   address public owner;
123   bool public isUpgradeAgent;
124   function upgradeFrom(address _from, uint256 _value) public;
125   function setOriginalSupply() public;
126 }
127 
128 contract MiBoodleToken is ERC20,SafeMath,Haltable {
129 
130     //flag to determine if address is for real contract or not
131     bool public isMiBoodleToken = false;
132 
133     //Token related information
134     string public constant name = "miBoodle";
135     string public constant symbol = "MIBO";
136     uint256 public constant decimals = 18; // decimal places
137 
138     //mapping of token balances
139     mapping (address => uint256) balances;
140     //mapping of allowed address for each address with tranfer limit
141     mapping (address => mapping (address => uint256)) allowed;
142     //mapping of allowed address for each address with burnable limit
143     mapping (address => mapping (address => uint256)) allowedToBurn;
144 
145     //mapping of ether investment
146     mapping (address => uint256) investment;
147 
148     address public upgradeMaster;
149     UpgradeAgent public upgradeAgent;
150     uint256 public totalUpgraded;
151     bool public upgradeAgentStatus = false;
152 
153     //crowdSale related information
154      //crowdsale start time
155     uint256 public start;
156     //crowdsale end time
157     uint256 public end;
158     //crowdsale prefunding start time
159     uint256 public preFundingStart;
160     //Tokens per Ether in preFunding
161     uint256 public preFundingtokens;
162     //Tokens per Ether in Funding
163     uint256 public fundingTokens;
164     //max token supply
165     uint256 public maxTokenSupply = 600000000 ether;
166     //max token for sale
167     uint256 public maxTokenSale = 200000000 ether;
168     //max token for preSale
169     uint256 public maxTokenForPreSale = 100000000 ether;
170     //address of multisig
171     address public multisig;
172     //address of vault
173     address public vault;
174     //Is crowdsale finalized
175     bool public isCrowdSaleFinalized = false;
176     //Accept minimum ethers
177     uint256 minInvest = 1 ether;
178     //Accept maximum ethers
179     uint256 maxInvest = 50 ether;
180     //Is transfer enable
181     bool public isTransferEnable = false;
182     //Is Released Ether Once
183     bool public isReleasedOnce = false;
184 
185     //event
186     event Allocate(address _address,uint256 _value);
187     event Burn(address owner,uint256 _value);
188     event ApproveBurner(address owner, address canBurn, uint256 value);
189     event BurnFrom(address _from,uint256 _value);
190     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
191     event UpgradeAgentSet(address agent);
192     event Deposit(address _investor,uint256 _value);
193 
194     function MiBoodleToken(uint256 _preFundingtokens,uint256 _fundingTokens,uint256 _preFundingStart,uint256 _start,uint256 _end) public {
195         upgradeMaster = msg.sender;
196         isMiBoodleToken = true;
197         preFundingtokens = _preFundingtokens;
198         fundingTokens = _fundingTokens;
199         preFundingStart = safeAdd(now, _preFundingStart);
200         start = safeAdd(now, _start);
201         end = safeAdd(now, _end);
202     }
203 
204     //'owner' can set minimum ether to accept
205     // @param _minInvest Minimum value of ether
206     function setMinimumEtherToAccept(uint256 _minInvest) public stopIfHalted onlyOwner {
207         minInvest = _minInvest;
208     }
209 
210     //'owner' can set maximum ether to accept
211     // @param _maxInvest Maximum value of ether
212     function setMaximumEtherToAccept(uint256 _maxInvest) public stopIfHalted onlyOwner {
213         maxInvest = _maxInvest;
214     }
215 
216     //'owner' can set start time of pre funding
217     // @param _preFundingStart Starting time of prefunding
218     function setPreFundingStartTime(uint256 _preFundingStart) public stopIfHalted onlyOwner {
219         preFundingStart = now + _preFundingStart;
220     }
221 
222     //'owner' can set start time of funding
223     // @param _start Starting time of funding
224     function setFundingStartTime(uint256 _start) public stopIfHalted onlyOwner {
225         start = now + _start;
226     }
227 
228     //'owner' can set end time of funding
229     // @param _end Ending time of funding
230     function setFundingEndTime(uint256 _end) public stopIfHalted onlyOwner {
231         end = now + _end;
232     }
233 
234     //'owner' can set transfer enable or disable
235     // @param _isTransferEnable Token transfer enable or disable
236     function setTransferEnable(bool _isTransferEnable) public stopIfHalted onlyOwner {
237         isTransferEnable = _isTransferEnable;
238     }
239 
240     //'owner' can set number of tokens per Ether in prefunding
241     // @param _preFundingtokens Tokens per Ether in prefunding
242     function setPreFundingtokens(uint256 _preFundingtokens) public stopIfHalted onlyOwner {
243         preFundingtokens = _preFundingtokens;
244     }
245 
246     //'owner' can set number of tokens per Ether in funding
247     // @param _fundingTokens Tokens per Ether in funding
248     function setFundingtokens(uint256 _fundingTokens) public stopIfHalted onlyOwner {
249         fundingTokens = _fundingTokens;
250     }
251 
252     //Owner can Set Multisig wallet
253     //@ param _multisig address of Multisig wallet.
254     function setMultisigWallet(address _multisig) onlyOwner public {
255         require(_multisig != 0);
256         multisig = _multisig;
257     }
258 
259     //Owner can Set TokenVault
260     //@ param _vault address of TokenVault.
261     function setMiBoodleVault(address _vault) onlyOwner public {
262         require(_vault != 0);
263         vault = _vault;
264     }
265 
266     //owner can call to allocate tokens to investor who invested in other currencies
267     //@ param _investor address of investor
268     //@ param _tokens number of tokens to give to investor
269     function cashInvestment(address _investor,uint256 _tokens) onlyOwner stopIfHalted external {
270         //validate address
271         require(_investor != 0);
272         //not allow with tokens 0
273         require(_tokens > 0);
274         //not allow if crowdsale ends.
275         require(now >= preFundingStart && now <= end);
276         if (now < start && now >= preFundingStart) {
277             //total supply should not be greater than max token sale for pre funding
278             require(safeAdd(totalSupply, _tokens) <= maxTokenForPreSale);
279         } else {
280             //total supply should not be greater than max token sale
281             require(safeAdd(totalSupply, _tokens) <= maxTokenSale);
282         }
283         //Call internal method to assign tokens
284         assignTokens(_investor,_tokens);
285     }
286 
287     // transfer the tokens to investor's address
288     // Common function code for cashInvestment and Crowdsale Investor
289     function assignTokens(address _investor, uint256 _tokens) internal {
290         // Creating tokens and  increasing the totalSupply
291         totalSupply = safeAdd(totalSupply,_tokens);
292         // Assign new tokens to the sender
293         balances[_investor] = safeAdd(balances[_investor],_tokens);
294         // Finally token created for sender, log the creation event
295         Allocate(_investor, _tokens);
296     }
297 
298     // Withdraw ether during pre-sale and sale 
299     function withdraw() external onlyOwner {
300         // Release only if token-sale not ended and multisig set
301         require(now <= end && multisig != address(0));
302         // Release only if not released anytime before
303         require(!isReleasedOnce);
304         // Release only if balance more then 200 ether
305         require(address(this).balance >= 200 ether);
306         // Set ether released once 
307         isReleasedOnce = true;
308         // Release 200 ether
309         assert(multisig.send(200 ether));
310     }
311 
312     //Finalize crowdsale and allocate tokens to multisig and vault
313     function finalizeCrowdSale() external {
314         require(!isCrowdSaleFinalized);
315         require(multisig != 0 && vault != 0 && now > end);
316         require(safeAdd(totalSupply,250000000 ether) <= maxTokenSupply);
317         assignTokens(multisig, 250000000 ether);
318         require(safeAdd(totalSupply,150000000 ether) <= maxTokenSupply);
319         assignTokens(vault, 150000000 ether);
320         isCrowdSaleFinalized = true;
321         require(multisig.send(address(this).balance));
322     }
323 
324     //fallback function to accept ethers
325     function() payable stopIfHalted external {
326         //not allow if crowdsale ends.
327         require(now <= end && now >= preFundingStart);
328         //not allow to invest with less then minimum investment value
329         require(msg.value >= minInvest);
330         //not allow to invest with more then maximum investment value
331         require(safeAdd(investment[msg.sender],msg.value) <= maxInvest);
332 
333         //Hold created tokens for current state of funding
334         uint256 createdTokens;
335         if (now < start) {
336             createdTokens = safeMul(msg.value,preFundingtokens);
337             //total supply should not be greater than max token sale for pre funding
338             require(safeAdd(totalSupply, createdTokens) <= maxTokenForPreSale);
339         } else {
340             createdTokens = safeMul(msg.value,fundingTokens);
341             //total supply should not greater than maximum token to supply 
342             require(safeAdd(totalSupply, createdTokens) <= maxTokenSale);
343         }
344 
345         // Add investment details of investor
346         investment[msg.sender] = safeAdd(investment[msg.sender],msg.value);
347         
348         //call internal method to assign tokens
349         assignTokens(msg.sender,createdTokens);
350         Deposit(msg.sender,createdTokens);
351     }
352 
353     // @param _who The address of the investor to check balance
354     // @return balance tokens of investor address
355     function balanceOf(address _who) public constant returns (uint) {
356         return balances[_who];
357     }
358 
359     // @param _owner The address of the account owning tokens
360     // @param _spender The address of the account able to transfer the tokens
361     // @return Amount of remaining tokens allowed to spent
362     function allowance(address _owner, address _spender) public constant returns (uint) {
363         return allowed[_owner][_spender];
364     }
365 
366     // @param _owner The address of the account owning tokens
367     // @param _spender The address of the account able to transfer the tokens
368     // @return Amount of remaining tokens allowed to spent
369     function allowanceToBurn(address _owner, address _spender) public constant returns (uint) {
370         return allowedToBurn[_owner][_spender];
371     }
372 
373     //  Transfer `value` miBoodle tokens from sender's account
374     // `msg.sender` to provided account address `to`.
375     // @param _to The address of the recipient
376     // @param _value The number of miBoodle tokens to transfer
377     // @return Whether the transfer was successful or not
378     function transfer(address _to, uint _value) public returns (bool ok) {
379         //allow only if transfer is enable
380         require(isTransferEnable);
381         //require(now >= end);
382         //validate receiver address and value.Not allow 0 value
383         require(_to != 0 && _value > 0);
384         uint256 senderBalance = balances[msg.sender];
385         //Check sender have enough balance
386         require(senderBalance >= _value);
387         senderBalance = safeSub(senderBalance, _value);
388         balances[msg.sender] = senderBalance;
389         balances[_to] = safeAdd(balances[_to],_value);
390         Transfer(msg.sender, _to, _value);
391         return true;
392     }
393 
394     //  Transfer `value` miBoodle tokens from sender 'from'
395     // to provided account address `to`.
396     // @param from The address of the sender
397     // @param to The address of the recipient
398     // @param value The number of miBoodle to transfer
399     // @return Whether the transfer was successful or not
400     function transferFrom(address _from, address _to, uint _value) public returns (bool ok) {
401         //allow only if transfer is enable
402         require(isTransferEnable);
403         //require(now >= end);
404         //validate _from,_to address and _value(Not allow with 0)
405         require(_from != 0 && _to != 0 && _value > 0);
406         //Check amount is approved by the owner for spender to spent and owner have enough balances
407         require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value);
408         balances[_from] = safeSub(balances[_from],_value);
409         balances[_to] = safeAdd(balances[_to],_value);
410         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);
411         Transfer(_from, _to, _value);
412         return true;
413     }
414 
415     //  `msg.sender` approves `spender` to spend `value` tokens
416     // @param spender The address of the account able to transfer the tokens
417     // @param value The amount of wei to be approved for transfer
418     // @return Whether the approval was successful or not
419     function approve(address _spender, uint _value) public returns (bool ok) {
420         //validate _spender address
421         require(_spender != 0);
422         allowed[msg.sender][_spender] = _value;
423         Approval(msg.sender, _spender, _value);
424         return true;
425     }
426 
427     //  `msg.sender` approves `_canBurn` to burn `value` tokens
428     // @param _canBurn The address of the account able to burn the tokens
429     // @param _value The amount of wei to be approved for burn
430     // @return Whether the approval was successful or not
431     function approveForBurn(address _canBurn, uint _value) public returns (bool ok) {
432         //validate _spender address
433         require(_canBurn != 0);
434         allowedToBurn[msg.sender][_canBurn] = _value;
435         ApproveBurner(msg.sender, _canBurn, _value);
436         return true;
437     }
438 
439     //  Burn `value` miBoodle tokens from sender's account
440     // `msg.sender` to provided _value.
441     // @param _value The number of miBoodle tokens to destroy
442     // @return Whether the Burn was successful or not
443     function burn(uint _value) public returns (bool ok) {
444         //allow only if transfer is enable
445         require(now >= end);
446         //validate receiver address and value.Now allow 0 value
447         require(_value > 0);
448         uint256 senderBalance = balances[msg.sender];
449         require(senderBalance >= _value);
450         senderBalance = safeSub(senderBalance, _value);
451         balances[msg.sender] = senderBalance;
452         totalSupply = safeSub(totalSupply,_value);
453         Burn(msg.sender, _value);
454         return true;
455     }
456 
457     //  Burn `value` miBoodle tokens from sender 'from'
458     // to provided account address `to`.
459     // @param from The address of the burner
460     // @param to The address of the token holder from token to burn
461     // @param value The number of miBoodle to burn
462     // @return Whether the transfer was successful or not
463     function burnFrom(address _from, uint _value) public returns (bool ok) {
464         //allow only if transfer is enable
465         require(now >= end);
466         //validate _from,_to address and _value(Now allow with 0)
467         require(_from != 0 && _value > 0);
468         //Check amount is approved by the owner to burn and owner have enough balances
469         require(allowedToBurn[_from][msg.sender] >= _value && balances[_from] >= _value);
470         balances[_from] = safeSub(balances[_from],_value);
471         totalSupply = safeSub(totalSupply,_value);
472         allowedToBurn[_from][msg.sender] = safeSub(allowedToBurn[_from][msg.sender],_value);
473         BurnFrom(_from, _value);
474         return true;
475     }
476 
477     // Token upgrade functionality
478 
479     /// @notice Upgrade tokens to the new token contract.
480     /// @param value The number of tokens to upgrade
481     function upgrade(uint256 value) external {
482         /*if (getState() != State.Success) throw; // Abort if not in Success state.*/
483         require(upgradeAgentStatus); // need a real upgradeAgent address
484 
485         // Validate input value.
486         require (value > 0 && upgradeAgent.owner() != 0x0);
487         require (value <= balances[msg.sender]);
488 
489         // update the balances here first before calling out (reentrancy)
490         balances[msg.sender] = safeSub(balances[msg.sender], value);
491         totalSupply = safeSub(totalSupply, value);
492         totalUpgraded = safeAdd(totalUpgraded, value);
493         upgradeAgent.upgradeFrom(msg.sender, value);
494         Upgrade(msg.sender, upgradeAgent, value);
495     }
496 
497     /// @notice Set address of upgrade target contract and enable upgrade
498     /// process.
499     /// @param agent The address of the UpgradeAgent contract
500     function setUpgradeAgent(address agent) external onlyOwner {
501         require(agent != 0x0 && msg.sender == upgradeMaster);
502         upgradeAgent = UpgradeAgent(agent);
503         require (upgradeAgent.isUpgradeAgent());
504         // this needs to be called in success condition to guarantee the invariant is true
505         upgradeAgentStatus = true;
506         upgradeAgent.setOriginalSupply();
507         UpgradeAgentSet(upgradeAgent);
508     }
509 
510     /// @notice Set address of upgrade target contract and enable upgrade
511     /// process.
512     /// @param master The address that will manage upgrades, not the upgradeAgent contract address
513     function setUpgradeMaster(address master) external {
514         require (master != 0x0 && msg.sender == upgradeMaster);
515         upgradeMaster = master;
516     }
517 }