1 /*
2  * Creator: EnterCoin (ENTRC) 
3  */
4 
5 /*
6  * Abstract Token Smart Contract
7  *
8  */
9 
10  
11  /*
12  * Safe Math Smart Contract. 
13  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
14  */
15 
16 contract SafeMath {
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     if (a == 0) {
19       return 0;
20     }
21     uint256 c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 
46 
47 
48 /**
49  * ERC-20 standard token interface, as defined
50  * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.
51  */
52 contract Token {
53   
54   function totalSupply() public view returns (uint256 supply);
55   function balanceOf(address _owner)public view returns (uint256 balance);
56   function transfer(address _to, uint256 _value)public returns (bool success);
57   function transferFrom(address _from, address _to, uint256 _value)public returns (bool success);
58   function approve(address _spender, uint256 _value)public returns (bool success);
59   function allowance(address _owner, address _spender)public view returns (uint256 remaining);
60   event Transfer(address indexed _from, address indexed _to, uint256 _value);
61   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
62 }
63 
64 
65 
66 /**
67  * Abstract Token Smart Contract that could be used as a base contract for
68  * ERC-20 token contracts.
69  */
70 contract AbstractToken is Token, SafeMath {
71   /**
72    * Create new Abstract Token contract.
73    */
74  constructor() public{
75     // Do nothing
76   }
77   
78   /**
79    * Get number of tokens currently belonging to given owner.
80    *
81    * @param _owner address to get number of tokens currently belonging to the
82    *        owner of
83    * @return number of tokens currently belonging to the owner of given address
84    */
85   function balanceOf(address _owner) public view returns (uint256 balance) {
86     return accounts [_owner];
87   }
88 
89   /**
90    * Transfer given number of tokens from message sender to given recipient.
91    *
92    * @param _to address to transfer tokens to the owner of
93    * @param _value number of tokens to transfer to the owner of given address
94    * @return true if tokens were transferred successfully, false otherwise
95    * accounts [_to] + _value > accounts [_to] for overflow check
96    * which is already in safeMath
97    */
98   function transfer(address _to, uint256 _value) public returns (bool success) {
99     require(_to != address(0));
100     if (accounts [msg.sender] < _value) return false;
101     if (_value > 0 && msg.sender != _to) {
102       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
103       accounts [_to] = safeAdd (accounts [_to], _value);
104     }
105     emit Transfer (msg.sender, _to, _value);
106     return true;
107   }
108 
109   /**
110    * Transfer given number of tokens from given owner to given recipient.
111    *
112    * @param _from address to transfer tokens from the owner of
113    * @param _to address to transfer tokens to the owner of
114    * @param _value number of tokens to transfer from given owner to given
115    *        recipient
116    * @return true if tokens were transferred successfully, false otherwise
117    * accounts [_to] + _value > accounts [_to] for overflow check
118    * which is already in safeMath
119    */
120   function transferFrom(address _from, address _to, uint256 _value) public
121   returns (bool success) {
122     require(_to != address(0));
123     if (allowances [_from][msg.sender] < _value) return false;
124     if (accounts [_from] < _value) return false; 
125 
126     if (_value > 0 && _from != _to) {
127 	  allowances [_from][msg.sender] = safeSub (allowances [_from][msg.sender], _value);
128       accounts [_from] = safeSub (accounts [_from], _value);
129       accounts [_to] = safeAdd (accounts [_to], _value);
130     }
131     emit Transfer(_from, _to, _value);
132     return true;
133   }
134 
135   /**
136    * Allow given spender to transfer given number of tokens from message sender.
137    * @param _spender address to allow the owner of to transfer tokens from message sender
138    * @param _value number of tokens to allow to transfer
139    * @return true if token transfer was successfully approved, false otherwise
140    */
141    function approve (address _spender, uint256 _value) public returns (bool success) {
142     allowances [msg.sender][_spender] = _value;
143     emit Approval (msg.sender, _spender, _value);
144     return true;
145   }
146 
147   /**
148    * Tell how many tokens given spender is currently allowed to transfer from
149    * given owner.
150    *
151    * @param _owner address to get number of tokens allowed to be transferred
152    *        from the owner of
153    * @param _spender address to get number of tokens allowed to be transferred
154    *        by the owner of
155    * @return number of tokens given spender is currently allowed to transfer
156    *         from given owner
157    */
158   function allowance(address _owner, address _spender) public view
159   returns (uint256 remaining) {
160     return allowances [_owner][_spender];
161   }
162 
163   /**
164    * Mapping from addresses of token holders to the numbers of tokens belonging
165    * to these token holders.
166    */
167   mapping (address => uint256) accounts;
168 
169   /**
170    * Mapping from addresses of token holders to the mapping of addresses of
171    * spenders to the allowances set by these token holders to these spenders.
172    */
173   mapping (address => mapping (address => uint256)) private allowances;
174   
175 }
176 
177 
178 /**
179  * EnterCoin smart contract.
180  */
181 contract EnterCoin is AbstractToken {
182   /**
183    * Maximum allowed number of tokens in circulation.
184    * tokenSupply = tokensIActuallyWant * (10 ^ decimals)
185    */
186    
187    
188   uint256 constant MAX_TOKEN_COUNT = 31000000 * (10**8);
189    
190   /**
191    * Address of the owner of this smart contract.
192    */
193   address private owner;
194   
195  
196   /**
197    * Current number of tokens in circulation.
198    */
199   uint256 tokenCount = 0;
200   
201  
202   /**
203    * Create new token smart contract and make msg.sender the
204    * owner of this smart contract.
205    */
206   constructor() public{
207     owner = msg.sender;
208   }
209 
210   /**
211    * Get total number of tokens in circulation.
212    *
213    * @return total number of tokens in circulation
214    */
215   function totalSupply() public view returns (uint256 supply) {
216     return tokenCount;
217   }
218 
219   string constant public name = "EnterCoin";
220   string constant public symbol = "ENTRC";
221   uint8 constant public decimals = 8;
222   
223   /**
224    * Transfer given number of tokens from message sender to given recipient.
225    * @param _to address to transfer tokens to the owner of
226    * @param _value number of tokens to transfer to the owner of given address
227    * @return true if tokens were transferred successfully, false otherwise
228    */
229   function transfer(address _to, uint256 _value) public returns (bool success) {
230      return AbstractToken.transfer (_to, _value);
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
244     return AbstractToken.transferFrom (_from, _to, _value);
245   }
246 
247    /**
248    * Change how many tokens given spender is allowed to transfer from message
249    * spender.  In order to prevent double spending of allowance,
250    * To change the approve amount you first have to reduce the addresses`
251    * allowance to zero by calling `approve(_spender, 0)` if it is not
252    * already 0 to mitigate the race condition described here:
253    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
254    * @param _spender address to allow the owner of to transfer tokens from
255    *        message sender
256    * @param _value number of tokens to allow to transfer
257    * @return true if token transfer was successfully approved, false otherwise
258    */
259   function approve (address _spender, uint256 _value) public
260     returns (bool success) {
261 	require(allowance (msg.sender, _spender) == 0 || _value == 0);
262     return AbstractToken.approve (_spender, _value);
263   }
264 
265   /**
266    * Create _value new tokens and give new created tokens to msg.sender.
267    * Only be called by smart contract owner.
268    *
269    * @param _value number of tokens to create
270    * @return true if tokens were created successfully, false otherwise
271    */
272   function createTokens(uint256 _value) public
273     returns (bool success) {
274     require (msg.sender == owner);
275 
276     if (_value > 0) {
277       if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;
278 	  
279       accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
280       tokenCount = safeAdd (tokenCount, _value);
281 	  
282 	  // adding transfer event and _from address as null address
283 	  emit Transfer(address(0), msg.sender, _value);
284 	  
285 	  return true;
286     }
287 	
288 	  return false;
289     
290   }
291   
292   
293   
294   /**
295    * Set new owner for the smart contract.
296    * Only be called by smart contract owner.
297    *
298    * @param _newOwner address of new owner of the smart contract
299    */
300   function setOwner(address _newOwner) public{
301     require (msg.sender == owner);
302 
303     owner = _newOwner;
304   }
305   
306   
307   /*A user is able to unintentionally send tokens to a contract 
308   * and if the contract is not prepared to refund them they will get stuck in the contract. 
309   * The same issue used to happen for Ether too but new Solidity versions added the payable modifier to
310   * prevent unintended Ether transfers. However, there’s no such mechanism for token transfers.
311   * so the below function is created
312   */
313   
314   function refundTokens(address _token, address _refund, uint256 _value) public {
315     require (msg.sender == owner);
316     require(_token != address(this));
317     AbstractToken token = AbstractToken(_token);
318     token.transfer(_refund, _value);
319     emit RefundTokens(_token, _refund, _value);
320   }
321   
322   
323 
324   
325   /**
326    * when accidentally send other tokens are refunded
327    */
328   
329   event RefundTokens(address _token, address _refund, uint256 _value);
330 }