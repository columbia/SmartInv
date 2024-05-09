1 /* 
2  * PROOF ASSET TOKEN (PRS)
3  * Developed by @cryptocreater
4  * Produced by PROOF CAPITAL GROUP
5 
6  * PRF TOKEN INFO *
7    Name      PROOF ASSET
8    Code      PRS
9    Decimals  9
10 
11  * PRS TOKEN MARKETING *
12    1. Liquidity is replenished by transferring ETH tokens to the address of the smart contract by interested parties. Moreover, the return of liquidity is possible only through the exchange of PRS tokens for ETH at the liquidity rate.
13    2. The exchange rate of PRF to PRS is 1:1 in absolute terms or 1000.000000:1.000000000 taking into tokens decimals.
14    3. The exchange rate of PRS to ETH is calculated based on the number of PRS tokens and the amount of liquidity in ETH tokens on the PROOF ASSET smart contract.
15    4. PRS liquidity is calculated using the formula:
16         Lq = Se / Sp
17         where
18         Lq - liquidity of the PRS token (PRS to ETH exchange rate),
19         Se - the volume (amount) of ETH tokens on the PROOF ASSET smart contract,
20         Sp - total emission of PRS tokens.
21    5. According to the provision of liquidity and the mechanics of the smart contract, PRS tokens can be obtained only in exchange for PRF tokens, and part of the liquidity can be withdrawn to ETH only in exchange for PRS tokens. Thus, each PRS token is provided with current liquidity in the ETH token, and a decrease in liquidity is not possible, in contrast to an increase due to its replenishment.
22    6. The remuneration of a smart contract for holding PRF tokens is 0.62% per day and does not depend on the PRF balance.
23    7. The emission of the PRS token is calculated based on the total emission of PRF tokens minus the amount of PRF tokens on the PROOF ASSET smart contract. Thus, each holders PRF token can be exchanged for an PRS token.
24    8. Any PRS token holder, depending on the financial strategy, can independently decide on the exchange of PRF tokens for PRS tokens and PRS tokens for ETH tokens without restrictions on the amount and timing of the exchange.
25 
26  * PRS TOKEN MECHANICS *
27    1. To exchange PRF tokens for PRS tokens, you must:
28     - use the "prf2prs" function, after granting permission to the PROOF ASSET smart contract to write off PRF tokens from the user's address;
29     or
30     - send PRF tokens to the address of the PROOF ASSET smart contract to activate the exchange;
31     - send 0 (zero) ETH to the address of the PROOF ASSET smart contract to receive PRS tokens.    
32    2. To exchange PRS tokens for ETH tokens according to the liquidity rate, you need to send PRS tokens to the address of the PROOF ASSET smart contract.
33     !!!Attention!!!
34     At the time of the exchange of tokens, the liquidity rate may change, because the smart contract will equalize the emission of PRF and PRS tokens, and then calculate the liquidity rate and transfer the corresponding number of ETH tokens.
35    3. Liquidity replenishment can be carried out by any interested person at his discretion in any time and amount exceeding 1 (one) ETH.
36  
37 */
38 
39 pragma solidity 0.6.6;
40 interface IERC20 {
41     function totalSupply() external view returns (uint256);
42     function balanceOf(address account) external view returns (uint256);
43     function transfer(address recipient, uint256 amount) external returns (bool);
44     function allowance(address owner, address spender) external view returns (uint256);
45     function approve(address spender, uint256 amount) external returns (bool);
46     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 interface prfInterface {
51     function swapOf(address account) external view returns (uint256);
52     function fnSwap(address account, uint256 amount) external;
53 }
54 library SafeMath {
55     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
56         require(a + b >= a, "Addition overflow");
57         return a + b;
58     }
59     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
60         require(a >= b, "Substruction overflow");
61         return a - b;
62     }  
63 }
64 library Address {
65     function isContract(address account) internal view returns (bool) {
66         bytes32 codehash;
67         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
68         assembly { codehash := extcodehash(account) }
69         return (codehash != accountHash && codehash != 0x0);
70     }
71 }
72 library SafeERC20 {
73     using SafeMath for uint256;
74     using Address for address;
75     function safeTransfer(IERC20 token, address to, uint256 value) internal { _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value)); }
76     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal { _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value)); }
77     function safeApprove(IERC20 token, address spender, uint256 value) internal {
78         require((value == 0) || (token.allowance(address(this), spender) == 0), "Non-zero allowance" );
79         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
80     }
81     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
82         uint256 newAllowance = token.allowance(address(this), spender).safeAdd(value);
83         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
84     }
85     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
86         uint256 newAllowance = token.allowance(address(this), spender).safeSub(value);
87         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
88     }
89     function _callOptionalReturn(IERC20 token, bytes memory data) private {
90         require(address(token).isContract(), "Non-contract");
91         (bool success, bytes memory returndata) = address(token).call(data);
92         require(success, "Call failed");
93         if (returndata.length > 0) require(abi.decode(returndata, (bool)), "Not succeed");
94     }
95 }
96 contract ERC20 is IERC20 {
97     using SafeMath for uint256;
98     using Address for address;
99     mapping (address => uint256) private _balances;
100     mapping (address => mapping (address => uint256)) private _allowances;
101     uint256 private _totalSupply;
102     string private _name = "PROOF ASSET";
103     string private _symbol = "PRS";
104     uint8 private _decimals = 9;
105     event CheckOut(address indexed addr, uint256 amount);
106     function name() public view returns (string memory) { return _name; }    
107     function symbol() public view returns (string memory) { return _symbol; }    
108     function decimals() public view returns (uint8) { return _decimals; }
109     function totalSupply() public view override returns (uint256) { return _totalSupply; }
110     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
111     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
112         _transfer(msg.sender, recipient, amount);
113         return true;
114     }
115     function allowance(address owner, address spender) public view virtual override returns (uint256) { return _allowances[owner][spender]; }
116     function approve(address spender, uint256 amount) public virtual override returns (bool) {
117         _approve(msg.sender, spender, amount);
118         return true;
119     }
120     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
121         _transfer(sender, recipient, amount);
122         _approve(sender, msg.sender, _allowances[sender][msg.sender].safeSub(amount));
123         return true;
124     }
125     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
126         _approve(msg.sender, spender, _allowances[msg.sender][spender].safeAdd(addedValue));
127         return true;
128     }
129     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
130         _approve(msg.sender, spender, _allowances[msg.sender][spender].safeSub(subtractedValue));
131         return true;
132     }
133     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
134         require(sender != address(0) && recipient != address(0), "Zero address");
135         uint256 _value = beforeTokenTransfer(recipient, amount);
136         if(_value > 0) {
137             _balances[sender] = _balances[sender].safeSub(amount);
138             _totalSupply = _totalSupply.safeSub(amount);
139             emit Transfer(sender, address(0), amount);
140             emit CheckOut(sender, amount);
141             payable(sender).transfer(_value);
142         } else {
143             _balances[sender] = _balances[sender].safeSub(amount);
144             _balances[recipient] = _balances[recipient].safeAdd(amount);
145             emit Transfer(sender, recipient, amount);
146         }        
147     }
148     function _mint(address account, uint256 amount) internal virtual {
149         require(account != address(0), "Zero address");
150         _totalSupply = _totalSupply.safeAdd(amount);
151         _balances[account] = _balances[account].safeAdd(amount);
152         emit Transfer(address(0), account, amount);
153     }
154     function _burn(address account, uint256 amount) internal virtual {
155         require(account != address(0), "Zero address");
156         _balances[account] = _balances[account].safeSub(amount);
157         _totalSupply = _totalSupply.safeSub(amount);
158         emit Transfer(account, address(0), amount);
159     }
160     function _approve(address owner, address spender, uint256 amount) internal virtual {
161         require(owner != address(0) && spender != address(0), "Zero address");
162         _allowances[owner][spender] = amount;
163         emit Approval(owner, spender, amount);
164     }
165     function _setupDecimals(uint8 decimals_) internal { _decimals = decimals_; }
166     function beforeTokenTransfer(address to, uint256 amount) internal virtual returns (uint256) { }
167 }
168 contract ProofAssetToken is ERC20 {
169     using SafeERC20 for IERC20;
170     IERC20 public prf = IERC20(0xf1280a9333eD16182c821aeb6F489B582788E639);    
171     prfInterface public prfInterfaceCall = prfInterface(0xf1280a9333eD16182c821aeb6F489B582788E639);
172     address private smart;
173     event CheckIn(address indexed addr, uint256 prfs);
174     constructor() public { smart = address(this); }
175     function beforeTokenTransfer(address to, uint256 amount) internal override returns (uint256) { return (to == smart) ? amount * smart.balance / totalSupply() : 0; }
176     receive() payable external {
177         if(msg.value == 0) {
178             uint256 _amount = prfInterfaceCall.swapOf(msg.sender);
179             require(_amount > 0, "Send PRF first");
180             prfInterfaceCall.fnSwap(msg.sender, _amount);
181             _mint(msg.sender, _amount);
182             emit CheckIn(msg.sender, _amount);
183         }
184     }
185     function prf2prs(uint256 amount) external {
186         require(amount > 0, "Zero amount");
187         prf.safeTransferFrom(msg.sender, smart, amount);
188         _mint(msg.sender, amount);
189         emit CheckIn(msg.sender, amount);
190     }
191     function prs2eth(uint256 amount) external {
192         uint256 _withdraw = amount * smart.balance / totalSupply();
193         _burn(msg.sender, amount);
194         payable(msg.sender).transfer(_withdraw);
195         emit CheckOut(msg.sender, amount);
196     }
197     function prsBurn(uint256 amount) external { _burn(msg.sender, amount); }
198     function prsRate() external view returns(uint256) { return smart.balance * 1e9 / totalSupply(); }
199 }