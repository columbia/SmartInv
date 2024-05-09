1 pragma solidity ^0.4.23;
2 contract ERC20Basic {
3   uint256 public totalSupply;
4   function balanceOf(address who) public view returns (uint256);
5   function transfer(address to, uint256 value) public returns (bool);
6   event Transfer(address indexed from, address indexed to, uint256 value);
7 }
8 
9 library SafeMath {
10 
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a / b;
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 contract BasicToken is ERC20Basic {
39   using SafeMath for uint256;
40 
41   mapping(address => uint256) balances;
42 
43   function transfer(address _to, uint256 _value) public returns (bool) {
44     require(_value > 0);
45     require(_to != address(0));
46     require(_value <= balances[msg.sender]);
47 
48     balances[msg.sender] = balances[msg.sender].sub(_value);
49     balances[_to] = balances[_to].add(_value);
50     Transfer(msg.sender, _to, _value);
51     return true;
52   }
53 
54   function balanceOf(address _owner) public view returns (uint256 balance) {
55     return balances[_owner];
56   }
57 
58 }
59 
60 contract ERC20 is ERC20Basic {
61   function allowance(address owner, address spender) public view returns (uint256);
62   function transferFrom(address from, address to, uint256 value) public returns (bool);
63   function approve(address spender, uint256 value) public returns (bool);
64   event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 
68 
69 contract StandardToken is ERC20, BasicToken {
70 
71   mapping (address => mapping (address => uint256)) internal allowed;
72 
73 
74   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
75     require(_value > 0);
76     require(_to != address(0));
77     require(_value <= balances[_from]);
78     require(_value <= allowed[_from][msg.sender]);
79 
80     balances[_from] = balances[_from].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
83     Transfer(_from, _to, _value);
84     return true;
85   }
86 
87   function approve(address _spender, uint256 _value) public returns (bool) {
88     require(_value > 0);
89     allowed[msg.sender][_spender] = _value;
90     Approval(msg.sender, _spender, _value);
91     return true;
92   }
93 
94   function allowance(address _owner, address _spender) public view returns (uint256) {
95     return allowed[_owner][_spender];
96   }
97 
98   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
99     require(_addedValue > 0);
100     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
101     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
102     return true;
103   }
104 
105   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
106     require(_subtractedValue > 0);
107     uint oldValue = allowed[msg.sender][_spender];
108     if (_subtractedValue > oldValue) {
109       allowed[msg.sender][_spender] = 0;
110     } else {
111       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
112     }
113     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
114     return true;
115   }
116 
117 }
118 
119 contract BurnableToken is BasicToken {
120 
121   event Burn(address indexed burner, uint256 value);
122 
123   function burn(uint256 _value) public {
124     require(_value > 0);
125     require(_value <= balances[msg.sender]);
126 
127     address burner = msg.sender;
128     balances[burner] = balances[burner].sub(_value);
129     totalSupply = totalSupply.sub(_value);
130     Burn(burner, _value);
131   }
132 }
133 
134 
135 contract BosToken is StandardToken, BurnableToken {
136 
137   string public constant name = "BOSTOKEN"; 
138   string public constant symbol = "BOS"; 
139   uint8 public constant decimals = 18; 
140 
141   uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
142 
143   function BosToken() public {
144     totalSupply = INITIAL_SUPPLY;
145     balances[msg.sender] = INITIAL_SUPPLY;
146     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
147   }
148 
149 }