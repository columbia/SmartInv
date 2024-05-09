1 pragma solidity ^0.4.13;
2 
3 library ECRecovery {
4 
5     /**
6      * @dev Recover signer address from a message by using their signature
7      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
8      * @param sig bytes signature, the signature is generated using web3.eth.sign()
9      */
10     function recover(bytes32 hash, bytes sig)
11         internal
12         pure
13         returns (address)
14     {
15         bytes32 r;
16         bytes32 s;
17         uint8 v;
18 
19         // Check the signature length
20         if (sig.length != 65) {
21             return (address(0));
22         }
23 
24         // Divide the signature in r, s and v variables
25         // ecrecover takes the signature parameters, and the only way to get them
26         // currently is to use assembly.
27         // solium-disable-next-line security/no-inline-assembly
28         assembly {
29             r := mload(add(sig, 32))
30             s := mload(add(sig, 64))
31             v := byte(0, mload(add(sig, 96)))
32         }
33 
34         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
35         if (v < 27) {
36             v += 27;
37         }
38 
39         // If the version is correct return the signer address
40         if (v != 27 && v != 28) {
41             return (address(0));
42         } else {
43             // solium-disable-next-line arg-overflow
44             return ecrecover(hash, v, r, s);
45         }
46     }
47 
48     /**
49      * toEthSignedMessageHash
50      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
51      * @dev and hash the result
52      */
53     function toEthSignedMessageHash(bytes32 hash)
54         internal
55         pure
56         returns (bytes32)
57     {
58         // 32 is the length in bytes of hash,
59         // enforced by the type signature above
60         return keccak256(
61             "\x19Ethereum Signed Message:\n32",
62             hash
63         );
64     }
65 }
66 
67 contract Htlc {
68     using ECRecovery for bytes32;
69 
70     // TYPES
71 
72     struct Multisig { // Locked by time and/or authority approval for HTLC conversion or earlyResolve
73         address owner; // Owns funds deposited in multisig,
74         address authority; // Can approve earlyResolve of funds out of multisig
75         uint deposit; // Amount deposited by owner in this multisig
76         uint unlockTime; // Multisig expiration timestamp in seconds
77     }
78 
79     struct AtomicSwap { // HTLC swap used for regular transfers
80         address initiator; // Initiated this swap
81         address beneficiary; // Beneficiary of this swap
82         uint amount; // If zero then swap not active anymore
83         uint fee; // Fee amount to be paid to multisig authority
84         uint expirationTime; // Swap expiration timestamp in seconds
85         bytes32 hashedSecret; // sha256(secret), hashed secret of swap initiator
86     }
87 
88     // FIELDS
89 
90     address constant FEE_RECIPIENT = 0x0E5cB767Cce09A7F3CA594Df118aa519BE5e2b5A;
91     mapping (bytes32 => Multisig) public hashIdToMultisig;
92     mapping (bytes32 => AtomicSwap) public hashIdToSwap;
93 
94     // EVENTS
95 
96     // TODO add events for all public functions
97 
98     // MODIFIERS
99 
100     // METHODS
101 
102     /**
103     @notice Send ether out of this contract to multisig owner and update or delete entry in multisig mapping
104     @param msigId Unique (owner, authority, balance != 0) multisig identifier
105     @param amount Spend this amount of ether
106     */
107     function spendFromMultisig(bytes32 msigId, uint amount, address recipient)
108         internal
109     {
110         // Require sufficient deposit amount; Prevents buffer underflow
111         require(amount <= hashIdToMultisig[msigId].deposit);
112         hashIdToMultisig[msigId].deposit -= amount;
113         if (hashIdToMultisig[msigId].deposit == 0) {
114             // Delete multisig
115             delete hashIdToMultisig[msigId];
116             assert(hashIdToMultisig[msigId].deposit == 0);
117         }
118         // Transfer recipient
119         recipient.transfer(amount);
120     }
121 
122     /**
123     @notice Send ether out of this contract to swap beneficiary and update or delete entry in swap mapping
124     @param swapId Unique (initiator, beneficiary, amount, fee, expirationTime, hashedSecret) swap identifier
125     @param amount Spend this amount of ether
126     */
127     function spendFromSwap(bytes32 swapId, uint amount, address recipient)
128         internal
129     {
130         // Require sufficient swap amount; Prevents buffer underflow
131         require(amount <= hashIdToSwap[swapId].amount);
132         hashIdToSwap[swapId].amount -= amount;
133         if (hashIdToSwap[swapId].amount == 0) {
134             // Delete swap
135             delete hashIdToSwap[swapId];
136             assert(hashIdToSwap[swapId].amount == 0);
137         }
138         // Transfer to recipient
139         recipient.transfer(amount);
140     }
141 
142     // PUBLIC METHODS
143 
144     /**
145     @notice Initialise and reparametrize Multisig
146     @dev Uses msg.value to fund Multisig
147     @param authority Second multisig Authority. Usually this is the Exchange.
148     @param unlockTime Lock Ether until unlockTime in seconds.
149     @return msigId Unique (owner, authority, balance != 0) multisig identifier
150     */
151     function initialiseMultisig(address authority, uint unlockTime)
152         public
153         payable
154         returns (bytes32 msigId)
155     {
156         // Require not own authority and ether are sent
157         require(msg.sender != authority);
158         require(msg.value > 0);
159         msigId = keccak256(
160             msg.sender,
161             authority,
162             msg.value,
163             unlockTime
164         );
165 
166         Multisig storage multisig = hashIdToMultisig[msigId];
167         if (multisig.deposit == 0) { // New or empty multisig
168             // Create new multisig
169             multisig.owner = msg.sender;
170             multisig.authority = authority;
171         }
172         // Adjust balance and locktime
173         reparametrizeMultisig(msigId, unlockTime);
174     }
175 
176     /**
177     @notice Deposit msg.value ether into a multisig and set unlockTime
178     @dev Can increase deposit and/or unlockTime but not owner or authority
179     @param msigId Unique (owner, authority, balance != 0) multisig identifier
180     @param unlockTime Lock Ether until unlockTime in seconds.
181     */
182     function reparametrizeMultisig(bytes32 msigId, uint unlockTime)
183         public
184         payable
185     {
186         Multisig storage multisig = hashIdToMultisig[msigId];
187         assert(
188             multisig.deposit + msg.value >=
189             multisig.deposit
190         ); // Throws on overflow.
191         multisig.deposit += msg.value;
192         assert(multisig.unlockTime <= unlockTime); // Can only increase unlockTime
193         multisig.unlockTime = unlockTime;
194     }
195 
196     // TODO allow for batch convertIntoHtlc
197     /**
198     @notice Convert swap from multisig to htlc mode
199     @param msigId Unique (owner, authority, balance != 0) multisig identifier
200     @param beneficiary Beneficiary of this swap
201     @param amount Convert this amount from multisig into swap
202     @param fee Fee amount to be paid to multisig authority
203     @param expirationTime Swap expiration timestamp in seconds; not more than 1 day from now
204     @param hashedSecret sha3(secret), hashed secret of swap initiator
205     @return swapId Unique (initiator, beneficiary, amount, fee, expirationTime, hashedSecret) swap identifier
206     */
207     function convertIntoHtlc(bytes32 msigId, address beneficiary, uint amount, uint fee, uint expirationTime, bytes32 hashedSecret)
208         public
209         returns (bytes32 swapId)
210     {
211         // Require owner with sufficient deposit
212         require(hashIdToMultisig[msigId].owner == msg.sender);
213         require(hashIdToMultisig[msigId].deposit >= amount + fee); // Checks for underflow
214         require(now <= expirationTime && expirationTime <= now + 86400); // Not more than 1 day
215         require(amount > 0); // Non-empty amount as definition for active swap
216         // Account in multisig balance
217         hashIdToMultisig[msigId].deposit -= amount + fee;
218         swapId = keccak256(
219             msg.sender,
220             beneficiary,
221             amount,
222             fee,
223             expirationTime,
224             hashedSecret
225         );
226         // Create swap
227         AtomicSwap storage swap = hashIdToSwap[swapId];
228         swap.initiator = msg.sender;
229         swap.beneficiary = beneficiary;
230         swap.amount = amount;
231         swap.fee = fee;
232         swap.expirationTime = expirationTime;
233         swap.hashedSecret = hashedSecret;
234         // Transfer fee to multisig.authority
235         hashIdToMultisig[msigId].authority.transfer(fee);
236     }
237 
238     // TODO calc gas limit
239     /**
240     @notice Withdraw ether and delete the htlc swap. Equivalent to REGULAR_TRANSFER in Nimiq
241     @dev Transfer swap amount to beneficiary of swap and fee to authority
242     @param swapIds Unique (initiator, beneficiary, amount, fee, expirationTime, hashedSecret) swap identifiers
243     @param secrets Hashed secrets of htlc swaps
244     */
245     function batchRegularTransfer(bytes32[] swapIds, bytes32[] secrets)
246         public
247     {
248         for (uint i = 0; i < swapIds.length; ++i)
249             regularTransfer(swapIds[i], secrets[i]);
250     }
251 
252     /**
253     @notice Withdraw ether and delete the htlc swap. Equivalent to REGULAR_TRANSFER in Nimiq
254     @dev Transfer swap amount to beneficiary of swap and fee to authority
255     @param swapId Unique (initiator, beneficiary, amount, fee, expirationTime, hashedSecret) swap identifier
256     @param secret Hashed secret of htlc swap
257     */
258     function regularTransfer(bytes32 swapId, bytes32 secret)
259         public
260     {
261         // Require valid secret provided
262         require(sha256(secret) == hashIdToSwap[swapId].hashedSecret);
263         // Execute swap
264         spendFromSwap(swapId, hashIdToSwap[swapId].amount, hashIdToSwap[swapId].beneficiary);
265         spendFromSwap(swapId, hashIdToSwap[swapId].fee, FEE_RECIPIENT);
266     }
267 
268     /**
269     @notice Reclaim all the expired, non-empty swaps into a multisig
270     @dev Transfer swap amount to beneficiary of swap and fee to authority
271     @param msigId Unique (owner, authority, balance != 0) multisig identifier to which deposit expired swaps
272     @param swapIds Unique (initiator, beneficiary, amount, fee, expirationTime, hashedSecret) swap identifiers
273     */
274     function batchReclaimExpiredSwaps(bytes32 msigId, bytes32[] swapIds)
275         public
276     {
277         for (uint i = 0; i < swapIds.length; ++i)
278             reclaimExpiredSwaps(msigId, swapIds[i]);
279     }
280 
281     /**
282     @notice Reclaim an expired, non-empty swap into a multisig
283     @dev Transfer swap amount to beneficiary of swap and fee to authority
284     @param msigId Unique (owner, authority, balance != 0) multisig identifier to which deposit expired swaps
285     @param swapId Unique (initiator, beneficiary, amount, fee, expirationTime, hashedSecret) swap identifier
286     */
287     function reclaimExpiredSwaps(bytes32 msigId, bytes32 swapId)
288         public
289     {
290         // Require: msg.sender == ower or authority
291         require(
292             hashIdToMultisig[msigId].owner == msg.sender ||
293             hashIdToMultisig[msigId].authority == msg.sender
294         );
295         // TODO! link msigId to swapId
296         // Require: is expired
297         require(now >= hashIdToSwap[swapId].expirationTime);
298         uint amount = hashIdToSwap[swapId].amount;
299         assert(hashIdToMultisig[msigId].deposit + amount >= amount); // Throws on overflow.
300         delete hashIdToSwap[swapId];
301         hashIdToMultisig[msigId].deposit += amount;
302     }
303 
304     /**
305     @notice Withdraw ether and delete the htlc swap. Equivalent to EARLY_RESOLVE in Nimiq
306     @param hashedMessage bytes32 hash of unique swap hash, the hash is the signed message. What is recovered is the signer address.
307     @param sig bytes signature, the signature is generated using web3.eth.sign()
308     */
309     function earlyResolve(bytes32 msigId, uint amount, bytes32 hashedMessage, bytes sig)
310         public
311     {
312         // Require: msg.sender == ower or authority
313         require(
314             hashIdToMultisig[msigId].owner == msg.sender ||
315             hashIdToMultisig[msigId].authority == msg.sender
316         );
317         // Require: valid signature from not tx.sending authority
318         address otherAuthority = hashIdToMultisig[msigId].owner == msg.sender ?
319             hashIdToMultisig[msigId].authority :
320             hashIdToMultisig[msigId].owner;
321         require(otherAuthority == hashedMessage.recover(sig));
322 
323         spendFromMultisig(msigId, amount, hashIdToMultisig[msigId].owner);
324     }
325 
326     /**
327     @notice Withdraw ether and delete the htlc swap. Equivalent to TIMEOUT_RESOLVE in Nimiq
328     @param msigId Unique (owner, authority, balance != 0) multisig identifier
329     @dev Only refunds owned multisig deposits
330     */
331     function timeoutResolve(bytes32 msigId, uint amount)
332         public
333     {
334         // Require sufficient amount and time passed
335         require(hashIdToMultisig[msigId].deposit >= amount);
336         require(now >= hashIdToMultisig[msigId].unlockTime);
337 
338         spendFromMultisig(msigId, amount, hashIdToMultisig[msigId].owner);
339     }
340 
341     // TODO add timelocked selfdestruct function for initial version
342 }