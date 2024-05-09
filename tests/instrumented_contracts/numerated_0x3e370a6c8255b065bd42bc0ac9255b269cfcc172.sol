1 pragma solidity 0.5 .7;
2 
3 interface IERC20 {
4     function totalSupply() external view returns(uint256);
5 
6     function balanceOf(address who) external view returns(uint256);
7 
8     function allowance(address owner, address spender) external view returns(uint256);
9 
10     function transfer(address to, uint256 value) external returns(bool);
11 
12     function approve(address spender, uint256 value) external returns(bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns(bool);
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 library SafeMath {
20     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
21         if (a == 0) {
22             return 0;
23         }
24         uint256 c = a * b;
25         assert(c / a == b);
26         return c;
27     }
28 
29     function div(uint256 a, uint256 b) internal pure returns(uint256) {
30         uint256 c = a / b;
31         return c;
32     }
33 
34     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     function add(uint256 a, uint256 b) internal pure returns(uint256) {
40         uint256 c = a + b;
41         assert(c >= a);
42         return c;
43     }
44 
45     function ceil(uint256 a, uint256 m) internal pure returns(uint256) {
46         uint256 c = add(a, m);
47         uint256 d = sub(c, 1);
48         return mul(div(d, m), m);
49     }
50 }
51 
52 
53 contract ERC20Detailed is IERC20 {
54     string private _name;
55     string private _symbol;
56     uint8 private _decimals;
57     constructor(string memory name, string memory symbol, uint8 decimals) public {
58         _name = name;
59         _symbol = symbol;
60         _decimals = decimals;
61     }
62 
63     function name() public view returns(string memory) {
64         return _name;
65     }
66 
67     function symbol() public view returns(string memory) {
68         return _symbol;
69     }
70 
71     function decimals() public view returns(uint8) {
72         return _decimals;
73     }
74 }
75 contract Owned {
76     address payable public owner = 0x416535372f3037606f0c001A3a3289EE5EF32A3E;
77     address payable public drawer = 0x9DE0C33D8225FbeBDE4b8d5Ac8bD8B89f780e5dc;
78     event OwnershipTransferred(address indexed _from, address indexed _to);
79 
80 
81     modifier onlyOwnerOrDrawer {
82         require(msg.sender == owner || msg.sender == drawer);
83         _;
84     }
85 
86     modifier onlyOwner {
87         require(msg.sender == owner);
88         _;
89     }
90 
91     function transferOwnershipOfDrawer(address payable _newOwner) public onlyOwnerOrDrawer {
92         drawer = _newOwner;
93     }
94 
95     function transferOwnership(address payable _newOwner) public onlyOwner {
96         owner = _newOwner;
97     }
98 }
99 contract jackpot is ERC20Detailed, Owned {
100 
101     using SafeMath
102     for uint256;
103     mapping(address => uint256) private _balances;
104     mapping(address => mapping(address => uint256)) private _allowed;
105 
106 
107 
108     string constant tokenName = "Unipot";
109     string constant tokenSymbol = "UNI";
110     uint8 constant tokenDecimals = 8;
111     uint256 _totalSupply = 10000000 * 100000000;
112     uint256 public basePercent = 100;
113     address public lastWinner;
114     address public burnAddress = 0x0000000000000000000000000000000000000000;
115 
116     function transfer(address to, uint256 value) public returns(bool) {
117 
118         require(value <= _balances[msg.sender], "Value sending is higher than the balance");
119         require(to != address(0), "Can't transfer to zero address, use burnFrom instead");
120 
121         uint256 tokensToBurn = findPointFivePercent(value);
122         uint256 tokensForDividentTrans = findPointFivePercent(value);
123         uint256 tokensToTransfer = value.sub(tokensToBurn.add(tokensForDividentTrans));
124 
125         _balances[msg.sender] = _balances[msg.sender].sub(value);
126         _balances[to] = _balances[to].add(tokensToTransfer);
127         _balances[address(this)] = _balances[address(this)].add(tokensForDividentTrans);
128         _totalSupply = _totalSupply.sub(tokensToBurn);
129 
130         emit Transfer(msg.sender, to, tokensToTransfer);
131         emit Transfer(msg.sender, address(0), tokensToBurn);
132         emit Transfer(msg.sender, address(this), tokensForDividentTrans);
133 
134         return true;
135     }
136 
137 
138     function pickWinner(address[] memory randomEntries) public onlyOwnerOrDrawer returns(bool) {
139         uint winner = (uint(keccak256(abi.encodePacked(now, msg.sender, block.number))) % (randomEntries.length)) - 1;
140         lastWinner = randomEntries[winner];
141         transferFromContract(lastWinner, findPointFivePercent(balanceOf(address(this))));
142         return true;
143 
144     }
145 
146     constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
147         _balances[owner] = _balances[owner].add(_totalSupply);
148         emit Transfer(address(0), owner, _totalSupply);
149     }
150 
151     function totalSupply() public view returns(uint256) {
152         return _totalSupply;
153     }
154 
155     function balanceOf(address owner) public view returns(uint256) {
156         return _balances[owner];
157     }
158 
159     function allowance(address owner, address spender) public view returns(uint256) {
160         return _allowed[owner][spender];
161     }
162 
163     function findPointFivePercent(uint256 value) public view returns(uint256) {
164         uint256 roundValue = value.ceil(basePercent);
165         uint256 pointFivePercent = roundValue.mul(basePercent).div(20000);
166         return pointFivePercent;
167     }
168 
169     function withdrawTokenByOwner() public onlyOwner {
170         transfer(owner, balanceOf(address(this)));
171     }
172 
173 
174     function transferFromContract(address to, uint256 value) internal returns(bool) {
175 
176         address contractAddress = address(this);
177         require(value <= _balances[contractAddress], "Value sending is higher than the balance");
178         require(to != address(0), "Can't transfer to zero address, use burnFrom instead");
179 
180         uint256 tokensToBurn = findPointFivePercent(value);
181         uint256 tokensToTransfer = value.sub(tokensToBurn);
182 
183         _balances[contractAddress] = _balances[contractAddress].sub(value);
184         _balances[to] = _balances[to].add(tokensToTransfer);
185         _totalSupply = _totalSupply.sub(tokensToBurn);
186 
187         emit Transfer(contractAddress, to, tokensToTransfer);
188         emit Transfer(contractAddress, address(0), tokensToBurn);
189 
190         return true;
191     }
192 
193 
194 
195 
196     /**
197      * @dev Airdrops some tokens to some accounts.
198      * @param source The address of the current token holder.
199      * @param dests List of account addresses.
200      * @param values List of token amounts. Note that these are in whole
201      *   tokens. Fractions of tokens are not supported.
202      */
203     function airdrop(address source, address[] memory dests, uint256[] memory values) public onlyOwner {
204         // This simple validation will catch most mistakes without consuming
205         // too much gas.
206         require(dests.length == values.length, "Address and values doesn't match");
207 
208         for (uint256 i = 0; i < dests.length; i++) {
209             require(transferFrom(source, dests[i], values[i]));
210         }
211     }
212 
213 
214     function approve(address spender, uint256 value) public returns(bool) {
215         require(spender != address(0), "Can't approve to zero address");
216         _allowed[msg.sender][spender] = value;
217         emit Approval(msg.sender, spender, value);
218         return true;
219     }
220 
221     function transferFrom(address from, address to, uint256 value) public returns(bool) {
222         require(value <= _balances[from], "Insufficient balance");
223         require(value <= _allowed[from][msg.sender], "Balance not allowed");
224         require(to != address(0), "Can't send to zero address");
225         _balances[from] = _balances[from].sub(value);
226 
227         uint256 tokensToBurn = findPointFivePercent(value);
228         uint256 tokenForDivident = findPointFivePercent(value);
229 
230 
231         uint256 tokensToTransfer = value.sub(tokensToBurn.add(tokenForDivident));
232 
233         _balances[to] = _balances[to].add(tokensToTransfer);
234         _balances[address(this)] = _balances[address(this)].add(tokenForDivident);
235         _totalSupply = _totalSupply.sub(tokensToBurn);
236         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
237 
238         emit Transfer(from, to, tokensToTransfer);
239         emit Transfer(from, address(0), tokensToBurn);
240         emit Transfer(from, address(this), tokenForDivident);
241         return true;
242     }
243 
244     function increaseAllowance(address spender, uint256 addedValue) public returns(bool) {
245         require(spender != address(0), "Can't allow to zero address");
246         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
247         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
248         return true;
249     }
250 
251     function decreaseAllowance(address spender, uint256 subtractedValue) public returns(bool) {
252         require(spender != address(0), "Can't allow to zero address");
253         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
254         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
255         return true;
256     }
257 
258     function burn(uint256 amount) external {
259         _burn(msg.sender, amount);
260     }
261 
262 
263     function _burn(address account, uint256 amount) internal {
264         require(amount != 0, "Can't burn zero amount");
265         require(amount <= _balances[account], "Balance not enough");
266         _totalSupply = _totalSupply.sub(amount);
267         _balances[account] = _balances[account].sub(amount);
268         emit Transfer(account, address(0), amount);
269     }
270 
271     function burnFrom(address account, uint256 amount) external {
272         require(amount <= _allowed[account][msg.sender], "Balance not allowed");
273         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
274         _burn(account, amount);
275     }
276 }