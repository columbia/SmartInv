1 pragma solidity ^0.4.18;
2 
3  
4 
5 /*
6 
7 This is a token wallet contract
8 
9 Store your tokens in this contract to give them super powers
10 
11 Tokens can be spent from the contract with only an ecSignature from the owner - onchain approve is not needed
12 
13 
14 */
15 
16 
17 library ECRecovery {
18 
19   /**
20    * @dev Recover signer address from a message by using their signature
21    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
22    * @param sig bytes signature, the signature is generated using web3.eth.sign()
23    */
24   function recover(bytes32 hash, bytes sig) public pure returns (address) {
25     bytes32 r;
26     bytes32 s;
27     uint8 v;
28 
29     //Check the signature length
30     if (sig.length != 65) {
31       return (address(0));
32     }
33 
34     // Divide the signature in r, s and v variables
35     assembly {
36       r := mload(add(sig, 32))
37       s := mload(add(sig, 64))
38       v := byte(0, mload(add(sig, 96)))
39     }
40 
41     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
42     if (v < 27) {
43       v += 27;
44     }
45 
46     // If the version is correct return the signer address
47     if (v != 27 && v != 28) {
48       return (address(0));
49     } else {
50       return ecrecover(hash, v, r, s);
51     }
52   }
53 
54 }
55 
56 
57 /**
58  * @title SafeMath
59  * @dev Math operations with safety checks that throw on error
60  */
61 library SafeMath {
62 
63   /**
64   * @dev Multiplies two numbers, throws on overflow.
65   */
66   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
67     if (a == 0) {
68       return 0;
69     }
70     uint256 c = a * b;
71     assert(c / a == b);
72     return c;
73   }
74 
75   /**
76   * @dev Integer division of two numbers, truncating the quotient.
77   */
78   function div(uint256 a, uint256 b) internal pure returns (uint256) {
79     // assert(b > 0); // Solidity automatically throws when dividing by 0
80     uint256 c = a / b;
81     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
82     return c;
83   }
84 
85   /**
86   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
87   */
88   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89     assert(b <= a);
90     return a - b;
91   }
92 
93   /**
94   * @dev Adds two numbers, throws on overflow.
95   */
96   function add(uint256 a, uint256 b) internal pure returns (uint256) {
97     uint256 c = a + b;
98     assert(c >= a);
99     return c;
100   }
101 }
102 
103 
104 contract ERC20Interface {
105     function totalSupply() public constant returns (uint);
106     function balanceOf(address tokenOwner) public constant returns (uint balance);
107     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
108     function transfer(address to, uint tokens) public returns (bool success);
109     function approve(address spender, uint tokens) public returns (bool success);
110     function transferFrom(address from, address to, uint tokens) public returns (bool success);
111 
112     event Transfer(address indexed from, address indexed to, uint tokens);
113     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
114 }
115 
116 
117 
118 contract ApproveAndCallFallBack {
119 
120     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
121 
122 }
123 
124 
125 
126 contract Owned {
127 
128     address public owner;
129 
130     address public newOwner;
131 
132 
133     event OwnershipTransferred(address indexed _from, address indexed _to);
134 
135 
136     function Owned() public {
137 
138         owner = msg.sender;
139 
140     }
141 
142 
143     modifier onlyOwner {
144 
145         require(msg.sender == owner);
146 
147         _;
148 
149     }
150 
151 
152     function transferOwnership(address _newOwner) public onlyOwner {
153 
154         newOwner = _newOwner;
155 
156     }
157 
158     function acceptOwnership() public {
159 
160         require(msg.sender == newOwner);
161 
162         OwnershipTransferred(owner, newOwner);
163 
164         owner = newOwner;
165 
166         newOwner = address(0);
167 
168     }
169 
170 }
171 
172 
173 
174 
175 
176 contract LavaWallet is Owned {
177 
178 
179   using SafeMath for uint;
180 
181   // balances[tokenContractAddress][EthereumAccountAddress] = 0
182    mapping(address => mapping (address => uint256)) balances;
183 
184    //token => owner => spender : amount
185    mapping(address => mapping (address => mapping (address => uint256))) allowed;
186 
187    mapping(address => uint256) depositedTokens;
188 
189    mapping(bytes32 => uint256) burnedSignatures;
190 
191 
192   event Deposit(address token, address user, uint amount, uint balance);
193   event Withdraw(address token, address user, uint amount, uint balance);
194   event Transfer(address indexed from, address indexed to,address token, uint tokens);
195   event Approval(address indexed tokenOwner, address indexed spender,address token, uint tokens);
196 
197   function LavaWallet() public  {
198 
199   }
200 
201 
202   //do not allow ether to enter
203   function() public payable {
204       revert();
205   }
206 
207 
208    //Remember you need pre-approval for this - nice with ApproveAndCall
209   function depositTokens(address from, address token, uint256 tokens ) public returns (bool success)
210   {
211       //we already have approval so lets do a transferFrom - transfer the tokens into this contract
212       ERC20Interface(token).transferFrom(from, this, tokens);
213       balances[token][from] = balances[token][from].add(tokens);
214       depositedTokens[token] = depositedTokens[token].add(tokens);
215 
216       Deposit(token, from, tokens, balances[token][from]);
217 
218       return true;
219   }
220 
221 
222   //No approve needed, only from msg.sender
223   function withdrawTokens(address token, uint256 tokens) public {
224     balances[token][msg.sender] = balances[token][msg.sender].sub(tokens);
225     depositedTokens[token] = depositedTokens[token].sub(tokens);
226 
227     ERC20Interface(token).transfer(msg.sender, tokens);
228 
229     Withdraw(token, msg.sender, tokens, balances[token][msg.sender]);
230   }
231 
232   //Requires approval so it can be public
233   function withdrawTokensFrom( address from, address to,address token,  uint tokens) public returns (bool success) {
234       balances[token][from] = balances[token][from].sub(tokens);
235       depositedTokens[token] = depositedTokens[token].sub(tokens);
236       allowed[token][from][to] = allowed[token][from][to].sub(tokens);
237 
238       ERC20Interface(token).transfer(to, tokens);
239 
240       Withdraw(token, from, tokens, balances[token][from]);
241       return true;
242   }
243 
244 
245   function balanceOf(address token,address user) public constant returns (uint) {
246        return balances[token][user];
247    }
248 
249 
250 
251   //Can also be used to remove approval by using a 'tokens' value of 0
252   function approveTokens(address spender, address token, uint tokens) public returns (bool success) {
253       allowed[token][msg.sender][spender] = tokens;
254       Approval(msg.sender, token, spender, tokens);
255       return true;
256   }
257 
258 
259   //No approve needed, only from msg.sender
260    function transferTokens(address to, address token, uint tokens) public returns (bool success) {
261         balances[token][msg.sender] = balances[token][msg.sender].sub(tokens);
262         balances[token][to] = balances[token][to].add(tokens);
263         Transfer(msg.sender, token, to, tokens);
264         return true;
265     }
266 
267 
268     //Can be public because it requires approval
269    function transferTokensFrom( address from, address to,address token,  uint tokens) public returns (bool success) {
270        balances[token][from] = balances[token][from].sub(tokens);
271        allowed[token][from][to] = allowed[token][from][to].sub(tokens);
272        balances[token][to] = balances[token][to].add(tokens);
273        Transfer(token, from, to, tokens);
274        return true;
275    }
276 
277    //Nonce is the same thing as a 'check number'
278    //EIP 712
279    function getLavaTypedDataHash( address from, address to, address token, uint256 tokens, uint256 relayerReward,
280                                      uint256 expires, uint256 nonce) public constant returns (bytes32)
281    {
282         bytes32 hardcodedSchemaHash = 0x313236b6cd8d12125421e44528d8f5ba070a781aeac3e5ae45e314b818734ec3 ;
283 
284         bytes32 typedDataHash = sha3(
285             hardcodedSchemaHash,
286             sha3(from,to,this,token,tokens,relayerReward,expires,nonce)
287           );
288 
289         return typedDataHash;
290    }
291 
292 
293 
294    function approveTokensWithSignature(address from, address to, address token, uint256 tokens, uint256 relayerReward,
295                                      uint256 expires, uint256 nonce, bytes signature) public returns (bool success)
296    {
297        //bytes32 sigHash = sha3("\x19Ethereum Signed Message:\n32",this, from, to, token, tokens, relayerReward, expires, nonce);
298 
299        bytes32 sigHash = getLavaTypedDataHash(from,to,token,tokens,relayerReward,expires,nonce);
300 
301        address recoveredSignatureSigner = ECRecovery.recover(sigHash,signature);
302 
303        //make sure the signer is the depositor of the tokens
304        if(from != recoveredSignatureSigner) revert();
305 
306        //make sure the signature has not expired
307        if(block.number > expires) revert();
308 
309        uint burnedSignature = burnedSignatures[sigHash];
310        burnedSignatures[sigHash] = 0x1; //spent
311        if(burnedSignature != 0x0 ) revert();
312 
313        //approve the relayer reward
314        allowed[token][from][msg.sender] = relayerReward;
315        Approval(from, token, msg.sender, relayerReward);
316 
317        //transferRelayerReward
318        if(!transferTokensFrom(from, msg.sender, token, relayerReward)) revert();
319 
320        //approve transfer of tokens
321        allowed[token][from][to] = tokens;
322        Approval(from, token, to, tokens);
323 
324 
325        return true;
326    }
327 
328    //The tokens are withdrawn from the lava wallet and transferred into the To account
329   function withdrawTokensFromWithSignature(address from, address to,  address token, uint256 tokens,  uint256 relayerReward,
330                                     uint256 expires, uint256 nonce, bytes signature) public returns (bool success)
331   {
332       //check to make sure that signature == ecrecover signature
333 
334       if(!approveTokensWithSignature(from,to,token,tokens,relayerReward,expires,nonce,signature)) revert();
335 
336       //it can be requested that fewer tokens be sent that were approved -- the whole approval will be invalidated though
337       if(!withdrawTokensFrom( from, to, token, tokens)) revert();
338 
339 
340       return true;
341 
342   }
343 
344    //the tokens remain in lava wallet
345   function transferTokensFromWithSignature(address from, address to,  address token, uint256 tokens,  uint256 relayerReward,
346                                     uint256 expires, uint256 nonce, bytes signature) public returns (bool success)
347   {
348       //check to make sure that signature == ecrecover signature
349 
350       if(!approveTokensWithSignature(from,to,token,tokens,relayerReward,expires,nonce,signature)) revert();
351 
352       //it can be requested that fewer tokens be sent that were approved -- the whole approval will be invalidated though
353       if(!transferTokensFrom( from, to, token, tokens)) revert();
354 
355 
356       return true;
357 
358   }
359 
360 
361     function tokenAllowance(address token, address tokenOwner, address spender) public constant returns (uint remaining) {
362 
363         return allowed[token][tokenOwner][spender];
364 
365     }
366 
367 
368 
369      function burnSignature(address from, address to, address token, uint256 tokens, uint256 relayerReward, uint256 expires, uint256 nonce,  bytes signature) public returns (bool success)
370      {
371 
372        bytes32 sigHash = getLavaTypedDataHash(from,to,token,tokens,relayerReward,expires,nonce);
373 
374 
375          address recoveredSignatureSigner = ECRecovery.recover(sigHash,signature);
376 
377          //make sure the invalidator is the signer
378          if(recoveredSignatureSigner != from) revert();
379 
380 
381          //make sure this signature has never been used
382          uint burnedSignature = burnedSignatures[sigHash];
383          burnedSignatures[sigHash] = 0x2; //invalidated
384          if(burnedSignature != 0x0 ) revert();
385 
386          return true;
387      }
388 
389 
390      //2 is burned
391      //1 is redeemed
392      function signatureBurnStatus(bytes32 digest) public view returns (uint)
393      {
394        return (burnedSignatures[digest]);
395      }
396 
397 
398 
399 
400        /*
401          Receive approval to spend tokens and perform any action all in one transaction
402        */
403      function receiveApproval(address from, uint256 tokens, address token, bytes data) public returns (bool success) {
404 
405 
406        return depositTokens(from, token, tokens );
407 
408      }
409 
410      /*
411       Approve lava tokens for a smart contract and call the contracts receiveApproval method all in one fell swoop
412       */
413      function approveAndCall(address from, address to, address token, uint256 tokens, uint256 relayerReward,
414                                        uint256 expires, uint256 nonce, bytes signature,  bytes data) public returns (bool success) {
415 
416          if(!approveTokensWithSignature(from,to,token,tokens,relayerReward,expires,nonce,signature)) revert();
417 
418          ApproveAndCallFallBack(to).receiveApproval(from, tokens, token, data);
419 
420          return true;
421 
422      }
423 
424 
425 
426  // ------------------------------------------------------------------------
427 
428  // Owner can transfer out any accidentally sent ERC20 tokens
429  // Owner CANNOT transfer out tokens which were purposefully deposited
430 
431  // ------------------------------------------------------------------------
432 
433  function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
434 
435     //find actual balance of the contract
436      uint tokenBalance = ERC20Interface(tokenAddress).balanceOf(this);
437 
438      //find number of accidentally deposited tokens (actual - purposefully deposited)
439      uint undepositedTokens = tokenBalance.sub(depositedTokens[tokenAddress]);
440 
441      //only allow withdrawing of accidentally deposited tokens
442      assert(tokens <= undepositedTokens);
443 
444      ERC20Interface(tokenAddress).transfer(owner, tokens);
445 
446      return true;
447 
448  }
449 
450 
451 
452 
453 }