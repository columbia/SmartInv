1 pragma solidity ^0.4.4;
2 
3 contract EthereumDIDRegistry {
4 
5   mapping(address => address) public owners;
6   mapping(address => mapping(bytes32 => mapping(address => uint))) public delegates;
7   mapping(address => uint) public changed;
8   mapping(address => uint) public nonce;
9 
10   modifier onlyOwner(address identity, address actor) {
11     require (actor == identityOwner(identity));
12     _;
13   }
14 
15   event DIDOwnerChanged(
16     address indexed identity,
17     address owner,
18     uint previousChange
19   );
20 
21   event DIDDelegateChanged(
22     address indexed identity,
23     bytes32 delegateType,
24     address delegate,
25     uint validTo,
26     uint previousChange
27   );
28 
29   event DIDAttributeChanged(
30     address indexed identity,
31     bytes32 name,
32     bytes value,
33     uint validTo,
34     uint previousChange
35   );
36 
37   function identityOwner(address identity) public view returns(address) {
38      address owner = owners[identity];
39      if (owner != 0x0) {
40        return owner;
41      }
42      return identity;
43   }
44 
45   function checkSignature(address identity, uint8 sigV, bytes32 sigR, bytes32 sigS, bytes32 hash) internal returns(address) {
46     address signer = ecrecover(hash, sigV, sigR, sigS);
47     require(signer == identityOwner(identity));
48     nonce[identity]++;
49     return signer;
50   }
51 
52   function validDelegate(address identity, bytes32 delegateType, address delegate) public view returns(bool) {
53     uint validity = delegates[identity][keccak256(delegateType)][delegate];
54     return (validity > now);
55   }
56 
57   function changeOwner(address identity, address actor, address newOwner) internal onlyOwner(identity, actor) {
58     owners[identity] = newOwner;
59     emit DIDOwnerChanged(identity, newOwner, changed[identity]);
60     changed[identity] = block.number;
61   }
62 
63   function changeOwner(address identity, address newOwner) public {
64     changeOwner(identity, msg.sender, newOwner);
65   }
66 
67   function changeOwnerSigned(address identity, uint8 sigV, bytes32 sigR, bytes32 sigS, address newOwner) public {
68     bytes32 hash = keccak256(byte(0x19), byte(0), this, nonce[identityOwner(identity)], identity, "changeOwner", newOwner);
69     changeOwner(identity, checkSignature(identity, sigV, sigR, sigS, hash), newOwner);
70   }
71 
72   function addDelegate(address identity, address actor, bytes32 delegateType, address delegate, uint validity) internal onlyOwner(identity, actor) {
73     delegates[identity][keccak256(delegateType)][delegate] = now + validity;
74     emit DIDDelegateChanged(identity, delegateType, delegate, now + validity, changed[identity]);
75     changed[identity] = block.number;
76   }
77 
78   function addDelegate(address identity, bytes32 delegateType, address delegate, uint validity) public {
79     addDelegate(identity, msg.sender, delegateType, delegate, validity);
80   }
81 
82   function addDelegateSigned(address identity, uint8 sigV, bytes32 sigR, bytes32 sigS, bytes32 delegateType, address delegate, uint validity) public {
83     bytes32 hash = keccak256(byte(0x19), byte(0), this, nonce[identityOwner(identity)], identity, "addDelegate", delegateType, delegate, validity);
84     addDelegate(identity, checkSignature(identity, sigV, sigR, sigS, hash), delegateType, delegate, validity);
85   }
86 
87   function revokeDelegate(address identity, address actor, bytes32 delegateType, address delegate) internal onlyOwner(identity, actor) {
88     delegates[identity][keccak256(delegateType)][delegate] = now;
89     emit DIDDelegateChanged(identity, delegateType, delegate, now, changed[identity]);
90     changed[identity] = block.number;
91   }
92 
93   function revokeDelegate(address identity, bytes32 delegateType, address delegate) public {
94     revokeDelegate(identity, msg.sender, delegateType, delegate);
95   }
96 
97   function revokeDelegateSigned(address identity, uint8 sigV, bytes32 sigR, bytes32 sigS, bytes32 delegateType, address delegate) public {
98     bytes32 hash = keccak256(byte(0x19), byte(0), this, nonce[identityOwner(identity)], identity, "revokeDelegate", delegateType, delegate);
99     revokeDelegate(identity, checkSignature(identity, sigV, sigR, sigS, hash), delegateType, delegate);
100   }
101 
102   function setAttribute(address identity, address actor, bytes32 name, bytes value, uint validity ) internal onlyOwner(identity, actor) {
103     emit DIDAttributeChanged(identity, name, value, now + validity, changed[identity]);
104     changed[identity] = block.number;
105   }
106 
107   function setAttribute(address identity, bytes32 name, bytes value, uint validity) public {
108     setAttribute(identity, msg.sender, name, value, validity);
109   }
110 
111   function setAttributeSigned(address identity, uint8 sigV, bytes32 sigR, bytes32 sigS, bytes32 name, bytes value, uint validity) public {
112     bytes32 hash = keccak256(byte(0x19), byte(0), this, nonce[identity], identity, "setAttribute", name, value, validity);
113     setAttribute(identity, checkSignature(identity, sigV, sigR, sigS, hash), name, value, validity);
114   }
115 
116   function revokeAttribute(address identity, address actor, bytes32 name, bytes value ) internal onlyOwner(identity, actor) {
117     emit DIDAttributeChanged(identity, name, value, 0, changed[identity]);
118     changed[identity] = block.number;
119   }
120 
121   function revokeAttribute(address identity, bytes32 name, bytes value) public {
122     revokeAttribute(identity, msg.sender, name, value);
123   }
124 
125  function revokeAttributeSigned(address identity, uint8 sigV, bytes32 sigR, bytes32 sigS, bytes32 name, bytes value) public {
126     bytes32 hash = keccak256(byte(0x19), byte(0), this, nonce[identity], identity, "revokeAttribute", name, value); 
127     revokeAttribute(identity, checkSignature(identity, sigV, sigR, sigS, hash), name, value);
128   }
129 
130 }