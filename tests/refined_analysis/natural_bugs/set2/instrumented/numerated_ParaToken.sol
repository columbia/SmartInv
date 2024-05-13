1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "./libraries/ERC20.sol";
6 import "./libraries/Ownable.sol";
7 import "./libraries/SafeMath_para.sol";
8 // WARNING: There is a known vuln contained within this contract related to vote delegation, 
9 // it's NOT recommmended to use this in production.  
10 
11 // ParaToken with Governance.
12 contract ParaToken is ERC20("ParalUni Token", "T42"), Ownable {
13     using SafeMath for uint256;
14 
15     uint denominator = 1e18;
16     uint256 public hardLimit = 10000000000e18; // Hardtop: upper limit of total T42 issuance
17     uint256 public _issuePerBlock = 1150e18;   // Initial issued quantity per block
18     uint256 public startBlock;          // Issuing start block height
19     uint256 public lastBlockHalve;             // Block height at last production reduction
20     uint256 public lastSoftLimit = 0;          // Soft roof at last production reduction
21     uint256 constant HALVE_INTERVAL = 880000;   // Number of production reduction interval blocks
22     uint256 constant HALVE_RATE = 90;           // Production reduction ratio
23     
24     mapping(address => bool) public minersAddress;
25     //Whereabouts of fines
26     address public fineAcceptAddress;
27     //
28     mapping(address => bool) public whiteAdmins;
29     mapping(address => bool) public whitelist;
30     mapping(address => bool) public fromWhitelist;
31     mapping(address => bool) public toWhitelist;
32     //User maturity
33     mapping(address => Maturity) public userMaturity;
34 
35     struct Maturity {
36         //Height of recently transferred block
37         uint lastBlockHalve;
38         //Number of blocks held (time)
39         uint blockNum;
40         //Balance in white list contract
41         uint whiteBalance;
42     }
43 
44     constructor(uint _startBlock) public {
45         startBlock = _startBlock;
46         lastBlockHalve = _startBlock;
47     }
48     
49     //set _setMinerAddress
50     function _setMinerAddress(address _minerAddress, bool flag) external onlyOwner{
51         minersAddress[_minerAddress] = flag;
52     }
53     
54     //set _setFineAcceptAddress
55     function _setFineAcceptAddress(address _fineAcceptAddress) external onlyOwner{
56         fineAcceptAddress = _fineAcceptAddress;
57     }
58     
59     //set whiteAdmin
60     function _setWhiteAdmin(address _whiteAdmin, bool flag) external onlyOwner{
61         whiteAdmins[_whiteAdmin] = flag;
62     }
63 
64     function _setWhiteListAll(uint whiteType, address[] memory users, bool[] memory flags) external onlyOwner{
65         require(users.length == flags.length);
66         for(uint i = 0; i < users.length; i++){
67            _setWhiteList(whiteType, users[i], flags[i]);
68         }
69     }
70 
71     function _setWhiteList(uint whiteType, address user, bool flag) public{
72         //auth
73         require(whiteAdmins[address(msg.sender)] || address(msg.sender) == owner(), "WhiteList:auth");
74         if(whiteType == 0){
75             whitelist[user] = flag;
76         }
77         if(whiteType == 1){
78             fromWhitelist[user] = flag;
79         }
80         if(whiteType == 2){
81             toWhitelist[user] = flag;
82         }
83     }
84 
85     /// @dev overrides transfer function to meet tokenomics of TENGU
86     function _transfer(address sender, address recipient, uint256 amount) internal virtual override {
87         uint fine = 0;
88          //Transfer out determines whether the receiving address is a white list address: accumulates the virtual balance of the transferor
89         if(whitelist[recipient] || toWhitelist[recipient]){
90             //The recipient is a whitelist sender, not a sender. You only need to update the virtual balance from
91             if(!whitelist[sender]){
92                 //user sender maturity stroage
93                 Maturity storage maturity = userMaturity[sender];
94                 maturity.whiteBalance = maturity.whiteBalance.add(amount);
95             }
96         }else{
97             //Update the number of blocks if necessary
98             //user recipient maturity stroage
99             Maturity storage maturity = userMaturity[recipient];
100             if(maturity.lastBlockHalve == 0){
101                 maturity.lastBlockHalve = block.number;
102             }
103             //Sender is a white list and recipient is not a white list. You only need to deduct the virtual balance of the recipient
104             if(whitelist[sender] || fromWhitelist[sender]){
105                 if(!fromWhitelist[sender]){
106                     if(maturity.whiteBalance >= amount){
107                         /** ===== set storage =====   */
108                         maturity.whiteBalance = maturity.whiteBalance.sub(amount);
109                     }else{
110                         /** ===== set storage =====   */
111                         maturity.whiteBalance = 0;
112                     }
113                 }
114             }else{
115                 //Neither are whitelisted
116                 //The penalty calculation for the transferer: non-whitelisted address
117                 fine = getFine(sender, amount);
118                 //Calculate the maturity of the transferee
119                 //Virtual balance
120                 uint virtualAmount = balanceOf(recipient).add(maturity.whiteBalance);
121                 (uint currentMaturityTo, ) = currentMaturity(recipient);
122                 //Update maturity
123                 uint latestMaturity = 0;
124                 if(virtualAmount.add(amount) > 0){
125                    latestMaturity = virtualAmount.mul(currentMaturityTo).div(virtualAmount.add(amount));
126                 }        
127                 //Get the latest x0 according to the latest maturity
128                 uint newBlockNum = getBlockNumByMaturity(latestMaturity);
129 
130                 /** ===== set storage =====   */
131                 maturity.blockNum = newBlockNum;
132                 maturity.lastBlockHalve = block.number;
133             }
134         }
135         //Modify the penalty disposal method
136         super._transfer(sender, recipient, amount.sub(fine));
137         if(fine > 0){
138             super._transfer(sender, fineAcceptAddress, fine);    
139         }
140     }
141 
142     function currentMaturity(address user) public view returns (uint mturityValue, uint blockNeeded){
143         //user recipient maturity stroage
144         Maturity memory maturity = userMaturity[user];
145         uint short = block.number.sub(maturity.lastBlockHalve);
146         if(maturity.lastBlockHalve == 0){
147             short = 0;
148         }
149         uint x0 = maturity.blockNum.add(short);
150         (mturityValue, blockNeeded) = getMaturity(x0);
151     }
152 
153     //mul(1e18)
154     function getMaturity(uint blockNum) internal view returns (uint maturity, uint blockNeeded) {
155         if(blockNum < uint(403200)){
156             blockNeeded = uint(403200).sub(blockNum);
157         }
158         blockNum = blockNum.mul(denominator);
159         if(blockNum < uint(201600).mul(denominator)){
160             maturity = blockNum.div(806400);
161         }
162         if(blockNum >= uint(201600).mul(denominator) && blockNum < uint(403200).mul(denominator)){
163             maturity = blockNum.div(268800).sub(5e17); //5e17 = 1e18* 0.5
164         }
165         if(blockNum >= uint(403200).mul(denominator)){
166             maturity = 1e18;
167         }
168     }
169 
170    function getBlockNumByMaturity(uint maturity)internal view returns (uint blockNum){
171        if(maturity < 0.25e18){
172            return maturity.mul(806400).div(denominator);
173        }
174        if(maturity >= 0.25e18 && maturity < 1e18){
175            return maturity.add(5e17).mul(268800).div(denominator);
176        }
177        if(maturity >= 1e18){
178            return 403200;
179        }
180    }
181 
182    function getFine(address user, uint amount) public view returns (uint) {
183         // amount x ( 1 - Maturity ) x 20%
184         (uint currentMaturityFrom, ) = currentMaturity(user);
185         return amount.mul(denominator.sub(currentMaturityFrom)).div(5).div(denominator);
186    }
187 
188     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
189     function mint(address _to, uint256 _amount) public { 
190         require(minersAddress[msg.sender], "!mint:auth");
191         // Check hard top, soft top
192         uint256 newTotal = totalSupply().add(_amount);
193         updateSoftLimit();
194         //TODO
195         require(newTotal <= softLimit(), "^softLimit");
196         require(newTotal <= hardLimit, "^hardLimit");
197 
198         _mint(_to, _amount);
199         _moveDelegates(address(0), _delegates[_to], _amount);
200     }
201 
202     // Calculate T42 current circulation soft top
203     function updateSoftLimit() internal {
204         if(block.number > startBlock){
205             uint256 n = block.number.sub(startBlock).div(HALVE_INTERVAL) 
206                     - lastBlockHalve.sub(startBlock).div(HALVE_INTERVAL);
207             // Usually n is 0 or 1
208             for (uint i = 0; i < n; i++) {
209                 lastSoftLimit = lastSoftLimit.add(_issuePerBlock.mul(HALVE_INTERVAL));
210                 _issuePerBlock = _issuePerBlock.mul(HALVE_RATE).div(100);
211                 lastBlockHalve = block.number;
212             }
213         }
214     }
215 
216     function softLimit() public view returns (uint) {
217         uint256 _lastSoftLimit = lastSoftLimit;
218         uint256 _lastBlockHalve = lastBlockHalve;
219         uint256 __issuePerBlock = _issuePerBlock;
220         if(block.number > startBlock){
221             uint256 n = block.number.sub(startBlock).div(HALVE_INTERVAL) - lastBlockHalve.sub(startBlock).div(HALVE_INTERVAL);
222             // Usually n is 0 or 1
223             for (uint i = 0; i < n; i++) {
224                 _lastSoftLimit = _lastSoftLimit.add(__issuePerBlock.mul(HALVE_INTERVAL));
225                 __issuePerBlock = __issuePerBlock.mul(HALVE_RATE).div(100);
226                 _lastBlockHalve = block.number;
227             }
228             uint256 blocks = block.number.sub(_lastBlockHalve).add(1);
229             return _lastSoftLimit.add(__issuePerBlock.mul(blocks));
230         }
231         return 0;
232     }
233 
234     function issuePerBlock() public view returns (uint) {
235         uint retval = _issuePerBlock;
236         if (block.number >= startBlock) {
237             uint256 n = block.number.sub(startBlock).div(HALVE_INTERVAL) - lastBlockHalve.sub(startBlock).div(HALVE_INTERVAL);
238             // Usually n is 0 or 1
239             for (uint i = 0; i < n; i++) {
240                 retval = retval.mul(HALVE_RATE).div(100);
241             }
242             return retval;
243         }
244         //There is no profit before mining starts
245         return 0;
246     }
247 
248     // Copied and modified from YAM code:
249     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
250     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
251     // Which is copied and modified from COMPOUND:
252     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
253 
254     /// @notice A record of each accounts delegate
255     mapping (address => address) internal _delegates;
256 
257     /// @notice A checkpoint for marking number of votes from a given block
258     struct Checkpoint {
259         uint32 fromBlock;
260         uint256 votes;
261     }
262 
263     /// @notice A record of votes checkpoints for each account, by index
264     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
265 
266     /// @notice The number of checkpoints for each account
267     mapping (address => uint32) public numCheckpoints;
268 
269     /// @notice The EIP-712 typehash for the contract's domain
270     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
271 
272     /// @notice The EIP-712 typehash for the delegation struct used by the contract
273     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
274 
275     /// @notice A record of states for signing / validating signatures
276     mapping (address => uint) public nonces;
277 
278       /// @notice An event thats emitted when an account changes its delegate
279     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
280 
281     /// @notice An event thats emitted when a delegate account's vote balance changes
282     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
283 
284     /**
285      * @notice Delegate votes from `msg.sender` to `delegatee`
286      * @param delegator The address to get delegatee for
287      */
288     function delegates(address delegator)
289         external
290         view
291         returns (address)
292     {
293         return _delegates[delegator];
294     }
295 
296    /**
297     * @notice Delegate votes from `msg.sender` to `delegatee`
298     * @param delegatee The address to delegate votes to
299     */
300     function delegate(address delegatee) external {
301         return _delegate(msg.sender, delegatee);
302     }
303 
304     /**
305      * @notice Delegates votes from signatory to `delegatee`
306      * @param delegatee The address to delegate votes to
307      * @param nonce The contract state required to match the signature
308      * @param expiry The time at which to expire the signature
309      * @param v The recovery byte of the signature
310      * @param r Half of the ECDSA signature pair
311      * @param s Half of the ECDSA signature pair
312      */
313     function delegateBySig(
314         address delegatee,
315         uint nonce,
316         uint expiry,
317         uint8 v,
318         bytes32 r,
319         bytes32 s
320     )
321         external
322     {
323         bytes32 domainSeparator = keccak256(
324             abi.encode(
325                 DOMAIN_TYPEHASH,
326                 keccak256(bytes(name())),
327                 getChainId(),
328                 address(this)
329             )
330         );
331 
332         bytes32 structHash = keccak256(
333             abi.encode(
334                 DELEGATION_TYPEHASH,
335                 delegatee,
336                 nonce,
337                 expiry
338             )
339         );
340 
341         bytes32 digest = keccak256(
342             abi.encodePacked(
343                 "\x19\x01",
344                 domainSeparator,
345                 structHash
346             )
347         );
348 
349         address signatory = ecrecover(digest, v, r, s);
350         require(signatory != address(0), "PARA::delegateBySig: invalid signature");
351         require(nonce == nonces[signatory]++, "PARA::delegateBySig: invalid nonce");
352         require(now <= expiry, "PARA::delegateBySig: signature expired");
353         return _delegate(signatory, delegatee);
354     }
355 
356     /**
357      * @notice Gets the current votes balance for `account`
358      * @param account The address to get votes balance
359      * @return The number of current votes for `account`
360      */
361     function getCurrentVotes(address account)
362         external
363         view
364         returns (uint256)
365     {
366         uint32 nCheckpoints = numCheckpoints[account];
367         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
368     }
369 
370     /**
371      * @notice Determine the prior number of votes for an account as of a block number
372      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
373      * @param account The address of the account to check
374      * @param blockNumber The block number to get the vote balance at
375      * @return The number of votes the account had as of the given block
376      */
377     function getPriorVotes(address account, uint blockNumber)
378         external
379         view
380         returns (uint256)
381     {
382         require(blockNumber < block.number, "PARA::getPriorVotes: not yet determined");
383 
384         uint32 nCheckpoints = numCheckpoints[account];
385         if (nCheckpoints == 0) {
386             return 0;
387         }
388 
389         // First check most recent balance
390         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
391             return checkpoints[account][nCheckpoints - 1].votes;
392         }
393 
394         // Next check implicit zero balance
395         if (checkpoints[account][0].fromBlock > blockNumber) {
396             return 0;
397         }
398 
399         uint32 lower = 0;
400         uint32 upper = nCheckpoints - 1;
401         while (upper > lower) {
402             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
403             Checkpoint memory cp = checkpoints[account][center];
404             if (cp.fromBlock == blockNumber) {
405                 return cp.votes;
406             } else if (cp.fromBlock < blockNumber) {
407                 lower = center;
408             } else {
409                 upper = center - 1;
410             }
411         }
412         return checkpoints[account][lower].votes;
413     }
414 
415     function _delegate(address delegator, address delegatee)
416         internal
417     {
418         address currentDelegate = _delegates[delegator];
419         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying T42s (not scaled);
420         _delegates[delegator] = delegatee;
421 
422         emit DelegateChanged(delegator, currentDelegate, delegatee);
423 
424         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
425     }
426 
427     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
428         if (srcRep != dstRep && amount > 0) {
429             if (srcRep != address(0)) {
430                 // decrease old representative
431                 uint32 srcRepNum = numCheckpoints[srcRep];
432                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
433                 uint256 srcRepNew = srcRepOld.sub(amount);
434                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
435             }
436 
437             if (dstRep != address(0)) {
438                 // increase new representative
439                 uint32 dstRepNum = numCheckpoints[dstRep];
440                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
441                 uint256 dstRepNew = dstRepOld.add(amount);
442                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
443             }
444         }
445     }
446 
447     function _writeCheckpoint(
448         address delegatee,
449         uint32 nCheckpoints,
450         uint256 oldVotes,
451         uint256 newVotes
452     )
453         internal
454     {
455         uint32 blockNumber = safe32(block.number, "PARA::_writeCheckpoint: block number exceeds 32 bits");
456 
457         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
458             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
459         } else {
460             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
461             numCheckpoints[delegatee] = nCheckpoints + 1;
462         }
463 
464         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
465     }
466 
467     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
468         require(n < 2**32, errorMessage);
469         return uint32(n);
470     }
471 
472     function getChainId() internal pure returns (uint) {
473         uint256 chainId;
474         assembly { chainId := chainid() }
475         return chainId;
476     }
477 }