1 pragma solidity ^0.5.9;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address who) external view returns (uint256);
6     function allowance(address owner, address spender) external view returns (uint256);
7     function transfer(address to, uint256 value) external returns (bool);
8     function approve(address spender, uint256 value) external returns (bool);
9     function transferFrom(address from, address to, uint256 value) external returns (bool);
10 
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 library SafeMath {
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         if (a == 0) {
18             return 0;
19         }
20         uint256 c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a / b;
27         return c;
28     }
29 
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         assert(c >= a);
38         return c;
39     }
40 
41     function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
42         uint256 c = add(a,m);
43         uint256 d = sub(c,1);
44         return mul(div(d,m),m);
45     }
46 }
47 
48 contract ERC20Detailed is IERC20 {
49     string private _name;
50     string private _symbol;
51     uint8 private _decimals;
52 
53     constructor(string memory name, string memory symbol, uint8 decimals) public {
54         _name = name;
55         _symbol = symbol;
56         _decimals = decimals;
57     }
58 
59     function name() public view returns(string memory) {
60         return _name;
61     }
62 
63     function symbol() public view returns(string memory) {
64         return _symbol;
65     }
66 
67     function decimals() public view returns(uint8) {
68         return _decimals;
69     }
70 }
71 
72 contract ATokenERC20 is ERC20Detailed {
73     using SafeMath for uint256;
74     mapping (address => uint256) private _balances;
75     mapping (address => mapping (address => uint256)) private _allowed;
76 
77     string constant tokenName = "B-ROCKET";
78     string constant tokenSymbol = "BRE";
79     uint8 constant tokenDecimals = 0;
80     uint256 _totalSupply = 50000000;
81     uint256 _totalBaseline = 5000000;
82     uint256 public basePercent = 100;
83 
84     constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
85         _mint(msg.sender, _totalSupply);
86     }
87 
88     function totalSupply() public view returns (uint256) {
89         return _totalSupply;
90     }
91 
92     function balanceOf(address owner) public view returns (uint256) {
93         return _balances[owner];
94     }
95 
96     function allowance(address owner, address spender) public view returns (uint256) {
97         return _allowed[owner][spender];
98     }
99 
100     function findOnePercent(uint256 value) public view returns (uint256)  {
101         uint256 roundValue = value.ceil(basePercent);
102         uint256 onePercent = roundValue.mul(basePercent).div(10000);
103         return onePercent;
104     }
105 
106     function transfer(address _to, uint256 _value) public returns (bool) {
107 
108         if (_totalSupply <= _totalBaseline) {
109             require(_value <= _balances[msg.sender]);
110             require(_to != address(0));
111 
112             _balances[msg.sender] = _balances[msg.sender].sub(_value);
113             _balances[_to] = _balances[_to].add(_value);
114 
115             emit Transfer(msg.sender, _to, _value);
116         } else {
117             require(_value <= _balances[msg.sender]);
118             require(_to != address(0));
119 
120             uint256 tokensToBurn = findOnePercent(_value);
121             uint256 tokensToTransfer = _value.sub(tokensToBurn);
122 
123             _balances[msg.sender] = _balances[msg.sender].sub(_value);
124             _balances[_to] = _balances[_to].add(tokensToTransfer);
125 
126             _totalSupply = _totalSupply.sub(tokensToBurn);
127 
128             emit Transfer(msg.sender, _to, tokensToTransfer);
129             emit Transfer(msg.sender, address(0), tokensToBurn);
130         }
131 
132         return true;
133     }
134 
135     function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
136         for (uint256 i = 0; i < receivers.length; i++) {
137             transfer(receivers[i], amounts[i]);
138         }
139     }
140 
141     function approve(address spender, uint256 value) public returns (bool) {
142         require(spender != address(0));
143         _allowed[msg.sender][spender] = value;
144         emit Approval(msg.sender, spender, value);
145         return true;
146     }
147 
148     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
149 
150         if (_totalSupply <= _totalBaseline) {
151             require(_value <= _balances[_from]);
152             require(_value <= _allowed[_from][msg.sender]);
153             require(_to != address(0));
154 
155             _balances[_from] = _balances[_from].sub(_value);
156             _balances[_to] = _balances[_to].add(_value);
157             _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
158 
159             emit Transfer(_from, _to, _value);
160         } else {
161             require(_value <= _balances[_from]);
162             require(_value <= _allowed[_from][msg.sender]);
163             require(_to != address(0));
164 
165             _balances[_from] = _balances[_from].sub(_value);
166 
167             uint256 tokensToBurn = findOnePercent(_value);
168             uint256 tokensToTransfer = _value.sub(tokensToBurn);
169 
170             _balances[_to] = _balances[_to].add(tokensToTransfer);
171             _totalSupply = _totalSupply.sub(tokensToBurn);
172             _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
173 
174             emit Transfer(_from, _to, tokensToTransfer);
175             emit Transfer(_from, address(0), tokensToBurn);
176         }
177 
178         return true;
179     }
180 
181     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
182         require(spender != address(0));
183         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
184         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
185         return true;
186     }
187 
188     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
189         require(spender != address(0));
190         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
191         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
192         return true;
193     }
194 
195     function _mint(address account, uint256 amount) internal {
196         require(amount != 0);
197         _balances[account] = _balances[account].add(amount);
198         emit Transfer(address(0), account, amount);
199     }
200 
201     function burn(uint256 amount) external {
202         _burn(msg.sender, amount);
203     }
204 
205     function _burn(address account, uint256 amount) internal {
206         require(amount != 0);
207         require(amount <= _balances[account]);
208         _totalSupply = _totalSupply.sub(amount);
209         _balances[account] = _balances[account].sub(amount);
210         emit Transfer(account, address(0), amount);
211     }
212 
213     function burnFrom(address account, uint256 amount) external {
214         require(amount <= _allowed[account][msg.sender]);
215         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
216         _burn(account, amount);
217     }
218 }