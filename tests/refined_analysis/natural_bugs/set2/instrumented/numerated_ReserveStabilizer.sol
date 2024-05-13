1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./IReserveStabilizer.sol";
5 import "../../pcv/PCVDeposit.sol";
6 import "../../refs/OracleRef.sol";
7 import "../../Constants.sol";
8 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
9 
10 /// @title implementation for an ERC20 Reserve Stabilizer
11 /// @author Fei Protocol
12 contract ReserveStabilizer is OracleRef, IReserveStabilizer, PCVDeposit {
13     using Decimal for Decimal.D256;
14 
15     /// @notice the USD per FEI exchange rate denominated in basis points (1/10000)
16     uint256 public override usdPerFeiBasisPoints;
17 
18     /// @notice the ERC20 token exchanged on this stablizer
19     IERC20 public token;
20 
21     /// @notice ERC20 Reserve Stabilizer constructor
22     /// @param _core Fei Core to reference
23     /// @param _oracle the price oracle to reference
24     /// @param _backupOracle the backup oracle to reference
25     /// @param _token the ERC20 token for this stabilizer, 0x0 if TRIBE or ETH
26     /// @param _usdPerFeiBasisPoints the USD price per FEI to sell tokens at
27     constructor(
28         address _core,
29         address _oracle,
30         address _backupOracle,
31         IERC20 _token,
32         uint256 _usdPerFeiBasisPoints
33     )
34         OracleRef(
35             _core,
36             _oracle,
37             _backupOracle,
38             0, // default to zero for ETH and TRIBE which both have 18 decimals
39             true // invert the price oracle, as the operation performed here needs to convert FEI into underlying
40         )
41     {
42         require(
43             _usdPerFeiBasisPoints <= Constants.BASIS_POINTS_GRANULARITY,
44             "ReserveStabilizer: Exceeds bp granularity"
45         );
46         usdPerFeiBasisPoints = _usdPerFeiBasisPoints;
47         emit UsdPerFeiRateUpdate(0, _usdPerFeiBasisPoints);
48 
49         token = _token;
50 
51         if (address(_token) != address(0)) {
52             _setDecimalsNormalizerFromToken(address(_token));
53         }
54     }
55 
56     /// @notice exchange FEI for tokens from the reserves
57     /// @param feiAmount of FEI to sell
58     function exchangeFei(uint256 feiAmount) public virtual override whenNotPaused returns (uint256 amountOut) {
59         updateOracle();
60 
61         fei().transferFrom(msg.sender, address(this), feiAmount);
62         _burnFeiHeld();
63 
64         amountOut = getAmountOut(feiAmount);
65 
66         _transfer(msg.sender, amountOut);
67         emit FeiExchange(msg.sender, feiAmount, amountOut);
68     }
69 
70     /// @notice returns the amount out of tokens from the reserves for a given amount of FEI
71     /// @param amountFeiIn the amount of FEI in
72     function getAmountOut(uint256 amountFeiIn) public view override returns (uint256) {
73         uint256 adjustedAmountIn = (amountFeiIn * usdPerFeiBasisPoints) / Constants.BASIS_POINTS_GRANULARITY;
74         return readOracle().mul(adjustedAmountIn).asUint256();
75     }
76 
77     /// @notice withdraw tokens from the reserves
78     /// @param to address to send tokens
79     /// @param amountOut amount of tokens to send
80     function withdraw(address to, uint256 amountOut) external virtual override onlyPCVController {
81         _transfer(to, amountOut);
82         emit Withdrawal(msg.sender, to, amountOut);
83     }
84 
85     /// @notice new PCV deposited to the stabilizer
86     /// @dev no-op because the token transfer already happened
87     function deposit() external virtual override {}
88 
89     /// @notice returns the amount of the held ERC-20
90     function balance() public view virtual override returns (uint256) {
91         return token.balanceOf(address(this));
92     }
93 
94     /// @notice display the related token of the balance reported
95     function balanceReportedIn() public view override returns (address) {
96         return address(token);
97     }
98 
99     /// @notice sets the USD per FEI exchange rate rate
100     /// @param newUsdPerFeiBasisPoints the USD per FEI exchange rate denominated in basis points (1/10000)
101     function setUsdPerFeiRate(uint256 newUsdPerFeiBasisPoints) external override onlyGovernorOrAdmin {
102         require(
103             newUsdPerFeiBasisPoints <= Constants.BASIS_POINTS_GRANULARITY,
104             "ReserveStabilizer: Exceeds bp granularity"
105         );
106         uint256 oldUsdPerFeiBasisPoints = usdPerFeiBasisPoints;
107         usdPerFeiBasisPoints = newUsdPerFeiBasisPoints;
108         emit UsdPerFeiRateUpdate(oldUsdPerFeiBasisPoints, newUsdPerFeiBasisPoints);
109     }
110 
111     function _transfer(address to, uint256 amount) internal virtual {
112         SafeERC20.safeTransfer(IERC20(token), to, amount);
113     }
114 }
