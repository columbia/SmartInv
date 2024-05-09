1 pragma solidity ^0.4.15;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value) returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) returns (bool);
13   function approve(address spender, uint256 value) returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SafeMath {
18   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
19     uint256 c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal constant returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal constant returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 contract BasicToken is ERC20Basic {
44   using SafeMath for uint256;
45 
46   mapping(address => uint256) balances;
47 
48   /**
49   * @dev transfer token for a specified address
50   * @param _to The address to transfer to.
51   * @param _value The amount to be transferred.
52   */
53   function transfer(address _to, uint256 _value) returns (bool) {
54     balances[msg.sender] = balances[msg.sender].sub(_value);
55     balances[_to] = balances[_to].add(_value);
56     Transfer(msg.sender, _to, _value);
57     return true;
58   }
59 
60   /**
61   * @dev Gets the balance of the specified address.
62   * @param _owner The address to query the the balance of.
63   * @return An uint256 representing the amount owned by the passed address.
64   */
65   function balanceOf(address _owner) constant returns (uint256 balance) {
66     return balances[_owner];
67   }
68 
69 }
70 
71 contract StandardToken is ERC20, BasicToken {
72 
73   mapping (address => mapping (address => uint256)) allowed;
74 
75 
76   /**
77    * @dev Transfer tokens from one address to another
78    * @param _from address The address which you want to send tokens from
79    * @param _to address The address which you want to transfer to
80    * @param _value uint256 the amout of tokens to be transfered
81    */
82   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
83     var _allowance = allowed[_from][msg.sender];
84 
85     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
86     // require (_value <= _allowance);
87 
88     balances[_to] = balances[_to].add(_value);
89     balances[_from] = balances[_from].sub(_value);
90     allowed[_from][msg.sender] = _allowance.sub(_value);
91     Transfer(_from, _to, _value);
92     return true;
93   }
94 
95   /**
96    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
97    * @param _spender The address which will spend the funds.
98    * @param _value The amount of tokens to be spent.
99    */
100   function approve(address _spender, uint256 _value) returns (bool) {
101 
102     // To change the approve amount you first have to reduce the addresses`
103     //  allowance to zero by calling `approve(_spender, 0)` if it is not
104     //  already 0 to mitigate the race condition described here:
105     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
106     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
107 
108     allowed[msg.sender][_spender] = _value;
109     Approval(msg.sender, _spender, _value);
110     return true;
111   }
112 
113   /**
114    * @dev Function to check the amount of tokens that an owner allowed to a spender.
115    * @param _owner address The address which owns the funds.
116    * @param _spender address The address which will spend the funds.
117    * @return A uint256 specifing the amount of tokens still avaible for the spender.
118    */
119   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
120     return allowed[_owner][_spender];
121   }
122 
123 }
124 
125 contract Ownable {
126   address public owner;
127 
128 
129   /**
130    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
131    * account.
132    */
133   function Ownable() {
134     owner = msg.sender;
135   }
136 
137 
138   /**
139    * @dev Throws if called by any account other than the owner.
140    */
141   modifier onlyOwner() {
142     require(msg.sender == owner);
143     _;
144   }
145 
146 
147   /**
148    * @dev Allows the current owner to transfer control of the contract to a newOwner.
149    * @param newOwner The address to transfer ownership to.
150    */
151   function transferOwnership(address newOwner) onlyOwner {
152     if (newOwner != address(0)) {
153       owner = newOwner;
154     }
155   }
156 
157 }
158 
159 contract BRC is StandardToken, Ownable {
160   string public constant name = "BinaryCoin";
161   string public constant symbol = "BRC";
162   uint8 public constant decimals = 8;
163   uint256 public constant INITIAL_SUPPLY = 10000000 * 10 ** uint256(decimals); // 10.000.000 Tokens
164 
165   function BRC() {
166       totalSupply = INITIAL_SUPPLY;
167       balances[msg.sender] = INITIAL_SUPPLY;
168       owner = msg.sender;
169   }
170 }