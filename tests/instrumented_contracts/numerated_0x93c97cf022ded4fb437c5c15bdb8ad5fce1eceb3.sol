1 pragma solidity ^0.4.18;
2 
3 interface ERC20 {
4     function transferFrom(address _from, address _to, uint _value) external returns (bool);
5     function approve(address _spender, uint _value) external returns (bool);
6     function allowance(address _owner, address _spender) external constant returns (uint);
7     event Approval(address indexed _owner, address indexed _spender, uint _value);
8 }
9 
10 interface ERC223 {
11     function transfer(address _to, uint _value, bytes _data) external returns (bool);
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
23     uint internal _totalSupply = 100000000000000000;
24     mapping (address => uint) internal _balanceOf;
25     mapping (address => mapping (address => uint)) internal _allowances;
26     
27     constructor(string symbol, string name, uint8 decimals, uint totalSupply) public {
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
56     /**
57      * @dev Multiplies two unsigned integers, reverts on overflow.
58      */
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
61         // benefit is lost if 'b' is also tested.
62         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
63         if (a == 0) {
64             return 0;
65         }
66 
67         uint256 c = a * b;
68         require(c / a == b);
69 
70         return c;
71     }
72 
73     /**
74      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
75      */
76     function div(uint256 a, uint256 b) internal pure returns (uint256) {
77         // Solidity only automatically asserts when dividing by 0
78         require(b > 0);
79         uint256 c = a / b;
80         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
81 
82         return c;
83     }
84 
85     /**
86      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
87      */
88     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89         require(b <= a);
90         uint256 c = a - b;
91 
92         return c;
93     }
94 
95     /**
96      * @dev Adds two unsigned integers, reverts on overflow.
97      */
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         uint256 c = a + b;
100         require(c >= a);
101 
102         return c;
103     }
104 
105     /**
106      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
107      * reverts when dividing by zero.
108      */
109     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
110         require(b != 0);
111         return a % b;
112     }
113 }
114 
115 contract AllPointPay is Token("APP", "AllPointPay", 8, 100000000000000000), ERC20, ERC223 {
116     using SafeMath for uint;
117 
118     constructor() public {
119         _balanceOf[msg.sender] = _totalSupply;
120     }
121     
122     function totalSupply() public constant returns (uint) {
123         return _totalSupply;
124     }
125     
126     function balanceOf(address _addr) public constant returns (uint) {
127         return _balanceOf[_addr];
128     }
129 
130     function transfer(address _to, uint _value) public returns (bool) {
131         if (_value > 0 && 
132             _value <= _balanceOf[msg.sender] &&
133             !isContract(_to)) {
134             _balanceOf[msg.sender] -= _value;
135             _balanceOf[_to] += _value;
136             emit Transfer(msg.sender, _to, _value);
137             return true;
138         }
139         return false;
140     }
141 
142     function transfer(address _to, uint _value, bytes _data) external returns (bool) {
143         if (_value > 0 && 
144             _value <= _balanceOf[msg.sender] &&
145             isContract(_to)) {
146             _balanceOf[msg.sender] -= _value;
147             _balanceOf[_to] += _value;
148             ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
149                 _contract.tokenFallback(msg.sender, _value, _data);
150             emit Transfer(msg.sender, _to, _value, _data);
151             return true;
152         }
153         return false;
154     }
155 
156     function isContract(address _addr) public view returns (bool) {
157         uint codeSize;
158         assembly {
159             codeSize := extcodesize(_addr)
160         }
161         return codeSize > 0;
162     }
163 
164     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
165         if (_allowances[_from][msg.sender] > 0 &&
166             _value > 0 &&
167             _allowances[_from][msg.sender] >= _value &&
168             _balanceOf[_from] >= _value) {
169             _balanceOf[_from] -= _value;
170             _balanceOf[_to] += _value;
171             _allowances[_from][msg.sender] -= _value;
172             emit Transfer(_from, _to, _value);
173             return true;
174         }
175         return false;
176     }
177     
178     function approve(address _spender, uint _value) public returns (bool) {
179         _allowances[msg.sender][_spender] = _value;
180         emit Approval(msg.sender, _spender, _value);
181         return true;
182     }
183     
184     function allowance(address _owner, address _spender) public constant returns (uint) {
185         return _allowances[_owner][_spender];
186     }
187 }