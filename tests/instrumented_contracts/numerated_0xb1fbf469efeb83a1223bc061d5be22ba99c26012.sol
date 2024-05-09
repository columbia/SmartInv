1 pragma solidity ^0.4.26;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   constructor() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 
44 /**
45  * @title SafeMath
46  * @dev Math operations with safety checks that throw on error
47  */
48 library SafeMath {
49 
50   /**
51   * @dev Multiplies two numbers, throws on overflow.
52   */
53   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
54     if (a == 0) {
55       return 0;
56     }
57     c = a * b;
58     assert(c / a == b);
59     return c;
60   }
61 
62   /**
63   * @dev Integer division of two numbers, truncating the quotient.
64   */
65   function div(uint256 a, uint256 b) internal pure returns (uint256) {
66     // assert(b > 0); // Solidity automatically throws when dividing by 0
67     // uint256 c = a / b;
68     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69     return a / b;
70   }
71 
72   /**
73   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76     assert(b <= a);
77     return a - b;
78   }
79 
80   /**
81   * @dev Adds two numbers, throws on overflow.
82   */
83   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
84     c = a + b;
85     assert(c >= a);
86     return c;
87   }
88 }
89 
90 
91 
92 /**
93  * @title ERC20Basic
94  * @dev Simpler version of ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/179
96  */
97 contract ERC20Basic {
98   function totalSupply() public view returns (uint256);
99   function balanceOf(address who) public view returns (uint256);
100   function transfer(address to, uint256 value) public returns (bool);
101   event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 // File: contracts/token/ERC20/BasicToken.sol
105 
106 /**
107  * @title Basic token
108  * @dev Basic version of StandardToken, with no allowances.
109  */
110 contract BasicToken is ERC20Basic {
111   using SafeMath for uint256;
112 
113   mapping(address => uint256) balances;
114 
115   uint256 totalSupply_;
116 
117   /**
118   * @dev total number of tokens in existence
119   */
120   function totalSupply() public view returns (uint256) {
121     return totalSupply_;
122   }
123 
124   /**
125   * @dev transfer token for a specified address
126   * @param _to The address to transfer to.
127   * @param _value The amount to be transferred.
128   */
129   function transfer(address _to, uint256 _value) public returns (bool) {
130     require(_to != address(0));
131     require(_value <= balances[msg.sender]);
132 
133     balances[msg.sender] = balances[msg.sender].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     emit Transfer(msg.sender, _to, _value);
136     return true;
137   }
138 
139   /**
140   * @dev Gets the balance of the specified address.
141   * @param _owner The address to query the the balance of.
142   * @return An uint256 representing the amount owned by the passed address.
143   */
144   function balanceOf(address _owner) public view returns (uint256) {
145     return balances[_owner];
146   }
147 
148 }
149 
150 
151 
152 /**
153  * @title Burnable Token
154  * @dev Token that can be irreversibly burned (destroyed).
155  */
156 contract BurnableToken is BasicToken {
157 
158   event Burn(address indexed burner, uint256 value);
159 
160   /**
161    * @dev Burns a specific amount of tokens.
162    * @param _value The amount of token to be burned.
163    */
164   function burn(uint256 _value) public {
165     _burn(msg.sender, _value);
166   }
167 
168   function _burn(address _who, uint256 _value) internal {
169     require(_value <= balances[_who]);
170     // no need to require value <= totalSupply, since that would imply the
171     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
172 
173     balances[_who] = balances[_who].sub(_value);
174     totalSupply_ = totalSupply_.sub(_value);
175     emit Burn(_who, _value);
176     emit Transfer(_who, address(0), _value);
177   }
178 }
179 
180 
181 
182 /**
183  * @title ERC20 interface
184  * @dev see https://github.com/ethereum/EIPs/issues/20
185  */
186 contract ERC20 is ERC20Basic {
187   function allowance(address owner, address spender) public view returns (uint256);
188   function transferFrom(address from, address to, uint256 value) public returns (bool);
189   function approve(address spender, uint256 value) public returns (bool);
190   event Approval(address indexed owner, address indexed spender, uint256 value);
191 }
192 
193 
194 
195 /**
196  * @title Standard ERC20 token
197  *
198  * @dev Implementation of the basic standard token.
199  * @dev https://github.com/ethereum/EIPs/issues/20
200  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
201  */
202 contract StandardToken is ERC20, BasicToken {
203 
204   mapping (address => mapping (address => uint256)) internal allowed;
205 
206 
207   /**
208    * @dev Transfer tokens from one address to another
209    * @param _from address The address which you want to send tokens from
210    * @param _to address The address which you want to transfer to
211    * @param _value uint256 the amount of tokens to be transferred
212    */
213   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
214     require(_to != address(0));
215     require(_value <= balances[_from]);
216     require(_value <= allowed[_from][msg.sender]);
217 
218     balances[_from] = balances[_from].sub(_value);
219     balances[_to] = balances[_to].add(_value);
220     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
221     emit Transfer(_from, _to, _value);
222     return true;
223   }
224 
225   /**
226    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
227    *
228    * Beware that changing an allowance with this method brings the risk that someone may use both the old
229    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
230    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
231    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
232    * @param _spender The address which will spend the funds.
233    * @param _value The amount of tokens to be spent.
234    */
235   function approve(address _spender, uint256 _value) public returns (bool) {
236     // To change the approve amount you first have to reduce the addresses`
237     //  allowance to zero by calling `approve(_spender, 0)` if it is not
238     //  already 0 to mitigate the race condition described here:
239     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
240     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
241 
242     allowed[msg.sender][_spender] = _value;
243     emit Approval(msg.sender, _spender, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Function to check the amount of tokens that an owner allowed to a spender.
249    * @param _owner address The address which owns the funds.
250    * @param _spender address The address which will spend the funds.
251    * @return A uint256 specifying the amount of tokens still available for the spender.
252    */
253   function allowance(address _owner, address _spender) public view returns (uint256) {
254     return allowed[_owner][_spender];
255   }
256 
257   /**
258    * @dev Increase the amount of tokens that an owner allowed to a spender.
259    *
260    * approve should be called when allowed[_spender] == 0. To increment
261    * allowed value is better to use this function to avoid 2 calls (and wait until
262    * the first transaction is mined)
263    * From MonolithDAO Token.sol
264    * @param _spender The address which will spend the funds.
265    * @param _addedValue The amount of tokens to increase the allowance by.
266    */
267   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
268     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
269     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273   /**
274    * @dev Decrease the amount of tokens that an owner allowed to a spender.
275    *
276    * approve should be called when allowed[_spender] == 0. To decrement
277    * allowed value is better to use this function to avoid 2 calls (and wait until
278    * the first transaction is mined)
279    * From MonolithDAO Token.sol
280    * @param _spender The address which will spend the funds.
281    * @param _subtractedValue The amount of tokens to decrease the allowance by.
282    */
283   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
284     uint oldValue = allowed[msg.sender][_spender];
285     if (_subtractedValue > oldValue) {
286       allowed[msg.sender][_spender] = 0;
287     } else {
288       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
289     }
290     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294 }
295 
296 contract CHC is StandardToken, BurnableToken, Ownable {
297     // Constants
298     string  public constant name = "Comprehensive Health Chain";
299     string  public constant symbol = "CHC";
300     uint8   public constant decimals = 18;
301     uint256 public constant INITIAL_SUPPLY      = 100000000 * (10 ** uint256(decimals));
302  
303     constructor() public {
304       totalSupply_ = INITIAL_SUPPLY;
305       balances[msg.sender] = INITIAL_SUPPLY;
306       emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
307     }
308 
309  
310     function () external payable {
311         revert();
312     }
313 
314  
315 }