1 pragma solidity ^0.4.13;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) internal returns (uint) {
15     assert(b > 0);
16     uint c = a / b;
17     assert(a == b * c + a % b);
18     return c;
19   }
20 
21   function sub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 
48   function assert(bool assertion) internal {
49     if (!assertion) {
50       revert();
51     }
52   }
53 }
54 
55 /*
56  * ERC20Basic
57  * Simpler version of ERC20 interface
58  * see https://github.com/ethereum/EIPs/issues/20
59  */
60 contract ERC20Basic {
61   uint public totalSupply;
62   function balanceOf(address who) constant returns (uint);
63   function transfer(address to, uint value);
64   event Transfer(address indexed from, address indexed to, uint value);
65 }
66 
67 /*
68  * ERC20 interface
69  * see https://github.com/ethereum/EIPs/issues/20
70  */
71 contract ERC20 is ERC20Basic {
72   function allowance(address owner, address spender) constant returns (uint);
73   function transferFrom(address from, address to, uint value);
74   function approve(address spender, uint value);
75   event Approval(address indexed owner, address indexed spender, uint value);
76 }
77 
78 /*
79  * Basic token
80  * Basic version of StandardToken, with no allowances
81  */
82 contract BasicToken is ERC20Basic {
83   using SafeMath for uint;
84 
85   mapping(address => uint) balances;
86 
87   /*
88    * Fix for the ERC20 short address attack
89    */
90   modifier onlyPayloadSize(uint size) {
91      if(msg.data.length < size + 4) {
92        revert();
93      }
94      _;
95   }
96 
97   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     Transfer(msg.sender, _to, _value);
101   }
102 
103   function balanceOf(address _owner) constant returns (uint balance) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 /**
110  * Standard ERC20 token
111  *
112  * https://github.com/ethereum/EIPs/issues/20
113  * Based on code by FirstBlood:
114  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
115  */
116 contract StandardToken is BasicToken, ERC20 {
117 
118   mapping (address => mapping (address => uint)) allowed;
119 
120   function transferFrom(address _from, address _to, uint _value) {
121     var _allowance = allowed[_from][msg.sender];
122 
123     // Check is not needed because sub(_allowance, _value) will already revert() if this condition is not met
124     // if (_value > _allowance) revert();
125 
126     balances[_to] = balances[_to].add(_value);
127     balances[_from] = balances[_from].sub(_value);
128     allowed[_from][msg.sender] = _allowance.sub(_value);
129     Transfer(_from, _to, _value);
130   }
131 
132   function approve(address _spender, uint _value) {
133     allowed[msg.sender][_spender] = _value;
134     Approval(msg.sender, _spender, _value);
135   }
136 
137   function allowance(address _owner, address _spender) constant returns (uint remaining) {
138     return allowed[_owner][_spender];
139   }
140 }
141 
142 contract Ownable {
143   address public owner;
144 
145   function Ownable() {
146     owner = msg.sender;
147   }
148 
149   modifier onlyOwner() {
150     if (msg.sender != owner) {
151       revert();
152     }
153     _;
154   }
155 }
156 
157 
158 contract RBInformationStore is Ownable {
159     address public profitContainerAddress;
160     address public companyWalletAddress;
161     uint public etherRatioForOwner;
162     address public multiSigAddress;
163     address public accountAddressForSponsee;
164     bool public isPayableEnabledForAll = true;
165 
166     modifier onlyMultiSig() {
167         require(multiSigAddress == msg.sender);
168         _;
169     }
170 
171     function RBInformationStore
172     (
173         address _profitContainerAddress,
174         address _companyWalletAddress,
175         uint _etherRatioForOwner,
176         address _multiSigAddress,
177         address _accountAddressForSponsee
178     ) {
179         profitContainerAddress = _profitContainerAddress;
180         companyWalletAddress = _companyWalletAddress;
181         etherRatioForOwner = _etherRatioForOwner;
182         multiSigAddress = _multiSigAddress;
183         accountAddressForSponsee = _accountAddressForSponsee;
184     }
185 
186     function changeProfitContainerAddress(address _address) onlyMultiSig {
187         profitContainerAddress = _address;
188     }
189 
190     function changeCompanyWalletAddress(address _address) onlyMultiSig {
191         companyWalletAddress = _address;
192     }
193 
194     function changeEtherRatioForOwner(uint _value) onlyMultiSig {
195         etherRatioForOwner = _value;
196     }
197 
198     function changeMultiSigAddress(address _address) onlyMultiSig {
199         multiSigAddress = _address;
200     }
201 
202     function changeOwner(address _address) onlyMultiSig {
203         owner = _address;
204     }
205 
206     function changeAccountAddressForSponsee(address _address) onlyMultiSig {
207         accountAddressForSponsee = _address;
208     }
209 
210     function changeIsPayableEnabledForAll() onlyMultiSig {
211         isPayableEnabledForAll = !isPayableEnabledForAll;
212     }
213 }
214 
215 
216 contract Rate {
217     uint public ETH_USD_rate;
218     RBInformationStore public rbInformationStore;
219 
220     modifier onlyOwner() {
221         require(msg.sender == rbInformationStore.owner());
222         _;
223     }
224 
225     function Rate(uint _rate, address _address) {
226         ETH_USD_rate = _rate;
227         rbInformationStore = RBInformationStore(_address);
228     }
229 
230     function setRate(uint _rate) onlyOwner {
231         ETH_USD_rate = _rate;
232     }
233 }
234 
235 /**
236 @title SponseeTokenModelSolaCoin
237 */
238 contract SponseeTokenModelSolaCoin is StandardToken {
239 
240     string public name = "SOLA COIN";
241     string public symbol = "SLC";
242     uint8 public decimals = 18;
243     uint public totalSupply = 500000000 * (10 ** uint256(decimals));
244     uint public cap = 1000000000 * (10 ** uint256(decimals)); // maximum cap = 10 000 000 $ = 1 000 000 000 tokens
245     uint public minimumSupport = 500; // minimum support is 5$
246     uint public etherRatioForInvestor = 10; // etherRatio (10%) to send ether to investor
247     address public sponseeAddress;
248     bool public isPayableEnabled = true;
249     RBInformationStore public rbInformationStore;
250     Rate public rate;
251 
252     event LogReceivedEther(address indexed from, address indexed to, uint etherValue, string tokenName);
253     event LogBuy(address indexed from, address indexed to, uint indexed value, uint paymentId);
254     event LogRollbackTransfer(address indexed from, address indexed to, uint value);
255     event LogExchange(address indexed from, address indexed token, uint value);
256     event LogIncreaseCap(uint value);
257     event LogDecreaseCap(uint value);
258     event LogSetRBInformationStoreAddress(address indexed to);
259     event LogSetName(string name);
260     event LogSetSymbol(string symbol);
261     event LogMint(address indexed to, uint value);
262     event LogChangeSponseeAddress(address indexed to);
263     event LogChangeIsPayableEnabled(bool flag);
264 
265     modifier onlyAccountAddressForSponsee() {
266         require(rbInformationStore.accountAddressForSponsee() == msg.sender);
267         _;
268     }
269 
270     modifier onlyMultiSig() {
271         require(rbInformationStore.multiSigAddress() == msg.sender);
272         _;
273     }
274 
275     // constructor
276     function SponseeTokenModelSolaCoin(
277         address _rbInformationStoreAddress,
278         address _rateAddress,
279         address _sponsee,
280         address _to
281     ) {
282         rbInformationStore = RBInformationStore(_rbInformationStoreAddress);
283         rate = Rate(_rateAddress);
284         sponseeAddress = _sponsee;
285         balances[_to] = totalSupply;
286     }
287 
288     /**
289     @notice Receive ether from any EOA accounts. Amount of ether received in this function is distributed to 3 parts.
290     One is a profitContainerAddress which is address of containerWallet to dividend to investor of Boost token.
291     Another is an ownerAddress which is address of owner of REALBOOST site.
292     The other is an sponseeAddress which is address of owner of this contract.
293     */
294     function() payable {
295 
296         // check condition
297         require(isPayableEnabled && rbInformationStore.isPayableEnabledForAll());
298 
299         // check validation
300         if (msg.value <= 0) { revert(); }
301 
302         // calculate support amount in USD
303         uint supportedAmount = msg.value.mul(rate.ETH_USD_rate()).div(10**18);
304         // if support is less than minimum => return money to supporter
305         if (supportedAmount < minimumSupport) { revert(); }
306 
307         // calculate the ratio of Ether for distribution
308         uint etherRatioForOwner = rbInformationStore.etherRatioForOwner();
309         uint etherRatioForSponsee = uint(100).sub(etherRatioForOwner).sub(etherRatioForInvestor);
310 
311         /* divide Ether */
312         // calculate
313         uint etherForOwner = msg.value.mul(etherRatioForOwner).div(100);
314         uint etherForInvestor = msg.value.mul(etherRatioForInvestor).div(100);
315         uint etherForSponsee = msg.value.mul(etherRatioForSponsee).div(100);
316 
317         // get address
318         address profitContainerAddress = rbInformationStore.profitContainerAddress();
319         address companyWalletAddress = rbInformationStore.companyWalletAddress();
320 
321         // send Ether
322         if (!profitContainerAddress.send(etherForInvestor)) { revert(); }
323         if (!companyWalletAddress.send(etherForOwner)) { revert(); }
324         if (!sponseeAddress.send(etherForSponsee)) { revert(); }
325 
326         // token amount is transfered to sender
327         // 1.0 token = 1 cent, 1 usd = 100 cents
328         // wei * US$/(10 ** 18 wei) * 100 cent/US$ * (10 ** 18(decimals))
329         uint tokenAmount = msg.value.mul(rate.ETH_USD_rate());
330 
331         // add tokens
332         balances[msg.sender] = balances[msg.sender].add(tokenAmount);
333 
334         // increase total supply
335         totalSupply = totalSupply.add(tokenAmount);
336 
337         // check cap
338         if (totalSupply > cap) { revert(); }
339 
340         // send Event
341         LogReceivedEther(msg.sender, this, msg.value, name);
342         LogExchange(msg.sender, this, tokenAmount);
343         Transfer(address(0x0), msg.sender, tokenAmount);
344     }
345 
346     /**
347     @notice Change rbInformationStoreAddress.
348     @param _address The address of new rbInformationStore
349     */
350     function setRBInformationStoreAddress(address _address) onlyMultiSig {
351 
352         rbInformationStore = RBInformationStore(_address);
353 
354         // send Event
355         LogSetRBInformationStoreAddress(_address);
356     }
357 
358     /**
359     @notice Change name.
360     @param _name The new name of token
361     */
362     function setName(string _name) onlyAccountAddressForSponsee {
363 
364         name = _name;
365 
366         // send Event
367         LogSetName(_name);
368     }
369 
370     /**
371     @notice Change symbol.
372     @param _symbol The new symbol of token
373     */
374     function setSymbol(string _symbol) onlyAccountAddressForSponsee {
375 
376         symbol = _symbol;
377 
378         // send Event
379         LogSetSymbol(_symbol);
380     }
381 
382     /**
383     @notice Mint new token amount.
384     @param _address The address that new token amount is added
385     @param _value The new amount of token
386     */
387     function mint(address _address, uint _value) onlyAccountAddressForSponsee {
388 
389         // add tokens
390         balances[_address] = balances[_address].add(_value);
391 
392         // increase total supply
393         totalSupply = totalSupply.add(_value);
394 
395         // check cap
396         if (totalSupply > cap) { revert(); }
397 
398         // send Event
399         LogMint(_address, _value);
400         Transfer(address(0x0), _address, _value);
401     }
402 
403     /**
404     @notice Increase cap.
405     @param _value The amount of token that should be increased
406     */
407     function increaseCap(uint _value) onlyAccountAddressForSponsee {
408 
409         // change cap here
410         cap = cap.add(_value);
411 
412         // send Event
413         LogIncreaseCap(_value);
414     }
415 
416     /**
417     @notice Decrease cap.
418     @param _value The amount of token that should be decreased
419     */
420     function decreaseCap(uint _value) onlyAccountAddressForSponsee {
421 
422         // check whether cap is lower than totalSupply or not
423         if (totalSupply > cap.sub(_value)) { revert(); }
424 
425         // change cap here
426         cap = cap.sub(_value);
427 
428         // send Event
429         LogDecreaseCap(_value);
430     }
431 
432     /**
433     @notice Rollback transfer.
434     @param _from The EOA address for rollback transfer
435     @param _to The EOA address for rollback transfer
436     @param _value The number of token for rollback transfer
437     */
438     function rollbackTransfer(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) onlyMultiSig {
439 
440         balances[_to] = balances[_to].sub(_value);
441         balances[_from] = balances[_from].add(_value);
442 
443         // send Event
444         LogRollbackTransfer(_from, _to, _value);
445         Transfer(_from, _to, _value);
446     }
447 
448     /**
449     @notice Transfer from msg.sender for downloading of content.
450     @param _to The EOA address for buy content
451     @param _value The number of token for buy content
452     @param _paymentId The id of content which msg.sender want to buy
453     */
454     function buy(address _to, uint _value, uint _paymentId) {
455 
456         transfer(_to, _value);
457 
458         // send Event
459         LogBuy(msg.sender, _to, _value, _paymentId);
460     }
461 
462     /**
463     @notice This method will change old sponsee address with new one.
464     @param _newAddress new address is set
465     */
466     function changeSponseeAddress(address _newAddress) onlyAccountAddressForSponsee {
467 
468         sponseeAddress = _newAddress;
469 
470         // send Event
471         LogChangeSponseeAddress(_newAddress);
472 
473     }
474 
475     /**
476     @notice This method will change isPayableEnabled flag.
477     */
478     function changeIsPayableEnabled() onlyMultiSig {
479 
480         isPayableEnabled = !isPayableEnabled;
481 
482         // send Event
483         LogChangeIsPayableEnabled(isPayableEnabled);
484 
485     }
486 }