1 // SPDX-License-Identifier: Apache-2.0
2 pragma solidity 0.7.5;
3 
4 /**
5  * Contract that exposes the needed erc20 token functions
6  */
7 
8 abstract contract ERC20Interface {
9   // Send _value amount of tokens to address _to
10   function transfer(address _to, uint256 _value)
11     public
12     virtual
13     returns (bool success);
14 
15   // Get the account balance of another account with address _owner
16   function balanceOf(address _owner)
17     public
18     virtual
19     view
20     returns (uint256 balance);
21 }
22 
23 /**
24  * Contract that will forward any incoming Ether to the creator of the contract
25  *
26  */
27 contract Forwarder {
28   // Address to which any funds sent to this contract will be forwarded
29   address public parentAddress;
30   event ForwarderDeposited(address from, uint256 value, bytes data);
31 
32   /**
33    * Initialize the contract, and sets the destination address to that of the creator
34    */
35   function init(address _parentAddress) external onlyUninitialized {
36     parentAddress = _parentAddress;
37     this.flush();
38   }
39 
40   /**
41    * Modifier that will execute internal code block only if the sender is the parent address
42    */
43   modifier onlyParent {
44     require(msg.sender == parentAddress, "Only Parent");
45     _;
46   }
47 
48   /**
49    * Modifier that will execute internal code block only if the contract has not been initialized yet
50    */
51   modifier onlyUninitialized {
52     require(parentAddress == address(0x0), "Already initialized");
53     _;
54   }
55 
56   /**
57    * Default function; Gets called when data is sent but does not match any other function
58    */
59   fallback() external payable {
60     this.flush();
61   }
62 
63   /**
64    * Default function; Gets called when Ether is deposited with no data, and forwards it to the parent address
65    */
66   receive() external payable {
67     this.flush();
68   }
69 
70   /**
71    * Execute a token transfer of the full balance from the forwarder token to the parent address
72    * @param tokenContractAddress the address of the erc20 token contract
73    */
74   function flushTokens(address tokenContractAddress) external onlyParent {
75     ERC20Interface instance = ERC20Interface(tokenContractAddress);
76     address forwarderAddress = address(this);
77     uint256 forwarderBalance = instance.balanceOf(forwarderAddress);
78     if (forwarderBalance == 0) {
79       return;
80     }
81 
82     require(
83       instance.transfer(parentAddress, forwarderBalance),
84       "Token flush failed"
85     );
86   }
87 
88   /**
89    * Flush the entire balance of the contract to the parent address.
90    */
91   function flush() external {
92     uint256 value = address(this).balance;
93 
94     if (value == 0) {
95       return;
96     }
97 
98     (bool success, ) = parentAddress.call{ value: value }("");
99     require(success, "Flush failed");
100     emit ForwarderDeposited(msg.sender, value, msg.data);
101   }
102 }
103 
104 /**
105  *
106  * WalletSimple
107  * ============
108  *
109  * Basic multi-signer wallet designed for use in a co-signing environment where 2 signatures are required to move funds.
110  * Typically used in a 2-of-3 signing configuration. Uses ecrecover to allow for 2 signatures in a single transaction.
111  *
112  * The first signature is created on the operation hash (see Data Formats) and passed to sendMultiSig/sendMultiSigToken
113  * The signer is determined by verifyMultiSig().
114  *
115  * The second signature is created by the submitter of the transaction and determined by msg.signer.
116  *
117  * Data Formats
118  * ============
119  *
120  * The signature is created with ethereumjs-util.ecsign(operationHash).
121  * Like the eth_sign RPC call, it packs the values as a 65-byte array of [r, s, v].
122  * Unlike eth_sign, the message is not prefixed.
123  *
124  * The operationHash the result of keccak256(prefix, toAddress, value, data, expireTime).
125  * For ether transactions, `prefix` is "ETHER".
126  * For token transaction, `prefix` is "ERC20" and `data` is the tokenContractAddress.
127  *
128  *
129  */
130 contract WalletSimple {
131   // Events
132   event Deposited(address from, uint256 value, bytes data);
133   event SafeModeActivated(address msgSender);
134   event Transacted(
135     address msgSender, // Address of the sender of the message initiating the transaction
136     address otherSigner, // Address of the signer (second signature) used to initiate the transaction
137     bytes32 operation, // Operation hash (see Data Formats)
138     address toAddress, // The address the transaction was sent to
139     uint256 value, // Amount of Wei sent to the address
140     bytes data // Data sent when invoking the transaction
141   );
142 
143   event BatchTransfer(address sender, address recipient, uint256 value);
144   // this event shows the other signer and the operation hash that they signed
145   // specific batch transfer events are emitted in Batcher
146   event BatchTransacted(
147     address msgSender, // Address of the sender of the message initiating the transaction
148     address otherSigner, // Address of the signer (second signature) used to initiate the transaction
149     bytes32 operation // Operation hash (see Data Formats)
150   );
151 
152   // Public fields
153   mapping(address => bool) public signers; // The addresses that can co-sign transactions on the wallet
154   bool public safeMode = false; // When active, wallet may only send to signer addresses
155   bool public initialized = false; // True if the contract has been initialized
156 
157   // Internal fields
158   uint256 private lastSequenceId;
159   uint256 private constant MAX_SEQUENCE_ID_INCREASE = 10000;
160 
161   /**
162    * Set up a simple multi-sig wallet by specifying the signers allowed to be used on this wallet.
163    * 2 signers will be required to send a transaction from this wallet.
164    * Note: The sender is NOT automatically added to the list of signers.
165    * Signers CANNOT be changed once they are set
166    *
167    * @param allowedSigners An array of signers on the wallet
168    */
169   function init(address[] calldata allowedSigners) external onlyUninitialized {
170     require(allowedSigners.length == 3, "Invalid number of signers");
171 
172     for (uint8 i = 0; i < allowedSigners.length; i++) {
173       require(allowedSigners[i] != address(0), "Invalid signer");
174       signers[allowedSigners[i]] = true;
175     }
176     initialized = true;
177   }
178 
179   /**
180    * Get the network identifier that signers must sign over
181    * This provides protection signatures being replayed on other chains
182    * This must be a virtual function because chain-specific contracts will need
183    *    to override with their own network ids. It also can't be a field
184    *    to allow this contract to be used by proxy with delegatecall, which will
185    *    not pick up on state variables
186    */
187   function getNetworkId() internal virtual pure returns (string memory) {
188     return "ETHER";
189   }
190 
191   /**
192    * Get the network identifier that signers must sign over for token transfers
193    * This provides protection signatures being replayed on other chains
194    * This must be a virtual function because chain-specific contracts will need
195    *    to override with their own network ids. It also can't be a field
196    *    to allow this contract to be used by proxy with delegatecall, which will
197    *    not pick up on state variables
198    */
199   function getTokenNetworkId() internal virtual pure returns (string memory) {
200     return "ERC20";
201   }
202 
203   /**
204    * Get the network identifier that signers must sign over for batch transfers
205    * This provides protection signatures being replayed on other chains
206    * This must be a virtual function because chain-specific contracts will need
207    *    to override with their own network ids. It also can't be a field
208    *    to allow this contract to be used by proxy with delegatecall, which will
209    *    not pick up on state variables
210    */
211   function getBatchNetworkId() internal virtual pure returns (string memory) {
212     return "ETHER-Batch";
213   }
214 
215   /**
216    * Determine if an address is a signer on this wallet
217    * @param signer address to check
218    * returns boolean indicating whether address is signer or not
219    */
220   function isSigner(address signer) public view returns (bool) {
221     return signers[signer];
222   }
223 
224   /**
225    * Modifier that will execute internal code block only if the sender is an authorized signer on this wallet
226    */
227   modifier onlySigner {
228     require(isSigner(msg.sender), "Non-signer in onlySigner method");
229     _;
230   }
231 
232   /**
233    * Modifier that will execute internal code block only if the contract has not been initialized yet
234    */
235   modifier onlyUninitialized {
236     require(!initialized, "Contract already initialized");
237     _;
238   }
239 
240   /**
241    * Gets called when a transaction is received with data that does not match any other method
242    */
243   fallback() external payable {
244     if (msg.value > 0) {
245       // Fire deposited event if we are receiving funds
246       Deposited(msg.sender, msg.value, msg.data);
247     }
248   }
249 
250   /**
251    * Gets called when a transaction is received with ether and no data
252    */
253   receive() external payable {
254     if (msg.value > 0) {
255       // Fire deposited event if we are receiving funds
256       Deposited(msg.sender, msg.value, msg.data);
257     }
258   }
259 
260   /**
261    * Execute a multi-signature transaction from this wallet using 2 signers: one from msg.sender and the other from ecrecover.
262    * Sequence IDs are numbers starting from 1. They are used to prevent replay attacks and may not be repeated.
263    *
264    * @param toAddress the destination address to send an outgoing transaction
265    * @param value the amount in Wei to be sent
266    * @param data the data to send to the toAddress when invoking the transaction
267    * @param expireTime the number of seconds since 1970 for which this transaction is valid
268    * @param sequenceId the unique sequence id obtainable from getNextSequenceId
269    * @param signature see Data Formats
270    */
271   function sendMultiSig(
272     address toAddress,
273     uint256 value,
274     bytes calldata data,
275     uint256 expireTime,
276     uint256 sequenceId,
277     bytes calldata signature
278   ) external onlySigner {
279     // Verify the other signer
280     bytes32 operationHash = keccak256(
281       abi.encodePacked(
282         getNetworkId(),
283         toAddress,
284         value,
285         data,
286         expireTime,
287         sequenceId
288       )
289     );
290 
291     address otherSigner = verifyMultiSig(
292       toAddress,
293       operationHash,
294       signature,
295       expireTime,
296       sequenceId
297     );
298 
299     // Success, send the transaction
300     (bool success, ) = toAddress.call{ value: value }(data);
301     require(success, "Call execution failed");
302 
303     emit Transacted(
304       msg.sender,
305       otherSigner,
306       operationHash,
307       toAddress,
308       value,
309       data
310     );
311   }
312 
313   /**
314    * Execute a batched multi-signature transaction from this wallet using 2 signers: one from msg.sender and the other from ecrecover.
315    * Sequence IDs are numbers starting from 1. They are used to prevent replay attacks and may not be repeated.
316    * The recipients and values to send are encoded in two arrays, where for index i, recipients[i] will be sent values[i].
317    *
318    * @param recipients The list of recipients to send to
319    * @param values The list of values to send to
320    * @param expireTime the number of seconds since 1970 for which this transaction is valid
321    * @param sequenceId the unique sequence id obtainable from getNextSequenceId
322    * @param signature see Data Formats
323    */
324   function sendMultiSigBatch(
325     address[] calldata recipients,
326     uint256[] calldata values,
327     uint256 expireTime,
328     uint256 sequenceId,
329     bytes calldata signature
330   ) external onlySigner {
331     require(recipients.length != 0, "Not enough recipients");
332     require(
333       recipients.length == values.length,
334       "Unequal recipients and values"
335     );
336     require(recipients.length < 256, "Too many recipients, max 255");
337 
338     // Verify the other signer
339     bytes32 operationHash = keccak256(
340       abi.encodePacked(
341         getBatchNetworkId(),
342         recipients,
343         values,
344         expireTime,
345         sequenceId
346       )
347     );
348 
349     // the first parameter (toAddress) is used to ensure transactions in safe mode only go to a signer
350     // if in safe mode, we should use normal sendMultiSig to recover, so this check will always fail if in safe mode
351     require(!safeMode, "Batch in safe mode");
352     address otherSigner = verifyMultiSig(
353       address(0x0),
354       operationHash,
355       signature,
356       expireTime,
357       sequenceId
358     );
359 
360     batchTransfer(recipients, values);
361     emit BatchTransacted(msg.sender, otherSigner, operationHash);
362   }
363 
364   /**
365    * Transfer funds in a batch to each of recipients
366    * @param recipients The list of recipients to send to
367    * @param values The list of values to send to recipients.
368    *  The recipient with index i in recipients array will be sent values[i].
369    *  Thus, recipients and values must be the same length
370    */
371   function batchTransfer(
372     address[] calldata recipients,
373     uint256[] calldata values
374   ) internal {
375     for (uint256 i = 0; i < recipients.length; i++) {
376       require(address(this).balance >= values[i], "Insufficient funds");
377 
378       (bool success, ) = recipients[i].call{ value: values[i] }("");
379       require(success, "Call failed");
380 
381       emit BatchTransfer(msg.sender, recipients[i], values[i]);
382     }
383   }
384 
385   /**
386    * Execute a multi-signature token transfer from this wallet using 2 signers: one from msg.sender and the other from ecrecover.
387    * Sequence IDs are numbers starting from 1. They are used to prevent replay attacks and may not be repeated.
388    *
389    * @param toAddress the destination address to send an outgoing transaction
390    * @param value the amount in tokens to be sent
391    * @param tokenContractAddress the address of the erc20 token contract
392    * @param expireTime the number of seconds since 1970 for which this transaction is valid
393    * @param sequenceId the unique sequence id obtainable from getNextSequenceId
394    * @param signature see Data Formats
395    */
396   function sendMultiSigToken(
397     address toAddress,
398     uint256 value,
399     address tokenContractAddress,
400     uint256 expireTime,
401     uint256 sequenceId,
402     bytes calldata signature
403   ) external onlySigner {
404     // Verify the other signer
405     bytes32 operationHash = keccak256(
406       abi.encodePacked(
407         getTokenNetworkId(),
408         toAddress,
409         value,
410         tokenContractAddress,
411         expireTime,
412         sequenceId
413       )
414     );
415 
416     verifyMultiSig(
417       toAddress,
418       operationHash,
419       signature,
420       expireTime,
421       sequenceId
422     );
423 
424     ERC20Interface instance = ERC20Interface(tokenContractAddress);
425     require(instance.transfer(toAddress, value), "ERC20 Transfer call failed");
426   }
427 
428   /**
429    * Execute a token flush from one of the forwarder addresses. This transfer needs only a single signature and can be done by any signer
430    *
431    * @param forwarderAddress the address of the forwarder address to flush the tokens from
432    * @param tokenContractAddress the address of the erc20 token contract
433    */
434   function flushForwarderTokens(
435     address payable forwarderAddress,
436     address tokenContractAddress
437   ) external onlySigner {
438     Forwarder forwarder = Forwarder(forwarderAddress);
439     forwarder.flushTokens(tokenContractAddress);
440   }
441 
442   /**
443    * Do common multisig verification for both eth sends and erc20token transfers
444    *
445    * @param toAddress the destination address to send an outgoing transaction
446    * @param operationHash see Data Formats
447    * @param signature see Data Formats
448    * @param expireTime the number of seconds since 1970 for which this transaction is valid
449    * @param sequenceId the unique sequence id obtainable from getNextSequenceId
450    * returns address that has created the signature
451    */
452   function verifyMultiSig(
453     address toAddress,
454     bytes32 operationHash,
455     bytes calldata signature,
456     uint256 expireTime,
457     uint256 sequenceId
458   ) private returns (address) {
459     address otherSigner = recoverAddressFromSignature(operationHash, signature);
460 
461     // Verify if we are in safe mode. In safe mode, the wallet can only send to signers
462     require(!safeMode || isSigner(toAddress), "External transfer in safe mode");
463 
464     // Verify that the transaction has not expired
465     require(expireTime >= block.timestamp, "Transaction expired");
466 
467     // Try to insert the sequence ID. Will revert if the sequence id was invalid
468     tryUpdateSequenceId(sequenceId);
469 
470     require(isSigner(otherSigner), "Invalid signer");
471 
472     require(otherSigner != msg.sender, "Signers cannot be equal");
473 
474     return otherSigner;
475   }
476 
477   /**
478    * Irrevocably puts contract into safe mode. When in this mode, transactions may only be sent to signing addresses.
479    */
480   function activateSafeMode() external onlySigner {
481     safeMode = true;
482     SafeModeActivated(msg.sender);
483   }
484 
485   /**
486    * Gets signer's address using ecrecover
487    * @param operationHash see Data Formats
488    * @param signature see Data Formats
489    * returns address recovered from the signature
490    */
491   function recoverAddressFromSignature(
492     bytes32 operationHash,
493     bytes memory signature
494   ) private pure returns (address) {
495     require(signature.length == 65, "Invalid signature - wrong length");
496 
497     // We need to unpack the signature, which is given as an array of 65 bytes (like eth.sign)
498     bytes32 r;
499     bytes32 s;
500     uint8 v;
501 
502     // solhint-disable-next-line
503     assembly {
504       r := mload(add(signature, 32))
505       s := mload(add(signature, 64))
506       v := and(mload(add(signature, 65)), 255)
507     }
508     if (v < 27) {
509       v += 27; // Ethereum versions are 27 or 28 as opposed to 0 or 1 which is submitted by some signing libs
510     }
511 
512     // protect against signature malleability
513     // S value must be in the lower half orader
514     // reference: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/051d340171a93a3d401aaaea46b4b62fa81e5d7c/contracts/cryptography/ECDSA.sol#L53
515     require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
516 
517     // note that this returns 0 if the signature is invalid
518     // Since 0x0 can never be a signer, when the recovered signer address
519     // is checked against our signer list, that 0x0 will cause an invalid signer failure
520     return ecrecover(operationHash, v, r, s);
521   }
522 
523   /**
524    * Verify that the sequence id is greater than the currently stored value and updates the stored value.
525    * By requiring sequence IDs to always increase, we ensure that the same signature can't be used twice.
526    * @param sequenceId The new sequenceId to use
527    */
528   function tryUpdateSequenceId(uint256 sequenceId) private onlySigner {
529     require(sequenceId > lastSequenceId, "sequenceId is too low");
530 
531     // Block sequence IDs which are much higher than the current
532     // This prevents people blocking the contract by using very large sequence IDs quickly
533     require(
534       sequenceId <= lastSequenceId + MAX_SEQUENCE_ID_INCREASE,
535       "sequenceId is too high"
536     );
537 
538     lastSequenceId = sequenceId;
539   }
540 
541   /**
542    * Gets the next available sequence ID for signing when using executeAndConfirm
543    * returns the sequenceId one higher than the one currently stored
544    */
545   function getNextSequenceId() external view returns (uint256) {
546     return lastSequenceId + 1;
547   }
548 }