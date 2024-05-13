1 //SPDX-License-Identifier: Unlicense
2 pragma solidity ^0.6.12;
3 
4 import "../deps/@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
5 import "../deps/@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
6 import "./ICoreOracle.sol";
7 
8 /*
9     Wrapped Interest-Bearing Bitcoin (Non-Ethereum mainnet variant)
10 */
11 contract WrappedIbbtc is Initializable, ERC20Upgradeable {
12     address public governance;
13     address public pendingGovernance;
14     ERC20Upgradeable public ibbtc; 
15 
16     ICoreOracle public oracle;
17 
18     event SetOracle(address oracle);
19     event SetPendingGovernance(address pendingGovernance);
20     event AcceptPendingGovernance(address pendingGovernance);
21 
22     /// ===== Modifiers =====
23     modifier onlyPendingGovernance() {
24         require(msg.sender == pendingGovernance, "onlyPendingGovernance");
25         _;
26     }
27 
28     modifier onlyGovernance() {
29         require(msg.sender == governance, "onlyGovernance");
30         _;
31     }
32 
33     modifier onlyOracle() {
34         require(msg.sender == address(oracle), "onlyOracle");
35         _;
36     }
37 
38     function initialize(address _governance, address _ibbtc, address _oracle) public initializer {
39         __ERC20_init("Wrapped Interest-Bearing Bitcoin", "wibBTC");
40         governance = _governance;
41         oracle = ICoreOracle(_oracle);
42         ibbtc = ERC20Upgradeable(_ibbtc);
43 
44         emit SetOracle(_oracle);
45     }
46 
47     /// ===== Permissioned: Governance =====
48     function setPendingGovernance(address _pendingGovernance) external onlyGovernance {
49         pendingGovernance = _pendingGovernance;
50         emit SetPendingGovernance(pendingGovernance);
51     }
52 
53     function setOracle(address _oracle) external onlyGovernance {
54         oracle = ICoreOracle(_oracle);
55         emit SetOracle(_oracle);
56     }
57 
58     /// ===== Permissioned: Pending Governance =====
59     function acceptPendingGovernance() external onlyPendingGovernance {
60         governance = pendingGovernance;
61         emit AcceptPendingGovernance(pendingGovernance);
62     }
63 
64     /// ===== Permissionless Calls =====
65 
66     /// @dev Deposit ibBTC to mint wibBTC shares
67     function mint(uint256 _shares) external {
68         require(ibbtc.transferFrom(_msgSender(), address(this), _shares));
69         _mint(_msgSender(), _shares);
70     }
71 
72     /// @dev Redeem wibBTC for ibBTC. Denominated in shares.
73     function burn(uint256 _shares) external {
74         _burn(_msgSender(), _shares);
75         require(ibbtc.transfer(_msgSender(), _shares));
76     }
77 
78     /// ===== Transfer Overrides =====
79     /**
80      * @dev See {IERC20-transferFrom}.
81      *
82      * Emits an {Approval} event indicating the updated allowance. This is not
83      * required by the EIP. See the note at the beginning of {ERC20};
84      *
85      * Requirements:
86      * - `sender` and `recipient` cannot be the zero address.
87      * - `sender` must have a balance of at least `amount`.
88      * - the caller must have allowance for ``sender``'s tokens of at least
89      * `amount`.
90      */
91     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
92         /// @dev the _balances mapping represents the underlying ibBTC shares ("non-rebased balances")
93         /// @dev the naming confusion is due to maintaining original ERC20 code as much as possible
94 
95         uint256 amountInShares = balanceToShares(amount);
96 
97         _transfer(sender, recipient, amountInShares);
98         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amountInShares, "ERC20: transfer amount exceeds allowance"));
99         return true;
100     }
101 
102     /**
103      * @dev See {IERC20-transfer}.
104      *
105      * Requirements:
106      *
107      * - `recipient` cannot be the zero address.
108      * - the caller must have a balance of at least `amount`.
109      */
110     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
111         /// @dev the _balances mapping represents the underlying ibBTC shares ("non-rebased balances")
112         /// @dev the naming confusion is due to maintaining original ERC20 code as much as possible
113 
114         uint256 amountInShares = balanceToShares(amount);
115 
116         _transfer(_msgSender(), recipient, amountInShares);
117         return true;
118     }
119 
120     /// ===== View Methods =====
121 
122     /// @dev Current pricePerShare read live from oracle
123     function pricePerShare() public view virtual returns (uint256) {
124         return oracle.pricePerShare();
125     }
126 
127     /// @dev Wrapped ibBTC shares of account
128     function sharesOf(address account) public view returns (uint256) {
129         return _balances[account];
130     }
131 
132     /// @dev Current account shares * pricePerShare
133     function balanceOf(address account) public view override returns (uint256) {
134         return sharesOf(account).mul(pricePerShare()).div(1e18);
135     }
136 
137     /// @dev Total wrapped ibBTC shares
138     function totalShares() public view returns (uint256) {
139         return _totalSupply;
140     }
141 
142     /// @dev Current total shares * pricePerShare
143     function totalSupply() public view override returns (uint256) {
144         return totalShares().mul(pricePerShare()).div(1e18);
145     }
146 
147     function balanceToShares(uint256 balance) public view returns (uint256) {
148         return balance.mul(1e18).div(pricePerShare());
149     }
150 
151     function sharesToBalance(uint256 shares) public view returns (uint256) {
152         return shares.mul(pricePerShare()).div(1e18);
153     }
154 }
