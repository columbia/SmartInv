1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../fei/Fei.sol";
5 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
6 
7 /// @notice contract to create a permanent governanceless FEI-DAI PSM
8 /// As long as Tribe DAO's governance is active, the funds in this contract
9 /// can still be accessed : the Tribe DAO can mint FEI at will and get the DAI
10 /// in this contract, and could revoke the MINTER role from this contract,
11 /// preventing it to create new FEI.
12 /// This contract acts as a FEI sink and can burn the FEI it holds.
13 /// Burning the MINTER_ROLE from the Tribe DAO will make this PSM act
14 /// like a permanent feeless FEI-DAI wrapper.
15 contract SimpleFeiDaiPSM {
16     using SafeERC20 for Fei;
17     using SafeERC20 for IERC20;
18 
19     IERC20 private constant DAI = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
20     Fei private constant FEI = Fei(0x956F47F50A910163D8BF957Cf5846D573E7f87CA);
21 
22     // ----------------------------------------------------------------------------
23     // Peg Stability Module functionalities
24     // ----------------------------------------------------------------------------
25 
26     /// @notice event emitted upon a redemption
27     event Redeem(address indexed to, uint256 amountFeiIn, uint256 amountAssetOut);
28     /// @notice event emitted when fei gets minted
29     event Mint(address indexed to, uint256 amountIn, uint256 amountFeiOut);
30 
31     /// @notice mint `amountFeiOut` FEI to address `to` for `amountIn` underlying tokens
32     /// @dev see getMintAmountOut() to pre-calculate amount out
33     function mint(
34         address to,
35         uint256 amountIn,
36         uint256 // minAmountOut
37     ) external returns (uint256 amountFeiOut) {
38         amountFeiOut = amountIn;
39         DAI.safeTransferFrom(msg.sender, address(this), amountIn);
40         FEI.mint(to, amountFeiOut);
41         emit Mint(to, amountIn, amountFeiOut);
42     }
43 
44     /// @notice redeem `amountFeiIn` FEI for `amountOut` underlying tokens and send to address `to`
45     /// @dev see getRedeemAmountOut() to pre-calculate amount out
46     /// @dev FEI received is not burned, see `burnFeiHeld()` below to batch-burn the FEI redeemed
47     function redeem(
48         address to,
49         uint256 amountFeiIn,
50         uint256 // minAmountOut
51     ) external returns (uint256 amountOut) {
52         amountOut = amountFeiIn;
53         FEI.safeTransferFrom(msg.sender, address(this), amountFeiIn);
54         DAI.safeTransfer(to, amountOut);
55         emit Redeem(to, amountFeiIn, amountOut);
56     }
57 
58     /// @notice calculate the amount of FEI out for a given `amountIn` of underlying
59     function getMintAmountOut(uint256 amountIn) external pure returns (uint256) {
60         return amountIn;
61     }
62 
63     /// @notice calculate the amount of underlying out for a given `amountFeiIn` of FEI
64     function getRedeemAmountOut(uint256 amountIn) external pure returns (uint256) {
65         return amountIn;
66     }
67 
68     // ----------------------------------------------------------------------------
69     // Functions to make this contract compatible with the PCVDeposit interface
70     // and accounted for in the Fei Protocol's Collateralization Oracle
71     // ----------------------------------------------------------------------------
72 
73     address public constant balanceReportedIn = address(DAI);
74 
75     /// @notice gets the effective balance of "balanceReportedIn" token if the deposit were fully withdrawn
76     function balance() external view returns (uint256) {
77         return DAI.balanceOf(address(this));
78     }
79 
80     /// @notice gets the resistant token balance and protocol owned fei of this deposit
81     function resistantBalanceAndFei() external view returns (uint256, uint256) {
82         return (DAI.balanceOf(address(this)), FEI.balanceOf(address(this)));
83     }
84 
85     // ----------------------------------------------------------------------------
86     // These view functions are meant to make this contract's interface
87     // as similar as possible to the FixedPricePSM as possible.
88     // ----------------------------------------------------------------------------
89 
90     uint256 public constant mintFeeBasisPoints = 0;
91     uint256 public constant redeemFeeBasisPoints = 0;
92     address public constant underlyingToken = address(DAI);
93     uint256 public constant getMaxMintAmountOut = type(uint256).max;
94     bool public constant paused = false;
95     bool public constant redeemPaused = false;
96     bool public constant mintPaused = false;
97 
98     // ----------------------------------------------------------------------------
99     // This contract should act as a FEI sink if needed
100     // ----------------------------------------------------------------------------
101 
102     /// @notice Burns all FEI on this contract.
103     function burnFeiHeld() external {
104         uint256 feiBalance = FEI.balanceOf(address(this));
105         if (feiBalance != 0) {
106             FEI.burn(feiBalance);
107         }
108     }
109 }
