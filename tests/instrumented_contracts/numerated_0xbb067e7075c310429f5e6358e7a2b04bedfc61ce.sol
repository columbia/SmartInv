1 pragma solidity ^0.4.24;
2 
3 // File: contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 // File: contracts/math/SafeMath.sol
45 
46 /**
47  * @title SafeMath
48  * @dev Math operations with safety checks that throw on error
49  */
50 library SafeMath {
51 
52   /**
53   * @dev Multiplies two numbers, throws on overflow.
54   */
55   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
56     if (a == 0) {
57       return 0;
58     }
59     c = a * b;
60     assert(c / a == b);
61     return c;
62   }
63 
64   /**
65   * @dev Integer division of two numbers, truncating the quotient.
66   */
67   function div(uint256 a, uint256 b) internal pure returns (uint256) {
68     // assert(b > 0); // Solidity automatically throws when dividing by 0
69     // uint256 c = a / b;
70     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71     return a / b;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     assert(b <= a);
79     return a - b;
80   }
81 
82   /**
83   * @dev Adds two numbers, throws on overflow.
84   */
85   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
86     c = a + b;
87     assert(c >= a);
88     return c;
89   }
90 }
91 
92 // File: contracts/token/ERC20/ERC20Basic.sol
93 
94 /**
95  * @title ERC20Basic
96  * @dev Simpler version of ERC20 interface
97  * @dev see https://github.com/ethereum/EIPs/issues/179
98  */
99 contract ERC20Basic {
100   function totalSupply() public view returns (uint256);
101   function balanceOf(address who) public view returns (uint256);
102   function transfer(address to, uint256 value) public returns (bool);
103   event Transfer(address indexed from, address indexed to, uint256 value);
104 }
105 
106 // File: contracts/token/ERC20/BasicToken.sol
107 
108 /**
109  * @title Basic token
110  * @dev Basic version of StandardToken, with no allowances.
111  */
112 contract BasicToken is ERC20Basic {
113   using SafeMath for uint256;
114 
115   mapping(address => uint256) balances;
116 
117   uint256 totalSupply_;
118 
119   /**
120   * @dev total number of tokens in existence
121   */
122   function totalSupply() public view returns (uint256) {
123     return totalSupply_;
124   }
125 
126   /**
127   * @dev transfer token for a specified address
128   * @param _to The address to transfer to.
129   * @param _value The amount to be transferred.
130   */
131   function transfer(address _to, uint256 _value) public returns (bool) {
132     require(_to != address(0));
133     require(_value <= balances[msg.sender]);
134 
135     balances[msg.sender] = balances[msg.sender].sub(_value);
136     balances[_to] = balances[_to].add(_value);
137     emit Transfer(msg.sender, _to, _value);
138     return true;
139   }
140 
141   /**
142   * @dev Gets the balance of the specified address.
143   * @param _owner The address to query the the balance of.
144   * @return An uint256 representing the amount owned by the passed address.
145   */
146   function balanceOf(address _owner) public view returns (uint256) {
147     return balances[_owner];
148   }
149 
150 }
151 
152 // File: contracts/token/ERC20/BurnableToken.sol
153 
154 /**
155  * @title Burnable Token
156  * @dev Token that can be irreversibly burned (destroyed).
157  */
158 contract BurnableToken is BasicToken {
159 
160   event Burn(address indexed burner, uint256 value);
161 
162   /**
163    * @dev Burns a specific amount of tokens.
164    * @param _value The amount of token to be burned.
165    */
166   function burn(uint256 _value) public {
167     _burn(msg.sender, _value);
168   }
169 
170   function _burn(address _who, uint256 _value) internal {
171     require(_value <= balances[_who]);
172     // no need to require value <= totalSupply, since that would imply the
173     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
174 
175     balances[_who] = balances[_who].sub(_value);
176     totalSupply_ = totalSupply_.sub(_value);
177     emit Burn(_who, _value);
178     emit Transfer(_who, address(0), _value);
179   }
180 }
181 
182 // File: contracts/token/ERC20/ERC20.sol
183 
184 /**
185  * @title ERC20 interface
186  * @dev see https://github.com/ethereum/EIPs/issues/20
187  */
188 contract ERC20 is ERC20Basic {
189   function allowance(address owner, address spender) public view returns (uint256);
190   function transferFrom(address from, address to, uint256 value) public returns (bool);
191   function approve(address spender, uint256 value) public returns (bool);
192   event Approval(address indexed owner, address indexed spender, uint256 value);
193 }
194 
195 // File: contracts/token/ERC20/StandardToken.sol
196 
197 /**
198  * @title Standard ERC20 token
199  *
200  * @dev Implementation of the basic standard token.
201  * @dev https://github.com/ethereum/EIPs/issues/20
202  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
203  */
204 contract StandardToken is ERC20, BasicToken {
205 
206   mapping (address => mapping (address => uint256)) internal allowed;
207 
208 
209   /**
210    * @dev Transfer tokens from one address to another
211    * @param _from address The address which you want to send tokens from
212    * @param _to address The address which you want to transfer to
213    * @param _value uint256 the amount of tokens to be transferred
214    */
215   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
216     require(_to != address(0));
217     require(_value <= balances[_from]);
218     require(_value <= allowed[_from][msg.sender]);
219 
220     balances[_from] = balances[_from].sub(_value);
221     balances[_to] = balances[_to].add(_value);
222     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
223     emit Transfer(_from, _to, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
229    *
230    * Beware that changing an allowance with this method brings the risk that someone may use both the old
231    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
232    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
233    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
234    * @param _spender The address which will spend the funds.
235    * @param _value The amount of tokens to be spent.
236    */
237   function approve(address _spender, uint256 _value) public returns (bool) {
238     allowed[msg.sender][_spender] = _value;
239     emit Approval(msg.sender, _spender, _value);
240     return true;
241   }
242 
243   /**
244    * @dev Function to check the amount of tokens that an owner allowed to a spender.
245    * @param _owner address The address which owns the funds.
246    * @param _spender address The address which will spend the funds.
247    * @return A uint256 specifying the amount of tokens still available for the spender.
248    */
249   function allowance(address _owner, address _spender) public view returns (uint256) {
250     return allowed[_owner][_spender];
251   }
252 
253   /**
254    * @dev Increase the amount of tokens that an owner allowed to a spender.
255    *
256    * approve should be called when allowed[_spender] == 0. To increment
257    * allowed value is better to use this function to avoid 2 calls (and wait until
258    * the first transaction is mined)
259    * From MonolithDAO Token.sol
260    * @param _spender The address which will spend the funds.
261    * @param _addedValue The amount of tokens to increase the allowance by.
262    */
263   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
264     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
265     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266     return true;
267   }
268 
269   /**
270    * @dev Decrease the amount of tokens that an owner allowed to a spender.
271    *
272    * approve should be called when allowed[_spender] == 0. To decrement
273    * allowed value is better to use this function to avoid 2 calls (and wait until
274    * the first transaction is mined)
275    * From MonolithDAO Token.sol
276    * @param _spender The address which will spend the funds.
277    * @param _subtractedValue The amount of tokens to decrease the allowance by.
278    */
279   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
280     uint oldValue = allowed[msg.sender][_spender];
281     if (_subtractedValue > oldValue) {
282       allowed[msg.sender][_spender] = 0;
283     } else {
284       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
285     }
286     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
287     return true;
288   }
289 
290 }
291 
292 contract WLB is StandardToken, BurnableToken, Ownable {
293     // Constants
294     string  public constant name = "香港傲讯达";
295     string  public constant symbol = "WLB";
296     uint8   public constant decimals = 18;
297     uint256 public constant INITIAL_SUPPLY      = 300000000  * (10 ** uint256(decimals));
298  
299     constructor() public {
300       address holder = 0x4fC660E367A6654Deb750311F670aF5B1828E513;
301       totalSupply_ = INITIAL_SUPPLY;
302       balances[holder] = INITIAL_SUPPLY;
303       emit Transfer(0x0, holder, INITIAL_SUPPLY);
304     }
305  
306     function () external payable {
307         revert();
308     }
309  
310 }