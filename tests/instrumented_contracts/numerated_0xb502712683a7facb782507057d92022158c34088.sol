1 pragma solidity ^0.4.24;
2 
3 /*
4  * Creator: CAREONCHAIN (REO) 
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
56   function totalSupply() constant returns (uint256 supply);
57   function balanceOf(address _owner) constant returns (uint256 balance);
58   function transfer(address _to, uint256 _value) returns (bool success);
59   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
60   function approve(address _spender, uint256 _value) returns (bool success);
61   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
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
76   function AbstractToken () {
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
87   function balanceOf(address _owner) constant returns (uint256 balance) {
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
100   function transfer(address _to, uint256 _value) returns (bool success) {
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
122   function transferFrom(address _from, address _to, uint256 _value)
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
143    function approve (address _spender, uint256 _value) returns (bool success) {
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
160   function allowance(address _owner, address _spender) constant
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
181  * CAREONCHAIN smart contract.
182  */
183 contract REOToken is AbstractToken {
184   /**
185    * Maximum allowed number of tokens in circulation.
186    * tokenSupply = tokensIActuallyWant * (10 ^ decimals)
187    */
188    
189    
190   uint256 constant MAX_TOKEN_COUNT = 360000000 * (10**18);
191    
192   /**
193    * Address of the owner of this smart contract.
194    */
195   address private owner;
196   
197   
198   /**
199    * Burning account list holder
200    */
201   
202   mapping (address => bool) private burningAccount;
203   
204 
205   /**
206    * Current number of tokens in circulation.
207    */
208   uint256 tokenCount = 0;
209   
210  
211   /**
212    * Create new token smart contract and make msg.sender the
213    * owner of this smart contract.
214    */
215   function REOToken () {
216     owner = msg.sender;
217   }
218 
219   /**
220    * Get total number of tokens in circulation.
221    *
222    * @return total number of tokens in circulation
223    */
224   function totalSupply() constant returns (uint256 supply) {
225     return tokenCount;
226   }
227 
228   string constant public name = "CAREONCHAIN";
229   string constant public symbol = "REO";
230   uint8 constant public decimals = 18;
231   
232   /**
233    * Transfer given number of tokens from message sender to given recipient.
234    * @param _to address to transfer tokens to the owner of
235    * @param _value number of tokens to transfer to the owner of given address
236    * @return true if tokens were transferred successfully, false otherwise
237    */
238   function transfer(address _to, uint256 _value) returns (bool success) {
239      return AbstractToken.transfer (_to, _value);
240   }
241 
242   /**
243    * Transfer given number of tokens from given owner to given recipient.
244    *
245    * @param _from address to transfer tokens from the owner of
246    * @param _to address to transfer tokens to the owner of
247    * @param _value number of tokens to transfer from given owner to given
248    *        recipient
249    * @return true if tokens were transferred successfully, false otherwise
250    */
251   function transferFrom(address _from, address _to, uint256 _value)
252     returns (bool success) {
253     return AbstractToken.transferFrom (_from, _to, _value);
254   }
255 
256    /**
257    * Change how many tokens given spender is allowed to transfer from message
258    * spender.  In order to prevent double spending of allowance,
259    * To change the approve amount you first have to reduce the addresses`
260    * allowance to zero by calling `approve(_spender, 0)` if it is not
261    * already 0 to mitigate the race condition described here:
262    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
263    * @param _spender address to allow the owner of to transfer tokens from
264    *        message sender
265    * @param _value number of tokens to allow to transfer
266    * @return true if token transfer was successfully approved, false otherwise
267    */
268   function approve (address _spender, uint256 _value)
269     returns (bool success) {
270 	require(allowance (msg.sender, _spender) == 0 || _value == 0);
271     return AbstractToken.approve (_spender, _value);
272   }
273 
274   /**
275    * Create _value new tokens and give new created tokens to msg.sender.
276    * Only be called by smart contract owner.
277    *
278    * @param _value number of tokens to create
279    * @return true if tokens were created successfully, false otherwise
280    */
281   function createTokens(uint256 _value)
282     returns (bool success) {
283     require (msg.sender == owner);
284 
285     if (_value > 0) {
286       if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;
287 	  
288       accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
289       tokenCount = safeAdd (tokenCount, _value);
290 	  
291 	  // adding transfer event and _from address as null address
292 	  emit Transfer(0x0, msg.sender, _value);
293 	  
294 	  return true;
295     }
296 	
297 	  return false;
298     
299   }
300   
301   
302  /**
303    * Burning capable account
304    * Only be called by smart contract owner.
305    */
306   function burningCapableAccount(address[] _target) {
307   
308       require (msg.sender == owner);
309 	  
310 	  for (uint i = 0; i < _target.length; i++) {
311 			burningAccount[_target[i]] = true;
312         }
313  }
314   
315   /**
316    * Burn intended tokens.
317    * Only be called by by burnable addresses.
318    *
319    * @param _value number of tokens to burn
320    * @return true if burnt successfully, false otherwise
321    */
322   
323   function burn(uint256 _value) public returns (bool success) {
324   
325         require(accounts[msg.sender] >= _value); 
326 		
327 		require(burningAccount[msg.sender]);
328 		
329 		accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
330 		
331         tokenCount = safeSub (tokenCount, _value);	
332 		
333         emit Burn(msg.sender, _value);
334 		
335         return true;
336     }
337   
338 
339   /**
340    * Set new owner for the smart contract.
341    * Only be called by smart contract owner.
342    *
343    * @param _newOwner address of new owner of the smart contract
344    */
345   function setOwner(address _newOwner) {
346     require (msg.sender == owner);
347 
348     owner = _newOwner;
349   }
350   
351   
352   /*A user is able to unintentionally send tokens to a contract 
353   * and if the contract is not prepared to refund them they will get stuck in the contract. 
354   * The same issue used to happen for Ether too but new Solidity versions added the payable modifier to
355   * prevent unintended Ether transfers. However, there’s no such mechanism for token transfers.
356   * so the below function is created
357   */
358   
359   function refundTokens(address _token, address _refund, uint256 _value) {
360     require (msg.sender == owner);
361     require(_token != address(this));
362     AbstractToken token = AbstractToken(_token);
363     token.transfer(_refund, _value);
364     emit RefundTokens(_token, _refund, _value);
365   }
366   
367   
368   /**
369    * Logged when a token is burnt.
370    */  
371   
372   event Burn(address target,uint256 _value);
373 
374   
375   /**
376    * when accidentally send other tokens are refunded
377    */
378   
379   event RefundTokens(address _token, address _refund, uint256 _value);
380 }