1 //SPDX-License-Identifier: Unlicense
2 pragma solidity ^0.6.12;
3 
4 import "../deps/@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
5 import "../deps/@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
6 import "./ICore.sol";
7 
8 /*
9     Wrapped Interest-Bearing Bitcoin (Ethereum mainnet variant)
10 */
11 contract WrappedIbbtcEth is Initializable, ERC20Upgradeable {
12     address public governance;
13     address public pendingGovernance;
14     ERC20Upgradeable public ibbtc; 
15     
16     ICore public core;
17 
18     uint256 public pricePerShare;
19     uint256 public lastPricePerShareUpdate;
20 
21     event SetCore(address core);
22     event SetPricePerShare(uint256 pricePerShare, uint256 updateTimestamp);
23     event SetPendingGovernance(address pendingGovernance);
24     event AcceptPendingGovernance(address pendingGovernance);
25 
26     /// ===== Modifiers =====
27     modifier onlyPendingGovernance() {
28         require(msg.sender == pendingGovernance, "onlyPendingGovernance");
29         _;
30     }
31 
32     modifier onlyGovernance() {
33         require(msg.sender == governance, "onlyGovernance");
34         _;
35     }
36 
37     function initialize(address _governance, address _ibbtc, address _core) public initializer {
38         __ERC20_init("Wrapped Interest-Bearing Bitcoin", "wibBTC");
39         governance = _governance;
40         core = ICore(_core);
41         ibbtc = ERC20Upgradeable(_ibbtc);
42 
43         updatePricePerShare();
44 
45         emit SetCore(_core);
46     }
47 
48     /// ===== Permissioned: Governance =====
49     function setPendingGovernance(address _pendingGovernance) external onlyGovernance {
50         pendingGovernance = _pendingGovernance;
51         emit SetPendingGovernance(pendingGovernance);
52     }
53 
54     /// @dev The ibBTC token is technically capable of having it's Core contract changed via governance process. This allows the wrapper to adapt.
55     /// @dev This function should be run atomically with setCore() on ibBTC if that eventuality ever arises.
56     function setCore(address _core) external onlyGovernance {
57         core = ICore(_core);
58         emit SetCore(_core);
59     }
60 
61     /// ===== Permissioned: Pending Governance =====
62     function acceptPendingGovernance() external onlyPendingGovernance {
63         governance = pendingGovernance;
64         emit AcceptPendingGovernance(pendingGovernance);
65     }
66 
67     /// ===== Permissionless Calls =====
68 
69     /// @dev Update live ibBTC price per share from core
70     /// @dev We cache this to reduce gas costs of mint / burn / transfer operations.
71     /// @dev Update function is permissionless, and must be updated at least once every X time as a sanity check to ensure value is up-to-date
72     function updatePricePerShare() public virtual returns (uint256) {
73         pricePerShare = core.pricePerShare();
74         lastPricePerShareUpdate = now;
75 
76         emit SetPricePerShare(pricePerShare, lastPricePerShareUpdate);
77     }
78 
79     /// @dev Deposit ibBTC to mint wibBTC shares
80     function mint(uint256 _shares) external {
81         require(ibbtc.transferFrom(_msgSender(), address(this), _shares));
82         _mint(_msgSender(), _shares);
83     }
84 
85     /// @dev Redeem wibBTC for ibBTC. Denominated in shares.
86     function burn(uint256 _shares) external {
87         _burn(_msgSender(), _shares);
88         require(ibbtc.transfer(_msgSender(), _shares));
89     }
90 
91     /// ===== Transfer Overrides =====
92     /**
93      * @dev See {IERC20-transferFrom}.
94      *
95      * Emits an {Approval} event indicating the updated allowance. This is not
96      * required by the EIP. See the note at the beginning of {ERC20};
97      *
98      * Requirements:
99      * - `sender` and `recipient` cannot be the zero address.
100      * - `sender` must have a balance of at least `amount`.
101      * - the caller must have allowance for ``sender``'s tokens of at least
102      * `amount`.
103      */
104     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
105         /// The _balances mapping represents the underlying ibBTC shares ("non-rebased balances")
106         /// Some naming confusion emerges due to maintaining original ERC20 var names
107 
108         uint256 amountInShares = balanceToShares(amount);
109 
110         _transfer(sender, recipient, amountInShares);
111         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amountInShares, "ERC20: transfer amount exceeds allowance"));
112         return true;
113     }
114 
115     /**
116      * @dev See {IERC20-transfer}.
117      *
118      * Requirements:
119      *
120      * - `recipient` cannot be the zero address.
121      * - the caller must have a balance of at least `amount`.
122      */
123     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
124         /// The _balances mapping represents the underlying ibBTC shares ("non-rebased balances")
125         /// Some naming confusion emerges due to maintaining original ERC20 var names
126 
127         uint256 amountInShares = balanceToShares(amount);
128 
129         _transfer(_msgSender(), recipient, amountInShares);
130         return true;
131     }
132 
133     /// ===== View Methods =====
134 
135     /// @dev Wrapped ibBTC shares of account
136     function sharesOf(address account) public view returns (uint256) {
137         return _balances[account];
138     }
139 
140     /// @dev Current account shares * pricePerShare
141     function balanceOf(address account) public view override returns (uint256) {
142         return sharesOf(account).mul(pricePerShare).div(1e18);
143     }
144 
145     /// @dev Total wrapped ibBTC shares
146     function totalShares() public view returns (uint256) {
147         return _totalSupply;
148     }
149 
150     /// @dev Current total shares * pricePerShare
151     function totalSupply() public view override returns (uint256) {
152         return totalShares().mul(pricePerShare).div(1e18);
153     }
154 
155     function balanceToShares(uint256 balance) public view returns (uint256) {
156         return balance.mul(1e18).div(pricePerShare);
157     }
158 
159     function sharesToBalance(uint256 shares) public view returns (uint256) {
160         return shares.mul(pricePerShare).div(1e18);
161     }
162 }
