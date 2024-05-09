1 pragma solidity ^0.4.18;
2 
3  
4 
5 
6 /*
7 
8 This is a token wallet contract
9 
10 Store your tokens in this contract to give them super powers
11 
12 Tokens can be spent from the contract with only an ecSignature from the owner - onchain approve is not needed
13 
14 
15 */
16 
17 
18 library ECRecovery {
19 
20   /**
21    * @dev Recover signer address from a message by using their signature
22    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
23    * @param sig bytes signature, the signature is generated using web3.eth.sign()
24    */
25   function recover(bytes32 hash, bytes sig) public pure returns (address) {
26     bytes32 r;
27     bytes32 s;
28     uint8 v;
29 
30     //Check the signature length
31     if (sig.length != 65) {
32       return (address(0));
33     }
34 
35     // Divide the signature in r, s and v variables
36     assembly {
37       r := mload(add(sig, 32))
38       s := mload(add(sig, 64))
39       v := byte(0, mload(add(sig, 96)))
40     }
41 
42     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
43     if (v < 27) {
44       v += 27;
45     }
46 
47     // If the version is correct return the signer address
48     if (v != 27 && v != 28) {
49       return (address(0));
50     } else {
51       return ecrecover(hash, v, r, s);
52     }
53   }
54 
55 }
56 
57 
58 
59 /**
60  * @title SafeMath
61  * @dev Math operations with safety checks that throw on error
62  */
63 library SafeMath {
64 
65   /**
66   * @dev Multiplies two numbers, throws on overflow.
67   */
68   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69     if (a == 0) {
70       return 0;
71     }
72     uint256 c = a * b;
73     assert(c / a == b);
74     return c;
75   }
76 
77   /**
78   * @dev Integer division of two numbers, truncating the quotient.
79   */
80   function div(uint256 a, uint256 b) internal pure returns (uint256) {
81     // assert(b > 0); // Solidity automatically throws when dividing by 0
82     uint256 c = a / b;
83     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
84     return c;
85   }
86 
87   /**
88   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
89   */
90   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91     assert(b <= a);
92     return a - b;
93   }
94 
95   /**
96   * @dev Adds two numbers, throws on overflow.
97   */
98   function add(uint256 a, uint256 b) internal pure returns (uint256) {
99     uint256 c = a + b;
100     assert(c >= a);
101     return c;
102   }
103 }
104 
105 
106 contract ERC20Interface {
107     function totalSupply() public constant returns (uint);
108     function balanceOf(address tokenOwner) public constant returns (uint balance);
109     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
110     function transfer(address to, uint tokens) public returns (bool success);
111     function approve(address spender, uint tokens) public returns (bool success);
112     function transferFrom(address from, address to, uint tokens) public returns (bool success);
113 
114     event Transfer(address indexed from, address indexed to, uint tokens);
115     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
116 }
117 
118 
119 
120 contract ApproveAndCallFallBack {
121 
122     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
123 
124 }
125 
126 
127 
128 contract Owned {
129 
130     address public owner;
131 
132     address public newOwner;
133 
134 
135     event OwnershipTransferred(address indexed _from, address indexed _to);
136 
137 
138     function Owned() public {
139 
140         owner = msg.sender;
141 
142     }
143 
144 
145     modifier onlyOwner {
146 
147         require(msg.sender == owner);
148 
149         _;
150 
151     }
152 
153 
154     function transferOwnership(address _newOwner) public onlyOwner {
155 
156         newOwner = _newOwner;
157 
158     }
159 
160     function acceptOwnership() public {
161 
162         require(msg.sender == newOwner);
163 
164         OwnershipTransferred(owner, newOwner);
165 
166         owner = newOwner;
167 
168         newOwner = address(0);
169 
170     }
171 
172 }
173 
174 
175 
176 
177 
178 contract LavaWallet is Owned {
179 
180 
181   using SafeMath for uint;
182 
183   // balances[tokenContractAddress][EthereumAccountAddress] = 0
184    mapping(address => mapping (address => uint256)) balances;
185 
186    //token => owner => spender : amount
187    mapping(address => mapping (address => mapping (address => uint256))) allowed;
188 
189    mapping(address => uint256) depositedTokens;
190 
191    mapping(bytes32 => uint256) burnedSignatures;
192 
193 
194   event Deposit(address token, address user, uint amount, uint balance);
195   event Withdraw(address token, address user, uint amount, uint balance);
196   event Transfer(address indexed from, address indexed to,address token, uint tokens);
197   event Approval(address indexed tokenOwner, address indexed spender,address token, uint tokens);
198 
199   function LavaWallet() public  {
200 
201   }
202 
203 
204   //do not allow ether to enter
205   function() public payable {
206       revert();
207   }
208 
209 
210    //Remember you need pre-approval for this - nice with ApproveAndCall
211   function depositTokens(address from, address token, uint256 tokens ) public returns (bool success)
212   {
213       //we already have approval so lets do a transferFrom - transfer the tokens into this contract
214 
215       if(!ERC20Interface(token).transferFrom(from, this, tokens)) revert();
216 
217 
218       balances[token][from] = balances[token][from].add(tokens);
219       depositedTokens[token] = depositedTokens[token].add(tokens);
220 
221       Deposit(token, from, tokens, balances[token][from]);
222 
223       return true;
224   }
225 
226  
227 
228   //No approve needed, only from msg.sender
229   function withdrawTokens(address token, uint256 tokens) public returns (bool success){
230     balances[token][msg.sender] = balances[token][msg.sender].sub(tokens);
231     depositedTokens[token] = depositedTokens[token].sub(tokens);
232 
233     if(!ERC20Interface(token).transfer(msg.sender, tokens)) revert();
234 
235 
236      Withdraw(token, msg.sender, tokens, balances[token][msg.sender]);
237      return true;
238   }
239 
240   //Requires approval so it can be public
241   function withdrawTokensFrom( address from, address to,address token,  uint tokens) public returns (bool success) {
242       balances[token][from] = balances[token][from].sub(tokens);
243       depositedTokens[token] = depositedTokens[token].sub(tokens);
244       allowed[token][from][to] = allowed[token][from][to].sub(tokens);
245 
246       if(!ERC20Interface(token).transfer(to, tokens)) revert();
247 
248 
249       Withdraw(token, from, tokens, balances[token][from]);
250       return true;
251   }
252 
253 
254   function balanceOf(address token,address user) public constant returns (uint) {
255        return balances[token][user];
256    }
257 
258 
259 
260   //Can also be used to remove approval by using a 'tokens' value of 0
261   function approveTokens(address spender, address token, uint tokens) public returns (bool success) {
262       allowed[token][msg.sender][spender] = tokens;
263       Approval(msg.sender, token, spender, tokens);
264       return true;
265   }
266 
267   ///transfer tokens within the lava balances
268   //No approve needed, only from msg.sender
269    function transferTokens(address to, address token, uint tokens) public returns (bool success) {
270         balances[token][msg.sender] = balances[token][msg.sender].sub(tokens);
271         balances[token][to] = balances[token][to].add(tokens);
272         Transfer(msg.sender, token, to, tokens);
273         return true;
274     }
275 
276 
277     ///transfer tokens within the lava balances
278     //Can be public because it requires approval
279    function transferTokensFrom( address from, address to,address token,  uint tokens) public returns (bool success) {
280        balances[token][from] = balances[token][from].sub(tokens);
281        allowed[token][from][to] = allowed[token][from][to].sub(tokens);
282        balances[token][to] = balances[token][to].add(tokens);
283        Transfer(token, from, to, tokens);
284        return true;
285    }
286 
287    //Nonce is the same thing as a 'check number'
288    //EIP 712
289    function getLavaTypedDataHash(bytes methodname, address from, address to, address token, uint256 tokens, uint256 relayerReward,
290                                      uint256 expires, uint256 nonce) public constant returns (bytes32)
291    {
292          bytes32 hardcodedSchemaHash = 0x8fd4f9177556bbc74d0710c8bdda543afd18cc84d92d64b5620d5f1881dceb37; //with methodname
293 
294 
295         bytes32 typedDataHash = sha3(
296             hardcodedSchemaHash,
297             sha3(methodname,from,to,this,token,tokens,relayerReward,expires,nonce)
298           );
299 
300         return typedDataHash;
301    }
302 
303 
304    function tokenApprovalWithSignature(address from, address to, address token, uint256 tokens, uint256 relayerReward,
305                                      uint256 expires, bytes32 sigHash, bytes signature) internal returns (bool success)
306    {
307 
308        address recoveredSignatureSigner = ECRecovery.recover(sigHash,signature);
309 
310        //make sure the signer is the depositor of the tokens
311        if(from != recoveredSignatureSigner) revert();
312 
313        //make sure the signature has not expired
314        if(block.number > expires) revert();
315 
316        uint burnedSignature = burnedSignatures[sigHash];
317        burnedSignatures[sigHash] = 0x1; //spent
318        if(burnedSignature != 0x0 ) revert();
319 
320        //approve the relayer reward
321        allowed[token][from][msg.sender] = relayerReward;
322        Approval(from, token, msg.sender, relayerReward);
323 
324        //transferRelayerReward
325        if(!transferTokensFrom(from, msg.sender, token, relayerReward)) revert();
326 
327        //approve transfer of tokens
328        allowed[token][from][to] = tokens;
329        Approval(from, token, to, tokens);
330 
331 
332        return true;
333    }
334 
335    function approveTokensWithSignature(address from, address to, address token, uint256 tokens, uint256 relayerReward,
336                                      uint256 expires, uint256 nonce, bytes signature) public returns (bool success)
337    {
338 
339 
340        bytes32 sigHash = getLavaTypedDataHash('approve',from,to,token,tokens,relayerReward,expires,nonce);
341 
342        if(!tokenApprovalWithSignature(from,to,token,tokens,relayerReward,expires,sigHash,signature)) revert();
343 
344 
345        return true;
346    }
347 
348    //the tokens remain in lava wallet
349   function transferTokensFromWithSignature(address from, address to,  address token, uint256 tokens,  uint256 relayerReward,
350                                     uint256 expires, uint256 nonce, bytes signature) public returns (bool success)
351   {
352 
353 
354       //check to make sure that signature == ecrecover signature
355 
356       bytes32 sigHash = getLavaTypedDataHash('transfer',from,to,token,tokens,relayerReward,expires,nonce);
357 
358       if(!tokenApprovalWithSignature(from,to,token,tokens,relayerReward,expires,sigHash,signature)) revert();
359 
360       //it can be requested that fewer tokens be sent that were approved -- the whole approval will be invalidated though
361       if(!transferTokensFrom( from, to, token, tokens)) revert();
362 
363 
364       return true;
365 
366   }
367 
368    //The tokens are withdrawn from the lava wallet and transferred into the To account
369   function withdrawTokensFromWithSignature(address from, address to,  address token, uint256 tokens,  uint256 relayerReward,
370                                     uint256 expires, uint256 nonce, bytes signature) public returns (bool success)
371   {
372 
373       //check to make sure that signature == ecrecover signature
374 
375       bytes32 sigHash = getLavaTypedDataHash('withdraw',from,to,token,tokens,relayerReward,expires,nonce);
376 
377       if(!tokenApprovalWithSignature(from,to,token,tokens,relayerReward,expires,sigHash,signature)) revert();
378 
379       //it can be requested that fewer tokens be sent that were approved -- the whole approval will be invalidated though
380       if(!withdrawTokensFrom( from, to, token, tokens)) revert();
381 
382 
383       return true;
384 
385   }
386 
387 
388 
389 
390     function tokenAllowance(address token, address tokenOwner, address spender) public constant returns (uint remaining) {
391 
392         return allowed[token][tokenOwner][spender];
393 
394     }
395 
396 
397 
398      function burnSignature(bytes methodname, address from, address to, address token, uint256 tokens, uint256 relayerReward, uint256 expires, uint256 nonce,  bytes signature) public returns (bool success)
399      {
400 
401         bytes32 sigHash = getLavaTypedDataHash(methodname,from,to,token,tokens,relayerReward,expires,nonce);
402 
403 
404          address recoveredSignatureSigner = ECRecovery.recover(sigHash,signature);
405 
406          //make sure the invalidator is the signer
407          if(recoveredSignatureSigner != from) revert();
408 
409          //only the original packet owner can burn signature, not a relay
410          if(from != msg.sender) revert();
411 
412          //make sure this signature has never been used
413          uint burnedSignature = burnedSignatures[sigHash];
414          burnedSignatures[sigHash] = 0x2; //invalidated
415          if(burnedSignature != 0x0 ) revert();
416 
417          return true;
418      }
419 
420 
421      //2 is burned
422      //1 is redeemed
423      function signatureBurnStatus(bytes32 digest) public view returns (uint)
424      {
425        return (burnedSignatures[digest]);
426      }
427 
428 
429 
430 
431        /*
432          Receive approval to spend tokens and perform any action all in one transaction
433        */
434      function receiveApproval(address from, uint256 tokens, address token, bytes data) public returns (bool success) {
435 
436 
437        return depositTokens(from, token, tokens );
438 
439      }
440 
441      /*
442       Approve lava tokens for a smart contract and call the contracts receiveApproval method all in one fell swoop
443 
444       One issue: the data is not being signed and so it could be manipulated
445       */
446      function approveAndCall(bytes methodname, address from, address to, address token, uint256 tokens, uint256 relayerReward,
447                                        uint256 expires, uint256 nonce, bytes signature ) public returns (bool success) {
448 
449 
450 
451             bytes32 sigHash = getLavaTypedDataHash(methodname,from,to,token,tokens,relayerReward,expires,nonce);
452 
453 
454 
455           if(!tokenApprovalWithSignature(from,to,token,tokens,relayerReward,expires,sigHash,signature)) revert();
456 
457           ApproveAndCallFallBack(to).receiveApproval(from, tokens, token, methodname);
458 
459          return true;
460 
461      }
462 
463 
464 
465  // ------------------------------------------------------------------------
466 
467  // Owner can transfer out any accidentally sent ERC20 tokens
468  // Owner CANNOT transfer out tokens which were purposefully deposited
469 
470  // ------------------------------------------------------------------------
471 
472  function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
473 
474     //find actual balance of the contract
475      uint tokenBalance = ERC20Interface(tokenAddress).balanceOf(this);
476 
477      //find number of accidentally deposited tokens (actual - purposefully deposited)
478      uint undepositedTokens = tokenBalance.sub(depositedTokens[tokenAddress]);
479 
480      //only allow withdrawing of accidentally deposited tokens
481      assert(tokens <= undepositedTokens);
482 
483      if(!ERC20Interface(tokenAddress).transfer(owner, tokens)) revert();
484 
485 
486 
487      return true;
488 
489  }
490 
491 
492 
493 
494 }