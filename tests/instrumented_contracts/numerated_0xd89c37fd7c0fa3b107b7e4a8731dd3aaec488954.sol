1 pragma solidity ^0.5.0;
2 
3 
4 
5 /**------------------------------------
6 
7 LAVA Token  (0xBTC Token Proxy with Lava Enabled)
8 
9 0xBTC proxy token contract.  ApproveAndCall() 0xBTC to this contract to receive LAVA tokens. Alternatively, Approve() 0xBTC to this contract and then call the mutateTokens() method. Do not directly transfer 0xBTC to this contract using Transfer() or TransferFrom().
10 
11 LAVA tokens can be spent not just by your account, but by any account as long as they have a lava packet signature, signed by your private key, which validates that specific transaction.
12 
13 A relayer reward can be specified in a signed packet.  This means that LAVA can be sent by paying an incentive fee of LAVA to relayers for the gas, not ETH.
14 
15 LAVA is 1:1 pegged to 0xBTC.
16 
17 
18 This contract implements EIP712 for Signing Typed Data:
19 https://github.com/MetaMask/eth-sig-util
20 
21 ------------------------------------*/
22 
23 
24 /**
25  * @title SafeMath
26  * @dev Math operations with safety checks that throw on error
27  */
28 library SafeMath {
29 
30   /**
31   * @dev Multiplies two numbers, throws on overflow.
32   */
33   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34     if (a == 0) {
35       return 0;
36     }
37     uint256 c = a * b;
38     assert(c / a == b);
39     return c;
40   }
41 
42   /**
43   * @dev Integer division of two numbers, truncating the quotient.
44   */
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     uint256 c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49     return c;
50   }
51 
52   /**
53   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
54   */
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   /**
61   * @dev Adds two numbers, throws on overflow.
62   */
63   function add(uint256 a, uint256 b) internal pure returns (uint256) {
64     uint256 c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 }
69 
70 
71 contract ECRecovery {
72 
73   /**
74    * @dev Recover signer address from a message by using their signature
75    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
76    * @param sig bytes signature, the signature is generated using web3.eth.sign()
77    */
78   function recover(bytes32 hash, bytes memory sig) internal  pure returns (address) {
79     bytes32 r;
80     bytes32 s;
81     uint8 v;
82 
83     //Check the signature length
84     if (sig.length != 65) {
85       return (address(0));
86     }
87 
88     // Divide the signature in r, s and v variables
89     assembly {
90       r := mload(add(sig, 32))
91       s := mload(add(sig, 64))
92       v := byte(0, mload(add(sig, 96)))
93     }
94 
95     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
96     if (v < 27) {
97       v += 27;
98     }
99 
100     // If the version is correct return the signer address
101     if (v != 27 && v != 28) {
102       return (address(0));
103     } else {
104       return ecrecover(hash, v, r, s);
105     }
106   }
107 
108 }
109 
110 
111 
112 contract RelayAuthorityInterface {
113     function getRelayAuthority() public returns (address);
114 }
115 
116 
117 contract ERC20Interface {
118     function totalSupply() public view returns (uint);
119     function balanceOf(address tokenOwner) public view returns (uint balance);
120     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
121     function transfer(address to, uint tokens) public returns (bool success);
122     function approve(address spender, uint tokens) public returns (bool success);
123     function transferFrom(address from, address to, uint tokens) public returns (bool success);
124 
125     event Transfer(address indexed from, address indexed to, uint tokens);
126     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
127 }
128 
129 
130 contract ApproveAndCallFallBack {
131     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
132 }
133 
134 
135 contract LavaToken is ECRecovery{
136 
137     using SafeMath for uint;
138 
139     address constant public masterToken = 0xB6eD7644C69416d67B522e20bC294A9a9B405B31;
140 
141     string public name     = "Lava";
142     string public symbol   = "LAVA";
143     uint8  public decimals = 8;
144     uint private _totalSupply;
145 
146     event  Approval(address indexed src, address indexed ext, uint amt);
147     event  Transfer(address indexed src, address indexed dst, uint amt);
148     event  Deposit(address indexed dst, uint amt);
149     event  Withdrawal(address indexed src, uint amt);
150 
151     mapping (address => uint)                       public  balances;
152     mapping (address => mapping (address => uint))  public  allowance;
153 
154     mapping (bytes32 => uint256)                    public burnedSignatures;
155 
156 
157   struct LavaPacket {
158     string methodName; //approve, transfer, or a custom data byte32 for ApproveAndCall()
159     address relayAuthority; //either a contract or an account
160     address from; //the packet origin and signer
161     address to; //the recipient of tokens
162     address wallet;  //this contract address
163     uint256 tokens; //the amount of tokens to give to the recipient
164     uint256 relayerRewardTokens; //the amount of tokens to give to msg.sender
165     uint256 expires; //the eth block number this packet expires at
166     uint256 nonce; //a random number to ensure that packet hashes are always unique (optional)
167   }
168 
169 
170 
171 
172 
173 
174   bytes32 constant EIP712DOMAIN_TYPEHASH = keccak256(
175         "EIP712Domain(string contractName,string version,uint256 chainId,address verifyingContract)"
176     );
177 
178  function getLavaDomainTypehash() public pure returns (bytes32) {
179     return EIP712DOMAIN_TYPEHASH;
180  }
181 
182   function getEIP712DomainHash(string memory contractName, string memory version, uint256 chainId, address verifyingContract) public pure returns (bytes32) {
183 
184     return keccak256(abi.encode(
185           EIP712DOMAIN_TYPEHASH,
186           keccak256(bytes(contractName)),
187           keccak256(bytes(version)),
188           chainId,
189           verifyingContract
190       ));
191   }
192 
193   bytes32 constant LAVAPACKET_TYPEHASH = keccak256(
194      "LavaPacket(string methodName,address relayAuthority,address from,address to,address wallet,uint256 tokens,uint256 relayerRewardTokens,uint256 expires,uint256 nonce)"
195  );
196 
197   function getLavaPacketTypehash() public pure returns (bytes32) {
198      return LAVAPACKET_TYPEHASH;
199  }
200 
201 
202 
203  function getLavaPacketHash(string memory methodName, address relayAuthority,address from,address to, address wallet,uint256 tokens,uint256 relayerRewardTokens,uint256 expires,uint256 nonce) public pure returns (bytes32) {
204         return keccak256(abi.encode(
205             LAVAPACKET_TYPEHASH,
206             keccak256(bytes(methodName)),
207             relayAuthority,
208             from,
209             to,
210             wallet,
211             tokens,
212             relayerRewardTokens,
213             expires,
214             nonce
215         ));
216     }
217 
218 
219     constructor() public {
220 
221     }
222 
223     /**
224     * Do not allow ETH to enter
225     */
226      function() external payable
227      {
228          revert();
229      }
230 
231 
232     /**
233      * @dev Deposit original tokens, receive proxy tokens 1:1
234      * This method requires token approval.
235      *
236      * @param amount of tokens to deposit
237      */
238     function mutateTokens(address from, uint amount) public returns (bool)
239     {
240 
241         require( amount >= 0 );
242 
243         require( ERC20Interface( masterToken ).transferFrom( from, address(this), amount) );
244 
245         balances[from] = balances[from].add(amount);
246         _totalSupply = _totalSupply.add(amount);
247 
248         emit Transfer(address(this), from, amount);
249 
250         return true;
251     }
252 
253 
254 
255     /**
256      * @dev Withdraw original tokens, burn proxy tokens 1:1
257      *
258      *
259      *
260      * @param amount of tokens to withdraw
261      */
262     function unmutateTokens( uint amount) public returns (bool)
263     {
264         address from = msg.sender;
265         require( amount >= 0 );
266 
267         balances[from] = balances[from].sub(amount);
268         _totalSupply = _totalSupply.sub(amount);
269 
270         emit Transfer(from, address(this), amount);
271 
272         require( ERC20Interface( masterToken ).transfer( from, amount) );
273 
274         return true;
275     }
276 
277 
278 
279    //standard ERC20 method
280     function totalSupply() public view returns (uint) {
281         return _totalSupply;
282     }
283 
284    //standard ERC20 method
285      function balanceOf(address tokenOwner) public view returns (uint balance) {
286         return balances[tokenOwner];
287     }
288 
289      //standard ERC20 method
290     function getAllowance(address owner, address spender) public view returns (uint)
291     {
292       return allowance[owner][spender];
293     }
294 
295    //standard ERC20 method
296   function approve(address spender,   uint tokens) public returns (bool success) {
297       allowance[msg.sender][spender] = tokens;
298       emit Approval(msg.sender, spender, tokens);
299       return true;
300   }
301 
302 
303   //standard ERC20 method
304    function transfer(address to,  uint tokens) public returns (bool success) {
305         balances[msg.sender] = balances[msg.sender].sub(tokens);
306         balances[to] = balances[to].add(tokens);
307         emit Transfer(msg.sender, to, tokens);
308         return true;
309     }
310 
311 
312    //standard ERC20 method
313    function transferFrom( address from, address to,  uint tokens) public returns (bool success) {
314        balances[from] = balances[from].sub(tokens);
315        allowance[from][to] = allowance[from][to].sub(tokens);
316        balances[to] = balances[to].add(tokens);
317        emit Transfer( from, to, tokens);
318        return true;
319    }
320 
321   //internal method for transferring tokens to the relayer reward as incentive for submitting the packet
322    function _giveRelayerReward( address from, address to, uint tokens) internal returns (bool success){
323      balances[from] = balances[from].sub(tokens);
324      balances[to] = balances[to].add(tokens);
325      emit Transfer( from, to, tokens);
326      return true;
327    }
328 
329 
330     /*
331         Read-only method that returns the EIP712 message structure to be signed for a lava packet.
332     */
333 
334    function getLavaTypedDataHash(string memory methodName, address relayAuthority,address from,address to, address wallet,uint256 tokens,uint256 relayerRewardTokens,uint256 expires,uint256 nonce) public view returns (bytes32) {
335 
336 
337           // Note: we need to use `encodePacked` here instead of `encode`.
338           bytes32 digest = keccak256(abi.encodePacked(
339               "\x19\x01",
340               getEIP712DomainHash('Lava Wallet','1',1,address(this)),
341               getLavaPacketHash(methodName,relayAuthority,from,to,wallet,tokens,relayerRewardTokens,expires,nonce)
342           ));
343           return digest;
344       }
345 
346 
347 
348     /*
349         The internal method for processing the internal data structure of an offchain lava packet with signature.
350     */
351 
352    function _tokenApprovalWithSignature(  string memory methodName, address relayAuthority,address from,address to, address wallet,uint256 tokens,uint256 relayerRewardTokens,uint256 expires,uint256 nonce, bytes32 sigHash, bytes memory signature) internal returns (bool success)
353    {
354 
355        /*
356         Always allow relaying a packet if the specified relayAuthority is 0.
357         If the authority address is not a contract, allow it to relay
358         If the authority address is a contract, allow its defined 'getAuthority()' delegate to relay
359 
360        */
361 
362 
363        require( relayAuthority == address(0x0)
364          || (!addressContainsContract(relayAuthority) && msg.sender == relayAuthority)
365          || (addressContainsContract(relayAuthority) && msg.sender == RelayAuthorityInterface(relayAuthority).getRelayAuthority())  );
366 
367 
368 
369        address recoveredSignatureSigner = recover(sigHash,signature);
370 
371 
372        //make sure the signer is the depositor of the tokens
373        require(from == recoveredSignatureSigner);
374 
375        //make sure this is the correct 'wallet' for this packet
376        require(address(this) == wallet);
377 
378        //make sure the signature has not expired
379        require(block.number < expires);
380 
381        uint previousBurnedSignatureValue = burnedSignatures[sigHash];
382        burnedSignatures[sigHash] = 0x1; //spent
383        require(previousBurnedSignatureValue == 0x0);
384 
385        //relayer reward tokens, has nothing to do with allowance
386        require(_giveRelayerReward(from, msg.sender,   relayerRewardTokens));
387 
388        //approve transfer of tokens
389        allowance[from][to] = tokens;
390        emit Approval(from,  to, tokens);
391 
392 
393        return true;
394    }
395 
396 
397 
398    function approveTokensWithSignature(string memory methodName, address relayAuthority,address from,address to, address wallet,uint256 tokens,uint256 relayerRewardTokens,uint256 expires,uint256 nonce, bytes memory signature) public returns (bool success)
399    {
400        require(bytesEqual('approve',bytes(methodName)));
401 
402        bytes32 sigHash = getLavaTypedDataHash(methodName,relayAuthority,from,to,wallet,tokens,relayerRewardTokens,expires,nonce);
403 
404        require(_tokenApprovalWithSignature(methodName,relayAuthority,from,to,wallet,tokens,relayerRewardTokens,expires,nonce,sigHash,signature));
405 
406 
407        return true;
408    }
409 
410 
411   function transferTokensWithSignature(string memory methodName, address relayAuthority,address from,address to, address wallet,uint256 tokens,uint256 relayerRewardTokens,uint256 expires,uint256 nonce, bytes memory signature) public returns (bool success)
412   {
413 
414       require(bytesEqual('transfer',bytes(methodName)));
415 
416       //check to make sure that signature == ecrecover signature
417       bytes32 sigHash = getLavaTypedDataHash(methodName,relayAuthority,from,to,wallet,tokens,relayerRewardTokens,expires,nonce);
418 
419       require(_tokenApprovalWithSignature(methodName,relayAuthority,from,to,wallet,tokens,relayerRewardTokens,expires,nonce,sigHash,signature));
420 
421       //it can be requested that fewer tokens be sent that were approved -- the whole approval will be invalidated though
422       require(transferFrom( from, to,  tokens));
423 
424 
425       return true;
426 
427   }
428 
429 
430      /*
431       Approve LAVA tokens for a smart contract and call the contracts receiveApproval method in a single packet transaction.
432 
433       Uses the methodName as the 'bytes' for the fallback function to the remote contract
434 
435       */
436      function approveAndCallWithSignature( string memory methodName, address relayAuthority,address from,address to, address wallet,uint256 tokens,uint256 relayerRewardTokens,uint256 expires,uint256 nonce, bytes memory signature ) public returns (bool success)   {
437 
438           require(!bytesEqual('approve',bytes(methodName))  && !bytesEqual('transfer',bytes(methodName)));
439 
440            //check to make sure that signature == ecrecover signature
441           bytes32 sigHash = getLavaTypedDataHash(methodName,relayAuthority,from,to,wallet,tokens,relayerRewardTokens,expires,nonce);
442 
443           require(_tokenApprovalWithSignature(methodName,relayAuthority,from,to,wallet,tokens,relayerRewardTokens,expires,nonce,sigHash,signature));
444 
445           _sendApproveAndCall(from,to,tokens,bytes(methodName));
446 
447            return true;
448      }
449 
450      function _sendApproveAndCall(address from, address to, uint tokens, bytes memory methodName) internal
451      {
452          ApproveAndCallFallBack(to).receiveApproval(from, tokens, address(this), bytes(methodName));
453      }
454 
455 
456 
457 
458     /*
459       Burn the signature of an off-chain transaction packet so that it cannot be used on-chain.
460       Only the creator of the packet can call this method as msg.sender.
461     */
462 
463      function burnSignature( string memory methodName, address relayAuthority,address from,address to, address wallet,uint256 tokens,uint256 relayerRewardTokens,uint256 expires,uint256 nonce,  bytes memory signature) public returns (bool success)
464      {
465 
466 
467         bytes32 sigHash = getLavaTypedDataHash(methodName,relayAuthority,from,to,wallet,tokens,relayerRewardTokens,expires,nonce);
468 
469          address recoveredSignatureSigner = recover(sigHash,signature);
470 
471          //make sure the invalidator is the signer
472          require(recoveredSignatureSigner == from);
473 
474          //only the original packet owner can burn signature, not a relay
475          require(from == msg.sender);
476 
477          //make sure this signature has never been used
478          uint burnedSignature = burnedSignatures[sigHash];
479          burnedSignatures[sigHash] = 0x2; //invalidated
480          require(burnedSignature == 0x0);
481 
482          return true;
483      }
484 
485 
486     /*
487       Check the burn status of the SHA3 hash of a packet signature.
488       Signatures are burned whenever they are used for a transaction or whenever the burnSignature() method is called.
489     */
490      function signatureHashBurnStatus(bytes32 digest) public view returns (uint)
491      {
492        return (burnedSignatures[digest]);
493      }
494 
495 
496 
497 
498        /*
499          Receive approval from ApproveAndCall() to mutate tokens.
500 
501          This method allows 0xBTC to be mutated into LAVA using a single method call.
502        */
503      function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public returns (bool success) {
504 
505         require(token == masterToken);
506 
507         require(mutateTokens(from, tokens));
508 
509         return true;
510 
511      }
512 
513 
514 
515 
516      function addressContainsContract(address _to) view internal returns (bool)
517      {
518        uint codeLength;
519 
520         assembly {
521             // Retrieve the size of the code on target address, this needs assembly .
522             codeLength := extcodesize(_to)
523         }
524 
525          return (codeLength>0);
526      }
527 
528 
529      function bytesEqual(bytes memory b1,bytes memory b2) pure internal returns (bool)
530         {
531           if(b1.length != b2.length) return false;
532 
533           for (uint i=0; i<b1.length; i++) {
534             if(b1[i] != b2[i]) return false;
535           }
536 
537           return true;
538         }
539 
540 
541 
542 
543 }