1 // File: contracts/dev/BlockhashStore.sol
2 
3 pragma solidity 0.6.6;
4 
5 /**
6  * @title BlockhashStore
7  * @notice This contract provides a way to access blockhashes older than
8  *   the 256 block limit imposed by the BLOCKHASH opcode.
9  *   You may assume that any blockhash stored by the contract is correct.
10  *   Note that the contract depends on the format of serialized Ethereum
11  *   blocks. If a future hardfork of Ethereum changes that format, the 
12  *   logic in this contract may become incorrect and an updated version 
13  *   would have to be deployed.
14  */
15 contract BlockhashStore {
16 
17   mapping(uint => bytes32) internal s_blockhashes;
18 
19   /**
20    * @notice stores blockhash of a given block, assuming it is available through BLOCKHASH
21    * @param n the number of the block whose blockhash should be stored
22    */
23   function store(uint256 n) public {
24     bytes32 h = blockhash(n);
25     require(h != 0x0, "blockhash(n) failed");
26     s_blockhashes[n] = h;
27   }
28 
29 
30   /**
31    * @notice stores blockhash of the earliest block still available through BLOCKHASH.
32    */
33   function storeEarliest() external {
34     store(block.number - 256);
35   }
36 
37   /**
38    * @notice stores blockhash after verifying blockheader of child/subsequent block
39    * @param n the number of the block whose blockhash should be stored
40    * @param header the rlp-encoded blockheader of block n+1. We verify its correctness by checking
41    *   that it hashes to a stored blockhash, and then extract parentHash to get the n-th blockhash.
42    */
43   function storeVerifyHeader(uint256 n, bytes memory header) public {
44     require(keccak256(header) == s_blockhashes[n + 1], "header has unknown blockhash");
45 
46     // At this point, we know that header is the correct blockheader for block n+1.
47 
48     // The header is an rlp-encoded list. The head item of that list is the 32-byte blockhash of the parent block.
49     // Based on how rlp works, we know that blockheaders always have the following form:
50     // 0xf9____a0PARENTHASH...
51     //   ^ ^   ^
52     //   | |   |
53     //   | |   +--- PARENTHASH is 32 bytes. rlpenc(PARENTHASH) is 0xa || PARENTHASH.
54     //   | |
55     //   | +--- 2 bytes containing the sum of the lengths of the encoded list items
56     //   |
57     //   +--- 0xf9 because we have a list and (sum of lengths of encoded list items) fits exactly into two bytes.
58     //
59     // As a consequence, the PARENTHASH is always at offset 4 of the rlp-encoded block header.
60 
61     bytes32 parentHash;
62     assembly {
63       parentHash := mload(add(header, 36)) // 36 = 32 byte offset for length prefix of ABI-encoded array
64                                            //    +  4 byte offset of PARENTHASH (see above)
65     }
66 
67     s_blockhashes[n] = parentHash;
68   }
69 
70   /**
71    * @notice gets a blockhash from the store. If no hash is known, this function reverts.
72    * @param n the number of the block whose blockhash should be returned
73    */
74   function getBlockhash(uint256 n) external view returns (bytes32) {
75     bytes32 h = s_blockhashes[n];
76     require(h != 0x0, "blockhash not found in store");
77     return h;
78   }
79 }