1 pragma solidity ^0.4.21;
2 
3 /*
4  * Abstract Token Smart Contract.  Copyright © 2017 by Grab A Meal.
5  * Author: contact@grabameal.world
6  */
7 
8  
9  /*
10  * Safe Math Smart Contract.  Copyright © 2017 by Grab A Meal.
11  * Author: contact@grabameal.world
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
177  * GAM token smart contract.
178  */
179 contract GAMToken is AbstractToken {
180   /**
181    * Maximum allowed number of tokens in circulation.
182    * Total Supply 2000000000 GAM Tokens
183    * 10^^10 is done for decimal places, this is standard practice as all ethers are actually wei in EVM
184    */
185    
186    
187   uint256 constant MAX_TOKEN_COUNT = 2000000000 * (10**10);
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
205   
206   /**
207    * Create new GAM token smart contract and make msg.sender the
208    * owner of this smart contract.
209    */
210   function GAMToken () {
211     owner = msg.sender;
212   }
213 
214   /**
215    * Get total number of tokens in circulation.
216    *
217    * @return total number of tokens in circulation
218    */
219   function totalSupply() constant returns (uint256 supply) {
220     return tokenCount;
221   }
222 
223   string constant public name = "Grab A Meal Token";
224   string constant public symbol = "GAM";
225   uint8 constant public decimals = 10;
226   
227   /**
228    * Transfer given number of tokens from message sender to given recipient.
229    *
230    * @param _to address to transfer tokens to the owner of
231    * @param _value number of tokens to transfer to the owner of given address
232    * @return true if tokens were transferred successfully, false otherwise
233    */
234   function transfer(address _to, uint256 _value) returns (bool success) {
235     if (frozen) return false;
236     else return AbstractToken.transfer (_to, _value);
237   }
238 
239   /**
240    * Transfer given number of tokens from given owner to given recipient.
241    *
242    * @param _from address to transfer tokens from the owner of
243    * @param _to address to transfer tokens to the owner of
244    * @param _value number of tokens to transfer from given owner to given
245    *        recipient
246    * @return true if tokens were transferred successfully, false otherwise
247    */
248   function transferFrom(address _from, address _to, uint256 _value)
249     returns (bool success) {
250     if (frozen) return false;
251     else return AbstractToken.transferFrom (_from, _to, _value);
252   }
253 
254    /**
255    * Change how many tokens given spender is allowed to transfer from message
256    * spender.  In order to prevent double spending of allowance,
257    * To change the approve amount you first have to reduce the addresses`
258    * allowance to zero by calling `approve(_spender, 0)` if it is not
259    * already 0 to mitigate the race condition described here:
260    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
261    * @param _spender address to allow the owner of to transfer tokens from
262    *        message sender
263    * @param _value number of tokens to allow to transfer
264    * @return true if token transfer was successfully approved, false otherwise
265    */
266   function approve (address _spender, uint256 _value)
267     returns (bool success) {
268 	require(allowance (msg.sender, _spender) == 0 || _value == 0);
269     return AbstractToken.approve (_spender, _value);
270   }
271 
272   /**
273    * Create _value new tokens and give new created tokens to msg.sender.
274    * May only be called by smart contract owner.
275    *
276    * @param _value number of tokens to create
277    * @return true if tokens were created successfully, false otherwise
278    */
279   function createTokens(uint256 _value)
280     returns (bool success) {
281     require (msg.sender == owner);
282 
283     if (_value > 0) {
284       if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;
285 	  
286       accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
287       tokenCount = safeAdd (tokenCount, _value);
288       
289 	  
290 	  // adding transfer event and _from address as null address
291 	  Transfer(0x0, msg.sender, _value);
292 	  
293 	  return true;
294     }
295 	
296 	  return false;
297     
298   }
299   
300   
301   /**
302    * For future use only whne we will need more tokens for our main application
303    * Create mintedAmount new tokens and give new created tokens to target.
304    * May only be called by smart contract owner.
305    * @param mintedAmount number of tokens to create
306    * @return true if tokens were created successfully, false otherwise
307    */
308   
309   function mintToken(address target, uint256 mintedAmount) 
310   returns (bool success) {
311     require (msg.sender == owner);
312       if (mintedAmount > 0) {
313 	  
314       accounts [target] = safeAdd (accounts [target], mintedAmount);
315       tokenCount = safeAdd (tokenCount, mintedAmount);
316 	  
317 	  // adding transfer event and _from address as null address
318 	  Transfer(0x0, target, mintedAmount);
319 	  
320 	   return true;
321     }
322 	  return false;
323    
324     }
325 
326   /**
327    * Set new owner for the smart contract.
328    * May only be called by smart contract owner.
329    *
330    * @param _newOwner address of new owner of the smart contract
331    */
332   function setOwner(address _newOwner) {
333     require (msg.sender == owner);
334 
335     owner = _newOwner;
336   }
337 
338   /**
339    * Freeze token transfers.
340    * May only be called by smart contract owner.
341    */
342   function freezeTransfers () {
343     require (msg.sender == owner);
344 
345     if (!frozen) {
346       frozen = true;
347       Freeze ();
348     }
349   }
350 
351   /**
352    * Unfreeze token transfers.
353    * May only be called by smart contract owner.
354    */
355   function unfreezeTransfers () {
356     require (msg.sender == owner);
357 
358     if (frozen) {
359       frozen = false;
360       Unfreeze ();
361     }
362   }
363   
364   /*A user is able to unintentionally send tokens to a contract 
365   * and if the contract is not prepared to refund them they will get stuck in the contract. 
366   * The same issue used to happen for Ether too but new Solidity versions added the payable modifier to
367   * prevent unintended Ether transfers. However, there’s no such mechanism for token transfers.
368   * so the below function is created
369   */
370   
371   function refundTokens(address _token, address _refund, uint256 _value) {
372     require (msg.sender == owner);
373     require(_token != address(this));
374     AbstractToken token = AbstractToken(_token);
375     token.transfer(_refund, _value);
376     RefundTokens(_token, _refund, _value);
377   }
378 
379   /**
380    * Logged when token transfers were frozen.
381    */
382   event Freeze ();
383 
384   /**
385    * Logged when token transfers were unfrozen.
386    */
387   event Unfreeze ();
388   
389   /**
390    * when accidentally send other tokens are refunded
391    */
392   
393   event RefundTokens(address _token, address _refund, uint256 _value);
394 }