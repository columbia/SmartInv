1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title Ownable contract - base contract with an owner
5  */
6 contract Ownable {
7   
8   address public owner;
9   address public newOwner;
10 
11   event OwnershipTransferred(address indexed _from, address indexed _to);
12   
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() public {
18     owner = msg.sender;
19   }
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     assert(msg.sender == owner);
26     _;
27   }
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param _newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address _newOwner) public onlyOwner {
34     assert(_newOwner != address(0));      
35     newOwner = _newOwner;
36   }
37 
38   /**
39    * @dev Accept transferOwnership.
40    */
41   function acceptOwnership() public {
42     if (msg.sender == newOwner) {
43       OwnershipTransferred(owner, newOwner);
44       owner = newOwner;
45     }
46   }
47 }
48 
49 
50 /**
51  * @title SafeMath
52  * @dev Math operations with safety checks that throw on error
53  */
54 contract SafeMath {
55 
56   function sub(uint256 x, uint256 y) internal constant returns (uint256) {
57     uint256 z = x - y;
58     assert(z <= x);
59 	  return z;
60   }
61 
62   function add(uint256 x, uint256 y) internal constant returns (uint256) {
63     uint256 z = x + y;
64 	  assert(z >= x);
65 	  return z;
66   }
67 	
68   function div(uint256 x, uint256 y) internal constant returns (uint256) {
69     uint256 z = x / y;
70 	  return z;
71   }
72 	
73   function mul(uint256 x, uint256 y) internal constant returns (uint256) {
74     uint256 z = x * y;
75     assert(x == 0 || z / x == y);
76     return z;
77   }
78 
79   function min(uint256 x, uint256 y) internal constant returns (uint256) {
80     uint256 z = x <= y ? x : y;
81 	  return z;
82   }
83 
84   function max(uint256 x, uint256 y) internal constant returns (uint256) {
85     uint256 z = x >= y ? x : y;
86 	  return z;
87   }
88 }
89 
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 {
96 	function totalSupply() public constant returns (uint);
97 	function balanceOf(address owner) public constant returns (uint);
98 	function allowance(address owner, address spender) public constant returns (uint);
99 	function transfer(address to, uint value) public returns (bool success);
100 	function transferFrom(address from, address to, uint value) public returns (bool success);
101 	function approve(address spender, uint value) public returns (bool success);
102 	function mint(address to, uint value) public returns (bool success);
103 	event Transfer(address indexed from, address indexed to, uint value);
104 	event Approval(address indexed owner, address indexed spender, uint value);
105 }
106 
107 
108 /**
109  * @title Standard ERC20 token
110  * @dev Implementation of the basic standard token.
111  * @dev https://github.com/ethereum/EIPs/issues/20
112  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
113  */
114 contract StandardToken is ERC20, SafeMath, Ownable{
115 	
116   uint256 _totalSupply;
117   mapping (address => uint256) balances;
118   mapping (address => mapping (address => uint256)) approvals;
119   address public crowdsaleAgent;
120   bool public released = false;  
121   
122   /**
123    * @dev Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/
124    * @param numwords payload size  
125    */
126   modifier onlyPayloadSize(uint numwords) {
127     assert(msg.data.length == numwords * 32 + 4);
128     _;
129   }
130   
131   /**
132    * @dev The function can be called only by crowdsale agent.
133    */
134   modifier onlyCrowdsaleAgent() {
135     assert(msg.sender == crowdsaleAgent);
136     _;
137   }
138 
139   /** Limit token mint after finishing crowdsale
140    * @dev Make sure we are not done yet.
141    */
142   modifier canMint() {
143     assert(!released);
144     _;
145   }
146   
147   /**
148    * @dev Limit token transfer until the crowdsale is over.
149    */
150   modifier canTransfer() {
151     assert(released);
152     _;
153   } 
154   
155   /** 
156    * @dev Total Supply
157    * @return _totalSupply 
158    */  
159   function totalSupply() public constant returns (uint256) {
160     return _totalSupply;
161   }
162   
163   /** 
164    * @dev Tokens balance
165    * @param _owner holder address
166    * @return balance amount 
167    */
168   function balanceOf(address _owner) public constant returns (uint256) {
169     return balances[_owner];
170   }
171   
172   /** 
173    * @dev Token allowance
174    * @param _owner holder address
175    * @param _spender spender address
176    * @return remain amount
177    */   
178   function allowance(address _owner, address _spender) public constant returns (uint256) {
179     return approvals[_owner][_spender];
180   }
181 
182   /** 
183    * @dev Tranfer tokens to address
184    * @param _to dest address
185    * @param _value tokens amount
186    * @return transfer result
187    */   
188   function transfer(address _to, uint _value) public canTransfer onlyPayloadSize(2) returns (bool success) {
189     assert(balances[msg.sender] >= _value);
190     balances[msg.sender] = sub(balances[msg.sender], _value);
191     balances[_to] = add(balances[_to], _value);
192     
193     Transfer(msg.sender, _to, _value);
194     return true;
195   }
196   
197   /**    
198    * @dev Tranfer tokens from one address to other
199    * @param _from source address
200    * @param _to dest address
201    * @param _value tokens amount
202    * @return transfer result
203    */    
204   function transferFrom(address _from, address _to, uint _value) public canTransfer onlyPayloadSize(3) returns (bool success) {
205     assert(balances[_from] >= _value);
206     assert(approvals[_from][msg.sender] >= _value);
207     approvals[_from][msg.sender] = sub(approvals[_from][msg.sender], _value);
208     balances[_from] = sub(balances[_from], _value);
209     balances[_to] = add(balances[_to], _value);
210     
211     Transfer(_from, _to, _value);
212     return true;
213   }
214   
215   /** 
216    * @dev Approve transfer
217    * @param _spender holder address
218    * @param _value tokens amount
219    * @return result  
220    */
221   function approve(address _spender, uint _value) public onlyPayloadSize(2) returns (bool success) {
222     // To change the approve amount you first have to reduce the addresses`
223     //  approvals to zero by calling `approve(_spender, 0)` if it is not
224     //  already 0 to mitigate the race condition described here:
225     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
226     assert((_value == 0) || (approvals[msg.sender][_spender] == 0));
227     approvals[msg.sender][_spender] = _value;
228     
229     Approval(msg.sender, _spender, _value);
230     return true;
231   }
232   
233   /** 
234    * @dev Create new tokens and allocate them to an address. Only callably by a crowdsale contract
235    * @param _to dest address
236    * @param _value tokens amount
237    * @return mint result
238    */ 
239   function mint(address _to, uint _value) public onlyCrowdsaleAgent canMint onlyPayloadSize(2) returns (bool success) {
240     _totalSupply = add(_totalSupply, _value);
241     balances[_to] = add(balances[_to], _value);
242     
243     Transfer(0, _to, _value);
244     return true;
245   }
246   
247   /**
248    * @dev Set the contract that can call release and make the token transferable.
249    * @param _crowdsaleAgent crowdsale contract address
250    */
251   function setCrowdsaleAgent(address _crowdsaleAgent) public onlyOwner {
252     assert(!released);
253     crowdsaleAgent = _crowdsaleAgent;
254   }
255   
256   /**
257    * @dev One way function to release the tokens to the wild. Can be called only from the release agent that is the final ICO contract. 
258    */
259   function releaseTokenTransfer() public onlyCrowdsaleAgent {
260     released = true;
261   }
262 }
263 
264 
265 /** 
266  * @title DAOPlayMarket2.0 contract - standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
267  */
268 contract DAOPlayMarketToken is StandardToken {
269   
270   string public name;
271   string public symbol;
272   uint public decimals;
273   
274   /** Name and symbol were updated. */
275   event UpdatedTokenInformation(string newName, string newSymbol);
276 
277   /**
278    * Construct the token.
279    *
280    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
281    *
282    * @param _name Token name
283    * @param _symbol Token symbol - should be all caps
284    * @param _initialSupply How many tokens we start with
285    * @param _decimals Number of decimal places
286    * @param _addr Address for team's tokens
287    */
288    
289   function DAOPlayMarketToken(string _name, string _symbol, uint _initialSupply, uint _decimals, address _addr) public {
290     require(_addr != 0x0);
291     name = _name;
292     symbol = _symbol;
293     decimals = _decimals;
294 	
295     _totalSupply = _initialSupply*10**_decimals;
296 
297     // Creating initial tokens
298     balances[_addr] = _totalSupply;
299   }   
300   
301    /**
302    * Owner can update token information here.
303    *
304    * It is often useful to conceal the actual token association, until
305    * the token operations, like central issuance or reissuance have been completed.
306    *
307    * This function allows the token owner to rename the token after the operations
308    * have been completed and then point the audience to use the token contract.
309    */
310   function setTokenInformation(string _name, string _symbol) public onlyOwner {
311     name = _name;
312     symbol = _symbol;
313 
314     UpdatedTokenInformation(name, symbol);
315   }
316 
317 }