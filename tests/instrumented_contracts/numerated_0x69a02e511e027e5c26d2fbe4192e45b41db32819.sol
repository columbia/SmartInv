1 pragma solidity ^0.4.18;
2 
3 library ECRecovery {
4 
5   /**
6    * @dev Recover signer address from a message by using their signature
7    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
8    * @param sig bytes signature, the signature is generated using web3.eth.sign()
9    */
10   function recover(bytes32 hash, bytes sig) public pure returns (address) {
11     bytes32 r;
12     bytes32 s;
13     uint8 v;
14 
15     //Check the signature length
16     if (sig.length != 65) {
17       return (address(0));
18     }
19 
20     // Divide the signature in r, s and v variables
21     assembly {
22       r := mload(add(sig, 32))
23       s := mload(add(sig, 64))
24       v := byte(0, mload(add(sig, 96)))
25     }
26 
27     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
28     if (v < 27) {
29       v += 27;
30     }
31 
32     // If the version is correct return the signer address
33     if (v != 27 && v != 28) {
34       return (address(0));
35     } else {
36       return ecrecover(hash, v, r, s);
37     }
38   }
39 
40 }
41 
42  
43 
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   /**
74   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 
92 /*
93 
94 This is a token wallet contract
95 
96 Store your tokens in this contract to give them super powers
97 
98 Tokens can be spent from the contract with only an ecSignature from the owner - onchain approve is not needed
99 
100 
101 */
102 
103 contract ERC20Interface {
104     function totalSupply() public constant returns (uint);
105     function balanceOf(address tokenOwner) public constant returns (uint balance);
106     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
107     function transfer(address to, uint tokens) public returns (bool success);
108     function approve(address spender, uint tokens) public returns (bool success);
109     function transferFrom(address from, address to, uint tokens) public returns (bool success);
110 
111     event Transfer(address indexed from, address indexed to, uint tokens);
112     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
113 }
114 contract ERC918Interface {
115   function totalSupply() public constant returns (uint);
116   function getMiningDifficulty() public constant returns (uint);
117   function getMiningTarget() public constant returns (uint);
118   function getMiningReward() public constant returns (uint);
119   function balanceOf(address tokenOwner) public constant returns (uint balance);
120 
121   function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
122 
123   event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
124 
125 }
126 
127 contract MiningKingInterface {
128     function getKing() public returns (address);
129     function transferKing(address newKing) public;
130 
131     event TransferKing(address from, address to);
132 }
133 
134 contract ApproveAndCallFallBack {
135 
136     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
137 
138 }
139 
140 
141 
142 contract Owned {
143 
144     address public owner;
145 
146     address public newOwner;
147 
148 
149     event OwnershipTransferred(address indexed _from, address indexed _to);
150 
151 
152     function Owned() public {
153 
154         owner = msg.sender;
155 
156     }
157 
158 
159     modifier onlyOwner {
160 
161         require(msg.sender == owner);
162 
163         _;
164 
165     }
166 
167 
168     function transferOwnership(address _newOwner) public onlyOwner {
169 
170         newOwner = _newOwner;
171 
172     }
173 
174     function acceptOwnership() public {
175 
176         require(msg.sender == newOwner);
177 
178         OwnershipTransferred(owner, newOwner);
179 
180         owner = newOwner;
181 
182         newOwner = address(0);
183 
184     }
185 
186 }
187 
188 
189 
190 
191 
192 contract LavaWallet is Owned {
193 
194 
195   using SafeMath for uint;
196 
197   // balances[tokenContractAddress][EthereumAccountAddress] = 0
198    mapping(address => mapping (address => uint256)) balances;
199 
200    //token => owner => spender : amount
201    mapping(address => mapping (address => mapping (address => uint256))) allowed;
202 
203    mapping(address => uint256) depositedTokens;
204 
205    mapping(bytes32 => uint256) burnedSignatures;
206 
207 
208     address public relayKingContract;
209 
210 
211 
212   event Deposit(address token, address user, uint amount, uint balance);
213   event Withdraw(address token, address user, uint amount, uint balance);
214   event Transfer(address indexed from, address indexed to,address token, uint tokens);
215   event Approval(address indexed tokenOwner, address indexed spender,address token, uint tokens);
216 
217   function LavaWallet(address relayKingContractAddress ) public  {
218     relayKingContract = relayKingContractAddress;
219   }
220 
221 
222   //do not allow ether to enter
223   function() public payable {
224       revert();
225   }
226 
227 
228    //Remember you need pre-approval for this - nice with ApproveAndCall
229   function depositTokens(address from, address token, uint256 tokens ) public returns (bool success)
230   {
231       //we already have approval so lets do a transferFrom - transfer the tokens into this contract
232 
233       if(!ERC20Interface(token).transferFrom(from, this, tokens)) revert();
234 
235 
236       balances[token][from] = balances[token][from].add(tokens);
237       depositedTokens[token] = depositedTokens[token].add(tokens);
238 
239       Deposit(token, from, tokens, balances[token][from]);
240 
241       return true;
242   }
243 
244 
245   //No approve needed, only from msg.sender
246   function withdrawTokens(address token, uint256 tokens) public returns (bool success){
247     balances[token][msg.sender] = balances[token][msg.sender].sub(tokens);
248     depositedTokens[token] = depositedTokens[token].sub(tokens);
249 
250     if(!ERC20Interface(token).transfer(msg.sender, tokens)) revert();
251 
252 
253      Withdraw(token, msg.sender, tokens, balances[token][msg.sender]);
254      return true;
255   }
256 
257   //Requires approval so it can be public
258   function withdrawTokensFrom( address from, address to,address token,  uint tokens) public returns (bool success) {
259       balances[token][from] = balances[token][from].sub(tokens);
260       depositedTokens[token] = depositedTokens[token].sub(tokens);
261       allowed[token][from][to] = allowed[token][from][to].sub(tokens);
262 
263       if(!ERC20Interface(token).transfer(to, tokens)) revert();
264 
265 
266       Withdraw(token, from, tokens, balances[token][from]);
267       return true;
268   }
269 
270 
271   function balanceOf(address token,address user) public constant returns (uint) {
272        return balances[token][user];
273    }
274 
275 
276 
277   //Can also be used to remove approval by using a 'tokens' value of 0
278   function approveTokens(address spender, address token, uint tokens) public returns (bool success) {
279       allowed[token][msg.sender][spender] = tokens;
280       Approval(msg.sender, token, spender, tokens);
281       return true;
282   }
283 
284   ///transfer tokens within the lava balances
285   //No approve needed, only from msg.sender
286    function transferTokens(address to, address token, uint tokens) public returns (bool success) {
287         balances[token][msg.sender] = balances[token][msg.sender].sub(tokens);
288         balances[token][to] = balances[token][to].add(tokens);
289         Transfer(msg.sender, token, to, tokens);
290         return true;
291     }
292 
293 
294     ///transfer tokens within the lava balances
295     //Can be public because it requires approval
296    function transferTokensFrom( address from, address to,address token,  uint tokens) public returns (bool success) {
297        balances[token][from] = balances[token][from].sub(tokens);
298        allowed[token][from][to] = allowed[token][from][to].sub(tokens);
299        balances[token][to] = balances[token][to].add(tokens);
300        Transfer(token, from, to, tokens);
301        return true;
302    }
303 
304    //Nonce is the same thing as a 'check number'
305    //EIP 712
306    function getLavaTypedDataHash(bytes methodname, address from, address to, address token, uint256 tokens, uint256 relayerReward,
307                                      uint256 expires, uint256 nonce) public constant returns (bytes32)
308    {
309          bytes32 hardcodedSchemaHash = 0x8fd4f9177556bbc74d0710c8bdda543afd18cc84d92d64b5620d5f1881dceb37; //with methodname
310 
311 
312         bytes32 typedDataHash = sha3(
313             hardcodedSchemaHash,
314             sha3(methodname,from,to,this,token,tokens,relayerReward,expires,nonce)
315           );
316 
317         return typedDataHash;
318    }
319 
320 
321    function tokenApprovalWithSignature(address from, address to, address token, uint256 tokens, uint256 relayerReward,
322                                      uint256 expires, bytes32 sigHash, bytes signature) internal returns (bool success)
323    {
324 
325        address recoveredSignatureSigner = ECRecovery.recover(sigHash,signature);
326 
327        //make sure the signer is the depositor of the tokens
328        require(from == recoveredSignatureSigner);
329 
330        require(msg.sender == getRelayingKing()
331          || msg.sender == from
332          || msg.sender == to);  // you must be the 'king of the hill' to relay
333 
334        //make sure the signature has not expired
335        require(block.number < expires);
336 
337        uint burnedSignature = burnedSignatures[sigHash];
338        burnedSignatures[sigHash] = 0x1; //spent
339        if(burnedSignature != 0x0 ) revert();
340 
341        //approve the relayer reward
342        allowed[token][from][msg.sender] = relayerReward;
343        Approval(from, token, msg.sender, relayerReward);
344 
345        //transferRelayerReward
346        if(!transferTokensFrom(from, msg.sender, token, relayerReward)) revert();
347 
348        //approve transfer of tokens
349        allowed[token][from][to] = tokens;
350        Approval(from, token, to, tokens);
351 
352 
353        return true;
354    }
355 
356    function approveTokensWithSignature(address from, address to, address token, uint256 tokens, uint256 relayerReward,
357                                      uint256 expires, uint256 nonce, bytes signature) public returns (bool success)
358    {
359 
360 
361        bytes32 sigHash = getLavaTypedDataHash('approve',from,to,token,tokens,relayerReward,expires,nonce);
362 
363        if(!tokenApprovalWithSignature(from,to,token,tokens,relayerReward,expires,sigHash,signature)) revert();
364 
365 
366        return true;
367    }
368 
369    //the tokens remain in lava wallet
370   function transferTokensFromWithSignature(address from, address to,  address token, uint256 tokens,  uint256 relayerReward,
371                                     uint256 expires, uint256 nonce, bytes signature) public returns (bool success)
372   {
373 
374 
375       //check to make sure that signature == ecrecover signature
376 
377       bytes32 sigHash = getLavaTypedDataHash('transfer',from,to,token,tokens,relayerReward,expires,nonce);
378 
379       if(!tokenApprovalWithSignature(from,to,token,tokens,relayerReward,expires,sigHash,signature)) revert();
380 
381       //it can be requested that fewer tokens be sent that were approved -- the whole approval will be invalidated though
382       if(!transferTokensFrom( from, to, token, tokens)) revert();
383 
384 
385       return true;
386 
387   }
388 
389    //The tokens are withdrawn from the lava wallet and transferred into the To account
390   function withdrawTokensFromWithSignature(address from, address to,  address token, uint256 tokens,  uint256 relayerReward,
391                                     uint256 expires, uint256 nonce, bytes signature) public returns (bool success)
392   {
393 
394       //check to make sure that signature == ecrecover signature
395 
396       bytes32 sigHash = getLavaTypedDataHash('withdraw',from,to,token,tokens,relayerReward,expires,nonce);
397 
398       if(!tokenApprovalWithSignature(from,to,token,tokens,relayerReward,expires,sigHash,signature)) revert();
399 
400       //it can be requested that fewer tokens be sent that were approved -- the whole approval will be invalidated though
401       if(!withdrawTokensFrom( from, to, token, tokens)) revert();
402 
403 
404       return true;
405 
406   }
407 
408 
409 
410 
411     function tokenAllowance(address token, address tokenOwner, address spender) public constant returns (uint remaining) {
412 
413         return allowed[token][tokenOwner][spender];
414 
415     }
416 
417 
418 
419      function burnSignature(bytes methodname, address from, address to, address token, uint256 tokens, uint256 relayerReward, uint256 expires, uint256 nonce,  bytes signature) public returns (bool success)
420      {
421 
422         bytes32 sigHash = getLavaTypedDataHash(methodname,from,to,token,tokens,relayerReward,expires,nonce);
423 
424 
425          address recoveredSignatureSigner = ECRecovery.recover(sigHash,signature);
426 
427          //make sure the invalidator is the signer
428          if(recoveredSignatureSigner != from) revert();
429 
430          //only the original packet owner can burn signature, not a relay
431          if(from != msg.sender) revert();
432 
433          //make sure this signature has never been used
434          uint burnedSignature = burnedSignatures[sigHash];
435          burnedSignatures[sigHash] = 0x2; //invalidated
436          if(burnedSignature != 0x0 ) revert();
437 
438          return true;
439      }
440 
441 
442      //2 is burned
443      //1 is redeemed
444      function signatureBurnStatus(bytes32 digest) public view returns (uint)
445      {
446        return (burnedSignatures[digest]);
447      }
448 
449 
450 
451 
452        /*
453          Receive approval to spend tokens and perform any action all in one transaction
454        */
455      function receiveApproval(address from, uint256 tokens, address token, bytes data) public returns (bool success) {
456 
457 
458        return depositTokens(from, token, tokens );
459 
460      }
461 
462      /*
463       Approve lava tokens for a smart contract and call the contracts receiveApproval method all in one fell swoop
464 
465       One issue: the data is not being signed and so it could be manipulated
466       */
467      function approveAndCall(bytes methodname, address from, address to, address token, uint256 tokens, uint256 relayerReward,
468                                        uint256 expires, uint256 nonce, bytes signature ) public returns (bool success) {
469 
470 
471 
472             bytes32 sigHash = getLavaTypedDataHash(methodname,from,to,token,tokens,relayerReward,expires,nonce);
473 
474 
475 
476           if(!tokenApprovalWithSignature(from,to,token,tokens,relayerReward,expires,sigHash,signature)) revert();
477 
478           ApproveAndCallFallBack(to).receiveApproval(from, tokens, token, methodname);
479 
480          return true;
481 
482      }
483 
484      function getRelayingKing() public returns (address)
485      {
486        return MiningKingInterface(relayKingContract).getKing();
487      }
488 
489 
490 
491  // ------------------------------------------------------------------------
492 
493  // Owner can transfer out any accidentally sent ERC20 tokens
494  // Owner CANNOT transfer out tokens which were purposefully deposited
495 
496  // ------------------------------------------------------------------------
497 
498  function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
499 
500     //find actual balance of the contract
501      uint tokenBalance = ERC20Interface(tokenAddress).balanceOf(this);
502 
503      //find number of accidentally deposited tokens (actual - purposefully deposited)
504      uint undepositedTokens = tokenBalance.sub(depositedTokens[tokenAddress]);
505 
506      //only allow withdrawing of accidentally deposited tokens
507      assert(tokens <= undepositedTokens);
508 
509      if(!ERC20Interface(tokenAddress).transfer(owner, tokens)) revert();
510 
511 
512 
513      return true;
514 
515  }
516 
517 
518 
519 }