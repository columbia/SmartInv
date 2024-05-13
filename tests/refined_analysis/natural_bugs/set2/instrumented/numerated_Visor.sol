1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity 0.7.6;
3 pragma abicoder v2;
4 
5 import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";
6 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
7 
8 import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
9 import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
10 
11 import {Initializable} from "@openzeppelin/contracts/proxy/Initializable.sol";
12 import {EnumerableSet} from "@openzeppelin/contracts/utils/EnumerableSet.sol";
13 import {Address} from "@openzeppelin/contracts/utils/Address.sol";
14 import {TransferHelper} from "@uniswap/lib/contracts/libraries/TransferHelper.sol";
15 
16 import {EIP712} from "./EIP712.sol";
17 import {ERC1271} from "./ERC1271.sol";
18 import {OwnableERC721} from "./OwnableERC721.sol";
19 import {IRageQuit} from "../hypervisor/Hypervisor.sol";
20 
21 import {IUniversalVault} from "../interfaces/IUniversalVault.sol";
22 import {IVisorService} from "../interfaces/IVisorService.sol";
23 
24 /// @title Visor
25 /// @notice Vault for isolated storage of staking tokens
26 /// @dev Warning: not compatible with rebasing tokens
27 contract Visor is
28     IUniversalVault,
29     EIP712("UniversalVault", "1.0.0"),
30     ERC1271,
31     OwnableERC721,
32     Initializable,
33     IERC721Receiver
34 {
35     using SafeMath for uint256;
36     using Address for address;
37     using Address for address payable;
38     using EnumerableSet for EnumerableSet.Bytes32Set;
39 
40     /* constant */
41 
42     // Hardcoding a gas limit for rageQuit() is required to prevent gas DOS attacks
43     // the gas requirement cannot be determined at runtime by querying the delegate
44     // as it could potentially be manipulated by a malicious delegate who could force
45     // the calls to revert.
46     // The gas limit could alternatively be set upon vault initialization or creation
47     // of a lock, but the gas consumption trade-offs are not favorable.
48     // Ultimately, to avoid a need for fixed gas limits, the EVM would need to provide
49     // an error code that allows for reliably catching out-of-gas errors on remote calls.
50     uint256 public constant RAGEQUIT_GAS = 500000;
51     bytes32 public constant LOCK_TYPEHASH =
52         keccak256("Lock(address delegate,address token,uint256 amount,uint256 nonce)");
53     bytes32 public constant UNLOCK_TYPEHASH =
54         keccak256("Unlock(address delegate,address token,uint256 amount,uint256 nonce)");
55 
56     string public constant VERSION = "VISOR-2.0.3";
57 
58     /* storage */
59 
60     uint256 private _nonce;
61     mapping(bytes32 => LockData) private _locks;
62     EnumerableSet.Bytes32Set private _lockSet;
63     string public uri;
64 
65     struct Nft {
66       uint256 tokenId; 
67       address nftContract;
68     }
69 
70     Nft[] public nfts;
71     mapping(bytes32=>bool) public nftApprovals;
72     mapping(bytes32=>uint256) public erc20Approvals;
73 
74     struct TimelockERC20 {
75       address recipient;
76       address token;
77       uint256 amount;
78       uint256 expires;
79     }
80 
81     mapping(bytes32=>TimelockERC20) public timelockERC20s; 
82     mapping(address=>bytes32[]) public timelockERC20Keys;
83     mapping(address=>uint256) public timelockERC20Balances;
84 
85     struct TimelockERC721 {
86       address recipient;
87       address nftContract;
88       uint256 tokenId;
89       uint256 expires;
90     }
91 
92     mapping(bytes32=>TimelockERC721) public timelockERC721s; 
93     mapping(address=>bytes32[]) public timelockERC721Keys;
94 
95     event AddNftToken(address nftContract, uint256 tokenId);
96     event RemoveNftToken(address nftContract, uint256 tokenId);
97     event TimeLockERC20(address recipient, address token, uint256 amount, uint256 expires);
98     event TimeUnlockERC20(address recipient, address token, uint256 amount, uint256 expires);
99     event TimeLockERC721(address recipient, address nftContract, uint256 tokenId, uint256 expires);
100     event TimeUnlockERC721(address recipient, address nftContract, uint256 tokenId, uint256 expires);
101 
102     /* initialization function */
103 
104     function initializeLock() external initializer {}
105 
106     function initialize() external override initializer {
107       OwnableERC721._setNFT(msg.sender);
108     }
109 
110     /* ether receive */
111 
112     receive() external payable {}
113 
114     /* internal  */
115 
116     function _addNft(address nftContract, uint256 tokenId) internal {
117 
118       nfts.push(
119         Nft({
120           tokenId: tokenId,
121           nftContract: nftContract
122         })
123       );
124       emit AddNftToken(nftContract, tokenId);
125     }
126 
127     function _removeNft(address nftContract, uint256 tokenId) internal {
128       uint256 len = nfts.length;
129       for (uint256 i = 0; i < len; i++) {
130         Nft memory nftInfo = nfts[i];
131         if (nftContract == nftInfo.nftContract && tokenId == nftInfo.tokenId) {
132           if(i != len - 1) {
133             nfts[i] = nfts[len - 1];
134           }
135           nfts.pop();
136           emit RemoveNftToken(nftContract, tokenId);
137           break;
138         }
139       }
140     }
141 
142     function _getOwner() internal view override(ERC1271) returns (address ownerAddress) {
143         return OwnableERC721.owner();
144     }
145 
146     /* pure functions */
147 
148     function calculateLockID(address delegate, address token)
149         public
150         pure
151         override
152         returns (bytes32 lockID)
153     {
154         return keccak256(abi.encodePacked(delegate, token));
155     }
156 
157     /* getter functions */
158 
159     function getPermissionHash(
160         bytes32 eip712TypeHash,
161         address delegate,
162         address token,
163         uint256 amount,
164         uint256 nonce
165     ) public view override returns (bytes32 permissionHash) {
166         return
167             EIP712._hashTypedDataV4(
168                 keccak256(abi.encode(eip712TypeHash, delegate, token, amount, nonce))
169             );
170     }
171 
172     function getNonce() external view override returns (uint256 nonce) {
173         return _nonce;
174     }
175 
176     function owner()
177         public
178         view
179         override(IUniversalVault, OwnableERC721)
180         returns (address ownerAddress)
181     {
182         return OwnableERC721.owner();
183     }
184 
185     function getLockSetCount() external view override returns (uint256 count) {
186         return _lockSet.length();
187     }
188 
189     function getLockAt(uint256 index) external view override returns (LockData memory lockData) {
190         return _locks[_lockSet.at(index)];
191     }
192 
193     function getBalanceDelegated(address token, address delegate)
194         external
195         view
196         override
197         returns (uint256 balance)
198     {
199         return _locks[calculateLockID(delegate, token)].balance;
200     }
201 
202     function getBalanceLocked(address token) public view override returns (uint256 balance) {
203         uint256 count = _lockSet.length();
204         for (uint256 index; index < count; index++) {
205             LockData storage _lockData = _locks[_lockSet.at(index)];
206             if (_lockData.token == token && _lockData.balance > balance)
207                 balance = _lockData.balance;
208         }
209         return balance;
210     }
211 
212     function checkBalances() external view override returns (bool validity) {
213         // iterate over all token locks and validate sufficient balance
214         uint256 count = _lockSet.length();
215         for (uint256 index; index < count; index++) {
216             // fetch storage lock reference
217             LockData storage _lockData = _locks[_lockSet.at(index)];
218             // if insufficient balance and no∏t shutdown, return false
219             if (IERC20(_lockData.token).balanceOf(address(this)) < _lockData.balance) return false;
220         }
221         // if sufficient balance or shutdown, return true
222         return true;
223     }
224 
225     // @notice Get ERC721 from nfts[] by index
226     /// @param i nfts index of nfts[] 
227     function getNftById(uint256 i) external view returns (address nftContract, uint256 tokenId) {
228         require(i < nfts.length, "ID overflow");
229         Nft memory ni = nfts[i];
230         nftContract = ni.nftContract;
231         tokenId = ni.tokenId;
232     }
233 
234     // @notice Get index of ERC721 in nfts[]
235     /// @param nftContract Address of ERC721 
236     /// @param tokenId tokenId for NFT in nftContract 
237     function getNftIdByTokenIdAndAddr(address nftContract, uint256 tokenId) external view returns(uint256) {
238         uint256 len = nfts.length;
239         for (uint256 i = 0; i < len; i++) {
240             if (nftContract == nfts[i].nftContract && tokenId == nfts[i].tokenId) {
241                 return i;
242             }
243         }
244         require(false, "Token not found");
245     }
246 
247     // @notice Get number of timelocks for given ERC20 token 
248     function getTimeLockCount(address token) public view returns(uint256) {
249       return timelockERC20Keys[token].length;
250     }
251 
252     // @notice Get number of timelocks for NFTs of a given ERC721 contract 
253     function getTimeLockERC721Count(address nftContract) public view returns(uint256) {
254       return timelockERC721Keys[nftContract].length;
255     }
256 
257     /* user functions */
258 
259     /// @notice Lock ERC20 tokens in the vault
260     /// access control: called by delegate with signed permission from owner
261     /// state machine: anytime
262     /// state scope:
263     /// - insert or update _locks
264     /// - increase _nonce
265     /// token transfer: none
266     /// @param token Address of token being locked
267     /// @param amount Amount of tokens being locked
268     /// @param permission Permission signature payload
269     function lock(
270         address token,
271         uint256 amount,
272         bytes calldata permission
273     )
274         external
275         override
276         onlyValidSignature(
277             getPermissionHash(LOCK_TYPEHASH, msg.sender, token, amount, _nonce),
278             permission
279         )
280     {
281         // get lock id
282         bytes32 lockID = calculateLockID(msg.sender, token);
283 
284         // add lock to storage
285         if (_lockSet.contains(lockID)) {
286             // if lock already exists, increase amount
287             _locks[lockID].balance = _locks[lockID].balance.add(amount);
288         } else {
289             // if does not exist, create new lock
290             // add lock to set
291             assert(_lockSet.add(lockID));
292             // add lock data to storage
293             _locks[lockID] = LockData(msg.sender, token, amount);
294         }
295 
296         // validate sufficient balance
297         require(
298             IERC20(token).balanceOf(address(this)) >= _locks[lockID].balance,
299             "UniversalVault: insufficient balance"
300         );
301 
302         // increase nonce
303         _nonce += 1;
304 
305         // emit event
306         emit Locked(msg.sender, token, amount);
307     }
308 
309     /// @notice Unlock ERC20 tokens in the vault
310     /// access control: called by delegate with signed permission from owner
311     /// state machine: after valid lock from delegate
312     /// state scope:
313     /// - remove or update _locks
314     /// - increase _nonce
315     /// token transfer: none
316     /// @param token Address of token being unlocked
317     /// @param amount Amount of tokens being unlocked
318     /// @param permission Permission signature payload
319     function unlock(
320         address token,
321         uint256 amount,
322         bytes calldata permission
323     )
324         external
325         override
326         onlyValidSignature(
327             getPermissionHash(UNLOCK_TYPEHASH, msg.sender, token, amount, _nonce),
328             permission
329         )
330     {
331         // get lock id
332         bytes32 lockID = calculateLockID(msg.sender, token);
333 
334         // validate existing lock
335         require(_lockSet.contains(lockID), "UniversalVault: missing lock");
336 
337         // update lock data
338         if (_locks[lockID].balance > amount) {
339             // substract amount from lock balance
340             _locks[lockID].balance = _locks[lockID].balance.sub(amount);
341         } else {
342             // delete lock data
343             delete _locks[lockID];
344             assert(_lockSet.remove(lockID));
345         }
346 
347         // increase nonce
348         _nonce += 1;
349 
350         // emit event
351         emit Unlocked(msg.sender, token, amount);
352     }
353 
354     /// @notice Forcibly cancel delegate lock
355     /// @dev This function will attempt to notify the delegate of the rage quit using
356     ///      a fixed amount of gas.
357     /// access control: only owner
358     /// state machine: after valid lock from delegate
359     /// state scope:
360     /// - remove item from _locks
361     /// token transfer: none
362     /// @param delegate Address of delegate
363     /// @param token Address of token being unlocked
364     function rageQuit(address delegate, address token)
365         external
366         override
367         onlyOwner
368         returns (bool notified, string memory error)
369     {
370         // get lock id
371         bytes32 lockID = calculateLockID(delegate, token);
372 
373         // validate existing lock
374         require(_lockSet.contains(lockID), "UniversalVault: missing lock");
375 
376         // attempt to notify delegate
377         if (delegate.isContract()) {
378             // check for sufficient gas
379             require(gasleft() >= RAGEQUIT_GAS, "UniversalVault: insufficient gas");
380 
381             // attempt rageQuit notification
382             try IRageQuit(delegate).rageQuit{gas: RAGEQUIT_GAS}() {
383                 notified = true;
384             } catch Error(string memory res) {
385                 notified = false;
386                 error = res;
387             } catch (bytes memory) {
388                 notified = false;
389             }
390         }
391 
392         // update lock storage
393         assert(_lockSet.remove(lockID));
394         delete _locks[lockID];
395 
396         // emit event
397         emit RageQuit(delegate, token, notified, error);
398     }
399 
400     function setURI(string memory _uri) public onlyOwner {
401       uri = _uri;
402     }
403 
404     /// @notice Transfer ERC20 tokens out of vault
405     /// access control: only owner
406     /// state machine: when balance >= max(lock) + amount
407     /// state scope: none
408     /// token transfer: transfer any token
409     /// @param token Address of token being transferred
410     /// @param to Address of the to
411     /// @param amount Amount of tokens to transfer
412     function transferERC20(
413         address token,
414         address to,
415         uint256 amount
416     ) external override onlyOwner {
417         // check for sufficient balance
418         require(
419             IERC20(token).balanceOf(address(this)) >= (getBalanceLocked(token).add(amount)).add(timelockERC20Balances[token]),
420             "UniversalVault: insufficient balance"
421         );
422         // perform transfer
423         TransferHelper.safeTransfer(token, to, amount);
424     }
425 
426     // @notice Approve delegate account to transfer ERC20 tokens out of vault
427     /// @param token Address of token being transferred
428     /// @param delegate Address being approved
429     /// @param amount Amount of tokens approved to transfer
430     function approveTransferERC20(address token, address delegate, uint256 amount) external onlyOwner {
431       erc20Approvals[keccak256(abi.encodePacked(delegate, token))] = amount;
432     }
433 
434     /// @notice Transfer ERC20 tokens out of vault with an approved account
435     /// access control: only approved accounts in erc20Approvals 
436     /// state machine: when balance >= max(lock) + amount
437     /// state scope: none
438     /// token transfer: transfer any token
439     /// @param token Address of token being transferred
440     /// @param to Address of the to
441     /// @param amount Amount of tokens to transfer
442     function delegatedTransferERC20(
443         address token,
444         address to,
445         uint256 amount
446     ) external {
447         if(msg.sender != _getOwner()) {
448 
449         require( 
450             erc20Approvals[keccak256(abi.encodePacked(msg.sender, token))] >= amount,
451             "Account not approved to transfer amount"); 
452         } 
453 
454         // check for sufficient balance
455         require(
456             IERC20(token).balanceOf(address(this)) >= (getBalanceLocked(token).add(amount)).add(timelockERC20Balances[token]),
457             "UniversalVault: insufficient balance"
458         );
459         erc20Approvals[keccak256(abi.encodePacked(msg.sender, token))] = erc20Approvals[keccak256(abi.encodePacked(msg.sender, token))].sub(amount);
460         
461         // perform transfer
462         TransferHelper.safeTransfer(token, to, amount);
463     }
464 
465     /// @notice Transfer ETH out of vault
466     /// access control: only owner
467     /// state machine: when balance >= amount
468     /// state scope: none
469     /// token transfer: transfer any token
470     /// @param to Address of the to
471     /// @param amount Amount of ETH to transfer
472     function transferETH(address to, uint256 amount) external payable override onlyOwner {
473       // perform transfer
474       TransferHelper.safeTransferETH(to, amount);
475     }
476 
477     // @notice Approve delegate account to transfer ERC721 token out of vault
478     /// @param delegate Account address being approved to transfer nft  
479     /// @param nftContract address of nft minter 
480     /// @param tokenId token id of the nft instance 
481     function approveTransferERC721(
482       address delegate, 
483       address nftContract, 
484       uint256 tokenId
485     ) external onlyOwner {
486       nftApprovals[keccak256(abi.encodePacked(delegate, nftContract, tokenId))] = true;
487     }
488 
489     /// @notice Transfer ERC721 out of vault
490     /// access control: only owner or approved
491     /// ERC721 transfer: transfer any ERC721 token
492     /// @param to recipient address 
493     /// @param nftContract address of nft minter 
494     /// @param tokenId token id of the nft instance 
495     function transferERC721(
496         address to,
497         address nftContract,
498         uint256 tokenId
499     ) external {
500         if(msg.sender != _getOwner()) {
501           require( nftApprovals[keccak256(abi.encodePacked(msg.sender, nftContract, tokenId))], "NFT not approved for transfer"); 
502         } 
503 
504         for(uint256 i=0; i<timelockERC721Keys[nftContract].length; i++) {
505           if(tokenId == timelockERC721s[timelockERC721Keys[nftContract][i]].tokenId) {
506               require(
507                 timelockERC721s[timelockERC721Keys[nftContract][i]].expires <= block.timestamp, 
508                 "NFT locked and not expired"
509               );
510               require( timelockERC721s[timelockERC721Keys[nftContract][i]].recipient == msg.sender, "NFT locked and must be withdrawn by timelock recipient");
511           }
512         }
513 
514         _removeNft(nftContract, tokenId);
515         IERC721(nftContract).safeTransferFrom(address(this), to, tokenId);
516     }
517 
518     // @notice Adjust nfts[] on ERC721 token recieved 
519     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata) external override returns (bytes4) {
520       _addNft(msg.sender, tokenId);
521       return IERC721Receiver.onERC721Received.selector;
522     }
523 
524     // @notice Lock ERC721 in vault until expires, redeemable by recipient
525     /// @param recipient Address with right to withdraw after expires 
526     /// @param nftContract address of nft minter 
527     /// @param tokenId Token id of the nft instance 
528     /// @param expires Timestamp when recipient is allowed to withdraw 
529     function timeLockERC721(address recipient, address nftContract, uint256 tokenId, uint256 expires) public onlyOwner {
530 
531       require(
532         expires > block.timestamp, 
533         "Expires must be in future"
534       );
535  
536       bytes32 key = keccak256(abi.encodePacked(recipient, nftContract, tokenId, expires)); 
537 
538       require(
539         timelockERC721s[key].expires == 0,
540         "TimelockERC721 already exists"
541       );
542      
543       timelockERC721s[key] = TimelockERC721({
544           recipient: recipient,
545           nftContract: nftContract,
546           tokenId: tokenId,
547           expires: expires
548       });
549 
550       timelockERC721Keys[nftContract].push(key);
551 
552       IERC721(nftContract).safeTransferFrom(msg.sender, address(this), tokenId);
553       emit TimeLockERC20(recipient, nftContract, tokenId, expires);
554     }
555 
556     // @notice Withdraw ERC721 in vault post expires by recipient
557     /// @param recipient Address with right to withdraw after expires 
558     /// @param nftContract address of nft minter 
559     /// @param tokenId Token id of the nft instance 
560     /// @param expires Timestamp when recipient is allowed to withdraw
561     function timeUnlockERC721(address recipient, address nftContract, uint256 tokenId, uint256 expires) public {
562 
563       bytes32 key = keccak256(abi.encodePacked(recipient, nftContract, tokenId, expires)); 
564       require(
565         timelockERC721s[key].expires <= block.timestamp,
566         "Not expired yet"
567       );
568 
569       require(msg.sender == timelockERC721s[key].recipient, "Not recipient");
570 
571       _removeNft(nftContract, tokenId);
572       delete timelockERC721s[key];
573 
574       IERC721(nftContract).safeTransferFrom(address(this), recipient, tokenId);
575       emit TimeUnlockERC721(recipient, nftContract, tokenId, expires);
576     }
577 
578     // @notice Lock ERC720 amount in vault until expires, redeemable by recipient
579     /// @param recipient Address with right to withdraw after expires 
580     /// @param token Address of token to lock 
581     /// @param amount Amount of token to lock 
582     /// @param expires Timestamp when recipient is allowed to withdraw
583     function timeLockERC20(address recipient, address token, uint256 amount, uint256 expires) public onlyOwner {
584 
585       require(
586         IERC20(token).allowance(msg.sender, address(this)) >= amount, 
587         "Amount not approved"
588       );
589 
590       require(
591         expires > block.timestamp, 
592         "Expires must be in future"
593       );
594 
595       bytes32 key = keccak256(abi.encodePacked(recipient, token, amount, expires)); 
596 
597       require(
598         timelockERC20s[key].expires == 0,
599         "TimelockERC20 already exists"
600       );
601     
602       timelockERC20s[key] = TimelockERC20({
603           recipient: recipient,
604           token: token,
605           amount: amount,
606           expires: expires
607       });
608       timelockERC20Keys[token].push(key);
609       timelockERC20Balances[token] = timelockERC20Balances[token].add(amount);
610       IERC20(token).transferFrom(msg.sender, address(this), amount);
611       emit TimeLockERC20(recipient, token, amount, expires);
612     }
613 
614     // @notice Withdraw ERC20 from vault post expires by recipient
615     /// @param recipient Address with right to withdraw after expires 
616     /// @param token Address of token to lock 
617     /// @param amount Amount of token to lock 
618     /// @param expires Timestamp when recipient is allowed to withdraw
619     function timeUnlockERC20(address recipient, address token, uint256 amount, uint256 expires) public {
620 
621       require(
622         IERC20(token).balanceOf(address(this)) >= getBalanceLocked(token).add(amount),
623         "Insufficient balance"
624       );
625 
626       bytes32 key = keccak256(abi.encodePacked(recipient, token, amount, expires)); 
627       require(
628         timelockERC20s[key].expires <= block.timestamp,
629         "Not expired yet"
630       );
631 
632       require(msg.sender == timelockERC20s[key].recipient, "Not recipient");
633       
634       delete timelockERC20s[key];
635 
636       timelockERC20Balances[token] = timelockERC20Balances[token].sub(amount);
637       TransferHelper.safeTransfer(token, recipient, amount);
638       emit TimeUnlockERC20(recipient, token, amount, expires);
639     }
640 
641 }
