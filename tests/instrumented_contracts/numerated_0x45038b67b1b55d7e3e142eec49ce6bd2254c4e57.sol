1 pragma solidity ^0.4.16;
2 
3 /**
4  * New Art Coin
5  *
6  * Invest into your future luxurious lifestyle.
7  *
8  * This is a luxurious token with the following properties:
9  *  - 300.000.000 coins max supply
10  *  - 150.000.000 coins mined for the company wallet
11  *  - Investors receive bonus coins from the company wallet during bonus phases
12  * 
13  * Visit https://newartcoin.io for more information and tokenholder benefits. 
14  * 
15  * Copyright New Art Coin Co., Ltd. All rights reserved.
16  */
17 
18 
19 /**
20  * @title ERC20Basic
21  * @dev Simpler version of ERC20 interface
22  * @dev see https://github.com/ethereum/EIPs/issues/179
23  */
24 contract ERC20Basic {
25   function totalSupply() public view returns (uint256);
26   function balanceOf(address who) public view returns (uint256);
27   function transfer(address to, uint256 value) public returns (bool);
28   event Transfer(address indexed from, address indexed to, uint256 value);
29 }
30 
31 /**
32  * @title SafeMath
33  * @dev Math operations with safety checks that throw on error
34  */
35 library SafeMath {
36 
37   /**
38   * @dev Multiplies two numbers, throws on overflow.
39   */
40   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41     if (a == 0) {
42       return 0;
43     }
44     uint256 c = a * b;
45     assert(c / a == b);
46     return c;
47   }
48 
49   /**
50   * @dev Integer division of two numbers, truncating the quotient.
51   */
52   function div(uint256 a, uint256 b) internal pure returns (uint256) {
53     // assert(b > 0); // Solidity automatically throws when dividing by 0
54     uint256 c = a / b;
55     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56     return c;
57   }
58 
59   /**
60   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
61   */
62   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63     assert(b <= a);
64     return a - b;
65   }
66 
67   /**
68   * @dev Adds two numbers, throws on overflow.
69   */
70   function add(uint256 a, uint256 b) internal pure returns (uint256) {
71     uint256 c = a + b;
72     assert(c >= a);
73     return c;
74   }
75 }
76 
77 /**
78  * @title Basic token
79  * @dev Basic version of StandardToken, with no allowances.
80  */
81 contract BasicToken is ERC20Basic {
82   using SafeMath for uint256;
83 
84   mapping(address => uint256) balances;
85 
86   uint256 totalSupply_;
87 
88   /**
89   * @dev total number of tokens in existence
90   */
91   function totalSupply() public view returns (uint256) {
92     return totalSupply_;
93   }
94 
95   /**
96   * @dev transfer token for a specified address
97   * @param _to The address to transfer to.
98   * @param _value The amount to be transferred.
99   */
100   function transfer(address _to, uint256 _value) public returns (bool) {
101     require(_to != address(0));
102     require(_value <= balances[msg.sender]);
103 
104     // SafeMath.sub will throw if there is not enough balance.
105     balances[msg.sender] = balances[msg.sender].sub(_value);
106     balances[_to] = balances[_to].add(_value);
107     Transfer(msg.sender, _to, _value);
108     return true;
109   }
110 
111   /**
112   * @dev Gets the balance of the specified address.
113   * @param _owner The address to query the the balance of.
114   * @return An uint256 representing the amount owned by the passed address.
115   */
116   function balanceOf(address _owner) public view returns (uint256 balance) {
117     return balances[_owner];
118   }
119 
120 }
121 
122 /**
123  * @title ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/20
125  */
126 contract ERC20 is ERC20Basic {
127   function allowance(address owner, address spender) public view returns (uint256);
128   function transferFrom(address from, address to, uint256 value) public returns (bool);
129   function approve(address spender, uint256 value) public returns (bool);
130   event Approval(address indexed owner, address indexed spender, uint256 value);
131 }
132 
133 /**
134  * @title Standard ERC20 token
135  *
136  * @dev Implementation of the basic standard token.
137  * @dev https://github.com/ethereum/EIPs/issues/20
138  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
139  */
140 contract StandardToken is ERC20, BasicToken {
141 
142   mapping (address => mapping (address => uint256)) internal allowed;
143 
144 
145   /**
146    * @dev Transfer tokens from one address to another
147    * @param _from address The address which you want to send tokens from
148    * @param _to address The address which you want to transfer to
149    * @param _value uint256 the amount of tokens to be transferred
150    */
151   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
152     require(_to != address(0));
153     require(_value <= balances[_from]);
154     require(_value <= allowed[_from][msg.sender]);
155 
156     balances[_from] = balances[_from].sub(_value);
157     balances[_to] = balances[_to].add(_value);
158     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
159     Transfer(_from, _to, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
165    *
166    * Beware that changing an allowance with this method brings the risk that someone may use both the old
167    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
168    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
169    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170    * @param _spender The address which will spend the funds.
171    * @param _value The amount of tokens to be spent.
172    */
173   function approve(address _spender, uint256 _value) public returns (bool) {
174     allowed[msg.sender][_spender] = _value;
175     Approval(msg.sender, _spender, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Function to check the amount of tokens that an owner allowed to a spender.
181    * @param _owner address The address which owns the funds.
182    * @param _spender address The address which will spend the funds.
183    * @return A uint256 specifying the amount of tokens still available for the spender.
184    */
185   function allowance(address _owner, address _spender) public view returns (uint256) {
186     return allowed[_owner][_spender];
187   }
188 
189   /**
190    * @dev Increase the amount of tokens that an owner allowed to a spender.
191    *
192    * approve should be called when allowed[_spender] == 0. To increment
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    * @param _spender The address which will spend the funds.
197    * @param _addedValue The amount of tokens to increase the allowance by.
198    */
199   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
200     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
201     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202     return true;
203   }
204 
205   /**
206    * @dev Decrease the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To decrement
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _subtractedValue The amount of tokens to decrease the allowance by.
214    */
215   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
216     uint oldValue = allowed[msg.sender][_spender];
217     if (_subtractedValue > oldValue) {
218       allowed[msg.sender][_spender] = 0;
219     } else {
220       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
221     }
222     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 
226 }
227 
228 /**
229  * @title Ownable
230  * @dev The Ownable contract has an owner address, and provides basic authorization control
231  * functions, this simplifies the implementation of "user permissions".
232  */
233 contract Ownable {
234   address public owner;
235 
236 
237   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
238 
239 
240   /**
241    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
242    * account.
243    */
244   function Ownable() public {
245     owner = msg.sender;
246   }
247 
248   /**
249    * @dev Throws if called by any account other than the owner.
250    */
251   modifier onlyOwner() {
252     require(msg.sender == owner);
253     _;
254   }
255 
256   /**
257    * @dev Allows the current owner to transfer control of the contract to a newOwner.
258    * @param newOwner The address to transfer ownership to.
259    */
260   function transferOwnership(address newOwner) public onlyOwner {
261     require(newOwner != address(0));
262     OwnershipTransferred(owner, newOwner);
263     owner = newOwner;
264   }
265 
266 }
267 
268 
269 
270 contract NARCoin is StandardToken, Ownable {
271   string public constant name = "New Art Coin";
272   string public constant symbol = "NAR";
273   uint256 public constant decimals = 18;
274 
275   uint256 public constant UNIT = 10 ** decimals;
276 
277   address public companyWallet;
278   address public backendWallet;
279 
280   uint256 public maxSupply = 300000000 * UNIT;
281 
282   /**
283    * event for token purchase logging
284    * @param purchaser who paid for the tokens
285    * @param beneficiary who got the tokens
286    * @param value weis paid for purchase
287    * @param amount amount of tokens purchased
288    */
289   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
290 
291   modifier onlyBackend() {
292     require(msg.sender == backendWallet);
293     _;
294   }
295 
296   function NARCoin(address _companyWallet, address _backendWallet) public {
297     companyWallet = _companyWallet;
298     backendWallet = _backendWallet;
299     balances[companyWallet] = 150000000 * UNIT;
300     totalSupply_ = totalSupply_.add(150000000 * UNIT);
301     Transfer(address(0x0), _companyWallet, 150000000 * UNIT);
302   }
303 
304   /**
305    * Change the backendWallet that is allowed to issue new tokens (used by server side)
306    * Or completely disabled backend unrevokable for all eternity by setting it to 0x0
307    */
308   function setBackendWallet(address _backendWallet) public onlyOwner {
309     require(backendWallet != address(0));
310     backendWallet = _backendWallet;
311   }
312 
313   function() public payable {
314     revert();
315   }
316 
317   /***
318    * This function is used to transfer tokens that have been bought through other means (credit card, bitcoin, etc), and to burn tokens after the sale.
319    */
320   function mint(address receiver, uint256 tokens) public onlyBackend {
321     require(totalSupply_ + tokens <= maxSupply);
322 
323     balances[receiver] += tokens;
324     totalSupply_ += tokens;
325     Transfer(address(0x0), receiver, tokens);
326   }
327 
328   function sendBonus(address receiver, uint256 bonus) public onlyBackend {
329     Transfer(companyWallet, receiver, bonus);
330     balances[companyWallet] = balances[companyWallet].sub(bonus);
331     balances[receiver] = balances[receiver].add(bonus);
332   }
333 
334 }