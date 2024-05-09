1 pragma solidity ^0.4.25;
2 contract SignatureContract {
3 
4     address private owner;
5 	address public signer;
6 	mapping(bytes32 => bool) public isSignedMerkleRoot;
7 
8 	event SignerSet(address indexed newSigner);
9 	event Signed(bytes32 indexed hash);
10 
11     constructor() public {
12         owner = msg.sender;
13     }
14 
15     modifier onlyByOwner {
16         require(msg.sender == owner, "Only owner can call this function!");
17         _;
18     }
19     
20     modifier onlyBySigner {
21         require(msg.sender == signer, "Only the current signer can call this function!");
22         _;
23     }
24 
25     function setSigner(address aSigner) external onlyByOwner {
26         require(aSigner != signer, "This address is already set as the current signer!");
27         signer = aSigner;
28         emit SignerSet(aSigner);
29     }
30 
31     function disable() external onlyByOwner {
32        delete signer;
33        delete owner;
34     }
35 
36     /*
37     *  Adds a SHA2-256 hash to the persisted map. This hash is supposed to be the root of the Merkle Tree of documents being signed.
38     *  Under the conventions of this contract, atleast one leaf of the Merkle Tree must be the SHA2-256 hash of this smart contract address. This allows proving non-membership by reproducing all the Merkle Trees.
39     */
40     function sign(bytes32 hash) external onlyBySigner {
41 		require(!isSignedMerkleRoot[hash], "This SHA2-256 hash is already signed!");
42 		isSignedMerkleRoot[hash] = true;
43 		emit Signed(hash);
44     }
45     
46     /*
47     *  Checks a given document hash for being a leaf of a signed Merkle Tree.
48     *  For the check to be performed the corresponding Merkle Proof is required along with an index encoding the position of siblings at each level (left or right).
49     */
50     function verifyDocument(bytes32 docHash, bytes merkleProof, uint16 index) external view returns (bool) {
51         require(merkleProof.length >= 32, "The Merkle Proof given is too short! It must be atleast 32 bytes in size.");
52         require(merkleProof.length <= 512, "The Merkle Proof given is too long! It can be upto only 512 bytes as the Merkle Tree is allowed a maximum depth of 16 under conventions of this contract.");
53         require(merkleProof.length%32 == 0, "The Merkle Proof given is not a multiple of 32 bytes! It must be a sequence of 32-byte SHA2-256 hashes each representing the sibling at every non-root level starting from leaf level in the Merkle Tree.");
54         
55         bytes32 root = docHash;
56         bytes32 sibling;
57         bytes memory proof = merkleProof;
58         
59         // This loop runs a maximum of 16 times with i = 32, 64, 96, ... proof.length. As i is uint16, no integer overflow possible.
60         // An upper limit of 16 iterations ensures that the function's gas requirements are within reasonable limits.
61         for(uint16 i=32; i<=proof.length; i+=32) {
62             assembly {
63                 sibling := mload(add(proof, i))     // reading 32 bytes
64             }
65             
66             // Now we have to find out if this sibling is on the right or on the left?
67             // This information is encoded in the i/32th bit from the right of the 16 bit integer index.
68             // To find this but we create a 16-bit mask with i/32th position as the only non-zero bit: uint16(1)<<(i/32-1)
69             // For example: for i=32, mask=0x0000000000000001.
70             // Note that since (i/32-1) is in the range 0-15, the left shift operation should be safe to use.
71             if(index & (uint16(1)<<(i/32-1)) == 0) {
72                 root = sha256(abi.encodePacked(root, sibling));
73             } else {
74                 root = sha256(abi.encodePacked(sibling, root));
75             }
76         }
77         
78         return isSignedMerkleRoot[root];
79     }
80 }