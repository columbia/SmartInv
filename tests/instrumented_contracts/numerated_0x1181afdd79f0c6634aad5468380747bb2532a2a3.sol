1 pragma solidity ^0.4.24;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address who) external view returns (uint256);
6     function allowance(address owner, address spender) external view returns (uint256);
7     function transfer(address to, uint256 value) external returns (bool);
8     function approve(address spender, uint256 value) external returns (bool);
9     function transferFrom(address from, address to, uint256 value) external returns (bool);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 library SafeMath {
15     int256 constant private INT256_MIN = -2**255;
16 
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18         if (a == 0) {
19             return 0;
20         }
21 
22         uint256 c = a * b;
23         require(c / a == b);
24 
25         return c;
26     }
27 
28     function mul(int256 a, int256 b) internal pure returns (int256) {
29         if (a == 0) {
30             return 0;
31         }
32 
33         require(!(a == -1 && b == INT256_MIN));
34 
35         int256 c = a * b;
36         require(c / a == b);
37 
38         return c;
39     }
40 
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b > 0);
43         uint256 c = a / b;
44 
45         return c;
46     }
47 
48     function div(int256 a, int256 b) internal pure returns (int256) {
49         require(b != 0);
50         require(!(b == -1 && a == INT256_MIN));
51 
52         int256 c = a / b;
53 
54         return c;
55     }
56 
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b <= a);
59         uint256 c = a - b;
60 
61         return c;
62     }
63 
64     function sub(int256 a, int256 b) internal pure returns (int256) {
65         int256 c = a - b;
66         require((b >= 0 && c <= a) || (b < 0 && c > a));
67 
68         return c;
69     }
70 
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         require(c >= a);
74 
75         return c;
76     }
77 
78     function add(int256 a, int256 b) internal pure returns (int256) {
79         int256 c = a + b;
80         require((b >= 0 && c >= a) || (b < 0 && c < a));
81 
82         return c;
83     }
84 
85     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
86         require(b != 0);
87         return a % b;
88     }
89 }
90 
91 contract owned {
92     address public owner;
93 
94     constructor() public {
95         owner = msg.sender;
96     }
97 
98     modifier onlyOwner {
99         require(msg.sender == owner);
100         _;
101     }
102 
103     function transferOwnership(address newOwner) onlyOwner public {
104         owner = newOwner;
105     }
106 }
107 
108 contract ERC20 is owned,IERC20 {
109     using SafeMath for uint256;
110     mapping (address => uint256) private _balances;
111     mapping (address => mapping (address => uint256)) private _allowed;
112     mapping (address => bool) public frozenAccount;
113     event FrozenFunds(address target, bool frozen);
114 
115     string public name = "NNB";
116     string public symbol = "NNB";
117     uint8 public decimals = 18;
118     uint256 private _totalSupply = 2 * 100000000;
119     
120     constructor() public {
121         _totalSupply = _totalSupply * 10 ** uint256(decimals);
122         _balances[msg.sender] = _totalSupply;
123     }
124 
125     function totalSupply() public view returns (uint256) {
126         return _totalSupply;
127     }
128 
129     function balanceOf(address owner) public view returns (uint256) {
130         return _balances[owner];
131     }
132 
133     function allowance(address owner, address spender) public view returns (uint256) {
134         return _allowed[owner][spender];
135     }
136 
137     function transfer(address to, uint256 value) public returns (bool) {
138         _transfer(msg.sender, to, value);
139         return true;
140     }
141     
142     function burn(address account, uint256 value) external onlyOwner returns (bool) {
143         _burn(account, value);
144         return true;
145     }
146 
147     function approve(address spender, uint256 value) public returns (bool) {
148         require(spender != address(0));
149 
150         _allowed[msg.sender][spender] = value;
151         emit Approval(msg.sender, spender, value);
152         return true;
153     }
154 
155     function transferFrom(address from, address to, uint256 value) public returns (bool) {
156         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
157         _transfer(from, to, value);
158         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
159         return true;
160     }
161 
162     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
163         require(spender != address(0));
164 
165         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
166         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
167         return true;
168     }
169 
170     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
171         require(spender != address(0));
172 
173         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
174         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
175         return true;
176     }
177     
178     function freezeAccount(address target, bool freeze) onlyOwner public {
179         frozenAccount[target] = freeze;
180         emit FrozenFunds(target, freeze);
181     }
182 
183     function _transfer(address from, address to, uint256 value) internal {
184         require(to != address(0));
185         require(to != 0x0);
186 		require(value > 0); 
187         require(_balances[from] >= value);
188         require(_balances[to] + value >= _balances[to]);
189 
190         _balances[from] = _balances[from].sub(value);
191         _balances[to] = _balances[to].add(value);
192         emit Transfer(from, to, value);
193     }
194 
195     function _burn(address account, uint256 value) internal {
196         require(account != address(0));
197         require(_balances[account] >= value);
198 
199         _totalSupply = _totalSupply.sub(value);
200         _balances[account] = _balances[account].sub(value);
201         emit Transfer(account, address(0), value);
202     }
203 
204     function _burnFrom(address account, uint256 value) internal {
205         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
206         _burn(account, value);
207         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
208     }
209 }