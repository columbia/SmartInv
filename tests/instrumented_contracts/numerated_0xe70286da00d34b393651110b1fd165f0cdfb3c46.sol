1 pragma solidity ^0.4.24;
2 
3 
4 // A 2/3 multisig contract compatible with Trezor or Ledger-signed messages.
5 //
6 // To authorize a spend, two signtures must be provided by 2 of the 3 owners.
7 // To generate the message to be signed, provide the destination address and
8 // spend amount (in wei) to the generateMessageToSignmethod.
9 // The signatures must be provided as the (v, r, s) hex-encoded coordinates.
10 // The S coordinate must be 0x00 or 0x01 corresponding to 0x1b and 0x1c
11 // (27 and 28), respectively.
12 // See the test file for example inputs.
13 //
14 // If you use other software than the provided dApp or scripts to sign the
15 // message, verify that the message shown by the device matches the
16 // generated message in hex.
17 //
18 // WARNING: The generated message is only valid until the next spend
19 //          is executed. After that, a new message will need to be calculated.
20 //
21 // ADDITIONAL WARNING: This contract is **NOT** ERC20 compatible.
22 // Tokens sent to this contract will be lost forever.
23 //
24 // ERROR CODES:
25 //
26 // 1: Invalid Owner Address. You must provide three distinct addresses.
27 //    None of the provided addresses may be 0x00.
28 // 2: Invalid Destination. You may not send ETH to this contract's address.
29 // 3: Insufficient Balance. You have tried to send more ETH that this
30 //    contract currently owns.
31 // 4: Invalid Signature. The provided signature does not correspond to
32 //    the provided destination, amount, nonce and current contract.
33 //    Did you swap the R and S fields?
34 // 5: Invalid Signers. The provided signatures are correctly signed, but are
35 //    not signed by the correct addresses. You must provide signatures from
36 //    two of the owner addresses.
37 //
38 // Developed by Unchained Capital, Inc.
39 
40 
41 
42 contract MultiSig2of3 {
43 
44     // The 3 addresses which control the funds in this contract.  The
45     // owners of 2 of these addresses will need to both sign a message
46     // allowing the funds in this contract to be spent.
47     mapping(address => bool) private owners;
48 
49     // The contract nonce is not accessible to the contract so we
50     // implement a nonce-like variable for replay protection.
51     uint256 public spendNonce = 0;
52 
53     // Contract Versioning
54     uint256 public unchainedMultisigVersionMajor = 2;
55     uint256 public unchainedMultisigVersionMinor = 0;
56 
57     // An event sent when funds are received.
58     event Funded(uint newBalance);
59 
60     // An event sent when a spend is triggered to the given address.
61     event Spent(address to, uint transfer);
62 
63     // Instantiate a new Multisig 2 of 3 contract owned by the
64     // three given addresses
65     constructor(address owner1, address owner2, address owner3) public {
66         address zeroAddress = 0x0;
67 
68         require(owner1 != zeroAddress, "1");
69         require(owner2 != zeroAddress, "1");
70         require(owner3 != zeroAddress, "1");
71 
72         require(owner1 != owner2, "1");
73         require(owner2 != owner3, "1");
74         require(owner1 != owner3, "1");
75 
76         owners[owner1] = true;
77         owners[owner2] = true;
78         owners[owner3] = true;
79     }
80 
81     // The fallback function for this contract.
82     function() public payable {
83         emit Funded(address(this).balance);
84     }
85 
86     // Generates the message to sign given the output destination address and amount.
87     // includes this contract's address and a nonce for replay protection.
88     // One option to independently verify:
89     //     https://leventozturk.com/engineering/sha3/ and select keccak
90     function generateMessageToSign(
91         address destination,
92         uint256 value
93     )
94         public view returns (bytes32)
95     {
96         require(destination != address(this), "2");
97         bytes32 message = keccak256(
98             abi.encodePacked(
99                 spendNonce,
100                 this,
101                 value,
102                 destination
103             )
104         );
105         return message;
106     }
107 
108     // Send the given amount of ETH to the given destination using
109     // the two triplets (v1, r1, s1) and (v2, r2, s2) as signatures.
110     // s1 and s2 should be 0x00 or 0x01 corresponding to 0x1b and 0x1c respectively.
111     function spend(
112         address destination,
113         uint256 value,
114         uint8 v1,
115         bytes32 r1,
116         bytes32 s1,
117         uint8 v2,
118         bytes32 r2,
119         bytes32 s2
120     )
121         public
122     {
123         // This require is handled by generateMessageToSign()
124         // require(destination != address(this));
125         require(address(this).balance >= value, "3");
126         require(
127             _validSignature(
128                 destination,
129                 value,
130                 v1, r1, s1,
131                 v2, r2, s2
132             ),
133             "4");
134         spendNonce = spendNonce + 1;
135         destination.transfer(value);
136         emit Spent(destination, value);
137     }
138 
139     // Confirm that the two signature triplets (v1, r1, s1) and (v2, r2, s2)
140     // both authorize a spend of this contract's funds to the given
141     // destination address.
142     function _validSignature(
143         address destination,
144         uint256 value,
145         uint8 v1, bytes32 r1, bytes32 s1,
146         uint8 v2, bytes32 r2, bytes32 s2
147     )
148         private view returns (bool)
149     {
150         bytes32 message = _messageToRecover(destination, value);
151         address addr1 = ecrecover(
152             message,
153             v1+27, r1, s1
154         );
155         address addr2 = ecrecover(
156             message,
157             v2+27, r2, s2
158         );
159         require(_distinctOwners(addr1, addr2), "5");
160 
161         return true;
162     }
163 
164     // Generate the the unsigned message (in bytes32) that each owner's
165     // wallet would have signed for the given destination and amount.
166     //
167     // The generated message from generateMessageToSign is converted to
168     // ascii when signed by a trezor.
169     //
170     // The required signing prefix, the length of this
171     // unsigned message, and the unsigned ascii message itself are
172     // then concatenated and hashed with keccak256.
173     function _messageToRecover(
174         address destination,
175         uint256 value
176     )
177         private view returns (bytes32)
178     {
179         bytes32 hashedUnsignedMessage = generateMessageToSign(
180             destination,
181             value
182         );
183         bytes memory unsignedMessageBytes = _hashToAscii(
184             hashedUnsignedMessage
185         );
186         bytes memory prefix = "\x19Ethereum Signed Message:\n64";
187         return keccak256(abi.encodePacked(prefix,unsignedMessageBytes));
188     }
189 
190     // Confirm the pair of addresses as two distinct owners of this contract.
191     function _distinctOwners(
192         address addr1,
193         address addr2
194     )
195         private view returns (bool)
196     {
197         // Check that both addresses are different
198         require(addr1 != addr2, "5");
199         // Check that both addresses are owners
200         require(owners[addr1], "5");
201         require(owners[addr2], "5");
202         return true;
203     }
204 
205     // Construct the byte representation of the ascii-encoded
206     // hashed message written in hex.
207     function _hashToAscii(bytes32 hash) private pure returns (bytes) {
208         bytes memory s = new bytes(64);
209         for (uint i = 0; i < 32; i++) {
210             byte  b = hash[i];
211             byte hi = byte(uint8(b) / 16);
212             byte lo = byte(uint8(b) - 16 * uint8(hi));
213             s[2*i] = _char(hi);
214             s[2*i+1] = _char(lo);
215         }
216         return s;
217     }
218 
219     // Convert from byte to ASCII of 0-f
220     // http://www.unicode.org/charts/PDF/U0000.pdf
221     function _char(byte b) private pure returns (byte c) {
222         if (b < 10) {
223             return byte(uint8(b) + 0x30);
224         } else {
225             return byte(uint8(b) + 0x57);
226         }
227     }
228 }