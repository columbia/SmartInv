1 pragma solidity 0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     uint256 public totalSupply;
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20     function allowance(address owner, address spender) public view returns (uint256);
21     function transferFrom(address from, address to, uint256 value) public returns (bool);
22     function approve(address spender, uint256 value) public returns (bool);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32         if (a == 0) {
33             return 0;
34         }
35         uint256 c = a * b;
36         assert(c / a == b);
37         return c;
38     }
39 
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41         // assert(b > 0); // Solidity automatically throws when dividing by 0
42         uint256 c = a / b;
43         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44         return c;
45     }
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         assert(b <= a);
49         return a - b;
50     }
51 
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         assert(c >= a);
55         return c;
56     }
57 }
58 
59 /*
60  * @title MerkleProof
61  * @dev Merkle proof verification
62  * @note Based on https://github.com/ameensol/merkle-tree-solidity/blob/master/src/MerkleProof.sol
63  */
64 library MerkleProof {
65   /*
66    * @dev Verifies a Merkle proof proving the existence of a leaf in a Merkle tree. Assumes that each pair of leaves
67    * and each pair of pre-images is sorted.
68    * @param _proof Merkle proof containing sibling hashes on the branch from the leaf to the root of the Merkle tree
69    * @param _root Merkle root
70    * @param _leaf Leaf of Merkle tree
71    */
72   function verifyProof(bytes _proof, bytes32 _root, bytes32 _leaf) public pure returns (bool) {
73     // Check if proof length is a multiple of 32
74     if (_proof.length % 32 != 0) return false;
75 
76     bytes32 proofElement;
77     bytes32 computedHash = _leaf;
78 
79     for (uint256 i = 32; i <= _proof.length; i += 32) {
80       assembly {
81         // Load the current element of the proof
82         proofElement := mload(add(_proof, i))
83       }
84 
85       if (computedHash < proofElement) {
86         // Hash(current computed hash + current element of the proof)
87         computedHash = keccak256(computedHash, proofElement);
88       } else {
89         // Hash(current element of the proof + current computed hash)
90         computedHash = keccak256(proofElement, computedHash);
91       }
92     }
93 
94     // Check if the computed hash (root) is equal to the provided root
95     return computedHash == _root;
96   }
97 }
98 
99 /**
100  * @title MerkleMine
101  * @dev Token distribution based on providing Merkle proofs of inclusion in genesis state to generate allocation
102  */
103 contract MerkleMine {
104     using SafeMath for uint256;
105 
106     // ERC20 token being distributed
107     ERC20 public token;
108     // Merkle root representing genesis state which encodes token recipients
109     bytes32 public genesisRoot;
110     // Total amount of tokens that can be generated
111     uint256 public totalGenesisTokens;
112     // Total number of recipients included in genesis state
113     uint256 public totalGenesisRecipients;
114     // Amount of tokens per recipient allocation. Equal to `totalGenesisTokens` / `totalGenesisRecipients`
115     uint256 public tokensPerAllocation;
116     // Minimum ETH balance threshold for recipients included in genesis state
117     uint256 public balanceThreshold;
118     // Block number of genesis - used to determine which ETH accounts are included in the genesis state
119     uint256 public genesisBlock;
120     // Start block where a third party caller (not the recipient) can generate and split the allocation with the recipient
121     // As the current block gets closer to `callerAllocationEndBlock`, the caller receives a larger precentage of the allocation
122     uint256 public callerAllocationStartBlock;
123     // From this block onwards, a third party caller (not the recipient) can generate and claim the recipient's full allocation
124     uint256 public callerAllocationEndBlock;
125     // Number of blocks in the caller allocation period as defined by `callerAllocationEndBlock` - `callerAllocationStartBlock`
126     uint256 public callerAllocationPeriod;
127 
128     // Track if the generation process is started
129     bool public started;
130 
131     // Track the already generated allocations for recipients
132     mapping (address => bool) public generated;
133 
134     // Check that a recipient's allocation has not been generated
135     modifier notGenerated(address _recipient) {
136         require(!generated[_recipient]);
137         _;
138     }
139 
140     // Check that the generation period is started
141     modifier isStarted() {
142         require(started);
143         _;
144     }
145 
146     // Check that the generation period is not started
147     modifier isNotStarted() {
148         require(!started);
149         _;
150     }
151 
152     event Generate(address indexed _recipient, address indexed _caller, uint256 _recipientTokenAmount, uint256 _callerTokenAmount, uint256 _block);
153 
154     /**
155      * @dev MerkleMine constructor
156      * @param _token ERC20 token being distributed
157      * @param _genesisRoot Merkle root representing genesis state which encodes token recipients
158      * @param _totalGenesisTokens Total amount of tokens that can be generated
159      * @param _totalGenesisRecipients Total number of recipients included in genesis state
160      * @param _balanceThreshold Minimum ETH balance threshold for recipients included in genesis state
161      * @param _genesisBlock Block number of genesis - used to determine which ETH accounts are included in the genesis state
162      * @param _callerAllocationStartBlock Start block where a third party caller (not the recipient) can generate and split the allocation with the recipient
163      * @param _callerAllocationEndBlock From this block onwards, a third party caller (not the recipient) can generate and claim the recipient's full allocation
164      */
165     function MerkleMine(
166         address _token,
167         bytes32 _genesisRoot,
168         uint256 _totalGenesisTokens,
169         uint256 _totalGenesisRecipients,
170         uint256 _balanceThreshold,
171         uint256 _genesisBlock,
172         uint256 _callerAllocationStartBlock,
173         uint256 _callerAllocationEndBlock
174     )
175         public
176     {
177         // Address of token contract must not be null
178         require(_token != address(0));
179         // Number of recipients must be non-zero
180         require(_totalGenesisRecipients > 0);
181         // Genesis block must be at or before the current block
182         require(_genesisBlock <= block.number);
183         // Start block for caller allocation must be after current block
184         require(_callerAllocationStartBlock > block.number);
185         // End block for caller allocation must be after caller allocation start block
186         require(_callerAllocationEndBlock > _callerAllocationStartBlock);
187 
188         token = ERC20(_token);
189         genesisRoot = _genesisRoot;
190         totalGenesisTokens = _totalGenesisTokens;
191         totalGenesisRecipients = _totalGenesisRecipients;
192         tokensPerAllocation = _totalGenesisTokens.div(_totalGenesisRecipients);
193         balanceThreshold = _balanceThreshold;
194         genesisBlock = _genesisBlock;
195         callerAllocationStartBlock = _callerAllocationStartBlock;
196         callerAllocationEndBlock = _callerAllocationEndBlock;
197         callerAllocationPeriod = _callerAllocationEndBlock.sub(_callerAllocationStartBlock);
198     }
199 
200     /**
201      * @dev Start the generation period - first checks that this contract's balance is equal to `totalGenesisTokens`
202      * The generation period must not already be started
203      */
204     function start() external isNotStarted {
205         // Check that this contract has a sufficient balance for the generation period
206         require(token.balanceOf(this) >= totalGenesisTokens);
207 
208         started = true;
209     }
210 
211     /**
212      * @dev Generate a recipient's token allocation. Generation period must be started. Starting from `callerAllocationStartBlock`
213      * a third party caller (not the recipient) can invoke this function to generate the recipient's token
214      * allocation and claim a percentage of it. The percentage of the allocation claimed by the
215      * third party caller is determined by how many blocks have elapsed since `callerAllocationStartBlock`.
216      * After `callerAllocationEndBlock`, a third party caller can claim the full allocation
217      * @param _recipient Recipient of token allocation
218      * @param _merkleProof Proof of recipient's inclusion in genesis state Merkle root
219      */
220     function generate(address _recipient, bytes _merkleProof) external isStarted notGenerated(_recipient) {
221         // Check the Merkle proof
222         bytes32 leaf = keccak256(_recipient);
223         // _merkleProof must prove inclusion of _recipient in the genesis state root
224         require(MerkleProof.verifyProof(_merkleProof, genesisRoot, leaf));
225 
226         generated[_recipient] = true;
227 
228         address caller = msg.sender;
229 
230         if (caller == _recipient) {
231             // If the caller is the recipient, transfer the full allocation to the caller/recipient
232             require(token.transfer(_recipient, tokensPerAllocation));
233 
234             Generate(_recipient, _recipient, tokensPerAllocation, 0, block.number);
235         } else {
236             // If the caller is not the recipient, the token allocation generation
237             // can only take place if we are in the caller allocation period
238             require(block.number >= callerAllocationStartBlock);
239 
240             uint256 callerTokenAmount = callerTokenAmountAtBlock(block.number);
241             uint256 recipientTokenAmount = tokensPerAllocation.sub(callerTokenAmount);
242 
243             if (callerTokenAmount > 0) {
244                 require(token.transfer(caller, callerTokenAmount));
245             }
246 
247             if (recipientTokenAmount > 0) {
248                 require(token.transfer(_recipient, recipientTokenAmount));
249             }
250 
251             Generate(_recipient, caller, recipientTokenAmount, callerTokenAmount, block.number);
252         }
253     }
254 
255     /**
256      * @dev Return the amount of tokens claimable by a third party caller when generating a recipient's token allocation at a given block
257      * @param _blockNumber Block at which to compute the amount of tokens claimable by a third party caller
258      */
259     function callerTokenAmountAtBlock(uint256 _blockNumber) public view returns (uint256) {
260         if (_blockNumber < callerAllocationStartBlock) {
261             // If the block is before the start of the caller allocation period, the third party caller can claim nothing
262             return 0;
263         } else if (_blockNumber >= callerAllocationEndBlock) {
264             // If the block is at or after the end block of the caller allocation period, the third party caller can claim everything
265             return tokensPerAllocation;
266         } else {
267             // During the caller allocation period, the third party caller can claim an increasing percentage
268             // of the recipient's allocation based on a linear curve - as more blocks pass in the caller allocation
269             // period, the amount claimable by the third party caller increases linearly
270             uint256 blocksSinceCallerAllocationStartBlock = _blockNumber.sub(callerAllocationStartBlock);
271             return tokensPerAllocation.mul(blocksSinceCallerAllocationStartBlock).div(callerAllocationPeriod);
272         }
273     }
274 }
275 
276 /**
277  * @title BytesUtil
278  * @dev Utilities for extracting bytes from byte arrays
279  * Functions taken from:
280  * - https://github.com/ethereum/solidity-examples/blob/master/src/unsafe/Memory.sol
281  * - https://github.com/ethereum/solidity-examples/blob/master/src/bytes/Bytes.sol
282  */
283 library BytesUtil{
284     uint256 internal constant BYTES_HEADER_SIZE = 32;
285     uint256 internal constant WORD_SIZE = 32;
286     
287     /**
288      * @dev Returns a memory pointer to the data portion of the provided bytes array.
289      * @param bts Memory byte array
290      */
291     function dataPtr(bytes memory bts) internal pure returns (uint256 addr) {
292         assembly {
293             addr := add(bts, /*BYTES_HEADER_SIZE*/ 32)
294         }
295     }
296     
297     /**
298      * @dev Copy 'len' bytes from memory address 'src', to address 'dest'.
299      * This function does not check the or destination, it only copies
300      * the bytes.
301      * @param src Memory address of source byte array
302      * @param dest Memory address of destination byte array
303      * @param len Number of bytes to copy from `src` to `dest`
304      */
305     function copy(uint256 src, uint256 dest, uint256 len) internal pure {
306         // Copy word-length chunks while possible
307         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
308             assembly {
309                 mstore(dest, mload(src))
310             }
311             dest += WORD_SIZE;
312             src += WORD_SIZE;
313         }
314 
315         // Copy remaining bytes
316         uint256 mask = 256 ** (WORD_SIZE - len) - 1;
317         assembly {
318             let srcpart := and(mload(src), not(mask))
319             let destpart := and(mload(dest), mask)
320             mstore(dest, or(destpart, srcpart))
321         }
322     }
323 
324     /**
325      * @dev Creates a 'bytes memory' variable from the memory address 'addr', with the
326      * length 'len'. The function will allocate new memory for the bytes array, and
327      * the 'len bytes starting at 'addr' will be copied into that new memory.
328      * @param addr Memory address of input byte array
329      * @param len Number of bytes to copy from input byte array
330      */
331     function toBytes(uint256 addr, uint256 len) internal pure returns (bytes memory bts) {
332         bts = new bytes(len);
333         uint256 btsptr = dataPtr(bts);
334         copy(addr, btsptr, len);
335     }
336     
337     /**
338      * @dev Copies 'len' bytes from 'bts' into a new array, starting at the provided 'startIndex'.
339      * Returns the new copy.
340      * Requires that:
341      *  - 'startIndex + len <= self.length'
342      * The length of the substring is: 'len'
343      * @param bts Memory byte array to copy from
344      * @param startIndex Index of `bts` to start copying bytes from
345      * @param len Number of bytes to copy from `bts`
346      */
347     function substr(bytes memory bts, uint256 startIndex, uint256 len) internal pure returns (bytes memory) {
348         require(startIndex + len <= bts.length);
349         if (len == 0) {
350             return;
351         }
352         uint256 addr = dataPtr(bts);
353         return toBytes(addr + startIndex, len);
354     }
355 
356     /**
357      * @dev Reads a bytes32 value from a byte array by copying 32 bytes from `bts` starting at the provided `startIndex`.
358      * @param bts Memory byte array to copy from
359      * @param startIndex Index of `bts` to start copying bytes from
360      */
361     function readBytes32(bytes memory bts, uint256 startIndex) internal pure returns (bytes32 result) {
362         require(startIndex + 32 <= bts.length);
363 
364         uint256 addr = dataPtr(bts);
365 
366         assembly {
367             result := mload(add(addr, startIndex))
368         }
369 
370         return result;
371     }
372 }
373 
374 /**
375  * @title MultiMerkleMine
376  * @dev The MultiMerkleMine contract is purely a convenience wrapper around an existing MerkleMine contract deployed on the blockchain.
377  */
378 contract MultiMerkleMine {
379 	using SafeMath for uint256;
380 
381 	/**
382      * @dev Generates token allocations for multiple recipients. Generation period must be started.
383      * @param _merkleMineContract Address of the deployed MerkleMine contract
384      * @param _recipients Array of recipients
385      * @param _merkleProofs Proofs for respective recipients constructed in the format: 
386      *       [proof_1_size, proof_1, proof_2_size, proof_2, ... , proof_n_size, proof_n]
387      */
388 	function multiGenerate(address _merkleMineContract, address[] _recipients, bytes _merkleProofs) public {
389 		MerkleMine mine = MerkleMine(_merkleMineContract);
390 		ERC20 token = ERC20(mine.token());
391 
392 		require(
393 			block.number >= mine.callerAllocationStartBlock(),
394 			"caller allocation period has not started"
395 		);
396 		
397 		uint256 initialBalance = token.balanceOf(this);
398 		bytes[] memory proofs = new bytes[](_recipients.length);
399 
400 		// Counter to keep track of position in `_merkleProofs` byte array
401 		uint256 i = 0;
402 		// Counter to keep track of index of each extracted Merkle proof
403 		uint256 j = 0;
404 
405 		// Extract proofs
406 		while(i < _merkleProofs.length){
407 			uint256 proofSize = uint256(BytesUtil.readBytes32(_merkleProofs, i));
408 
409 			require(
410 				proofSize % 32 == 0,
411 				"proof size must be a multiple of 32"
412 			);
413 
414 			proofs[j] = BytesUtil.substr(_merkleProofs, i + 32, proofSize);
415 
416 			i = i + 32 + proofSize;
417 			j++;
418 		}
419 
420 		require(
421 			_recipients.length == j,
422 			"number of recipients != number of proofs"
423 		);
424 
425 		for (uint256 k = 0; k < _recipients.length; k++) {
426 			// If recipient's token allocation has not been generated, generate the token allocation
427 			// Else, continue to the next recipient
428 			if (!mine.generated(_recipients[k])) {
429 				mine.generate(_recipients[k], proofs[k]);
430 			}
431 		}
432 
433 		uint256 newBalanceSinceAllocation = token.balanceOf(this);
434 		uint256 callerTokensGenerated = newBalanceSinceAllocation.sub(initialBalance);
435 
436 		// Transfer caller's portion of tokens generated by this function call 
437 		if (callerTokensGenerated > 0) {
438 			require(token.transfer(msg.sender, callerTokensGenerated));
439 		}
440 	}
441 }