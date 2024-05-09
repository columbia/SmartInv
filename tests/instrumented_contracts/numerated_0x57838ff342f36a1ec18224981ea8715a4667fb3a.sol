1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 /**
32  * @title ERC20 interface
33  */
34 contract ERC20 {
35   uint256 public totalSupply;
36   function balanceOf(address who) public view returns (uint256);
37   function transfer(address to, uint256 value) public returns (bool);
38   function allowance(address owner, address spender) public view returns (uint256);
39   function transferFrom(address from, address to, uint256 value) public returns (bool);
40   function approve(address spender, uint256 value) public returns (bool);
41   event Transfer(address indexed from, address indexed to, uint256 value);
42   event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 /**
46  * @title Standard ERC20 token
47  * @dev Implementation of the basic standard token.
48  */
49 contract StandardToken is ERC20 {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53   mapping (address => mapping (address => uint256)) allowed;
54 
55   /**
56    * @dev Gets the balance of the specified address.
57    * @param _owner The address to query the the balance of.
58    * @return An uint256 representing the amount owned by the passed address.
59    */
60   function balanceOf(address _owner) public view returns (uint256 balance) {
61     return balances[_owner];
62   }
63 
64   /**
65    * @dev transfer token for a specified address
66    * @param _to The address to transfer to.
67    * @param _value The amount to be transferred.
68    */
69   function transfer(address _to, uint256 _value) public returns (bool) {
70     require(_to != address(0));
71 
72     balances[msg.sender] = balances[msg.sender].sub(_value);
73     balances[_to] = balances[_to].add(_value);
74     Transfer(msg.sender, _to, _value);
75     return true;
76   }
77 
78   /**
79    * @dev Transfer tokens from one address to another
80    * @param _from address The address which you want to send tokens from
81    * @param _to address The address which you want to transfer to
82    * @param _value uint256 the amount of tokens to be transferred
83    */
84   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
85     var _allowance = allowed[_from][msg.sender];
86     require(_to != address(0));
87     require (_value <= _allowance);
88     balances[_from] = balances[_from].sub(_value);
89     balances[_to] = balances[_to].add(_value);
90     allowed[_from][msg.sender] = _allowance.sub(_value);
91     Transfer(_from, _to, _value);
92     return true;
93   }
94 
95   /**
96    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
97    * @param _spender The address which will spend the funds.
98    * @param _value The amount of tokens to be spent.
99    */
100   function approve(address _spender, uint256 _value) public returns (bool) {
101     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
102     allowed[msg.sender][_spender] = _value;
103     Approval(msg.sender, _spender, _value);
104     return true;
105   }
106 
107   /**
108    * @dev Function to check the amount of tokens that an owner allowed to a spender.
109    * @param _owner address The address which owns the funds.
110    * @param _spender address The address which will spend the funds.
111    * @return A uint256 specifying the amount of tokens still available for the spender.
112    */
113   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
114     return allowed[_owner][_spender];
115   }
116 }
117 
118 contract QUBEToken is StandardToken {
119   string public constant name = "QUBE";
120   string public constant symbol = "QUBE";
121   uint8 public constant decimals = 18;
122 
123   function QUBEToken() public {
124     totalSupply = 1000000000000000000000000000;
125     balances[msg.sender] = totalSupply;
126   }
127 }