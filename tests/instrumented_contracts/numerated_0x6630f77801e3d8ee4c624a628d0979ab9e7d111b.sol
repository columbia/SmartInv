1 pragma solidity ^0.4.14;
2 
3 /**
4  * Contract that exposes the needed erc20 token functions
5  */
6 
7 contract ERC20Interface {
8   // Send _value amount of tokens to address _to
9   function transfer(address _to, uint256 _value) returns (bool success);
10   // Get the account balance of another account with address _owner
11   function balanceOf(address _owner) constant returns (uint256 balance);
12 }
13 
14 /**
15  * Contract that will forward any incoming Ether to its creator
16  */
17 contract Forwarder {
18   // Address to which any funds sent to this contract will be forwarded
19   address public parentAddress;
20   event ForwarderDeposited(address from, uint value, bytes data);
21 
22   event TokensFlushed(
23     address tokenContractAddress, // The contract address of the token
24     uint value // Amount of token sent
25   );
26 
27   /**
28    * Create the contract, and set the destination address to that of the creator
29    */
30   function Forwarder() {
31     parentAddress = msg.sender;
32   }
33 
34   /**
35    * Modifier that will execute internal code block only if the sender is a parent of the forwarder contract
36    */
37   modifier onlyParent {
38     if (msg.sender != parentAddress) {
39       throw;
40     }
41     _;
42   }
43 
44   /**
45    * Default function; Gets called when Ether is deposited, and forwards it to the destination address
46    */
47   function() payable {
48     if (!parentAddress.call.value(msg.value)(msg.data))
49       throw;
50     // Fire off the deposited event if we can forward it  
51     ForwarderDeposited(msg.sender, msg.value, msg.data);
52   }
53 
54   /**
55    * Execute a token transfer of the full balance from the forwarder token to the main wallet contract
56    * @param tokenContractAddress the address of the erc20 token contract
57    */
58   function flushTokens(address tokenContractAddress) onlyParent {
59     ERC20Interface instance = ERC20Interface(tokenContractAddress);
60     var forwarderAddress = address(this);
61     var forwarderBalance = instance.balanceOf(forwarderAddress);
62     if (forwarderBalance == 0) {
63       return;
64     }
65     if (!instance.transfer(parentAddress, forwarderBalance)) {
66       throw;
67     }
68     TokensFlushed(tokenContractAddress, forwarderBalance);
69   }
70 
71   /**
72    * It is possible that funds were sent to this address before the contract was deployed.
73    * We can flush those funds to the destination address.
74    */
75   function flush() {
76     if (!parentAddress.call.value(this.balance)())
77       throw;
78   }
79 }
80 
81 /**
82  * Basic multi-signer wallet designed for use in a co-signing environment where 2 signatures are required to move funds.
83  * Typically used in a 2-of-3 signing configuration. Uses ecrecover to allow for 2 signatures in a single transaction.
84  */
85 contract WalletSimple {
86   // Events
87   event Deposited(address from, uint value, bytes data);
88   event SafeModeActivated(address msgSender);
89   event Transacted(
90     address msgSender, // Address of the sender of the message initiating the transaction
91     address otherSigner, // Address of the signer (second signature) used to initiate the transaction
92     bytes32 operation, // Operation hash (sha3 of toAddress, value, data, expireTime, sequenceId)
93     address toAddress, // The address the transaction was sent to
94     uint value, // Amount of Wei sent to the address
95     bytes data // Data sent when invoking the transaction
96   );
97   event TokenTransacted(
98     address msgSender, // Address of the sender of the message initiating the transaction
99     address otherSigner, // Address of the signer (second signature) used to initiate the transaction
100     bytes32 operation, // Operation hash (sha3 of toAddress, value, tokenContractAddress, expireTime, sequenceId)
101     address toAddress, // The address the transaction was sent to
102     uint value, // Amount of token sent
103     address tokenContractAddress // The contract address of the token
104   );
105 
106   // Public fields
107   address[] public signers; // The addresses that can co-sign transactions on the wallet
108   bool public safeMode = false; // When active, wallet may only send to signer addresses
109 
110   // Internal fields
111   uint constant SEQUENCE_ID_WINDOW_SIZE = 10;
112   uint[10] recentSequenceIds;
113 
114   /**
115    * Modifier that will execute internal code block only if the sender is an authorized signer on this wallet
116    */
117   modifier onlysigner {
118     if (!isSigner(msg.sender)) {
119       throw;
120     }
121     _;
122   }
123 
124   /**
125    * Set up a simple multi-sig wallet by specifying the signers allowed to be used on this wallet.
126    * 2 signers will be required to send a transaction from this wallet.
127    * Note: The sender is NOT automatically added to the list of signers.
128    * Signers CANNOT be changed once they are set
129    *
130    * @param allowedSigners An array of signers on the wallet
131    */
132   function WalletSimple(address[] allowedSigners) {
133     if (allowedSigners.length != 3) {
134       // Invalid number of signers
135       throw;
136     }
137     signers = allowedSigners;
138   }
139   
140     function init(address[] allowedSigners) {
141     if (allowedSigners.length != 3) {
142       // Invalid number of signers
143       throw;
144     }
145     signers = allowedSigners;
146   }
147 
148   /**
149    * Gets called when a transaction is received without calling a method
150    */
151   function() payable {
152     if (msg.value > 0) {
153       // Fire deposited event if we are receiving funds
154       Deposited(msg.sender, msg.value, msg.data);
155     }
156   }
157 
158   /**
159    * Create a new contract (and also address) that forwards funds to this contract
160    * returns address of newly created forwarder address
161    */
162   function createForwarder() onlysigner returns (address) {
163     return new Forwarder();
164   }
165 
166   /**
167    * Execute a multi-signature transaction from this wallet using 2 signers: one from msg.sender and the other from ecrecover.
168    * The signature is a signed form (using eth.sign) of tightly packed toAddress, value, data, expireTime and sequenceId
169    * Sequence IDs are numbers starting from 1. They are used to prevent replay attacks and may not be repeated.
170    *
171    * @param toAddress the destination address to send an outgoing transaction
172    * @param value the amount in Wei to be sent
173    * @param data the data to send to the toAddress when invoking the transaction
174    * @param expireTime the number of seconds since 1970 for which this transaction is valid
175    * @param sequenceId the unique sequence id obtainable from getNextSequenceId
176    * @param signature the result of eth.sign on the operationHash sha3(toAddress, value, data, expireTime, sequenceId)
177    */
178   function sendMultiSig(address toAddress, uint value, bytes data, uint expireTime, uint sequenceId, bytes signature) onlysigner {
179     // Verify the other signer
180     var operationHash = sha3("ETHER", toAddress, value, data, expireTime, sequenceId);
181     
182     var otherSigner = verifyMultiSig(toAddress, operationHash, signature, expireTime, sequenceId);
183 
184     // Success, send the transaction
185     if (!(toAddress.call.value(value)(data))) {
186       // Failed executing transaction
187       throw;
188     }
189     Transacted(msg.sender, otherSigner, operationHash, toAddress, value, data);
190   }
191   
192   /**
193    * Execute a multi-signature token transfer from this wallet using 2 signers: one from msg.sender and the other from ecrecover.
194    * The signature is a signed form (using eth.sign) of tightly packed toAddress, value, tokenContractAddress, expireTime and sequenceId
195    * Sequence IDs are numbers starting from 1. They are used to prevent replay attacks and may not be repeated.
196    *
197    * @param toAddress the destination address to send an outgoing transaction
198    * @param value the amount in tokens to be sent
199    * @param tokenContractAddress the address of the erc20 token contract
200    * @param expireTime the number of seconds since 1970 for which this transaction is valid
201    * @param sequenceId the unique sequence id obtainable from getNextSequenceId
202    * @param signature the result of eth.sign on the operationHash sha3(toAddress, value, tokenContractAddress, expireTime, sequenceId)
203    */
204   function sendMultiSigToken(address toAddress, uint value, address tokenContractAddress, uint expireTime, uint sequenceId, bytes signature) onlysigner {
205     // Verify the other signer
206     var operationHash = sha3("ERC20", toAddress, value, tokenContractAddress, expireTime, sequenceId);
207     
208     var otherSigner = verifyMultiSig(toAddress, operationHash, signature, expireTime, sequenceId);
209     
210     ERC20Interface instance = ERC20Interface(tokenContractAddress);
211     if (!instance.transfer(toAddress, value)) {
212         throw;
213     }
214     TokenTransacted(msg.sender, otherSigner, operationHash, toAddress, value, tokenContractAddress);
215   }
216 
217   /**
218    * Execute a token flush from one of the forwarder addresses. This transfer needs only a single signature and can be done by any signer
219    *
220    * @param forwarderAddress the address of the forwarder address to flush the tokens from
221    * @param tokenContractAddress the address of the erc20 token contract
222    */
223   function flushForwarderTokens(address forwarderAddress, address tokenContractAddress) onlysigner {    
224     Forwarder forwarder = Forwarder(forwarderAddress);
225     forwarder.flushTokens(tokenContractAddress);
226   }  
227   
228   /**
229    * Do common multisig verification for both eth sends and erc20token transfers
230    *
231    * @param toAddress the destination address to send an outgoing transaction
232    * @param operationHash the sha3 of the toAddress, value, data/tokenContractAddress and expireTime
233    * @param signature the tightly packed signature of r, s, and v as an array of 65 bytes (returned by eth.sign)
234    * @param expireTime the number of seconds since 1970 for which this transaction is valid
235    * @param sequenceId the unique sequence id obtainable from getNextSequenceId
236    * returns address of the address to send tokens or eth to
237    */
238   function verifyMultiSig(address toAddress, bytes32 operationHash, bytes signature, uint expireTime, uint sequenceId) private returns (address) {
239 
240     var otherSigner = recoverAddressFromSignature(operationHash, signature);
241 
242     // Verify if we are in safe mode. In safe mode, the wallet can only send to signers
243     if (safeMode && !isSigner(toAddress)) {
244       // We are in safe mode and the toAddress is not a signer. Disallow!
245       throw;
246     }
247     // Verify that the transaction has not expired
248     if (expireTime < block.timestamp) {
249       // Transaction expired
250       throw;
251     }
252 
253     // Try to insert the sequence ID. Will throw if the sequence id was invalid
254     tryInsertSequenceId(sequenceId);
255 
256     if (!isSigner(otherSigner)) {
257       // Other signer not on this wallet or operation does not match arguments
258       throw;
259     }
260     if (otherSigner == msg.sender) {
261       // Cannot approve own transaction
262       throw;
263     }
264 
265     return otherSigner;
266   }
267 
268   /**
269    * Irrevocably puts contract into safe mode. When in this mode, transactions may only be sent to signing addresses.
270    */
271   function activateSafeMode() onlysigner {
272     safeMode = true;
273     SafeModeActivated(msg.sender);
274   }
275 
276   /**
277    * Determine if an address is a signer on this wallet
278    * @param signer address to check
279    * returns boolean indicating whether address is signer or not
280    */
281   function isSigner(address signer) returns (bool) {
282     // Iterate through all signers on the wallet and
283     for (uint i = 0; i < signers.length; i++) {
284       if (signers[i] == signer) {
285         return true;
286       }
287     }
288     return false;
289   }
290 
291   /**
292    * Gets the second signer's address using ecrecover
293    * @param operationHash the sha3 of the toAddress, value, data/tokenContractAddress and expireTime
294    * @param signature the tightly packed signature of r, s, and v as an array of 65 bytes (returned by eth.sign)
295    * returns address recovered from the signature
296    */
297   function recoverAddressFromSignature(bytes32 operationHash, bytes signature) private returns (address) {
298     if (signature.length != 65) {
299       throw;
300     }
301     // We need to unpack the signature, which is given as an array of 65 bytes (from eth.sign)
302     bytes32 r;
303     bytes32 s;
304     uint8 v;
305     assembly {
306       r := mload(add(signature, 32))
307       s := mload(add(signature, 64))
308       v := and(mload(add(signature, 65)), 255)
309     }
310     if (v < 27) {
311       v += 27; // Ethereum versions are 27 or 28 as opposed to 0 or 1 which is submitted by some signing libs
312     }
313     return ecrecover(operationHash, v, r, s);
314   }
315 
316   /**
317    * Verify that the sequence id has not been used before and inserts it. Throws if the sequence ID was not accepted.
318    * We collect a window of up to 10 recent sequence ids, and allow any sequence id that is not in the window and
319    * greater than the minimum element in the window.
320    * @param sequenceId to insert into array of stored ids
321    */
322   function tryInsertSequenceId(uint sequenceId) onlysigner private {
323     // Keep a pointer to the lowest value element in the window
324     uint lowestValueIndex = 0;
325     for (uint i = 0; i < SEQUENCE_ID_WINDOW_SIZE; i++) {
326       if (recentSequenceIds[i] == sequenceId) {
327         // This sequence ID has been used before. Disallow!
328         throw;
329       }
330       if (recentSequenceIds[i] < recentSequenceIds[lowestValueIndex]) {
331         lowestValueIndex = i;
332       }
333     }
334     if (sequenceId < recentSequenceIds[lowestValueIndex]) {
335       // The sequence ID being used is lower than the lowest value in the window
336       // so we cannot accept it as it may have been used before
337       throw;
338     }
339     if (sequenceId > (recentSequenceIds[lowestValueIndex] + 10000)) {
340       // Block sequence IDs which are much higher than the lowest value
341       // This prevents people blocking the contract by using very large sequence IDs quickly
342       throw;
343     }
344     recentSequenceIds[lowestValueIndex] = sequenceId;
345   }
346 
347   /**
348    * Gets the next available sequence ID for signing when using executeAndConfirm
349    * returns the sequenceId one higher than the highest currently stored
350    */
351   function getNextSequenceId() returns (uint) {
352     uint highestSequenceId = 0;
353     for (uint i = 0; i < SEQUENCE_ID_WINDOW_SIZE; i++) {
354       if (recentSequenceIds[i] > highestSequenceId) {
355         highestSequenceId = recentSequenceIds[i];
356       }
357     }
358     return highestSequenceId + 1;
359   }
360 }