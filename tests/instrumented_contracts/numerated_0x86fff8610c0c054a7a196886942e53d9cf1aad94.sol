1 pragma solidity 0.4.25;
2 
3 
4 library SafeMath {
5 
6     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
7         if (_a == 0) {
8             return 0;
9         }
10 
11         uint256 c = _a * _b;
12         require(c / _a == _b);
13 
14         return c;
15     }
16 
17     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
18         require(_b > 0);
19         uint256 c = _a / _b;
20 
21         return c;
22     }
23 
24     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
25         require(_b <= _a);
26         uint256 c = _a - _b;
27 
28         return c;
29     }
30 
31     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
32         uint256 c = _a + _b;
33         require(c >= _a);
34 
35         return c;
36     }
37 
38     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b != 0);
40         return a % b;
41     }
42 }
43 
44 interface IERC20 {
45   function totalSupply() external view returns (uint256);
46 
47   function balanceOf(address who) external view returns (uint256);
48 
49   function allowance(address owner, address spender)
50     external view returns (uint256);
51 
52   function transfer(address to, uint256 value) external returns (bool);
53 
54   function approve(address spender, uint256 value)
55     external returns (bool);
56 
57   function transferFrom(address from, address to, uint256 value)
58     external returns (bool);
59 
60   event Transfer(
61     address indexed from,
62     address indexed to,
63     uint256 value
64   );
65 
66   event Approval(
67     address indexed owner,
68     address indexed spender,
69     uint256 value
70   );
71 }
72 
73 contract ERC20 is IERC20 {
74   using SafeMath for uint256;
75 
76   mapping (address => uint256) private _balances;
77 
78   mapping (address => mapping (address => uint256)) private _allowed;
79 
80   uint256 private _totalSupply;
81 
82   function totalSupply() public view returns (uint256) {
83     return _totalSupply;
84   }
85 
86   function balanceOf(address owner) public view returns (uint256) {
87     return _balances[owner];
88   }
89 
90   function allowance(
91     address owner,
92     address spender
93    )
94     public
95     view
96     returns (uint256)
97   {
98     return _allowed[owner][spender];
99   }
100 
101   function transfer(address to, uint256 value) public returns (bool) {
102     _transfer(msg.sender, to, value);
103     return true;
104   }
105 
106   function approve(address spender, uint256 value) public returns (bool) {
107     require(spender != address(0));
108 
109     _allowed[msg.sender][spender] = value;
110     emit Approval(msg.sender, spender, value);
111     return true;
112   }
113 
114   function transferFrom(
115     address from,
116     address to,
117     uint256 value
118   )
119     public
120     returns (bool)
121   {
122     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
123     _transfer(from, to, value);
124     return true;
125   }
126 
127   function increaseAllowance(
128     address spender,
129     uint256 addedValue
130   )
131     public
132     returns (bool)
133   {
134     require(spender != address(0));
135 
136     _allowed[msg.sender][spender] = (
137       _allowed[msg.sender][spender].add(addedValue));
138     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
139     return true;
140   }
141 
142   function decreaseAllowance(
143     address spender,
144     uint256 subtractedValue
145   )
146     public
147     returns (bool)
148   {
149     require(spender != address(0));
150 
151     _allowed[msg.sender][spender] = (
152       _allowed[msg.sender][spender].sub(subtractedValue));
153     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
154     return true;
155   }
156 
157   function _transfer(address from, address to, uint256 value) internal {
158     require(to != address(0));
159 
160     _balances[from] = _balances[from].sub(value);
161     _balances[to] = _balances[to].add(value);
162     emit Transfer(from, to, value);
163   }
164 
165   function _mint(address account, uint256 value) internal {
166     require(account != address(0));
167 
168     _totalSupply = _totalSupply.add(value);
169     _balances[account] = _balances[account].add(value);
170     emit Transfer(address(0), account, value);
171   }
172 
173   function _burn(address account, uint256 value) internal {
174     require(account != address(0));
175 
176     _totalSupply = _totalSupply.sub(value);
177     _balances[account] = _balances[account].sub(value);
178     emit Transfer(account, address(0), value);
179   }
180 
181   function _burnFrom(address account, uint256 value) internal {
182     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
183       value);
184     _burn(account, value);
185   }
186 }
187 
188 
189 contract ERC20Burnable is ERC20 {
190 
191   function burn(uint256 value) public {
192     _burn(msg.sender, value);
193   }
194 
195   function burnFrom(address from, uint256 value) public {
196     _burnFrom(from, value);
197   }
198 }
199 
200 
201 contract LeadRexToken is ERC20Burnable {
202 
203     string private _name = "LeadRex Token";
204     string private _symbol = "LDXT";
205     uint8 private _decimals = 18;
206 
207     uint256 constant INITIAL_SUPPLY = 135900000 * (10 ** 18);
208 
209     constructor() public {
210         _mint(0x710258Fc97E85910F1b1B219a72A8e794ca7E5C8, INITIAL_SUPPLY);
211     }
212 
213     function name() public view returns(string) {
214       return _name;
215     }
216 
217     function symbol() public view returns(string) {
218       return _symbol;
219     }
220 
221     function decimals() public view returns(uint8) {
222       return _decimals;
223     }
224 }