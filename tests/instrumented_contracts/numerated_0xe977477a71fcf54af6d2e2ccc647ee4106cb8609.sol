1 pragma solidity 0.4.25;
2 
3 // ERC20 interface
4 interface IERC20 {
5   function balanceOf(address _owner) external view returns (uint256);
6   function allowance(address _owner, address _spender) external view returns (uint256);
7   function transfer(address _to, uint256 _value) external returns (bool);
8   function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
9   function approve(address _spender, uint256 _value) external returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11   event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 library SafeMath {
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 
44 contract BCoin is IERC20 {
45   using SafeMath for uint256;
46   address private mod;
47   string public name = "BCoin Coin";
48   string public symbol = "BCN";
49   uint8 public constant decimals = 18;
50   uint256 public constant decimalFactor = 1000000000000000000;
51   uint256 public constant totalSupply = 300000000 * decimalFactor;
52   mapping (address => uint256) balances;
53   mapping (address => mapping (address => uint256)) internal allowed;
54 
55   event Transfer(address indexed from, address indexed to, uint256 value);
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 
58   constructor() public {
59     balances[msg.sender] = totalSupply;
60     mod = msg.sender;
61     emit Transfer(address(0), msg.sender, totalSupply);
62   }
63 
64   function balanceOf(address _owner) public view returns (uint256 balance) {
65     return balances[_owner];
66   }
67 
68   function allowance(address _owner, address _spender) public view returns (uint256) {
69     return allowed[_owner][_spender];
70   }
71 
72   function transfer(address _to, uint256 _value) public returns (bool) {
73     require(_to != address(0));
74     require(_value <= balances[msg.sender]);
75 
76     // SafeMath.sub will throw if there is not enough balance.
77     balances[msg.sender] = balances[msg.sender].sub(_value);
78     balances[_to] = balances[_to].add(_value);
79     emit Transfer(msg.sender, _to, _value);
80     return true;
81   }
82 
83   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
84     require(_to != address(0));
85     require(_value <= balances[_from]);
86     require(_value <= allowed[_from][msg.sender]);
87 
88     balances[_from] = balances[_from].sub(_value);
89     balances[_to] = balances[_to].add(_value);
90     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
91     emit Transfer(_from, _to, _value);
92     return true;
93   }
94 
95   function approve(address _spender, uint256 _value) public returns (bool) {
96     allowed[msg.sender][_spender] = _value;
97     emit Approval(msg.sender, _spender, _value);
98     return true;
99   }
100 
101   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
102     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
103     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
104     return true;
105   }
106 
107   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
108     uint oldValue = allowed[msg.sender][_spender];
109     if (_subtractedValue > oldValue) {
110       allowed[msg.sender][_spender] = 0;
111     } else {
112       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
113     }
114     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
115     return true;
116   }
117 
118   function transferMod(address _mod) public returns (bool) {
119     require(msg.sender == mod);
120     mod = _mod;
121     return true;
122   }
123 
124   function modName(string _name) public returns (bool) {
125     require(msg.sender == mod);
126     name = _name;
127     return true;
128   }
129 
130   function modSymbol(string _symbol) public returns (bool) {
131     require(msg.sender == mod);
132     symbol = _symbol;
133     return true;
134   }
135 
136 }