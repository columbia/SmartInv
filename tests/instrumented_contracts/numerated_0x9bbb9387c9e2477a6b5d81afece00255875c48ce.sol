1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address newOwner) public onlyOwner {
75     require(newOwner != address(0));
76     OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80 }
81 
82 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: zeppelin-solidity/contracts/token/BasicToken.sol
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115 
116     // SafeMath.sub will throw if there is not enough balance.
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 // File: contracts/InkPublicPresale.sol
135 
136 contract InkPublicPresale is Ownable {
137   using SafeMath for uint256;
138 
139   // Flag to indicate whether or not the presale is currently active or is paused.
140   // This flag is used both before the presale is finalized as well as after.
141   // Pausing the presale before finalize means that no further contributions can
142   // be made. Pausing the presale after finalize means that no one can claim
143   // XNK tokens.
144   bool public active;
145 
146   // Flag to indicate whether or not contributions can be refunded.
147   bool private refundable;
148 
149   // The global minimum contribution (in Wei) imposed on all contributors.
150   uint256 public globalMin;
151   // The global maximum contribution (in Wei) imposed on all contributors.
152   // Contributor also have a personal max. When evaluating whether or not they
153   // can make a contribution, the lower of the global max and personal max is
154   // used.
155   uint256 public globalMax;
156   // The max amount of Ether (in Wei) that is available for contribution.
157   uint256 public etherCap;
158   // The running count of Ether (in Wei) that is already contributed.
159   uint256 private etherContributed;
160   // The running count of XNK that is purchased by contributors.
161   uint256 private xnkPurchased;
162   // The address of the XNK token contract. When this address is set, the
163   // presale is considered finalized and no further contributions can be made.
164   address public tokenAddress;
165   // Max gas price for contributing transactions.
166   uint256 public maxGasPrice;
167 
168   // Contributors storage mapping.
169   mapping(address => Contributor) private contributors;
170 
171   struct Contributor {
172     bool whitelisted;
173     // The individual rate (in XNK).
174     uint256 rate;
175     // The individual max contribution (in Wei).
176     uint256 max;
177     // The amount (in Wei) the contributor has contributed.
178     uint256 balance;
179   }
180 
181   // The presale is considered finalized when the token address is set.
182   modifier finalized {
183     require(tokenAddress != address(0));
184     _;
185   }
186 
187   // The presale is considered not finalized when the token address is not set.
188   modifier notFinalized {
189     require(tokenAddress == address(0));
190     _;
191   }
192 
193   function InkPublicPresale() public {
194     globalMax = 1000000000000000000; // 1.0 Ether
195     globalMin = 100000000000000000;  // 0.1 Ether
196     maxGasPrice = 40000000000;       // 40 Gwei
197   }
198 
199   function updateMaxGasPrice(uint256 _maxGasPrice) public onlyOwner {
200     require(_maxGasPrice > 0);
201 
202     maxGasPrice = _maxGasPrice;
203   }
204 
205   // Returns the amount of Ether contributed by all contributors.
206   function getEtherContributed() public view onlyOwner returns (uint256) {
207     return etherContributed;
208   }
209 
210   // Returns the amount of XNK purchased by all contributes.
211   function getXNKPurchased() public view onlyOwner returns (uint256) {
212     return xnkPurchased;
213   }
214 
215   // Update the global ether cap. If the new cap is set to something less than
216   // or equal to the current contributed ether (etherContributed), then no
217   // new contributions can be made.
218   function updateEtherCap(uint256 _newEtherCap) public notFinalized onlyOwner {
219     etherCap = _newEtherCap;
220   }
221 
222   // Update the global max contribution.
223   function updateGlobalMax(uint256 _globalMax) public notFinalized onlyOwner {
224     require(_globalMax > globalMin);
225 
226     globalMax = _globalMax;
227   }
228 
229   // Update the global minimum contribution.
230   function updateGlobalMin(uint256 _globalMin) public notFinalized onlyOwner {
231     require(_globalMin > 0);
232     require(_globalMin < globalMax);
233 
234     globalMin = _globalMin;
235   }
236 
237   function updateTokenAddress(address _tokenAddress) public finalized onlyOwner {
238     require(_tokenAddress != address(0));
239 
240     tokenAddress = _tokenAddress;
241   }
242 
243   // Pause the presale (disables contributions and token claiming).
244   function pause() public onlyOwner {
245     require(active);
246     active = false;
247   }
248 
249   // Resume the presale (enables contributions and token claiming).
250   function resume() public onlyOwner {
251     require(!active);
252     active = true;
253   }
254 
255   // Allow contributors to call the refund function to get their contributions
256   // returned to their whitelisted address.
257   function enableRefund() public onlyOwner {
258     require(!refundable);
259     refundable = true;
260   }
261 
262   // Disallow refunds (this is the case by default).
263   function disableRefund() public onlyOwner {
264     require(refundable);
265     refundable = false;
266   }
267 
268   // Add a contributor to the whitelist.
269   function addContributor(address _account, uint256 _rate, uint256 _max) public onlyOwner notFinalized {
270     require(_account != address(0));
271     require(_rate > 0);
272     require(_max >= globalMin);
273     require(!contributors[_account].whitelisted);
274 
275     contributors[_account].whitelisted = true;
276     contributors[_account].max = _max;
277     contributors[_account].rate = _rate;
278   }
279 
280   // Updates a contributor's rate and/or max.
281   function updateContributor(address _account, uint256 _newRate, uint256 _newMax) public onlyOwner notFinalized {
282     require(_account != address(0));
283     require(_newRate > 0);
284     require(_newMax >= globalMin);
285     require(contributors[_account].whitelisted);
286 
287     // Account for any changes in rate since we are keeping track of total XNK
288     // purchased.
289     if (contributors[_account].balance > 0 && contributors[_account].rate != _newRate) {
290       // Put back the purchased XNK for the old rate.
291       xnkPurchased = xnkPurchased.sub(contributors[_account].balance.mul(contributors[_account].rate));
292 
293       // Purchase XNK at the new rate.
294       xnkPurchased = xnkPurchased.add(contributors[_account].balance.mul(_newRate));
295     }
296 
297     contributors[_account].rate = _newRate;
298     contributors[_account].max = _newMax;
299   }
300 
301   // Remove the contributor from the whitelist. This also refunds their
302   // contribution if they have made any.
303   function removeContributor(address _account) public onlyOwner {
304     require(_account != address(0));
305     require(contributors[_account].whitelisted);
306 
307     // Remove from whitelist.
308     contributors[_account].whitelisted = false;
309 
310     // If contributions were made, refund it.
311     if (contributors[_account].balance > 0) {
312       uint256 balance = contributors[_account].balance;
313 
314       contributors[_account].balance = 0;
315       xnkPurchased = xnkPurchased.sub(balance.mul(contributors[_account].rate));
316       etherContributed = etherContributed.sub(balance);
317 
318       // XXX: The exclamation point does nothing. We just want to get rid of the
319       // compiler warning that we're not using the returned value of the Ether
320       // transfer. The transfer *can* fail but we don't want it to stop the
321       // removal of the contributor. We will deal if the transfer failure
322       // manually outside this contract.
323       !_account.call.value(balance)();
324     }
325 
326     delete contributors[_account];
327   }
328 
329   function withdrawXNK(address _to) public onlyOwner {
330     require(_to != address(0));
331 
332     BasicToken token = BasicToken(tokenAddress);
333     assert(token.transfer(_to, token.balanceOf(this)));
334   }
335 
336   function withdrawEther(address _to) public finalized onlyOwner {
337     require(_to != address(0));
338 
339     assert(_to.call.value(this.balance)());
340   }
341 
342   // Returns a contributor's balance.
343   function balanceOf(address _account) public view returns (uint256) {
344     require(_account != address(0));
345 
346     return contributors[_account].balance;
347   }
348 
349   // When refunds are enabled, contributors can call this function get their
350   // contributed Ether back. The contributor must still be whitelisted.
351   function refund() public {
352     require(active);
353     require(refundable);
354     require(contributors[msg.sender].whitelisted);
355 
356     uint256 balance = contributors[msg.sender].balance;
357 
358     require(balance > 0);
359 
360     contributors[msg.sender].balance = 0;
361     etherContributed = etherContributed.sub(balance);
362     xnkPurchased = xnkPurchased.sub(balance.mul(contributors[msg.sender].rate));
363 
364     assert(msg.sender.call.value(balance)());
365   }
366 
367   function airdrop(address _account) public finalized onlyOwner {
368     _processPayout(_account);
369   }
370 
371   // Finalize the presale by specifying the XNK token's contract address.
372   // No further contributions can be made. The presale will be in the
373   // "token claiming" phase.
374   function finalize(address _tokenAddress) public notFinalized onlyOwner {
375     require(_tokenAddress != address(0));
376 
377     tokenAddress = _tokenAddress;
378   }
379 
380   // Fallback/payable method for contributions and token claiming.
381   function () public payable {
382     // Allow the owner to send Ether to the contract arbitrarily.
383     if (msg.sender == owner && msg.value > 0) {
384       return;
385     }
386 
387     require(active);
388     require(contributors[msg.sender].whitelisted);
389 
390     if (tokenAddress == address(0)) {
391       // Presale is still accepting contributions.
392       _processContribution();
393     } else {
394       // Presale has been finalized and the user is attempting to claim
395       // XNK tokens.
396       _processPayout(msg.sender);
397     }
398   }
399 
400   // Process the contribution.
401   function _processContribution() private {
402     // Must be contributing a positive amount.
403     require(msg.value > 0);
404     // Limit the transaction's gas price.
405     require(tx.gasprice <= maxGasPrice);
406     // The sum of the contributor's total contributions must be higher than the
407     // global minimum.
408     require(contributors[msg.sender].balance.add(msg.value) >= globalMin);
409     // The global contribution cap must be higher than what has been contributed
410     // by everyone. Otherwise, there's zero room for any contribution.
411     require(etherCap > etherContributed);
412     // Make sure that this specific contribution does not take the total
413     // contribution by everyone over the global contribution cap.
414     require(msg.value <= etherCap.sub(etherContributed));
415 
416     uint256 newBalance = contributors[msg.sender].balance.add(msg.value);
417 
418     // We limit the individual's contribution based on whichever is lower
419     // between their individual max or the global max.
420     if (globalMax <= contributors[msg.sender].max) {
421       require(newBalance <= globalMax);
422     } else {
423       require(newBalance <= contributors[msg.sender].max);
424     }
425 
426     // Increment the contributor's balance.
427     contributors[msg.sender].balance = newBalance;
428     // Increment the total amount of Ether contributed by everyone.
429     etherContributed = etherContributed.add(msg.value);
430     // Increment the total amount of XNK purchased by everyone.
431     xnkPurchased = xnkPurchased.add(msg.value.mul(contributors[msg.sender].rate));
432   }
433 
434   // Process the token claim.
435   function _processPayout(address _recipient) private {
436     // The transaction must be 0 Ether.
437     require(msg.value == 0);
438 
439     uint256 balance = contributors[_recipient].balance;
440 
441     // The contributor must have contributed something.
442     require(balance > 0);
443 
444     // Figure out the amount of XNK the contributor will receive.
445     uint256 amount = balance.mul(contributors[_recipient].rate);
446 
447     // Zero out the contributor's balance to denote that they have received
448     // their tokens.
449     contributors[_recipient].balance = 0;
450 
451     // Transfer XNK to the contributor.
452     assert(BasicToken(tokenAddress).transfer(_recipient, amount));
453   }
454 }