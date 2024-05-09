1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function balanceOf(address _owner) public view returns (uint256);
9   function allowance(address _owner, address _spender) public view returns (uint256);
10   function transfer(address _to, uint256 _value) public returns (bool);
11   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
12   function approve(address _spender, uint256 _value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24     if (a == 0) {
25       return 0;
26     }
27     uint256 c = a * b;
28     assert(c / a == b);
29     return c;
30   }
31 
32   function div(uint256 a, uint256 b) internal pure returns (uint256) {
33     // assert(b > 0); // Solidity automatically throws when dividing by 0
34     uint256 c = a / b;
35     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36     return c;
37   }
38 
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 /**
52  * @title Standard ERC20 token
53  *
54  * @dev Implementation of the basic standard token.
55  * @dev https://github.com/ethereum/EIPs/issues/20
56  */
57 contract IETToken is IERC20 {
58   using SafeMath for uint256;
59 
60   // IET Token parameters
61   string public name = 'InternationalEducationChain';
62   string public symbol = 'IET';
63   uint8 public constant decimals = 18;
64   uint256 public constant decimalFactor = 10 ** uint256(decimals);
65   uint256 public constant totalSupply = 1660000000 * decimalFactor;
66   mapping (address => uint256) balances;
67   mapping (address => mapping (address => uint256)) internal allowed;
68 
69   event Transfer(address indexed from, address indexed to, uint256 value);
70   event Approval(address indexed owner, address indexed spender, uint256 value);
71 
72   /**
73   * @dev Constructor for IET creation
74   * @dev Assigns the totalSupply to the IETDistribution contract
75   */
76   function IETToken(address _IETDistributionContractAddress) public {
77     require(_IETDistributionContractAddress != address(0));
78     balances[_IETDistributionContractAddress] = totalSupply;
79     Transfer(address(0), _IETDistributionContractAddress, totalSupply);
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public view returns (uint256 balance) {
88     return balances[_owner];
89   }
90 
91   /**
92    * @dev Function to check the amount of tokens that an owner allowed to a spender.
93    * @param _owner address The address which owns the funds.
94    * @param _spender address The address which will spend the funds.
95    * @return A uint256 specifying the amount of tokens still available for the spender.
96    */
97   function allowance(address _owner, address _spender) public view returns (uint256) {
98     return allowed[_owner][_spender];
99   }
100 
101   /**
102   * @dev transfer token for a specified address
103   * @param _to The address to transfer to.
104   * @param _value The amount to be transferred.
105   */
106   function transfer(address _to, uint256 _value) public returns (bool) {
107     require(_to != address(0));
108     require(_value <= balances[msg.sender]);
109 
110     // SafeMath.sub will throw if there is not enough balance.
111     balances[msg.sender] = balances[msg.sender].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     Transfer(msg.sender, _to, _value);
114     return true;
115   }
116 
117   /**
118    * @dev Transfer tokens from one address to another
119    * @param _from address The address which you want to send tokens from
120    * @param _to address The address which you want to transfer to
121    * @param _value uint256 the amount of tokens to be transferred
122    */
123   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
124     require(_to != address(0));
125     require(_value <= balances[_from]);
126     require(_value <= allowed[_from][msg.sender]);
127 
128     balances[_from] = balances[_from].sub(_value);
129     balances[_to] = balances[_to].add(_value);
130     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
131     Transfer(_from, _to, _value);
132     return true;
133   }
134 
135   /**
136    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
137    *
138    * Beware that changing an allowance with this method brings the risk that someone may use both the old
139    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
140    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
141    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
142    * @param _spender The address which will spend the funds.
143    * @param _value The amount of tokens to be spent.
144    */
145   function approve(address _spender, uint256 _value) public returns (bool) {
146     allowed[msg.sender][_spender] = _value;
147     Approval(msg.sender, _spender, _value);
148     return true;
149   }
150 
151 }