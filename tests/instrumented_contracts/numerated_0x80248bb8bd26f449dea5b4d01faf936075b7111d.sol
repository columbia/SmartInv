1 pragma solidity ^0.4.23;
2 
3 interface tokenRecipient {
4     function receiveApproval (address from, uint256 value, address token, bytes extraData) external;
5 }
6 
7 /**
8  * DreamTeam token contract. It implements the next capabilities:
9  * 1. Standard ERC20 functionality. [OK]
10  * 2. Additional utility function approveAndCall. [OK]
11  * 3. Function to rescue "lost forever" tokens, which were accidentally sent to the contract address. [OK]
12  * 4. Additional transfer and approve functions which allow to distinct the transaction signer and executor,
13  *    which enables accounts with no Ether on their balances to make token transfers and use DreamTeam services. [OK]
14  * 5. Token sale distribution rules. [OK]
15  * 
16  * Testing DreamTeam Token distribution
17  * Solidity contract by Nikita @ https://nikita.tk
18  */
19 contract Pasadena {
20 
21     string public name;
22     string public symbol;
23     uint8 public decimals = 6; // Makes JavaScript able to handle precise calculations (until totalSupply < 9 milliards)
24     uint256 public totalSupply;
25     mapping(address => uint256) public balanceOf;
26     mapping(address => mapping(address => uint256)) public allowance;
27     mapping(address => mapping(uint => bool)) public usedSigIds; // Used in *ViaSignature(..)
28     address public tokenDistributor; // Account authorized to distribute tokens only during the token distribution event
29     address public rescueAccount; // Account authorized to withdraw tokens accidentally sent to this contract
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 
34     bytes public ethSignedMessagePrefix = "\x19Ethereum Signed Message:\n";
35     enum sigStandard { typed, personal, stringHex }
36     enum sigDestination { transfer, approve, approveAndCall, transferFrom }
37     bytes32 public sigDestinationTransfer = keccak256(
38         "address Token Contract Address",
39         "address Sender's Address",
40         "address Recipient's Address",
41         "uint256 Amount to Transfer (last six digits are decimals)",
42         "uint256 Fee in Tokens Paid to Executor (last six digits are decimals)",
43         "uint256 Signature Expiration Timestamp (unix timestamp)",
44         "uint256 Signature ID"
45     ); // `transferViaSignature`: keccak256(address(this), from, to, value, fee, deadline, sigId)
46     bytes32 public sigDestinationTransferFrom = keccak256(
47         "address Token Contract Address",
48         "address Address Approved for Withdraw",
49         "address Account to Withdraw From",
50         "address Withdrawal Recipient Address",
51         "uint256 Amount to Transfer (last six digits are decimals)",
52         "uint256 Fee in Tokens Paid to Executor (last six digits are decimals)",
53         "uint256 Signature Expiration Timestamp (unix timestamp)",
54         "uint256 Signature ID"
55     ); // `transferFromViaSignature`: keccak256(address(this), signer, from, to, value, fee, deadline, sigId)
56     bytes32 public sigDestinationApprove = keccak256(
57         "address Token Contract Address",
58         "address Withdrawal Approval Address",
59         "address Withdrawal Recipient Address",
60         "uint256 Amount to Transfer (last six digits are decimals)",
61         "uint256 Fee in Tokens Paid to Executor (last six digits are decimals)",
62         "uint256 Signature Expiration Timestamp (unix timestamp)",
63         "uint256 Signature ID"
64     ); // `approveViaSignature`: keccak256(address(this), from, spender, value, fee, deadline, sigId)
65     bytes32 public sigDestinationApproveAndCall = keccak256( // `approveAndCallViaSignature`
66         "address Token Contract Address",
67         "address Withdrawal Approval Address",
68         "address Withdrawal Recipient Address",
69         "uint256 Amount to Transfer (last six digits are decimals)",
70         "bytes Data to Transfer",
71         "uint256 Fee in Tokens Paid to Executor (last six digits are decimals)",
72         "uint256 Signature Expiration Timestamp (unix timestamp)",
73         "uint256 Signature ID"
74     ); // `approveAndCallViaSignature`: keccak256(address(this), from, spender, value, extraData, fee, deadline, sigId)
75 
76     constructor (string tokenName, string tokenSymbol) public {
77         name = tokenName;
78         symbol = tokenSymbol;
79         rescueAccount = tokenDistributor = msg.sender;
80     }
81 
82     /**
83      * Utility internal function used to safely transfer `value` tokens `from` -> `to`. Throws if transfer is impossible.
84      */
85     function internalTransfer (address from, address to, uint value) internal {
86         // Prevent people from accidentally burning their tokens + uint256 wrap prevention
87         require(to != 0x0 && balanceOf[from] >= value && balanceOf[to] + value >= balanceOf[to]);
88         balanceOf[from] -= value;
89         balanceOf[to] += value;
90         emit Transfer(from, to, value);
91     }
92 
93     /**
94      * Utility internal function used to safely transfer `value1` tokens `from` -> `to1`, and `value2` tokens
95      * `from` -> `to2`, minimizing gas usage (calling `internalTransfer` twice is more expensive). Throws if
96      * transfers are impossible.
97      */
98     function internalDoubleTransfer (address from, address to1, uint value1, address to2, uint value2) internal {
99         require( // Prevent people from accidentally burning their tokens + uint256 wrap prevention
100             to1 != 0x0 && to2 != 0x0 && value1 + value2 >= value1 && balanceOf[from] >= value1 + value2
101             && balanceOf[to1] + value1 >= balanceOf[to1] && balanceOf[to2] + value2 >= balanceOf[to2]
102         );
103         balanceOf[from] -= value1 + value2;
104         balanceOf[to1] += value1;
105         emit Transfer(from, to1, value1);
106         if (value2 > 0) {
107             balanceOf[to2] += value2;
108             emit Transfer(from, to2, value2);
109         }
110     }
111 
112     /**
113      * Internal method that makes sure that the given signature corresponds to a given data and is made by `signer`.
114      * It utilizes three (four) standards of message signing in Ethereum, as at the moment of this smart contract
115      * development there is no single signing standard defined. For example, Metamask and Geth both support
116      * personal_sign standard, SignTypedData is only supported by Matamask, Trezor does not support "widely adopted"
117      * Ethereum personal_sign but rather personal_sign with fixed prefix and so on.
118      * Note that it is always possible to forge any of these signatures using the private key, the problem is that
119      * third-party wallets must adopt a single standard for signing messages.
120      */
121     function requireSignature (
122         bytes32 data, address signer, uint256 deadline, uint256 sigId, bytes sig, sigStandard std, sigDestination signDest
123     ) internal {
124         bytes32 r;
125         bytes32 s;
126         uint8 v;
127         assembly { // solium-disable-line security/no-inline-assembly
128             r := mload(add(sig, 32))
129             s := mload(add(sig, 64))
130             v := byte(0, mload(add(sig, 96)))
131         }
132         if (v < 27)
133             v += 27;
134         require(block.timestamp <= deadline && !usedSigIds[signer][sigId]); // solium-disable-line security/no-block-members
135         if (std == sigStandard.typed) { // Typed signature. This is the most likely scenario to be used and accepted
136             require(
137                 signer == ecrecover(
138                     keccak256(
139                         signDest == sigDestination.transfer
140                             ? sigDestinationTransfer
141                             : signDest == sigDestination.approve
142                                 ? sigDestinationApprove
143                                 : signDest == sigDestination.approveAndCall
144                                     ? sigDestinationApproveAndCall
145                                     : sigDestinationTransferFrom,
146                         data
147                     ),
148                     v, r, s
149                 )
150             );
151         } else if (std == sigStandard.personal) { // Ethereum signed message signature (Geth and Trezor)
152             require(
153                 signer == ecrecover(keccak256(ethSignedMessagePrefix, "32", data), v, r, s) // Geth-adopted
154                 ||
155                 signer == ecrecover(keccak256(ethSignedMessagePrefix, "\x20", data), v, r, s) // Trezor-adopted
156             );
157         } else { // == 2; Signed string hash signature (the most expensive but universal)
158             require(
159                 signer == ecrecover(keccak256(ethSignedMessagePrefix, "64", hexToString(data)), v, r, s) // Geth
160                 ||
161                 signer == ecrecover(keccak256(ethSignedMessagePrefix, "\x40", hexToString(data)), v, r, s) // Trezor
162             );
163         }
164         usedSigIds[signer][sigId] = true;
165     }
166 
167     /**
168      * Utility costly function to encode bytes HEX representation as string.
169      * @param sig - signature to encode.
170      */
171     function hexToString (bytes32 sig) internal pure returns (bytes) { // /to-try/ convert to two uint256 and test gas
172         bytes memory str = new bytes(64);
173         for (uint8 i = 0; i < 32; ++i) {
174             str[2 * i] = byte((uint8(sig[i]) / 16 < 10 ? 48 : 87) + uint8(sig[i]) / 16);
175             str[2 * i + 1] = byte((uint8(sig[i]) % 16 < 10 ? 48 : 87) + (uint8(sig[i]) % 16));
176         }
177         return str;
178     }
179 
180     /**
181      * Transfer `value` tokens to `to` address from the account of sender.
182      * @param to - the address of the recipient
183      * @param value - the amount to send
184      */
185     function transfer (address to, uint256 value) public returns (bool) {
186         internalTransfer(msg.sender, to, value);
187         return true;
188     }
189 
190     /**
191      * This function distincts transaction signer from transaction executor. It allows anyone to transfer tokens
192      * from the `from` account by providing a valid signature, which can only be obtained from the `from` account
193      * owner.
194      * Note that passed parameter sigId is unique and cannot be passed twice (prevents replay attacks). When there's
195      * a need to make signature once again (because the first on is lost or whatever), user should sign the message
196      * with the same sigId, thus ensuring that the previous signature won't be used if the new one passes.
197      * Use case: the user wants to send some tokens to other user or smart contract, but don't have ether to do so.
198      * @param from - the account giving its signature to transfer `value` tokens to `to` address
199      * @param to - the account receiving `value` tokens
200      * @param value - the value in tokens to transfer
201      * @param fee - a fee to pay to transaction executor (`msg.sender`)
202      * @param deadline - until when the signature is valid
203      * @param sigId - signature unique ID. Signatures made with the same signature ID cannot be submitted twice
204      * @param sig - signature made by `from`, which is the proof of `from`'s agreement with the above parameters
205      * @param sigStd - chosen standard for signature validation. The signer must explicitly tell which standard they use
206      */
207     function transferViaSignature (
208         address     from,
209         address     to,
210         uint256     value,
211         uint256     fee,
212         uint256     deadline,
213         uint256     sigId,
214         bytes       sig,
215         sigStandard sigStd
216     ) external returns (bool) {
217         requireSignature(
218             keccak256(address(this), from, to, value, fee, deadline, sigId),
219             from, deadline, sigId, sig, sigStd, sigDestination.transfer
220         );
221         internalDoubleTransfer(from, to, value, msg.sender, fee);
222         return true;
223     }
224 
225     /**
226      * Allow `spender` to take `value` tokens from the transaction sender's account.
227      * Beware that changing an allowance with this method brings the risk that `spender` may use both the old
228      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
229      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
230      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231      * @param spender - the address authorized to spend
232      * @param value - the maximum amount they can spend
233      */
234     function approve (address spender, uint256 value) public returns (bool) {
235         allowance[msg.sender][spender] = value;
236         emit Approval(msg.sender, spender, value);
237         return true;
238     }
239 
240     /**
241      * Same as `transferViaSignature`, but for `approve`.
242      * Use case: the user wants to set an allowance for the smart contract or another user without having ether on their
243      * balance.
244      * @param from - the account to approve withdrawal from, which signed all below parameters
245      * @param spender - the account allowed to withdraw tokens from `from` address
246      * @param value - the value in tokens to approve to withdraw
247      * @param fee - a fee to pay to transaction executor (`msg.sender`)
248      * @param deadline - until when the signature is valid
249      * @param sigId - signature unique ID. Signatures made with the same signature ID cannot be submitted twice
250      * @param sig - signature made by `from`, which is the proof of `from`'s agreement with the above parameters
251      * @param sigStd - chosen standard for signature validation. The signer must explicitely tell which standard they use
252      */
253     function approveViaSignature (
254         address     from,
255         address     spender,
256         uint256     value,
257         uint256     fee,
258         uint256     deadline,
259         uint256     sigId,
260         bytes       sig,
261         sigStandard sigStd
262     ) external returns (bool) {
263         requireSignature(
264             keccak256(address(this), from, spender, value, fee, deadline, sigId),
265             from, deadline, sigId, sig, sigStd, sigDestination.approve
266         );
267         allowance[from][spender] = value;
268         emit Approval(from, spender, value);
269         internalTransfer(from, msg.sender, fee);
270         return true;
271     }
272 
273     /**
274      * Transfer `value` tokens to `to` address from the `from` account, using the previously set allowance.
275      * @param from - the address to transfer tokens from
276      * @param to - the address of the recipient
277      * @param value - the amount to send
278      */
279     function transferFrom (address from, address to, uint256 value) public returns (bool) {
280         require(value <= allowance[from][msg.sender]); // Test whether allowance was set
281         allowance[from][msg.sender] -= value;
282         internalTransfer(from, to, value);
283         return true;
284     }
285 
286     /**
287      * Same as `transferViaSignature`, but for `transferFrom`.
288      * Use case: the user wants to withdraw tokens from a smart contract or another user who allowed the user to do so.
289      * Important note: fee is subtracted from `value` before it reaches `to`.
290      * @param from - the address to transfer tokens from
291      * @param to - the address of the recipient
292      * @param value - the amount to send
293      */
294     function transferFromViaSignature (
295         address     signer,
296         address     from,
297         address     to,
298         uint256     value,
299         uint256     fee,
300         uint256     deadline,
301         uint256     sigId,
302         bytes       sig,
303         sigStandard sigStd
304     ) external returns (bool) {
305         requireSignature(
306             keccak256(address(this), signer, from, to, value, fee, deadline, sigId),
307             signer, deadline, sigId, sig, sigStd, sigDestination.transferFrom
308         );
309         require(value <= allowance[from][signer] && value >= fee);
310         allowance[from][signer] -= value;
311         internalDoubleTransfer(from, to, value - fee, msg.sender, fee);
312         return true;
313     }
314 
315     /**
316      * Utility function, which acts the same as approve(...) does, but also calls `receiveApproval` function on a
317      * `spender` address, which is usually the address of the smart contract. In the same call, smart contract can
318      * withdraw tokens from the sender's account and receive additional `extraData` for processing.
319      * @param spender - the address to be authorized to spend tokens
320      * @param value - the max amount the `spender` can withdraw
321      * @param extraData - some extra information to send to the approved contract
322      */
323     function approveAndCall (address spender, uint256 value, bytes extraData) public returns (bool) {
324         approve(spender, value);
325         tokenRecipient(spender).receiveApproval(msg.sender, value, this, extraData);
326         return true;
327     }
328 
329     /**
330      * Same as `approveViaSignature`, but for `approveAndCall`.
331      * Use case: the user wants to send tokens to the smart contract and pass additional data within one transaction.
332      * @param from - the account to approve withdrawal from, which signed all below parameters
333      * @param spender - the account allowed to withdraw tokens from `from` address (in this case, smart contract only)
334      * @param value - the value in tokens to approve to withdraw
335      * @param extraData - additional data to pass to the `spender` smart contract
336      * @param fee - a fee to pay to transaction executor (`msg.sender`)
337      * @param deadline - until when the signature is valid
338      * @param sigId - signature unique ID. Signatures made with the same signature ID cannot be submitted twice
339      * @param sig - signature made by `from`, which is the proof of `from`'s agreement with the above parameters
340      * @param sigStd - chosen standard for signature validation. The signer must explicitely tell which standard they use
341      */
342     function approveAndCallViaSignature (
343         address     from,
344         address     spender,
345         uint256     value,
346         bytes       extraData,
347         uint256     fee,
348         uint256     deadline,
349         uint256     sigId,
350         bytes       sig,
351         sigStandard sigStd
352     ) external returns (bool) {
353         requireSignature(
354             keccak256(address(this), from, spender, value, extraData, fee, deadline, sigId),
355             from, deadline, sigId, sig, sigStd, sigDestination.approveAndCall
356         );
357         allowance[from][spender] = value;
358         emit Approval(from, spender, value);
359         tokenRecipient(spender).receiveApproval(from, value, this, extraData);
360         internalTransfer(from, msg.sender, fee);
361         return true;
362     }
363 
364     /**
365      * `tokenDistributor` is authorized to distribute tokens to the parties who participated in the token sale by the
366      * time the `lastMint` function is triggered, which closes the ability to mint any new tokens forever.
367      * @param recipients - Addresses of token recipients
368      * @param amounts - Corresponding amount of each token recipient in `recipients`
369      */
370     function multiMint (address[] recipients, uint256[] amounts) external {
371         
372         // Once the token distribution ends, tokenDistributor will become 0x0 and multiMint will never work
373         require(tokenDistributor != 0x0 && tokenDistributor == msg.sender && recipients.length == amounts.length);
374 
375         uint total = 0;
376 
377         for (uint i = 0; i < recipients.length; ++i) {
378             balanceOf[recipients[i]] += amounts[i];
379             total += amounts[i];
380             emit Transfer(0x0, recipients[i], amounts[i]);
381         }
382 
383         totalSupply += total;
384         
385     }
386 
387     /**
388      * The last mint that will ever happen. Disables the multiMint function and mints remaining 40% of tokens (in
389      * regard of 60% tokens minted before) to a `tokenDistributor` address.
390      */
391     function lastMint () external {
392 
393         require(tokenDistributor != 0x0 && tokenDistributor == msg.sender && totalSupply > 0);
394 
395         uint256 remaining = totalSupply * 40 / 60; // Portion of tokens for DreamTeam (40%)
396 
397         // To make the total supply rounded (no fractional part), subtract the fractional part from DreamTeam's balance
398         uint256 fractionalPart = (remaining + totalSupply) % (uint256(10) ** decimals);
399         if (fractionalPart <= remaining)
400             remaining -= fractionalPart; // Remove the fractional part to round the totalSupply
401 
402         balanceOf[tokenDistributor] += remaining;
403         emit Transfer(0x0, tokenDistributor, remaining);
404 
405         totalSupply += remaining;
406         tokenDistributor = 0x0; // Disable multiMint and lastMint functions forever
407 
408     }
409 
410     /**
411      * ERC20 token is not designed to hold any tokens itself. This function allows to rescue tokens accidentally sent
412      * to the address of this smart contract.
413      * @param tokenContract - ERC-20 compatible token
414      * @param value - amount to rescue
415      */
416     function rescueTokens (Pasadena tokenContract, uint256 value) public {
417         require(msg.sender == rescueAccount);
418         tokenContract.approve(rescueAccount, value);
419     }
420 
421     /**
422      * Utility function that allows to change the rescueAccount address.
423      * @param newRescueAccount - account which will be authorized to rescue tokens.
424      */
425     function changeRescueAccount (address newRescueAccount) public {
426         require(msg.sender == rescueAccount);
427         rescueAccount = newRescueAccount;
428     }
429 
430 }