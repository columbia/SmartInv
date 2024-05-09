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
16 contract ERC20Interface {
17     function totalSupply() public constant returns (uint);
18     function balanceOf(address tokenOwner) public constant returns (uint balance);
19     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
20     function transfer(address to, uint tokens) public returns (bool success);
21     function approve(address spender, uint tokens) public returns (bool success);
22     function transferFrom(address from, address to, uint tokens) public returns (bool success);
23 
24     event Transfer(address indexed from, address indexed to, uint tokens);
25     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
26 }
27 
28 
29 library ECRecovery {
30 
31   /**
32    * @dev Recover signer address from a message by using their signature
33    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
34    * @param sig bytes signature, the signature is generated using web3.eth.sign()
35    */
36   function recover(bytes32 hash, bytes sig) public pure returns (address) {
37     bytes32 r;
38     bytes32 s;
39     uint8 v;
40 
41     //Check the signature length
42     if (sig.length != 65) {
43       return (address(0));
44     }
45 
46     // Divide the signature in r, s and v variables
47     assembly {
48       r := mload(add(sig, 32))
49       s := mload(add(sig, 64))
50       v := byte(0, mload(add(sig, 96)))
51     }
52 
53     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
54     if (v < 27) {
55       v += 27;
56     }
57 
58     // If the version is correct return the signer address
59     if (v != 27 && v != 28) {
60       return (address(0));
61     } else {
62       return ecrecover(hash, v, r, s);
63     }
64   }
65 
66 }
67 
68 /**
69  * @title SafeMath
70  * @dev Math operations with safety checks that throw on error
71  */
72 library SafeMath {
73 
74   /**
75   * @dev Multiplies two numbers, throws on overflow.
76   */
77   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78     if (a == 0) {
79       return 0;
80     }
81     uint256 c = a * b;
82     assert(c / a == b);
83     return c;
84   }
85 
86   /**
87   * @dev Integer division of two numbers, truncating the quotient.
88   */
89   function div(uint256 a, uint256 b) internal pure returns (uint256) {
90     // assert(b > 0); // Solidity automatically throws when dividing by 0
91     uint256 c = a / b;
92     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
93     return c;
94   }
95 
96   /**
97   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
98   */
99   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100     assert(b <= a);
101     return a - b;
102   }
103 
104   /**
105   * @dev Adds two numbers, throws on overflow.
106   */
107   function add(uint256 a, uint256 b) internal pure returns (uint256) {
108     uint256 c = a + b;
109     assert(c >= a);
110     return c;
111   }
112 }
113 
114 //wEth interface
115 contract WrapperInterface
116 {
117   function() public payable;
118   function deposit() public payable ;
119   function withdraw(uint wad) public;
120   function totalSupply() public view returns (uint);
121   function approve(address guy, uint wad) public returns (bool success);
122   function transfer(address dst, uint wad) public returns (bool success);
123   function transferFrom(address src, address dst, uint wad) public returns (bool);
124 
125 
126   event  Approval(address indexed src, address indexed guy, uint wad);
127   event  Transfer(address indexed src, address indexed dst, uint wad);
128   event  Deposit(address indexed dst, uint wad);
129   event  Withdrawal(address indexed src, uint wad);
130 
131 }
132 
133 contract ApproveAndCallFallBack {
134 
135     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
136 
137 }
138 
139 
140 
141 contract Owned {
142 
143     address public owner;
144 
145     address public newOwner;
146 
147 
148     event OwnershipTransferred(address indexed _from, address indexed _to);
149 
150 
151     function Owned() public {
152 
153         owner = msg.sender;
154 
155     }
156 
157 
158     modifier onlyOwner {
159 
160         require(msg.sender == owner);
161 
162         _;
163 
164     }
165 
166 
167     function transferOwnership(address _newOwner) public onlyOwner {
168 
169         newOwner = _newOwner;
170 
171     }
172 
173     function acceptOwnership() public {
174 
175         require(msg.sender == newOwner);
176 
177         OwnershipTransferred(owner, newOwner);
178 
179         owner = newOwner;
180 
181         newOwner = address(0);
182 
183     }
184 
185 }
186 
187 
188 
189 
190 
191 contract LavaWallet is Owned {
192 
193 
194   using SafeMath for uint;
195 
196   // balances[tokenContractAddress][EthereumAccountAddress] = 0
197    mapping(address => mapping (address => uint256)) balances;
198 
199    //token => owner => spender : amount
200    mapping(address => mapping (address => mapping (address => uint256))) allowed;
201 
202 
203 
204    mapping(bytes32 => uint256) burnedSignatures;
205 
206 
207   event Deposit(address token, address user, uint amount, uint balance);
208   event Withdraw(address token, address user, uint amount, uint balance);
209   event Transfer(address indexed from, address indexed to,address token, uint tokens);
210   event Approval(address indexed tokenOwner, address indexed spender,address token, uint tokens);
211 
212   function LavaWallet() public  {
213 
214   }
215 
216 
217   //do not allow ether to enter
218   function() public payable {
219       revert();
220   }
221 
222 
223    //Remember you need pre-approval for this - nice with ApproveAndCall
224   function depositTokens(address from, address token, uint256 tokens ) public returns (bool success)
225   {
226       //we already have approval so lets do a transferFrom - transfer the tokens into this contract
227       ERC20Interface(token).transferFrom(from, this, tokens);
228       balances[token][from] = balances[token][from].add(tokens);
229 
230       Deposit(token, from, tokens, balances[token][from]);
231 
232       return true;
233   }
234 
235 
236   //No approve needed, only from msg.sender
237   function withdrawTokens(address token, uint256 tokens) public {
238     balances[token][msg.sender] = balances[token][msg.sender].sub(tokens);
239 
240     ERC20Interface(token).transfer(msg.sender, tokens);
241 
242     Withdraw(token, msg.sender, tokens, balances[token][msg.sender]);
243   }
244 
245   //Requires approval so it can be public
246   function withdrawTokensFrom( address from, address to,address token,  uint tokens) public returns (bool success) {
247       balances[token][from] = balances[token][from].sub(tokens);
248       allowed[token][from][to] = allowed[token][from][to].sub(tokens);
249 
250       ERC20Interface(token).transfer(to, tokens);
251 
252       Withdraw(token, from, tokens, balances[token][from]);
253       return true;
254   }
255 
256 
257   function balanceOf(address token,address user) public constant returns (uint) {
258        return balances[token][user];
259    }
260 
261 
262 
263   //Can also be used to remove approval by using a 'tokens' value of 0
264   function approveTokens(address spender, address token, uint tokens) public returns (bool success) {
265       allowed[token][msg.sender][spender] = tokens;
266       Approval(msg.sender, token, spender, tokens);
267       return true;
268   }
269 
270 
271   //No approve needed, only from msg.sender
272    function transferTokens(address to, address token, uint tokens) public returns (bool success) {
273         balances[token][msg.sender] = balances[token][msg.sender].sub(tokens);
274         balances[token][to] = balances[token][to].add(tokens);
275         Transfer(msg.sender, token, to, tokens);
276         return true;
277     }
278 
279 
280     //Can be public because it requires approval
281    function transferTokensFrom( address from, address to,address token,  uint tokens) public returns (bool success) {
282        balances[token][from] = balances[token][from].sub(tokens);
283        allowed[token][from][to] = allowed[token][from][to].sub(tokens);
284        balances[token][to] = balances[token][to].add(tokens);
285        Transfer(token, from, to, tokens);
286        return true;
287    }
288 
289    //Nonce is the same thing as a 'check number'
290    //EIP 712
291    function getLavaTypedDataHash( address from, address to, address token, uint256 tokens, uint256 relayerReward,
292                                      uint256 expires, uint256 nonce) public constant returns (bytes32)
293    {
294         bytes32 hardcodedSchemaHash = 0x313236b6cd8d12125421e44528d8f5ba070a781aeac3e5ae45e314b818734ec3 ;
295 
296         bytes32 typedDataHash = sha3(
297             hardcodedSchemaHash,
298             sha3(from,to,this,token,tokens,relayerReward,expires,nonce)
299           );
300 
301         return typedDataHash;
302    }
303 
304 
305 
306    function approveTokensWithSignature(address from, address to, address token, uint256 tokens, uint256 relayerReward,
307                                      uint256 expires, uint256 nonce, bytes signature) public returns (bool success)
308    {
309        //bytes32 sigHash = sha3("\x19Ethereum Signed Message:\n32",this, from, to, token, tokens, relayerReward, expires, nonce);
310 
311        bytes32 sigHash = getLavaTypedDataHash(from,to,token,tokens,relayerReward,expires,nonce);
312 
313        address recoveredSignatureSigner = ECRecovery.recover(sigHash,signature);
314 
315        //make sure the signer is the depositor of the tokens
316        if(from != recoveredSignatureSigner) revert();
317 
318        //make sure the signature has not expired
319        if(block.number > expires) revert();
320 
321        uint burnedSignature = burnedSignatures[sigHash];
322        burnedSignatures[sigHash] = 0x1; //spent
323        if(burnedSignature != 0x0 ) revert();
324 
325        //approve the relayer reward
326        allowed[token][from][msg.sender] = relayerReward;
327        Approval(from, token, msg.sender, relayerReward);
328 
329        //transferRelayerReward
330        if(!transferTokensFrom(from, msg.sender, token, relayerReward)) revert();
331 
332        //approve transfer of tokens
333        allowed[token][from][to] = tokens;
334        Approval(from, token, to, tokens);
335 
336 
337        return true;
338    }
339 
340    //The tokens are withdrawn from the lava wallet and transferred into the To account
341   function withdrawTokensFromWithSignature(address from, address to,  address token, uint256 tokens,  uint256 relayerReward,
342                                     uint256 expires, uint256 nonce, bytes signature) public returns (bool success)
343   {
344       //check to make sure that signature == ecrecover signature
345 
346       if(!approveTokensWithSignature(from,to,token,tokens,relayerReward,expires,nonce,signature)) revert();
347 
348       //it can be requested that fewer tokens be sent that were approved -- the whole approval will be invalidated though
349       if(!withdrawTokensFrom( from, to, token, tokens)) revert();
350 
351 
352       return true;
353 
354   }
355 
356    //the tokens remain in lava wallet
357   function transferTokensFromWithSignature(address from, address to,  address token, uint256 tokens,  uint256 relayerReward,
358                                     uint256 expires, uint256 nonce, bytes signature) public returns (bool success)
359   {
360       //check to make sure that signature == ecrecover signature
361 
362       if(!approveTokensWithSignature(from,to,token,tokens,relayerReward,expires,nonce,signature)) revert();
363 
364       //it can be requested that fewer tokens be sent that were approved -- the whole approval will be invalidated though
365       if(!transferTokensFrom( from, to, token, tokens)) revert();
366 
367 
368       return true;
369 
370   }
371 
372 
373     function tokenAllowance(address token, address tokenOwner, address spender) public constant returns (uint remaining) {
374 
375         return allowed[token][tokenOwner][spender];
376 
377     }
378 
379 
380 
381      function burnSignature(address from, address to, address token, uint256 tokens, uint256 relayerReward, uint256 expires, uint256 nonce,  bytes signature) public returns (bool success)
382      {
383 
384        bytes32 sigHash = getLavaTypedDataHash(from,to,token,tokens,relayerReward,expires,nonce);
385 
386 
387          address recoveredSignatureSigner = ECRecovery.recover(sigHash,signature);
388 
389          //make sure the invalidator is the signer
390          if(recoveredSignatureSigner != from) revert();
391 
392 
393          //make sure this signature has never been used
394          uint burnedSignature = burnedSignatures[sigHash];
395          burnedSignatures[sigHash] = 0x2; //invalidated
396          if(burnedSignature != 0x0 ) revert();
397 
398          return true;
399      }
400 
401 
402      //2 is burned
403      //1 is redeemed
404      function signatureBurnStatus(bytes32 digest) public view returns (uint)
405      {
406        return (burnedSignatures[digest]);
407      }
408 
409 
410 
411 
412        /*
413          Receive approval to spend tokens and perform any action all in one transaction
414        */
415      function receiveApproval(address from, uint256 tokens, address token, bytes data) public returns (bool success) {
416 
417 
418        return depositTokens(from, token, tokens );
419 
420      }
421 
422      /*
423       Approve lava tokens for a smart contract and call the contracts receiveApproval method all in one fell swoop
424       */
425      function approveAndCall(address from, address to, address token, uint256 tokens, uint256 relayerReward,
426                                        uint256 expires, uint256 nonce, bytes signature,  bytes data) public returns (bool success) {
427 
428          if(!approveTokensWithSignature(from,to,token,tokens,relayerReward,expires,nonce,signature)) revert();
429 
430          ApproveAndCallFallBack(to).receiveApproval(from, tokens, token, data);
431 
432          return true;
433 
434      }
435 
436 
437 
438  // ------------------------------------------------------------------------
439 
440  // Owner can transfer out any accidentally sent ERC20 tokens
441 
442  // ------------------------------------------------------------------------
443 
444  function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
445 
446      return ERC20Interface(tokenAddress).transfer(owner, tokens);
447 
448  }
449 
450 
451 
452 
453 }