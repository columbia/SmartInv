1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 
68 /**
69  * @title ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/20
71  */
72 interface IERC20 {
73   function totalSupply() external view returns (uint256);
74 
75   function balanceOf(address who) external view returns (uint256);
76 
77   function allowance(address owner, address spender)
78     external view returns (uint256);
79 
80   function transfer(address to, uint256 value) external returns (bool);
81 
82   function approve(address spender, uint256 value)
83     external returns (bool);
84 
85   function transferFrom(address from, address to, uint256 value)
86     external returns (bool);
87 
88   event Transfer(
89     address indexed from,
90     address indexed to,
91     uint256 value
92   );
93 
94   event Approval(
95     address indexed owner,
96     address indexed spender,
97     uint256 value
98   );
99 }
100 
101 
102 /**
103  * Abstract contract, requires implementation to specify who can commit blocks and what
104  *   happens when a successful proof is presented
105  * Verifies Merkle-tree inclusion proofs that show that certain address has
106  *   certain earnings balance, according to hash published ("signed") by a
107  *   sidechain operator or similar authority
108  *
109  * ABOUT Merkle-tree inclusion proof: Merkle-tree inclusion proof is an algorithm to prove memebership
110  * in a set using minimal [ie log(N)] inputs. The hashes of the items are arranged by hash value in a binary Merkle tree where 
111  * each node contains a hash of the hashes of nodes below. The root node (ie "root hash") contains hash information 
112  * about the entire set, and that is the data that BalanceVerifier posts to the blockchain. To prove membership, you walk up the 
113  * tree from the node in question, and use the supplied hashes (the "proof") to fill in the hashes from the adjacent nodes. The proof  
114  * succeeds iff you end up with the known root hash when you get to the top of the tree. 
115  * See https://medium.com/crypto-0-nite/merkle-proofs-explained-6dd429623dc5
116  *
117  * Merkle-tree inclusion proof is a RELATED concept to the blockchain Merkle tree, but a somewhat DIFFERENT application. 
118  * BalanceVerifier posts the root hash of the CURRENT ledger only, and this does NOT depend on the hash of previous ledgers.
119  * This is different from the blockchain, where each block contains the hash of the previous block. 
120  *
121  * TODO: see if it could be turned into a library, so many contracts could use it
122  */
123 contract BalanceVerifier {
124     event BlockCreated(uint blockNumber, bytes32 rootHash, string ipfsHash);
125 
126     /**
127      * Sidechain "blocks" are simply root hashes of merkle-trees constructed from its balances
128      * @param uint root-chain block number after which the balances were recorded
129      * @return bytes32 root of the balances merkle-tree at that time
130      */
131     mapping (uint => bytes32) public blockHash;
132 
133     /**
134      * Handler for proof of sidechain balances
135      * It is up to the implementing contract to actually distribute out the balances
136      * @param blockNumber the block whose hash was used for verification
137      * @param account whose balances were successfully verified
138      * @param balance the side-chain account balance
139      */
140     function onVerifySuccess(uint blockNumber, address account, uint balance) internal;
141 
142     /**
143      * Implementing contract should should do access checks for committing
144      */
145     function onCommit(uint blockNumber, bytes32 rootHash, string ipfsHash) internal;
146 
147     /**
148      * Side-chain operator submits commitments to main chain. These
149      * For convenience, also publish the ipfsHash of the balance book JSON object
150      * @param blockNumber the block after which the balances were recorded
151      * @param rootHash root of the balances merkle-tree
152      * @param ipfsHash where the whole balances object can be retrieved in JSON format
153      */
154     function commit(uint blockNumber, bytes32 rootHash, string ipfsHash) external {
155         require(blockHash[blockNumber] == 0, "error_overwrite");
156         string memory _hash = ipfsHash;
157         onCommit(blockNumber, rootHash, _hash);
158         blockHash[blockNumber] = rootHash;
159         emit BlockCreated(blockNumber, rootHash, _hash);
160     }
161 
162     /**
163      * Proving can be used to record the sidechain balances permanently into root chain
164      * @param blockNumber the block after which the balances were recorded
165      * @param account whose balances will be verified
166      * @param balance side-chain account balance
167      * @param proof list of hashes to prove the totalEarnings
168      */
169     function prove(uint blockNumber, address account, uint balance, bytes32[] memory proof) public {
170         require(proofIsCorrect(blockNumber, account, balance, proof), "error_proof");
171         onVerifySuccess(blockNumber, account, balance);
172     }
173 
174     /**
175      * Check the merkle proof of balance in the given side-chain block for given account
176      */
177     function proofIsCorrect(uint blockNumber, address account, uint balance, bytes32[] memory proof) public view returns(bool) {
178         bytes32 hash = keccak256(abi.encodePacked(account, balance));
179         bytes32 rootHash = blockHash[blockNumber];
180         require(rootHash != 0x0, "error_blockNotFound");
181         return rootHash == calculateRootHash(hash, proof);
182     }
183 
184     /**
185      * Calculate root hash of a Merkle tree, given
186      * @param hash of the leaf to verify
187      * @param others list of hashes of "other" branches
188      */
189     function calculateRootHash(bytes32 hash, bytes32[] memory others) public pure returns (bytes32 root) {
190         root = hash;
191         for (uint8 i = 0; i < others.length; i++) {
192             bytes32 other = others[i];
193             if (other == 0x0) continue;     // odd branch, no need to hash
194             if (root < other) {
195                 root = keccak256(abi.encodePacked(root, other));
196             } else {
197                 root = keccak256(abi.encodePacked(other, root));
198             }
199         }
200     }
201 }
202 
203 /**
204  * @title Ownable
205  * @dev The Ownable contract has an owner address, and provides basic authorization control
206  * functions, this simplifies the implementation of "user permissions".
207  */
208 contract Ownable {
209     address public owner;
210     address public pendingOwner;
211 
212     event OwnershipTransferred(
213         address indexed previousOwner,
214         address indexed newOwner
215     );
216 
217     /**
218      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
219      * account.
220      */
221     constructor() public {
222         owner = msg.sender;
223     }
224 
225     /**
226      * @dev Throws if called by any account other than the owner.
227      */
228     modifier onlyOwner() {
229         require(msg.sender == owner, "onlyOwner");
230         _;
231     }
232 
233     /**
234      * @dev Allows the current owner to set the pendingOwner address.
235      * @param newOwner The address to transfer ownership to.
236      */
237     function transferOwnership(address newOwner) public onlyOwner {
238         pendingOwner = newOwner;
239     }
240 
241     /**
242      * @dev Allows the pendingOwner address to finalize the transfer.
243      */
244     function claimOwnership() public {
245         require(msg.sender == pendingOwner, "onlyPendingOwner");
246         emit OwnershipTransferred(owner, pendingOwner);
247         owner = pendingOwner;
248         pendingOwner = address(0);
249     }
250 }
251 
252 
253 
254 
255 /**
256  * Monoplasma that is managed by an owner, likely the side-chain operator
257  * Owner can add and remove recipients.
258  */
259 contract Monoplasma is BalanceVerifier, Ownable {
260     using SafeMath for uint256;
261 
262     event OperatorChanged(address indexed newOperator);
263     event AdminFeeChanged(uint adminFee);
264     /**
265      * Freeze period during which all side-chain participants should be able to
266      *   acquire the whole balance book from IPFS (or HTTP server, or elsewhere)
267      *   and validate that the published rootHash is correct
268      * In case of incorrect rootHash, all members should issue withdrawals from the
269      *   latest block they have validated (that is older than blockFreezeSeconds)
270      * So: too short freeze period + bad availability => ether (needlessly) spent withdrawing earnings
271      *     long freeze period == lag between purchase and withdrawal => bad UX
272      * Blocks older than blockFreezeSeconds can be used to withdraw funds
273      */
274     uint public blockFreezeSeconds;
275 
276     /**
277      * Block number => timestamp
278      * Publish time of a block, where the block freeze period starts from.
279      * Note that block number points to the block after which the root hash is calculated,
280      *   not the block where BlockCreated was emitted (event must come later)
281      */
282     mapping (uint => uint) public blockTimestamp;
283 
284     address public operator;
285 
286     //fee fraction = adminFee/10^18
287     uint public adminFee;
288 
289     IERC20 public token;
290 
291     mapping (address => uint) public earnings;
292     mapping (address => uint) public withdrawn;
293     uint public totalWithdrawn;
294     uint public totalProven;
295 
296     constructor(address tokenAddress, uint blockFreezePeriodSeconds, uint _adminFee) public {
297         blockFreezeSeconds = blockFreezePeriodSeconds;
298         token = IERC20(tokenAddress);
299         operator = msg.sender;
300         setAdminFee(_adminFee);
301     }
302 
303     function setOperator(address newOperator) public onlyOwner {
304         operator = newOperator;
305         emit OperatorChanged(newOperator);
306     }
307 
308     /**
309      * Admin fee as a fraction of revenue
310      * Fixed-point decimal in the same way as ether: 50% === 0.5 ether
311      * Smart contract doesn't use it, it's here just for storing purposes
312      */
313     function setAdminFee(uint _adminFee) public onlyOwner {
314         require(adminFee <= 1 ether, "Admin fee cannot be greater than 1");
315         adminFee = _adminFee;
316         emit AdminFeeChanged(_adminFee);
317     }
318 
319     /**
320      * Operator creates the side-chain blocks
321      */
322     function onCommit(uint blockNumber, bytes32, string) internal {
323         require(msg.sender == operator, "error_notPermitted");
324         blockTimestamp[blockNumber] = now;
325     }
326 
327     /**
328      * Called from BalanceVerifier.prove
329      * Prove can be called directly to withdraw less than the whole share,
330      *   or just "cement" the earnings so far into root chain even without withdrawing
331      */
332     function onVerifySuccess(uint blockNumber, address account, uint newEarnings) internal {
333         uint blockFreezeStart = blockTimestamp[blockNumber];
334         require(now > blockFreezeStart + blockFreezeSeconds, "error_frozen");
335         require(earnings[account] < newEarnings, "error_oldEarnings");
336         totalProven = totalProven.add(newEarnings).sub(earnings[account]);
337         require(totalProven.sub(totalWithdrawn) <= token.balanceOf(this), "error_missingBalance");
338         earnings[account] = newEarnings;
339     }
340 
341     /**
342      * Prove and withdraw the whole revenue share from sidechain in one transaction
343      * @param blockNumber of the leaf to verify
344      * @param totalEarnings in the side-chain
345      * @param proof list of hashes to prove the totalEarnings
346      */
347     function withdrawAll(uint blockNumber, uint totalEarnings, bytes32[] proof) external {
348         withdrawAllFor(msg.sender, blockNumber, totalEarnings, proof);
349     }
350 
351     /**
352      * Prove and withdraw the whole revenue share for someone else
353      * Validator needs to exit those it's watching out for, in case
354      *   it detects Operator malfunctioning
355      * @param recipient the address we're proving and withdrawing
356      * @param blockNumber of the leaf to verify
357      * @param totalEarnings in the side-chain
358      * @param proof list of hashes to prove the totalEarnings
359      */
360     function withdrawAllFor(address recipient, uint blockNumber, uint totalEarnings, bytes32[] proof) public {
361         prove(blockNumber, recipient, totalEarnings, proof);
362         uint withdrawable = totalEarnings.sub(withdrawn[recipient]);
363         withdrawTo(recipient, recipient, withdrawable);
364     }
365 
366     /**
367      * "Donate withdraw" function that allows you to prove and transfer
368      *   your earnings to a another address in one transaction
369      * @param recipient the address the tokens will be sent to (instead of msg.sender)
370      * @param blockNumber of the leaf to verify
371      * @param totalEarnings in the side-chain
372      * @param proof list of hashes to prove the totalEarnings
373      */
374     function withdrawAllTo(address recipient, uint blockNumber, uint totalEarnings, bytes32[] proof) external {
375         prove(blockNumber, msg.sender, totalEarnings, proof);
376         uint withdrawable = totalEarnings.sub(withdrawn[msg.sender]);
377         withdrawTo(recipient, msg.sender, withdrawable);
378     }
379 
380     /**
381      * Withdraw a specified amount of your own proven earnings (see `function prove`)
382      */
383     function withdraw(uint amount) public {
384         withdrawTo(msg.sender, msg.sender, amount);
385     }
386 
387     /**
388      * Do the withdrawal on behalf of someone else
389      * Validator needs to exit those it's watching out for, in case
390      *   it detects Operator malfunctioning
391      */
392     function withdrawFor(address recipient, uint amount) public {
393         withdrawTo(recipient, recipient, amount);
394     }
395 
396     /**
397      * Execute token withdrawal into specified recipient address from specified member account
398      * @dev It is up to the sidechain implementation to make sure
399      * @dev  always token balance >= sum of earnings - sum of withdrawn
400      */
401     function withdrawTo(address recipient, address account, uint amount) public {
402         require(amount > 0, "error_zeroWithdraw");
403         uint w = withdrawn[account].add(amount);
404         require(w <= earnings[account], "error_overdraft");
405         withdrawn[account] = w;
406         totalWithdrawn = totalWithdrawn.add(amount);
407         require(token.transfer(recipient, amount), "error_transfer");
408     }
409 }
410 
411 
412 contract CommunityProduct is Monoplasma {
413 
414     string public joinPartStream;
415 
416     constructor(address operator, string joinPartStreamId, address tokenAddress, uint blockFreezePeriodSeconds, uint adminFeeFraction)
417     Monoplasma(tokenAddress, blockFreezePeriodSeconds, adminFeeFraction) public {
418         setOperator(operator);
419         joinPartStream = joinPartStreamId;
420     }
421 }