1 pragma solidity 0.4.24;
2 
3 interface tokenRecipient {
4     function receiveApproval (address from, uint256 value, address token, bytes extraData) external;
5 }
6 
7 interface ERC20CompatibleToken {
8     function transfer (address to, uint256 value) external returns (bool);
9 }
10 
11 /**
12  * Math operations with safety checks that throw on overflows.
13  */
14 library SafeMath {
15     
16     function mul (uint256 a, uint256 b) internal pure returns (uint256 c) {
17         if (a == 0) {
18             return 0;
19         }
20         c = a * b;
21         require(c / a == b);
22         return c;
23     }
24     
25     function div (uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         // uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return a / b;
30     }
31     
32     function sub (uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b <= a);
34         return a - b;
35     }
36 
37     function add (uint256 a, uint256 b) internal pure returns (uint256 c) {
38         c = a + b;
39         require(c >= a);
40         return c;
41     }
42 
43 }
44 
45 /**
46  * DreamTeam token contract. It implements the next capabilities:
47  * 1. Standard ERC20 functionality.
48  * 2. Additional utility function approveAndCall.
49  * 3. Function to rescue "lost forever" tokens, which were accidentally sent to this smart contract.
50  * 4. Additional transfer and approve functions which allow to distinct the transaction signer and executor,
51  *    which enables accounts with no Ether on their balances to make token transfers and use DreamTeam services.
52  * 5. Token sale distribution rules.
53  */ 		   	  				  	  	      		 			  		 	  	 		 	 		 		 	  	 			 	   		    	  	 			  			 	   		 	 		
54 contract DreamTeamToken {
55 
56     using SafeMath for uint256;
57 
58     string public name;
59     string public symbol;
60     uint8 public decimals = 6; // Allows JavaScript to handle precise calculations (until totalSupply < 9 billion)
61     uint256 public totalSupply;
62     mapping(address => uint256) public balanceOf;
63     mapping(address => mapping(address => uint256)) public allowance;
64     mapping(address => mapping(uint => bool)) public usedSigIds; // Used in *ViaSignature(..)
65     address public tokenDistributor; // Account authorized to distribute tokens only during the token distribution event
66     address public rescueAccount; // Account authorized to withdraw tokens accidentally sent to this contract
67 
68     event Transfer(address indexed from, address indexed to, uint256 value);
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 
71     modifier rescueAccountOnly {require(msg.sender == rescueAccount); _;}
72     modifier tokenDistributionPeriodOnly {require(tokenDistributor == msg.sender); _;}
73 
74     enum sigStandard { typed, personal, stringHex }
75     enum sigDestination { transfer, approve, approveAndCall, transferFrom }
76 
77     bytes constant public ethSignedMessagePrefix = "\x19Ethereum Signed Message:\n";
78     bytes32 constant public sigDestinationTransfer = keccak256(
79         "address Token Contract Address",
80         "address Sender's Address",
81         "address Recipient's Address",
82         "uint256 Amount to Transfer (last six digits are decimals)",
83         "uint256 Fee in Tokens Paid to Executor (last six digits are decimals)",
84         "address Account which Receives Fee",
85         "uint256 Signature Expiration Timestamp (unix timestamp)",
86         "uint256 Signature ID"
87     ); // `transferViaSignature`: keccak256(address(this), from, to, value, fee, deadline, sigId)
88     bytes32 constant public sigDestinationTransferFrom = keccak256(
89         "address Token Contract Address",
90         "address Address Approved for Withdraw",
91         "address Account to Withdraw From",
92         "address Withdrawal Recipient Address",
93         "uint256 Amount to Transfer (last six digits are decimals)",
94         "uint256 Fee in Tokens Paid to Executor (last six digits are decimals)",
95         "address Account which Receives Fee",
96         "uint256 Signature Expiration Timestamp (unix timestamp)",
97         "uint256 Signature ID"
98     ); // `transferFromViaSignature`: keccak256(address(this), signer, from, to, value, fee, deadline, sigId)
99     bytes32 constant public sigDestinationApprove = keccak256(
100         "address Token Contract Address",
101         "address Withdrawal Approval Address",
102         "address Withdrawal Recipient Address",
103         "uint256 Amount to Transfer (last six digits are decimals)",
104         "uint256 Fee in Tokens Paid to Executor (last six digits are decimals)",
105         "address Account which Receives Fee",
106         "uint256 Signature Expiration Timestamp (unix timestamp)",
107         "uint256 Signature ID"
108     ); // `approveViaSignature`: keccak256(address(this), from, spender, value, fee, deadline, sigId)
109     bytes32 constant public sigDestinationApproveAndCall = keccak256(
110         "address Token Contract Address",
111         "address Withdrawal Approval Address",
112         "address Withdrawal Recipient Address",
113         "uint256 Amount to Transfer (last six digits are decimals)",
114         "bytes Data to Transfer",
115         "uint256 Fee in Tokens Paid to Executor (last six digits are decimals)",
116         "address Account which Receives Fee",
117         "uint256 Signature Expiration Timestamp (unix timestamp)",
118         "uint256 Signature ID"
119     ); // `approveAndCallViaSignature`: keccak256(address(this), from, spender, value, extraData, fee, deadline, sigId)
120 
121     /**
122      * @param tokenName - full token name
123      * @param tokenSymbol - token symbol
124      */
125     constructor (string tokenName, string tokenSymbol) public {
126         name = tokenName;
127         symbol = tokenSymbol;
128         rescueAccount = tokenDistributor = msg.sender;
129     } 		   	  				  	  	      		 			  		 	  	 		 	 		 		 	  	 			 	   		    	  	 			  			 	   		 	 		
130 
131     /**
132      * Utility internal function used to safely transfer `value` tokens `from` -> `to`. Throws if transfer is impossible.
133      * @param from - account to make the transfer from
134      * @param to - account to transfer `value` tokens to
135      * @param value - tokens to transfer to account `to`
136      */
137     function internalTransfer (address from, address to, uint value) internal {
138         require(to != 0x0); // Prevent people from accidentally burning their tokens
139         balanceOf[from] = balanceOf[from].sub(value);
140         balanceOf[to] = balanceOf[to].add(value);
141         emit Transfer(from, to, value);
142     }
143 
144     /**
145      * Utility internal function used to safely transfer `value1` tokens `from` -> `to1`, and `value2` tokens
146      * `from` -> `to2`, minimizing gas usage (calling `internalTransfer` twice is more expensive). Throws if
147      * transfers are impossible.
148      * @param from - account to make the transfer from
149      * @param to1 - account to transfer `value1` tokens to
150      * @param value1 - tokens to transfer to account `to1`
151      * @param to2 - account to transfer `value2` tokens to
152      * @param value2 - tokens to transfer to account `to2`
153      */
154     function internalDoubleTransfer (address from, address to1, uint value1, address to2, uint value2) internal {
155         require(to1 != 0x0 && to2 != 0x0); // Prevent people from accidentally burning their tokens
156         balanceOf[from] = balanceOf[from].sub(value1.add(value2));
157         balanceOf[to1] = balanceOf[to1].add(value1);
158         emit Transfer(from, to1, value1);
159         if (value2 > 0) {
160             balanceOf[to2] = balanceOf[to2].add(value2);
161             emit Transfer(from, to2, value2);
162         }
163     }
164 
165     /**
166      * Internal method that makes sure that the given signature corresponds to a given data and is made by `signer`.
167      * It utilizes three (four) standards of message signing in Ethereum, as at the moment of this smart contract
168      * development there is no single signing standard defined. For example, Metamask and Geth both support
169      * personal_sign standard, SignTypedData is only supported by Matamask, Trezor does not support "widely adopted"
170      * Ethereum personal_sign but rather personal_sign with fixed prefix and so on.
171      * Note that it is always possible to forge any of these signatures using the private key, the problem is that
172      * third-party wallets must adopt a single standard for signing messages.
173      * @param data - original data which had to be signed by `signer`
174      * @param signer - account which made a signature
175      * @param deadline - until when the signature is valid
176      * @param sigId - signature unique ID. Signatures made with the same signature ID cannot be submitted twice
177      * @param sig - signature made by `from`, which is the proof of `from`'s agreement with the above parameters
178      * @param sigStd - chosen standard for signature validation. The signer must explicitly tell which standard they use
179      * @param sigDest - for which type of action this signature was made
180      */
181     function requireSignature (
182         bytes32 data,
183         address signer,
184         uint256 deadline,
185         uint256 sigId,
186         bytes sig,
187         sigStandard sigStd,
188         sigDestination sigDest
189     ) internal {
190         bytes32 r;
191         bytes32 s;
192         uint8 v;
193         assembly { // solium-disable-line security/no-inline-assembly
194             r := mload(add(sig, 32))
195             s := mload(add(sig, 64)) 		   	  				  	  	      		 			  		 	  	 		 	 		 		 	  	 			 	   		    	  	 			  			 	   		 	 		
196             v := byte(0, mload(add(sig, 96)))
197         }
198         if (v < 27)
199             v += 27;
200         require(block.timestamp <= deadline && !usedSigIds[signer][sigId]); // solium-disable-line security/no-block-members
201         if (sigStd == sigStandard.typed) { // Typed signature. This is the most likely scenario to be used and accepted
202             require(
203                 signer == ecrecover(
204                     keccak256(
205                         sigDest == sigDestination.transfer
206                             ? sigDestinationTransfer
207                             : sigDest == sigDestination.approve
208                                 ? sigDestinationApprove
209                                 : sigDest == sigDestination.approveAndCall
210                                     ? sigDestinationApproveAndCall
211                                     : sigDestinationTransferFrom,
212                         data
213                     ),
214                     v, r, s
215                 )
216             );
217         } else if (sigStd == sigStandard.personal) { // Ethereum signed message signature (Geth and Trezor)
218             require(
219                 signer == ecrecover(keccak256(ethSignedMessagePrefix, "32", data), v, r, s) // Geth-adopted
220                 ||
221                 signer == ecrecover(keccak256(ethSignedMessagePrefix, "\x20", data), v, r, s) // Trezor-adopted
222             );
223         } else { // == 2; Signed string hash signature (the most expensive but universal)
224             require(
225                 signer == ecrecover(keccak256(ethSignedMessagePrefix, "64", hexToString(data)), v, r, s) // Geth
226                 ||
227                 signer == ecrecover(keccak256(ethSignedMessagePrefix, "\x40", hexToString(data)), v, r, s) // Trezor
228             );
229         }
230         usedSigIds[signer][sigId] = true;
231     }
232 
233     /**
234      * Utility costly function to encode bytes HEX representation as string.
235      * @param sig - signature as bytes32 to represent as string
236      */
237     function hexToString (bytes32 sig) internal pure returns (bytes) {
238         bytes memory str = new bytes(64);
239         for (uint8 i = 0; i < 32; ++i) {
240             str[2 * i] = byte((uint8(sig[i]) / 16 < 10 ? 48 : 87) + uint8(sig[i]) / 16);
241             str[2 * i + 1] = byte((uint8(sig[i]) % 16 < 10 ? 48 : 87) + (uint8(sig[i]) % 16));
242         }
243         return str;
244     }
245 
246     /**
247      * Transfer `value` tokens to `to` address from the account of sender.
248      * @param to - the address of the recipient
249      * @param value - the amount to send
250      */
251     function transfer (address to, uint256 value) public returns (bool) {
252         internalTransfer(msg.sender, to, value);
253         return true;
254     }
255 
256     /**
257      * This function distincts transaction signer from transaction executor. It allows anyone to transfer tokens
258      * from the `from` account by providing a valid signature, which can only be obtained from the `from` account
259      * owner.
260      * Note that passed parameter sigId is unique and cannot be passed twice (prevents replay attacks). When there's
261      * a need to make signature once again (because the first one is lost or whatever), user should sign the message
262      * with the same sigId, thus ensuring that the previous signature can't be used if the new one passes.
263      * Use case: the user wants to send some tokens to another user or smart contract, but don't have Ether to do so.
264      * @param from - the account giving its signature to transfer `value` tokens to `to` address
265      * @param to - the account receiving `value` tokens
266      * @param value - the value in tokens to transfer
267      * @param fee - a fee to pay to `feeRecipient`
268      * @param feeRecipient - account which will receive fee
269      * @param deadline - until when the signature is valid
270      * @param sigId - signature unique ID. Signatures made with the same signature ID cannot be submitted twice
271      * @param sig - signature made by `from`, which is the proof of `from`'s agreement with the above parameters
272      * @param sigStd - chosen standard for signature validation. The signer must explicitly tell which standard they use
273      */
274     function transferViaSignature ( 		   	  				  	  	      		 			  		 	  	 		 	 		 		 	  	 			 	   		    	  	 			  			 	   		 	 		
275         address     from,
276         address     to,
277         uint256     value,
278         uint256     fee,
279         address     feeRecipient,
280         uint256     deadline,
281         uint256     sigId,
282         bytes       sig,
283         sigStandard sigStd
284     ) external returns (bool) {
285         requireSignature(
286             keccak256(address(this), from, to, value, fee, feeRecipient, deadline, sigId),
287             from, deadline, sigId, sig, sigStd, sigDestination.transfer
288         );
289         internalDoubleTransfer(from, to, value, feeRecipient, fee);
290         return true;
291     }
292 
293     /**
294      * Allow `spender` to take `value` tokens from the transaction sender's account.
295      * Beware that changing an allowance with this method brings the risk that `spender` may use both the old
296      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
297      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
298      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
299      * @param spender - the address authorized to spend
300      * @param value - the maximum amount they can spend
301      */
302     function approve (address spender, uint256 value) public returns (bool) {
303         allowance[msg.sender][spender] = value;
304         emit Approval(msg.sender, spender, value);
305         return true;
306     }
307 
308     /**
309      * Same as `transferViaSignature`, but for `approve`.
310      * Use case: the user wants to set an allowance for the smart contract or another user without having Ether on
311      * their balance.
312      * @param from - the account to approve withdrawal from, which signed all below parameters
313      * @param spender - the account allowed to withdraw tokens from `from` address
314      * @param value - the value in tokens to approve to withdraw
315      * @param fee - a fee to pay to `feeRecipient`
316      * @param feeRecipient - account which will receive fee
317      * @param deadline - until when the signature is valid
318      * @param sigId - signature unique ID. Signatures made with the same signature ID cannot be submitted twice
319      * @param sig - signature made by `from`, which is the proof of `from`'s agreement with the above parameters
320      * @param sigStd - chosen standard for signature validation. The signer must explicitly tell which standard they use
321      */
322     function approveViaSignature (
323         address     from,
324         address     spender,
325         uint256     value,
326         uint256     fee,
327         address     feeRecipient,
328         uint256     deadline,
329         uint256     sigId,
330         bytes       sig,
331         sigStandard sigStd
332     ) external returns (bool) {
333         requireSignature(
334             keccak256(address(this), from, spender, value, fee, feeRecipient, deadline, sigId),
335             from, deadline, sigId, sig, sigStd, sigDestination.approve
336         );
337         allowance[from][spender] = value;
338         emit Approval(from, spender, value);
339         internalTransfer(from, feeRecipient, fee);
340         return true;
341     }
342 
343     /**
344      * Transfer `value` tokens to `to` address from the `from` account, using the previously set allowance.
345      * @param from - the address to transfer tokens from
346      * @param to - the address of the recipient
347      * @param value - the amount to send
348      */
349     function transferFrom (address from, address to, uint256 value) public returns (bool) {
350         allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
351         internalTransfer(from, to, value);
352         return true;
353     }
354 
355     /**
356      * Same as `transferViaSignature`, but for `transferFrom`.
357      * Use case: the user wants to withdraw tokens from a smart contract or another user who allowed the user to
358      * do so. Important note: the fee is subtracted from the `value`, and `to` address receives `value - fee`.
359      * @param signer - the address allowed to call transferFrom, which signed all below parameters
360      * @param from - the account to make withdrawal from
361      * @param to - the address of the recipient
362      * @param value - the value in tokens to withdraw
363      * @param fee - a fee to pay to `feeRecipient`
364      * @param feeRecipient - account which will receive fee
365      * @param deadline - until when the signature is valid
366      * @param sigId - signature unique ID. Signatures made with the same signature ID cannot be submitted twice
367      * @param sig - signature made by `from`, which is the proof of `from`'s agreement with the above parameters
368      * @param sigStd - chosen standard for signature validation. The signer must explicitly tell which standard they use
369      */
370     function transferFromViaSignature (
371         address     signer,
372         address     from,
373         address     to,
374         uint256     value,
375         uint256     fee,
376         address     feeRecipient,
377         uint256     deadline,
378         uint256     sigId,
379         bytes       sig,
380         sigStandard sigStd
381     ) external returns (bool) { 		   	  				  	  	      		 			  		 	  	 		 	 		 		 	  	 			 	   		    	  	 			  			 	   		 	 		
382         requireSignature(
383             keccak256(address(this), from, to, value, fee, feeRecipient, deadline, sigId),
384             signer, deadline, sigId, sig, sigStd, sigDestination.transferFrom
385         );
386         allowance[from][signer] = allowance[from][signer].sub(value);
387         internalDoubleTransfer(from, to, value.sub(fee), feeRecipient, fee);
388         return true;
389     }
390 
391     /**
392      * Utility function, which acts the same as approve(...), but also calls `receiveApproval` function on a
393      * `spender` address, which is usually the address of the smart contract. In the same call, smart contract can
394      * withdraw tokens from the sender's account and receive additional `extraData` for processing.
395      * @param spender - the address to be authorized to spend tokens
396      * @param value - the max amount the `spender` can withdraw
397      * @param extraData - some extra information to send to the approved contract
398      */
399     function approveAndCall (address spender, uint256 value, bytes extraData) public returns (bool) {
400         approve(spender, value);
401         tokenRecipient(spender).receiveApproval(msg.sender, value, this, extraData);
402         return true;
403     }
404 
405     /**
406      * Same as `approveViaSignature`, but for `approveAndCall`.
407      * Use case: the user wants to send tokens to the smart contract and pass additional data within one transaction.
408      * @param from - the account to approve withdrawal from, which signed all below parameters
409      * @param spender - the account allowed to withdraw tokens from `from` address (in this case, smart contract only)
410      * @param value - the value in tokens to approve to withdraw
411      * @param extraData - additional data to pass to the `spender` smart contract
412      * @param fee - a fee to pay to `feeRecipient`
413      * @param feeRecipient - account which will receive fee
414      * @param deadline - until when the signature is valid
415      * @param sigId - signature unique ID. Signatures made with the same signature ID cannot be submitted twice
416      * @param sig - signature made by `from`, which is the proof of `from`'s agreement with the above parameters
417      * @param sigStd - chosen standard for signature validation. The signer must explicitly tell which standard they use
418      */
419     function approveAndCallViaSignature (
420         address     from,
421         address     spender,
422         uint256     value,
423         bytes       extraData,
424         uint256     fee,
425         address     feeRecipient,
426         uint256     deadline,
427         uint256     sigId,
428         bytes       sig,
429         sigStandard sigStd
430     ) external returns (bool) {
431         requireSignature(
432             keccak256(address(this), from, spender, value, extraData, fee, feeRecipient, deadline, sigId),
433             from, deadline, sigId, sig, sigStd, sigDestination.approveAndCall
434         );
435         allowance[from][spender] = value;
436         emit Approval(from, spender, value);
437         tokenRecipient(spender).receiveApproval(from, value, this, extraData);
438         internalTransfer(from, feeRecipient, fee);
439         return true;
440     } 		   	  				  	  	      		 			  		 	  	 		 	 		 		 	  	 			 	   		    	  	 			  			 	   		 	 		
441 
442     /**
443      * `tokenDistributor` is authorized to distribute tokens to the parties who participated in the token sale by the
444      * time the `lastMint` function is triggered, which closes the ability to mint any new tokens forever.
445      * Once the token distribution event ends (lastMint is triggered), tokenDistributor will become 0x0 and multiMint
446      * function will never work again.
447      * @param recipients - addresses of token recipients
448      * @param amounts - corresponding amount of each token recipient in `recipients`
449      */
450     function multiMint (address[] recipients, uint256[] amounts) external tokenDistributionPeriodOnly {
451         
452         require(recipients.length == amounts.length);
453 
454         uint total = 0;
455 
456         for (uint i = 0; i < recipients.length; ++i) {
457             balanceOf[recipients[i]] = balanceOf[recipients[i]].add(amounts[i]);
458             total = total.add(amounts[i]);
459             emit Transfer(0x0, recipients[i], amounts[i]);
460         }
461 
462         totalSupply = totalSupply.add(total);
463         
464     }
465  		   	  				  	  	      		 			  		 	  	 		 	 		 		 	  	 			 	   		    	  	 			  			 	   		 	 		
466     /**
467      * The last mint that will ever happen. Disables the multiMint function and mints remaining 40% of tokens (in
468      * regard of 60% tokens minted before) to a `tokenDistributor` address.
469      */
470     function lastMint () external tokenDistributionPeriodOnly {
471 
472         require(totalSupply > 0);
473 
474         uint256 remaining = totalSupply.mul(40).div(60); // Portion of tokens for DreamTeam (40%)
475 
476         // To make the total supply rounded (no fractional part), subtract the fractional part from DreamTeam's balance
477         uint256 fractionalPart = remaining.add(totalSupply) % (uint256(10) ** decimals);
478         remaining = remaining.sub(fractionalPart); // Remove the fractional part to round the totalSupply
479 
480         balanceOf[tokenDistributor] = balanceOf[tokenDistributor].add(remaining);
481         emit Transfer(0x0, tokenDistributor, remaining);
482 
483         totalSupply = totalSupply.add(remaining);
484         tokenDistributor = 0x0; // Disable multiMint and lastMint functions forever
485 
486     }
487 
488     /**
489      * ERC20 tokens are not designed to hold any other tokens (or Ether) on their balances. There were thousands
490      * of cases when people accidentally transfer tokens to a contract address while there is no way to get them
491      * back. This function adds a possibility to "rescue" tokens that were accidentally sent to this smart contract.
492      * @param tokenContract - ERC20-compatible token
493      * @param value - amount to rescue
494      */
495     function rescueLostTokens (ERC20CompatibleToken tokenContract, uint256 value) external rescueAccountOnly {
496         tokenContract.transfer(rescueAccount, value);
497     }
498 
499     /**
500      * Utility function that allows to change the rescueAccount address, which can "rescue" tokens accidentally sent to
501      * this smart contract address.
502      * @param newRescueAccount - account which will become authorized to rescue tokens
503      */ 		   	  				  	  	      		 			  		 	  	 		 	 		 		 	  	 			 	   		    	  	 			  			 	   		 	 		
504     function changeRescueAccount (address newRescueAccount) external rescueAccountOnly {
505         rescueAccount = newRescueAccount;
506     }
507  		   	  				  	  	      		 			  		 	  	 		 	 		 		 	  	 			 	   		    	  	 			  			 	   		 	 		
508 }