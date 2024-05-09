1 // SPDX-License-Identifier: No License
2 pragma solidity 0.6.12;
3 
4 // ----------------------------------------------------------------------------
5 // 'Groovy.finance' token contract
6 //
7 // Symbol      : Gvy
8 // Name        : Groovy.finance
9 // Total supply: 42 000
10 // Decimals    : 18
11 // ----------------------------------------------------------------------------
12 
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath{
19       function mul(uint256 a, uint256 b) internal pure returns (uint256) 
20     {
21         if (a == 0) {
22         return 0;}
23         uint256 c = a * b;
24         assert(c / a == b);
25         return c;
26     }
27 
28     function div(uint256 a, uint256 b) internal pure returns (uint256) 
29     {
30         uint256 c = a / b;
31         return c;
32     }
33 
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
35     {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     function add(uint256 a, uint256 b) internal pure returns (uint256) 
41     {
42         uint256 c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 
47 }
48  
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   constructor () internal {
68     owner = msg.sender;
69   }
70 
71 
72   /**
73    * @dev Throws if called by any account other than the owner.
74    */
75   modifier onlyOwner() {
76     require(msg.sender == owner);
77     _;
78   }
79 
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) onlyOwner public {
86     require(newOwner != address(0));
87     emit OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 }
91 
92 /**
93  * @title ERC20Basic
94  * @dev Simpler version of ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/179
96  */ 
97 interface ERC20Basic {
98   
99   function balanceOf(address who) external view returns (uint256 balance);
100   function transfer(address to, uint256 value) external returns (bool trans1);
101   function allowance(address owner, address spender) external view returns (uint256 remaining);
102   function transferFrom(address from, address to, uint256 value) external returns (bool trans);
103   function approve(address spender, uint256 value) external returns (bool hello);
104   event Approval(address indexed owner, address indexed spender, uint256 value);
105   event Transfer(address indexed from, address indexed to, uint256 value);
106 }
107 
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 
114 
115 
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implementation of the basic standard token.
120  * @dev https://github.com/ethereum/EIPs/issues/20
121  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract StandardToken is  ERC20Basic, Ownable {
124 
125 
126 
127 uint256 public totalSupply;
128   using SafeMath for uint256;
129 
130   mapping(address => uint256) balances;
131  
132 
133  
134 
135   /**
136   * @dev transfer token for a specified address
137   * @param _to The address to transfer to.
138   * @param _value The amount to be transferred.
139   */
140   function transfer(address _to, uint256 _value) public override returns (bool trans1) {
141     require(_to != address(0));
142     //require(canTransfer(msg.sender));
143     
144 
145     // SafeMath.sub will throw if there is not enough balance.
146     balances[msg.sender] = balances[msg.sender].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     emit Transfer(msg.sender, _to, _value);
149     return true;
150   }
151 
152   /**
153   * @dev Gets the balance of the specified address.
154   * @param _owner The address to query the the balance of.
155   
156   */
157   function balanceOf(address _owner) public view override returns (uint256 balance) {
158     return balances[_owner];
159   }
160 
161 
162   mapping (address => mapping (address => uint256)) allowed;
163 
164 
165   /**
166    * @dev Transfer tokens from one address to another
167    * @param _from address The address which you want to send tokens from
168    * @param _to address The address which you want to transfer to
169    * @param _value uint256 the amount of tokens to be transferred
170    */
171   function transferFrom(address _from, address _to, uint256 _value) public override returns (bool trans) {
172     require(_to != address(0));
173    // require(canTransfer(msg.sender));
174 
175     uint256 _allowance = allowed[_from][msg.sender];
176 
177     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
178     // require (_value <= _allowance);
179 
180     balances[_from] = balances[_from].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     allowed[_from][msg.sender] = _allowance.sub(_value);
183     emit Transfer(_from, _to, _value);
184     return true;
185   }
186 
187   /**
188    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
189    *
190    * Beware that changing an allowance with this method brings the risk that someone may use both the old
191    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
192    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
193    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194    * @param _spender The address which will spend the funds.
195    * @param _value The amount of tokens to be spent.
196    */
197   function approve(address _spender, uint256 _value) public override returns (bool hello) {
198     allowed[msg.sender][_spender] = _value;
199     emit Approval(msg.sender, _spender, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Function to check the amount of tokens that an owner allowed to a spender.
205    * @param _owner address The address which owns the funds.
206    * @param _spender address The address which will spend the funds.
207    
208    */
209   function allowance(address _owner, address _spender) public view override  returns (uint256 remaining) {
210     return allowed[_owner][_spender];
211   }
212 
213   /**
214    * approve should be called when allowed[_spender] == 0. To increment
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    */
219   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
220     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
221     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225   function decreaseApproval (address _spender, uint _subtractedValue) public  returns (bool success) {
226     uint oldValue = allowed[msg.sender][_spender];
227     if (_subtractedValue > oldValue) {
228       allowed[msg.sender][_spender] = 0;
229     } else {
230       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
231     }
232     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235 }
236 
237 
238 /**
239  * @title Burnable Token
240  * @dev Token that can be irreversibly burned (destroyed).
241  */
242 contract BurnableToken is StandardToken {
243 
244     event Burn(address indexed burner, uint256 value);
245 
246     /**
247      * @dev Burns a specific amount of tokens.
248      * @param _value The amount of token to be burned.
249      */
250     function burn(uint256 _value) public {
251         require(_value > 0);
252         require(_value <= balances[msg.sender]);
253         // no need to require value <= totalSupply, since that would imply the
254         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
255 
256         address burner = msg.sender;
257         balances[burner] = balances[burner].sub(_value);
258         totalSupply = totalSupply.sub(_value);
259         emit Burn(burner, _value);
260         emit Transfer(burner, address(0), _value);
261     }
262 }
263 
264 contract Groovy is BurnableToken {
265 
266     string public constant name = "Groovy.finance";
267     string public constant symbol = "Gvy";
268     uint public constant decimals = 18;
269     // there is no problem in using * here instead of .mul()
270     uint256 public constant initialSupply = 42000 * (10 ** uint256(decimals));
271 
272     // Constructors
273     constructor () public{
274         totalSupply = initialSupply;
275         balances[msg.sender] = initialSupply; // Send all tokens to owner
276         //allowedAddresses[owner] = true;
277     }
278 
279 }