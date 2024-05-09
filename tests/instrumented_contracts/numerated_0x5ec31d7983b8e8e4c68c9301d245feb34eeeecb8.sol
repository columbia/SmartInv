1 pragma solidity ^0.4.24;
2  
3 
4 contract SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 
35 
36 /**
37  * ERC-20 standard token interface, as defined
38  * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.
39  */
40 contract Token {
41   
42   function totalSupply() public constant returns (uint256 supply);
43   function balanceOf(address _owner) public constant returns (uint256 balance);
44   function transfer(address _to, uint256 _value) public returns (bool success);
45   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
46   function approve(address _spender, uint256 _value) public returns (bool success);
47   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
48   event Transfer(address indexed _from, address indexed _to, uint256 _value);
49   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 }
51 
52 
53 
54 /**
55  * Abstract Token Smart Contract that could be used as a base contract for
56  * ERC-20 token contracts.
57  */
58 contract AbstractToken is Token, SafeMath {
59   /**
60    * Create new Abstract Token contract.
61    */
62   constructor () public {
63     // Do nothing
64   }
65   
66   /**
67    * Get number of tokens currently belonging to given owner.
68    *
69    * @param _owner address to get number of tokens currently belonging to the
70    *        owner of
71    * @return number of tokens currently belonging to the owner of given address
72    */
73   function balanceOf(address _owner) public constant returns (uint256 balance) {
74     return accounts [_owner];
75   }
76 
77   /**
78    * Transfer given number of tokens from message sender to given recipient.
79    *
80    * @param _to address to transfer tokens to the owner of
81    * @param _value number of tokens to transfer to the owner of given address
82    * @return true if tokens were transferred successfully, false otherwise
83    * accounts [_to] + _value > accounts [_to] for overflow check
84    * which is already in safeMath
85    */
86   function transfer(address _to, uint256 _value) public returns (bool success) {
87     require(_to != address(0));
88     if (accounts [msg.sender] < _value) return false;
89     if (_value > 0 && msg.sender != _to) {
90       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
91       accounts [_to] = safeAdd (accounts [_to], _value);
92     }
93     emit Transfer (msg.sender, _to, _value);
94     return true;
95   }
96 
97   /**
98    * Transfer given number of tokens from given owner to given recipient.
99    *
100    * @param _from address to transfer tokens from the owner of
101    * @param _to address to transfer tokens to the owner of
102    * @param _value number of tokens to transfer from given owner to given
103    *        recipient
104    * @return true if tokens were transferred successfully, false otherwise
105    * accounts [_to] + _value > accounts [_to] for overflow check
106    * which is already in safeMath
107    */
108   function transferFrom(address _from, address _to, uint256 _value) public
109   returns (bool success) {
110     require(_to != address(0));
111     if (allowances [_from][msg.sender] < _value) return false;
112     if (accounts [_from] < _value) return false; 
113 
114     if (_value > 0 && _from != _to) {
115 	  allowances [_from][msg.sender] = safeSub (allowances [_from][msg.sender], _value);
116       accounts [_from] = safeSub (accounts [_from], _value);
117       accounts [_to] = safeAdd (accounts [_to], _value);
118     }
119     emit Transfer(_from, _to, _value);
120     return true;
121   }
122 
123   /**
124    * Allow given spender to transfer given number of tokens from message sender.
125    * @param _spender address to allow the owner of to transfer tokens from message sender
126    * @param _value number of tokens to allow to transfer
127    * @return true if token transfer was successfully approved, false otherwise
128    */
129    function approve (address _spender, uint256 _value) public returns (bool success) {
130     allowances [msg.sender][_spender] = _value;
131     emit Approval (msg.sender, _spender, _value);
132     return true;
133   }
134 
135   /**
136    * Tell how many tokens given spender is currently allowed to transfer from
137    * given owner.
138    *
139    * @param _owner address to get number of tokens allowed to be transferred
140    *        from the owner of
141    * @param _spender address to get number of tokens allowed to be transferred
142    *        by the owner of
143    * @return number of tokens given spender is currently allowed to transfer
144    *         from given owner
145    */
146   function allowance(address _owner, address _spender) public constant
147   returns (uint256 remaining) {
148     return allowances [_owner][_spender];
149   }
150 
151   /**
152    * Mapping from addresses of token holders to the numbers of tokens belonging
153    * to these token holders.
154    */
155   mapping (address => uint256) accounts;
156 
157   /**
158    * Mapping from addresses of token holders to the mapping of addresses of
159    * spenders to the allowances set by these token holders to these spenders.
160    */
161   mapping (address => mapping (address => uint256)) private allowances;
162   
163 }
164 
165 
166 /**
167  * Aixal token smart contract.
168  */
169 contract Aixal is AbstractToken {
170   /**
171    * Maximum allowed number of tokens in circulation.
172    * tokenSupply = tokensIActuallyWant * (10 ^ decimals)
173    */
174    
175    
176   uint256 constant MAX_TOKEN_COUNT = 100000000 * (10**9);
177    
178   /**
179    * Address of the owner of this smart contract.
180    */
181   address private owner;
182   
183   /**
184    * Frozen account list holder
185    */
186   mapping (address => bool) private frozenAccount;
187 
188   /**
189    * Current number of tokens in circulation.
190    */
191   uint256 tokenCount = 0;
192   
193  
194   /**
195    * True if tokens transfers are currently frozen, false otherwise.
196    */
197   bool frozen = false;
198   
199  
200   /**
201    * Create new token smart contract and make msg.sender the
202    * owner of this smart contract.
203    */
204   constructor () public {
205     owner = msg.sender;
206   }
207 
208   /**
209    * Get total number of tokens in circulation.
210    *
211    * @return total number of tokens in circulation
212    */
213   function totalSupply() public constant returns (uint256 supply) {
214     return tokenCount;
215   }
216 
217   string constant public name = "Aixal";
218   string constant public symbol = "AXL";
219   uint8 constant public decimals = 9;
220   
221   /**
222    * Transfer given number of tokens from message sender to given recipient.
223    * @param _to address to transfer tokens to the owner of
224    * @param _value number of tokens to transfer to the owner of given address
225    * @return true if tokens were transferred successfully, false otherwise
226    */
227   function transfer(address _to, uint256 _value) public returns (bool success) {
228     require(!frozenAccount[msg.sender]);
229 	if (frozen) return false;
230     else return AbstractToken.transfer (_to, _value);
231   }
232 
233   /**
234    * Transfer given number of tokens from given owner to given recipient.
235    *
236    * @param _from address to transfer tokens from the owner of
237    * @param _to address to transfer tokens to the owner of
238    * @param _value number of tokens to transfer from given owner to given
239    *        recipient
240    * @return true if tokens were transferred successfully, false otherwise
241    */
242   function transferFrom(address _from, address _to, uint256 _value) public
243     returns (bool success) {
244 	require(!frozenAccount[_from]);
245     if (frozen) return false;
246     else return AbstractToken.transferFrom (_from, _to, _value);
247   }
248 
249    /**
250    * Change how many tokens given spender is allowed to transfer from message
251    * spender.  In order to prevent double spending of allowance,
252    * To change the approve amount you first have to reduce the addresses`
253    * allowance to zero by calling `approve(_spender, 0)` if it is not
254    * already 0 to mitigate the race condition described here:
255    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
256    * @param _spender address to allow the owner of to transfer tokens from
257    *        message sender
258    * @param _value number of tokens to allow to transfer
259    * @return true if token transfer was successfully approved, false otherwise
260    */
261   function approve (address _spender, uint256 _value) public 
262     returns (bool success) {
263 	require(allowance (msg.sender, _spender) == 0 || _value == 0);
264     return AbstractToken.approve (_spender, _value);
265   }
266 
267   /**
268    * Create _value new tokens and give new created tokens to msg.sender.
269    * May only be called by smart contract owner.
270    *
271    * @param _value number of tokens to create
272    * @return true if tokens were created successfully, false otherwise
273    */
274   function createTokens(uint256 _value) public
275     returns (bool success) {
276     require (msg.sender == owner);
277 
278     if (_value > 0) {
279       if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;
280 	  
281       accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
282       tokenCount = safeAdd (tokenCount, _value);
283 	  
284 	  // adding transfer event and _from address as null address
285 	  emit Transfer(0x0, msg.sender, _value);
286 	  
287 	  return true;
288     }
289 	
290 	  return false;
291     
292   }
293   
294 
295   /**
296    * Set new owner for the smart contract.
297    * May only be called by smart contract owner.
298    *
299    * @param _newOwner address of new owner of the smart contract
300    */
301   function setOwner(address _newOwner) public {
302     require (msg.sender == owner);
303 
304     owner = _newOwner;
305   }
306 
307   /**
308    * Freeze ALL token transfers.
309    * May only be called by smart contract owner.
310    */
311   function freezeTransfers () public {
312     require (msg.sender == owner);
313 
314     if (!frozen) {
315       frozen = true;
316       emit Freeze ();
317     }
318   }
319 
320   /**
321    * Unfreeze ALL token transfers.
322    * May only be called by smart contract owner.
323    */
324   function unfreezeTransfers  () public {
325     require (msg.sender == owner);
326 
327     if (frozen) {
328       frozen = false;
329       emit Unfreeze ();
330     }
331   }
332   
333   
334   /*A user is able to unintentionally send tokens to a contract 
335   * and if the contract is not prepared to refund them they will get stuck in the contract. 
336   * The same issue used to happen for Ether too but new Solidity versions added the payable modifier to
337   * prevent unintended Ether transfers. However, there’s no such mechanism for token transfers.
338   * so the below function is created
339   */
340   
341   function refundTokens(address _token, address _refund, uint256 _value) public {
342     require (msg.sender == owner);
343     require(_token != address(this));
344     AbstractToken token = AbstractToken(_token);
345     token.transfer(_refund, _value);
346     emit RefundTokens(_token, _refund, _value);
347   }
348   
349   /**
350    * Freeze specific account
351    * May only be called by smart contract owner.
352    */
353   function freezeAccount(address _target, bool freeze) public {
354       require (msg.sender == owner);
355 	  require (msg.sender != _target);
356       frozenAccount[_target] = freeze;
357       emit FrozenFunds(_target, freeze);
358  }
359 
360   /**
361    * Logged when token transfers were frozen.
362    */
363   event Freeze ();
364 
365   /**
366    * Logged when token transfers were unfrozen.
367    */
368   event Unfreeze ();
369   
370   /**
371    * Logged when a particular account is frozen.
372    */
373   
374   event FrozenFunds(address target, bool frozen);
375 
376 
377   
378   /**
379    * when accidentally send other tokens are refunded
380    */
381   
382   event RefundTokens(address _token, address _refund, uint256 _value);
383 }