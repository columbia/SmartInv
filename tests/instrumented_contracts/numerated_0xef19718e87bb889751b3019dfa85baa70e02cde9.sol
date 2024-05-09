1 pragma solidity ^0.4.21;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 /**
31  * @title ERC20 interface
32  */
33 contract ERC20 {
34   uint256 public totalSupply;
35   function balanceOf(address who) public view returns (uint256);
36   function transfer(address to, uint256 value) public returns (bool);
37   function allowance(address owner, address spender) public view returns (uint256);
38   function transferFrom(address from, address to, uint256 value) public returns (bool);
39   function approve(address spender, uint256 value) public returns (bool);
40   event Transfer(address indexed from, address indexed to, uint256 value);
41   event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 /**
45  * @title Standard ERC20 token
46  *
47  * @dev Implementation of the basic standard token.
48  * @dev https://github.com/ethereum/EIPs/issues/20
49  */
50 contract StandardToken is ERC20 {
51   using SafeMath for uint256;
52 
53   mapping(address => uint256) balances;
54   mapping (address => mapping (address => uint256)) allowed;
55 
56   /**
57    * @dev Gets the balance of the specified address.
58    * @param _owner The address to query the the balance of.
59    * @return An uint256 representing the amount owned by the passed address.
60    */
61   function balanceOf(address _owner) public view returns (uint256 balance) {
62     return balances[_owner];
63   }
64 
65   /**
66    * @dev transfer token for a specified address
67    * @param _to The address to transfer to.
68    * @param _value The amount to be transferred.
69    */
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72 
73     // SafeMath.sub will throw if there is not enough balance.
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     emit Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   /**
81    * @dev Transfer tokens from one address to another
82    * @param _from address The address which you want to send tokens from
83    * @param _to address The address which you want to transfer to
84    * @param _value uint256 the amount of tokens to be transferred
85    */
86   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
87     uint256 _allowance = allowed[_from][msg.sender];
88     require(_to != address(0));
89     require (_value <= _allowance);
90     balances[_from] = balances[_from].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     allowed[_from][msg.sender] = _allowance.sub(_value);
93     emit Transfer(_from, _to, _value);
94     return true;
95   }
96 
97   /**
98    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
99    * @param _spender The address which will spend the funds.
100    * @param _value The amount of tokens to be spent.
101    */
102   function approve(address _spender, uint256 _value) public returns (bool) {
103     // To change the approve amount you first have to reduce the addresses`
104     //  allowance to zero by calling `approve(_spender, 0)` if it is not
105     //  already 0 to mitigate the race condition described here:
106     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
107     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
108     allowed[msg.sender][_spender] = _value;
109     emit Approval(msg.sender, _spender, _value);
110     return true;
111   }
112 
113   /**
114    * @dev Function to check the amount of tokens that an owner allowed to a spender.
115    * @param _owner address The address which owns the funds.
116    * @param _spender address The address which will spend the funds.
117    * @return A uint256 specifying the amount of tokens still available for the spender.
118    */
119   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
120     return allowed[_owner][_spender];
121   }
122 }
123 
124 contract VVToken is StandardToken {
125   string public constant name = "VVeljk Token";
126   string public constant symbol = "VVT";
127   uint8 public constant decimals = 18;
128 
129   function VVToken() public {
130     totalSupply = 300000000 * 10**uint(decimals);
131     balances[msg.sender] = totalSupply;
132   }
133 }