1 pragma solidity ^0.4.17;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) onlyOwner public {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 
47 
48 
49 
50 /**
51  * @title Eliptic curve signature operations
52  *
53  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
54  */
55 
56 library ECRecovery {
57 
58   /**
59    * @dev Recover signer address from a message by using his signature
60    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
61    * @param sig bytes signature, the signature is generated using web3.eth.sign()
62    */
63   function recover(bytes32 hash, bytes sig) public pure returns (address) {
64     bytes32 r;
65     bytes32 s;
66     uint8 v;
67 
68     //Check the signature length
69     if (sig.length != 65) {
70       return (address(0));
71     }
72 
73     // Divide the signature in r, s and v variables
74     assembly {
75       r := mload(add(sig, 32))
76       s := mload(add(sig, 64))
77       v := byte(0, mload(add(sig, 96)))
78     }
79 
80     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
81     if (v < 27) {
82       v += 27;
83     }
84 
85     // If the version is correct return the signer address
86     if (v != 27 && v != 28) {
87       return (address(0));
88     } else {
89       return ecrecover(hash, v, r, s);
90     }
91   }
92 
93 }
94 
95 /**
96  * @title EthealWhitelist
97  * @author thesved
98  * @notice EthealWhitelist contract which handles KYC
99  */
100 contract EthealWhitelist is Ownable {
101     using ECRecovery for bytes32;
102 
103     // signer address for offchain whitelist signing
104     address public signer;
105 
106     // storing whitelisted addresses
107     mapping(address => bool) public isWhitelisted;
108 
109     event WhitelistSet(address indexed _address, bool _state);
110 
111     ////////////////
112     // Constructor
113     ////////////////
114     function EthealWhitelist(address _signer) {
115         require(_signer != address(0));
116 
117         signer = _signer;
118     }
119 
120     /// @notice set signing address after deployment
121     function setSigner(address _signer) public onlyOwner {
122         require(_signer != address(0));
123 
124         signer = _signer;
125     }
126 
127     ////////////////
128     // Whitelisting: only owner
129     ////////////////
130 
131     /// @notice Set whitelist state for an address.
132     function setWhitelist(address _addr, bool _state) public onlyOwner {
133         require(_addr != address(0));
134         isWhitelisted[_addr] = _state;
135         WhitelistSet(_addr, _state);
136     }
137 
138     /// @notice Set whitelist state for multiple addresses
139     function setManyWhitelist(address[] _addr, bool _state) public onlyOwner {
140         for (uint256 i = 0; i < _addr.length; i++) {
141             setWhitelist(_addr[i], _state);
142         }
143     }
144 
145     /// @notice offchain whitelist check
146     function isOffchainWhitelisted(address _addr, bytes _sig) public view returns (bool) {
147         bytes32 hash = keccak256("\x19Ethereum Signed Message:\n20",_addr);
148         return hash.recover(_sig) == signer;
149     }
150 }