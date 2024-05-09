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
172    bytes32 constant LAVAPACKET_TYPEHASH = keccak256(
173       "LavaPacket(string methodName,address relayAuthority,address from,address to,address wallet,uint256 tokens,uint256 relayerRewardTokens,uint256 expires,uint256 nonce)"
174   );
175 
176    function getLavaPacketTypehash() public pure returns (bytes32) {
177       return LAVAPACKET_TYPEHASH;
178   }
179 
180  function getLavaPacketHash(string memory methodName, address relayAuthority,address from,address to, address wallet,uint256 tokens,uint256 relayerRewardTokens,uint256 expires,uint256 nonce) public pure returns (bytes32) {
181         return keccak256(abi.encode(
182             LAVAPACKET_TYPEHASH,
183             keccak256(bytes(methodName)),
184             relayAuthority,
185             from,
186             to,
187             wallet,
188             tokens,
189             relayerRewardTokens,
190             expires,
191             nonce
192         ));
193     }
194 
195 
196     constructor() public {
197 
198     }
199 
200     /**
201     * Do not allow ETH to enter
202     */
203      function() external payable
204      {
205          revert();
206      }
207 
208 
209     /**
210      * @dev Deposit original tokens, receive proxy tokens 1:1
211      * This method requires token approval.
212      *
213      * @param amount of tokens to deposit
214      */
215     function mutateTokens(address from, uint amount) public returns (bool)
216     {
217 
218         require( amount >= 0 );
219 
220         require( ERC20Interface( masterToken ).transferFrom( from, address(this), amount) );
221 
222         balances[from] = balances[from].add(amount);
223         _totalSupply = _totalSupply.add(amount);
224         
225         emit Transfer(address(0), from, amount);
226 
227         return true;
228     }
229 
230 
231 
232     /**
233      * @dev Withdraw original tokens, burn proxy tokens 1:1
234      *
235      *
236      *
237      * @param amount of tokens to withdraw
238      */
239     function unmutateTokens( uint amount) public returns (bool)
240     {
241         address from = msg.sender;
242         require( amount >= 0 );              
243         
244         balances[from] = balances[from].sub(amount);
245         _totalSupply = _totalSupply.sub(amount);
246         
247         emit Transfer(from, address(0), amount);
248 
249         require( ERC20Interface( masterToken ).transfer( from, amount) );
250 
251         return true;
252     }
253 
254 
255 
256    //standard ERC20 method
257     function totalSupply() public view returns (uint) {
258         return _totalSupply;
259     }
260 
261    //standard ERC20 method
262      function balanceOf(address tokenOwner) public view returns (uint balance) {
263         return balances[tokenOwner];
264     }
265 
266      //standard ERC20 method
267     function getAllowance(address owner, address spender) public view returns (uint)
268     {
269       return allowance[owner][spender];
270     }
271 
272    //standard ERC20 method
273   function approve(address spender,   uint tokens) public returns (bool success) {
274       allowance[msg.sender][spender] = tokens;
275       emit Approval(msg.sender, spender, tokens);
276       return true;
277   }
278 
279 
280   //standard ERC20 method
281    function transfer(address to,  uint tokens) public returns (bool success) {
282         balances[msg.sender] = balances[msg.sender].sub(tokens);
283         balances[to] = balances[to].add(tokens);
284         emit Transfer(msg.sender, to, tokens);
285         return true;
286     }
287 
288 
289    //standard ERC20 method
290    function transferFrom( address from, address to,  uint tokens) public returns (bool success) {
291        balances[from] = balances[from].sub(tokens);
292        allowance[from][to] = allowance[from][to].sub(tokens);
293        balances[to] = balances[to].add(tokens);
294        emit Transfer( from, to, tokens);
295        return true;
296    }
297 
298   //internal method for transferring tokens to the relayer reward as incentive for submitting the packet
299    function _giveRelayerReward( address from, address to, uint tokens) internal returns (bool success){
300      balances[from] = balances[from].sub(tokens);
301      balances[to] = balances[to].add(tokens);
302      emit Transfer( from, to, tokens);
303      return true;
304    }
305 
306 
307     /*
308         Read-only method that returns the EIP712 message structure to be signed for a lava packet.
309     */
310 
311    function getLavaTypedDataHash(string memory methodName, address relayAuthority,address from,address to, address wallet,uint256 tokens,uint256 relayerRewardTokens,uint256 expires,uint256 nonce) public  pure returns (bytes32) {
312 
313 
314           // Note: we need to use `encodePacked` here instead of `encode`.
315           bytes32 digest = keccak256(abi.encodePacked(
316               "\x19\x01",
317             //  DOMAIN_SEPARATOR,
318               getLavaPacketHash(methodName,relayAuthority,from,to,wallet,tokens,relayerRewardTokens,expires,nonce)
319           ));
320           return digest;
321       }
322 
323 
324 
325     /*
326         The internal method for processing the internal data structure of an offchain lava packet with signature.
327     */
328 
329    function _tokenApprovalWithSignature(  string memory methodName, address relayAuthority,address from,address to, address wallet,uint256 tokens,uint256 relayerRewardTokens,uint256 expires,uint256 nonce, bytes32 sigHash, bytes memory signature) internal returns (bool success)
330    {
331 
332        /*
333         Always allow relaying a packet if the specified relayAuthority is 0.
334         If the authority address is not a contract, allow it to relay
335         If the authority address is a contract, allow its defined 'getAuthority()' delegate to relay
336 
337        */
338 
339 
340        require( relayAuthority == address(0x0)
341          || (!addressContainsContract(relayAuthority) && msg.sender == relayAuthority)
342          || (addressContainsContract(relayAuthority) && msg.sender == RelayAuthorityInterface(relayAuthority).getRelayAuthority())  );
343 
344 
345 
346        address recoveredSignatureSigner = recover(sigHash,signature);
347 
348 
349        //make sure the signer is the depositor of the tokens
350        require(from == recoveredSignatureSigner);
351 
352        //make sure this is the correct 'wallet' for this packet
353        require(address(this) == wallet);
354 
355        //make sure the signature has not expired
356        require(block.number < expires);
357 
358        uint previousBurnedSignatureValue = burnedSignatures[sigHash];
359        burnedSignatures[sigHash] = 0x1; //spent
360        require(previousBurnedSignatureValue == 0x0);
361 
362        //relayer reward tokens, has nothing to do with allowance
363        require(_giveRelayerReward(from, msg.sender,   relayerRewardTokens));
364 
365        //approve transfer of tokens
366        allowance[from][to] = tokens;
367        emit Approval(from,  to, tokens);
368 
369 
370        return true;
371    }
372 
373 
374 
375    function approveTokensWithSignature(string memory methodName, address relayAuthority,address from,address to, address wallet,uint256 tokens,uint256 relayerRewardTokens,uint256 expires,uint256 nonce, bytes memory signature) public returns (bool success)
376    {
377        require(bytesEqual('approve',bytes(methodName)));
378 
379        bytes32 sigHash = getLavaTypedDataHash(methodName,relayAuthority,from,to,wallet,tokens,relayerRewardTokens,expires,nonce);
380 
381        require(_tokenApprovalWithSignature(methodName,relayAuthority,from,to,wallet,tokens,relayerRewardTokens,expires,nonce,sigHash,signature));
382 
383 
384        return true;
385    }
386 
387 
388   function transferTokensWithSignature(string memory methodName, address relayAuthority,address from,address to, address wallet,uint256 tokens,uint256 relayerRewardTokens,uint256 expires,uint256 nonce, bytes memory signature) public returns (bool success)
389   {
390 
391       require(bytesEqual('transfer',bytes(methodName)));
392 
393       //check to make sure that signature == ecrecover signature
394       bytes32 sigHash = getLavaTypedDataHash(methodName,relayAuthority,from,to,wallet,tokens,relayerRewardTokens,expires,nonce);
395 
396       require(_tokenApprovalWithSignature(methodName,relayAuthority,from,to,wallet,tokens,relayerRewardTokens,expires,nonce,sigHash,signature));
397 
398       //it can be requested that fewer tokens be sent that were approved -- the whole approval will be invalidated though
399       require(transferFrom( from, to,  tokens));
400 
401 
402       return true;
403 
404   }
405 
406 
407      /*
408       Approve LAVA tokens for a smart contract and call the contracts receiveApproval method in a single packet transaction.
409 
410       Uses the methodName as the 'bytes' for the fallback function to the remote contract
411 
412       */
413      function approveAndCallWithSignature( string memory methodName, address relayAuthority,address from,address to, address wallet,uint256 tokens,uint256 relayerRewardTokens,uint256 expires,uint256 nonce, bytes memory signature ) public returns (bool success)   {
414 
415           require(!bytesEqual('approve',bytes(methodName))  && !bytesEqual('transfer',bytes(methodName)));
416 
417            //check to make sure that signature == ecrecover signature
418           bytes32 sigHash = getLavaTypedDataHash(methodName,relayAuthority,from,to,wallet,tokens,relayerRewardTokens,expires,nonce);
419 
420           require(_tokenApprovalWithSignature(methodName,relayAuthority,from,to,wallet,tokens,relayerRewardTokens,expires,nonce,sigHash,signature));
421 
422           _sendApproveAndCall(from,to,tokens,bytes(methodName));
423 
424            return true;
425      }
426 
427      function _sendApproveAndCall(address from, address to, uint tokens, bytes memory methodName) internal
428      {
429          ApproveAndCallFallBack(to).receiveApproval(from, tokens, address(this), bytes(methodName));
430      }
431 
432 
433 
434 
435     /*
436       Burn the signature of an off-chain transaction packet so that it cannot be used on-chain.
437       Only the creator of the packet can call this method as msg.sender.
438     */
439 
440      function burnSignature( string memory methodName, address relayAuthority,address from,address to, address wallet,uint256 tokens,uint256 relayerRewardTokens,uint256 expires,uint256 nonce,  bytes memory signature) public returns (bool success)
441      {
442 
443 
444         bytes32 sigHash = getLavaTypedDataHash(methodName,relayAuthority,from,to,wallet,tokens,relayerRewardTokens,expires,nonce);
445 
446          address recoveredSignatureSigner = recover(sigHash,signature);
447 
448          //make sure the invalidator is the signer
449          require(recoveredSignatureSigner == from);
450 
451          //only the original packet owner can burn signature, not a relay
452          require(from == msg.sender);
453 
454          //make sure this signature has never been used
455          uint burnedSignature = burnedSignatures[sigHash];
456          burnedSignatures[sigHash] = 0x2; //invalidated
457          require(burnedSignature == 0x0);
458 
459          return true;
460      }
461 
462 
463     /*
464       Check the burn status of the SHA3 hash of a packet signature.
465       Signatures are burned whenever they are used for a transaction or whenever the burnSignature() method is called.
466     */
467      function signatureHashBurnStatus(bytes32 digest) public view returns (uint)
468      {
469        return (burnedSignatures[digest]);
470      }
471 
472 
473 
474 
475        /*
476          Receive approval from ApproveAndCall() to mutate tokens.
477 
478          This method allows 0xBTC to be mutated into LAVA using a single method call.
479        */
480      function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public returns (bool success) {
481 
482         require(token == masterToken);
483 
484         require(mutateTokens(from, tokens));
485 
486         return true;
487 
488      }
489 
490 
491 
492 
493      function addressContainsContract(address _to) view internal returns (bool)
494      {
495        uint codeLength;
496 
497         assembly {
498             // Retrieve the size of the code on target address, this needs assembly .
499             codeLength := extcodesize(_to)
500         }
501 
502          return (codeLength>0);
503      }
504 
505 
506      function bytesEqual(bytes memory b1,bytes memory b2) pure internal returns (bool)
507         {
508           if(b1.length != b2.length) return false;
509 
510           for (uint i=0; i<b1.length; i++) {
511             if(b1[i] != b2[i]) return false;
512           }
513 
514           return true;
515         }
516 
517 
518 
519 
520 }