1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6   function Ownable() {
7     owner = msg.sender;
8   }
9 
10   modifier onlyOwner() {
11     if (msg.sender != owner) {
12       revert();
13     }
14     _;
15   }
16 }
17 
18 contract RBInformationStore is Ownable {
19     address public profitContainerAddress;
20     address public companyWalletAddress;
21     uint public etherRatioForOwner;
22     address public multisig;
23 
24     function RBInformationStore(address _profitContainerAddress, address _companyWalletAddress, uint _etherRatioForOwner, address _multisig) {
25         profitContainerAddress = _profitContainerAddress;
26         companyWalletAddress = _companyWalletAddress;
27         etherRatioForOwner = _etherRatioForOwner;
28         multisig = _multisig;
29     }
30 
31     function setProfitContainerAddress(address _address)  {
32         require(multisig == msg.sender);
33         if(_address != 0x0) {
34             profitContainerAddress = _address;
35         }
36     }
37 
38     function setCompanyWalletAddress(address _address)  {
39         require(multisig == msg.sender);
40         if(_address != 0x0) {
41             companyWalletAddress = _address;
42         }
43     }
44 
45     function setEtherRatioForOwner(uint _value)  {
46         require(multisig == msg.sender);
47         if(_value != 0) {
48             etherRatioForOwner = _value;
49         }
50     }
51 
52     function changeMultiSig(address newAddress){
53         require(multisig == msg.sender);
54         multisig = newAddress;
55     }
56 
57     function changeOwner(address newOwner){
58         require(multisig == msg.sender);
59         owner = newOwner;
60     }
61 }
62 
63 /**
64  * Math operations with safety checks
65  */
66 library SafeMath {
67   function mul(uint a, uint b) internal returns (uint) {
68     uint c = a * b;
69     assert(a == 0 || c / a == b);
70     return c;
71   }
72 
73   function div(uint a, uint b) internal returns (uint) {
74     assert(b > 0);
75     uint c = a / b;
76     assert(a == b * c + a % b);
77     return c;
78   }
79 
80   function sub(uint a, uint b) internal returns (uint) {
81     assert(b <= a);
82     return a - b;
83   }
84 
85   function add(uint a, uint b) internal returns (uint) {
86     uint c = a + b;
87     assert(c >= a);
88     return c;
89   }
90 
91   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
92     return a >= b ? a : b;
93   }
94 
95   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
96     return a < b ? a : b;
97   }
98 
99   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
100     return a >= b ? a : b;
101   }
102 
103   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
104     return a < b ? a : b;
105   }
106 
107   function assert(bool assertion) internal {
108     if (!assertion) {
109       revert();
110     }
111   }
112 }
113 
114 /*
115  * ERC20Basic
116  * Simpler version of ERC20 interface
117  * see https://github.com/ethereum/EIPs/issues/20
118  */
119 contract ERC20Basic {
120   uint public totalSupply;
121   function balanceOf(address who) constant returns (uint);
122   function transfer(address to, uint value);
123   event Transfer(address indexed from, address indexed to, uint value);
124 }
125 
126 /*
127  * ERC20 interface
128  * see https://github.com/ethereum/EIPs/issues/20
129  */
130 contract ERC20 is ERC20Basic {
131   function allowance(address owner, address spender) constant returns (uint);
132   function transferFrom(address from, address to, uint value);
133   function approve(address spender, uint value);
134   event Approval(address indexed owner, address indexed spender, uint value);
135 }
136 
137 /*
138  * Basic token
139  * Basic version of StandardToken, with no allowances
140  */
141 contract BasicToken is ERC20Basic {
142   using SafeMath for uint;
143 
144   mapping(address => uint) balances;
145 
146   /*
147    * Fix for the ERC20 short address attack
148    */
149   modifier onlyPayloadSize(uint size) {
150      if(msg.data.length < size + 4) {
151        revert();
152      }
153      _;
154   }
155 
156   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
157     balances[msg.sender] = balances[msg.sender].sub(_value);
158     balances[_to] = balances[_to].add(_value);
159     Transfer(msg.sender, _to, _value);
160   }
161 
162   function balanceOf(address _owner) constant returns (uint balance) {
163     return balances[_owner];
164   }
165 
166 }
167 
168 /**
169  * Standard ERC20 token
170  *
171  * https://github.com/ethereum/EIPs/issues/20
172  * Based on code by FirstBlood:
173  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  */
175 contract StandardToken is BasicToken, ERC20 {
176 
177   mapping (address => mapping (address => uint)) allowed;
178 
179   function transferFrom(address _from, address _to, uint _value) {
180     var _allowance = allowed[_from][msg.sender];
181 
182     // Check is not needed because sub(_allowance, _value) will already revert() if this condition is not met
183     // if (_value > _allowance) revert();
184 
185     balances[_to] = balances[_to].add(_value);
186     balances[_from] = balances[_from].sub(_value);
187     allowed[_from][msg.sender] = _allowance.sub(_value);
188     Transfer(_from, _to, _value);
189   }
190 
191   function approve(address _spender, uint _value) {
192     allowed[msg.sender][_spender] = _value;
193     Approval(msg.sender, _spender, _value);
194   }
195 
196   function allowance(address _owner, address _spender) constant returns (uint remaining) {
197     return allowed[_owner][_spender];
198   }
199 
200 }
201 
202 contract Rate {
203     uint public ETH_USD_rate;
204     RBInformationStore public rbInformationStore;
205 
206     modifier onlyOwner() {
207         if (msg.sender != rbInformationStore.owner()) {
208             revert();
209         }
210         _;
211     }
212 
213     function Rate(uint _rate, address _address) {
214         ETH_USD_rate = _rate;
215         rbInformationStore = RBInformationStore(_address);
216     }
217 
218     function setRate(uint _rate) onlyOwner {
219         ETH_USD_rate = _rate;
220     }
221 }
222 
223 /**
224 @title SponseeTokenModelSolaCoin
225 @dev TODO add contract code of three contract above when deploy to mainnet
226 */
227 contract SponseeTokenModelSolaCoin is StandardToken {
228 
229     string public name = "SOLA COIN";
230     uint8 public decimals = 18;
231     string public symbol = "SLC";
232     uint public totalSupply = 500000000 * (10 ** uint256(decimals));
233     uint public cap = 1000000000 * (10 ** uint256(decimals)); // maximum cap = 10 000 000 $ = 1 000 000 000 tokens
234     RBInformationStore public rbInformationStore;
235     Rate public rate;
236     uint public minimumSupport = 500; // minimum support is 5$
237     uint public etherRatioForInvestor = 10; // etherRatio (10%) to send ether to investor
238     address public sponseeAddress;
239     address public multiSigAddress; // account controls transfer ether/token and change multisig address
240     address public accountAddressForSponseeAddress; // account controls sponsee address to receive ether
241     bool public isPayableEnabled = false;
242 
243     event LogReceivedEther(address indexed from, address indexed to, uint etherValue, string tokenName);
244     event LogTransferFromOwner(address indexed from, address indexed to, uint tokenValue, uint etherValue, uint rateUSDETH);
245     event LogBuy(address indexed from, address indexed to, uint indexed value, uint paymentId);
246     event LogRollbackTransfer(address indexed from, address indexed to, uint value);
247     event LogExchange(address indexed from, address indexed token, uint value);
248     event LogIncreaseCap(uint value);
249     event LogDecreaseCap(uint value);
250     event LogSetRBInformationStoreAddress(address indexed to);
251     event LogSetName(string name);
252     event LogSetSymbol(string symbol);
253     event LogMint(address indexed to, uint value);
254     event LogChangeMultiSigAddress(address indexed to);
255     event LogChangeAccountAddressForSponseeAddress(address indexed to);
256     event LogChangeSponseeAddress(address indexed to);
257     event LogChangeIsPayableEnabled();
258 
259     modifier onlyOwner() {
260         if (msg.sender != rbInformationStore.owner()) {
261             revert();
262         }
263         _;
264     }
265 
266     // constructor
267     function SponseeTokenModelSolaCoin(
268         address _rbInformationStoreAddress,
269         address _rateAddress,
270         address _sponsee,
271         address _multiSig,
272         address _accountForSponseeAddress,
273         address _to
274     ) {
275         rbInformationStore = RBInformationStore(_rbInformationStoreAddress);
276         rate = Rate(_rateAddress);
277         sponseeAddress = _sponsee;
278         multiSigAddress = _multiSig;
279         accountAddressForSponseeAddress = _accountForSponseeAddress;
280         balances[_to] = totalSupply;
281     }
282 
283     /**
284     @notice Receive ether from any EOA accounts. Amount of ether received in this function is distributed to 3 parts.
285     One is a profitContainerAddress which is address of containerWallet to dividend to investor of Boost token.
286     Another is an ownerAddress which is address of owner of REALBOOST site.
287     The other is an sponseeAddress which is address of owner of this contract.
288     */
289     function() payable {
290         // check condition
291         require(isPayableEnabled);
292 
293         // check validation
294         if(msg.value <= 0) { revert(); }
295 
296         // calculate support amount in USD
297         uint supportedAmount = msg.value.mul(rate.ETH_USD_rate()).div(10**18);
298         // if support is less than minimum => return money to supporter
299         if(supportedAmount < minimumSupport) { revert(); }
300 
301         // calculate the ratio of Ether for distribution
302         uint etherRatioForOwner = rbInformationStore.etherRatioForOwner();
303         uint etherRatioForSponsee = uint(100).sub(etherRatioForOwner).sub(etherRatioForInvestor);
304 
305         /* divide Ether */
306         // calculate
307         uint etherForOwner = msg.value.mul(etherRatioForOwner).div(100);
308         uint etherForInvestor = msg.value.mul(etherRatioForInvestor).div(100);
309         uint etherForSponsee = msg.value.mul(etherRatioForSponsee).div(100);
310 
311         // get address
312         address profitContainerAddress = rbInformationStore.profitContainerAddress();
313         address companyWalletAddress = rbInformationStore.companyWalletAddress();
314 
315         // send Ether
316         if(!profitContainerAddress.send(etherForInvestor)) { revert(); }
317         if(!companyWalletAddress.send(etherForOwner)) { revert(); }
318         if(!sponseeAddress.send(etherForSponsee)) { revert(); }
319 
320         // token amount is transfered to sender
321         // 1.0 token = 1 cent, 1 usd = 100 cents
322         // wei * US$/(10 ** 18 wei) * 100 cent/US$ * (10 ** 18(decimals))
323         uint tokenAmount = msg.value.mul(rate.ETH_USD_rate());
324 
325         // add tokens
326         balances[msg.sender] = balances[msg.sender].add(tokenAmount);
327 
328         // increase total supply
329         totalSupply = totalSupply.add(tokenAmount);
330 
331         // check cap
332         if(totalSupply > cap) { revert(); }
333 
334         // send exchange event
335         LogExchange(msg.sender, this, tokenAmount);
336 
337         // send Event
338         LogReceivedEther(msg.sender, this, msg.value, name);
339 
340         // tranfer event
341         Transfer(address(0x0), msg.sender, tokenAmount);
342     }
343 
344     /**
345     @notice Change rbInformationStoreAddress.
346     @param _address The address of new rbInformationStore
347     */
348     function setRBInformationStoreAddress(address _address) {
349         // check sender is multisig address
350         require(multiSigAddress == msg.sender);
351 
352         rbInformationStore = RBInformationStore(_address);
353 
354         LogSetRBInformationStoreAddress(_address);
355     }
356 
357     /**
358     @notice Change name.
359     @param _name The new name of token
360     */
361     function setName(string _name) onlyOwner {
362         name = _name;
363 
364         LogSetName(_name);
365     }
366 
367     /**
368     @notice Change symbol.
369     @param _symbol The new symbol of token
370     */
371     function setSymbol(string _symbol) onlyOwner {
372         symbol = _symbol;
373 
374         LogSetSymbol(_symbol);
375     }
376 
377     /**
378     @notice Mint new token amount.
379     @param _address The address that new token amount is added
380     @param _value The new amount of token
381     */
382     function mint(address _address, uint _value) {
383 
384         // check sender is multisig address
385         require(multiSigAddress == msg.sender);
386 
387         // add tokens
388         balances[_address] = balances[_address].add(_value);
389 
390         // increase total supply
391         totalSupply = totalSupply.add(_value);
392 
393         // check cap
394         if(totalSupply > cap) { revert(); }
395 
396         LogMint(_address, _value);
397 
398         // tranfer event
399         Transfer(address(0x0), _address, _value);
400     }
401 
402     /**
403     @notice Increase cap.
404     @param _value The amount of token that should be increased
405     */
406     function increaseCap(uint _value) onlyOwner {
407         // change cap here
408         cap = cap.add(_value);
409 
410         LogIncreaseCap(_value);
411     }
412 
413     /**
414     @notice Decrease cap.
415     @param _value The amount of token that should be decreased
416     */
417     function decreaseCap(uint _value) onlyOwner {
418         // check whether cap is lower than totalSupply or not
419         if(totalSupply > cap.sub(_value)) { revert(); }
420         // change cap here
421         cap = cap.sub(_value);
422 
423         LogDecreaseCap(_value);
424     }
425 
426     /**
427     @notice Rollback transfer.
428     @param _from The EOA address for rollback transfer
429     @param _to The EOA address for rollback transfer
430     @param _value The number of token for rollback transfer
431     */
432     function rollbackTransfer(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
433         // check sender is multisig address
434         require(multiSigAddress == msg.sender);
435 
436         balances[_to] = balances[_to].sub(_value);
437         balances[_from] = balances[_from].add(_value);
438 
439         LogRollbackTransfer(_from, _to, _value);
440 
441         // tranfer event
442         Transfer(_from, _to, _value);
443     }
444 
445     /**
446     @notice Transfer from msg.sender for downloading of content.
447     @param _to The EOA address for buy content
448     @param _value The number of token for buy content
449     @param _paymentId The id of content which msg.sender want to buy
450     */
451     function buy(address _to, uint _value, uint _paymentId) {
452         transfer(_to, _value);
453 
454         LogBuy(msg.sender, _to, _value, _paymentId);
455     }
456 
457     /**
458     @notice This method will change old multi signature address with new one.
459     @param _newAddress new address is set
460     */
461     function changeMultiSigAddress(address _newAddress) {
462         // check sender is multisig address
463         require(multiSigAddress == msg.sender);
464 
465         multiSigAddress = _newAddress;
466 
467         LogChangeMultiSigAddress(_newAddress);
468 
469     }
470 
471     /**
472     @notice This method will change old multi signature for sponsee address with new one.
473     @param _newAddress new address is set
474     */
475     function changeAccountAddressForSponseeAddress(address _newAddress) {
476         // check sender is account for changing sponsee address
477         require(accountAddressForSponseeAddress == msg.sender);
478 
479         accountAddressForSponseeAddress = _newAddress;
480 
481         LogChangeAccountAddressForSponseeAddress(_newAddress);
482 
483     }
484 
485     /**
486     @notice This method will change old sponsee address with new one.
487     @param _newAddress new address is set
488     */
489     function changeSponseeAddress(address _newAddress) {
490         // check sender is account for changing sponsee address
491         require(accountAddressForSponseeAddress == msg.sender);
492 
493         sponseeAddress = _newAddress;
494 
495         LogChangeSponseeAddress(_newAddress);
496 
497     }
498 
499     /**
500     @notice This method will change isPayableEnabled flag.
501     */
502     function changeIsPayableEnabled() {
503         // check sender is multisig address
504         require(multiSigAddress == msg.sender);
505 
506         isPayableEnabled = !isPayableEnabled;
507 
508         LogChangeIsPayableEnabled();
509 
510     }
511 }