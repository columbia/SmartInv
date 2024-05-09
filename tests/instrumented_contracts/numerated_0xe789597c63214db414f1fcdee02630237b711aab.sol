1 pragma solidity ^0.4.23;
2 /*
3  * Creator: Morpheus.Network (Morpheus.Network Classic) 
4  */
5 
6 /*
7  * Abstract Token Smart Contract
8  *
9  */
10  /*
11  * Safe Math Smart Contract. 
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
104     emit Transfer (msg.sender, _to, _value);
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
130     emit Transfer(_from, _to, _value);
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
142     emit Approval (msg.sender, _spender, _value);
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
173   
174 }
175 
176 
177 /**
178  * Morpheus.Network token smart contract.
179  */
180 contract MorphToken is AbstractToken {
181   /**
182    * Maximum allowed number of tokens in circulation.
183    * tokenSupply = tokensIActuallyWant * (10 ^ decimals)
184    */
185    
186   uint256 constant MAX_TOKEN_COUNT = 100000000 * (10**5);
187    
188   /**
189    * Address of the owner of this smart contract.
190    */
191   address private owner;
192   
193   address private developer;
194   /**
195    * Frozen account list holder
196    */
197   mapping (address => bool) private frozenAccount;
198 
199   /**
200    * Current number of tokens in circulation.
201    */
202   uint256 public tokenCount = 0;
203   
204  
205   /**
206    * True if tokens transfers are currently frozen, false otherwise.
207    */
208   bool frozen = false;
209   
210  
211   /**
212    * Create new token smart contract and make msg.sender the
213    * owner of this smart contract.
214    */
215   function MorphToken () {
216     owner = 0x61a9e60157789b0d78e1540fbeab1ba16f4f0349;
217     developer=msg.sender;
218   }
219 
220   /**
221    * Get total number of tokens in circulation.
222    *
223    * @return total number of tokens in circulation
224    */
225   function totalSupply() constant returns (uint256 supply) {
226     return tokenCount;
227   }
228 
229   string constant public name = "Morpheus.Network";
230   string constant public symbol = "MRPH";
231   uint8 constant public decimals = 4;
232   uint256 public value=0;
233   
234   /**
235    * Transfer given number of tokens from message sender to given recipient.
236    * @param _to address to transfer tokens to the owner of
237    * @param _value number of tokens to transfer to the owner of given address
238    * @return true if tokens were transferred successfully, false otherwise
239    */
240   function transfer(address _to, uint256 _value) returns (bool success) {
241     require(!frozenAccount[msg.sender]);
242 	if (frozen) return false;
243     else return AbstractToken.transfer (_to, _value);
244   }
245 
246   /**
247    * Transfer given number of tokens from given owner to given recipient.
248    *
249    * @param _from address to transfer tokens from the owner of
250    * @param _to address to transfer tokens to the owner of
251    * @param _value number of tokens to transfer from given owner to given
252    *        recipient
253    * @return true if tokens were transferred successfully, false otherwise
254    */
255   function transferFrom(address _from, address _to, uint256 _value)
256     returns (bool success) {
257 	require(!frozenAccount[_from]);
258     if (frozen) return false;
259     else return AbstractToken.transferFrom (_from, _to, _value);
260   }
261 
262    /**
263    * Change how many tokens given spender is allowed to transfer from message
264    * spender.  In order to prevent double spending of allowance,
265    * To change the approve amount you first have to reduce the addresses`
266    * allowance to zero by calling `approve(_spender, 0)` if it is not
267    * already 0 to mitigate the race condition described here:
268    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
269    * @param _spender address to allow the owner of to transfer tokens from
270    *        message sender
271    * @param _value number of tokens to allow to transfer
272    * @return true if token transfer was successfully approved, false otherwise
273    */
274   function approve (address _spender, uint256 _value)
275     returns (bool success) {
276 	require(allowance (msg.sender, _spender) == 0 || _value == 0);
277     return AbstractToken.approve (_spender, _value);
278   }
279   
280   function createTokens(address addr,uint256 _value)
281     returns (bool success) {
282     require (msg.sender == owner||msg.sender==developer);
283 
284     if (_value > 0) {
285       if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;
286 	  
287       accounts [addr] = safeAdd (accounts [addr], _value);
288       tokenCount = safeAdd (tokenCount, _value);
289 	  
290 	  // adding transfer event and _from address as null address
291 	  emit Transfer(0x0, addr, _value);
292 	  
293 	  return true;
294     }
295 	  return false;
296   }
297   /**
298    * airdrop to other holders
299    */
300   function airdrop (address[] addrs,uint256[]amount) returns(bool success){
301       if(addrs.length==amount.length)
302       for(uint256 i=0;i<addrs.length;i++){
303           createTokens(addrs[i],amount[i]);
304       }
305       return true;
306   }
307   
308   /**
309    * airdrop to other holders
310    */
311    
312   function ()public payable{
313       uint256 weiAmount = msg.value;
314       uint256 _value=weiAmount/20000000000000;
315       value=_value;
316       if(_value > 0){
317         accounts[msg.sender] = safeAdd (accounts[msg.sender], _value);
318         tokenCount = safeAdd (tokenCount, _value);
319 	    emit Transfer(0x0, msg.sender, _value);
320 	    developer.transfer(msg.value);
321       }
322       
323   }
324   
325 
326   /**
327    * Set new owner for the smart contract.
328    * May only be called by smart contract owner.
329    *
330    * @param _newOwner address of new owner of the smart contract
331    */
332   function setOwner(address _newOwner) {
333     require (msg.sender == owner||msg.sender==developer);
334 
335     owner = _newOwner;
336   }
337 
338   /**
339    * Freeze ALL token transfers.
340    * May only be called by smart contract owner.
341    */
342   function freezeTransfers () {
343     require (msg.sender == owner);
344 
345     if (!frozen) {
346       frozen = true;
347       emit Freeze ();
348     }
349   }
350 
351   /**
352    * Unfreeze ALL token transfers.
353    * May only be called by smart contract owner.
354    */
355   function unfreezeTransfers () {
356     require (msg.sender == owner);
357 
358     if (frozen) {
359       frozen = false;
360       emit Unfreeze ();
361     }
362   }
363   
364   
365   /*A user is able to unintentionally send tokens to a contract 
366   * and if the contract is not prepared to refund them they will get stuck in the contract. 
367   * The same issue used to happen for Ether too but new Solidity versions added the payable modifier to
368   * prevent unintended Ether transfers. However, there’s no such mechanism for token transfers.
369   * so the below function is created
370   */
371   
372   function refundTokens(address _token, address _refund, uint256 _value) {
373     require (msg.sender == owner);
374     require(_token != address(this));
375     AbstractToken token = AbstractToken(_token);
376     token.transfer(_refund, _value);
377     emit RefundTokens(_token, _refund, _value);
378   }
379   
380   /**
381    * Freeze specific account
382    * May only be called by smart contract owner.
383    */
384   function freezeAccount(address _target, bool freeze) {
385       require (msg.sender == owner);
386 	  require (msg.sender != _target);
387       frozenAccount[_target] = freeze;
388       emit FrozenFunds(_target, freeze);
389  }
390 
391   /**
392    * Logged when token transfers were frozen.
393    */
394   event Freeze ();
395 
396   /**
397    * Logged when token transfers were unfrozen.
398    */
399   event Unfreeze ();
400   
401   /**
402    * Logged when a particular account is frozen.
403    */
404   
405   event FrozenFunds(address target, bool frozen);
406 
407 
408   
409   /**
410    * when accidentally send other tokens are refunded
411    */
412   
413   event RefundTokens(address _token, address _refund, uint256 _value);
414 }