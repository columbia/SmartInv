1 pragma solidity ^0.4.23;
2 
3 /**
4     Creator: BTSM (Bitsmo Coin)
5  */
6 
7 
8 // ----------------------------------------------------------------------------
9 // Safe maths
10 // ----------------------------------------------------------------------------
11 contract SafeMath {
12     function safeAdd(uint a, uint b) public pure returns (uint c) {
13         c = a + b;
14         require(c >= a);
15     }
16     function safeSub(uint a, uint b) public pure returns (uint c) {
17         require(b <= a);
18         c = a - b;
19     }
20     function safeMul(uint a, uint b) public pure returns (uint c) {
21         c = a * b;
22         require(a == 0 || c / a == b);
23     }
24     function safeDiv(uint a, uint b) public pure returns (uint c) {
25         require(b > 0);
26         c = a / b;
27     }
28 }
29 
30 /**
31  * ERC-20 standard token interface, as defined
32  * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.
33  */
34 contract Token {
35   
36   function totalSupply() constant returns (uint256 supply);
37   function balanceOf(address _owner) constant returns (uint256 balance);
38   function transfer(address _to, uint256 _value) returns (bool success);
39   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
40   function approve(address _spender, uint256 _value) returns (bool success);
41   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
42   event Transfer(address indexed _from, address indexed _to, uint256 _value);
43   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 }
45 
46 
47 
48 
49 /**
50  * Abstract Token Smart Contract that could be used as a base contract for
51  * ERC-20 token contracts.
52  */
53 contract AbstractToken is Token, SafeMath {
54   /**
55    * Create new Abstract Token contract.
56    */
57   function AbstractToken () {
58     // Do nothing
59   }
60   
61   /**
62    * Get number of tokens currently belonging to given owner.
63    *
64    * @param _owner address to get number of tokens currently belonging to the
65    *        owner of
66    * @return number of tokens currently belonging to the owner of given address
67    */
68   function balanceOf(address _owner) constant returns (uint256 balance) {
69     return accounts [_owner];
70   }
71 
72   /**
73    * Transfer given number of tokens from message sender to given recipient.
74    *
75    * @param _to address to transfer tokens to the owner of
76    * @param _value number of tokens to transfer to the owner of given address
77    * @return true if tokens were transferred successfully, false otherwise
78    * accounts [_to] + _value > accounts [_to] for overflow check
79    * which is already in safeMath
80    */
81   function transfer(address _to, uint256 _value) returns (bool success) {
82     require(_to != address(0));
83     if (accounts [msg.sender] < _value) return false;
84     if (_value > 0 && msg.sender != _to) {
85       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
86       accounts [_to] = safeAdd (accounts [_to], _value);
87     }
88     emit Transfer (msg.sender, _to, _value);
89     return true;
90   }
91 
92   /**
93    * Transfer given number of tokens from given owner to given recipient.
94    *
95    * @param _from address to transfer tokens from the owner of
96    * @param _to address to transfer tokens to the owner of
97    * @param _value number of tokens to transfer from given owner to given
98    *        recipient
99    * @return true if tokens were transferred successfully, false otherwise
100    * accounts [_to] + _value > accounts [_to] for overflow check
101    * which is already in safeMath
102    */
103   function transferFrom(address _from, address _to, uint256 _value)
104   returns (bool success) {
105     require(_to != address(0));
106     if (allowances [_from][msg.sender] < _value) return false;
107     if (accounts [_from] < _value) return false; 
108 
109     if (_value > 0 && _from != _to) {
110 	  allowances [_from][msg.sender] = safeSub (allowances [_from][msg.sender], _value);
111       accounts [_from] = safeSub (accounts [_from], _value);
112       accounts [_to] = safeAdd (accounts [_to], _value);
113     }
114     emit Transfer(_from, _to, _value);
115     return true;
116   }
117 
118   /**
119    * Allow given spender to transfer given number of tokens from message sender.
120    * @param _spender address to allow the owner of to transfer tokens from message sender
121    * @param _value number of tokens to allow to transfer
122    * @return true if token transfer was successfully approved, false otherwise
123    */
124    function approve (address _spender, uint256 _value) returns (bool success) {
125     allowances [msg.sender][_spender] = _value;
126     emit Approval (msg.sender, _spender, _value);
127     return true;
128   }
129 
130   /**
131    * Tell how many tokens given spender is currently allowed to transfer from
132    * given owner.
133    *
134    * @param _owner address to get number of tokens allowed to be transferred
135    *        from the owner of
136    * @param _spender address to get number of tokens allowed to be transferred
137    *        by the owner of
138    * @return number of tokens given spender is currently allowed to transfer
139    *         from given owner
140    */
141   function allowance(address _owner, address _spender) constant
142   returns (uint256 remaining) {
143     return allowances [_owner][_spender];
144   }
145 
146   /**
147    * Mapping from addresses of token holders to the numbers of tokens belonging
148    * to these token holders.
149    */
150   mapping (address => uint256) accounts;
151 
152   /**
153    * Mapping from addresses of token holders to the mapping of addresses of
154    * spenders to the allowances set by these token holders to these spenders.
155    */
156   mapping (address => mapping (address => uint256)) private allowances;
157   
158 }
159 
160 
161 /**
162  * BTSM token smart contract.
163  */
164 contract BTSMToken is AbstractToken {
165   /**
166    * Maximum allowed number of tokens in circulation.
167    * tokenSupply = tokensIActuallyWant * (10 ^ decimals)
168    */
169    
170    
171   // uint256 constant MAX_TOKEN_COUNT = 200000000 * (10**3);
172   uint256 constant MAX_TOKEN_COUNT = 200000000; // * (10**3);
173   
174    
175   /**
176    * Address of the owner of this smart contract.
177    */
178   address private owner;
179   
180   /**
181    * Frozen account list holder
182    */
183   mapping (address => bool) private frozenAccount;
184 
185   /**
186    * Current number of tokens in circulation.
187    */
188   uint256 tokenCount = 0;
189   
190  
191   /**
192    * True if tokens transfers are currently frozen, false otherwise.
193    */
194   bool frozen = false;
195   
196  
197   /**
198    * Create new token smart contract and make msg.sender the
199    * owner of this smart contract.
200    */
201   function BTSMToken () {
202     owner = msg.sender;
203   }
204 
205   /**
206    * Get total number of tokens in circulation.
207    *
208    * @return total number of tokens in circulation
209    */
210   function totalSupply() constant returns (uint256 supply) {
211     return tokenCount;
212   }
213 
214   string constant public name = "Bitsmo Coin";
215   string constant public symbol = "BTSM";
216   uint8 constant public decimals = 0;
217   
218   /**
219    * Transfer given number of tokens from message sender to given recipient.
220    * @param _to address to transfer tokens to the owner of
221    * @param _value number of tokens to transfer to the owner of given address
222    * @return true if tokens were transferred successfully, false otherwise
223    */
224   function transfer(address _to, uint256 _value) returns (bool success) {
225     require(!frozenAccount[msg.sender]);
226 	if (frozen) return false;
227     else return AbstractToken.transfer (_to, _value);
228   }
229 
230   /**
231    * Transfer given number of tokens from given owner to given recipient.
232    *
233    * @param _from address to transfer tokens from the owner of
234    * @param _to address to transfer tokens to the owner of
235    * @param _value number of tokens to transfer from given owner to given
236    *        recipient
237    * @return true if tokens were transferred successfully, false otherwise
238    */
239   function transferFrom(address _from, address _to, uint256 _value)
240     returns (bool success) {
241 	require(!frozenAccount[_from]);
242     if (frozen) return false;
243     else return AbstractToken.transferFrom (_from, _to, _value);
244   }
245 
246    /**
247    * Change how many tokens given spender is allowed to transfer from message
248    * spender.  In order to prevent double spending of allowance,
249    * To change the approve amount you first have to reduce the addresses`
250    * allowance to zero by calling `approve(_spender, 0)` if it is not
251    * already 0 to mitigate the race condition described here:
252    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
253    * @param _spender address to allow the owner of to transfer tokens from
254    *        message sender
255    * @param _value number of tokens to allow to transfer
256    * @return true if token transfer was successfully approved, false otherwise
257    */
258   function approve (address _spender, uint256 _value)
259     returns (bool success) {
260 	require(allowance (msg.sender, _spender) == 0 || _value == 0);
261     return AbstractToken.approve (_spender, _value);
262   }
263 
264   /**
265    * Create _value new tokens and give new created tokens to msg.sender.
266    * May only be called by smart contract owner.
267    *
268    * @param _value number of tokens to create
269    * @return true if tokens were created successfully, false otherwise
270    */
271   function createTokens(uint256 _value)
272     returns (bool success) {
273     require (msg.sender == owner);
274 
275     if (_value > 0) {
276       if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;
277 	  
278       accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
279       tokenCount = safeAdd (tokenCount, _value);
280 	  
281 	  // adding transfer event and _from address as null address
282 	  emit Transfer(0x0, msg.sender, _value);
283 	  
284 	  return true;
285     }
286 	
287 	  return false;
288     
289   }
290   
291 
292   /**
293    * Set new owner for the smart contract.
294    * May only be called by smart contract owner.
295    *
296    * @param _newOwner address of new owner of the smart contract
297    */
298   function setOwner(address _newOwner) {
299     require (msg.sender == owner);
300 
301     owner = _newOwner;
302   }
303 
304   /**
305    * Freeze ALL token transfers.
306    * May only be called by smart contract owner.
307    */
308   function freezeTransfers () {
309     require (msg.sender == owner);
310 
311     if (!frozen) {
312       frozen = true;
313       emit Freeze ();
314     }
315   }
316 
317   /**
318    * Unfreeze ALL token transfers.
319    * May only be called by smart contract owner.
320    */
321   function unfreezeTransfers () {
322     require (msg.sender == owner);
323 
324     if (frozen) {
325       frozen = false;
326       emit Unfreeze ();
327     }
328   }
329   
330   
331   /*A user is able to unintentionally send tokens to a contract 
332   * and if the contract is not prepared to refund them they will get stuck in the contract. 
333   * The same issue used to happen for Ether too but new Solidity versions added the payable modifier to
334   * prevent unintended Ether transfers. However, there’s no such mechanism for token transfers.
335   * so the below function is created
336   */
337   
338   function refundTokens(address _token, address _refund, uint256 _value) {
339     require (msg.sender == owner);
340     require(_token != address(this));
341     AbstractToken token = AbstractToken(_token);
342     token.transfer(_refund, _value);
343     emit RefundTokens(_token, _refund, _value);
344   }
345   
346   /**
347    * Freeze specific account
348    * May only be called by smart contract owner.
349    */
350   function freezeAccount(address _target, bool freeze) {
351       require (msg.sender == owner);
352 	  require (msg.sender != _target);
353       frozenAccount[_target] = freeze;
354       emit FrozenFunds(_target, freeze);
355  }
356 
357   /**
358    * Logged when token transfers were frozen.
359    */
360   event Freeze ();
361 
362   /**
363    * Logged when token transfers were unfrozen.
364    */
365   event Unfreeze ();
366   
367   /**
368    * Logged when a particular account is frozen.
369    */
370   
371   event FrozenFunds(address target, bool frozen);
372 
373 
374   
375   /**
376    * when accidentally send other tokens are refunded
377    */
378   
379   event RefundTokens(address _token, address _refund, uint256 _value);
380 }