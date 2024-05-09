1 pragma solidity ^0.4.15;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 library SafeMath {
11 
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a / b;
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 
39 contract BasicToken is ERC20Basic {
40   using SafeMath for uint256;
41 
42   mapping(address => uint256) balances;
43 
44   function transfer(address _to, uint256 _value) public returns (bool) {
45     require(_value > 0);
46     require(_to != address(0));
47     require(_value <= balances[msg.sender]);
48 
49     balances[msg.sender] = balances[msg.sender].sub(_value);
50     balances[_to] = balances[_to].add(_value);
51     Transfer(msg.sender, _to, _value);
52     return true;
53   }
54 
55   function balanceOf(address _owner) public view returns (uint256 balance) {
56     return balances[_owner];
57   }
58 
59 }
60 
61 contract ERC20 is ERC20Basic {
62   function allowance(address owner, address spender) public view returns (uint256);
63   function transferFrom(address from, address to, uint256 value) public returns (bool);
64   function approve(address spender, uint256 value) public returns (bool);
65   event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 
69 
70 contract StandardToken is ERC20, BasicToken {
71 
72   mapping (address => mapping (address => uint256)) internal allowed;
73 
74 
75   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
76     require(_value > 0);
77     require(_to != address(0));
78     require(_value <= balances[_from]);
79     require(_value <= allowed[_from][msg.sender]);
80 
81     balances[_from] = balances[_from].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
84     Transfer(_from, _to, _value);
85     return true;
86   }
87 
88   function approve(address _spender, uint256 _value) public returns (bool) {
89     require(_value > 0);
90     allowed[msg.sender][_spender] = _value;
91     Approval(msg.sender, _spender, _value);
92     return true;
93   }
94 
95   function allowance(address _owner, address _spender) public view returns (uint256) {
96     return allowed[_owner][_spender];
97   }
98 
99   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
100     require(_addedValue > 0);
101     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
102     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
103     return true;
104   }
105 
106   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
107     require(_subtractedValue > 0);
108     uint oldValue = allowed[msg.sender][_spender];
109     if (_subtractedValue > oldValue) {
110       allowed[msg.sender][_spender] = 0;
111     } else {
112       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
113     }
114     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
115     return true;
116   }
117 
118 }
119 
120 contract BurnableToken is BasicToken {
121 
122   event Burn(address indexed burner, uint256 value);
123 
124   function burn(uint256 _value) public {
125     require(_value > 0);
126     require(_value <= balances[msg.sender]);
127 
128     address burner = msg.sender;
129     balances[burner] = balances[burner].sub(_value);
130     totalSupply = totalSupply.sub(_value);
131     Burn(burner, _value);
132   }
133 }
134 
135 
136 contract OctusToken is StandardToken, BurnableToken {
137 
138   string public constant name = "Octus"; 
139   string public constant symbol = "OCT"; 
140   uint8 public constant decimals = 18; 
141 
142   uint256 public constant INITIAL_SUPPLY = 2500000 * (10 ** uint256(decimals));
143 
144   function OctusToken() public {
145     totalSupply = INITIAL_SUPPLY;
146     balances[msg.sender] = INITIAL_SUPPLY;
147     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
148   }
149 
150 }