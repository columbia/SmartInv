1 pragma solidity ^0.4.18;
2 
3 
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   function Ownable() public {
23     owner = msg.sender;
24   }
25 
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35 
36   /**
37    * @dev Allows the current owner to transfer control of the contract to a newOwner.
38    * @param newOwner The address to transfer ownership to.
39    */
40   function transferOwnership(address newOwner) public onlyOwner {
41     require(newOwner != address(0));
42     OwnershipTransferred(owner, newOwner);
43     owner = newOwner;
44   }
45 
46 }
47 
48 /**
49  * @title ERC20Basic
50  * @dev Simpler version of ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/179
52  */
53 contract ERC20Basic {
54   uint256 public totalSupply;
55   function balanceOf(address who) public view returns (uint256);
56   function transfer(address to, uint256 value) public returns (bool);
57   event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 /**
60  * @title ERC20 interface
61  * @dev see https://github.com/ethereum/EIPs/issues/20
62  */
63 contract ERC20 is ERC20Basic {
64   function allowance(address owner, address spender) public view returns (uint256);
65   function transferFrom(address from, address to, uint256 value) public returns (bool);
66   function approve(address spender, uint256 value) public returns (bool);
67   event Approval(address indexed owner, address indexed spender, uint256 value);
68 
69 }
70 /**
71  * @title SafeMath
72  * @dev Math operations with safety checks that throw on error
73  */
74 library SafeMath {
75 
76   /**
77   * @dev Multiplies two numbers, throws on overflow.
78   */
79   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80     if (a == 0) {
81       return 0;
82     }
83     uint256 c = a * b;
84     assert(c / a == b);
85     return c;
86   }
87 
88   /**
89   * @dev Integer division of two numbers, truncating the quotient.
90   */
91   function div(uint256 a, uint256 b) internal pure returns (uint256) {
92     // assert(b > 0); // Solidity automatically throws when dividing by 0
93     uint256 c = a / b;
94     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95     return c;
96   }
97 
98   /**
99   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
100   */
101   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102     assert(b <= a);
103     return a - b;
104   }
105 
106   /**
107   * @dev Adds two numbers, throws on overflow.
108   */
109   function add(uint256 a, uint256 b) internal pure returns (uint256) {
110     uint256 c = a + b;
111     assert(c >= a);
112     return c;
113   }
114 }
115 /**
116  * @title Basic token
117  * @dev Basic version of StandardToken, with no allowances.
118  */
119 contract BasicToken is ERC20Basic {
120 
121   using SafeMath for uint256;
122 
123   mapping(address => uint256) balances;
124 
125   /**
126   * @dev transfer token for a specified address
127   * @param _to The address to transfer to.
128   * @param _value The amount to be transferred.
129   */
130   function transfer(address _to, uint256 _value) public returns (bool) {
131     require(_to != address(0));
132     require(_value <= balances[msg.sender]);
133 
134     // SafeMath.sub will throw if there is not enough balance.
135     balances[msg.sender] = balances[msg.sender].sub(_value);
136     balances[_to] = balances[_to].add(_value);
137     Transfer(msg.sender, _to, _value);
138     return true;
139   }
140 
141   /**
142   * @dev Gets the balance of the specified address.
143   * @param _owner The address to query the the balance of.
144   * @return An uint256 representing the amount owned by the passed address.
145   */
146   function balanceOf(address _owner) public view returns (uint256 balance) {
147     return balances[_owner];
148   }
149 }
150 
151 /**
152  * @title Standard ERC20 token
153  *
154  * @dev Implementation of the basic standard token.
155  * @dev https://github.com/ethereum/EIPs/issues/20
156  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
157  */
158 contract StandardToken is ERC20, BasicToken {
159 
160   mapping (address => mapping (address => uint256)) internal allowed;
161 
162 
163   /**
164    * @dev Transfer tokens from one address to another
165    * @param _from address The address which you want to send tokens from
166    * @param _to address The address which you want to transfer to
167    * @param _value uint256 the amount of tokens to be transferred
168    */
169   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
170     require(_to != address(0));
171     require(_value <= balances[_from]);
172     require(_value <= allowed[_from][msg.sender]);
173 
174     balances[_from] = balances[_from].sub(_value);
175     balances[_to] = balances[_to].add(_value);
176     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
177     Transfer(_from, _to, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
183    *
184    * Beware that changing an allowance with this method brings the risk that someone may use both the old
185    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
186    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
187    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188    * @param _spender The address which will spend the funds.
189    * @param _value The amount of tokens to be spent.
190    */
191   function approve(address _spender, uint256 _value) public returns (bool) {
192     allowed[msg.sender][_spender] = _value;
193     Approval(msg.sender, _spender, _value);
194     return true;
195   }
196 
197   /**
198    * @dev Function to check the amount of tokens that an owner allowed to a spender.
199    * @param _owner address The address which owns the funds.
200    * @param _spender address The address which will spend the funds.
201    * @return A uint256 specifying the amount of tokens still available for the spender.
202    */
203   function allowance(address _owner, address _spender) public view returns (uint256) {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    *
210    * approve should be called when allowed[_spender] == 0. To increment
211    * allowed value is better to use this function to avoid 2 calls (and wait until
212    * the first transaction is mined)
213    * From MonolithDAO Token.sol
214    * @param _spender The address which will spend the funds.
215    * @param _addedValue The amount of tokens to increase the allowance by.
216    */
217   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
218     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
219     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220     return true;
221   }
222 
223   /**
224    * @dev Decrease the amount of tokens that an owner allowed to a spender.
225    *
226    * approve should be called when allowed[_spender] == 0. To decrement
227    * allowed value is better to use this function to avoid 2 calls (and wait until
228    * the first transaction is mined)
229    * From MonolithDAO Token.sol
230    * @param _spender The address which will spend the funds.
231    * @param _subtractedValue The amount of tokens to decrease the allowance by.
232    */
233   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
234     uint oldValue = allowed[msg.sender][_spender];
235     if (_subtractedValue > oldValue) {
236       allowed[msg.sender][_spender] = 0;
237     } else {
238       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
239     }
240     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
241     return true;
242   }
243 
244 }
245 
246 
247 contract MintableToken is StandardToken, Ownable {
248   event Mint(address indexed to, uint256 amount);
249   event MintFinished();
250 
251   bool public mintingFinished = false;
252 
253 
254   modifier canMint() {
255     require(!mintingFinished);
256     _;
257   }
258 
259   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
260     totalSupply = totalSupply.add(_amount);
261     balances[_to] = balances[_to].add(_amount);
262     Mint(_to, _amount);
263     Transfer(address(0), _to, _amount);
264     return true;
265   }
266 
267   function finishMinting() onlyOwner canMint public returns (bool) {
268     mintingFinished = true;
269     MintFinished();
270     return true;
271   }
272 }
273 
274 contract GDR is MintableToken {
275 
276   string public constant name = "Golden Resource";
277 
278   string public constant symbol = "GDR";
279 
280   uint8 public constant decimals = 18;
281 
282 }