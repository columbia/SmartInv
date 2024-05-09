1 pragma solidity 0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // 'ADG' token contract
5 //
6 //
7 // Symbol      : AD
8 // Name        : ASIAN DRAGON - A REVISION OF ASIAN DRAGON COIN (ADGN)
9 // Total supply: 500000000 - 500,000,000 - 5 Hundred Million
10 // 
11 //
12 // 
13 //
14 // (c) all rights reserve 2018.
15 // ----------------------------------------------------------------------------
16 
17 contract ReentrancyGuard {
18   uint256 private _guardCounter;
19 
20   constructor() internal {
21     // The counter starts at one to prevent changing it from zero to a non-zero value, which is a more expensive operation.
22     _guardCounter = 1;
23   }
24 
25   /**
26    * @dev Prevents a contract from calling itself, directly or indirectly.
27    * Calling a `nonReentrant` function from another `nonReentrant`
28    * function is not supported. It is possible to prevent this from happening
29    * by making the `nonReentrant` function external, and make it call a
30    * `private` function that does the actual work.
31    */
32   modifier nonReentrant() {
33     _guardCounter += 1;
34     uint256 localCounter = _guardCounter;
35     _;
36     require(localCounter == _guardCounter);
37   }
38 }
39 
40 
41 contract PublicData {
42     uint public health = 100;
43     uint internal mana = 50;
44     string private secret = "foo";
45 }
46 
47 contract auction {
48     address highestBidder;
49     uint highestBid;
50     mapping(address => uint) refunds;
51 
52     function bid() payable external {
53         require(msg.value >= highestBid);
54 
55         if (highestBidder != address(0)) {
56             refunds[highestBidder] += highestBid; // record the refund that this user can claim
57         }
58 
59         highestBidder = msg.sender;
60         highestBid = msg.value;
61     }
62 
63     function withdrawRefund() external {
64         uint refund = refunds[msg.sender];
65         refunds[msg.sender] = 0;
66         msg.sender.transfer(refund);
67     }
68 }
69 
70 /**
71  * @title SafeMath
72  * @dev Math operations with safety checks that throw on error
73  */
74 library SafeMath {
75 
76   /**
77   * @dev Multiplies two numbers, throws on overflow.
78   */
79   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
80     if (a == 0) {
81       return 0;
82     }
83     c = a * b;
84     assert(c / a == b);
85     return c;
86   }
87 
88   /**
89   * @dev Integer division of two numbers, truncating the quotient.
90   */
91   function div(uint256 a, uint256 b) internal pure returns (uint256) {
92     // assert(b > 0); // Solidity automatically throws when dividing by 0
93     // uint256 c = a / b;
94     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95     return a / b;
96   }
97 
98   /**
99   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
100   */
101   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102     assert(b <= a);
103     return a - b;
104   }
105 
106   /**
107   * @dev Adds two numbers, throws on overflow.
108   */
109   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
110     c = a + b;
111     assert(c >= a);
112     return c;
113   }
114 }
115 
116 
117 /**
118  * @title ERC20Basic
119  * @dev Simpler version of ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/179
121  */
122 contract ERC20Basic {
123   function totalSupply() public view returns (uint256);
124   function balanceOf(address who) public view returns (uint256);
125   function transfer(address to, uint256 value) public returns (bool);
126   event Transfer(address indexed from, address indexed to, uint256 value);
127 }
128 
129 /**
130  * @title ERC20 interface
131  * @dev see https://github.com/ethereum/EIPs/issues/20
132  */
133 contract ERC20 is ERC20Basic {
134   function allowance(address owner, address spender) public view returns (uint256);
135   function transferFrom(address from, address to, uint256 value) public returns (bool);
136   function approve(address spender, uint256 value) public returns (bool);
137   event Approval(address indexed owner, address indexed spender, uint256 value);
138 }
139 
140 /**
141  * @title Basic token
142  * @dev Basic version of StandardToken, with no allowances.
143  */
144 contract BasicToken is ERC20Basic {
145   using SafeMath for uint256;
146 
147   mapping(address => uint256) balances;
148 
149   uint256 totalSupply_;
150 
151   /**
152   * @dev total number of tokens in existence
153   */
154   function totalSupply() public view returns (uint256) {
155     return totalSupply_;
156   }
157 
158   /**
159   * @dev transfer token for a specified address
160   * @param _to The address to transfer to.
161   * @param _value The amount to be transferred.
162   */
163   function transfer(address _to, uint256 _value) public returns (bool) {
164     require(_to != address(0));
165     require(_value <= balances[msg.sender]);
166 
167     balances[msg.sender] = balances[msg.sender].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     emit Transfer(msg.sender, _to, _value);
170     return true;
171   }
172 
173   /**
174   * @dev Gets the balance of the specified address.
175   * @param _owner The address to query the the balance of.
176   * @return An uint256 representing the amount owned by the passed address.
177   */
178   function balanceOf(address _owner) public view returns (uint256) {
179     return balances[_owner];
180   }
181 
182 }
183 
184 
185 
186 /**
187  * @title Standard ERC20 token
188  *
189  * @dev Implementation of the basic standard token.
190  * @dev https://github.com/ethereum/EIPs/issues/20
191  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
192  */
193 contract StandardToken is ERC20, BasicToken {
194 
195   mapping (address => mapping (address => uint256)) internal allowed;
196 
197 
198   /**
199    * @dev Transfer tokens from one address to another
200    * @param _from address The address which you want to send tokens from
201    * @param _to address The address which you want to transfer to
202    * @param _value uint256 the amount of tokens to be transferred
203    */
204   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
205     require(_to != address(0));
206     require(_value <= balances[_from]);
207     require(_value <= allowed[_from][msg.sender]);
208 
209     balances[_from] = balances[_from].sub(_value);
210     balances[_to] = balances[_to].add(_value);
211     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
212     emit Transfer(_from, _to, _value);
213     return true;
214   }
215 
216   /**
217    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
218    *
219    * Beware that changing an allowance with this method brings the risk that someone may use both the old
220    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
221    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
222    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223    * @param _spender The address which will spend the funds.
224    * @param _value The amount of tokens to be spent.
225    */
226   function approve(address _spender, uint256 _value) public returns (bool) {
227     allowed[msg.sender][_spender] = _value;
228     emit Approval(msg.sender, _spender, _value);
229     return true;
230   }
231 
232   /**
233    * @dev Function to check the amount of tokens that an owner allowed to a spender.
234    * @param _owner address The address which owns the funds.
235    * @param _spender address The address which will spend the funds.
236    * @return A uint256 specifying the amount of tokens still available for the spender.
237    */
238   function allowance(address _owner, address _spender) public view returns (uint256) {
239     return allowed[_owner][_spender];
240   }
241 
242   /**
243    * @dev Increase the amount of tokens that an owner allowed to a spender.
244    *
245    * approve should be called when allowed[_spender] == 0. To increment
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    * @param _spender The address which will spend the funds.
250    * @param _addedValue The amount of tokens to increase the allowance by.
251    */
252   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
253     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
254     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258 
259 
260 
261   /**
262    * @dev Decrease the amount of tokens that an owner allowed to a spender.
263    *
264    * approve should be called when allowed[_spender] == 0. To decrement
265    * allowed value is better to use this function to avoid 2 calls (and wait until
266    * the first transaction is mined)
267    * From MonolithDAO Token.sol
268    * @param _spender The address which will spend the funds.
269    * @param _subtractedValue The amount of tokens to decrease the allowance by.
270    */
271   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
272     uint oldValue = allowed[msg.sender][_spender];
273     if (_subtractedValue > oldValue) {
274       allowed[msg.sender][_spender] = 0;
275     } else {
276       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
277     }
278     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
279     return true;
280   }
281 
282 }
283 
284 /**
285  * @title Asian Dragon Coin - A revision from Previous ADGN Deployed
286  * @dev Asian Dragon Coin ERC20 token. Implemented as an Solidity StandardToken.
287  */
288 
289 /** Public variables of the token */
290 
291  /**
292  NOTE:
293  The following variables are OPTIONAL vanities. One does not have to include them.
294  They allow one to customise the token contract & in no way influences the core functionality.
295  Some wallets/interfaces might not even bother to look at this information.
296  */
297  
298  
299 
300 contract Asiandragon is StandardToken {
301 
302   string public constant name = "Asian Dragon";
303   string public constant symbol = "AD";
304   string public version = 'H1.0'; //human 0.1 standard. Just an arbitrary versioning scheme.
305   uint8 public constant decimals = 8;
306   
307   uint256 public constant INITIAL_SUPPLY = 500000000 * (10 ** uint256(decimals));
308   
309   constructor() public {
310     totalSupply_ = INITIAL_SUPPLY;
311     balances[msg.sender] = INITIAL_SUPPLY;
312     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
313   }
314 
315 
316 
317  /**
318   * @dev Reentrancy.
319   */
320   
321 function withdraw(uint _amount) public {
322   if(balances[msg.sender] >= _amount) {
323     if(msg.sender.call.value(_amount)()) {
324       _amount;
325     }
326     balances[msg.sender] -= _amount;
327     }
328     
329 
330 }
331 }