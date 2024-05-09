1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) onlyOwner public {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: contracts/Certification.sol
48 
49 contract Certification is Ownable {
50 
51   struct Certifier {
52     bool valid;
53     string id;
54   }
55 
56   mapping (address => Certifier) public certifiers;
57 
58   event Certificate(bytes32 indexed certHash, bytes32 innerHash, address indexed certifier);
59   event Revocation(bytes32 indexed certHash, bool invalid);
60 
61   function setCertifierInfo(address certifier, bool valid, string id)
62   onlyOwner public {
63     certifiers[certifier] = Certifier({
64       valid: valid,
65       id: id
66     });
67   }
68 
69   function computeCertHash(address certifier, bytes32 innerHash) pure public returns (bytes32) {
70     return keccak256(certifier, innerHash);
71   }
72 
73   function certify(bytes32 innerHash) public {
74     require(certifiers[msg.sender].valid);
75     Certificate(
76       computeCertHash(msg.sender, innerHash),
77       innerHash, msg.sender
78     );
79   }
80 
81   function revoke(bytes32 innerHash, address certifier, bool invalid) public {
82     require(msg.sender == owner
83       || (certifiers[msg.sender].valid && msg.sender == certifier)
84     );
85     Revocation(computeCertHash(certifier, innerHash), invalid);
86   }
87 
88 }