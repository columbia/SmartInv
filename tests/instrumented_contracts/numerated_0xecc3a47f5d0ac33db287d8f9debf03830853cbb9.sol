1 pragma solidity ^0.4.16;
2 
3 /**
4  * RIK Coin
5  * 
6  * RIK Coin powers a new generation of cancer treatment research.
7  *
8  * For more information, please visit http://rikcoin.io
9  */
10 
11 /**
12  * @title ERC20Basic
13  * @dev Simpler version of ERC20 interface
14  * @dev see https://github.com/ethereum/EIPs/issues/179
15  */
16 contract ERC20Basic {
17   function totalSupply() public view returns (uint256);
18   function balanceOf(address who) public view returns (uint256);
19   function transfer(address to, uint256 value) public returns (bool);
20   event Transfer(address indexed from, address indexed to, uint256 value);
21 }
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, throws on overflow.
31   */
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     if (a == 0) {
34       return 0;
35     }
36     uint256 c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return c;
49   }
50 
51   /**
52   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256) {
63     uint256 c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 /**
70  * @title Basic token
71  * @dev Basic version of StandardToken, with no allowances.
72  */
73 contract BasicToken is ERC20Basic {
74   using SafeMath for uint256;
75 
76   mapping(address => uint256) balances;
77 
78   uint256 totalSupply_;
79 
80   /**
81   * @dev total number of tokens in existence
82   */
83   function totalSupply() public view returns (uint256) {
84     return totalSupply_;
85   }
86 
87   /**
88   * @dev transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92   function transfer(address _to, uint256 _value) public returns (bool) {
93     require(_to != address(0));
94     require(_value <= balances[msg.sender]);
95 
96     // SafeMath.sub will throw if there is not enough balance.
97     balances[msg.sender] = balances[msg.sender].sub(_value);
98     balances[_to] = balances[_to].add(_value);
99     Transfer(msg.sender, _to, _value);
100     return true;
101   }
102 
103   /**
104   * @dev Gets the balance of the specified address.
105   * @param _owner The address to query the the balance of.
106   * @return An uint256 representing the amount owned by the passed address.
107   */
108   function balanceOf(address _owner) public view returns (uint256 balance) {
109     return balances[_owner];
110   }
111 
112 }
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 is ERC20Basic {
119   function allowance(address owner, address spender) public view returns (uint256);
120   function transferFrom(address from, address to, uint256 value) public returns (bool);
121   function approve(address spender, uint256 value) public returns (bool);
122   event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implementation of the basic standard token.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
131  */
132 contract StandardToken is ERC20, BasicToken {
133 
134   mapping (address => mapping (address => uint256)) internal allowed;
135 
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amount of tokens to be transferred
142    */
143   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
144     require(_to != address(0));
145     require(_value <= balances[_from]);
146     require(_value <= allowed[_from][msg.sender]);
147 
148     balances[_from] = balances[_from].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
151     Transfer(_from, _to, _value);
152     return true;
153   }
154 
155   /**
156    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
157    *
158    * Beware that changing an allowance with this method brings the risk that someone may use both the old
159    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162    * @param _spender The address which will spend the funds.
163    * @param _value The amount of tokens to be spent.
164    */
165   function approve(address _spender, uint256 _value) public returns (bool) {
166     allowed[msg.sender][_spender] = _value;
167     Approval(msg.sender, _spender, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Function to check the amount of tokens that an owner allowed to a spender.
173    * @param _owner address The address which owns the funds.
174    * @param _spender address The address which will spend the funds.
175    * @return A uint256 specifying the amount of tokens still available for the spender.
176    */
177   function allowance(address _owner, address _spender) public view returns (uint256) {
178     return allowed[_owner][_spender];
179   }
180 
181   /**
182    * @dev Increase the amount of tokens that an owner allowed to a spender.
183    *
184    * approve should be called when allowed[_spender] == 0. To increment
185    * allowed value is better to use this function to avoid 2 calls (and wait until
186    * the first transaction is mined)
187    * From MonolithDAO Token.sol
188    * @param _spender The address which will spend the funds.
189    * @param _addedValue The amount of tokens to increase the allowance by.
190    */
191   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
192     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
193     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194     return true;
195   }
196 
197   /**
198    * @dev Decrease the amount of tokens that an owner allowed to a spender.
199    *
200    * approve should be called when allowed[_spender] == 0. To decrement
201    * allowed value is better to use this function to avoid 2 calls (and wait until
202    * the first transaction is mined)
203    * From MonolithDAO Token.sol
204    * @param _spender The address which will spend the funds.
205    * @param _subtractedValue The amount of tokens to decrease the allowance by.
206    */
207   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
208     uint oldValue = allowed[msg.sender][_spender];
209     if (_subtractedValue > oldValue) {
210       allowed[msg.sender][_spender] = 0;
211     } else {
212       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
213     }
214     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215     return true;
216   }
217 
218 }
219 
220 /**
221  * @title Ownable
222  * @dev The Ownable contract has an owner address, and provides basic authorization control
223  * functions, this simplifies the implementation of "user permissions".
224  */
225 contract Ownable {
226   address public owner;
227 
228 
229   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
230 
231 
232   /**
233    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
234    * account.
235    */
236   function Ownable() public {
237     owner = msg.sender;
238   }
239 
240   /**
241    * @dev Throws if called by any account other than the owner.
242    */
243   modifier onlyOwner() {
244     require(msg.sender == owner);
245     _;
246   }
247 
248   /**
249    * @dev Allows the current owner to transfer control of the contract to a newOwner.
250    * @param newOwner The address to transfer ownership to.
251    */
252   function transferOwnership(address newOwner) public onlyOwner {
253     require(newOwner != address(0));
254     OwnershipTransferred(owner, newOwner);
255     owner = newOwner;
256   }
257 
258 }
259 
260 
261 contract RIKCoin is StandardToken, Ownable {
262   string public constant name = "RIK Coin";
263   string public constant symbol = "RIK";
264   uint256 public constant decimals = 18;
265 
266   uint256 public constant UNIT = 10 ** decimals;
267 
268   address public companyWallet;
269   address public backendWallet;
270 
271   uint256 public maxSupply = 40000000 * UNIT;
272   
273 
274   /**
275    * event for token purchase logging
276    * @param purchaser who paid for the tokens
277    * @param beneficiary who got the tokens
278    * @param value weis paid for purchase
279    * @param amount amount of tokens purchased
280    */
281   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
282 
283   modifier onlyBackend() {
284     require(msg.sender == backendWallet);
285     _;
286   }
287 
288   function RIKCoin(address _companyWallet, address _backendWallet) public {
289     companyWallet = _companyWallet;
290     backendWallet = _backendWallet;
291     balances[companyWallet] = 20000000 * UNIT;
292     totalSupply_ = totalSupply_.add(20000000 * UNIT);
293     Transfer(address(0x0), _companyWallet, 20000000 * UNIT);
294   }
295 
296   /**
297    * Change the backendWallet that is allowed to issue new tokens (used by server side)
298    * Or completely disabled backend unrevokable for all eternity by setting it to 0x0. Should be done after token sale completed.
299    */
300   function setBackendWallet(address _backendWallet) public onlyOwner {
301     if (backendWallet != address(0)) {
302       backendWallet = _backendWallet;
303     }
304   }
305 
306 
307   function() public payable {
308     revert();
309   }
310 
311   /***
312    * This function is used to transfer tokens that have been bought through other means (credit card, bitcoin, etc), and to burn tokens after the sale.
313    */
314   function mint(address receiver, uint256 tokens) public onlyBackend {
315     require(totalSupply_.add(tokens) <= maxSupply);
316 
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