1 pragma solidity ^0.4.21;
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
13 
14   event OwnershipRenounced(address indexed previousOwner);
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
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     emit OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44   /**
45    * @dev Allows the current owner to relinquish control of the contract.
46    */
47   function renounceOwnership() public onlyOwner {
48     emit OwnershipRenounced(owner);
49     owner = address(0);
50   }
51 }
52 
53 // File: contracts/math/SafeMath.sol
54 
55 /**
56  * @title SafeMath
57  * @dev Math operations with safety checks that throw on error
58  */
59 library SafeMath {
60 
61   /**
62   * @dev Multiplies two numbers, throws on overflow.
63   */
64   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
65     if (a == 0) {
66       return 0;
67     }
68     c = a * b;
69     assert(c / a == b);
70     return c;
71   }
72 
73   /**
74   * @dev Integer division of two numbers, truncating the quotient.
75   */
76   function div(uint256 a, uint256 b) internal pure returns (uint256) {
77     // assert(b > 0); // Solidity automatically throws when dividing by 0
78     // uint256 c = a / b;
79     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
80     return a / b;
81   }
82 
83   /**
84   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
85   */
86   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87     assert(b <= a);
88     return a - b;
89   }
90 
91   /**
92   * @dev Adds two numbers, throws on overflow.
93   */
94   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
95     c = a + b;
96     assert(c >= a);
97     return c;
98   }
99 }
100 
101 // File: contracts/token/ERC20/ERC20Basic.sol
102 
103 /**
104  * @title ERC20Basic
105  * @dev Simpler version of ERC20 interface
106  * @dev see https://github.com/ethereum/EIPs/issues/179
107  */
108 contract ERC20Basic {
109   function totalSupply() public view returns (uint256);
110   function balanceOf(address who) public view returns (uint256);
111   function transfer(address to, uint256 value) public returns (bool);
112   event Transfer(address indexed from, address indexed to, uint256 value);
113 }
114 
115 // File: contracts/token/ERC20/BasicToken.sol
116 
117 /**
118  * @title Basic token
119  * @dev Basic version of StandardToken, with no allowances.
120  */
121 contract BasicToken is ERC20Basic {
122   using SafeMath for uint256;
123 
124   mapping(address => uint256) balances;
125 
126   uint256 totalSupply_;
127 
128   /**
129   * @dev total number of tokens in existence
130   */
131   function totalSupply() public view returns (uint256) {
132     return totalSupply_;
133   }
134 
135   /**
136   * @dev transfer token for a specified address
137   * @param _to The address to transfer to.
138   * @param _value The amount to be transferred.
139   */
140   function transfer(address _to, uint256 _value) public returns (bool) {
141     require(_to != address(0));
142     require(_value <= balances[msg.sender]);
143 
144     balances[msg.sender] = balances[msg.sender].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     emit Transfer(msg.sender, _to, _value);
147     return true;
148   }
149 
150   /**
151   * @dev Gets the balance of the specified address.
152   * @param _owner The address to query the the balance of.
153   * @return An uint256 representing the amount owned by the passed address.
154   */
155   function balanceOf(address _owner) public view returns (uint256) {
156     return balances[_owner];
157   }
158 
159 }
160 
161  
162 
163 // File: contracts/token/ERC20/ERC20.sol
164 
165 /**
166  * @title ERC20 interface
167  * @dev see https://github.com/ethereum/EIPs/issues/20
168  */
169 contract ERC20 is ERC20Basic {
170   function allowance(address owner, address spender) public view returns (uint256);
171   function transferFrom(address from, address to, uint256 value) public returns (bool);
172   function approve(address spender, uint256 value) public returns (bool);
173   event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
175 
176 // File: contracts/token/ERC20/StandardToken.sol
177 
178 /**
179  * @title Standard ERC20 token
180  *
181  * @dev Implementation of the basic standard token.
182  * @dev https://github.com/ethereum/EIPs/issues/20
183  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
184  */
185 contract StandardToken is ERC20, BasicToken {
186 
187   mapping (address => mapping (address => uint256)) internal allowed;
188 
189 
190   /**
191    * @dev Transfer tokens from one address to another
192    * @param _from address The address which you want to send tokens from
193    * @param _to address The address which you want to transfer to
194    * @param _value uint256 the amount of tokens to be transferred
195    */
196   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
197     require(_to != address(0));
198     require(_value <= balances[_from]);
199     require(_value <= allowed[_from][msg.sender]);
200 
201     balances[_from] = balances[_from].sub(_value);
202     balances[_to] = balances[_to].add(_value);
203     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
204     emit Transfer(_from, _to, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
210    *
211    * Beware that changing an allowance with this method brings the risk that someone may use both the old
212    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
213    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
214    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215    * @param _spender The address which will spend the funds.
216    * @param _value The amount of tokens to be spent.
217    */
218   function approve(address _spender, uint256 _value) public returns (bool) {
219     allowed[msg.sender][_spender] = _value;
220     emit Approval(msg.sender, _spender, _value);
221     return true;
222   }
223 
224   /**
225    * @dev Function to check the amount of tokens that an owner allowed to a spender.
226    * @param _owner address The address which owns the funds.
227    * @param _spender address The address which will spend the funds.
228    * @return A uint256 specifying the amount of tokens still available for the spender.
229    */
230   function allowance(address _owner, address _spender) public view returns (uint256) {
231     return allowed[_owner][_spender];
232   }
233 
234   /**
235    * @dev Increase the amount of tokens that an owner allowed to a spender.
236    *
237    * approve should be called when allowed[_spender] == 0. To increment
238    * allowed value is better to use this function to avoid 2 calls (and wait until
239    * the first transaction is mined)
240    * From MonolithDAO Token.sol
241    * @param _spender The address which will spend the funds.
242    * @param _addedValue The amount of tokens to increase the allowance by.
243    */
244   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
245     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
246     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247     return true;
248   }
249 
250   /**
251    * @dev Decrease the amount of tokens that an owner allowed to a spender.
252    *
253    * approve should be called when allowed[_spender] == 0. To decrement
254    * allowed value is better to use this function to avoid 2 calls (and wait until
255    * the first transaction is mined)
256    * From MonolithDAO Token.sol
257    * @param _spender The address which will spend the funds.
258    * @param _subtractedValue The amount of tokens to decrease the allowance by.
259    */
260   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
261     uint oldValue = allowed[msg.sender][_spender];
262     if (_subtractedValue > oldValue) {
263       allowed[msg.sender][_spender] = 0;
264     } else {
265       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
266     }
267     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268     return true;
269   }
270 
271 }
272 
273 contract Ethereumwhocoin is StandardToken, Ownable {
274     // Constants
275     string  public constant name = "Ethereum who coin";
276     string  public constant symbol = "Ewcoin";
277     uint8   public constant decimals = 4;
278     uint256 public constant INITIAL_SUPPLY     =  100000000 * (10 ** uint256(decimals));
279    
280     
281     mapping(address => bool) touched;
282  
283 
284     function Ethereumwhocoin() public {
285       totalSupply_ = INITIAL_SUPPLY;
286 
287       
288 
289       balances[msg.sender] = INITIAL_SUPPLY;
290       emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
291     }
292 
293     function _transfer(address _from, address _to, uint _value) internal {     
294         require (balances[_from] >= _value);               // Check if the sender has enough
295         require (balances[_to] + _value > balances[_to]); // Check for overflows
296    
297         balances[_from] = balances[_from].sub(_value);                         // Subtract from the sender
298         balances[_to] = balances[_to].add(_value);                            // Add the same to the recipient
299          
300         emit Transfer(_from, _to, _value);
301     }
302  
303     
304     function safeWithdrawal(uint _value ) onlyOwner public {
305        if (_value == 0) 
306            owner.transfer(address(this).balance);
307        else
308            owner.transfer(_value);
309     }
310 
311 }