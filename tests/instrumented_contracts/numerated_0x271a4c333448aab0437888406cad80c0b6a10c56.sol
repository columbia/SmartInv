1 pragma solidity 0.4.21;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address owner, address spender) public view returns (uint256);
23   function transferFrom(address from, address to, uint256 value) public returns (bool);
24   function approve(address spender, uint256 value) public returns (bool);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 /**
29  * @title Basic token
30  * @dev Basic version of StandardToken, with no allowances.
31  */
32 contract BasicToken is ERC20Basic {
33   using SafeMath for uint256;
34 
35   mapping(address => uint256) balances;
36 
37   uint256 totalSupply_;
38 
39   /**
40   * @dev total number of tokens in existence
41   */
42   function totalSupply() public view returns (uint256) {
43     return totalSupply_;
44   }
45 
46   /**
47   * @dev transfer token for a specified address
48   * @param _to The address to transfer to.
49   * @param _value The amount to be transferred.
50   */
51   function transfer(address _to, uint256 _value) public returns (bool) {
52     require(_to != address(0));
53     require(_value <= balances[msg.sender]);
54 
55     // SafeMath.sub will throw if there is not enough balance.
56     balances[msg.sender] = balances[msg.sender].sub(_value);
57     balances[_to] = balances[_to].add(_value);
58     Transfer(msg.sender, _to, _value);
59     return true;
60   }
61 
62   /**
63   * @dev Gets the balance of the specified address.
64   * @param _owner The address to query the the balance of.
65   * @return An uint256 representing the amount owned by the passed address.
66   */
67   function balanceOf(address _owner) public view returns (uint256 balance) {
68     return balances[_owner];
69   }
70 
71 }
72 
73 
74 /**
75  * @title Standard ERC20 token
76  *
77  * @dev Implementation of the basic standard token.
78  * @dev https://github.com/ethereum/EIPs/issues/20
79  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
80  */
81 contract StandardToken is ERC20, BasicToken {
82 
83   mapping (address => mapping (address => uint256)) internal allowed;
84 
85 
86   /**
87    * @dev Transfer tokens from one address to another
88    * @param _from address The address which you want to send tokens from
89    * @param _to address The address which you want to transfer to
90    * @param _value uint256 the amount of tokens to be transferred
91    */
92   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
93     require(_to != address(0));
94     require(_value <= balances[_from]);
95     require(_value <= allowed[_from][msg.sender]);
96 
97     balances[_from] = balances[_from].sub(_value);
98     balances[_to] = balances[_to].add(_value);
99     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
100     Transfer(_from, _to, _value);
101     return true;
102   }
103 
104   /**
105    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
106    *
107    * Beware that changing an allowance with this method brings the risk that someone may use both the old
108    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
109    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
110    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111    * @param _spender The address which will spend the funds.
112    * @param _value The amount of tokens to be spent.
113    */
114   function approve(address _spender, uint256 _value) public returns (bool) {
115     allowed[msg.sender][_spender] = _value;
116     Approval(msg.sender, _spender, _value);
117     return true;
118   }
119 
120   /**
121    * @dev Function to check the amount of tokens that an owner allowed to a spender.
122    * @param _owner address The address which owns the funds.
123    * @param _spender address The address which will spend the funds.
124    * @return A uint256 specifying the amount of tokens still available for the spender.
125    */
126   function allowance(address _owner, address _spender) public view returns (uint256) {
127     return allowed[_owner][_spender];
128   }
129 
130   /**
131    * @dev Increase the amount of tokens that an owner allowed to a spender.
132    *
133    * approve should be called when allowed[_spender] == 0. To increment
134    * allowed value is better to use this function to avoid 2 calls (and wait until
135    * the first transaction is mined)
136    * From MonolithDAO Token.sol
137    * @param _spender The address which will spend the funds.
138    * @param _addedValue The amount of tokens to increase the allowance by.
139    */
140   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
141     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
142     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143     return true;
144   }
145 
146   /**
147    * @dev Decrease the amount of tokens that an owner allowed to a spender.
148    *
149    * approve should be called when allowed[_spender] == 0. To decrement
150    * allowed value is better to use this function to avoid 2 calls (and wait until
151    * the first transaction is mined)
152    * From MonolithDAO Token.sol
153    * @param _spender The address which will spend the funds.
154    * @param _subtractedValue The amount of tokens to decrease the allowance by.
155    */
156   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
157     uint oldValue = allowed[msg.sender][_spender];
158     if (_subtractedValue > oldValue) {
159       allowed[msg.sender][_spender] = 0;
160     } else {
161       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
162     }
163     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
164     return true;
165   }
166 
167 }
168 
169 
170 
171 
172 /**
173  * @title Ownable
174  * @dev The Ownable contract has an owner address, and provides basic authorization control
175  * functions, this simplifies the implementation of "user permissions".
176  */
177 contract Ownable {
178   address public owner;
179 
180 
181   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
182 
183 
184   /**
185    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
186    * account.
187    */
188   function Ownable() public {
189     owner = msg.sender;
190   }
191 
192   /**
193    * @dev Throws if called by any account other than the owner.
194    */
195   modifier onlyOwner() {
196     require(msg.sender == owner);
197     _;
198   }
199 
200   /**
201    * @dev Allows the current owner to transfer control of the contract to a newOwner.
202    * @param newOwner The address to transfer ownership to.
203    */
204   function transferOwnership(address newOwner) public onlyOwner {
205     require(newOwner != address(0));
206     OwnershipTransferred(owner, newOwner);
207     owner = newOwner;
208   }
209 
210 }
211 
212 /**
213  * @title SafeMath
214  * @dev Math operations with safety checks that throw on error
215  */
216 library SafeMath {
217 
218   /**
219   * @dev Multiplies two numbers, throws on overflow.
220   */
221   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
222     if (a == 0) {
223       return 0;
224     }
225     uint256 c = a * b;
226     assert(c / a == b);
227     return c;
228   }
229 
230   /**
231   * @dev Integer division of two numbers, truncating the quotient.
232   */
233   function div(uint256 a, uint256 b) internal pure returns (uint256) {
234     // assert(b > 0); // Solidity automatically throws when dividing by 0
235     // uint256 c = a / b;
236     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
237     return a / b;
238   }
239 
240   /**
241   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
242   */
243   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
244     assert(b <= a);
245     return a - b;
246   }
247 
248   /**
249   * @dev Adds two numbers, throws on overflow.
250   */
251   function add(uint256 a, uint256 b) internal pure returns (uint256) {
252     uint256 c = a + b;
253     assert(c >= a);
254     return c;
255   }
256 }
257 
258 
259 contract OmmerToken is StandardToken, Ownable {
260 
261     using SafeMath for uint256;
262 
263     // Constants for the ERC20 interface
264     //
265     string public constant name = "ommer";
266     string public constant symbol = "OMR";
267     uint256 public constant decimals = 18;
268     // Our supply is 100 million OMR
269     uint256 public constant INITIAL_SUPPLY = 1 * (10 ** 8) * (10 ** decimals);
270 
271     // Constructor
272     //
273     function OmmerToken() public {
274         totalSupply_ = INITIAL_SUPPLY;
275         balances[msg.sender] = INITIAL_SUPPLY;
276     }
277 
278 }