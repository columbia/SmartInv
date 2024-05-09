1 pragma solidity ^0.4.18;
2 
3 //*****************************************************
4 // BOOMR Coin contract
5 // For LibLob, Zach Spoor, by Michael Hanna
6 // ****************************************************
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   function add(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a + b;
36     assert(c >= a);
37     return c;
38   }
39 }
40 
41 /**
42  * @title Ownable
43  * @dev The Ownable contract has an owner address, and provides basic authorization control
44  * functions, this simplifies the implementation of "user permissions".
45  */
46 contract Ownable {
47   address public owner;
48 
49 
50   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52 
53   /**
54    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55    * account.
56    */
57   function Ownable() public {
58     owner = msg.sender;
59   }
60 
61 
62   /**
63    * @dev Throws if called by any account other than the owner.
64    */
65   modifier onlyOwner() {
66     require(msg.sender == owner);
67     _;
68   }
69 
70 
71   /**
72    * @dev Allows the current owner to transfer control of the contract to a newOwner.
73    * @param newOwner The address to transfer ownership to.
74    */
75   function transferOwnership(address newOwner) public onlyOwner {
76     require(newOwner != address(0));
77     OwnershipTransferred(owner, newOwner);
78     owner = newOwner;
79   }
80 }
81 
82 /**
83  * @title Pausable
84  * @dev Base contract which allows children to implement an emergency stop mechanism.
85  */
86 contract Pausable is Ownable {
87   event Pause();
88   event Unpause();
89 
90   bool public paused = false;
91 
92 
93   /**
94    * @dev Modifier to make a function callable only when the contract is not paused.
95    */
96   modifier whenNotPaused() {
97     require(!paused);
98     _;
99   }
100 
101   /**
102    * @dev Modifier to make a function callable only when the contract is paused.
103    */
104   modifier whenPaused() {
105     require(paused);
106     _;
107   }
108 
109   /**
110    * @dev called by the owner to pause, triggers stopped state
111    */
112   function pause() onlyOwner whenNotPaused public {
113     paused = true;
114     Pause();
115   }
116 
117   /**
118    * @dev called by the owner to unpause, returns to normal state
119    */
120   function unpause() onlyOwner whenPaused public {
121     paused = false;
122     Unpause();
123   }
124 }
125 
126 /**
127  * @title ERC20Basic
128  * @dev Simpler version of ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/179
130  */
131 contract ERC20Basic {
132   uint256 public totalSupply;
133   function balanceOf(address who) public view returns (uint256);
134   function transfer(address to, uint256 value) public returns (bool);
135   event Transfer(address indexed from, address indexed to, uint256 value);
136 }
137 
138 /**
139  * @title Basic token
140  * @dev Basic version of StandardToken, with no allowances.
141  */
142 contract BasicToken is ERC20Basic {
143   using SafeMath for uint256;
144 
145   mapping(address => uint256) balances;
146 
147   /**
148   * @dev transfer token for a specified address
149   * @param _to The address to transfer to.
150   * @param _value The amount to be transferred.
151   */
152   function transfer(address _to, uint256 _value) public returns (bool) {
153     require(_to != address(0));
154     require(_value <= balances[msg.sender]);
155 
156     // SafeMath.sub will throw if there is not enough balance.
157     balances[msg.sender] = balances[msg.sender].sub(_value);
158     balances[_to] = balances[_to].add(_value);
159     Transfer(msg.sender, _to, _value);
160     return true;
161   }
162 
163   /**
164   * @dev Gets the balance of the specified address.
165   * @param _owner The address to query the the balance of.
166   * @return An uint256 representing the amount owned by the passed address.
167   */
168   function balanceOf(address _owner) public view returns (uint256 balance) {
169     return balances[_owner];
170   }
171 }
172 
173 /**
174  * @title ERC20 interface
175  * @dev see https://github.com/ethereum/EIPs/issues/20
176  */
177 contract ERC20 is ERC20Basic {
178   function allowance(address owner, address spender) public view returns (uint256);
179   function transferFrom(address from, address to, uint256 value) public returns (bool);
180   function approve(address spender, uint256 value) public returns (bool);
181   event Approval(address indexed owner, address indexed spender, uint256 value);
182 }
183 
184 /**
185  * @title Standard ERC20 token
186  *
187  * @dev Implementation of the basic standard token.
188  * @dev https://github.com/ethereum/EIPs/issues/20
189  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
190  */
191 contract StandardToken is ERC20, BasicToken {
192 
193   mapping (address => mapping (address => uint256)) internal allowed;
194 
195 
196   /**
197    * @dev Transfer tokens from one address to another
198    * @param _from address The address which you want to send tokens from
199    * @param _to address The address which you want to transfer to
200    * @param _value uint256 the amount of tokens to be transferred
201    */
202   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
203     require(_to != address(0));
204     require(_value <= balances[_from]);
205     require(_value <= allowed[_from][msg.sender]);
206 
207     balances[_from] = balances[_from].sub(_value);
208     balances[_to] = balances[_to].add(_value);
209     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
210     Transfer(_from, _to, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
216    *
217    * Beware that changing an allowance with this method brings the risk that someone may use both the old
218    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
219    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
220    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221    * @param _spender The address which will spend the funds.
222    * @param _value The amount of tokens to be spent.
223    */
224   function approve(address _spender, uint256 _value) public returns (bool) {
225     allowed[msg.sender][_spender] = _value;
226     Approval(msg.sender, _spender, _value);
227     return true;
228   }
229 
230   /**
231    * @dev Function to check the amount of tokens that an owner allowed to a spender.
232    * @param _owner address The address which owns the funds.
233    * @param _spender address The address which will spend the funds.
234    * @return A uint256 specifying the amount of tokens still available for the spender.
235    */
236   function allowance(address _owner, address _spender) public view returns (uint256) {
237     return allowed[_owner][_spender];
238   }
239 
240   /**
241    * approve should be called when allowed[_spender] == 0. To increment
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    */
246   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
247     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
248     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249     return true;
250   }
251 
252   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
253     uint oldValue = allowed[msg.sender][_spender];
254     if (_subtractedValue > oldValue) {
255       allowed[msg.sender][_spender] = 0;
256     } else {
257       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
258     }
259     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263 }
264 
265 /**
266  * @title Pausable token
267  *
268  * @dev StandardToken modified with pausable transfers.
269  **/
270 contract PausableToken is StandardToken, Pausable {
271 
272   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
273     return super.transfer(_to, _value);
274   }
275 
276   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
277     return super.transferFrom(_from, _to, _value);
278   }
279 
280   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
281     return super.approve(_spender, _value);
282   }
283 
284   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
285     return super.increaseApproval(_spender, _addedValue);
286   }
287 
288   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
289     return super.decreaseApproval(_spender, _subtractedValue);
290   }
291 }
292 
293 //*****************************************************
294 // * @title BoomrCoin
295 // * @dev  Initial supply is 500000000
296 //   Supply is intended to be fixed
297 //   by the owner if needed in the future.
298 //   StartMinting is added to the base class.
299 // ****************************************************
300 contract BoomrCoin is PausableToken {
301   string public name = "BOOMR COIN - LIBLOB";
302   string public symbol = "BMR";
303   uint256 public decimals = 18;
304   uint256 public constant INITIAL_SUPPLY = 500000000 * 10**18;
305 
306   /**
307    * @dev Contructor that gives msg.sender all of existing tokens.
308    */
309   function BoomrCoin() public{
310     totalSupply = INITIAL_SUPPLY;
311     balances[msg.sender] = INITIAL_SUPPLY;
312   }
313 }