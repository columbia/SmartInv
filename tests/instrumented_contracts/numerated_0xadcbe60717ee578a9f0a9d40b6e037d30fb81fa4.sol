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
115     string public name = "HKT";
116     string public symbol = "HKT";
117     uint8 public decimals = 18;
118     uint256 private _totalSupply = 0;
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
142     function mint(address account, uint256 value) external onlyOwner returns (bool) {
143         uint256 addValue = value * 10 ** uint256(decimals);
144         _mint(account, addValue);
145         return true;
146     }
147 
148     function burn(address account, uint256 value) external onlyOwner returns (bool) {
149         _burn(account, value);
150         return true;
151     }
152 
153     function approve(address spender, uint256 value) public returns (bool) {
154         require(spender != address(0));
155 
156         _allowed[msg.sender][spender] = value;
157         emit Approval(msg.sender, spender, value);
158         return true;
159     }
160 
161     function transferFrom(address from, address to, uint256 value) public returns (bool) {
162         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
163         _transfer(from, to, value);
164         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
165         return true;
166     }
167 
168     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
169         require(spender != address(0));
170 
171         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
172         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
173         return true;
174     }
175 
176     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
177         require(spender != address(0));
178 
179         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
180         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
181         return true;
182     }
183     
184     function freezeAccount(address target, bool freeze) onlyOwner public {
185         frozenAccount[target] = freeze;
186         emit FrozenFunds(target, freeze);
187     }
188 
189     function _transfer(address from, address to, uint256 value) internal {
190         require(to != address(0));
191 
192         _balances[from] = _balances[from].sub(value);
193         _balances[to] = _balances[to].add(value);
194         emit Transfer(from, to, value);
195     }
196 
197     function _mint(address account, uint256 value) internal {
198         require(account != address(0));
199 
200         _totalSupply = _totalSupply.add(value);
201         _balances[account] = _balances[account].add(value);
202         emit Transfer(address(0), account, value);
203     }
204 
205     function _burn(address account, uint256 value) internal {
206         require(account != address(0));
207 
208         _totalSupply = _totalSupply.sub(value);
209         _balances[account] = _balances[account].sub(value);
210         emit Transfer(account, address(0), value);
211     }
212 
213     function _burnFrom(address account, uint256 value) internal {
214         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
215         _burn(account, value);
216         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
217     }
218 }