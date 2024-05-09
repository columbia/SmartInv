1 pragma solidity ^0.4.16;
2 
3 contract ERC20 {
4     function transferFrom(address _from, address _to, uint _value) public returns (bool);
5     function approve(address _spender, uint _value) public returns (bool);
6     function allowance(address _owner, address _spender) public constant returns(uint);
7     event Approval(address indexed _owner, address indexed _spender, uint _value);
8 }
9 
10 library SafeMath {
11 
12   function safemul(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function safediv(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function safesub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function safeadd(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 contract Token {
38     string internal _symbol;
39     string internal _name;
40     uint8 internal _decimals;
41     uint internal _totalSupply = 1000;
42     mapping (address => uint) internal _balanceOf;
43     mapping (address => mapping(address => uint)) internal _allowances;
44     
45     constructor(string symbol, string name, uint8 decimals, uint totalSupply) public {
46         _symbol = symbol;
47         _name = name;
48         _decimals = decimals;
49         _totalSupply = totalSupply;
50     }
51     
52     function name() public constant returns (string) {
53         return _name;
54     }
55     
56     function symbol() public constant returns (string) {
57         return _symbol;
58     }
59     
60     function decimals() public constant returns (uint8){
61         return _decimals;
62     }
63     
64     function totalSupply() public constant returns (uint){
65         return _totalSupply;
66     }
67     
68     function balanceOf(address _addr) public constant returns (uint);
69     function transfer(address _to, uint _value) public returns (bool);
70     event Transfer(address indexed _from, address indexed _to, uint _value);
71 }
72 
73 contract PapaBoxToken is Token("PaPB", "Papa Box Beta", 6, 10 ** 15 ), ERC20 {
74     using SafeMath for uint256;
75     
76     constructor() public {
77         _balanceOf[msg.sender] = _totalSupply;
78     }
79     
80     function totalSupply() public constant returns (uint) {
81         return _totalSupply;
82     }
83     
84     function balanceOf(address addr) public constant returns(uint) {
85         return _balanceOf[addr];
86     }
87     
88     function transfer(address _to, uint _value) public returns (bool){
89         if(_value > 0 &&
90             _value <= _balanceOf[msg.sender] &&
91             !isContract(_to)) {
92                 
93             _balanceOf[msg.sender] = _balanceOf[msg.sender].safesub(_value);
94             _balanceOf[_to] = _balanceOf[_to].safeadd(_value);
95             
96             emit Transfer(msg.sender, _to, _value);
97             return true;
98         }
99         return false;
100     }
101     
102     function isContract(address _addr) private constant returns(bool) {
103         uint codeSize;
104         _addr = _addr;
105         assembly {
106             codeSize := extcodesize(_addr)
107         }
108         return codeSize > 0;
109     }
110     
111     function transferFrom(address _from, address _to, uint _value) public returns(bool)  {
112         if(_allowances[_from][msg.sender] > 0 &&
113             _value > 0 &&
114             _allowances[_from][msg.sender] >= _value) {
115                 
116                 _balanceOf[_from] = _balanceOf[_from].safesub(_value);
117                 _balanceOf[_to] = _balanceOf[_to].safeadd(_value);
118                 return true;
119             }
120             return false;
121     }
122     
123     function approve(address _spender, uint _value) public returns (bool success) {
124         _allowances[msg.sender][_spender] = _value; 
125         return true;
126     }
127     
128     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
129         return _allowances[_owner][_spender];
130     }
131     
132 }