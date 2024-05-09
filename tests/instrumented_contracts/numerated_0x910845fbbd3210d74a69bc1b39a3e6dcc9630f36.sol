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
23     uint internal _totalSupply = 1000;
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
81 contract Organicco is Token("ORC", "Organicco", 18, 120000000000000000000000000), ERC20, ERC223 {
82 
83     using SafeMath for uint;
84     address public constant FOUNDING_TEAM = 0x001c3234d614F12D5ef931E2871BFf35D8C05a29;
85     address public constant PARTNER_SALES = 0x00749ea1Ca25e9C027426D74Bb3659A80493fa6d;
86     address public constant PRESALES = 0x00faf4afd47ebA1D1713C0506f4a05BC36cc590D;
87     address public constant ICO = 0x000E945D52F3EF8602B3484ce04036fF4d2888CA;
88     address public constant BONUS = 0x009C88134EE3636E7f92A402ed9531DF54B802BB;
89 
90     function Organicco() public {
91         _balanceOf[FOUNDING_TEAM] = _totalSupply * 20 / 100; //24,000,000 (24 million)
92         _balanceOf[PARTNER_SALES] = _totalSupply * 16 / 100; //19,200,000 (19.2 million)
93         _balanceOf[PRESALES] = _totalSupply * 10 / 100; //12,000,000 (12 million)
94         _balanceOf[ICO] = _totalSupply * 50 / 100; //60,000,000 (60 million)
95         _balanceOf[BONUS] = _totalSupply * 4 / 100; //4,800,000 (4.8 million)
96     }
97 
98     function totalSupply() public constant returns (uint) {
99         return _totalSupply;
100     }
101 
102     function balanceOf(address _addr) public constant returns (uint) {
103         return _balanceOf[_addr];
104     }
105 
106     function transfer(address _to, uint _value) public returns (bool) {
107         if (_value > 0 &&
108             _value <= _balanceOf[msg.sender] &&
109             !isContract(_to)) {
110             _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
111             _balanceOf[_to] = _balanceOf[_to].add(_value);
112             Transfer(msg.sender, _to, _value);
113             return true;
114         }
115         return false;
116     }
117 
118     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
119         if (_value > 0 &&
120             _value <= _balanceOf[msg.sender] &&
121             isContract(_to)) {
122             _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
123             _balanceOf[_to] = _balanceOf[_to].add(_value);
124             ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
125             _contract.tokenFallback(msg.sender, _value, _data);
126             Transfer(msg.sender, _to, _value, _data);
127             return true;
128         }
129         return false;
130     }
131 
132     function isContract(address _addr) private constant returns (bool) {
133         uint codeSize;
134         assembly {
135             codeSize := extcodesize(_addr)
136         }
137         return codeSize > 0;
138     }
139 
140     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
141         if (_allowances[_from][msg.sender] > 0 &&
142             _value > 0 &&
143             _allowances[_from][msg.sender] >= _value &&
144             _balanceOf[_from] >= _value) {
145             _balanceOf[_from] = _balanceOf[_from].sub(_value);
146             _balanceOf[_to] = _balanceOf[_to].add(_value);
147             _allowances[_from][msg.sender] = _allowances[_from][msg.sender].sub(_value);
148             Transfer(_from, _to, _value);
149             return true;
150         }
151         return false;
152     }
153 
154     function approve(address _spender, uint _value) public returns (bool) {
155         _allowances[msg.sender][_spender] = _allowances[msg.sender][_spender].add(_value);
156         Approval(msg.sender, _spender, _value);
157         return true;
158     }
159 
160     function allowance(address _owner, address _spender) public constant returns (uint) {
161         return _allowances[_owner][_spender];
162     }
163 }