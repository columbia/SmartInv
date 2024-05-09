1 pragma solidity ^0.4.24;
2 
3 /*
4  * Creator: Peer 2 Peer Global Network (P2P) 
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
56   function totalSupply() public view returns (uint256 supply);
57   function balanceOf(address _owner)public view returns (uint256 balance);
58   function transfer(address _to, uint256 _value)public returns (bool success);
59   function transferFrom(address _from, address _to, uint256 _value)public returns (bool success);
60   function approve(address _spender, uint256 _value)public returns (bool success);
61   function allowance(address _owner, address _spender)public view returns (uint256 remaining);
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
76  constructor() public{
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
87   function balanceOf(address _owner) public view returns (uint256 balance) {
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
160   function allowance(address _owner, address _spender) public view
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
181  * Peer 2 Peer Global Network Smart Contract.
182  */
183 contract P2PToken is AbstractToken {
184   /**
185    * Maximum allowed number of tokens in circulation.
186    * tokenSupply = tokensIActuallyWant * (10 ^ decimals)
187    */
188    
189    
190   uint256 constant MAX_TOKEN_COUNT = 100000000 * (10**18);
191    
192   /**
193    * Address of the owner of this smart contract.
194    */
195   address private owner;
196   
197   /**
198    * Burning account list holder
199    */
200   
201   mapping (address => bool) private burningAccount;
202   
203  
204   /**
205    * Current number of tokens in circulation.
206    */
207   uint256 tokenCount = 0;
208   
209  
210   /**
211    * Create new token smart contract and make msg.sender the
212    * owner of this smart contract.
213    */
214   constructor() public{
215     owner = msg.sender;
216   }
217 
218   /**
219    * Get total number of tokens in circulation.
220    *
221    * @return total number of tokens in circulation
222    */
223   function totalSupply() public view returns (uint256 supply) {
224     return tokenCount;
225   }
226 
227   string constant public name = "Peer 2 Peer Global Network";
228   string constant public symbol = "P2P";
229   uint8 constant public decimals = 18;
230   
231   /**
232    * Transfer given number of tokens from message sender to given recipient.
233    * @param _to address to transfer tokens to the owner of
234    * @param _value number of tokens to transfer to the owner of given address
235    * @return true if tokens were transferred successfully, false otherwise
236    */
237   function transfer(address _to, uint256 _value) public returns (bool success) {
238      return AbstractToken.transfer (_to, _value);
239   }
240 
241   /**
242    * Transfer given number of tokens from given owner to given recipient.
243    *
244    * @param _from address to transfer tokens from the owner of
245    * @param _to address to transfer tokens to the owner of
246    * @param _value number of tokens to transfer from given owner to given
247    *        recipient
248    * @return true if tokens were transferred successfully, false otherwise
249    */
250   function transferFrom(address _from, address _to, uint256 _value) public
251     returns (bool success) {
252     return AbstractToken.transferFrom (_from, _to, _value);
253   }
254 
255    /**
256    * Change how many tokens given spender is allowed to transfer from message
257    * spender.  In order to prevent double spending of allowance,
258    * To change the approve amount you first have to reduce the addresses`
259    * allowance to zero by calling `approve(_spender, 0)` if it is not
260    * already 0 to mitigate the race condition described here:
261    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
262    * @param _spender address to allow the owner of to transfer tokens from
263    *        message sender
264    * @param _value number of tokens to allow to transfer
265    * @return true if token transfer was successfully approved, false otherwise
266    */
267   function approve (address _spender, uint256 _value) public
268     returns (bool success) {
269 	require(allowance (msg.sender, _spender) == 0 || _value == 0);
270     return AbstractToken.approve (_spender, _value);
271   }
272 
273   /**
274    * Create _value new tokens and give new created tokens to msg.sender.
275    * Only be called by smart contract owner.
276    *
277    * @param _value number of tokens to create
278    * @return true if tokens were created successfully, false otherwise
279    */
280   function createTokens(uint256 _value) public
281     returns (bool success) {
282     require (msg.sender == owner);
283 
284     if (_value > 0) {
285       if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;
286 	  
287       accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
288       tokenCount = safeAdd (tokenCount, _value);
289 	  
290 	  // adding transfer event and _from address as null address
291 	  emit Transfer(address(0), msg.sender, _value);
292 	  
293 	  return true;
294     }
295 	
296 	  return false;
297     
298   }
299   
300   /**
301    * Burning capable account
302    * Only be called by smart contract owner.
303    */
304   function burningCapableAccount(address[] _target) public {
305   
306       require (msg.sender == owner);
307 	  
308 	  for (uint i = 0; i < _target.length; i++) {
309 			burningAccount[_target[i]] = true;
310         }
311  }
312   
313   /**
314    * Burn intended tokens.
315    * Only be called by by burnable addresses.
316    *
317    * @param _value number of tokens to burn
318    * @return true if burnt successfully, false otherwise
319    */
320   
321   function burn(uint256 _value) public returns (bool success) {
322   
323         require(accounts[msg.sender] >= _value); 
324 		
325 		require(burningAccount[msg.sender]);
326 		
327 		accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
328 		
329         tokenCount = safeSub (tokenCount, _value);	
330 		
331         emit Burn(msg.sender, _value);
332 		
333         return true;
334     }
335   
336 
337   
338   
339   
340   /**
341    * Set new owner for the smart contract.
342    * Only be called by smart contract owner.
343    *
344    * @param _newOwner address of new owner of the smart contract
345    */
346   function setOwner(address _newOwner) public{
347     require (msg.sender == owner);
348 
349     owner = _newOwner;
350   }
351   
352   
353   /*A user is able to unintentionally send tokens to a contract 
354   * and if the contract is not prepared to refund them they will get stuck in the contract. 
355   * The same issue used to happen for Ether too but new Solidity versions added the payable modifier to
356   * prevent unintended Ether transfers. However, there’s no such mechanism for token transfers.
357   * so the below function is created
358   */
359   
360   function refundTokens(address _token, address _refund, uint256 _value) public {
361     require (msg.sender == owner);
362     require(_token != address(this));
363     AbstractToken token = AbstractToken(_token);
364     token.transfer(_refund, _value);
365     emit RefundTokens(_token, _refund, _value);
366   }
367   
368    /**
369    * Logged when a token is burnt.
370    */  
371   
372   event Burn(address target,uint256 _value);
373 
374 
375   
376   /**
377    * when accidentally send other tokens are refunded
378    */
379   
380   event RefundTokens(address _token, address _refund, uint256 _value);
381 }