1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./IPSMRouter.sol";
5 import "./PegStabilityModule.sol";
6 import "../Constants.sol";
7 import "../utils/RateLimited.sol";
8 import "../pcv/IPCVDepositBalances.sol";
9 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
10 
11 /// @notice the PSM router is an ungoverned, non custodial contract that allows user to seamlessly wrap and unwrap their WETH
12 /// for trading against the PegStabilityModule.
13 contract PSMRouter is IPSMRouter {
14     using SafeERC20 for IERC20;
15 
16     /// @notice reference to the PegStabilityModule that this router interacts with
17     IPegStabilityModule public immutable override psm;
18     /// @notice reference to the FEI contract used. Does not reference core to save on gas
19     /// Router can be redeployed if FEI address changes
20     IFei public immutable override fei;
21 
22     constructor(IPegStabilityModule _psm, IFei _fei) {
23         psm = _psm;
24         fei = _fei;
25         IERC20(address(Constants.WETH)).approve(address(_psm), type(uint256).max);
26         _fei.approve(address(_psm), type(uint256).max);
27     }
28 
29     modifier ensure(uint256 deadline) {
30         require(deadline >= block.timestamp, "PSMRouter: order expired");
31         _;
32     }
33 
34     // ----------- Public View-Only API ----------
35 
36     /// @notice view only pass through function to get amount of FEI out with given amount of ETH in
37     function getMintAmountOut(uint256 amountIn) public view override returns (uint256 amountFeiOut) {
38         amountFeiOut = psm.getMintAmountOut(amountIn);
39     }
40 
41     /// @notice view only pass through function to get amount of ETH out with given amount of FEI in
42     function getRedeemAmountOut(uint256 amountFeiIn) public view override returns (uint256 amountTokenOut) {
43         amountTokenOut = psm.getRedeemAmountOut(amountFeiIn);
44     }
45 
46     /// @notice the maximum mint amount out
47     function getMaxMintAmountOut() external view override returns (uint256) {
48         return psm.getMaxMintAmountOut();
49     }
50 
51     /// @notice the maximum redeem amount out
52     function getMaxRedeemAmountOut() external view override returns (uint256) {
53         return IPCVDepositBalances(address(psm)).balance();
54     }
55 
56     // ---------- Public State-Changing API ----------
57 
58     /// @notice Mints fei to the given address, with a minimum amount required
59     /// @dev This wraps ETH and then calls into the PSM to mint the fei. We return the amount of fei minted.
60     /// @param to The address to mint fei to
61     /// @param minAmountOut The minimum amount of fei to mint
62     function mint(
63         address to,
64         uint256 minAmountOut,
65         uint256 ethAmountIn
66     ) external payable override returns (uint256) {
67         return _mint(to, minAmountOut, ethAmountIn);
68     }
69 
70     /// @notice Mints fei to the given address, with a minimum amount required and a deadline
71     /// @dev This wraps ETH and then calls into the PSM to mint the fei. We return the amount of fei minted.
72     /// @param to The address to mint fei to
73     /// @param minAmountOut The minimum amount of fei to mint
74     /// @param deadline The deadline for this order to be filled
75     function mint(
76         address to,
77         uint256 minAmountOut,
78         uint256 deadline,
79         uint256 ethAmountIn
80     ) external payable ensure(deadline) returns (uint256) {
81         return _mint(to, minAmountOut, ethAmountIn);
82     }
83 
84     /// @notice Redeems fei for ETH
85     /// First pull user FEI into this contract
86     /// Then call redeem on the PSM to turn the FEI into weth
87     /// Withdraw all weth to eth in the router
88     /// Send the eth to the specified recipient
89     /// @param to the address to receive the eth
90     /// @param amountFeiIn the amount of FEI to redeem
91     /// @param minAmountOut the minimum amount of weth to receive
92     function redeem(
93         address to,
94         uint256 amountFeiIn,
95         uint256 minAmountOut
96     ) external override returns (uint256) {
97         return _redeem(to, amountFeiIn, minAmountOut);
98     }
99 
100     /// @notice Redeems fei for ETH
101     /// First pull user FEI into this contract
102     /// Then call redeem on the PSM to turn the FEI into weth
103     /// Withdraw all weth to eth in the router
104     /// Send the eth to the specified recipient
105     /// @param to the address to receive the eth
106     /// @param amountFeiIn the amount of FEI to redeem
107     /// @param minAmountOut the minimum amount of weth to receive
108     /// @param deadline The deadline for this order to be filled
109     function redeem(
110         address to,
111         uint256 amountFeiIn,
112         uint256 minAmountOut,
113         uint256 deadline
114     ) external ensure(deadline) returns (uint256) {
115         return _redeem(to, amountFeiIn, minAmountOut);
116     }
117 
118     /// @notice function to receive ether from the weth contract when the redeem function is called
119     /// will not accept eth unless there is an active redemption.
120     fallback() external payable {
121         require(msg.sender == address(Constants.WETH), "PSMRouter: fallback sender must be WETH contract");
122     }
123 
124     // ---------- Internal Methods ----------
125 
126     /// @notice helper function to wrap eth and handle mint call to PSM
127     function _mint(
128         address _to,
129         uint256 _minAmountOut,
130         uint256 _ethAmountIn
131     ) internal returns (uint256) {
132         require(_ethAmountIn == msg.value, "PSMRouter: ethAmountIn and msg.value mismatch");
133         Constants.WETH.deposit{value: msg.value}();
134         return psm.mint(_to, msg.value, _minAmountOut);
135     }
136 
137     /// @notice helper function to deposit user FEI, unwrap weth and send eth to the user
138     /// the PSM router receives the weth, then sends it to the specified recipient.
139     function _redeem(
140         address to,
141         uint256 amountFeiIn,
142         uint256 minAmountOut
143     ) internal returns (uint256 amountOut) {
144         IERC20(fei).safeTransferFrom(msg.sender, address(this), amountFeiIn);
145         amountOut = psm.redeem(address(this), amountFeiIn, minAmountOut);
146 
147         Constants.WETH.withdraw(amountOut);
148 
149         (bool success, ) = to.call{value: amountOut}("");
150         require(success, "PSMRouter: eth transfer failed");
151     }
152 }
