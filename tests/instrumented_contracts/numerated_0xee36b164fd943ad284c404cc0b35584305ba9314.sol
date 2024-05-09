1 pragma solidity ^0.4.23;/**
2  * @title ERC20Basic
3  * @dev Simpler version of ERC20 interface
4  * @dev see https://github.com/ethereum/EIPs/issues/179
5  */
6 contract ERC20Basic {
7   uint256 public totalSupply;
8   function balanceOf(address who) public constant returns (uint256);
9   function transfer(address to, uint256 value) public returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 /**
13  * @title SafeMath
14  * @dev Math operations with safety checks that throw on error
15  */
16 library SafeMath {
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     uint256 c = a * b;
19     assert(a == 0 || c / a == b);
20     return c;
21   }
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 /**
39  * @title Basic token
40  * @dev Basic version of StandardToken, with no allowances.
41  */
42 contract BasicToken is ERC20Basic {
43   using SafeMath for uint256;
44   mapping(address => uint256) balances;
45   /**
46   * @dev transfer token for a specified address
47   * @param _to The address to transfer to.
48   * @param _value The amount to be transferred.
49   */
50   function transfer(address _to, uint256 _value) public returns (bool) {
51     require(_to != address(0));
52     // SafeMath.sub will throw if there is not enough balance.
53     balances[msg.sender] = balances[msg.sender].sub(_value);
54     balances[_to] = balances[_to].add(_value);
55     emit Transfer(msg.sender, _to, _value);
56     return true;
57   }
58   /**
59   * @dev Gets the balance of the specified address.
60   * @param _owner The address to query the the balance of.
61   * @return An uint256 representing the amount owned by the passed address.
62   */
63   function balanceOf(address _owner) public constant returns (uint256 balance) {
64     return balances[_owner];
65   }
66 }
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 contract ERC20 is ERC20Basic {
72   function allowance(address owner, address spender) public constant returns (uint256);
73   function transferFrom(address from, address to, uint256 value) public returns (bool);
74   function approve(address spender, uint256 value) public returns (bool);
75   event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 /**
78  * @title Standard ERC20 token
79  *
80  * @dev Implementation of the basic standard token.
81  * @dev https://github.com/ethereum/EIPs/issues/20
82  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
83  */
84 contract StandardToken is ERC20, BasicToken {
85   mapping (address => mapping (address => uint256)) allowed;
86   /**
87    * @dev Transfer tokens from one address to another
88    * @param _from address The address which you want to send tokens from
89    * @param _to address The address which you want to transfer to
90    * @param _value uint256 the amount of tokens to be transferred
91    */
92   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
93     require(_to != address(0));
94     uint256 _allowance = allowed[_from][msg.sender];
95     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
96     // require (_value <= _allowance);
97     balances[_from] = balances[_from].sub(_value);
98     balances[_to] = balances[_to].add(_value);
99     allowed[_from][msg.sender] = _allowance.sub(_value);
100     emit Transfer(_from, _to, _value);
101     return true;
102   }
103   /**
104    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
105    *
106    * Beware that changing an allowance with this method brings the risk that someone may use both the old
107    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
108    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
109    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
110    * @param _spender The address which will spend the funds.
111    * @param _value The amount of tokens to be spent.
112    */
113   function approve(address _spender, uint256 _value) public returns (bool) {
114     allowed[msg.sender][_spender] = _value;
115     emit Approval(msg.sender, _spender, _value);
116     return true;
117   }
118   /**
119    * @dev Function to check the amount of tokens that an owner allowed to a spender.
120    * @param _owner address The address which owns the funds.
121    * @param _spender address The address which will spend the funds.
122    * @return A uint256 specifying the amount of tokens still available for the spender.
123    */
124   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
125     return allowed[_owner][_spender];
126   }
127   /**
128    * approve should be called when allowed[_spender] == 0. To increment
129    * allowed value is better to use this function to avoid 2 calls (and wait until
130    * the first transaction is mined)
131    * From MonolithDAO Token.sol
132    */
133   function increaseApproval (address _spender, uint _addedValue) public
134     returns (bool success) {
135     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
136     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
137     return true;
138   }
139   function decreaseApproval (address _spender, uint _subtractedValue) public
140     returns (bool success) {
141     uint oldValue = allowed[msg.sender][_spender];
142     if (_subtractedValue > oldValue) {
143       allowed[msg.sender][_spender] = 0;
144     } else {
145       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
146     }
147     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148     return true;
149   }
150 }
151 
152 contract Ownable {
153   address public owner;
154   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
155   /**
156    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
157    * account.
158    */
159   constructor() public{
160     owner = msg.sender;
161   }
162   /**
163    * @dev Throws if called by any account other than the owner.
164    */
165   modifier onlyOwner() {
166     require(msg.sender == owner);
167     _;
168   }
169   /**
170    * @dev Allows the current owner to transfer control of the contract to a newOwner.
171    * @param newOwner The address to transfer ownership to.
172    */
173   function transferOwnership(address newOwner) onlyOwner public {
174     require(newOwner != address(0));
175     emit OwnershipTransferred(owner, newOwner);
176     owner = newOwner;
177   }
178 }
179 
180 contract DigiBit is StandardToken, Ownable {
181   string public name = "DigiBit";
182   string public symbol = "DBIT";
183   uint256 public decimals = 18;
184   uint256 public constant INITIAL_SUPPLY = 2500000000 * (10 ** uint256(18));
185 
186   event Burn(address indexed owner, uint256 value);
187 
188   /**
189    * @dev Constructor that gives msg.sender all of existing tokens.
190    */
191   constructor() public{
192     totalSupply = INITIAL_SUPPLY;
193     balances[msg.sender] = INITIAL_SUPPLY;
194   }
195 
196   function burn(uint256 _value) public onlyOwner returns (bool) {
197     require(balances[msg.sender] >= _value);
198     balances[msg.sender] = balances[msg.sender].sub(_value);
199     totalSupply = totalSupply.sub(_value);
200     emit Burn(msg.sender, _value);
201     return true;
202   }
203 }