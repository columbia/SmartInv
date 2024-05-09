1 // File: contracts\Proxy\newBaseProxy.sol
2 
3 pragma solidity =0.5.16;
4 /**
5  * @title  newBaseProxy Contract
6 
7  */
8 contract newBaseProxy {
9     bytes32 private constant implementPositon = keccak256("org.Finnexus.implementation.storage");
10     bytes32 private constant proxyOwnerPosition  = keccak256("org.Finnexus.Owner.storage");
11     constructor(address implementation_) public {
12         // Creator of the contract is admin during initialization
13         _setProxyOwner(msg.sender);
14         _setImplementation(implementation_);
15         (bool success,) = implementation_.delegatecall(abi.encodeWithSignature("initialize()"));
16         require(success);
17     }
18     /**
19      * @dev Allows the current owner to transfer ownership
20      * @param _newOwner The address to transfer ownership to
21      */
22     function transferProxyOwnership(address _newOwner) public onlyProxyOwner 
23     {
24         require(_newOwner != address(0));
25         _setProxyOwner(_newOwner);
26     }
27     function _setProxyOwner(address _newOwner) internal 
28     {
29         bytes32 position = proxyOwnerPosition;
30         assembly {
31             sstore(position, _newOwner)
32         }
33     }
34     function proxyOwner() public view returns (address owner) {
35         bytes32 position = proxyOwnerPosition;
36         assembly {
37             owner := sload(position)
38         }
39     }
40     /**
41      * @dev Tells the address of the current implementation
42      * @return address of the current implementation
43      */
44     function getImplementation() public view returns (address impl) {
45         bytes32 position = implementPositon;
46         assembly {
47             impl := sload(position)
48         }
49     }
50     function _setImplementation(address _newImplementation) internal 
51     {
52         bytes32 position = implementPositon;
53         assembly {
54             sstore(position, _newImplementation)
55         }
56     }
57     function setImplementation(address _newImplementation)public onlyProxyOwner{
58         address currentImplementation = getImplementation();
59         require(currentImplementation != _newImplementation);
60         _setImplementation(_newImplementation);
61         (bool success,) = _newImplementation.delegatecall(abi.encodeWithSignature("update()"));
62         require(success);
63     }
64 
65     /**
66      * @notice Delegates execution to the implementation contract
67      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
68      * @param data The raw data to delegatecall
69      * @return The returned bytes from the delegatecall
70      */
71     function delegateToImplementation(bytes memory data) public returns (bytes memory) {
72         (bool success, bytes memory returnData) = getImplementation().delegatecall(data);
73         assembly {
74             if eq(success, 0) {
75                 revert(add(returnData, 0x20), returndatasize)
76             }
77         }
78         return returnData;
79     }
80 
81     /**
82      * @notice Delegates execution to an implementation contract
83      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
84      *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
85      * @param data The raw data to delegatecall
86      * @return The returned bytes from the delegatecall
87      */
88     function delegateToViewImplementation(bytes memory data) public view returns (bytes memory) {
89         (bool success, bytes memory returnData) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", data));
90         assembly {
91             if eq(success, 0) {
92                 revert(add(returnData, 0x20), returndatasize)
93             }
94         }
95         return abi.decode(returnData, (bytes));
96     }
97 
98     function delegateToViewAndReturn() internal view returns (bytes memory) {
99         (bool success, ) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", msg.data));
100 
101         assembly {
102             let free_mem_ptr := mload(0x40)
103             returndatacopy(free_mem_ptr, 0, returndatasize)
104 
105             switch success
106             case 0 { revert(free_mem_ptr, returndatasize) }
107             default { return(add(free_mem_ptr, 0x40), sub(returndatasize, 0x40)) }
108         }
109     }
110 
111     function delegateAndReturn() internal returns (bytes memory) {
112         (bool success, ) = getImplementation().delegatecall(msg.data);
113 
114         assembly {
115             let free_mem_ptr := mload(0x40)
116             returndatacopy(free_mem_ptr, 0, returndatasize)
117 
118             switch success
119             case 0 { revert(free_mem_ptr, returndatasize) }
120             default { return(free_mem_ptr, returndatasize) }
121         }
122     }
123         /**
124     * @dev Throws if called by any account other than the owner.
125     */
126     modifier onlyProxyOwner() {
127         require (msg.sender == proxyOwner());
128         _;
129     }
130 }
131 
132 // File: contracts\fixedMinePool\fixedMinePoolProxy.sol
133 
134 pragma solidity =0.5.16;
135 
136 
137 /**
138  * @title FNX period mine pool.
139  * @dev A smart-contract which distribute some mine coins when user stake FPT-A and FPT-B coins.
140  *
141  */
142 contract fixedMinePoolProxy is newBaseProxy {
143     /**
144     * @dev constructor.
145     * FPTA FPT-A coin's address,staking coin
146     * FPTB FPT-B coin's address,staking coin
147     * startTime the start time when this mine pool begin.
148     */
149     constructor (address implementation_,address FPTA,address FPTB,uint256 startTime) newBaseProxy(implementation_) public{
150         (bool success,) = implementation_.delegatecall(abi.encodeWithSignature(
151                 "setAddresses(address,address,uint256)",
152                 FPTA,
153                 FPTB,
154                 startTime));
155         require(success);
156     }
157         /**
158      * @dev default function for foundation input miner coins.
159      */
160     function()external payable{
161 
162     }
163         /**
164      * @dev Returns the address of the current owner.
165      */
166     function owner() public view returns (address) {
167         delegateToViewAndReturn(); 
168     }
169     /**
170      * @dev Returns true if the caller is the current owner.
171      */
172     function isOwner() public view returns (bool) {
173         delegateToViewAndReturn(); 
174     }
175     /**
176      * @dev Leaves the contract without owner. It will not be possible to call
177      * `onlyOwner` functions anymore. Can only be called by the current owner.
178      *
179      * NOTE: Renouncing ownership will leave the contract without an owner,
180      * thereby removing any functionality that is only available to the owner.
181      */
182     function renounceOwnership() public {
183         delegateAndReturn();
184     }
185     /**
186      * @dev Transfers ownership of the contract to a new account (`newOwner`).
187      * Can only be called by the current owner.
188      */
189     function transferOwnership(address /*newOwner*/) public {
190         delegateAndReturn();
191     }
192     function setHalt(bool /*halt*/) public  {
193         delegateAndReturn();
194     }
195      function addWhiteList(address /*addAddress*/)public{
196         delegateAndReturn();
197     }
198     /**
199      * @dev Implementation of revoke an invalid address from the whitelist.
200      *  removeAddress revoked address.
201      */
202     function removeWhiteList(address /*removeAddress*/)public returns (bool){
203         delegateAndReturn();
204     }
205     /**
206      * @dev Implementation of getting the eligible whitelist.
207      */
208     function getWhiteList()public view returns (address[] memory){
209         delegateToViewAndReturn();
210     }
211     /**
212      * @dev Implementation of testing whether the input address is eligible.
213      *  tmpAddress input address for testing.
214      */    
215     function isEligibleAddress(address /*tmpAddress*/) public view returns (bool){
216         delegateToViewAndReturn();
217     }
218     function setOperator(uint256 /*index*/,address /*addAddress*/)public{
219         delegateAndReturn();
220     }
221     function getOperator(uint256 /*index*/)public view returns (address) {
222         delegateToViewAndReturn(); 
223     }
224     /**
225      * @dev getting function. Retrieve FPT-A coin's address
226      */
227     function getFPTAAddress()public view returns (address) {
228         delegateToViewAndReturn(); 
229     }
230     /**
231      * @dev getting function. Retrieve FPT-B coin's address
232      */
233     function getFPTBAddress()public view returns (address) {
234         delegateToViewAndReturn(); 
235     }
236     /**
237      * @dev getting function. Retrieve mine pool's start time.
238      */
239     function getStartTime()public view returns (uint256) {
240         delegateToViewAndReturn(); 
241     }
242     /**
243      * @dev getting current mine period ID.
244      */
245     function getCurrentPeriodID()public view returns (uint256) {
246         delegateToViewAndReturn(); 
247     }
248     /**
249      * @dev getting user's staking FPT-A balance.
250      * account user's account
251      */
252     function getUserFPTABalance(address /*account*/)public view returns (uint256) {
253         delegateToViewAndReturn(); 
254     }
255     /**
256      * @dev getting user's staking FPT-B balance.
257      * account user's account
258      */
259     function getUserFPTBBalance(address /*account*/)public view returns (uint256) {
260         delegateToViewAndReturn(); 
261     }
262     /**
263      * @dev getting user's maximium locked period ID.
264      * account user's account
265      */
266     function getUserMaxPeriodId(address /*account*/)public view returns (uint256) {
267         delegateToViewAndReturn(); 
268     }
269     /**
270      * @dev getting user's locked expired time. After this time user can unstake FPTB coins.
271      * account user's account
272      */
273     function getUserExpired(address /*account*/)public view returns (uint256) {
274         delegateToViewAndReturn(); 
275     }
276     function getCurrentTotalAPY(address /*mineCoin*/)public view returns (uint256){
277         delegateToViewAndReturn(); 
278     }
279     /**
280      * @dev Calculate user's current APY.
281      * account user's account.
282      * mineCoin mine coin address
283      */
284     function getUserCurrentAPY(address /*account*/,address /*mineCoin*/)public view returns (uint256){
285         delegateToViewAndReturn(); 
286     }
287     function getAverageLockedTime()public view returns (uint256){
288         delegateToViewAndReturn(); 
289     }
290     /**
291      * @dev foundation redeem out mine coins.
292      *  mineCoin mineCoin address
293      *  amount redeem amount.
294      */
295     function redeemOut(address /*mineCoin*/,uint256 /*amount*/)public{
296         delegateAndReturn();
297     }
298     /**
299      * @dev retrieve total distributed mine coins.
300      *  mineCoin mineCoin address
301      */
302     function getTotalMined(address /*mineCoin*/)public view returns(uint256){
303         delegateToViewAndReturn(); 
304     }
305     /**
306      * @dev retrieve minecoin distributed informations.
307      *  mineCoin mineCoin address
308      * @return distributed amount and distributed time interval.
309      */
310     function getMineInfo(address /*mineCoin*/)public view returns(uint256,uint256){
311         delegateToViewAndReturn(); 
312     }
313     /**
314      * @dev retrieve user's mine balance.
315      *  account user's account
316      *  mineCoin mineCoin address
317      */
318     function getMinerBalance(address /*account*/,address /*mineCoin*/)public view returns(uint256){
319         delegateToViewAndReturn(); 
320     }
321     /**
322      * @dev Set mineCoin mine info, only foundation owner can invoked.
323      *  mineCoin mineCoin address
324      *  _mineAmount mineCoin distributed amount
325      *  _mineInterval mineCoin distributied time interval
326      */
327     function setMineCoinInfo(address /*mineCoin*/,uint256 /*_mineAmount*/,uint256 /*_mineInterval*/)public {
328         delegateAndReturn();
329     }
330 
331     /**
332      * @dev user redeem mine rewards.
333      *  mineCoin mine coin address
334      *  amount redeem amount.
335      */
336     function redeemMinerCoin(address /*mineCoin*/,uint256 /*amount*/)public{
337         delegateAndReturn();
338     }
339     /**
340      * @dev getting whole pool's mine production weight ratio.
341      *      Real mine production equals base mine production multiply weight ratio.
342      */
343     function getMineWeightRatio()public view returns (uint256) {
344         delegateToViewAndReturn(); 
345     }
346     /**
347      * @dev getting whole pool's mine shared distribution. All these distributions will share base mine production.
348      */
349     function getTotalDistribution() public view returns (uint256){
350         delegateToViewAndReturn(); 
351     }
352     /**
353      * @dev convert timestamp to period ID.
354      * _time timestamp. 
355      */ 
356     function getPeriodIndex(uint256 /*_time*/) public view returns (uint256) {
357         delegateToViewAndReturn(); 
358     }
359     /**
360      * @dev convert period ID to period's finish timestamp.
361      * periodID period ID. 
362      */
363     function getPeriodFinishTime(uint256 /*periodID*/)public view returns (uint256) {
364         delegateToViewAndReturn(); 
365     }
366     /**
367      * @dev Stake FPT-A coin and get distribution for mining.
368      * amount FPT-A amount that transfer into mine pool.
369      */
370     function stakeFPTA(uint256 /*amount*/)public {
371         delegateAndReturn();
372     }
373     /**
374      * @dev Air drop to user some FPT-B coin and lock one period and get distribution for mining.
375      * user air drop's recieptor.
376      * ftp_b_amount FPT-B amount that transfer into mine pool.
377      */
378     function lockAirDrop(address /*user*/,uint256 /*ftp_b_amount*/) external{
379         delegateAndReturn();
380     }
381     /**
382      * @dev Stake FPT-B coin and lock locedPreiod and get distribution for mining.
383      * amount FPT-B amount that transfer into mine pool.
384      * lockedPeriod locked preiod number.
385      */
386     function stakeFPTB(uint256 /*amount*/,uint256 /*lockedPeriod*/)public{
387         delegateAndReturn();
388     }
389     /**
390      * @dev withdraw FPT-A coin.
391      * amount FPT-A amount that withdraw from mine pool.
392      */
393     function unstakeFPTA(uint256 /*amount*/)public {
394         delegateAndReturn();
395     }
396     /**
397      * @dev withdraw FPT-B coin.
398      * amount FPT-B amount that withdraw from mine pool.
399      */
400     function unstakeFPTB(uint256 /*amount*/)public{
401         delegateAndReturn();
402     }
403     /**
404      * @dev Add FPT-B locked period.
405      * lockedPeriod FPT-B locked preiod number.
406      */
407     function changeFPTBLockedPeriod(uint256 /*lockedPeriod*/)public{
408         delegateAndReturn();
409     }
410 
411        /**
412      * @dev retrieve total distributed premium coins.
413      */
414     function getTotalPremium()public view returns(uint256){
415         delegateToViewAndReturn(); 
416     }
417     /**
418      * @dev user redeem his options premium rewards.
419      */
420     function redeemPremium()public{
421         delegateAndReturn();
422     }
423     /**
424      * @dev user redeem his options premium rewards.
425      * amount redeem amount.
426      */
427     function redeemPremiumCoin(address /*premiumCoin*/,uint256 /*amount*/)public{
428         delegateAndReturn();
429     }
430     /**
431      * @dev get user's premium balance.
432      * account user's account
433      */ 
434     function getUserLatestPremium(address /*account*/,address /*premiumCoin*/)public view returns(uint256){
435         delegateToViewAndReturn(); 
436     }
437  
438     /**
439      * @dev Distribute premium from foundation.
440      * periodID period ID
441      * amount premium amount.
442      */ 
443     function distributePremium(address /*premiumCoin*/,uint256 /*periodID*/,uint256 /*amount*/)public {
444         delegateAndReturn();
445     }
446         /**
447      * @dev Emitted when `account` stake `amount` FPT-A coin.
448      */
449     event StakeFPTA(address indexed account,uint256 amount);
450     /**
451      * @dev Emitted when `from` airdrop `recieptor` `amount` FPT-B coin.
452      */
453     event LockAirDrop(address indexed from,address indexed recieptor,uint256 amount);
454     /**
455      * @dev Emitted when `account` stake `amount` FPT-B coin and locked `lockedPeriod` periods.
456      */
457     event StakeFPTB(address indexed account,uint256 amount,uint256 lockedPeriod);
458     /**
459      * @dev Emitted when `account` unstake `amount` FPT-A coin.
460      */
461     event UnstakeFPTA(address indexed account,uint256 amount);
462     /**
463      * @dev Emitted when `account` unstake `amount` FPT-B coin.
464      */
465     event UnstakeFPTB(address indexed account,uint256 amount);
466     /**
467      * @dev Emitted when `account` change `lockedPeriod` locked periods for FPT-B coin.
468      */
469     event ChangeLockedPeriod(address indexed account,uint256 lockedPeriod);
470     /**
471      * @dev Emitted when owner `account` distribute `amount` premium in `periodID` period.
472      */
473     event DistributePremium(address indexed account,address indexed premiumCoin,uint256 indexed periodID,uint256 amount);
474     /**
475      * @dev Emitted when `account` redeem `amount` premium.
476      */
477     event RedeemPremium(address indexed account,address indexed premiumCoin,uint256 amount);
478 
479     /**
480      * @dev Emitted when `account` redeem `value` mineCoins.
481      */
482     event RedeemMineCoin(address indexed account, address indexed mineCoin, uint256 value);
483 
484 }