1 pragma solidity ^0.4.21;
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
67 contract StandardToken is ERC20, BasicToken {
68 
69   mapping (address => mapping (address => uint256)) internal allowed;
70 
71 
72   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
73     require(_value > 0);
74     require(_to != address(0));
75     require(_value <= balances[_from]);
76     require(_value <= allowed[_from][msg.sender]);
77 
78     balances[_from] = balances[_from].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
81     Transfer(_from, _to, _value);
82     return true;
83   }
84 
85   function approve(address _spender, uint256 _value) public returns (bool) {
86     require(_value > 0);
87     allowed[msg.sender][_spender] = _value;
88     Approval(msg.sender, _spender, _value);
89     return true;
90   }
91 
92   function allowance(address _owner, address _spender) public view returns (uint256) {
93     return allowed[_owner][_spender];
94   }
95 
96   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
97     require(_addedValue > 0);
98     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
99     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
100     return true;
101   }
102 
103   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
104     require(_subtractedValue > 0);
105     uint oldValue = allowed[msg.sender][_spender];
106     if (_subtractedValue > oldValue) {
107       allowed[msg.sender][_spender] = 0;
108     } else {
109       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
110     }
111     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
112     return true;
113   }
114 
115 }
116 
117 contract BurnableToken is BasicToken {
118 
119   event Burn(address indexed burner, uint256 value);
120 
121   function burn(uint256 _value) public {
122     require(_value > 0);
123     require(_value <= balances[msg.sender]);
124 
125     address burner = msg.sender;
126     balances[burner] = balances[burner].sub(_value);
127     totalSupply = totalSupply.sub(_value);
128     Burn(burner, _value);
129   }
130 }
131 
132 contract Daereum is StandardToken, BurnableToken {
133 
134   string public constant name = "Daereum"; 
135   string public constant symbol = "DAER"; 
136   uint8 public constant decimals = 8; 
137 
138   uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
139 
140   function Daereum() public {
141     totalSupply = INITIAL_SUPPLY;
142     balances[msg.sender] = INITIAL_SUPPLY;
143     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
144   }
145 
146 }