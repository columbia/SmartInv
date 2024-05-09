1 contract ERC20Basic {
2   uint256 public totalSupply;
3   function balanceOf(address who) public view returns (uint256);
4   function transfer(address to, uint256 value) public returns (bool);
5   event Transfer(address indexed from, address indexed to, uint256 value);
6 }
7 
8 library SafeMath {
9 
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     uint256 c = a / b;
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 
37 contract BasicToken is ERC20Basic {
38   using SafeMath for uint256;
39 
40   mapping(address => uint256) balances;
41 
42   function transfer(address _to, uint256 _value) public returns (bool) {
43     require(_value > 0);
44     require(_to != address(0));
45     require(_value <= balances[msg.sender]);
46 
47     balances[msg.sender] = balances[msg.sender].sub(_value);
48     balances[_to] = balances[_to].add(_value);
49     Transfer(msg.sender, _to, _value);
50     return true;
51   }
52 
53   function balanceOf(address _owner) public view returns (uint256 balance) {
54     return balances[_owner];
55   }
56 
57 }
58 
59 contract ERC20 is ERC20Basic {
60   function allowance(address owner, address spender) public view returns (uint256);
61   function transferFrom(address from, address to, uint256 value) public returns (bool);
62   function approve(address spender, uint256 value) public returns (bool);
63   event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 
67 
68 contract StandardToken is ERC20, BasicToken {
69 
70   mapping (address => mapping (address => uint256)) internal allowed;
71 
72 
73   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
74     require(_value > 0);
75     require(_to != address(0));
76     require(_value <= balances[_from]);
77     require(_value <= allowed[_from][msg.sender]);
78 
79     balances[_from] = balances[_from].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
82     Transfer(_from, _to, _value);
83     return true;
84   }
85 
86   function approve(address _spender, uint256 _value) public returns (bool) {
87     require(_value > 0);
88     allowed[msg.sender][_spender] = _value;
89     Approval(msg.sender, _spender, _value);
90     return true;
91   }
92 
93   function allowance(address _owner, address _spender) public view returns (uint256) {
94     return allowed[_owner][_spender];
95   }
96 
97   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
98     require(_addedValue > 0);
99     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
100     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
101     return true;
102   }
103 
104   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
105     require(_subtractedValue > 0);
106     uint oldValue = allowed[msg.sender][_spender];
107     if (_subtractedValue > oldValue) {
108       allowed[msg.sender][_spender] = 0;
109     } else {
110       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
111     }
112     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
113     return true;
114   }
115 
116 }
117 
118 contract BurnableToken is BasicToken {
119 
120   event Burn(address indexed burner, uint256 value);
121 
122   function burn(uint256 _value) public {
123     require(_value > 0);
124     require(_value <= balances[msg.sender]);
125 
126     address burner = msg.sender;
127     balances[burner] = balances[burner].sub(_value);
128     totalSupply = totalSupply.sub(_value);
129     Burn(burner, _value);
130   }
131 }
132 
133 
134 contract RHC is StandardToken, BurnableToken {
135 
136   string public constant name = "Rich Human Crypto"; 
137   string public constant symbol = "RHC"; 
138   uint8 public constant decimals = 2; 
139 
140   uint256 public constant INITIAL_SUPPLY = 10000000000000;
141 
142   function RHC() public {
143     totalSupply = INITIAL_SUPPLY;
144     balances[msg.sender] = INITIAL_SUPPLY;
145     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
146   }
147 
148 }