1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
11   */
12   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13     assert(b <= a);
14     return a - b;
15   }
16 
17   /**
18   * @dev Adds two numbers, throws on overflow.
19   */
20   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
21     c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 /**
28  * @title ERC20Basic
29  * @dev Simpler version of ERC20 interface
30  * @dev see https://github.com/ethereum/EIPs/issues/179
31  */
32 contract ERC20Basic {
33   function totalSupply() public view returns (uint256);
34   function balanceOf(address who) public view returns (uint256);
35   function transfer(address to, uint256 value) public returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract ERC20 is ERC20Basic {
40   function allowance(address owner, address spender) public view returns (uint256);
41   function transferFrom(address from, address to, uint256 value) public returns (bool);
42   function approve(address spender, uint256 value) public returns (bool);
43   event Approval( address indexed owner, address indexed spender, uint256 value );
44 }
45 
46 /**
47  * @title Basic token
48  * @dev Basic version of StandardToken, with no allowances.
49  */
50 contract BasicToken is ERC20Basic {
51   using SafeMath for uint256;
52 
53   mapping(address => uint256) internal balances;
54 
55   uint256 internal totalSupply_;
56 
57   /**
58   * @dev total number of tokens in existence
59   */
60   function totalSupply() public view returns (uint256) {
61     return totalSupply_;
62   }
63 
64   /**
65   * @dev transfer token for a specified address
66   * @param _to The address to transfer to.
67   * @param _value The amount to be transferred.
68   */
69   function transfer(address _to, uint256 _value) public returns (bool) {
70     require(_to != address(0));
71     require(_value <= balances[msg.sender]);
72 
73     balances[msg.sender] = balances[msg.sender].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     emit Transfer(msg.sender, _to, _value);
76     return true;
77   }
78 
79   /**
80   * @dev Gets the balance of the specified address.
81   * @param _owner The address to query the the balance of.
82   * @return An uint256 representing the amount owned by the passed address.
83   */
84   function balanceOf(address _owner) public view returns (uint256) {
85     return balances[_owner];
86   }
87 
88 }
89 
90 /**
91  * @title Standard ERC20 token
92  *
93  * @dev Implementation of the basic standard token.
94  * @dev https://github.com/ethereum/EIPs/issues/20
95  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
96  */
97 contract StandardToken is ERC20, BasicToken {
98 
99   mapping (address => mapping (address => uint256)) internal allowed;
100 
101 
102   /**
103    * @dev Transfer tokens from one address to another
104    * @param _from address The address which you want to send tokens from
105    * @param _to address The address which you want to transfer to
106    * @param _value uint256 the amount of tokens to be transferred
107    */
108   function transferFrom( address _from, address _to, uint256 _value ) public returns (bool) {
109     require(_to != address(0));
110     require(_value <= balances[_from]);
111     require(_value <= allowed[_from][msg.sender]);
112 
113     balances[_from] = balances[_from].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
116     emit Transfer(_from, _to, _value);
117     return true;
118   }
119 
120   /**
121    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
122    * @param _spender The address which will spend the funds.
123    * @param _value The amount of tokens to be spent.
124    */
125   function approve(address _spender, uint256 _value) public returns (bool) {
126     allowed[msg.sender][_spender] = _value;
127     emit Approval(msg.sender, _spender, _value);
128     return true;
129   }
130 
131   /**
132    * @dev Function to check the amount of tokens that an owner allowed to a spender.
133    * @param _owner address The address which owns the funds.
134    * @param _spender address The address which will spend the funds.
135    * @return A uint256 specifying the amount of tokens still available for the spender.
136    */
137   function allowance( address _owner, address _spender ) public view returns (uint256) {
138     return allowed[_owner][_spender];
139   }
140 }
141 
142 contract HFCToken is StandardToken {
143   string public name;
144   string public symbol;
145   uint8 public decimals;
146 
147   constructor() public {
148     name = "HFCToken";
149     symbol = "HFC";
150     decimals = 8;
151     totalSupply_ = 100000000000000000;
152     balances[0xB97f41cc340899DbA210BdCc86a912ef100eFE96] = totalSupply_;
153     emit Transfer(address(0), 0xB97f41cc340899DbA210BdCc86a912ef100eFE96, totalSupply_);
154   }
155 }