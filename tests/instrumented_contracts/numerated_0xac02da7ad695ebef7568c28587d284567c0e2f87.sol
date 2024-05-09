1 pragma solidity ^0.4.18;
2 
3 /* Token creado con fines educativos. todos los derechos reservados al Tio WEA. */
4 
5 
6 contract ERC20Basic {
7   uint256 public totalSupply;
8   function balanceOf(address who) public view returns (uint256);
9   function transfer(address to, uint256 value) public returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 
14 
15 contract ERC20 is ERC20Basic {
16   function allowance(address owner, address spender) public view returns (uint256);
17   function transferFrom(address from, address to, uint256 value) public returns (bool);
18   function approve(address spender, uint256 value) public returns (bool);
19   event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 
23 contract BasicToken is ERC20Basic {
24   using SafeMath for uint256;
25 
26   mapping(address => uint256) balances;
27 
28 
29   function transfer(address _to, uint256 _value) public returns (bool) {
30     require(_to != address(0));
31     require(_value <= balances[msg.sender]);
32 
33     // SafeMath.sub will throw if there is not enough balance.
34     balances[msg.sender] = balances[msg.sender].sub(_value);
35     balances[_to] = balances[_to].add(_value);
36     Transfer(msg.sender, _to, _value);
37     return true;
38   }
39 
40 
41   function balanceOf(address _owner) public view returns (uint256 balance) {
42     return balances[_owner];
43   }
44 
45 }
46 
47 /* protección de operaciones matemáticas, si un token no tiene safemath véndelo ahora! */
48 
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   /**
74   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 
92 contract StandardToken is ERC20, BasicToken {
93 
94   mapping (address => mapping (address => uint256)) internal allowed;
95 
96 
97   
98   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
99     require(_to != address(0));
100     require(_value <= balances[_from]);
101     require(_value <= allowed[_from][msg.sender]);
102 
103     balances[_from] = balances[_from].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
106     Transfer(_from, _to, _value);
107     return true;
108   }
109 
110 
111   function approve(address _spender, uint256 _value) public returns (bool) {
112     allowed[msg.sender][_spender] = _value;
113     Approval(msg.sender, _spender, _value);
114     return true;
115   }
116 
117   
118   function allowance(address _owner, address _spender) public view returns (uint256) {
119     return allowed[_owner][_spender];
120   }
121 
122  
123   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
124     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
125     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
126     return true;
127   }
128 
129   
130   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
131     uint oldValue = allowed[msg.sender][_spender];
132     if (_subtractedValue > oldValue) {
133       allowed[msg.sender][_spender] = 0;
134     } else {
135       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
136     }
137     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
138     return true;
139   }
140 
141 }
142 
143 contract Bitcheke is StandardToken {
144 
145   string public constant name = "Bitcheke"; // solium-disable-line uppercase
146   string public constant symbol = "BCK"; // solium-disable-line uppercase
147   uint8 public constant decimals = 0; // solium-disable-line uppercase
148 
149   uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
150 
151   function Bitcheke() public {
152     totalSupply = INITIAL_SUPPLY;
153     balances[msg.sender] = INITIAL_SUPPLY;
154     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
155   }
156 
157 }