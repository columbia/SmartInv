1 pragma solidity ^0.4.13;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint a, uint b) internal returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint a, uint b) internal returns (uint) {
14     assert(b > 0);
15     uint c = a / b;
16     assert(a == b * c + a % b);
17     return c;
18   }
19 
20   function sub(uint a, uint b) internal returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint a, uint b) internal returns (uint) {
26     uint c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47   function assert(bool assertion) internal {
48     if (!assertion) {
49       revert();
50     }
51   }
52 }
53 
54 /**
55  * @title ERC20Basic
56  * @dev Simpler version of ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/179
58  */
59 contract ERC20Basic {
60     uint256 public totalSupply;
61     function balanceOf(address who) public constant returns (uint256);
62     function transfer(address to, uint256 value) public returns (bool);
63     event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 contract ERC20 is ERC20Basic {
72     function allowance(address owner, address spender) public constant returns (uint256);
73     function transferFrom(address from, address to, uint256 value) public returns (bool);
74     function approve(address spender, uint256 value) public returns (bool);
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 
79 /**
80  * @title Basic token
81  * @dev Basic version of StandardToken, with no allowances.
82  */
83 contract BasicToken is ERC20Basic {
84     using SafeMath for uint256;
85 
86     mapping(address => uint256) balances;
87 
88     /*
89      * Fix for the ERC20 short address attack
90      */
91     modifier onlyPayloadSize(uint size) {
92         if (msg.data.length < size + 4) {
93             revert();
94         }
95         _;
96     }
97 
98     /**
99     * @dev transfer token for a specified address
100     * @param _to The address to transfer to.
101     * @param _value The amount to be transferred.
102     */
103     function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32)  returns (bool) {
104         require(_to != address(0));
105         require(_value <= balances[msg.sender]);
106 
107         // SafeMath.sub will throw if there is not enough balance.
108         balances[msg.sender] = balances[msg.sender].sub(_value);
109         balances[_to] = balances[_to].add(_value);
110         Transfer(msg.sender, _to, _value);
111         return true;
112     }
113 
114     /**
115     * @dev Gets the balance of the specified address.
116     * @param _owner The address to query the the balance of.
117     * @return An uint256 representing the amount owned by the passed address.
118     */
119     function balanceOf(address _owner) public constant returns (uint256 balance) {
120         return balances[_owner];
121     }
122 
123 }
124 
125 
126 contract Ownable {
127   address public owner;
128 
129   function Ownable() {
130     owner = msg.sender;
131   }
132 
133   modifier onlyOwner() {
134     if (msg.sender != owner) {
135       revert();
136     }
137     _;
138   }
139 }
140 
141 /**
142  * @title Standard ERC20 token
143  *
144  * @dev Implementation of the basic standard token.
145  * @dev https://github.com/ethereum/EIPs/issues/20
146  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
147  */
148 contract StandardToken is ERC20, BasicToken {
149 
150     mapping (address => mapping (address => uint256)) internal allowed;
151 
152     /**
153     * @dev Transfer tokens from one address to another
154     * @param _from address The address which you want to send tokens from
155     * @param _to address The address which you want to transfer to
156     * @param _value uint256 the amount of tokens to be transferred
157     */
158     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
159         require(_to != address(0));
160         require(_value <= balances[_from]);
161         require(_value <= allowed[_from][msg.sender]);
162 
163         balances[_from] = balances[_from].sub(_value);
164         balances[_to] = balances[_to].add(_value);
165         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
166         Transfer(_from, _to, _value);
167         return true;
168     }
169 
170     /**
171     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
172     *
173     * Beware that changing an allowance with this method brings the risk that someone may use both the old
174     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
175     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
176     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177     * @param _spender The address which will spend the funds.
178     * @param _value The amount of tokens to be spent.
179     */
180     function approve(address _spender, uint256 _value) public returns (bool) {
181         allowed[msg.sender][_spender] = _value;
182         Approval(msg.sender, _spender, _value);
183         return true;
184     }
185 
186     /**
187     * @dev Function to check the amount of tokens that an owner allowed to a spender.
188     * @param _owner address The address which owns the funds.
189     * @param _spender address The address which will spend the funds.
190     * @return A uint256 specifying the amount of tokens still available for the spender.
191     */
192     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
193         return allowed[_owner][_spender];
194     }
195 
196 }
197 
198 
199 contract RBInformationStore is Ownable {
200     address public profitContainerAddress;
201     address public companyWalletAddress;
202     uint public etherRatioForOwner;
203     address public multiSigAddress;
204     address public accountAddressForSponsee;
205     bool public isPayableEnabledForAll = true;
206 
207     modifier onlyMultiSig() {
208         require(multiSigAddress == msg.sender);
209         _;
210     }
211 
212     function RBInformationStore
213     (
214         address _profitContainerAddress,
215         address _companyWalletAddress,
216         uint _etherRatioForOwner,
217         address _multiSigAddress,
218         address _accountAddressForSponsee
219     ) {
220         profitContainerAddress = _profitContainerAddress;
221         companyWalletAddress = _companyWalletAddress;
222         etherRatioForOwner = _etherRatioForOwner;
223         multiSigAddress = _multiSigAddress;
224         accountAddressForSponsee = _accountAddressForSponsee;
225     }
226 
227     function changeProfitContainerAddress(address _address) onlyMultiSig {
228         profitContainerAddress = _address;
229     }
230 
231     function changeCompanyWalletAddress(address _address) onlyMultiSig {
232         companyWalletAddress = _address;
233     }
234 
235     function changeEtherRatioForOwner(uint _value) onlyMultiSig {
236         etherRatioForOwner = _value;
237     }
238 
239     function changeMultiSigAddress(address _address) onlyMultiSig {
240         multiSigAddress = _address;
241     }
242 
243     function changeOwner(address _address) onlyMultiSig {
244         owner = _address;
245     }
246 
247     function changeAccountAddressForSponsee(address _address) onlyMultiSig {
248         accountAddressForSponsee = _address;
249     }
250 
251     function changeIsPayableEnabledForAll() onlyMultiSig {
252         isPayableEnabledForAll = !isPayableEnabledForAll;
253     }
254 }
255 
256 
257 contract Rate {
258     uint public ETH_USD_rate;
259     RBInformationStore public rbInformationStore;
260 
261     modifier onlyOwner() {
262         require(msg.sender == rbInformationStore.owner());
263         _;
264     }
265 
266     function Rate(uint _rate, address _address) {
267         ETH_USD_rate = _rate;
268         rbInformationStore = RBInformationStore(_address);
269     }
270 
271     function setRate(uint _rate) onlyOwner {
272         ETH_USD_rate = _rate;
273     }
274 }
275 
276 
277 
278 /**
279 @title SponseeTokenModel
280 */
281 contract SponseeTokenModel is StandardToken {
282 
283     string public name;
284     string public symbol;
285     uint8 public decimals = 0;
286     uint public totalSupply = 0;
287     uint public cap = 100000000;                    // maximum cap = 1 000 000 $ = 100 000 000 tokens
288     uint public minimumSupport = 500;               // minimum support is 5$(500 cents)
289     uint public etherRatioForInvestor = 10;         // etherRatio (10%) to send ether to investor
290     address public sponseeAddress;
291     bool public isPayableEnabled = true;
292     RBInformationStore public rbInformationStore;
293     Rate public rate;
294 
295     event LogReceivedEther(address indexed from, address indexed to, uint etherValue, string tokenName);
296     event LogBuy(address indexed from, address indexed to, uint indexed value, uint paymentId);
297     event LogRollbackTransfer(address indexed from, address indexed to, uint value);
298     event LogExchange(address indexed from, address indexed token, uint value);
299     event LogIncreaseCap(uint value);
300     event LogDecreaseCap(uint value);
301     event LogSetRBInformationStoreAddress(address indexed to);
302     event LogSetName(string name);
303     event LogSetSymbol(string symbol);
304     event LogMint(address indexed to, uint value);
305     event LogChangeSponseeAddress(address indexed to);
306     event LogChangeIsPayableEnabled(bool flag);
307 
308     modifier onlyAccountAddressForSponsee() {
309         require(rbInformationStore.accountAddressForSponsee() == msg.sender);
310         _;
311     }
312 
313     modifier onlyMultiSig() {
314         require(rbInformationStore.multiSigAddress() == msg.sender);
315         _;
316     }
317 
318     // constructor
319     function SponseeTokenModel(
320         string _name,
321         string _symbol,
322         address _rbInformationStoreAddress,
323         address _rateAddress,
324         address _sponsee
325     ) {
326         name = _name;
327         symbol = _symbol;
328         rbInformationStore = RBInformationStore(_rbInformationStoreAddress);
329         rate = Rate(_rateAddress);
330         sponseeAddress = _sponsee;
331     }
332 
333     /**
334     @notice Receive ether from any EOA accounts. Amount of ether received in this function is distributed to 3 parts.
335     One is a profitContainerAddress which is address of containerWallet to dividend to investor of Boost token.
336     Another is an ownerAddress which is address of owner of REALBOOST site.
337     The other is an sponseeAddress which is address of owner of this contract.
338     Then, return token of this contract to msg.sender related to the amount of ether that msg.sender sent and rate (US cent) of ehter stored in Rate contract.
339     */
340     function() payable {
341 
342         // check condition
343         require(isPayableEnabled && rbInformationStore.isPayableEnabledForAll());
344 
345         // check validation
346         if (msg.value <= 0) { revert(); }
347 
348         // calculate support amount in US
349         uint supportedAmount = msg.value.mul(rate.ETH_USD_rate()).div(10**18);
350 
351         // if support is less than minimum => return money to supporter
352         if (supportedAmount < minimumSupport) { revert(); }
353 
354         // calculate the ratio of Ether for distribution
355         uint etherRatioForOwner = rbInformationStore.etherRatioForOwner();
356         uint etherRatioForSponsee = uint(100).sub(etherRatioForOwner).sub(etherRatioForInvestor);
357 
358         /* divide Ether */
359         // calculate
360         uint etherForOwner = msg.value.mul(etherRatioForOwner).div(100);
361         uint etherForInvestor = msg.value.mul(etherRatioForInvestor).div(100);
362         uint etherForSponsee = msg.value.mul(etherRatioForSponsee).div(100);
363 
364         // get address
365         address profitContainerAddress = rbInformationStore.profitContainerAddress();
366         address companyWalletAddress = rbInformationStore.companyWalletAddress();
367 
368         // send Ether
369         if (!profitContainerAddress.send(etherForInvestor)) { revert(); }
370         if (!companyWalletAddress.send(etherForOwner)) { revert(); }
371         if (!sponseeAddress.send(etherForSponsee)) { revert(); }
372 
373         // token amount is transfered to sender
374         // 1 token = 1 cent, 1 usd = 100 cents
375         uint tokenAmount = msg.value.mul(rate.ETH_USD_rate()).div(10**18);
376 
377         // add tokens
378         balances[msg.sender] = balances[msg.sender].add(tokenAmount);
379 
380         // increase total supply
381         totalSupply = totalSupply.add(tokenAmount);
382 
383         // check cap
384         if (totalSupply > cap) { revert(); }
385 
386         // send Event
387         LogExchange(msg.sender, this, tokenAmount);
388         LogReceivedEther(msg.sender, this, msg.value, name);
389         Transfer(address(0x0), msg.sender, tokenAmount);
390     }
391 
392     /**
393     @notice Change rbInformationStoreAddress.
394     @param _address The address of new rbInformationStore
395     */
396     function setRBInformationStoreAddress(address _address) onlyMultiSig {
397 
398         rbInformationStore = RBInformationStore(_address);
399 
400         // send Event
401         LogSetRBInformationStoreAddress(_address);
402     }
403 
404     /**
405     @notice Change name.
406     @param _name The new name of token
407     */
408     function setName(string _name) onlyAccountAddressForSponsee {
409 
410         name = _name;
411 
412         // send Event
413         LogSetName(_name);
414     }
415 
416     /**
417     @notice Change symbol.
418     @param _symbol The new symbol of token
419     */
420     function setSymbol(string _symbol) onlyAccountAddressForSponsee {
421 
422         symbol = _symbol;
423 
424         // send Event
425         LogSetSymbol(_symbol);
426     }
427 
428     /**
429     @notice Mint new token amount.
430     @param _address The address that new token amount is added
431     @param _value The new amount of token
432     */
433     function mint(address _address, uint _value) onlyAccountAddressForSponsee {
434 
435         // add tokens
436         balances[_address] = balances[_address].add(_value);
437 
438         // increase total supply
439         totalSupply = totalSupply.add(_value);
440 
441         // check cap
442         if (totalSupply > cap) { revert(); }
443 
444         // send Event
445         LogMint(_address, _value);
446         Transfer(address(0x0), _address, _value);
447     }
448 
449     /**
450     @notice Increase cap.
451     @param _value The amount of token that should be increased
452     */
453     function increaseCap(uint _value) onlyAccountAddressForSponsee {
454 
455         // change cap here
456         cap = cap.add(_value);
457 
458         // send Event
459         LogIncreaseCap(_value);
460     }
461 
462     /**
463     @notice Decrease cap.
464     @param _value The amount of token that should be decreased
465     */
466     function decreaseCap(uint _value) onlyAccountAddressForSponsee {
467 
468         // check whether cap is lower than totalSupply or not
469         if (totalSupply > cap.sub(_value)) { revert(); }
470 
471         // change cap here
472         cap = cap.sub(_value);
473 
474         // send Event
475         LogDecreaseCap(_value);
476     }
477 
478     /**
479     @notice Rollback transfer.
480     @param _from The EOA address for rollback transfer
481     @param _to The EOA address for rollback transfer
482     @param _value The number of token for rollback transfer
483     */
484     function rollbackTransfer(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) onlyMultiSig {
485 
486         balances[_to] = balances[_to].sub(_value);
487         balances[_from] = balances[_from].add(_value);
488 
489         // send Event
490         LogRollbackTransfer(_from, _to, _value);
491         Transfer(_from, _to, _value);
492     }
493 
494     /**
495     @notice Transfer from msg.sender for downloading of content.
496     @param _to The EOA address for buy content
497     @param _value The number of token for buy content
498     @param _paymentId The id of content which msg.sender want to buy
499     */
500     function buy(address _to, uint _value, uint _paymentId) {
501 
502         transfer(_to, _value);
503 
504         // send Event
505         LogBuy(msg.sender, _to, _value, _paymentId);
506     }
507 
508     /**
509     @notice This method will change old sponsee address with a new one.
510     @param _newAddress new address is set
511     */
512     function changeSponseeAddress(address _newAddress) onlyAccountAddressForSponsee {
513 
514         sponseeAddress = _newAddress;
515 
516         // send Event
517         LogChangeSponseeAddress(_newAddress);
518     }
519 
520     /**
521     @notice This method will change isPayableEnabled flag.
522     */
523     function changeIsPayableEnabled() onlyMultiSig {
524 
525         isPayableEnabled = !isPayableEnabled;
526 
527         // send Event
528         LogChangeIsPayableEnabled(isPayableEnabled);
529     }
530 }