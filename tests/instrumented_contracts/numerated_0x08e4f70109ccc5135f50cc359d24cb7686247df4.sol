1 pragma solidity ^0.4.19;
2 
3 
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   /**
35   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 
53 
54 
55 /**
56  * @title Eliptic curve signature operations
57  *
58  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
59  */
60 
61 library ECRecovery {
62 
63   /**
64    * @dev Recover signer address from a message by using his signature
65    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
66    * @param sig bytes signature, the signature is generated using web3.eth.sign()
67    */
68   function recover(bytes32 hash, bytes sig) public pure returns (address) {
69     bytes32 r;
70     bytes32 s;
71     uint8 v;
72 
73     //Check the signature length
74     if (sig.length != 65) {
75       return (address(0));
76     }
77 
78     // Divide the signature in r, s and v variables
79     assembly {
80       r := mload(add(sig, 32))
81       s := mload(add(sig, 64))
82       v := byte(0, mload(add(sig, 96)))
83     }
84 
85     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
86     if (v < 27) {
87       v += 27;
88     }
89 
90     // If the version is correct return the signer address
91     if (v != 27 && v != 28) {
92       return (address(0));
93     } else {
94       return ecrecover(hash, v, r, s);
95     }
96   }
97 
98 }
99 
100 
101 
102 /// @title Unidirectional Ether payment channels contract.
103 contract Unidirectional {
104     using SafeMath for uint256;
105 
106     struct PaymentChannel {
107         address sender;
108         address receiver;
109         uint256 value; // Total amount of money deposited to the channel.
110 
111         uint32 settlingPeriod; // How many blocks to wait for the receiver to claim her funds, after sender starts settling.
112         uint256 settlingUntil; // Starting with this block number, anyone can settle the channel.
113     }
114 
115     mapping (bytes32 => PaymentChannel) public channels;
116 
117     event DidOpen(bytes32 indexed channelId, address indexed sender, address indexed receiver, uint256 value);
118     event DidDeposit(bytes32 indexed channelId, uint256 deposit);
119     event DidClaim(bytes32 indexed channelId);
120     event DidStartSettling(bytes32 indexed channelId);
121     event DidSettle(bytes32 indexed channelId);
122 
123     /*** ACTIONS AND CONSTRAINTS ***/
124 
125     /// @notice Open a new channel between `msg.sender` and `receiver`, and do an initial deposit to the channel.
126     /// @param channelId Unique identifier of the channel to be created.
127     /// @param receiver Receiver of the funds, counter-party of `msg.sender`.
128     /// @param settlingPeriod Number of blocks to wait for receiver to `claim` her funds after the sender starts settling period (see `startSettling`).
129     /// After that period is over anyone could call `settle`, and move all the channel funds to the sender.
130     function open(bytes32 channelId, address receiver, uint32 settlingPeriod) public payable {
131         require(isAbsent(channelId));
132 
133         channels[channelId] = PaymentChannel({
134             sender: msg.sender,
135             receiver: receiver,
136             value: msg.value,
137             settlingPeriod: settlingPeriod,
138             settlingUntil: 0
139         });
140 
141         DidOpen(channelId, msg.sender, receiver, msg.value);
142     }
143 
144     /// @notice Ensure `origin` address can deposit money into the channel identified by `channelId`.
145     /// @dev Constraint `deposit` call.
146     /// @param channelId Identifier of the channel.
147     /// @param origin Caller of `deposit` function.
148     function canDeposit(bytes32 channelId, address origin) public view returns(bool) {
149         PaymentChannel memory channel = channels[channelId];
150         bool isSender = channel.sender == origin;
151         return isOpen(channelId) && isSender;
152     }
153 
154     /// @notice Add more money to the contract.
155     /// @param channelId Identifier of the channel.
156     function deposit(bytes32 channelId) public payable {
157         require(canDeposit(channelId, msg.sender));
158 
159         channels[channelId].value += msg.value;
160 
161         DidDeposit(channelId, msg.value);
162     }
163 
164     /// @notice Ensure `origin` address can start settling the channel identified by `channelId`.
165     /// @dev Constraint `startSettling` call.
166     /// @param channelId Identifier of the channel.
167     /// @param origin Caller of `startSettling` function.
168     function canStartSettling(bytes32 channelId, address origin) public view returns(bool) {
169         PaymentChannel memory channel = channels[channelId];
170         bool isSender = channel.sender == origin;
171         return isOpen(channelId) && isSender;
172     }
173 
174     /// @notice Sender initiates settling of the contract.
175     /// @dev Actually set `settlingUntil` field of the PaymentChannel structure.
176     /// @param channelId Identifier of the channel.
177     function startSettling(bytes32 channelId) public {
178         require(canStartSettling(channelId, msg.sender));
179 
180         PaymentChannel storage channel = channels[channelId];
181         channel.settlingUntil = block.number + channel.settlingPeriod;
182 
183         DidStartSettling(channelId);
184     }
185 
186     /// @notice Ensure one can settle the channel identified by `channelId`.
187     /// @dev Check if settling period is over by comparing `settlingUntil` to a current block number.
188     /// @param channelId Identifier of the channel.
189     function canSettle(bytes32 channelId) public view returns(bool) {
190         PaymentChannel memory channel = channels[channelId];
191         bool isWaitingOver = isSettling(channelId) && block.number >= channel.settlingUntil;
192         return isSettling(channelId) && isWaitingOver;
193     }
194 
195     /// @notice Move the money to sender, and close the channel.
196     /// After the settling period is over, and receiver has not claimed the funds, anyone could call that.
197     /// @param channelId Identifier of the channel.
198     function settle(bytes32 channelId) public {
199         require(canSettle(channelId));
200         PaymentChannel storage channel = channels[channelId];
201         channel.sender.transfer(channel.value);
202 
203         delete channels[channelId];
204         DidSettle(channelId);
205     }
206 
207     /// @notice Ensure `origin` address can claim `payment` amount on channel identified by `channelId`.
208     /// @dev Check if `signature` is made by sender part of the channel, and is for payment promise (see `paymentDigest`).
209     /// @param channelId Identifier of the channel.
210     /// @param payment Amount claimed.
211     /// @param origin Caller of `claim` function.
212     /// @param signature Signature for the payment promise.
213     function canClaim(bytes32 channelId, uint256 payment, address origin, bytes signature) public view returns(bool) {
214         PaymentChannel memory channel = channels[channelId];
215         bool isReceiver = origin == channel.receiver;
216         bytes32 hash = recoveryPaymentDigest(channelId, payment);
217         bool isSigned = channel.sender == ECRecovery.recover(hash, signature);
218 
219         return isReceiver && isSigned;
220     }
221 
222     /// @notice Claim the funds, and close the channel.
223     /// @dev Can be claimed by channel receiver only. Guarded by `canClaim`.
224     /// @param channelId Identifier of the channel.
225     /// @param payment Amount claimed.
226     /// @param signature Signature for the payment promise.
227     function claim(bytes32 channelId, uint256 payment, bytes signature) public {
228         require(canClaim(channelId, payment, msg.sender, signature));
229 
230         PaymentChannel memory channel = channels[channelId];
231 
232         if (payment >= channel.value) {
233             channel.receiver.transfer(channel.value);
234         } else {
235             channel.receiver.transfer(payment);
236             channel.sender.transfer(channel.value.sub(payment));
237         }
238 
239         delete channels[channelId];
240 
241         DidClaim(channelId);
242     }
243 
244     /*** CHANNEL STATE ***/
245 
246     /// @notice Check if the channel is present: in open or settling state.
247     /// @param channelId Identifier of the channel.
248     function isPresent(bytes32 channelId) public view returns(bool) {
249         return !isAbsent(channelId);
250     }
251 
252     /// @notice Check if the channel is not present.
253     /// @param channelId Identifier of the channel.
254     function isAbsent(bytes32 channelId) public view returns(bool) {
255         PaymentChannel memory channel = channels[channelId];
256         return channel.sender == 0;
257     }
258 
259     /// @notice Check if the channel is in settling state: waits till the settling period is over.
260     /// @dev It is settling, if `settlingUntil` is set to non-zero.
261     /// @param channelId Identifier of the channel.
262     function isSettling(bytes32 channelId) public view returns(bool) {
263         PaymentChannel memory channel = channels[channelId];
264         return channel.settlingUntil != 0;
265     }
266 
267     /// @notice Check if the channel is open: present and not settling.
268     /// @param channelId Identifier of the channel.
269     function isOpen(bytes32 channelId) public view returns(bool) {
270         return isPresent(channelId) && !isSettling(channelId);
271     }
272 
273     /*** PAYMENT DIGEST ***/
274 
275     /// @return Hash of the payment promise to sign.
276     /// @param channelId Identifier of the channel.
277     /// @param payment Amount to send, and to claim later.
278     function paymentDigest(bytes32 channelId, uint256 payment) public view returns(bytes32) {
279         return keccak256(address(this), channelId, payment);
280     }
281 
282     /// @return Actually signed hash of the payment promise, considering "Ethereum Signed Message" prefix.
283     /// @param channelId Identifier of the channel.
284     /// @param payment Amount to send, and to claim later.
285     function recoveryPaymentDigest(bytes32 channelId, uint256 payment) internal view returns(bytes32) {
286         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
287         return keccak256(prefix, paymentDigest(channelId, payment));
288     }
289 }