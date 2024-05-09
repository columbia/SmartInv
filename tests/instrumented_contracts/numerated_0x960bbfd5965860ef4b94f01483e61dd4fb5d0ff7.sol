1 pragma solidity ^0.5.0;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * @notice Renouncing to ownership will leave the contract without an owner.
49      * It will not be possible to call the functions with the `onlyOwner`
50      * modifier anymore.
51      */
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 // File: contracts/Certification.sol
77 
78 contract ICertification {
79   event Certificate(bytes32 indexed certHash, bytes32 innerHash, address indexed certifier);
80   event Revocation(bytes32 indexed certHash, bool invalid);  
81   address public newAddress;
82   uint public genesis;
83 }
84 
85 contract Certification is ICertification, Ownable {
86 
87   struct Certifier {
88     bool valid;
89     string id;
90   }
91 
92   mapping (address => Certifier) public certifiers;  
93   mapping (bytes32 => bool) public revoked;  
94 
95   constructor() public {
96     genesis = block.number;
97   }
98 
99   function setCertifierStatus(address certifier, bool valid)
100   onlyOwner public {
101     certifiers[certifier].valid = valid;
102   }
103 
104   function setCertifierId(address certifier, string memory id)
105   onlyOwner public {
106     certifiers[certifier].id = id;
107   }
108 
109   function computeCertHash(address certifier, bytes32 innerHash)
110   pure public returns (bytes32) {
111     return keccak256(abi.encodePacked(certifier, innerHash));
112   }
113 
114   function _certify(bytes32 innerHash) internal {
115     emit Certificate(
116       computeCertHash(msg.sender, innerHash),
117       innerHash, msg.sender
118     );
119   }
120 
121   function certifyMany(bytes32[] memory innerHashes) public {
122     require(certifiers[msg.sender].valid);
123     for(uint i = 0; i < innerHashes.length; i++) {
124       _certify(innerHashes[i]);
125     }
126   }
127 
128   function revoke(bytes32 innerHash, address certifier, bool invalid) public {
129     require(isOwner() || (certifiers[msg.sender].valid && msg.sender == certifier && invalid));
130     bytes32 certHash = computeCertHash(certifier, innerHash);
131     emit Revocation(certHash, invalid);
132     revoked[certHash] = invalid;
133   }
134 
135   function deprecate(address _newAddress) public onlyOwner {
136     newAddress = _newAddress;
137   }
138 
139 }