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
67 contract DSMath {
68     function add(uint x, uint y) internal pure returns (uint z) {
69         require((z = x + y) >= x);
70     }
71     function sub(uint x, uint y) internal pure returns (uint z) {
72         require((z = x - y) <= x);
73     }
74     function mul(uint x, uint y) internal pure returns (uint z) {
75         require(y == 0 || (z = x * y) / y == x);
76     }
77 
78     function min(uint x, uint y) internal pure returns (uint z) {
79         return x <= y ? x : y;
80     }
81     function max(uint x, uint y) internal pure returns (uint z) {
82         return x >= y ? x : y;
83     }
84     function imin(int x, int y) internal pure returns (int z) {
85         return x <= y ? x : y;
86     }
87     function imax(int x, int y) internal pure returns (int z) {
88         return x >= y ? x : y;
89     }
90 
91     uint constant WAD = 10 ** 18;
92     uint constant RAY = 10 ** 27;
93 
94     function wmul(uint x, uint y) internal pure returns (uint z) {
95         z = add(mul(x, y), WAD / 2) / WAD;
96     }
97     function rmul(uint x, uint y) internal pure returns (uint z) {
98         z = add(mul(x, y), RAY / 2) / RAY;
99     }
100     function wdiv(uint x, uint y) internal pure returns (uint z) {
101         z = add(mul(x, WAD), y / 2) / y;
102     }
103     function rdiv(uint x, uint y) internal pure returns (uint z) {
104         z = add(mul(x, RAY), y / 2) / y;
105     }
106 
107     // This famous algorithm is called "exponentiation by squaring"
108     // and calculates x^n with x as fixed-point and n as regular unsigned.
109     //
110     // It's O(log n), instead of O(n) for naive repeated multiplication.
111     //
112     // These facts are why it works:
113     //
114     //  If n is even, then x^n = (x^2)^(n/2).
115     //  If n is odd,  then x^n = x * x^(n-1),
116     //   and applying the equation for even x gives
117     //    x^n = x * (x^2)^((n-1) / 2).
118     //
119     //  Also, EVM division is flooring and
120     //    floor[(n-1) / 2] = floor[n / 2].
121     //
122     function rpow(uint x, uint n) internal pure returns (uint z) {
123         z = n % 2 != 0 ? x : RAY;
124 
125         for (n /= 2; n != 0; n /= 2) {
126             x = rmul(x, x);
127 
128             if (n % 2 != 0) {
129                 z = rmul(z, x);
130             }
131         }
132     }
133 }
134 
135 contract Htlc is DSMath {
136     using ECRecovery for bytes32;
137 
138     // TYPES
139 
140     // ATL Authority timelocked contract
141     struct Multisig { // Locked by authority approval (earlyResolve), time (timoutResolve) or conversion into an atomic swap
142         address owner; // Owns ether deposited in multisig
143         address authority; // Can approve earlyResolve of funds out of multisig
144         uint deposit; // Amount deposited by owner in this multisig
145         uint unlockTime; // Multisig expiration timestamp in seconds
146     }
147 
148     struct AtomicSwap { // Locked by secret (regularTransfer) or time (reclaimExpiredSwaps)
149         bytes32 msigId; // Corresponding multisigId
150         address initiator; // Initiated this swap
151         address beneficiary; // Beneficiary of this swap
152         uint amount; // If zero then swap not active anymore
153         uint fee; // Fee amount to be paid to multisig authority
154         uint expirationTime; // Swap expiration timestamp in seconds
155         bytes32 hashedSecret; // sha256(secret), hashed secret of swap initiator
156     }
157 
158     // FIELDS
159 
160     address constant FEE_RECIPIENT = 0x478189a0aF876598C8a70Ce8896960500455A949;
161     uint constant MAX_BATCH_ITERATIONS = 25; // Assumption block.gaslimit around 7500000
162     mapping (bytes32 => Multisig) public multisigs;
163     mapping (bytes32 => AtomicSwap) public atomicswaps;
164     mapping (bytes32 => bool) public isAntecedentHashedSecret;
165 
166     // EVENTS
167 
168     event MultisigInitialised(bytes32 msigId);
169     event MultisigReparametrized(bytes32 msigId);
170     event AtomicSwapInitialised(bytes32 swapId);
171 
172     // MODIFIERS
173 
174     // METHODS
175 
176     /**
177     @notice Send ether out of this contract to multisig owner and update or delete entry in multisig mapping
178     @param msigId Unique (owner, authority, balance != 0) multisig identifier
179     @param amount Spend this amount of ether
180     */
181     function spendFromMultisig(bytes32 msigId, uint amount, address recipient)
182         internal
183     {
184         multisigs[msigId].deposit = sub(multisigs[msigId].deposit, amount);
185         if (multisigs[msigId].deposit == 0)
186             delete multisigs[msigId];
187         recipient.transfer(amount);
188     }
189 
190     // PUBLIC METHODS
191 
192     /**
193     @notice Initialise and reparametrize Multisig
194     @dev Uses msg.value to fund Multisig
195     @param authority Second multisig Authority. Usually this is the Exchange.
196     @param unlockTime Lock Ether until unlockTime in seconds.
197     @return msigId Unique (owner, authority, balance != 0) multisig identifier
198     */
199     function initialiseMultisig(address authority, uint unlockTime)
200         public
201         payable
202         returns (bytes32 msigId)
203     {
204         // Require not own authority and non-zero ether amount are sent
205         require(msg.sender != authority);
206         require(msg.value > 0);
207         // Create unique multisig identifier
208         msigId = keccak256(
209             msg.sender,
210             authority,
211             msg.value,
212             unlockTime
213         );
214         emit MultisigInitialised(msigId);
215         // Create multisig
216         Multisig storage multisig = multisigs[msigId];
217         if (multisig.deposit == 0) { // New or empty multisig
218             // Create new multisig
219             multisig.owner = msg.sender;
220             multisig.authority = authority;
221         }
222         // Adjust balance and locktime
223         reparametrizeMultisig(msigId, unlockTime);
224     }
225 
226     /**
227     @notice Inititate/extend multisig unlockTime and/or initiate/refund multisig deposit
228     @dev Can increase deposit and/or unlockTime but not owner or authority
229     @param msigId Unique (owner, authority, balance != 0) multisig identifier
230     @param unlockTime Lock Ether until unlockTime in seconds.
231     */
232     function reparametrizeMultisig(bytes32 msigId, uint unlockTime)
233         public
234         payable
235     {
236         require(multisigs[msigId].owner == msg.sender);
237         Multisig storage multisig = multisigs[msigId];
238         multisig.deposit = add(multisig.deposit, msg.value);
239         assert(multisig.unlockTime <= unlockTime); // Can only increase unlockTime
240         multisig.unlockTime = unlockTime;
241         emit MultisigReparametrized(msigId);
242     }
243 
244     /**
245     @notice Withdraw ether from the multisig. Equivalent to EARLY_RESOLVE in Nimiq
246     @dev the signature is generated using web3.eth.sign() over the unique msigId
247     @param msigId Unique (owner, authority, balance != 0) multisig identifier
248     @param amount Return this amount from this contract to owner
249     @param sig bytes signature of the not transaction sending Authority
250     */
251     function earlyResolve(bytes32 msigId, uint amount, bytes sig)
252         public
253     {
254         // Require: msg.sender == (owner or authority)
255         require(
256             multisigs[msigId].owner == msg.sender ||
257             multisigs[msigId].authority == msg.sender
258         );
259         // Require: valid signature from not msg.sending authority
260         address otherAuthority = multisigs[msigId].owner == msg.sender ?
261             multisigs[msigId].authority :
262             multisigs[msigId].owner;
263         require(otherAuthority == msigId.toEthSignedMessageHash().recover(sig));
264         // Return to owner
265         spendFromMultisig(msigId, amount, multisigs[msigId].owner);
266     }
267 
268     /**
269     @notice Withdraw ether and delete the htlc swap. Equivalent to TIMEOUT_RESOLVE in Nimiq
270     @param msigId Unique (owner, authority, balance != 0) multisig identifier
271     @dev Only refunds owned multisig deposits
272     */
273     function timeoutResolve(bytes32 msigId, uint amount)
274         public
275     {
276         // Require time has passed
277         require(now >= multisigs[msigId].unlockTime);
278         // Return to owner
279         spendFromMultisig(msigId, amount, multisigs[msigId].owner);
280     }
281 
282     /**
283     @notice First or second stage of atomic swap.
284     @param msigId Unique (owner, authority, balance != 0) multisig identifier
285     @param beneficiary Beneficiary of this swap
286     @param amount Convert this amount from multisig into swap
287     @param fee Fee amount to be paid to multisig authority
288     @param expirationTime Swap expiration timestamp in seconds; not more than 1 day from now
289     @param hashedSecret sha256(secret), hashed secret of swap initiator
290     @return swapId Unique (initiator, beneficiary, amount, fee, expirationTime, hashedSecret) swap identifier
291     */
292     function convertIntoHtlc(bytes32 msigId, address beneficiary, uint amount, uint fee, uint expirationTime, bytes32 hashedSecret)
293         public
294         returns (bytes32 swapId)
295     {
296         // Require owner with sufficient deposit
297         require(multisigs[msigId].owner == msg.sender);
298         require(multisigs[msigId].deposit >= amount + fee); // Checks for underflow
299         require(
300             now <= expirationTime &&
301             expirationTime <= min(now + 1 days, multisigs[msigId].unlockTime)
302         ); // Not more than 1 day or unlockTime
303         require(amount > 0); // Non-empty amount as definition for active swap
304         require(!isAntecedentHashedSecret[hashedSecret]);
305         isAntecedentHashedSecret[hashedSecret] = true;
306         // Account in multisig balance
307         multisigs[msigId].deposit = sub(multisigs[msigId].deposit, add(amount, fee));
308         // Create swap identifier
309         swapId = keccak256(
310             msigId,
311             msg.sender,
312             beneficiary,
313             amount,
314             fee,
315             expirationTime,
316             hashedSecret
317         );
318         emit AtomicSwapInitialised(swapId);
319         // Create swap
320         AtomicSwap storage swap = atomicswaps[swapId];
321         swap.msigId = msigId;
322         swap.initiator = msg.sender;
323         swap.beneficiary = beneficiary;
324         swap.amount = amount;
325         swap.fee = fee;
326         swap.expirationTime = expirationTime;
327         swap.hashedSecret = hashedSecret;
328         // Transfer fee to fee recipient
329         FEE_RECIPIENT.transfer(fee);
330     }
331 
332     /**
333     @notice Batch execution of convertIntoHtlc() function
334     */
335     function batchConvertIntoHtlc(
336         bytes32[] msigIds,
337         address[] beneficiaries,
338         uint[] amounts,
339         uint[] fees,
340         uint[] expirationTimes,
341         bytes32[] hashedSecrets
342     )
343         public
344         returns (bytes32[] swapId)
345     {
346         require(msigIds.length <= MAX_BATCH_ITERATIONS);
347         for (uint i = 0; i < msigIds.length; ++i)
348             convertIntoHtlc(
349                 msigIds[i],
350                 beneficiaries[i],
351                 amounts[i],
352                 fees[i],
353                 expirationTimes[i],
354                 hashedSecrets[i]
355             ); // Gas estimate `infinite`
356     }
357 
358     /**
359     @notice Withdraw ether and delete the htlc swap. Equivalent to REGULAR_TRANSFER in Nimiq
360     @dev Transfer swap amount to beneficiary of swap and fee to authority
361     @param swapId Unique (initiator, beneficiary, amount, fee, expirationTime, hashedSecret) swap identifier
362     @param secret Hashed secret of htlc swap
363     */
364     function regularTransfer(bytes32 swapId, bytes32 secret)
365         public
366     {
367         // Require valid secret provided
368         require(sha256(secret) == atomicswaps[swapId].hashedSecret);
369         uint amount = atomicswaps[swapId].amount;
370         address beneficiary = atomicswaps[swapId].beneficiary;
371         // Delete swap
372         delete atomicswaps[swapId];
373         // Execute swap
374         beneficiary.transfer(amount);
375     }
376 
377     /**
378     @notice Batch exection of regularTransfer() function
379     */
380     function batchRegularTransfers(bytes32[] swapIds, bytes32[] secrets)
381         public
382     {
383         require(swapIds.length <= MAX_BATCH_ITERATIONS);
384         for (uint i = 0; i < swapIds.length; ++i)
385             regularTransfer(swapIds[i], secrets[i]); // Gas estimate `infinite`
386     }
387 
388     /**
389     @notice Reclaim an expired, non-empty swap into a multisig
390     @dev Transfer swap amount to beneficiary of swap and fee to authority
391     @param msigId Unique (owner, authority, balance != 0) multisig identifier to which deposit expired swaps
392     @param swapId Unique (initiator, beneficiary, amount, fee, expirationTime, hashedSecret) swap identifier
393     */
394     function reclaimExpiredSwap(bytes32 msigId, bytes32 swapId)
395         public
396     {
397         // Require: msg.sender == ower or authority
398         require(
399             multisigs[msigId].owner == msg.sender ||
400             multisigs[msigId].authority == msg.sender
401         );
402         // Require msigId matches swapId
403         require(msigId == atomicswaps[swapId].msigId);
404         // Require: is expired
405         require(now >= atomicswaps[swapId].expirationTime);
406         uint amount = atomicswaps[swapId].amount;
407         delete atomicswaps[swapId];
408         multisigs[msigId].deposit = add(multisigs[msigId].deposit, amount);
409     }
410 
411     /**
412     @notice Batch exection of reclaimExpiredSwaps() function
413     */
414     function batchReclaimExpiredSwaps(bytes32 msigId, bytes32[] swapIds)
415         public
416     {
417         require(swapIds.length <= MAX_BATCH_ITERATIONS); // << block.gaslimit / 88281
418         for (uint i = 0; i < swapIds.length; ++i)
419             reclaimExpiredSwap(msigId, swapIds[i]); // Gas estimate 88281
420     }
421 }