1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55 
56     address public tokenOwner;
57     address private tokenNewOwner;
58     event ChangeOwner(address oldOwner, address newOwner);
59 
60 
61     modifier onlyOwner() {
62         require(msg.sender == tokenOwner);
63         _;
64     }
65 
66 // @notice The Constructor assigns the message sender to be `owner`
67     constructor () public {
68         tokenOwner = msg.sender;
69     }
70 
71 
72     function changeOwner(address _newOwner) public onlyOwner {
73         emit ChangeOwner(tokenOwner, _newOwner);
74         tokenOwner = _newOwner;
75     }
76 }
77 
78 /**
79  * @title ERC20Basic
80  * @dev Simpler version of ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/179
82  */
83 contract ERC20Basic {
84   function totalSupply() public view returns (uint256);
85   function balanceOf(address who) public view returns (uint256);
86   function transfer(address to, uint256 value) public returns (bool);
87   event Transfer(address indexed from, address indexed to, uint256 value);
88   event Burn(address indexed from, uint256 value);
89   event BurnUser(address indexed from, uint256 value);
90   event Mint(address receiver, uint amount);
91 }
92 
93 /**
94  * @title Basic token
95  * @dev Basic version of StandardToken, with no allowances.
96  */
97 contract BasicToken is ERC20Basic {
98   using SafeMath for uint256;
99 
100   mapping(address => uint256) balances;
101 
102   uint256 totalSupply_;
103 
104   /**
105   * @dev total number of tokens in existence
106   */
107   function totalSupply() public view returns (uint256) {
108     return totalSupply_;
109   }
110 
111   /**
112   * @dev transfer token for a specified address
113   * @param _to The address to transfer to.
114   * @param _value The amount to be transferred.
115   */
116   function transfer(address _to, uint256 _value) public returns (bool) {
117     require(_to != address(0));
118     require(_value <= balances[msg.sender]);
119 
120     // SafeMath.sub will throw if there is not enough balance.
121     balances[msg.sender] = balances[msg.sender].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     emit Transfer(msg.sender, _to, _value);
124     return true;
125   }
126 
127   /**
128   * @dev Gets the balance of the specified address.
129   * @param _owner The address to query the the balance of.
130   * @return An uint256 representing the amount owned by the passed address.
131   */
132   function balanceOf(address _owner) public view returns (uint256 balance) {
133     return balances[_owner];
134   }
135 }
136 
137 /**
138  * @title ERC20 interface
139  * @dev see https://github.com/ethereum/EIPs/issues/20
140  */
141 contract ERC20 is ERC20Basic {
142   function allowance(address owner, address spender) public view returns (uint256);
143   function transferFrom(address from, address to, uint256 value) public returns (bool);
144   function approve(address spender, uint256 value) public returns (bool);
145   event Approval(address indexed owner, address indexed spender, uint256 value);
146 }
147 
148 /**
149  * @title Standard ERC20 token
150  *
151  * @dev Implementation of the basic standard token.
152  * @dev https://github.com/ethereum/EIPs/issues/20
153  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
154  */
155 contract StandardToken is ERC20, BasicToken {
156 
157   mapping (address => mapping (address => uint256)) internal allowed;
158 
159   /**
160    * @dev Transfer tokens from one address to another
161    * @param _from address The address which you want to send tokens from
162    * @param _to address The address which you want to transfer to
163    * @param _value uint256 the amount of tokens to be transferred
164    */
165   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
166     require(_to != address(0));
167     require(_value <= balances[_from]);
168     require(_value <= allowed[_from][msg.sender]);
169 
170     balances[_from] = balances[_from].sub(_value);
171     balances[_to] = balances[_to].add(_value);
172     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
173     emit Transfer(_from, _to, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
179    *
180    * Beware that changing an allowance with this method brings the risk that someone may use both the old
181    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
182    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
183    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
184    * @param _spender The address which will spend the funds.
185    * @param _value The amount of tokens to be spent.
186    */
187   function approve(address _spender, uint256 _value) public returns (bool) {
188     allowed[msg.sender][_spender] = _value;
189     emit Approval(msg.sender, _spender, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Function to check the amount of tokens that an owner allowed to a spender.
195    * @param _owner address The address which owns the funds.
196    * @param _spender address The address which will spend the funds.
197    * @return A uint256 specifying the amount of tokens still available for the spender.
198    */
199   function allowance(address _owner, address _spender) public view returns (uint256) {
200     return allowed[_owner][_spender];
201   }
202 
203   /**
204    * @dev Increase the amount of tokens that an owner allowed to a spender.
205    *
206    * approve should be called when allowed[_spender] == 0. To increment
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    * @param _spender The address which will spend the funds.
211    * @param _addedValue The amount of tokens to increase the allowance by.
212    */
213   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
214     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219   /**
220    * @dev Decrease the amount of tokens that an owner allowed to a spender.
221    *
222    * approve should be called when allowed[_spender] == 0. To decrement
223    * allowed value is better to use this function to avoid 2 calls (and wait until
224    * the first transaction is mined)
225    * From MonolithDAO Token.sol
226    * @param _spender The address which will spend the funds.
227    * @param _subtractedValue The amount of tokens to decrease the allowance by.
228    */
229   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
230     uint oldValue = allowed[msg.sender][_spender];
231     if (_subtractedValue > oldValue) {
232       allowed[msg.sender][_spender] = 0;
233     } else {
234       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
235     }
236     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239   
240 }
241 
242 
243 /**
244  * @title MyToken
245  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
246  * Note they can later distribute these tokens as they wish using `transfer` and other
247  * `StandardToken` functions.
248  */
249 contract NABI is StandardToken, Ownable {
250 
251   string public constant name = "Nabichain"; // solium-disable-line uppercase
252   string public constant symbol = "NABI"; // solium-disable-line uppercase
253   uint8 public constant decimals = 18; // solium-disable-line uppercase
254 
255   uint256 public constant INITIAL_SUPPLY = 1e10 * (10 ** uint256(decimals));
256   /**
257    * @dev Constructor that gives msg.sender all of existing tokens.
258    */
259   constructor() public {
260     totalSupply_ = INITIAL_SUPPLY;
261     balances[msg.sender] = INITIAL_SUPPLY;
262     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
263   }
264   
265   function mintToken(address target, uint256 mintedAmount) onlyOwner public {
266     balances[target] += mintedAmount;
267     totalSupply_ += mintedAmount;
268     emit Transfer(0, this, mintedAmount);
269     emit Transfer(this, target, mintedAmount);
270   }
271   
272   function burn(uint256 _value) onlyOwner public returns (bool success) {
273     require(balances[msg.sender] >= _value);   // Check if the sender has enough
274     balances[msg.sender] -= _value;            // Subtract from the sender
275     totalSupply_ -= _value;                      // Updates totalSupply
276     emit Burn(msg.sender, _value);
277     return true;
278   }
279 
280   function burnUser(address target, uint256 _value) onlyOwner public returns (bool success) {
281     require(balances[target] >= _value);   // Check if the sender has enough
282     balances[target] -= _value;            // Subtract from the sender
283     totalSupply_ -= _value;                      // Updates totalSupply
284     emit BurnUser(target, _value);
285     return true;
286   }
287     
288 
289 }