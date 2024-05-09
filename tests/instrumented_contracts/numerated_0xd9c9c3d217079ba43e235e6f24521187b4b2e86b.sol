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
225         return true;
226     }
227 
228 
229 
230     /**
231      * @dev Withdraw original tokens, burn proxy tokens 1:1
232      *
233      *
234      *
235      * @param amount of tokens to withdraw
236      */
237     function unmutateTokens( uint amount) public returns (bool)
238     {
239         address from = msg.sender;
240         require( amount >= 0 );
241 
242         balances[from] = balances[from].sub(amount);
243         _totalSupply = _totalSupply.sub(amount);
244 
245         require( ERC20Interface( masterToken ).transfer( from, amount) );
246 
247         return true;
248     }
249 
250 
251 
252    //standard ERC20 method
253     function totalSupply() public view returns (uint) {
254         return _totalSupply;
255     }
256 
257    //standard ERC20 method
258      function balanceOf(address tokenOwner) public view returns (uint balance) {
259         return balances[tokenOwner];
260     }
261 
262      //standard ERC20 method
263     function getAllowance(address owner, address spender) public view returns (uint)
264     {
265       return allowance[owner][spender];
266     }
267 
268    //standard ERC20 method
269   function approve(address spender,   uint tokens) public returns (bool success) {
270       allowance[msg.sender][spender] = tokens;
271       emit Approval(msg.sender, spender, tokens);
272       return true;
273   }
274 
275 
276   //standard ERC20 method
277    function transfer(address to,  uint tokens) public returns (bool success) {
278         balances[msg.sender] = balances[msg.sender].sub(tokens);
279         balances[to] = balances[to].add(tokens);
280         emit Transfer(msg.sender, to, tokens);
281         return true;
282     }
283 
284 
285    //standard ERC20 method
286    function transferFrom( address from, address to,  uint tokens) public returns (bool success) {
287        balances[from] = balances[from].sub(tokens);
288        allowance[from][to] = allowance[from][to].sub(tokens);
289        balances[to] = balances[to].add(tokens);
290        emit Transfer( from, to, tokens);
291        return true;
292    }
293 
294   //internal method for transferring tokens to the relayer reward as incentive for submitting the packet
295    function _giveRelayerReward( address from, address to, uint tokens) internal returns (bool success){
296      balances[from] = balances[from].sub(tokens);
297      balances[to] = balances[to].add(tokens);
298      emit Transfer( from, to, tokens);
299      return true;
300    }
301 
302 
303     /*
304         Read-only method that returns the EIP712 message structure to be signed for a lava packet.
305     */
306 
307    function getLavaTypedDataHash(string memory methodName, address relayAuthority,address from,address to, address wallet,uint256 tokens,uint256 relayerRewardTokens,uint256 expires,uint256 nonce) public  pure returns (bytes32) {
308 
309 
310           // Note: we need to use `encodePacked` here instead of `encode`.
311           bytes32 digest = keccak256(abi.encodePacked(
312               "\x19\x01",
313             //  DOMAIN_SEPARATOR,
314               getLavaPacketHash(methodName,relayAuthority,from,to,wallet,tokens,relayerRewardTokens,expires,nonce)
315           ));
316           return digest;
317       }
318 
319 
320 
321     /*
322         The internal method for processing the internal data structure of an offchain lava packet with signature.
323     */
324 
325    function _tokenApprovalWithSignature(  string memory methodName, address relayAuthority,address from,address to, address wallet,uint256 tokens,uint256 relayerRewardTokens,uint256 expires,uint256 nonce, bytes32 sigHash, bytes memory signature) internal returns (bool success)
326    {
327 
328        /*
329         Always allow relaying a packet if the specified relayAuthority is 0.
330         If the authority address is not a contract, allow it to relay
331         If the authority address is a contract, allow its defined 'getAuthority()' delegate to relay
332 
333        */
334 
335 
336        require( relayAuthority == address(0x0)
337          || (!addressContainsContract(relayAuthority) && msg.sender == relayAuthority)
338          || (addressContainsContract(relayAuthority) && msg.sender == RelayAuthorityInterface(relayAuthority).getRelayAuthority())  );
339 
340 
341 
342        address recoveredSignatureSigner = recover(sigHash,signature);
343 
344 
345        //make sure the signer is the depositor of the tokens
346        require(from == recoveredSignatureSigner);
347 
348        //make sure this is the correct 'wallet' for this packet
349        require(address(this) == wallet);
350 
351        //make sure the signature has not expired
352        require(block.number < expires);
353 
354        uint previousBurnedSignatureValue = burnedSignatures[sigHash];
355        burnedSignatures[sigHash] = 0x1; //spent
356        require(previousBurnedSignatureValue == 0x0);
357 
358        //relayer reward tokens, has nothing to do with allowance
359        require(_giveRelayerReward(from, msg.sender,   relayerRewardTokens));
360 
361        //approve transfer of tokens
362        allowance[from][to] = tokens;
363        emit Approval(from,  to, tokens);
364 
365 
366        return true;
367    }
368 
369 
370 
371    function approveTokensWithSignature(string memory methodName, address relayAuthority,address from,address to, address wallet,uint256 tokens,uint256 relayerRewardTokens,uint256 expires,uint256 nonce, bytes memory signature) public returns (bool success)
372    {
373        require(bytesEqual('approve',bytes(methodName)));
374 
375        bytes32 sigHash = getLavaTypedDataHash(methodName,relayAuthority,from,to,wallet,tokens,relayerRewardTokens,expires,nonce);
376 
377        require(_tokenApprovalWithSignature(methodName,relayAuthority,from,to,wallet,tokens,relayerRewardTokens,expires,nonce,sigHash,signature));
378 
379 
380        return true;
381    }
382 
383 
384   function transferTokensWithSignature(string memory methodName, address relayAuthority,address from,address to, address wallet,uint256 tokens,uint256 relayerRewardTokens,uint256 expires,uint256 nonce, bytes memory signature) public returns (bool success)
385   {
386 
387       require(bytesEqual('transfer',bytes(methodName)));
388 
389       //check to make sure that signature == ecrecover signature
390       bytes32 sigHash = getLavaTypedDataHash(methodName,relayAuthority,from,to,wallet,tokens,relayerRewardTokens,expires,nonce);
391 
392       require(_tokenApprovalWithSignature(methodName,relayAuthority,from,to,wallet,tokens,relayerRewardTokens,expires,nonce,sigHash,signature));
393 
394       //it can be requested that fewer tokens be sent that were approved -- the whole approval will be invalidated though
395       require(transferFrom( from, to,  tokens));
396 
397 
398       return true;
399 
400   }
401 
402 
403      /*
404       Approve LAVA tokens for a smart contract and call the contracts receiveApproval method in a single packet transaction.
405 
406       Uses the methodName as the 'bytes' for the fallback function to the remote contract
407 
408       */
409      function approveAndCallWithSignature( string memory methodName, address relayAuthority,address from,address to, address wallet,uint256 tokens,uint256 relayerRewardTokens,uint256 expires,uint256 nonce, bytes memory signature ) public returns (bool success)   {
410 
411           require(!bytesEqual('approve',bytes(methodName))  && !bytesEqual('transfer',bytes(methodName)));
412 
413            //check to make sure that signature == ecrecover signature
414           bytes32 sigHash = getLavaTypedDataHash(methodName,relayAuthority,from,to,wallet,tokens,relayerRewardTokens,expires,nonce);
415 
416           require(_tokenApprovalWithSignature(methodName,relayAuthority,from,to,wallet,tokens,relayerRewardTokens,expires,nonce,sigHash,signature));
417 
418           _sendApproveAndCall(from,to,tokens,bytes(methodName));
419 
420            return true;
421      }
422 
423      function _sendApproveAndCall(address from, address to, uint tokens, bytes memory methodName) internal
424      {
425          ApproveAndCallFallBack(to).receiveApproval(from, tokens, address(this), bytes(methodName));
426      }
427 
428 
429 
430 
431     /*
432       Burn the signature of an off-chain transaction packet so that it cannot be used on-chain.
433       Only the creator of the packet can call this method as msg.sender.
434     */
435 
436      function burnSignature( string memory methodName, address relayAuthority,address from,address to, address wallet,uint256 tokens,uint256 relayerRewardTokens,uint256 expires,uint256 nonce,  bytes memory signature) public returns (bool success)
437      {
438 
439 
440         bytes32 sigHash = getLavaTypedDataHash(methodName,relayAuthority,from,to,wallet,tokens,relayerRewardTokens,expires,nonce);
441 
442          address recoveredSignatureSigner = recover(sigHash,signature);
443 
444          //make sure the invalidator is the signer
445          require(recoveredSignatureSigner == from);
446 
447          //only the original packet owner can burn signature, not a relay
448          require(from == msg.sender);
449 
450          //make sure this signature has never been used
451          uint burnedSignature = burnedSignatures[sigHash];
452          burnedSignatures[sigHash] = 0x2; //invalidated
453          require(burnedSignature == 0x0);
454 
455          return true;
456      }
457 
458 
459     /*
460       Check the burn status of the SHA3 hash of a packet signature.
461       Signatures are burned whenever they are used for a transaction or whenever the burnSignature() method is called.
462     */
463      function signatureHashBurnStatus(bytes32 digest) public view returns (uint)
464      {
465        return (burnedSignatures[digest]);
466      }
467 
468 
469 
470 
471        /*
472          Receive approval from ApproveAndCall() to mutate tokens.
473 
474          This method allows 0xBTC to be mutated into LAVA using a single method call.
475        */
476      function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public returns (bool success) {
477 
478         require(token == masterToken);
479 
480         require(mutateTokens(from, tokens));
481 
482         return true;
483 
484      }
485 
486 
487 
488 
489      function addressContainsContract(address _to) view internal returns (bool)
490      {
491        uint codeLength;
492 
493         assembly {
494             // Retrieve the size of the code on target address, this needs assembly .
495             codeLength := extcodesize(_to)
496         }
497 
498          return (codeLength>0);
499      }
500 
501 
502      function bytesEqual(bytes memory b1,bytes memory b2) pure internal returns (bool)
503         {
504           if(b1.length != b2.length) return false;
505 
506           for (uint i=0; i<b1.length; i++) {
507             if(b1[i] != b2[i]) return false;
508           }
509 
510           return true;
511         }
512 
513 
514 
515 
516 }