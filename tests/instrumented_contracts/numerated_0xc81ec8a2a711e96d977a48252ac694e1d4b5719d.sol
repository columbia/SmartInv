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
23     uint internal _totalSupply;
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
56   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
57     uint256 c = a * b;
58     assert(a == 0 || c / a == b);
59     return c;
60   }
61 
62   function div(uint256 a, uint256 b) internal constant returns (uint256) {
63     // assert(b > 0); // Solidity automatically throws when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66     return c;
67   }
68 
69   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
70     assert(b <= a);
71     return a - b;
72   }
73 
74   function add(uint256 a, uint256 b) internal constant returns (uint256) {
75     uint256 c = a + b;
76     assert(c >= a);
77     return c;
78   }
79 }
80 
81 contract GTCoin is Token("GTC", "GTCoin", 18, 100000000000000000000000000), ERC20, ERC223 {
82 
83     using SafeMath for uint;
84 
85     function GTCoin() public {
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
98         if (_value > 0 && _value <= _balanceOf[msg.sender]) {
99             bytes memory empty;
100             _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
101             _balanceOf[_to] = _balanceOf[_to].add(_value);
102 
103             if (isContract(_to)) {
104                 ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
105                 _contract.tokenFallback(msg.sender, _value, empty);
106             }
107             Transfer(msg.sender, _to, _value);
108             return true;
109         }
110         return false;
111     }
112 
113     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
114         if (_value > 0 && _value <= _balanceOf[msg.sender]) {
115             _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
116             _balanceOf[_to] = _balanceOf[_to].add(_value);
117 
118             if (isContract(_to)) {
119                 ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
120                 _contract.tokenFallback(msg.sender, _value, _data);
121             }
122 
123             Transfer(msg.sender, _to, _value, _data);
124             return true;
125         }
126         return false;
127     }
128 
129     function isContract(address _addr) private constant returns (bool) {
130         uint codeSize;
131         assembly {
132             codeSize := extcodesize(_addr)
133         }
134         return codeSize > 0;
135     }
136 
137     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
138         if (_allowances[_from][msg.sender] > 0 && _value > 0 && _allowances[_from][msg.sender] >= _value && _balanceOf[_from] >= _value) {
139             _balanceOf[_from] = _balanceOf[_from].sub(_value);
140             _balanceOf[_to] = _balanceOf[_to].add(_value);
141             _allowances[_from][msg.sender] = _allowances[_from][msg.sender].sub(_value);
142             Transfer(_from, _to, _value);
143             return true;
144         }
145         return false;
146     }
147 
148     function approve(address _spender, uint _value) public returns (bool) {
149         _allowances[msg.sender][_spender] = _allowances[msg.sender][_spender].add(_value);
150         Approval(msg.sender, _spender, _value);
151         return true;
152     }
153 
154     function allowance(address _owner, address _spender) public constant returns (uint) {
155         return _allowances[_owner][_spender];
156     }
157 }