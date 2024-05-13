1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
5 import "../libraries/ScaledMath.sol";
6 import "../interfaces/ILpToken.sol";
7 import "../interfaces/pool/ILiquidityPool.sol";
8 import "../libraries/Errors.sol";
9 
10 contract LpToken is ILpToken, ERC20Upgradeable {
11     using ScaledMath for uint256;
12 
13     uint8 private _decimals;
14 
15     address public override minter;
16 
17     /**
18      * @notice Make a function only callable by the minter contract.
19      * @dev Fails if msg.sender is not the minter.
20      */
21     modifier onlyMinter() {
22         require(msg.sender == minter, Error.UNAUTHORIZED_ACCESS);
23         _;
24     }
25 
26     constructor() ERC20Upgradeable() {}
27 
28     function initialize(
29         string memory name_,
30         string memory symbol_,
31         uint8 decimals_,
32         address _minter
33     ) external override initializer returns (bool) {
34         require(_minter != address(0), Error.ZERO_ADDRESS_NOT_ALLOWED);
35         __ERC20_init(name_, symbol_);
36         _decimals = decimals_;
37         minter = _minter;
38         return true;
39     }
40 
41     /**
42      * @notice Mint tokens.
43      * @param account Account from which tokens should be burned.
44      * @param amount Amount of tokens to mint.
45      */
46     function mint(address account, uint256 amount) external override onlyMinter {
47         _mint(account, amount);
48     }
49 
50     /**
51      * @notice Burns tokens of msg.sender.
52      * @param amount Amount of tokens to burn.
53      */
54     function burn(uint256 amount) external override {
55         _burn(msg.sender, amount);
56     }
57 
58     /**
59      * @notice Burn tokens.
60      * @param owner Account from which tokens should be burned.
61      * @param burnAmount Amount of tokens to burn.
62      * @return Aamount of tokens burned.
63      */
64     function burn(address owner, uint256 burnAmount)
65         external
66         override
67         onlyMinter
68         returns (uint256)
69     {
70         _burn(owner, burnAmount);
71         return burnAmount;
72     }
73 
74     function decimals() public view virtual override returns (uint8) {
75         return _decimals;
76     }
77 
78     /**
79      * @dev We notify that LP tokens have been transfered
80      * this is currently used to keep track of the withdrawal fees
81      */
82     function _beforeTokenTransfer(
83         address from,
84         address to,
85         uint256 amount
86     ) internal virtual override {
87         if (amount > 0) ILiquidityPool(minter).handleLpTokenTransfer(from, to, amount); // add check to not break 0 transfers
88     }
89 }
