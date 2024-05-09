1 pragma solidity ^0.5.17;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint);
5     function balanceOf(address account) external view returns (uint);
6     function transfer(address recipient, uint amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint);
8     function approve(address spender, uint amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
10     event Transfer(address indexed from, address indexed to, uint value);
11     event Approval(address indexed owner, address indexed spender, uint value);
12 }
13 
14 library SafeMath {
15     function add(uint a, uint b) internal pure returns (uint) {
16         uint c = a + b;
17         require(c >= a, "SafeMath: addition overflow");
18 
19         return c;
20     }
21     function sub(uint a, uint b) internal pure returns (uint) {
22         return sub(a, b, "SafeMath: subtraction overflow");
23     }
24     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
25         require(b <= a, errorMessage);
26         uint c = a - b;
27 
28         return c;
29     }
30     function mul(uint a, uint b) internal pure returns (uint) {
31         if (a == 0) {
32             return 0;
33         }
34 
35         uint c = a * b;
36         require(c / a == b, "SafeMath: multiplication overflow");
37 
38         return c;
39     }
40     function div(uint a, uint b) internal pure returns (uint) {
41         return div(a, b, "SafeMath: division by zero");
42     }
43     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
44         // Solidity only automatically asserts when dividing by 0
45         require(b > 0, errorMessage);
46         uint c = a / b;
47 
48         return c;
49     }
50 }
51 
52 contract ERC20 is IERC20 {
53     using SafeMath for uint;
54 
55     mapping (address => uint) private _balances;
56 
57     mapping (address => mapping (address => uint)) private _allowances;
58 
59     uint private _totalSupply;
60     function totalSupply() public view returns (uint) {
61         return _totalSupply;
62     }
63     function balanceOf(address account) public view returns (uint) {
64         return _balances[account];
65     }
66     function transfer(address recipient, uint amount) public returns (bool) {
67         _transfer(msg.sender, recipient, amount);
68         return true;
69     }
70     function allowance(address owner, address spender) public view returns (uint) {
71         return _allowances[owner][spender];
72     }
73     function approve(address spender, uint amount) public returns (bool) {
74         _approve(msg.sender, spender, amount);
75         return true;
76     }
77     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
78         _transfer(sender, recipient, amount);
79         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
80         return true;
81     }
82     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
83         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
84         return true;
85     }
86     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
87         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
88         return true;
89     }
90     function _transfer(address sender, address recipient, uint amount) internal {
91         require(sender != address(0), "ERC20: transfer from the zero address");
92         require(recipient != address(0), "ERC20: transfer to the zero address");
93 
94         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
95         _balances[recipient] = _balances[recipient].add(amount);
96         emit Transfer(sender, recipient, amount);
97     }
98     function _mint(address account, uint amount) internal {
99         require(account != address(0), "ERC20: mint to the zero address");
100 
101         _totalSupply = _totalSupply.add(amount);
102         _balances[account] = _balances[account].add(amount);
103         emit Transfer(address(0), account, amount);
104     }
105     function _burn(address account, uint amount) internal {
106         require(account != address(0), "ERC20: burn from the zero address");
107 
108         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
109         _totalSupply = _totalSupply.sub(amount);
110         emit Transfer(account, address(0), amount);
111     }
112     function _approve(address owner, address spender, uint amount) internal {
113         require(owner != address(0), "ERC20: approve from the zero address");
114         require(spender != address(0), "ERC20: approve to the zero address");
115 
116         _allowances[owner][spender] = amount;
117         emit Approval(owner, spender, amount);
118     }
119 }
120 
121 contract ERC20Detailed is IERC20 {
122     string private _name;
123     string private _symbol;
124     uint8 private _decimals;
125 
126     constructor (string memory name, string memory symbol, uint8 decimals) public {
127         _name = name;
128         _symbol = symbol;
129         _decimals = decimals;
130     }
131     function name() public view returns (string memory) {
132         return _name;
133     }
134     function symbol() public view returns (string memory) {
135         return _symbol;
136     }
137     function decimals() public view returns (uint8) {
138         return _decimals;
139     }
140 }
141 
142 interface BondingCurve {
143     function calculatePurchaseReturn(uint _supply,  uint _reserveBalance, uint32 _reserveRatio, uint _depositAmount) external view returns (uint);
144     function calculateSaleReturn(uint _supply, uint _reserveBalance, uint32 _reserveRatio, uint _sellAmount) external view returns (uint);
145 }
146 
147 contract ContinuousToken is ERC20 {
148     using SafeMath for uint;
149 
150     uint public scale = 10**18;
151     uint public reserveBalance = 1*10**15;
152     uint32 public reserveRatio;
153     
154     BondingCurve constant public CURVE = BondingCurve(0x16F6664c16beDE5d70818654dEfef11769D40983);
155 
156     function _buy(uint _amount) internal returns (uint _bought) {
157         _bought = _continuousMint(_amount);
158     }
159 
160     function _sell(uint _amount) internal returns (uint _sold) {
161         _sold = _continuousBurn(_amount);
162     }
163 
164     function calculateContinuousMintReturn(uint _amount) public view returns (uint mintAmount) {
165         return CURVE.calculatePurchaseReturn(totalSupply(), reserveBalance, uint32(reserveRatio), _amount);
166     }
167 
168     function calculateContinuousBurnReturn(uint _amount) public view returns (uint burnAmount) {
169         return CURVE.calculateSaleReturn(totalSupply(), reserveBalance, uint32(reserveRatio), _amount);
170     }
171 
172     function _continuousMint(uint _deposit) internal returns (uint) {
173         uint amount = calculateContinuousMintReturn(_deposit);
174         reserveBalance = reserveBalance.add(_deposit);
175         return amount;
176     }
177 
178     function _continuousBurn(uint _amount) internal returns (uint) {
179         uint reimburseAmount = calculateContinuousBurnReturn(_amount);
180         reserveBalance = reserveBalance.sub(reimburseAmount);
181         return reimburseAmount;
182     }
183 }
184 
185 contract EminenceCurrency is ContinuousToken, ERC20Detailed {
186     mapping(address => bool) public gamemasters;
187     mapping(address => bool) public npcs;
188     
189     event AddGM(address indexed newGM, address indexed gm);
190     event RevokeGM(address indexed newGM, address indexed gm);
191     event AddNPC(address indexed newNPC, address indexed gm);
192     event RevokeNPC(address indexed newNPC, address indexed gm);
193     event CashShopBuy(address _from, uint  _amount, uint _deposit);
194     event CashShopSell(address _from, uint  _amount, uint _reimbursement);
195     
196     EminenceCurrency constant public EMN = EminenceCurrency(0x5ade7aE8660293F2ebfcEfaba91d141d72d221e8);
197     
198     constructor (string memory name, string memory symbol, uint32 _reserveRatio) public ERC20Detailed(name, symbol, 18) {
199         gamemasters[msg.sender] = true;
200         EMN.addGM(address(this));
201         reserveRatio = _reserveRatio;
202         _mint(msg.sender, 1*scale);
203     }
204     function addNPC(address _npc) external {
205         require(gamemasters[msg.sender], "!gm");
206         npcs[_npc] = true;
207         emit AddNPC(_npc, msg.sender);
208     }
209     function revokeNPC(address _npc) external {
210         require(gamemasters[msg.sender], "!gm");
211         npcs[_npc] = false;
212         emit RevokeNPC(_npc, msg.sender);
213     }
214     function addGM(address _gm) external {
215         require(gamemasters[msg.sender]||gamemasters[tx.origin], "!gm");
216         gamemasters[_gm] = true;
217         emit AddGM(_gm, msg.sender);
218     }
219     function revokeGM(address _gm) external {
220         require(gamemasters[msg.sender], "!gm");
221         gamemasters[_gm] = false;
222         emit RevokeGM(_gm, msg.sender);
223     }
224     function award(address _to, uint _amount) external {
225         require(gamemasters[msg.sender], "!gm");
226         _mint(_to, _amount);
227     }
228     function claim(address _from, uint _amount) external {
229         require(gamemasters[msg.sender]||npcs[msg.sender], "!gm");
230         _burn(_from, _amount);
231     }
232     function buy(uint _amount, uint _min) external returns (uint _bought) {
233         _bought = _buy(_amount);
234         require(_bought >= _min, "slippage");
235         EMN.claim(msg.sender, _amount);
236         _mint(msg.sender, _bought);
237         emit CashShopBuy(msg.sender, _bought, _amount);
238     }
239     function sell(uint _amount, uint _min) external returns (uint _bought) {
240         _bought = _sell(_amount);
241         require(_bought >= _min, "slippage");
242         _burn(msg.sender, _amount);
243         EMN.award(msg.sender, _bought);
244         emit CashShopSell(msg.sender, _amount, _bought);
245     }
246 }