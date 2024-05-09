1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7  contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) constant returns (uint256);
10   function transfer(address to, uint256 value) returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 contract ERC20 is ERC20Basic {
14   function allowance(address owner, address spender) constant returns (uint256);
15   function transferFrom(address from, address to, uint256 value) returns (bool);
16   function approve(address spender, uint256 value) returns (bool);
17   event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 library SafeMath {
21   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
22     uint256 c = a * b;
23     assert(a == 0 || c / a == b);
24     return c;
25   }
26 
27   function div(uint256 a, uint256 b) internal constant returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function add(uint256 a, uint256 b) internal constant returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 contract BasicToken is ERC20Basic {
46   using SafeMath for uint256;
47 
48   mapping(address => uint256) balances;
49 
50   /**
51   * @dev transfer token for a specified address
52   * @param _to The address to transfer to.
53   * @param _value The amount to be transferred.
54   */
55   function transfer(address _to, uint256 _value) returns (bool) {
56     balances[msg.sender] = balances[msg.sender].sub(_value);
57     balances[_to] = balances[_to].add(_value);
58     Transfer(msg.sender, _to, _value);
59     return true;
60   }
61 
62   /**
63   * @dev Gets the balance of the specified address.
64   * @param _owner The address to query the the balance of. 
65   * @return An uint256 representing the amount owned by the passed address.
66   */
67   function balanceOf(address _owner) constant returns (uint256 balance) {
68     return balances[_owner];
69   }
70 
71 }
72 contract StandardToken is ERC20, BasicToken {
73 
74   mapping (address => mapping (address => uint256)) allowed;
75 
76 
77   /**
78    * @dev Transfer tokens from one address to another
79    * @param _from address The address which you want to send tokens from
80    * @param _to address The address which you want to transfer to
81    * @param _value uint256 the amout of tokens to be transfered
82    */
83   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
84     var _allowance = allowed[_from][msg.sender];
85 
86     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
87     // require (_value <= _allowance);
88 
89     balances[_to] = balances[_to].add(_value);
90     balances[_from] = balances[_from].sub(_value);
91     allowed[_from][msg.sender] = _allowance.sub(_value);
92     Transfer(_from, _to, _value);
93     return true;
94   }
95 
96   /**
97    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
98    * @param _spender The address which will spend the funds.
99    * @param _value The amount of tokens to be spent.
100    */
101   function approve(address _spender, uint256 _value) returns (bool) {
102 
103     // To change the approve amount you first have to reduce the addresses`
104     //  allowance to zero by calling `approve(_spender, 0)` if it is not
105     //  already 0 to mitigate the race condition described here:
106     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
107     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
108 
109     allowed[msg.sender][_spender] = _value;
110     Approval(msg.sender, _spender, _value);
111     return true;
112   }
113 
114   /**
115    * @dev Function to check the amount of tokens that an owner allowed to a spender.
116    * @param _owner address The address which owns the funds.
117    * @param _spender address The address which will spend the funds.
118    * @return A uint256 specifing the amount of tokens still available for the spender.
119    */
120   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
121     return allowed[_owner][_spender];
122   }
123 
124 }
125 
126 contract PremineToken2 is StandardToken {
127   using SafeMath for uint256;
128 
129   string public name = "Premine Token";
130   string public symbol = "PRE";
131   uint public decimals = 18;
132   uint256 public initialSupply = 1000000000000000000000000000;
133   function PremineToken2() {
134     totalSupply = initialSupply;
135     balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
136     totalSupply = initialSupply;                        // Update total supply
137   }
138    mapping (address => uint256) public balanceOf;
139    mapping (address => mapping (address => uint256)) public allowance;
140   
141 }