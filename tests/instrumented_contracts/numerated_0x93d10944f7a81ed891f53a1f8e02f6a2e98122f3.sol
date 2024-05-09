1 pragma solidity ^0.4.24;
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
29  * @title Ownable
30  * @dev The Ownable contract has an owner address, and provides basic authorization control
31  * functions, this simplifies the implementation of "user permissions".
32  */
33 contract Ownable {
34   address public owner;
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   constructor() public{
41     owner = msg.sender;
42   }
43   /**
44    * @dev Throws if called by any account other than the owner.
45    */
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50   /**
51    * @dev Allows the current owner to transfer control of the contract to a newOwner.
52    * @param newOwner The address to transfer ownership to.
53    */
54   function transferOwnership(address newOwner) onlyOwner public {
55     require(newOwner != address(0));
56     emit OwnershipTransferred(owner, newOwner);
57     owner = newOwner;
58   }
59 }
60 /**
61  * @title ERC20Basic
62  * @dev Simpler version of ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/179
64  */
65 contract ERC20Basic {
66   uint256 public totalSupply;
67   function balanceOf(address who) public constant returns (uint256);
68   function transfer(address to, uint256 value) public returns (bool);
69   event Transfer(address indexed from, address indexed to, uint256 value);
70 }
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77   mapping(address => uint256) balances;
78   /**
79   * @dev transfer token for a specified address
80   * @param _to The address to transfer to.
81   * @param _value The amount to be transferred.
82   */
83   function transfer(address _to, uint256 _value) public returns (bool) {
84     require(_to != address(0));
85     // SafeMath.sub will throw if there is not enough balance.
86     balances[msg.sender] = balances[msg.sender].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     emit Transfer(msg.sender, _to, _value);
89     return true;
90   }
91   /**
92   * @dev Gets the balance of the specified address.
93   * @param _owner The address to query the the balance of.
94   * @return An uint256 representing the amount owned by the passed address.
95   */
96   function balanceOf(address _owner) public constant returns (uint256 balance) {
97     return balances[_owner];
98   }
99 }
100 /**
101  * @title ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/20
103  */
104 contract ERC20 is ERC20Basic {
105   function allowance(address owner, address spender) public constant returns (uint256);
106   function transferFrom(address from, address to, uint256 value) public returns (bool);
107   function approve(address spender, uint256 value) public returns (bool);
108   event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 /**
111  * @title Standard ERC20 token
112  *
113  * @dev Implementation of the basic standard token.
114  * @dev https://github.com/ethereum/EIPs/issues/20
115  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
116  */
117 contract StandardToken is ERC20, BasicToken {
118   mapping (address => mapping (address => uint256)) allowed;
119   /**
120    * @dev Transfer tokens from one address to another
121    * @param _from address The address which you want to send tokens from
122    * @param _to address The address which you want to transfer to
123    * @param _value uint256 the amount of tokens to be transferred
124    */
125   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
126     require(_to != address(0));
127     uint256 _allowance = allowed[_from][msg.sender];
128     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
129     // require (_value <= _allowance);
130     balances[_from] = balances[_from].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     allowed[_from][msg.sender] = _allowance.sub(_value);
133     emit Transfer(_from, _to, _value);
134     return true;
135   }
136   /**
137    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
138    *
139    * Beware that changing an allowance with this method brings the risk that someone may use both the old
140    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
141    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
142    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143    * @param _spender The address which will spend the funds.
144    * @param _value The amount of tokens to be spent.
145    */
146   function approve(address _spender, uint256 _value) public returns (bool) {
147     allowed[msg.sender][_spender] = _value;
148     emit Approval(msg.sender, _spender, _value);
149     return true;
150   }
151   /**
152    * @dev Function to check the amount of tokens that an owner allowed to a spender.
153    * @param _owner address The address which owns the funds.
154    * @param _spender address The address which will spend the funds.
155    * @return A uint256 specifying the amount of tokens still available for the spender.
156    */
157   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
158     return allowed[_owner][_spender];
159   }
160   /**
161    * approve should be called when allowed[_spender] == 0. To increment
162    * allowed value is better to use this function to avoid 2 calls (and wait until
163    * the first transaction is mined)
164    * From MonolithDAO Token.sol
165    */
166   function increaseApproval (address _spender, uint _addedValue) public
167     returns (bool success)  {
168     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
169     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172   function decreaseApproval (address _spender, uint _subtractedValue) public
173     returns (bool success) {
174     uint oldValue = allowed[msg.sender][_spender];
175     if (_subtractedValue > oldValue) {
176       allowed[msg.sender][_spender] = 0;
177     } else {
178       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
179     }
180     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181     return true;
182   }
183 }
184 /**
185  * @title Burnable Token
186  * @dev Token that can be irreversibly burned (destroyed).
187  */
188 contract BurnableToken is StandardToken, Ownable {
189     event Burn(address indexed burner, uint256 value);
190     /**
191      * @dev Burns a specific amount of tokens.
192      * @param _value The amount of token to be burned.
193      */
194     function burn(uint256 _value) onlyOwner public {
195         require(_value > 0);
196         require(_value <= balances[msg.sender]);
197         // no need to require value <= totalSupply, since that would imply the
198         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
199         address burner = msg.sender;
200         balances[burner] = balances[burner].sub(_value);
201         totalSupply = totalSupply.sub(_value);
202         emit Burn(burner, _value);
203         emit Transfer(burner, address(0), _value);
204     }
205 }
206 contract DORACoin is BurnableToken  {
207     string public constant name = "DORA coin";
208     string public constant symbol = "DOR";
209     uint public constant decimals = 6;
210     // there is no problem in using * here instead of .mul()
211     uint256 public constant initialSupply = 1200000000 * (10 ** uint256(decimals));
212     // Constructors
213     constructor() public {
214         totalSupply = initialSupply;
215         balances[msg.sender] = initialSupply; // Send all tokens to owner
216     }
217 }