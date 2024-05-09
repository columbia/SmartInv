1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title ERC20 interface
5  */
6 interface HERC20 {
7   function balanceOf(address _owner) public view returns (uint256);
8   function allowance(address _owner, address _spender) public view returns (uint256);
9   function transfer(address _to, uint256 _value) public returns (bool);
10   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
11   function approve(address _spender, uint256 _value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13   event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23     if (a == 0) {
24       return 0;
25     }
26     uint256 c = a * b;
27     assert(c / a == b);
28     return c;
29   }
30 
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title Standard ERC20 token
52  *
53  * @dev Implementation of the basic standard token.
54  * @dev https://github.com/ethereum/EIPs/issues/20
55  */
56 contract HPToken is HERC20 {
57   using SafeMath for uint256;
58 
59   string public name = 'Healthy Physique Token';
60   string public symbol = 'HPT';
61   uint8 public constant decimals = 18;
62   uint256 public constant decimalFactor = 10 ** uint256(decimals);
63   uint256 public constant totalSupply = 2000000000 * decimalFactor;
64   mapping (address => uint256) balances;
65   mapping (address => mapping (address => uint256)) internal allowed;
66 
67   event Transfer(address indexed from, address indexed to, uint256 value);
68   event Approval(address indexed owner, address indexed spender, uint256 value);
69 
70   /**
71   * @dev Constructor for HPToken creation
72   * @dev Assigns the totalSupply to the HPToken contract
73   */
74   function HPToken() public {
75     balances[msg.sender] = totalSupply;
76   }
77 
78   /**
79   * @dev Gets the balance of the specified address.
80   * @param _owner The address to query the the balance of.
81   * @return An uint256 representing the amount owned by the passed address.
82   */
83   function balanceOf(address _owner) public view returns (uint256 balance) {
84     return balances[_owner];
85   }
86 
87   /**
88    * @dev Function to check the amount of tokens that an owner allowed to a spender.
89    * @param _owner address The address which owns the funds.
90    * @param _spender address The address which will spend the funds.
91    * @return A uint256 specifying the amount of tokens still available for the spender.
92    */
93   function allowance(address _owner, address _spender) public view returns (uint256) {
94     return allowed[_owner][_spender];
95   }
96 
97   /**
98   * @dev transfer token for a specified address
99   * @param _to The address to transfer to.
100   * @param _value The amount to be transferred.
101   */
102   function transfer(address _to, uint256 _value) public returns (bool) {
103     require(_to != address(0));
104     require(_value <= balances[msg.sender]);
105     // SafeMath.sub will throw if there is not enough balance.
106     balances[msg.sender] = balances[msg.sender].sub(_value);
107     balances[_to] = balances[_to].add(_value);
108     emit Transfer(msg.sender, _to, _value);
109     return true;
110   }
111 
112   /**
113    * @dev Transfer tokens from one address to another
114    * @param _from address The address which you want to send tokens from
115    * @param _to address The address which you want to transfer to
116    * @param _value uint256 the amount of tokens to be transferred
117    */
118   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120     require(_value <= balances[_from]);
121     require(_value <= allowed[_from][msg.sender]);
122 
123     balances[_from] = balances[_from].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126     emit Transfer(_from, _to, _value);
127     return true;
128   }
129 
130   /**
131    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
132    *
133    * Beware that changing an allowance with this method brings the risk that someone may use both the old
134    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
135    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
136    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137    * @param _spender The address which will spend the funds.
138    * @param _value The amount of tokens to be spent.
139    */
140   function approve(address _spender, uint256 _value) public returns (bool) {
141     allowed[msg.sender][_spender] = _value;
142     emit Approval(msg.sender, _spender, _value);
143     return true;
144   }
145 
146 }