1 pragma solidity ^0.4.24;
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
47  *
48  * @dev Implementation of the basic standard token.
49  * @dev https://github.com/ethereum/EIPs/issues/20
50  */
51 contract StandardToken is ERC20 {
52   using SafeMath for uint256;
53 
54   mapping(address => uint256) balances;
55   mapping (address => mapping (address => uint256)) allowed;
56 
57   /**
58    * @dev Gets the balance of the specified address.
59    * @param _owner The address to query the the balance of.
60    * @return An uint256 representing the amount owned by the passed address.
61    */
62   function balanceOf(address _owner) public view returns (uint256 balance) {
63     return balances[_owner];
64   }
65 
66   /**
67    * @dev transfer token for a specified address
68    * @param _to The address to transfer to.
69    * @param _value The amount to be transferred.
70    */
71   function transfer(address _to, uint256 _value) public returns (bool) {
72     require(_to != address(0));
73 
74     // SafeMath.sub will throw if there is not enough balance.
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   /**
82    * @dev Transfer tokens from one address to another
83    * @param _from address The address which you want to send tokens from
84    * @param _to address The address which you want to transfer to
85    * @param _value uint256 the amount of tokens to be transferred
86    */
87   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
88     var _allowance = allowed[_from][msg.sender];
89     require(_to != address(0));
90     require (_value <= _allowance);
91     balances[_from] = balances[_from].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     allowed[_from][msg.sender] = _allowance.sub(_value);
94     Transfer(_from, _to, _value);
95     return true;
96   }
97 
98   /**
99    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
100    * @param _spender The address which will spend the funds.
101    * @param _value The amount of tokens to be spent.
102    */
103   function approve(address _spender, uint256 _value) public returns (bool) {
104     // To change the approve amount you first have to reduce the addresses`
105     //  allowance to zero by calling `approve(_spender, 0)` if it is not
106     //  already 0 to mitigate the race condition described here:
107     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
108     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
109     allowed[msg.sender][_spender] = _value;
110     Approval(msg.sender, _spender, _value);
111     return true;
112   }
113 
114   /**
115    * @dev Function to check the amount of tokens that an owner allowed to a spender.
116    * @param _owner address The address which owns the funds.
117    * @param _spender address The address which will spend the funds.
118    * @return A uint256 specifying the amount of tokens still available for the spender.
119    */
120   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
121     return allowed[_owner][_spender];
122   }
123 }
124 
125 contract Presalezillion is StandardToken {
126   string public constant name = "Presalezillion";
127   string public constant symbol = "Zylion";
128   uint8 public constant decimals = 0;
129 
130   function Presalezillion() public {
131     totalSupply = 10500000000;  
132     balances[msg.sender] = totalSupply;
133   }
134 }