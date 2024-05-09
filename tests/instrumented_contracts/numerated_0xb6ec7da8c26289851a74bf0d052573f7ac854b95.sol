1 pragma solidity ^0.4.25;
2 
3 /*
4  * Creator: CCVT (CrytoCoinVillage) 
5  */
6 
7 /*
8  * Abstract Token Smart Contract
9  *
10  */
11 
12  
13  /*
14  * Safe Math Smart Contract. 
15  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
16  */
17 
18 contract SafeMath {
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 
48 
49 
50 /**
51  * ERC-20 standard token interface, as defined
52  * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.
53  */
54 contract Token {
55   
56   function totalSupply() public constant returns (uint256 supply);
57   function balanceOf(address _owner) public constant returns (uint256 balance);
58   function transfer(address _to, uint256 _value) public returns (bool success);
59   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
60   function approve(address _spender, uint256 _value) public returns (bool success);
61   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
62   event Transfer(address indexed _from, address indexed _to, uint256 _value);
63   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
64 }
65 
66 
67 
68 /**
69  * Abstract Token Smart Contract that could be used as a base contract for
70  * ERC-20 token contracts.
71  */
72 contract AbstractToken is Token, SafeMath {
73   /**
74    * Create new Abstract Token contract.
75    */
76   constructor () public {
77     // Do nothing
78   }
79   
80   /**
81    * Get number of tokens currently belonging to given owner.
82    *
83    * @param _owner address to get number of tokens currently belonging to the
84    *        owner of
85    * @return number of tokens currently belonging to the owner of given address
86    */
87   function balanceOf(address _owner) public constant returns (uint256 balance) {
88     return accounts [_owner];
89   }
90 
91   /**
92    * Transfer given number of tokens from message sender to given recipient.
93    *
94    * @param _to address to transfer tokens to the owner of
95    * @param _value number of tokens to transfer to the owner of given address
96    * @return true if tokens were transferred successfully, false otherwise
97    * accounts [_to] + _value > accounts [_to] for overflow check
98    * which is already in safeMath
99    */
100   function transfer(address _to, uint256 _value) public returns (bool success) {
101     require(_to != address(0));
102     if (accounts [msg.sender] < _value) return false;
103     if (_value > 0 && msg.sender != _to) {
104       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
105       accounts [_to] = safeAdd (accounts [_to], _value);
106     }
107     emit Transfer (msg.sender, _to, _value);
108     return true;
109   }
110 
111   /**
112    * Transfer given number of tokens from given owner to given recipient.
113    *
114    * @param _from address to transfer tokens from the owner of
115    * @param _to address to transfer tokens to the owner of
116    * @param _value number of tokens to transfer from given owner to given
117    *        recipient
118    * @return true if tokens were transferred successfully, false otherwise
119    * accounts [_to] + _value > accounts [_to] for overflow check
120    * which is already in safeMath
121    */
122   function transferFrom(address _from, address _to, uint256 _value) public
123   returns (bool success) {
124     require(_to != address(0));
125     if (allowances [_from][msg.sender] < _value) return false;
126     if (accounts [_from] < _value) return false; 
127 
128     if (_value > 0 && _from != _to) {
129 	  allowances [_from][msg.sender] = safeSub (allowances [_from][msg.sender], _value);
130       accounts [_from] = safeSub (accounts [_from], _value);
131       accounts [_to] = safeAdd (accounts [_to], _value);
132     }
133     emit Transfer(_from, _to, _value);
134     return true;
135   }
136 
137   /**
138    * Allow given spender to transfer given number of tokens from message sender.
139    * @param _spender address to allow the owner of to transfer tokens from message sender
140    * @param _value number of tokens to allow to transfer
141    * @return true if token transfer was successfully approved, false otherwise
142    */
143    function approve (address _spender, uint256 _value) public returns (bool success) {
144     allowances [msg.sender][_spender] = _value;
145     emit Approval (msg.sender, _spender, _value);
146     return true;
147   }
148 
149   /**
150    * Tell how many tokens given spender is currently allowed to transfer from
151    * given owner.
152    *
153    * @param _owner address to get number of tokens allowed to be transferred
154    *        from the owner of
155    * @param _spender address to get number of tokens allowed to be transferred
156    *        by the owner of
157    * @return number of tokens given spender is currently allowed to transfer
158    *         from given owner
159    */
160   function allowance(address _owner, address _spender) public constant
161   returns (uint256 remaining) {
162     return allowances [_owner][_spender];
163   }
164 
165   /**
166    * Mapping from addresses of token holders to the numbers of tokens belonging
167    * to these token holders.
168    */
169   mapping (address => uint256) accounts;
170 
171   /**
172    * Mapping from addresses of token holders to the mapping of addresses of
173    * spenders to the allowances set by these token holders to these spenders.
174    */
175   mapping (address => mapping (address => uint256)) private allowances;
176   
177 }
178 
179 
180 /**
181  * CrytoCoinVillage smart contract.
182  */
183 contract CCVTToken is AbstractToken {
184   /**
185    * Maximum allowed number of tokens in circulation.
186    * tokenSupply = tokensIActuallyWant * (10 ^ decimals)
187    */
188    
189    
190   uint256 constant MAX_TOKEN_COUNT = 200000000 * (10**18);
191    
192   /**
193    * Address of the owner of this smart contract.
194    */
195   address private owner;
196   
197   /**
198    * Frozen account list holder
199    */
200   mapping (address => bool) private frozenAccount;
201 
202   /**
203    * Current number of tokens in circulation.
204    */
205   uint256 tokenCount = 0;
206   
207  
208   /**
209    * True if tokens transfers are currently frozen, false otherwise.
210    */
211   bool frozen = false;
212   
213  
214   /**
215    * Create new token smart contract and make msg.sender the
216    * owner of this smart contract.
217    */
218   constructor () public {
219     owner = msg.sender;
220   }
221 
222   /**
223    * Get total number of tokens in circulation.
224    *
225    * @return total number of tokens in circulation
226    */
227   function totalSupply() public constant returns (uint256 supply) {
228     return tokenCount;
229   }
230 
231   string constant public name = "CrytoCoinVillage";
232   string constant public symbol = "CCVT";
233   uint8 constant public decimals = 18;
234   
235   /**
236    * Transfer given number of tokens from message sender to given recipient.
237    * @param _to address to transfer tokens to the owner of
238    * @param _value number of tokens to transfer to the owner of given address
239    * @return true if tokens were transferred successfully, false otherwise
240    */
241   function transfer(address _to, uint256 _value) public returns (bool success) {
242     require(!frozenAccount[msg.sender]);
243 	if (frozen) return false;
244     else return AbstractToken.transfer (_to, _value);
245   }
246 
247   /**
248    * Transfer given number of tokens from given owner to given recipient.
249    *
250    * @param _from address to transfer tokens from the owner of
251    * @param _to address to transfer tokens to the owner of
252    * @param _value number of tokens to transfer from given owner to given
253    *        recipient
254    * @return true if tokens were transferred successfully, false otherwise
255    */
256   function transferFrom(address _from, address _to, uint256 _value) public
257     returns (bool success) {
258 	require(!frozenAccount[_from]);
259     if (frozen) return false;
260     else return AbstractToken.transferFrom (_from, _to, _value);
261   }
262 
263    /**
264    * Change how many tokens given spender is allowed to transfer from message
265    * spender.  In order to prevent double spending of allowance,
266    * To change the approve amount you first have to reduce the addresses`
267    * allowance to zero by calling `approve(_spender, 0)` if it is not
268    * already 0 to mitigate the race condition described here:
269    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
270    * @param _spender address to allow the owner of to transfer tokens from
271    *        message sender
272    * @param _value number of tokens to allow to transfer
273    * @return true if token transfer was successfully approved, false otherwise
274    */
275   function approve (address _spender, uint256 _value) public
276     returns (bool success) {
277 	require(allowance (msg.sender, _spender) == 0 || _value == 0);
278     return AbstractToken.approve (_spender, _value);
279   }
280 
281   /**
282    * Create _value new tokens and give new created tokens to msg.sender.
283    * May only be called by smart contract owner.
284    *
285    * @param _value number of tokens to create
286    * @return true if tokens were created successfully, false otherwise
287    */
288   function createTokens(uint256 _value) public
289     returns (bool success) {
290     require (msg.sender == owner);
291 
292     if (_value > 0) {
293       if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;
294 	  
295       accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
296       tokenCount = safeAdd (tokenCount, _value);
297 	  
298 	  // adding transfer event and _from address as null address
299 	  emit Transfer(0x0, msg.sender, _value);
300 	  
301 	  return true;
302     }
303 	
304 	  return false;
305     
306   }
307   
308 
309   /**
310    * Set new owner for the smart contract.
311    * May only be called by smart contract owner.
312    *
313    * @param _newOwner address of new owner of the smart contract
314    */
315   function setOwner(address _newOwner) public {
316     require (msg.sender == owner);
317 
318     owner = _newOwner;
319   }
320 
321   /**
322    * Freeze ALL token transfers.
323    * May only be called by smart contract owner.
324    */
325   function freezeTransfers () public {
326     require (msg.sender == owner);
327 
328     if (!frozen) {
329       frozen = true;
330       emit Freeze ();
331     }
332   }
333 
334   /**
335    * Unfreeze ALL token transfers.
336    * May only be called by smart contract owner.
337    */
338   function unfreezeTransfers () public {
339     require (msg.sender == owner);
340 
341     if (frozen) {
342       frozen = false;
343       emit Unfreeze ();
344     }
345   }
346   
347   
348   /*A user is able to unintentionally send tokens to a contract 
349   * and if the contract is not prepared to refund them they will get stuck in the contract. 
350   * The same issue used to happen for Ether too but new Solidity versions added the payable modifier to
351   * prevent unintended Ether transfers. However, there’s no such mechanism for token transfers.
352   * so the below function is created
353   */
354   
355   function refundTokens(address _token, address _refund, uint256 _value) public {
356     require (msg.sender == owner);
357     require(_token != address(this));
358     AbstractToken token = AbstractToken(_token);
359     token.transfer(_refund, _value);
360     emit RefundTokens(_token, _refund, _value);
361   }
362   
363   /**
364    * Freeze specific account
365    * May only be called by smart contract owner.
366    */
367   function freezeAccount(address _target, bool freeze) public {
368       require (msg.sender == owner);
369 	  require (msg.sender != _target);
370       frozenAccount[_target] = freeze;
371       emit FrozenFunds(_target, freeze);
372  }
373 
374   /**
375    * Logged when token transfers were frozen.
376    */
377   event Freeze ();
378 
379   /**
380    * Logged when token transfers were unfrozen.
381    */
382   event Unfreeze ();
383   
384   /**
385    * Logged when a particular account is frozen.
386    */
387   
388   event FrozenFunds(address target, bool frozen);
389 
390 
391   
392   /**
393    * when accidentally send other tokens are refunded
394    */
395   
396   event RefundTokens(address _token, address _refund, uint256 _value);
397 }