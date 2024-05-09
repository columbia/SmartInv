1 pragma solidity ^0.4.0;
2 
3 interface ERC20 {
4     function transferFrom(address _from, address _to, uint _value) public returns (bool);
5     function approve(address _spender, uint _value) public returns (bool);
6     function allowance(address _owner, address _spender) public constant returns (uint);
7     event Approval(address indexed _owner, address indexed _spender, uint _value);
8 }
9 
10 interface ERC223 {
11     function transfer(address _to, uint _value, bytes _data) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
13 }
14 
15 contract ERC223ReceivingContract {
16     function tokenFallback(address _from, uint _value, bytes _data) public;
17 }
18 
19 contract Token {
20     string internal _symbol;
21     string internal _name;
22     uint8 internal _decimals;
23     uint internal _totalSupply = 200000000000000000000000000;
24     mapping (address => uint) internal _balanceOf;
25     mapping (address => mapping (address => uint)) internal _allowances;
26 
27     function Token(string symbol, string name, uint8 decimals, uint totalSupply) public {
28         _symbol = symbol;
29         _name = name;
30         _decimals = decimals;
31         _totalSupply = totalSupply;
32     }
33 
34     function name() public constant returns (string) {
35         return _name;
36     }
37 
38     function symbol() public constant returns (string) {
39         return _symbol;
40     }
41 
42     function decimals() public constant returns (uint8) {
43         return _decimals;
44     }
45 
46     function totalSupply() public constant returns (uint) {
47         return _totalSupply;
48     }
49 
50     function balanceOf(address _addr) public constant returns (uint);
51     function transfer(address _to, uint _value) public returns (bool);
52     event Transfer(address indexed _from, address indexed _to, uint _value);
53 }
54 
55 library SafeMath {
56   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a * b;
58     assert(a == 0 || c / a == b);
59     return c;
60   }
61 
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     // assert(b > 0); // Solidity automatically throws when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66     return c;
67   }
68 
69   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70     assert(b <= a);
71     return a - b;
72   }
73 
74   function add(uint256 a, uint256 b) internal pure returns (uint256) {
75     uint256 c = a + b;
76     assert(c >= a);
77     return c;
78   }
79 }
80 
81 contract MyFirstToken is Token("LLIU", "LLIURE", 18, 200000000000000000000000000), ERC20, ERC223 {
82 
83     using SafeMath for uint;
84 
85     function MyFirstToken() public {
86         _balanceOf[msg.sender] = _totalSupply;
87     }
88 
89     function totalSupply() public constant returns (uint) {
90         return _totalSupply;
91     }
92 
93     function balanceOf(address _addr) public constant returns (uint) {
94         return _balanceOf[_addr];
95     }
96 
97     function transfer(address _to, uint _value) public returns (bool) {
98         if (_value > 0 &&
99             _value <= _balanceOf[msg.sender] &&
100             !isContract(_to)) {
101             _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
102             _balanceOf[_to] = _balanceOf[_to].add(_value);
103             Transfer(msg.sender, _to, _value);
104             return true;
105         }
106         return false;
107     }
108 
109     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
110         if (_value > 0 &&
111             _value <= _balanceOf[msg.sender] &&
112             isContract(_to)) {
113             _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
114             _balanceOf[_to] = _balanceOf[_to].add(_value);
115             ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
116             _contract.tokenFallback(msg.sender, _value, _data);
117             Transfer(msg.sender, _to, _value, _data);
118             return true;
119         }
120         return false;
121     }
122 
123     function isContract(address _addr) private constant returns (bool) {
124         uint codeSize;
125         assembly {
126             codeSize := extcodesize(_addr)
127         }
128         return codeSize > 0;
129     }
130 
131     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
132         if (_allowances[_from][msg.sender] > 0 &&
133             _value > 0 &&
134             _allowances[_from][msg.sender] >= _value &&
135             _balanceOf[_from] >= _value) {
136             _balanceOf[_from] = _balanceOf[_from].sub(_value);
137             _balanceOf[_to] = _balanceOf[_to].add(_value);
138             _allowances[_from][msg.sender] = _allowances[_from][msg.sender].sub(_value);
139             Transfer(_from, _to, _value);
140             return true;
141         }
142         return false;
143     }
144 
145     function approve(address _spender, uint _value) public returns (bool) {
146         _allowances[msg.sender][_spender] = _allowances[msg.sender][_spender].add(_value);
147         Approval(msg.sender, _spender, _value);
148         return true;
149     }
150 
151     function allowance(address _owner, address _spender) public constant returns (uint) {
152         return _allowances[_owner][_spender];
153     }
154 }