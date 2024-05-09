1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor() public {
18         owner = msg.sender;
19     }
20 
21 
22     /**
23      * @dev Throws if called by any account other than the owner.
24      */
25     modifier onlyOwner() {
26         require(msg.sender == owner);
27         _;
28     }
29 
30 
31     /**
32      * @dev Allows the current owner to transfer control of the contract to a newOwner.
33      * @param newOwner The address to transfer ownership to.
34      */
35     function transferOwnership(address newOwner) public onlyOwner {
36         require(newOwner != address(0));
37         emit OwnershipTransferred(owner, newOwner);
38         owner = newOwner;
39     }
40 
41 }
42 
43 contract AudigentSegment is Ownable {
44     mapping (uint256 => address[]) private _hashToSignatures;
45     mapping (address => address) private _signerToAgency;
46 
47     modifier onlyAlreadyExistingSigner(address _signer) {
48         require(_signerToAgency[_signer] == msg.sender);
49         _;
50     }
51 
52     modifier onlyNewSigner(address _signer) {
53         if (_signerToAgency[_signer] == msg.sender) {
54             revert('Signer already assigned to this agency');
55         }
56         require(_signer != owner);
57         require(_signerToAgency[_signer] != _signer);
58         require(_signerToAgency[_signer] == address(0));
59         _;
60     }
61 
62     modifier onlyAssociatedSigner() {
63         require(_signerToAgency[msg.sender] != address(0));
64         _;
65     }
66 
67     function createHash(uint256 _hash) public onlyOwner {
68         if (_hashToSignatures[_hash].length > 0) {
69             revert('Hash already exists');
70         }
71         _hashToSignatures[_hash] = new address[](0);
72     }
73 
74     function addSigner(address _signer) public onlyNewSigner(_signer) {
75         _signerToAgency[_signer] = msg.sender;
76     }
77 
78     function removeSigner(address _signer) public onlyAlreadyExistingSigner(_signer) {
79         _signerToAgency[_signer] = address(0);
80     }
81 
82     function signHash(uint256 _hash) public onlyAssociatedSigner {
83         address[] memory signatures = _hashToSignatures[_hash];
84 
85         bool alreadySigned = false;
86         for (uint i = 0; i < signatures.length; i++) {
87             if (signatures[i] == msg.sender) {
88                 alreadySigned = true;
89                 break;
90             }
91         }
92         if (alreadySigned == true) {
93             revert('Hash already signed');
94         }
95 
96         _hashToSignatures[_hash].push(msg.sender);
97     }
98 
99     function isHashSigned(uint256 _hash) public view returns (bool isSigned) {
100         return _hashToSignatures[_hash].length > 0;
101     }
102 
103     function getHashSignatures(uint256 _hash) public view returns (address[] signatures) {
104         return _hashToSignatures[_hash];
105     }
106 }