1 pragma solidity ^0.4.16;
2 
3 /**
4  * DNA Coin
5  * 
6  * Powering a next generation DNA Data Matching Platform
7  * 
8  * Copyright DNA TEMPLE International Limited. All rights reserved.
9  */
10 
11 
12 /**
13  * @title ERC20Basic
14  * @dev Simpler version of ERC20 interface
15  * @dev see https://github.com/ethereum/EIPs/issues/179
16  */
17 contract ERC20Basic {
18   function totalSupply() public view returns (uint256);
19   function balanceOf(address who) public view returns (uint256);
20   function transfer(address to, uint256 value) public returns (bool);
21   event Transfer(address indexed from, address indexed to, uint256 value);
22 }
23 
24 /**
25  * @title SafeMath
26  * @dev Math operations with safety checks that throw on error
27  */
28 library SafeMath {
29 
30   /**
31   * @dev Multiplies two numbers, throws on overflow.
32   */
33   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34     if (a == 0) {
35       return 0;
36     }
37     uint256 c = a * b;
38     assert(c / a == b);
39     return c;
40   }
41 
42   /**
43   * @dev Integer division of two numbers, truncating the quotient.
44   */
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     uint256 c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49     return c;
50   }
51 
52   /**
53   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
54   */
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   /**
61   * @dev Adds two numbers, throws on overflow.
62   */
63   function add(uint256 a, uint256 b) internal pure returns (uint256) {
64     uint256 c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 }
69 
70 /**
71  * @title Basic token
72  * @dev Basic version of StandardToken, with no allowances.
73  */
74 contract BasicToken is ERC20Basic {
75   using SafeMath for uint256;
76 
77   mapping(address => uint256) balances;
78 
79   uint256 totalSupply_;
80 
81   /**
82   * @dev total number of tokens in existence
83   */
84   function totalSupply() public view returns (uint256) {
85     return totalSupply_;
86   }
87 
88   /**
89   * @dev transfer token for a specified address
90   * @param _to The address to transfer to.
91   * @param _value The amount to be transferred.
92   */
93   function transfer(address _to, uint256 _value) public returns (bool) {
94     require(_to != address(0));
95     require(_value <= balances[msg.sender]);
96 
97     // SafeMath.sub will throw if there is not enough balance.
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256 balance) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 /**
116  * @title ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/20
118  */
119 contract ERC20 is ERC20Basic {
120   function allowance(address owner, address spender) public view returns (uint256);
121   function transferFrom(address from, address to, uint256 value) public returns (bool);
122   function approve(address spender, uint256 value) public returns (bool);
123   event Approval(address indexed owner, address indexed spender, uint256 value);
124 }
125 
126 /**
127  * @title Standard ERC20 token
128  *
129  * @dev Implementation of the basic standard token.
130  * @dev https://github.com/ethereum/EIPs/issues/20
131  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132  */
133 contract StandardToken is ERC20, BasicToken {
134 
135   mapping (address => mapping (address => uint256)) internal allowed;
136 
137 
138   /**
139    * @dev Transfer tokens from one address to another
140    * @param _from address The address which you want to send tokens from
141    * @param _to address The address which you want to transfer to
142    * @param _value uint256 the amount of tokens to be transferred
143    */
144   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[_from]);
147     require(_value <= allowed[_from][msg.sender]);
148 
149     balances[_from] = balances[_from].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152     Transfer(_from, _to, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    *
159    * Beware that changing an allowance with this method brings the risk that someone may use both the old
160    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
161    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
162    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163    * @param _spender The address which will spend the funds.
164    * @param _value The amount of tokens to be spent.
165    */
166   function approve(address _spender, uint256 _value) public returns (bool) {
167     allowed[msg.sender][_spender] = _value;
168     Approval(msg.sender, _spender, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Function to check the amount of tokens that an owner allowed to a spender.
174    * @param _owner address The address which owns the funds.
175    * @param _spender address The address which will spend the funds.
176    * @return A uint256 specifying the amount of tokens still available for the spender.
177    */
178   function allowance(address _owner, address _spender) public view returns (uint256) {
179     return allowed[_owner][_spender];
180   }
181 
182   /**
183    * @dev Increase the amount of tokens that an owner allowed to a spender.
184    *
185    * approve should be called when allowed[_spender] == 0. To increment
186    * allowed value is better to use this function to avoid 2 calls (and wait until
187    * the first transaction is mined)
188    * From MonolithDAO Token.sol
189    * @param _spender The address which will spend the funds.
190    * @param _addedValue The amount of tokens to increase the allowance by.
191    */
192   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
193     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
194     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198   /**
199    * @dev Decrease the amount of tokens that an owner allowed to a spender.
200    *
201    * approve should be called when allowed[_spender] == 0. To decrement
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _subtractedValue The amount of tokens to decrease the allowance by.
207    */
208   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
209     uint oldValue = allowed[msg.sender][_spender];
210     if (_subtractedValue > oldValue) {
211       allowed[msg.sender][_spender] = 0;
212     } else {
213       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214     }
215     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219 }
220 
221 /**
222  * @title Ownable
223  * @dev The Ownable contract has an owner address, and provides basic authorization control
224  * functions, this simplifies the implementation of "user permissions".
225  */
226 contract Ownable {
227   address public owner;
228 
229 
230   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
231 
232 
233   /**
234    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
235    * account.
236    */
237   function Ownable() public {
238     owner = msg.sender;
239   }
240 
241   /**
242    * @dev Throws if called by any account other than the owner.
243    */
244   modifier onlyOwner() {
245     require(msg.sender == owner);
246     _;
247   }
248 
249   /**
250    * @dev Allows the current owner to transfer control of the contract to a newOwner.
251    * @param newOwner The address to transfer ownership to.
252    */
253   function transferOwnership(address newOwner) public onlyOwner {
254     require(newOwner != address(0));
255     OwnershipTransferred(owner, newOwner);
256     owner = newOwner;
257   }
258 
259 }
260 
261 
262 
263 contract DNACoin is StandardToken, Ownable {
264   string public constant name = "DNA Coin";
265   string public constant symbol = "DNA";
266   uint256 public constant decimals = 18;
267 
268   uint256 public constant UNIT = 10 ** decimals;
269 
270   address public companyWallet;
271   address public backendWallet;
272 
273   uint256 public maxSupply = 1000000 * UNIT;
274   
275 
276   /**
277    * event for token purchase logging
278    * @param purchaser who paid for the tokens
279    * @param beneficiary who got the tokens
280    * @param value weis paid for purchase
281    * @param amount amount of tokens purchased
282    */
283   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
284 
285   modifier onlyBackend() {
286     require(msg.sender == backendWallet);
287     _;
288   }
289 
290   function DNACoin(address _companyWallet, address _backendWallet) public {
291     companyWallet = _companyWallet;
292     backendWallet = _backendWallet;
293     balances[companyWallet] = 500000 * UNIT;
294     totalSupply_ = totalSupply_.add(500000 * UNIT);
295     Transfer(address(0x0), _companyWallet, 500000 * UNIT);
296   }
297 
298   /**
299    * Change the backendWallet that is allowed to issue new tokens (used by server side)
300    * Or completely disabled backend unrevokable for all eternity by setting it to 0x0. Should be done after token sale completed.
301    */
302   function setBackendWallet(address _backendWallet) public onlyOwner {
303     if (backendWallet != address(0)) {
304       backendWallet = _backendWallet;
305     }
306   }
307 
308   function() public payable {
309     revert();
310   }
311 
312   /***
313    * This function is used to transfer tokens that have been bought through other means (credit card, bitcoin, etc), and to burn tokens after the sale.
314    */
315   function mint(address receiver, uint256 tokens) public onlyBackend {
316     require(totalSupply_ + tokens <= maxSupply);
317     balances[receiver] += tokens;
318     totalSupply_ += tokens;
319     Transfer(address(0x0), receiver, tokens);
320   }
321 
322   function sendBonus(address receiver, uint256 bonus) public onlyBackend {
323     Transfer(companyWallet, receiver, bonus);
324     balances[companyWallet] = balances[companyWallet].sub(bonus);
325     balances[receiver] = balances[receiver].add(bonus);
326   }
327 
328 }