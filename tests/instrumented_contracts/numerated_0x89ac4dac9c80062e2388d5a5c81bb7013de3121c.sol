1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9   uint256 public totalSupply;
10 
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   function allowance(address owner, address spender) public view returns (uint256);
14   function transferFrom(address from, address to, uint256 value) public returns (bool);
15   function approve(address spender, uint256 value) public returns (bool);
16 
17   event Approval(address indexed owner, address indexed spender, uint256 value);
18   event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that throw on error
25  */
26 library SafeMath {
27   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28     if (a == 0) {
29       return 0;
30     }
31     uint256 c = a * b;
32     assert(c / a == b);
33     return c;
34   }
35 
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   function add(uint256 a, uint256 b) internal pure returns (uint256) {
49     uint256 c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 contract CZToken is ERC20 {
56   using SafeMath for uint256;
57 
58   mapping(address => uint256) balances;
59   mapping (address => mapping (address => uint256)) internal allowed;
60 
61   string public name = "CryptowarriorZ";
62   string public symbol = "CZ";
63   uint256 public decimals = 18;
64 
65   function CZToken() public {
66     totalSupply = 6000000000 * (10 ** decimals);
67     balances[msg.sender] = totalSupply;
68   }
69 
70   /**
71   * @dev Gets the balance of the specified address.
72   * @param _owner The address to query the the balance of.
73   * @return An uint256 representing the amount owned by the passed address.
74   */
75   function balanceOf(address _owner) public view returns (uint256 balance) {
76     return balances[_owner];
77   }
78 
79   /**
80   * @dev transfer token for a specified address
81   * @param _to The address to transfer to.
82   * @param _value The amount to be transferred.
83   */
84   function transfer(address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86     require(_value <= balances[msg.sender]);
87 
88     // SafeMath.sub will throw if there is not enough balance.
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   /**
96    * @dev Transfer tokens from one address to another
97    * @param _from address The address which you want to send tokens from
98    * @param _to address The address which you want to transfer to
99    * @param _value uint256 the amount of tokens to be transferred
100    */
101   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
102     require(_to != address(0));
103     require(_value <= balances[_from]);
104     require(_value <= allowed[_from][msg.sender]);
105 
106     balances[_from] = balances[_from].sub(_value);
107     balances[_to] = balances[_to].add(_value);
108     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
109     Transfer(_from, _to, _value);
110     return true;
111   }
112 
113   /**
114    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
115    *
116    * Beware that changing an allowance with this method brings the risk that someone may use both the old
117    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
118    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
119    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
120    * @param _spender The address which will spend the funds.
121    * @param _value The amount of tokens to be spent.
122    */
123   function approve(address _spender, uint256 _value) public returns (bool) {
124     allowed[msg.sender][_spender] = _value;
125     Approval(msg.sender, _spender, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Function to check the amount of tokens that an owner allowed to a spender.
131    * @param _owner address The address which owns the funds.
132    * @param _spender address The address which will spend the funds.
133    * @return A uint256 specifying the amount of tokens still available for the spender.
134    */
135   function allowance(address _owner, address _spender) public view returns (uint256) {
136     return allowed[_owner][_spender];
137   }
138 
139   event Transfer(address indexed from, address indexed to, uint256 value);
140   event Approval(address indexed owner, address indexed spender, uint256 value);
141 }