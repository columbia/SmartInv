1 pragma solidity ^0.4.18;
2 
3 /**
4  * Contract that exposes the needed erc20 token functions
5  */
6 
7 contract ERC20Interface {
8   // Send _value amount of tokens to address _to
9   function transfer(address _to, uint256 _value) public returns (bool success);
10   // Get the account balance of another account with address _owner
11   function balanceOf(address _owner) public constant returns (uint256 balance);
12 }
13 
14 /**
15  * Contract that will forward any incoming Ether to the creator of the contract
16  */
17 contract Forwarder {
18   // Address to which any funds sent to this contract will be forwarded
19   address public parentAddress;
20   event ForwarderDeposited(address from, uint value, bytes data);
21 
22   /**
23    * Create the contract, and sets the destination address to that of the creator
24    */
25   function Forwarder() public {
26     parentAddress = msg.sender;
27   }
28 
29   /**
30    * Modifier that will execute internal code block only if the sender is the parent address
31    */
32   modifier onlyParent {
33     if (msg.sender != parentAddress) {
34       revert();
35     }
36     _;
37   }
38 
39   /**
40    * Default function; Gets called when Ether is deposited, and forwards it to the parent address
41    */
42   function() public payable {
43     // throws on failure
44     parentAddress.transfer(msg.value);
45     // Fire off the deposited event if we can forward it
46     ForwarderDeposited(msg.sender, msg.value, msg.data);
47   }
48 
49   /**
50    * Execute a token transfer of the full balance from the forwarder token to the parent address
51    * @param tokenContractAddress the address of the erc20 token contract
52    */
53   function flushTokens(address tokenContractAddress) public onlyParent {
54     ERC20Interface instance = ERC20Interface(tokenContractAddress);
55     var forwarderAddress = address(this);
56     var forwarderBalance = instance.balanceOf(forwarderAddress);
57     if (forwarderBalance == 0) {
58       return;
59     }
60     if (!instance.transfer(parentAddress, forwarderBalance)) {
61       revert();
62     }
63   }
64 
65   /**
66    * It is possible that funds were sent to this address before the contract was deployed.
67    * We can flush those funds to the parent address.
68    */
69   function flush() public {
70     // throws on failure
71     parentAddress.transfer(this.balance);
72   }
73 }
74 
75 /**
76  *
77  * WalletSimple
78  * ============
79  *
80  * Basic multi-signer wallet designed for use in a co-signing environment where 2 signatures are required to move funds.
81  * Typically used in a 2-of-3 signing configuration. Uses ecrecover to allow for 2 signatures in a single transaction.
82  *
83  * The first signature is created on the operation hash (see Data Formats) and passed to sendMultiSig/sendMultiSigToken
84  * The signer is determined by verifyMultiSig().
85  *
86  * The second signature is created by the submitter of the transaction and determined by msg.signer.
87  *
88  * Data Formats
89  * ============
90  *
91  * The signature is created with ethereumjs-util.ecsign(operationHash).
92  * Like the eth_sign RPC call, it packs the values as a 65-byte array of [r, s, v].
93  * Unlike eth_sign, the message is not prefixed.
94  *
95  * The operationHash the result of keccak256(prefix, toAddress, value, data, expireTime).
96  * For ether transactions, `prefix` is "ETHER".
97  * For token transaction, `prefix` is "ERC20" and `data` is the tokenContractAddress.
98  *
99  *
100  */
101 contract WalletSimple {
102   // Events
103   event Deposited(address from, uint value, bytes data);
104   event SafeModeActivated(address msgSender);
105   event Transacted(
106     address msgSender, // Address of the sender of the message initiating the transaction
107     address otherSigner, // Address of the signer (second signature) used to initiate the transaction
108     bytes32 operation, // Operation hash (see Data Formats)
109     address toAddress, // The address the transaction was sent to
110     uint value, // Amount of Wei sent to the address
111     bytes data // Data sent when invoking the transaction
112   );
113 
114   // Public fields
115   address[] public signers; // The addresses that can co-sign transactions on the wallet
116   bool public safeMode = false; // When active, wallet may only send to signer addresses
117 
118   // Internal fields
119   uint constant SEQUENCE_ID_WINDOW_SIZE = 10;
120   uint[10] recentSequenceIds;
121 
122   /**
123    * Set up a simple multi-sig wallet by specifying the signers allowed to be used on this wallet.
124    * 2 signers will be required to send a transaction from this wallet.
125    * Note: The sender is NOT automatically added to the list of signers.
126    * Signers CANNOT be changed once they are set
127    *
128    * @param allowedSigners An array of signers on the wallet
129    */
130   function WalletSimple(address[] allowedSigners) public {
131     if (allowedSigners.length != 3) {
132       // Invalid number of signers
133       revert();
134     }
135     signers = allowedSigners;
136   }
137 
138   /**
139    * Determine if an address is a signer on this wallet
140    * @param signer address to check
141    * returns boolean indicating whether address is signer or not
142    */
143   function isSigner(address signer) public view returns (bool) {
144     // Iterate through all signers on the wallet and
145     for (uint i = 0; i < signers.length; i++) {
146       if (signers[i] == signer) {
147         return true;
148       }
149     }
150     return false;
151   }
152 
153   /**
154    * Modifier that will execute internal code block only if the sender is an authorized signer on this wallet
155    */
156   modifier onlySigner {
157     if (!isSigner(msg.sender)) {
158       revert();
159     }
160     _;
161   }
162 
163   /**
164    * Gets called when a transaction is received without calling a method
165    */
166   function() public payable {
167     if (msg.value > 0) {
168       // Fire deposited event if we are receiving funds
169       Deposited(msg.sender, msg.value, msg.data);
170     }
171   }
172 
173   /**
174    * Create a new contract (and also address) that forwards funds to this contract
175    * returns address of newly created forwarder address
176    */
177   function createForwarder() public returns (address) {
178     return new Forwarder();
179   }
180 
181   /**
182    * Execute a multi-signature transaction from this wallet using 2 signers: one from msg.sender and the other from ecrecover.
183    * Sequence IDs are numbers starting from 1. They are used to prevent replay attacks and may not be repeated.
184    *
185    * @param toAddress the destination address to send an outgoing transaction
186    * @param value the amount in Wei to be sent
187    * @param data the data to send to the toAddress when invoking the transaction
188    * @param expireTime the number of seconds since 1970 for which this transaction is valid
189    * @param sequenceId the unique sequence id obtainable from getNextSequenceId
190    * @param signature see Data Formats
191    */
192   function sendMultiSig(
193       address toAddress,
194       uint value,
195       bytes data,
196       uint expireTime,
197       uint sequenceId,
198       bytes signature
199   ) public onlySigner {
200     // Verify the other signer
201     var operationHash = keccak256("ETHER", toAddress, value, data, expireTime, sequenceId);
202     
203     var otherSigner = verifyMultiSig(toAddress, operationHash, signature, expireTime, sequenceId);
204 
205     // Success, send the transaction
206     if (!(toAddress.call.value(value)(data))) {
207       // Failed executing transaction
208       revert();
209     }
210     Transacted(msg.sender, otherSigner, operationHash, toAddress, value, data);
211   }
212   
213   /**
214    * Execute a multi-signature token transfer from this wallet using 2 signers: one from msg.sender and the other from ecrecover.
215    * Sequence IDs are numbers starting from 1. They are used to prevent replay attacks and may not be repeated.
216    *
217    * @param toAddress the destination address to send an outgoing transaction
218    * @param value the amount in tokens to be sent
219    * @param tokenContractAddress the address of the erc20 token contract
220    * @param expireTime the number of seconds since 1970 for which this transaction is valid
221    * @param sequenceId the unique sequence id obtainable from getNextSequenceId
222    * @param signature see Data Formats
223    */
224   function sendMultiSigToken(
225       address toAddress,
226       uint value,
227       address tokenContractAddress,
228       uint expireTime,
229       uint sequenceId,
230       bytes signature
231   ) public onlySigner {
232     // Verify the other signer
233     var operationHash = keccak256("ERC20", toAddress, value, tokenContractAddress, expireTime, sequenceId);
234     
235     verifyMultiSig(toAddress, operationHash, signature, expireTime, sequenceId);
236     
237     ERC20Interface instance = ERC20Interface(tokenContractAddress);
238     if (!instance.transfer(toAddress, value)) {
239         revert();
240     }
241   }
242   
243   /**
244    * Execute a token flush from one of the forwarder addresses. This transfer needs only a single signature and can be done by any signer
245    *
246    * @param forwarderAddress the address of the forwarder address to flush the tokens from
247    * @param tokenContractAddress the address of the erc20 token contract
248    */
249   function flushForwarderTokens(
250     address forwarderAddress, 
251     address tokenContractAddress
252   ) public onlySigner {
253     Forwarder forwarder = Forwarder(forwarderAddress);
254     forwarder.flushTokens(tokenContractAddress);
255   }
256 
257   /**
258    * Do common multisig verification for both eth sends and erc20token transfers
259    *
260    * @param toAddress the destination address to send an outgoing transaction
261    * @param operationHash see Data Formats
262    * @param signature see Data Formats
263    * @param expireTime the number of seconds since 1970 for which this transaction is valid
264    * @param sequenceId the unique sequence id obtainable from getNextSequenceId
265    * returns address that has created the signature
266    */
267   function verifyMultiSig(
268       address toAddress,
269       bytes32 operationHash,
270       bytes signature,
271       uint expireTime,
272       uint sequenceId
273   ) private returns (address) {
274 
275     var otherSigner = recoverAddressFromSignature(operationHash, signature);
276 
277     // Verify if we are in safe mode. In safe mode, the wallet can only send to signers
278     if (safeMode && !isSigner(toAddress)) {
279       // We are in safe mode and the toAddress is not a signer. Disallow!
280       revert();
281     }
282     // Verify that the transaction has not expired
283     if (expireTime < block.timestamp) {
284       // Transaction expired
285       revert();
286     }
287 
288     // Try to insert the sequence ID. Will revert if the sequence id was invalid
289     tryInsertSequenceId(sequenceId);
290 
291     if (!isSigner(otherSigner)) {
292       // Other signer not on this wallet or operation does not match arguments
293       revert();
294     }
295     if (otherSigner == msg.sender) {
296       // Cannot approve own transaction
297       revert();
298     }
299 
300     return otherSigner;
301   }
302 
303   /**
304    * Irrevocably puts contract into safe mode. When in this mode, transactions may only be sent to signing addresses.
305    */
306   function activateSafeMode() public onlySigner {
307     safeMode = true;
308     SafeModeActivated(msg.sender);
309   }
310 
311   /**
312    * Gets signer's address using ecrecover
313    * @param operationHash see Data Formats
314    * @param signature see Data Formats
315    * returns address recovered from the signature
316    */
317   function recoverAddressFromSignature(
318     bytes32 operationHash,
319     bytes signature
320   ) private pure returns (address) {
321     if (signature.length != 65) {
322       revert();
323     }
324     // We need to unpack the signature, which is given as an array of 65 bytes (like eth.sign)
325     bytes32 r;
326     bytes32 s;
327     uint8 v;
328     assembly {
329       r := mload(add(signature, 32))
330       s := mload(add(signature, 64))
331       v := and(mload(add(signature, 65)), 255)
332     }
333     if (v < 27) {
334       v += 27; // Ethereum versions are 27 or 28 as opposed to 0 or 1 which is submitted by some signing libs
335     }
336     return ecrecover(operationHash, v, r, s);
337   }
338 
339   /**
340    * Verify that the sequence id has not been used before and inserts it. Throws if the sequence ID was not accepted.
341    * We collect a window of up to 10 recent sequence ids, and allow any sequence id that is not in the window and
342    * greater than the minimum element in the window.
343    * @param sequenceId to insert into array of stored ids
344    */
345   function tryInsertSequenceId(uint sequenceId) private onlySigner {
346     // Keep a pointer to the lowest value element in the window
347     uint lowestValueIndex = 0;
348     for (uint i = 0; i < SEQUENCE_ID_WINDOW_SIZE; i++) {
349       if (recentSequenceIds[i] == sequenceId) {
350         // This sequence ID has been used before. Disallow!
351         revert();
352       }
353       if (recentSequenceIds[i] < recentSequenceIds[lowestValueIndex]) {
354         lowestValueIndex = i;
355       }
356     }
357     if (sequenceId < recentSequenceIds[lowestValueIndex]) {
358       // The sequence ID being used is lower than the lowest value in the window
359       // so we cannot accept it as it may have been used before
360       revert();
361     }
362     if (sequenceId > (recentSequenceIds[lowestValueIndex] + 10000)) {
363       // Block sequence IDs which are much higher than the lowest value
364       // This prevents people blocking the contract by using very large sequence IDs quickly
365       revert();
366     }
367     recentSequenceIds[lowestValueIndex] = sequenceId;
368   }
369 
370   /**
371    * Gets the next available sequence ID for signing when using executeAndConfirm
372    * returns the sequenceId one higher than the highest currently stored
373    */
374   function getNextSequenceId() public view returns (uint) {
375     uint highestSequenceId = 0;
376     for (uint i = 0; i < SEQUENCE_ID_WINDOW_SIZE; i++) {
377       if (recentSequenceIds[i] > highestSequenceId) {
378         highestSequenceId = recentSequenceIds[i];
379       }
380     }
381     return highestSequenceId + 1;
382   }
383 }