1 pragma solidity ^0.4.16;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12   function div(uint256 a, uint256 b) internal constant returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 /**
29  * @title ERC20Basic
30  * @dev Simpler version of ERC20 interface
31  * @dev see https://github.com/ethereum/EIPs/issues/179
32  */
33 contract ERC20Basic {
34   uint256 public totalSupply;
35   function balanceOf(address who) public constant returns (uint256);
36   function transfer(address to, uint256 value) public returns (bool);
37   event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 /**
40  * @title Basic token
41  * @dev Basic version of StandardToken, with no allowances.
42  */
43 contract BasicToken is ERC20Basic {
44   using SafeMath for uint256;
45   mapping(address => uint256) balances;
46   /**
47   * @dev transfer token for a specified address
48   * @param _to The address to transfer to.
49   * @param _value The amount to be transferred.
50   */
51   function transfer(address _to, uint256 _value) public returns (bool) {
52     require(_to != address(0));
53     require(_value > 0 && _value <= balances[msg.sender]);
54     // SafeMath.sub will throw if there is not enough balance.
55     balances[msg.sender] = balances[msg.sender].sub(_value);
56     balances[_to] = balances[_to].add(_value);
57     Transfer(msg.sender, _to, _value);
58     return true;
59   }
60   /**
61   * @dev Gets the balance of the specified address.
62   * @param _owner The address to query the the balance of.
63   * @return An uint256 representing the amount owned by the passed address.
64   */
65   function balanceOf(address _owner) public constant returns (uint256 balance) {
66     return balances[_owner];
67   }
68 }
69 /**
70  * @title ERC20 interface
71  * @dev see https://github.com/ethereum/EIPs/issues/20
72  */
73 contract ERC20 is ERC20Basic {
74   function allowance(address owner, address spender) public constant returns (uint256);
75   function transferFrom(address from, address to, uint256 value) public returns (bool);
76   function approve(address spender, uint256 value) public returns (bool);
77   event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 /**
80  * @title Standard ERC20 token
81  *
82  * @dev Implementation of the basic standard token.
83  * @dev https://github.com/ethereum/EIPs/issues/20
84  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
85  */
86 contract StandardToken is ERC20, BasicToken {
87   mapping (address => mapping (address => uint256)) internal allowed;
88   /**
89    * @dev Transfer tokens from one address to another
90    * @param _from address The address which you want to send tokens from
91    * @param _to address The address which you want to transfer to
92    * @param _value uint256 the amount of tokens to be transferred
93    */
94   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value > 0 && _value <= balances[_from]);
97     require(_value <= allowed[_from][msg.sender]);
98     balances[_from] = balances[_from].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
101     Transfer(_from, _to, _value);
102     return true;
103   }
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
119   /**
120    * @dev Function to check the amount of tokens that an owner allowed to a spender.
121    * @param _owner address The address which owns the funds.
122    * @param _spender address The address which will spend the funds.
123    * @return A uint256 specifying the amount of tokens still available for the spender.
124    */
125   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
126     return allowed[_owner][_spender];
127   }
128 }
129 /**
130  * @title Ownable
131  * @dev The Ownable contract has an owner address, and provides basic authorization control
132  * functions, this simplifies the implementation of "user permissions".
133  */
134 contract Ownable {
135   address public owner;
136   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
137   /**
138    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
139    * account.
140    */
141   function Ownable() {
142     owner = msg.sender;
143   }
144   /**
145    * @dev Throws if called by any account other than the owner.
146    */
147   modifier onlyOwner() {
148     require(msg.sender == owner);
149     _;
150   }
151   /**
152    * @dev Allows the current owner to transfer control of the contract to a newOwner.
153    * @param newOwner The address to transfer ownership to.
154    */
155   function transferOwnership(address newOwner) onlyOwner public {
156     require(newOwner != address(0));
157     OwnershipTransferred(owner, newOwner);
158     owner = newOwner;
159   }
160 }
161 /**
162  * @title Pausable
163  * @dev Base contract which allows children to implement an emergency stop mechanism.
164  */
165 contract Pausable is Ownable {
166   event Pause();
167   event Unpause();
168   bool public paused = false;
169   /**
170    * @dev Modifier to make a function callable only when the contract is not paused.
171    */
172   modifier whenNotPaused() {
173     require(!paused);
174     _;
175   }
176   /**
177    * @dev Modifier to make a function callable only when the contract is paused.
178    */
179   modifier whenPaused() {
180     require(paused);
181     _;
182   }
183   /**
184    * @dev called by the owner to pause, triggers stopped state
185    */
186   function pause() onlyOwner whenNotPaused public {
187     paused = true;
188     Pause();
189   }
190   /**
191    * @dev called by the owner to unpause, returns to normal state
192    */
193   function unpause() onlyOwner whenPaused public {
194     paused = false;
195     Unpause();
196   }
197 }
198 /**
199  * @title Pausable token
200  *
201  * @dev StandardToken modified with pausable transfers.
202  **/
203 contract PausableToken is StandardToken, Pausable {
204   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
205     return super.transfer(_to, _value);
206   }
207   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
208     return super.transferFrom(_from, _to, _value);
209   }
210   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
211     return super.approve(_spender, _value);
212   }
213 }
214 /**
215  * @title Bec Token
216  *
217  * @dev Implementation of Bec Token based on the basic standard token.
218  */
219 contract BecToken is PausableToken {
220     /**
221     * Public variables of the token
222     * The following variables are OPTIONAL vanities. One does not have to include them.
223     * They allow one to customise the token contract & in no way influences the core functionality.
224     * Some wallets/interfaces might not even bother to look at this information.
225     */
226     string public name = "BeautyChain";
227     string public symbol = "BEC";
228     string public version = '1.0.1';
229     uint8 public decimals = 18;
230     /**
231      * @dev Function to check the amount of tokens that an owner allowed to a spender.
232      */
233     function BecToken() {
234       totalSupply = 7000000000 * (10**(uint256(decimals)));
235       balances[msg.sender] = totalSupply;    // Give the creator all initial tokens
236     }
237     function () {
238         //if ether is sent to this address, send it back.
239         revert();
240     }
241 }