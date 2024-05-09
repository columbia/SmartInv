1 pragma solidity ^0.4.19;
2 
3 // A 2/3 multisig contract which is compatible with Trezor-signed messages.
4 //
5 // To authorize a spend, two signtures must be provided by 2 of the 3 owners.
6 // To generate the message to be signed, provide the destination address and
7 // spend amount (in wei) to the generateMessageToSignmethod.
8 // The signatures must be provided as the (v, r, s) hex-encoded coordinates.
9 // The S coordinate must be 0x00 or 0x01 corresponding to 0x1b and 0x1c, respectively.
10 // See the test file for example inputs.
11 //
12 // If you use other software than the provided dApp or scripts to sign the message,
13 // verify that the message shown by the trezor device matches the generated message in hex.
14 //
15 // WARNING: The generated message is only valid until the next spend is executed.
16 //          after that, a new message will need to be calculated.
17 //
18 // WARNING: The signing algorithm Trezor uses is different than that
19 // of Ledger, Geth, Etc. This contract is for Trezor managed private
20 // keys ONLY.
21 //
22 // ADDITIONAL WARNING: This contract is **NOT** ERC20 compatible.
23 // Tokens sent to this contract will be lost forever.
24 //
25 contract TrezorMultiSig2of3 {
26 
27   // The 3 addresses which control the funds in this contract.  The
28   // owners of 2 of these addresses will need to both sign a message
29   // allowing the funds in this contract to be spent.
30   mapping(address => bool) private owners;
31 
32   // The contract nonce is not accessible to the contract so we
33   // implement a nonce-like variable for replay protection.
34   uint256 public spendNonce = 0;
35 
36   // Contract Versioning
37   uint256 public unchainedMultisigVersionMajor = 1;
38   uint256 public unchainedMultisigVersionMinor = 0;   
39   
40   // An event sent when funds are received.
41   event Funded(uint new_balance);
42   
43   // An event sent when a spend is triggered to the given address.
44   event Spent(address to, uint transfer);
45 
46   // Instantiate a new Trezor Multisig 2 of 3 contract owned by the
47   // three given addresses
48   function TrezorMultiSig2of3(address owner1, address owner2, address owner3) public {
49     address zeroAddress = 0x0;
50     
51     require(owner1 != zeroAddress);
52     require(owner2 != zeroAddress);
53     require(owner3 != zeroAddress);
54 
55     require(owner1 != owner2);
56     require(owner2 != owner3);
57     require(owner1 != owner3);
58     
59     owners[owner1] = true;
60     owners[owner2] = true;
61     owners[owner3] = true;
62   }
63 
64   // The fallback function for this contract.
65   function() public payable {
66     Funded(this.balance);
67   }
68 
69   // Generates the message to sign given the output destination address and amount.
70   // includes this contract's address and a nonce for replay protection.
71   // One option to  independently verify: https://leventozturk.com/engineering/sha3/ and select keccak
72   function generateMessageToSign(address destination, uint256 value) public constant returns (bytes32) {
73     require(destination != address(this));
74     bytes32 message = keccak256(spendNonce, this, value, destination);
75     return message;
76   }
77   
78   // Send the given amount of ETH to the given destination using
79   // the two triplets (v1, r1, s1) and (v2, r2, s2) as signatures.
80   // s1 and s2 should be 0x00 or 0x01 corresponding to 0x1b and 0x1c respectively.
81   function spend(address destination, uint256 value, uint8 v1, bytes32 r1, bytes32 s1, uint8 v2, bytes32 r2, bytes32 s2) public {
82     // This require is handled by generateMessageToSign()
83     // require(destination != address(this));
84     require(this.balance >= value);
85     require(_validSignature(destination, value, v1, r1, s1, v2, r2, s2));
86     spendNonce = spendNonce + 1;
87     destination.transfer(value);
88     Spent(destination, value);
89   }
90 
91   // Confirm that the two signature triplets (v1, r1, s1) and (v2, r2, s2)
92   // both authorize a spend of this contract's funds to the given
93   // destination address.
94   function _validSignature(address destination, uint256 value, uint8 v1, bytes32 r1, bytes32 s1, uint8 v2, bytes32 r2, bytes32 s2) private constant returns (bool) {
95     bytes32 message = _messageToRecover(destination, value);
96     address addr1   = ecrecover(message, v1+27, r1, s1);
97     address addr2   = ecrecover(message, v2+27, r2, s2);
98     require(_distinctOwners(addr1, addr2));
99     return true;
100   }
101 
102   // Generate the the unsigned message (in bytes32) that each owner's
103   // Trezor would have signed for the given destination and amount.
104   //
105   // The generated message from generateMessageToSign is converted to
106   // ascii when signed by a trezor.
107   //
108   // The required Trezor signing prefix, the length of this
109   // unsigned message, and the unsigned ascii message itself are
110   // then concatenated and hashed with keccak256.
111   function _messageToRecover(address destination, uint256 value) private constant returns (bytes32) {
112     bytes32 hashedUnsignedMessage = generateMessageToSign(destination, value);
113     bytes memory unsignedMessageBytes = _hashToAscii(hashedUnsignedMessage);
114     bytes memory prefix = "\x19Ethereum Signed Message:\n";
115     return keccak256(prefix,bytes1(unsignedMessageBytes.length),unsignedMessageBytes);
116   }
117 
118   
119   // Confirm the pair of addresses as two distinct owners of this contract.
120   function _distinctOwners(address addr1, address addr2) private constant returns (bool) {
121     // Check that both addresses are different
122     require(addr1 != addr2);
123     // Check that both addresses are owners
124     require(owners[addr1]);
125     require(owners[addr2]);
126     return true;
127   }
128 
129 
130   // Construct the byte representation of the ascii-encoded
131   // hashed message written in hex.
132    function _hashToAscii(bytes32 hash) private pure returns (bytes) {
133     bytes memory s = new bytes(64);
134     for (uint i = 0; i < 32; i++) {
135       byte b  = hash[i];
136       byte hi = byte(uint8(b) / 16);
137       byte lo = byte(uint8(b) - 16 * uint8(hi));
138       s[2*i]   = _char(hi);
139       s[2*i+1] = _char(lo);            
140     }
141     return s;    
142   }
143   
144   // Convert from byte to ASCII of 0-f
145   // http://www.unicode.org/charts/PDF/U0000.pdf
146   function _char(byte b) private pure returns (byte c) {
147     if (b < 10) return byte(uint8(b) + 0x30);
148     else return byte(uint8(b) + 0x57);
149   }
150 }