1 pragma solidity ^0.4.18;
2 
3 
4 // CONTRACT USED TO TEST THE ICO CONTRACT
5 
6 
7 
8 
9 
10 
11 
12 /**
13  * @title ERC20Basic
14  * @dev Simpler version of ERC20 interface
15  * @dev see https://github.com/ethereum/EIPs/issues/179
16  */
17 contract ERC20Basic {
18   uint256 public totalSupply;
19   function balanceOf(address who) public view returns (uint256);
20   function transfer(address to, uint256 value) public returns (bool);
21   event Transfer(address indexed from, address indexed to, uint256 value);
22 }
23 
24 /**
25  * @title ERC20 interface
26  * @dev see https://github.com/ethereum/EIPs/issues/20
27  */
28 contract ERC20 is ERC20Basic {
29   function allowance(address owner, address spender) public view returns (uint256);
30   function transferFrom(address from, address to, uint256 value) public returns (bool);
31   function approve(address spender, uint256 value) public returns (bool);
32   event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 /**
36  * @title SafeMath
37  * @dev Math operations with safety checks that throw on error
38  */
39 library SafeMath {
40   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41     if (a == 0) {
42       return 0;
43     }
44     uint256 c = a * b;
45     assert(c / a == b);
46     return c;
47   }
48 
49   function div(uint256 a, uint256 b) internal pure returns (uint256) {
50     // assert(b > 0); // Solidity automatically throws when dividing by 0
51     uint256 c = a / b;
52     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53     return c;
54   }
55 
56   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57     assert(b <= a);
58     return a - b;
59   }
60 
61   function add(uint256 a, uint256 b) internal pure returns (uint256) {
62     uint256 c = a + b;
63     assert(c >= a);
64     return c;
65   }
66 }
67 
68 /**
69  * @title Basic token
70  * @dev Basic version of StandardToken, with no allowances.
71  */
72 contract BasicToken is ERC20Basic {
73   using SafeMath for uint256;
74 
75   mapping(address => uint256) balances;
76 
77   /**
78   * @dev transfer token for a specified address
79   * @param _to The address to transfer to.
80   * @param _value The amount to be transferred.
81   */
82   function transfer(address _to, uint256 _value) public returns (bool) {
83     require(_to != address(0));
84     require(_value <= balances[msg.sender]);
85 
86     // SafeMath.sub will throw if there is not enough balance.
87     balances[msg.sender] = balances[msg.sender].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   /**
94   * @dev Gets the balance of the specified address.
95   * @param _owner The address to query the the balance of.
96   * @return An uint256 representing the amount owned by the passed address.
97   */
98   function balanceOf(address _owner) public view returns (uint256 balance) {
99     return balances[_owner];
100   }
101 
102 }
103 
104 /**
105  * @title Standard ERC20 token
106  *
107  * @dev Implementation of the basic standard token.
108  * @dev https://github.com/ethereum/EIPs/issues/20
109  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
110  */
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) internal allowed;
114 
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124     require(_value <= balances[_from]);
125     require(_value <= allowed[_from][msg.sender]);
126 
127     balances[_from] = balances[_from].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
130     Transfer(_from, _to, _value);
131     return true;
132   }
133 
134   /**
135    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
136    *
137    * Beware that changing an allowance with this method brings the risk that someone may use both the old
138    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
139    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
140    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141    * @param _spender The address which will spend the funds.
142    * @param _value The amount of tokens to be spent.
143    */
144   function approve(address _spender, uint256 _value) public returns (bool) {
145     allowed[msg.sender][_spender] = _value;
146     Approval(msg.sender, _spender, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Function to check the amount of tokens that an owner allowed to a spender.
152    * @param _owner address The address which owns the funds.
153    * @param _spender address The address which will spend the funds.
154    * @return A uint256 specifying the amount of tokens still available for the spender.
155    */
156   function allowance(address _owner, address _spender) public view returns (uint256) {
157     return allowed[_owner][_spender];
158   }
159 
160   /**
161    * approve should be called when allowed[_spender] == 0. To increment
162    * allowed value is better to use this function to avoid 2 calls (and wait until
163    * the first transaction is mined)
164    * From MonolithDAO Token.sol
165    */
166   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
167     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
168     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171 
172   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
173     uint oldValue = allowed[msg.sender][_spender];
174     if (_subtractedValue > oldValue) {
175       allowed[msg.sender][_spender] = 0;
176     } else {
177       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
178     }
179     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180     return true;
181   }
182 
183 }
184 
185 
186 
187 contract IprontoToken is StandardToken {
188 
189   // Setting Token Name to Mango
190   string public constant name = "iPRONTO";
191 
192   // Setting Token Symbol to MGO
193   string public constant symbol = "IPR";
194 
195   // Setting Token Decimals to 18
196   uint8 public constant decimals = 18;
197 
198   // Setting Token Decimals to 45 Million
199   uint256 public constant INITIAL_SUPPLY = 45000000 * (1 ether / 1 wei);
200 
201   address public owner;
202 
203   // Flags address for KYC verrified.
204   mapping (address => bool) public validKyc;
205 
206   function IprontoToken() public{
207     totalSupply = INITIAL_SUPPLY;
208     balances[msg.sender] = INITIAL_SUPPLY;
209     owner = msg.sender;
210   }
211 
212   modifier onlyOwner() {
213     require(msg.sender == owner);
214     _;
215   }
216 
217   // Approving an address to tranfer tokens
218   function approveKyc(address[] _addrs)
219         public
220         onlyOwner
221         returns (bool)
222     {
223         uint len = _addrs.length;
224         while (len-- > 0) {
225             validKyc[_addrs[len]] = true;
226         }
227         return true;
228     }
229 
230   function isValidKyc(address _addr) public constant returns (bool){
231     return validKyc[_addr];
232   }
233 
234   function approve(address _spender, uint256 _value) public returns (bool) {
235     require(isValidKyc(msg.sender));
236     return super.approve(_spender, _value);
237   }
238 
239   function() public{
240     throw;
241   }
242 }
243 
244 
245 contract CrowdsaleiPRONTOLiveICO{
246   using SafeMath for uint256;
247   address public owner;
248 
249   // The token being sold
250   IprontoToken public token;
251 
252   // rate for one token in wei
253   uint256 public rate = 500; // 1 ether
254   uint256 public discountRatePreIco = 588; // 1 ether
255   uint256 public discountRateIco = 555; // 1 ether
256 
257   // funds raised in Wei
258   uint256 public weiRaised;
259 
260   // Funds pool
261   // Setting funds pool for PROMOTORS_POOL, PRIVATE_SALE_POOL, PRE_ICO_POOL and ICO_POOL
262   uint256 public constant PROMOTORS_POOL = 18000000 * (1 ether / 1 wei);
263   uint256 public constant PRIVATE_SALE_POOL = 3600000 * (1 ether / 1 wei);
264   uint256 public constant PRE_ICO_POOL = 6300000 * (1 ether / 1 wei);
265   uint256 public constant ICO_POOL = 17100000 * (1 ether / 1 wei);
266 
267   // Initilising tracking variables for Funds pool
268   uint256 public promotorSale = 0;
269   uint256 public privateSale = 0;
270   uint256 public preicoSale = 0;
271   uint256 public icoSale = 0;
272 
273   // Solidity event to notify the dashboard app about transfer
274   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
275 
276   // Contract constructor
277   function CrowdsaleiPRONTOLiveICO() public{
278     token = createTokenContract();
279     owner = msg.sender;
280   }
281 
282   // Creates ERC20 standard token
283   function createTokenContract() internal returns (IprontoToken) {
284     return new IprontoToken();
285   }
286 
287   modifier onlyOwner() {
288     require(msg.sender == owner);
289     _;
290   }
291 
292   // @return true if the transaction can buy tokens
293   function validPurchase(uint256 weiAmount, address beneficiary) internal view returns (bool) {
294     bool nonZeroPurchase = weiAmount != 0;
295     bool validAddress = beneficiary != address(0);
296     return nonZeroPurchase && validAddress;
297   }
298 
299   // Getter function to see all funds pool balances.
300   function availableTokenBalance(uint256 token_needed, uint8 mode)  internal view returns (bool){
301 
302     if (mode == 1) { // promotorSale
303       return ((promotorSale + token_needed) <= PROMOTORS_POOL );
304     }
305     else if (mode == 2) { // Closed Group
306       return ((privateSale + token_needed) <= PRIVATE_SALE_POOL);
307     }
308     else if (mode == 3) { // preicoSale
309       return ((preicoSale + token_needed) <= PRE_ICO_POOL);
310     }
311     else if (mode == 4) { // icoSale
312       return ((icoSale + token_needed) <= ICO_POOL);
313     }
314     else {
315       return false;
316     }
317   }
318 
319   // fallback function can be used to buy tokens
320   function () public payable {
321     throw;
322   }
323 
324   // Token transfer
325   function transferToken(address beneficiary, uint256 tokens, uint8 mode) onlyOwner public {
326     // Checking for valid purchase
327     require(validPurchase(tokens, beneficiary));
328     require(availableTokenBalance(tokens, mode));
329     // Execute token purchase
330     if(mode == 1){
331       promotorSale = promotorSale.add(tokens);
332     } else if(mode == 2) {
333       privateSale = privateSale.add(tokens);
334     } else if(mode == 3) {
335       preicoSale = preicoSale.add(tokens);
336     } else if(mode == 4) {
337       icoSale = icoSale.add(tokens);
338     } else {
339       throw;
340     }
341     token.transfer(beneficiary, tokens);
342     TokenPurchase(beneficiary, beneficiary, tokens, tokens);
343   }
344 
345   // Function to get balance of an address
346   function balanceOf(address _addr) public view returns (uint256 balance) {
347     return token.balanceOf(_addr);
348   }
349 
350   function setTokenPrice(uint256 _rate,uint256 _discountRatePreIco,uint256 _discountRateIco) onlyOwner public returns (bool){
351     rate = _rate; // 1 ether
352     discountRatePreIco = _discountRatePreIco; // 1 ether
353     discountRateIco = _discountRateIco; // 1 ether
354     return true;
355   }
356 }