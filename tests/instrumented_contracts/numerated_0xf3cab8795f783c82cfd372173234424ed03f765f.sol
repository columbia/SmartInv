1 pragma solidity ^0.4.21;
2 
3         contract  IYFIS {
4 
5             uint256 public totalSupply;
6 
7 
8             function balanceOf(address _owner) public view returns (uint256 balance);
9 
10 
11             function transfer(address _to, uint256 _value) public returns (bool success);
12 
13 
14             function transferFrom(address _from, address _to, uint256 _value) public 
15 
16 returns (bool success);
17 
18 
19             function approve(address _spender, uint256 _value) public returns (bool 
20 
21 success);
22 
23 
24             function allowance(address _owner, address _spender) public view returns 
25 
26 (uint256 remaining);
27 
28 
29             event Transfer(address indexed _from, address indexed _to, uint256 _value);
30             event Approval(address indexed _owner, address indexed _spender, uint256 
31 
32 _value);
33         }
34 
35         library SafeMath {
36 
37 
38             function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39 
40                 if (a == 0) {
41                     return 0;
42                 }
43 
44                 uint256 c = a * b;
45                 require(c / a == b);
46                 return c;
47             }
48 
49 
50             function div(uint256 a, uint256 b) internal pure returns (uint256) {
51                 require(b > 0);
52                 uint256 c = a / b;
53                 return c;
54             }
55 
56 
57 
58             function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59                 require(b <= a);
60                 uint256 c = a - b;
61                 return c;
62             }
63 
64 
65             function add(uint256 a, uint256 b) internal pure returns (uint256) {
66                 uint256 c = a + b;
67                 require(c >= a);
68                 return c;
69             }
70 
71 
72             function mod(uint256 a, uint256 b) internal pure returns (uint256) {
73                 require(b != 0);
74                 return a % b;
75             }
76         }
77 
78 
79         contract YFIS is IYFIS {
80             using SafeMath for uint256;
81 
82             mapping (address => uint256) public balances;
83             mapping (address => mapping (address => uint256)) public allowed;
84 
85             string public name;
86             uint8 public decimals;
87             string public symbol;
88 
89             function YFIS(
90                 uint256 _initialAmount,
91                 string _tokenName,
92                 uint8 _decimalUnits,
93                 string _tokenSymbol
94                 ) public {
95                 balances[msg.sender] = _initialAmount;
96                 totalSupply = _initialAmount;
97                 name = _tokenName;
98                 decimals = _decimalUnits;
99                 symbol = _tokenSymbol;
100             }
101 
102             function transfer(address _to, uint256 _value) public returns (bool success) {
103             require(_to != address(0));
104             require(balances[msg.sender] >= _value);
105 
106             balances[msg.sender] = balances[msg.sender].sub(_value);
107 
108             balances[_to] = balances[_to].add(_value);
109             emit Transfer(msg.sender, _to, _value);
110             return true;
111         }
112 
113         function transferFrom(address _from, address _to, uint256 _value) public returns 
114 
115 (bool success) {
116             uint256 allowance = allowed[_from][msg.sender];
117             require(balances[_from] >= _value && allowance >= _value);
118             require(_to != address(0));
119 
120             balances[_to] = balances[_to].add(_value);
121 
122             balances[_from] = balances[_from].sub(_value);
123 
124             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
125 
126             emit Transfer(_from, _to, _value);
127             return true;
128         }
129 
130         function balanceOf(address _owner) public view returns (uint256 balance) {
131             return balances[_owner];
132         }
133 
134         function approve(address _spender, uint256 _value) public returns (bool success) {
135             require(_spender != address(0));
136             allowed[msg.sender][_spender] = _value;
137             emit Approval(msg.sender, _spender, _value);
138             return true;
139         }
140 
141         function allowance(address _owner, address _spender) public view returns (uint256 
142 
143 remaining) {
144             require(_spender != address(0));
145             return allowed[_owner][_spender];
146         }
147     }