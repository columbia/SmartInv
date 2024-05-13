1 // SPDX-License-Identifier: AGPL-3.0-only
2 pragma solidity 0.8.17;
3 
4 import {ERC20} from "./ERC20.sol";
5 import {FixedPointMathLib} from "./utils/FixedPointMathLib.sol";
6 
7 /// @notice Minimal ERC4626 tokenized Vault implementation.
8 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/mixins/ERC4626.sol)
9 abstract contract ERC4626 is ERC20 {
10     
11     using FixedPointMathLib for uint256;
12 
13     /*//////////////////////////////////////////////////////////////
14                                IMMUTABLES
15     //////////////////////////////////////////////////////////////*/
16 
17     ERC20 public immutable asset;
18 
19     constructor(ERC20 _asset, string memory _name, string memory _symbol) ERC20(_name, _symbol, _asset.decimals()) {
20         asset = _asset;
21     }
22 
23     /*//////////////////////////////////////////////////////////////
24                         DEPOSIT/WITHDRAWAL LOGIC
25     //////////////////////////////////////////////////////////////*/
26 
27     /// @dev Mints Vault shares to receiver by depositing exact amount of underlying assets.
28     /// @param assets - The amount of assets to deposit.
29     /// @param receiver - The receiver of minted shares.
30     /// @return shares - The amount of shares minted.
31     function deposit(uint256 assets, address receiver) external virtual returns (uint256 shares) {
32         // require(assets <= maxDeposit(receiver), "ERC4626: deposit more than max");
33 
34         // shares = previewDeposit(assets);
35         // _deposit(msg.sender, receiver, assets, shares);
36 
37         // return shares;
38     }
39 
40     /// @dev Mints exact Vault shares to receiver by depositing amount of underlying assets.
41     /// @param shares - The shares to receive.
42     /// @param receiver - The address of the receiver of shares.
43     /// @return assets - The amount of underlying assets received.
44     function mint(uint256 shares, address receiver) external virtual returns (uint256 assets) {
45         // require(shares <= maxMint(receiver), "ERC4626: mint more than max");
46 
47         // assets = previewMint(shares);
48         // _deposit(msg.sender, receiver, assets, shares);
49 
50         // return assets;
51     }
52 
53     /// @dev Burns shares from owner and sends exact assets of underlying assets to receiver.
54     /// @param assets - The amount of underlying assets to receive.
55     /// @param receiver - The address of the receiver of underlying assets.
56     /// @param owner - The owner of shares.
57     /// @return shares - The amount of shares burned.
58     function withdraw(uint256 assets, address receiver, address owner) external virtual returns (uint256 shares) {
59         // require(assets <= maxWithdraw(owner), "ERC4626: withdraw more than max");
60 
61         // shares = previewWithdraw(assets);
62         // _withdraw(msg.sender, receiver, owner, assets, shares);
63 
64         // return shares;
65     }
66 
67     /// @dev Burns exact shares from owner and sends assets of underlying tokens to receiver.
68     /// @param shares - The shares to burn.
69     /// @param receiver - The address of the receiver of underlying assets.
70     /// @param owner - The owner of shares to burn.
71     /// @return assets - The amount of assets returned to the user.
72     function redeem(uint256 shares, address receiver, address owner) external virtual returns (uint256 assets) {
73         // require(shares <= maxRedeem(owner), "ERC4626: redeem more than max");
74 
75         // assets = previewRedeem(shares);
76         // _withdraw(msg.sender, receiver, owner, assets, shares);
77 
78         // return assets;
79     }
80 
81     /*//////////////////////////////////////////////////////////////
82                             ACCOUNTING LOGIC
83     //////////////////////////////////////////////////////////////*/
84 
85     /// @dev Returns the total amount of the underlying asset that is “managed” by Vault.
86     function totalAssets() public view virtual returns (uint256);
87 
88     /// @dev Returns the amount of shares that the Vault would exchange for the amount of assets provided, in an ideal scenario.
89     function convertToShares(uint256 assets) public view virtual returns (uint256) {
90         uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.
91 
92         // slither-disable-next-line incorrect-equality
93         return supply == 0 ? assets : assets.mulDivDown(supply, totalAssets());
94     }
95 
96     /// @dev Returns the amount of assets that the Vault would exchange for the amount of shares provided, in an ideal scenario
97     function convertToAssets(uint256 shares) public view virtual returns (uint256) {
98         uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.
99 
100         // slither-disable-next-line incorrect-equality
101         return supply == 0 ? shares : shares.mulDivDown(totalAssets(), supply);
102     }
103 
104     /// @dev Allows an on-chain or off-chain user to simulate the effects of their deposit at the current block, given current on-chain conditions.
105     function previewDeposit(uint256 _assets) public view virtual returns (uint256) {
106         return convertToShares(_assets);
107     }
108 
109     /// @dev Allows an on-chain or off-chain user to simulate the effects of their mint at the current block, given current on-chain conditions.
110     function previewMint(uint256 _shares) public view virtual returns (uint256) {
111         return convertToAssets(_shares);
112     }
113 
114     /// @dev Allows an on-chain or off-chain user to simulate the effects of their withdrawal at the current block, given current on-chain conditions.
115     function previewWithdraw(uint256 assets) public view virtual returns (uint256) {
116         return convertToShares(assets);
117     }
118 
119     /// @dev Allows an on-chain or off-chain user to simulate the effects of their redeemption at the current block, given current on-chain conditions.
120     function previewRedeem(uint256 shares) public view virtual returns (uint256) {
121         return convertToAssets(shares);
122     }
123 
124     /*//////////////////////////////////////////////////////////////
125                      DEPOSIT/WITHDRAWAL LIMIT LOGIC
126     //////////////////////////////////////////////////////////////*/
127 
128     /// @dev Returns the maximum amount of the underlying asset that can be deposited into the Vault for the receiver, through a deposit call.
129     function maxDeposit(address) public view virtual returns (uint256) {
130         return type(uint256).max;
131     }
132 
133     /// @dev Returns the maximum amount of the Vault shares that can be minted for the receiver, through a mint call.
134     function maxMint(address) public view virtual returns (uint256) {
135         return type(uint256).max;
136     }
137 
138     /// @dev Returns the maximum amount of the underlying asset that can be withdrawn from the owner balance in the Vault, through a withdraw call.
139     function maxWithdraw(address owner) public view virtual returns (uint256) {
140         return convertToAssets(balanceOf[owner]);
141     }
142 
143     /// @dev Returns the maximum amount of Vault shares that can be redeemed from the owner balance in the Vault, through a redeem call.
144     function maxRedeem(address owner) public view virtual returns (uint256) {
145         return balanceOf[owner];
146     }
147 
148     /*//////////////////////////////////////////////////////////////
149                           INTERNAL HOOKS LOGIC
150     //////////////////////////////////////////////////////////////*/
151 
152    function _withdraw(address caller, address receiver, address owner, uint256 assets, uint256 shares) internal virtual {}
153 
154     function _deposit(address caller, address receiver, uint256 assets, uint256 shares) internal virtual {}
155 }