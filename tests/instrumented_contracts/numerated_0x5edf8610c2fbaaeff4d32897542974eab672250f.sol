1 pragma solidity ^0.5.10;
2 
3 /*
4  * Creator: TRIGX 
5 
6 /*
7  * Abstract Token Smart Contract
8  *
9  */
10 
11  
12  /*
13  * Safe Math Smart Contract. 
14  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
15  */
16 
17 contract SafeMath {
18   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19     if (a == 0) {
20       return 0;
21     }
22     uint256 c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 
47 
48 
49 /**
50  * ERC-20 standard token interface, as defined
51  * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.
52  */
53 contract Token {
54   
55   function totalSupply() public view returns (uint256 supply);
56   function balanceOf(address _owner) public view returns (uint256 balance);
57   function transfer(address _to, uint256 _value) public returns (bool success);
58   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
59   function approve(address _spender, uint256 _value) public returns (bool success);
60   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
61   event Transfer(address indexed _from, address indexed _to, uint256 _value);
62   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
63 }
64 
65 
66 
67 /**
68  * Abstract Token Smart Contract that could be used as a base contract for
69  * ERC-20 token contracts.
70  */
71 contract AbstractToken is Token, SafeMath {
72   /**
73    * Create new Abstract Token contract.
74    */
75   constructor () public {
76     // Do nothing
77   }
78   
79   /**
80    * Get number of tokens currently belonging to given owner.
81    *
82    * @param _owner address to get number of tokens currently belonging to the
83    *        owner of
84    * @return number of tokens currently belonging to the owner of given address
85    */
86   function balanceOf(address _owner) public view returns (uint256 balance) {
87     return accounts [_owner];
88   }
89 
90   /**
91    * Transfer given number of tokens from message sender to given recipient.
92    *
93    * @param _to address to transfer tokens to the owner of
94    * @param _value number of tokens to transfer to the owner of given address
95    * @return true if tokens were transferred successfully, false otherwise
96    * accounts [_to] + _value > accounts [_to] for overflow check
97    * which is already in safeMath
98    */
99   function transfer(address _to, uint256 _value) public returns (bool success) {
100     require(_to != address(0));
101     if (accounts [msg.sender] < _value) return false;
102     if (_value > 0 && msg.sender != _to) {
103       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
104       accounts [_to] = safeAdd (accounts [_to], _value);
105     }
106     emit Transfer (msg.sender, _to, _value);
107     return true;
108   }
109 
110   /**
111    * Transfer given number of tokens from given owner to given recipient.
112    *
113    * @param _from address to transfer tokens from the owner of
114    * @param _to address to transfer tokens to the owner of
115    * @param _value number of tokens to transfer from given owner to given
116    *        recipient
117    * @return true if tokens were transferred successfully, false otherwise
118    * accounts [_to] + _value > accounts [_to] for overflow check
119    * which is already in safeMath
120    */
121   function transferFrom(address _from, address _to, uint256 _value) public
122   returns (bool success) {
123     require(_to != address(0));
124     if (allowances [_from][msg.sender] < _value) return false;
125     if (accounts [_from] < _value) return false; 
126 
127     if (_value > 0 && _from != _to) {
128 	  allowances [_from][msg.sender] = safeSub (allowances [_from][msg.sender], _value);
129       accounts [_from] = safeSub (accounts [_from], _value);
130       accounts [_to] = safeAdd (accounts [_to], _value);
131     }
132     emit Transfer(_from, _to, _value);
133     return true;
134   }
135 
136   /**
137    * Allow given spender to transfer given number of tokens from message sender.
138    * @param _spender address to allow the owner of to transfer tokens from message sender
139    * @param _value number of tokens to allow to transfer
140    * @return true if token transfer was successfully approved, false otherwise
141    */
142    function approve (address _spender, uint256 _value) public returns (bool success) {
143     allowances [msg.sender][_spender] = _value;
144     emit Approval (msg.sender, _spender, _value);
145     return true;
146   }
147 
148   /**
149    * Tell how many tokens given spender is currently allowed to transfer from
150    * given owner.
151    *
152    * @param _owner address to get number of tokens allowed to be transferred
153    *        from the owner of
154    * @param _spender address to get number of tokens allowed to be transferred
155    *        by the owner of
156    * @return number of tokens given spender is currently allowed to transfer
157    *         from given owner
158    */
159   function allowance(address _owner, address _spender) public view
160   returns (uint256 remaining) {
161     return allowances [_owner][_spender];
162   }
163 
164   /**
165    * Mapping from addresses of token holders to the numbers of tokens belonging
166    * to these token holders.
167    */
168   mapping (address => uint256) accounts;
169 
170   /**
171    * Mapping from addresses of token holders to the mapping of addresses of
172    * spenders to the allowances set by these token holders to these spenders.
173    */
174   mapping (address => mapping (address => uint256)) private allowances;
175   
176 }
177 
178 
179 /**
180  * TRIGX smart contract.
181  */
182 contract TRIGX is AbstractToken {
183   /**
184    * Maximum allowed number of tokens in circulation.
185    * tokenSupply = tokensIActuallyWant * (10 ^ decimals)
186    */
187    
188    
189   uint256 constant MAX_TOKEN_COUNT = 32105577 * (10**18);
190    
191   /**
192    * Address of the owner of this smart contract.
193    */
194   address private owner;
195   
196   /**
197    * Current number of tokens in circulation.
198    */
199   uint256 tokenCount = 0;
200   
201  
202   /**
203    * True if tokens transfers are currently frozen, false otherwise.
204    */
205   bool frozen = false;
206   
207  
208   /**
209    * Create new token smart contract and make msg.sender the
210    * owner of this smart contract.
211    */
212   constructor () public {
213     owner = msg.sender;
214   }
215 
216   /**
217    * Get total number of tokens in circulation.
218    *
219    * @return total number of tokens in circulation
220    */
221   function totalSupply() public view returns (uint256 supply) {
222     return tokenCount;
223   }
224 
225   string constant public name = "TRIGX";
226   string constant public symbol = "Trigx";
227   uint8 constant public decimals = 18;
228   
229   /**
230    * Transfer given number of tokens from message sender to given recipient.
231    * @param _to address to transfer tokens to the owner of
232    * @param _value number of tokens to transfer to the owner of given address
233    * @return true if tokens were transferred successfully, false otherwise
234    */
235   function transfer(address _to, uint256 _value) public returns (bool success) {
236     return AbstractToken.transfer (_to, _value);
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
248   function transferFrom(address _from, address _to, uint256 _value) public
249     returns (bool success) {
250     return AbstractToken.transferFrom (_from, _to, _value);
251   }
252 
253    /**
254    * Change how many tokens given spender is allowed to transfer from message
255    * spender.  In order to prevent double spending of allowance,
256    * To change the approve amount you first have to reduce the addresses`
257    * allowance to zero by calling `approve(_spender, 0)` if it is not
258    * already 0 to mitigate the race condition described here:
259    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
260    * @param _spender address to allow the owner of to transfer tokens from
261    *        message sender
262    * @param _value number of tokens to allow to transfer
263    * @return true if token transfer was successfully approved, false otherwise
264    */
265   function approve (address _spender, uint256 _value) public
266     returns (bool success) {
267 	require(allowance (msg.sender, _spender) == 0 || _value == 0);
268     return AbstractToken.approve (_spender, _value);
269   }
270 
271   /**
272    * Create _value new tokens and give new created tokens to msg.sender.
273    * May only be called by smart contract owner.
274    *
275    * @param _value number of tokens to create
276    * @return true if tokens were created successfully, false otherwise
277    */
278   function createTokens(uint256 _value) public
279     returns (bool success) {
280     require (msg.sender == owner);
281 
282     if (_value > 0) {
283       if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;
284 	  
285       accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
286       tokenCount = safeAdd (tokenCount, _value);
287 	  
288 	  // adding transfer event and _from address as null address
289 	  emit Transfer(address(0), msg.sender, _value);
290 	  
291 	  return true;
292     }
293 	
294 	  return false;
295     
296   }
297   
298 
299   /**
300    * Burn intended tokens.
301    * Only be called by owner
302    *
303    * @param _value number of tokens to burn
304    * @return true if burnt successfully, false otherwise
305    */
306   
307   function burn(uint256 _value) public returns (bool success) {
308   
309         require(accounts[msg.sender] >= _value); 
310 		
311 		require (msg.sender == owner);
312 		
313 		accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
314 		
315         tokenCount = safeSub (tokenCount, _value);	
316 		
317         emit Burn(msg.sender, _value);
318 		
319         return true;
320     }
321   
322   
323 
324   /**
325    * Set new owner for the smart contract.
326    * May only be called by smart contract owner.
327    *
328    * @param _newOwner address of new owner of the smart contract
329    */
330   function setOwner(address _newOwner) public {
331     require (msg.sender == owner);
332 
333     owner = _newOwner;
334   }
335 
336   /**
337   * A user is able to unintentionally send tokens to a contract 
338   * and if the contract is not prepared to refund them they will get stuck in the contract. 
339   * The same issue used to happen for Ether too but new Solidity versions added the payable modifier to
340   * prevent unintended Ether transfers. However, there’s no such mechanism for token transfers.
341   * so the below function is created
342   */
343   
344   function refundTokens(address _token, address _refund, uint256 _value) public {
345     require (msg.sender == owner);
346     require(_token != address(this));
347     AbstractToken token = AbstractToken(_token);
348     token.transfer(_refund, _value);
349     emit RefundTokens(_token, _refund, _value);
350   }
351   
352   
353    /**
354    * Logged when a token is burnt.
355    */  
356   
357   event Burn(address target,uint256 _value);
358 
359 
360 
361   
362   /**
363    * when accidentally send other tokens are refunded
364    */
365   
366   event RefundTokens(address _token, address _refund, uint256 _value);
367 }