1 pragma solidity ^0.4.19;
2 
3 /*
4  * Abstract Token Smart Contract.  Copyright © 2017 by CIBUS WORLD.
5  * Author: contact@cibus.world
6  */
7 
8  
9  /*
10  * Safe Math Smart Contract.  Copyright © 2017-2018 by CIBUS WORLD.
11  * Author: contact@cibus.world
12  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
13  */
14 
15 contract SafeMath {
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 
44 
45 
46 
47 /**
48  * ERC-20 standard token interface, as defined
49  * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.
50  */
51 contract Token {
52   
53   function totalSupply() constant returns (uint256 supply);
54   function balanceOf(address _owner) constant returns (uint256 balance);
55   function transfer(address _to, uint256 _value) returns (bool success);
56   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
57   function approve(address _spender, uint256 _value) returns (bool success);
58   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
59   event Transfer(address indexed _from, address indexed _to, uint256 _value);
60   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
61 }
62 
63 
64 
65 /**
66  * Abstract Token Smart Contract that could be used as a base contract for
67  * ERC-20 token contracts.
68  */
69 contract AbstractToken is Token, SafeMath {
70   /**
71    * Create new Abstract Token contract.
72    */
73   function AbstractToken () {
74     // Do nothing
75   }
76   
77   /**
78    * Get number of tokens currently belonging to given owner.
79    *
80    * @param _owner address to get number of tokens currently belonging to the
81    *        owner of
82    * @return number of tokens currently belonging to the owner of given address
83    */
84   function balanceOf(address _owner) constant returns (uint256 balance) {
85     return accounts [_owner];
86   }
87 
88   /**
89    * Transfer given number of tokens from message sender to given recipient.
90    *
91    * @param _to address to transfer tokens to the owner of
92    * @param _value number of tokens to transfer to the owner of given address
93    * @return true if tokens were transferred successfully, false otherwise
94    * accounts [_to] + _value > accounts [_to] for overflow check
95    * which is already in safeMath
96    */
97   function transfer(address _to, uint256 _value) returns (bool success) {
98     require(_to != address(0));
99     if (accounts [msg.sender] < _value) return false;
100     if (_value > 0 && msg.sender != _to) {
101       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
102       accounts [_to] = safeAdd (accounts [_to], _value);
103     }
104     Transfer (msg.sender, _to, _value);
105     return true;
106   }
107 
108   /**
109    * Transfer given number of tokens from given owner to given recipient.
110    *
111    * @param _from address to transfer tokens from the owner of
112    * @param _to address to transfer tokens to the owner of
113    * @param _value number of tokens to transfer from given owner to given
114    *        recipient
115    * @return true if tokens were transferred successfully, false otherwise
116    * accounts [_to] + _value > accounts [_to] for overflow check
117    * which is already in safeMath
118    */
119   function transferFrom(address _from, address _to, uint256 _value)
120   returns (bool success) {
121     require(_to != address(0));
122     if (allowances [_from][msg.sender] < _value) return false;
123     if (accounts [_from] < _value) return false; 
124 
125     if (_value > 0 && _from != _to) {
126 	  allowances [_from][msg.sender] = safeSub (allowances [_from][msg.sender], _value);
127       accounts [_from] = safeSub (accounts [_from], _value);
128       accounts [_to] = safeAdd (accounts [_to], _value);
129     }
130     Transfer(_from, _to, _value);
131     return true;
132   }
133 
134   /**
135    * Allow given spender to transfer given number of tokens from message sender.
136    * @param _spender address to allow the owner of to transfer tokens from message sender
137    * @param _value number of tokens to allow to transfer
138    * @return true if token transfer was successfully approved, false otherwise
139    */
140    function approve (address _spender, uint256 _value) returns (bool success) {
141     allowances [msg.sender][_spender] = _value;
142     Approval (msg.sender, _spender, _value);
143     return true;
144   }
145 
146   /**
147    * Tell how many tokens given spender is currently allowed to transfer from
148    * given owner.
149    *
150    * @param _owner address to get number of tokens allowed to be transferred
151    *        from the owner of
152    * @param _spender address to get number of tokens allowed to be transferred
153    *        by the owner of
154    * @return number of tokens given spender is currently allowed to transfer
155    *         from given owner
156    */
157   function allowance(address _owner, address _spender) constant
158   returns (uint256 remaining) {
159     return allowances [_owner][_spender];
160   }
161 
162   /**
163    * Mapping from addresses of token holders to the numbers of tokens belonging
164    * to these token holders.
165    */
166   mapping (address => uint256) accounts;
167 
168   /**
169    * Mapping from addresses of token holders to the mapping of addresses of
170    * spenders to the allowances set by these token holders to these spenders.
171    */
172   mapping (address => mapping (address => uint256)) private allowances;
173 }
174 
175 
176 /**
177  * CIBUS token smart contract.
178  */
179 contract CIBUSToken is AbstractToken {
180   /**
181    * Maximum allowed number of tokens in circulation.
182    *Total Supply for Pre ICO = (10% of 100000000 = 10000000)  and  ICO = (30% of 100000000 = 30000000) 
183    * 10^^10 is done for decimal places, this is standard practice as all ethers are actually wei in EVM
184    */
185    
186    
187   uint256 constant MAX_TOKEN_COUNT = 100000000 * (10**10);
188    
189   /**
190    * Address of the owner of this smart contract.
191    */
192   address private owner;
193 
194   /**
195    * Current number of tokens in circulation.
196    */
197   uint256 tokenCount = 0;
198   
199  
200   /**
201    * True if tokens transfers are currently frozen, false otherwise.
202    */
203   bool frozen = false;
204   
205   /**
206    * Counter of total funds collected, in wei
207   */
208   uint public totalCollected = 0;
209 
210   /**
211    * Create new CIBUS token smart contract and make msg.sender the
212    * owner of this smart contract.
213    */
214   function CIBUSToken () {
215     owner = msg.sender;
216   }
217 
218   /**
219    * Get total number of tokens in circulation.
220    *
221    * @return total number of tokens in circulation
222    */
223   function totalSupply() constant returns (uint256 supply) {
224     return tokenCount;
225   }
226 
227   string constant public name = "CIBUS Token";
228   string constant public symbol = "CBT";
229   uint8 constant public decimals = 10;
230   
231   /**
232    * Transfer given number of tokens from message sender to given recipient.
233    *
234    * @param _to address to transfer tokens to the owner of
235    * @param _value number of tokens to transfer to the owner of given address
236    * @return true if tokens were transferred successfully, false otherwise
237    */
238   function transfer(address _to, uint256 _value) returns (bool success) {
239     if (frozen) return false;
240     else return AbstractToken.transfer (_to, _value);
241   }
242 
243   /**
244    * Transfer given number of tokens from given owner to given recipient.
245    *
246    * @param _from address to transfer tokens from the owner of
247    * @param _to address to transfer tokens to the owner of
248    * @param _value number of tokens to transfer from given owner to given
249    *        recipient
250    * @return true if tokens were transferred successfully, false otherwise
251    */
252   function transferFrom(address _from, address _to, uint256 _value)
253     returns (bool success) {
254     if (frozen) return false;
255     else return AbstractToken.transferFrom (_from, _to, _value);
256   }
257 
258    /**
259    * Change how many tokens given spender is allowed to transfer from message
260    * spender.  In order to prevent double spending of allowance,
261    * To change the approve amount you first have to reduce the addresses`
262    * allowance to zero by calling `approve(_spender, 0)` if it is not
263    * already 0 to mitigate the race condition described here:
264    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
265    * @param _spender address to allow the owner of to transfer tokens from
266    *        message sender
267    * @param _value number of tokens to allow to transfer
268    * @return true if token transfer was successfully approved, false otherwise
269    */
270   function approve (address _spender, uint256 _value)
271     returns (bool success) {
272 	require(allowance (msg.sender, _spender) == 0 || _value == 0);
273     return AbstractToken.approve (_spender, _value);
274   }
275 
276   /**
277    * Create _value new tokens and give new created tokens to msg.sender.
278    * May only be called by smart contract owner.
279    *
280    * @param _value number of tokens to create
281    * @param _collected total amounts of fund collected for this issuance, in wei
282    * @return true if tokens were created successfully, false otherwise
283    */
284   function createTokens(uint256 _value, uint _collected)
285     returns (bool success) {
286     require (msg.sender == owner);
287 
288     if (_value > 0) {
289       if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;
290 	  
291       accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
292       tokenCount = safeAdd (tokenCount, _value);
293       totalCollected = safeAdd(totalCollected, _collected);
294 	  
295 	  // adding transfer event and _from address as null address
296 	  Transfer(0x0, msg.sender, _value);
297 	  
298 	  return true;
299     }
300 	
301 	  return false;
302     
303   }
304   
305   
306   /**
307    * For future use only whne we will need more tokens for our main application
308    * Create mintedAmount new tokens and give new created tokens to target.
309    * May only be called by smart contract owner.
310    * @param mintedAmount number of tokens to create
311    * @return true if tokens were created successfully, false otherwise
312    */
313   
314   function mintToken(address target, uint256 mintedAmount) 
315   returns (bool success) {
316     require (msg.sender == owner);
317       if (mintedAmount > 0) {
318 	  
319       accounts [target] = safeAdd (accounts [target], mintedAmount);
320       tokenCount = safeAdd (tokenCount, mintedAmount);
321 	  
322 	  // adding transfer event and _from address as null address
323 	  Transfer(0x0, target, mintedAmount);
324 	  
325 	   return true;
326     }
327 	  return false;
328    
329     }
330 
331   /**
332    * Set new owner for the smart contract.
333    * May only be called by smart contract owner.
334    *
335    * @param _newOwner address of new owner of the smart contract
336    */
337   function setOwner(address _newOwner) {
338     require (msg.sender == owner);
339 
340     owner = _newOwner;
341   }
342 
343   /**
344    * Freeze token transfers.
345    * May only be called by smart contract owner.
346    */
347   function freezeTransfers () {
348     require (msg.sender == owner);
349 
350     if (!frozen) {
351       frozen = true;
352       Freeze ();
353     }
354   }
355 
356   /**
357    * Unfreeze token transfers.
358    * May only be called by smart contract owner.
359    */
360   function unfreezeTransfers () {
361     require (msg.sender == owner);
362 
363     if (frozen) {
364       frozen = false;
365       Unfreeze ();
366     }
367   }
368   
369   /*A user is able to unintentionally send tokens to a contract 
370   * and if the contract is not prepared to refund them they will get stuck in the contract. 
371   * The same issue used to happen for Ether too but new Solidity versions added the payable modifier to
372   * prevent unintended Ether transfers. However, there’s no such mechanism for token transfers.
373   * so the below function is created
374   */
375   
376   function refundTokens(address _token, address _refund, uint256 _value) {
377     require (msg.sender == owner);
378     require(_token != address(this));
379     AbstractToken token = AbstractToken(_token);
380     token.transfer(_refund, _value);
381     RefundTokens(_token, _refund, _value);
382   }
383 
384   /**
385    * Logged when token transfers were frozen.
386    */
387   event Freeze ();
388 
389   /**
390    * Logged when token transfers were unfrozen.
391    */
392   event Unfreeze ();
393   
394   /**
395    * when accidentally send other tokens are refunded
396    */
397   
398   event RefundTokens(address _token, address _refund, uint256 _value);
399 }