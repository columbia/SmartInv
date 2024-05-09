1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28   function toUINT112(uint256 a) internal pure returns(uint112) {
29     assert(uint112(a) == a);
30     return uint112(a);
31   }
32 
33   function toUINT120(uint256 a) internal pure returns(uint120) {
34     assert(uint120(a) == a);
35     return uint120(a);
36   }
37 
38   function toUINT128(uint256 a) internal pure returns(uint128) {
39     assert(uint128(a) == a);
40     return uint128(a);
41   }
42 }
43 
44 contract ERC20Basic {
45   uint256 public totalSupply;
46   function balanceOf(address who) public constant returns (uint256);
47   function transfer(address to, uint256 value) public returns (bool);
48   event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 contract ERC20 is ERC20Basic {
52   function allowance(address owner, address spender) public constant returns (uint256);
53   function transferFrom(address from, address to, uint256 value) public returns (bool);
54   function approve(address spender, uint256 value) public returns (bool);
55   event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 contract BasicToken is ERC20Basic {
59   using SafeMath for uint256;
60 
61   mapping(address => uint256) balances;
62 
63   /**
64   * @dev transfer token for a specified address
65   * @param _to The address to transfer to.
66   * @param _value The amount to be transferred.
67   */
68   function transfer(address _to, uint256 _value) public returns (bool) {
69     require(_to != address(0));
70     require(_value <= balances[msg.sender]);
71 
72     // SafeMath.sub will throw if there is not enough balance.
73     balances[msg.sender] = balances[msg.sender].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     Transfer(msg.sender, _to, _value);
76     return true;
77   }
78 
79   /**
80   * @dev Gets the balance of the specified address.
81   * @param _owner The address to query the the balance of.
82   * @return An uint256 representing the amount owned by the passed address.
83   */
84   function balanceOf(address _owner) public constant returns (uint256 balance) {
85     return balances[_owner];
86   }
87 
88 }
89 
90 contract StandardToken is ERC20, BasicToken {
91 
92   mapping (address => mapping (address => uint256)) internal allowed;
93 
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
124     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
125     allowed[msg.sender][_spender] = _value;
126     Approval(msg.sender, _spender, _value);
127     return true;
128   }
129 
130   /**
131    * @dev Function to check the amount of tokens that an owner allowed to a spender.
132    * @param _owner address The address which owns the funds.
133    * @param _spender address The address which will spend the funds.
134    * @return A uint256 specifying the amount of tokens still available for the spender.
135    */
136   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
137     return allowed[_owner][_spender];
138   }
139 
140 }
141 
142 contract AEFTOKEN is StandardToken {
143 
144   string public constant name = "AISI ECO FOF";
145   string public constant symbol = "aef";
146   uint8 public constant decimals = 18;
147 
148   uint256 public constant INITIAL_SUPPLY = 180000000 * (10 ** uint256(decimals));
149 
150   /**
151    * @dev Constructor that gives msg.sender all of existing tokens.
152    */
153   function AEFTOKEN() public {
154     totalSupply = INITIAL_SUPPLY;
155     balances[msg.sender] = INITIAL_SUPPLY;
156   }
157 }