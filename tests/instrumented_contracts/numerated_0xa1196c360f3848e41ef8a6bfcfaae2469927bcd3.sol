1 pragma solidity ^0.4.17;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9 
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12 
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 contract Ownable {
17   address public owner;
18   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   function Ownable() public {
24     owner = msg.sender;
25   }
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner public {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 }
43 
44 /**
45  * @title SafeMath
46  * @dev Math operations with safety checks that throw on error
47  */
48 library SafeMath {
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a * b;
51     assert(a == 0 || c / a == b);
52     return c;
53   }
54   function div(uint256 a, uint256 b) internal pure returns (uint256) {
55     // assert(b > 0); // Solidity automatically throws when dividing by 0
56     uint256 c = a / b;
57     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58     return c;
59   }
60   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61     assert(b <= a);
62     return a - b;
63   }
64   function add(uint256 a, uint256 b) internal pure returns (uint256) {
65     uint256 c = a + b;
66     assert(c >= a);
67     return c;
68   }
69 }
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract SafeBasicToken is ERC20Basic {
76   using SafeMath for uint256;
77   mapping(address => uint256) balances;
78 
79   // Avoid Short Address Attack
80   modifier onlyPayloadSize(uint size) {
81      assert(msg.data.length >= size + 4);
82      _;
83   }
84   /**
85   * @dev transfer token for a specified address
86   * @param _to The address to transfer to.
87   * @param _value The amount to be transferred.
88   */
89   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
90     require(_to != address(0));
91     // SafeMath.sub will throw if there is not enough balance.
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97   /**
98   * @dev Gets the balance of the specified address.
99   * @param _owner The address to query the the balance of.
100   * @return An uint256 representing the amount owned by the passed address.
101   */
102   function balanceOf(address _owner) public constant returns (uint256 balance) {
103     return balances[_owner];
104   }
105 }
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112   function allowance(address owner, address spender) public constant returns (uint256);
113   function transferFrom(address from, address to, uint256 value) public returns (bool);
114   function approve(address spender, uint256 value) public returns (bool);
115   event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 /**
119  * @title Standard ERC20 token
120  *
121  * @dev Implementation of the basic standard token.
122  * @dev https://github.com/ethereum/EIPs/issues/20
123  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
124  */
125 contract SafeStandardToken is ERC20, SafeBasicToken {
126   mapping (address => mapping (address => uint256)) allowed;
127   /**
128    * @dev Transfer tokens from one address to another
129    * @param _from address The address which you want to send tokens from
130    * @param _to address The address which you want to transfer to
131    * @param _value uint256 the amount of tokens to be transferred
132    */
133   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
134     require(_to != address(0));
135     uint256 _allowance = allowed[_from][msg.sender];
136     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
137     // require (_value <= _allowance);
138     balances[_from] = balances[_from].sub(_value);
139     balances[_to] = balances[_to].add(_value);
140     allowed[_from][msg.sender] = _allowance.sub(_value);
141     emit Transfer(_from, _to, _value);
142     return true;
143   }
144   /**
145    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
146    *
147    * Beware that changing an allowance with this method brings the risk that someone may use both the old
148    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
149    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
150    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151    * @param _spender The address which will spend the funds.
152    * @param _value The amount of tokens to be spent.
153    */
154   function approve(address _spender, uint256 _value) public returns (bool) {
155     allowed[msg.sender][_spender] = _value;
156     emit Approval(msg.sender, _spender, _value);
157     return true;
158   }
159   /**
160    * @dev Function to check the amount of tokens that an owner allowed to a spender.
161    * @param _owner address The address which owns the funds.
162    * @param _spender address The address which will spend the funds.
163    * @return A uint256 specifying the amount of tokens still available for the spender.
164    */
165   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
166     return allowed[_owner][_spender];
167   }
168   /**
169    * approve should be called when allowed[_spender] == 0. To increment
170    * allowed value is better to use this function to avoid 2 calls (and wait until
171    * the first transaction is mined)
172    * From MonolithDAO Token.sol
173    */
174   function increaseApproval (address _spender, uint _addedValue) public
175     returns (bool success) {
176     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
177     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
178     return true;
179   }
180   function decreaseApproval (address _spender, uint _subtractedValue) public
181     returns (bool success) {
182     uint oldValue = allowed[msg.sender][_spender];
183     if (_subtractedValue > oldValue) {
184       allowed[msg.sender][_spender] = 0;
185     } else {
186       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
187     }
188     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189     return true;
190   }
191 }
192 
193 contract JESToken is SafeStandardToken{
194   string public constant name = "JES Token";
195   string public constant symbol = "JES";
196   uint256 public constant decimals = 18;
197   uint256 public constant INITIAL_SUPPLY = 100000000000 * (10 ** uint256(decimals));
198 
199   function JESToken() public {
200     totalSupply = INITIAL_SUPPLY;
201     balances[msg.sender] = INITIAL_SUPPLY;
202   }
203 }