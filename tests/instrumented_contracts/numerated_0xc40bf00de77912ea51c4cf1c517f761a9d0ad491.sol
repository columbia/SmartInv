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
43 contract AudigentAudience is Ownable {
44     struct Signature {
45         address partner;
46         address[] signatures;
47     }
48 
49     mapping (uint256 => Signature) private _hashToSignature;
50     mapping (address => address) private _signerToPartner;
51 
52     modifier onlyPartnerSigner(uint256 _hash) {
53         require(_signerToPartner[msg.sender] == _hashToSignature[_hash].partner);
54         _;
55     }
56 
57     modifier onlySignerPartner(address _signer) {
58         require(_signerToPartner[_signer] == msg.sender);
59         _;
60     }
61 
62     modifier onlyNewSigner(address _signer) {
63         if (_signerToPartner[_signer] == msg.sender) {
64             revert('Signer already assigned to this partner');
65         }
66         require(_signer != owner);
67         require(_signerToPartner[_signer] != _signer);
68         require(_signerToPartner[_signer] == address(0));
69         _;
70     }
71 
72     modifier onlyHashPartner(uint256 _hash) {
73         require(_hashToSignature[_hash].partner == msg.sender);
74         _;
75     }
76 
77     function createHash(uint256 _hash, address _partner) public onlyOwner {
78         if (_hashToSignature[_hash].partner != address(0)) {
79             revert('Hash already exists');
80         }
81         _hashToSignature[_hash] = Signature(_partner, new address[](0));
82     }
83 
84     function transferHashOwnership(uint256 _hash, address _newOwner) public onlyHashPartner(_hash) {
85         require(_newOwner != address(0));
86         _hashToSignature[_hash].partner = _newOwner;
87     }
88 
89     function addSigner(address _signer) public onlyNewSigner(_signer) {
90         _signerToPartner[_signer] = msg.sender;
91     }
92 
93     function removeSigner(address _signer) public onlySignerPartner(_signer) {
94         _signerToPartner[_signer] = address(0);
95     }
96 
97     function signHash(uint256 _hash) public onlyPartnerSigner(_hash) {
98         address[] memory signatures = _hashToSignature[_hash].signatures;
99 
100         bool alreadySigned = false;
101         for (uint i = 0; i < signatures.length; i++) {
102             if (signatures[i] == msg.sender) {
103                 alreadySigned = true;
104                 break;
105             }
106         }
107         if (alreadySigned == true) {
108             revert('Hash already signed');
109         }
110 
111         _hashToSignature[_hash].signatures.push(msg.sender);
112     }
113 
114     function isHashSigned(uint256 _hash) public view returns (bool isSigned) {
115         return _hashToSignature[_hash].signatures.length > 0;
116     }
117 
118     function getHashSignatures(uint256 _hash) public view returns (address[] signatures) {
119         return _hashToSignature[_hash].signatures;
120     }
121 }