1 pragma solidity ^0.5.11;
2 
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 contract Context {
15     // Empty internal constructor, to prevent people from mistakenly deploying
16     // an instance of this contract, which should be used via inheritance.
17     constructor () internal { }
18     // solhint-disable-previous-line no-empty-blocks
19 
20     function _msgSender() internal view returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor () internal {
49         address msgSender = _msgSender();
50         _owner = msgSender;
51         emit OwnershipTransferred(address(0), msgSender);
52     }
53 
54     /**
55      * @dev Returns the address of the current owner.
56      */
57     function owner() public view returns (address) {
58         return _owner;
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(isOwner(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     /**
70      * @dev Returns true if the caller is the current owner.
71      */
72     function isOwner() public view returns (bool) {
73         return _msgSender() == _owner;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public onlyOwner {
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      */
99     function _transferOwnership(address newOwner) internal {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         emit OwnershipTransferred(_owner, newOwner);
102         _owner = newOwner;
103     }
104 }
105 
106 
107 
108 /**
109  * @title Catalizr
110  * @dev The Catalizr contract provide an easy way to proof the document is legit
111  */
112 contract Catalizr is Ownable {
113 
114     mapping(bytes32 => bytes32) public operations;
115 
116     /**
117     * @dev Allows the current owner to create a proof for an operation / document type
118     * @param _mixedHash mixed hash of the operationId hash and document_type hash
119     * @param _hashDocument hash of the document
120     */
121     function storeDocumentProof(bytes32 _mixedHash, bytes32 _hashDocument) public onlyOwner{
122         operations[_mixedHash] = _hashDocument;
123     }
124 
125     /**
126     * @dev Allows the current owner to create proofs for many operation / documentType
127     * @param _mixedHashes array of mixed hash of the operationId hash and document_type hash
128     * @param _hashDocuments array of hash of the documents
129     */
130     function storeDocumentsProofs(bytes32[] memory _mixedHashes, bytes32[] memory _hashDocuments) public onlyOwner{
131        for(uint i = 0; i < _mixedHashes.length; i++) {
132         operations[_mixedHashes[i]] = _hashDocuments[i];
133         }
134     }
135 
136     /**
137      * @dev Get the document hash from the hash of the operationId
138      * @param _mixedHash mixed hash of the operationId hash and document_type hash
139      */
140     function getDocumentHashbyMixedHash(bytes32 _mixedHash) public view returns (bytes32) {
141         return (operations[_mixedHash]);
142     }
143 
144 }