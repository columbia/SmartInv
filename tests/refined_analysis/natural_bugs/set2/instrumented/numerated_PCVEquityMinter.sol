1 pragma solidity ^0.8.0;
2 
3 import "./FeiTimedMinter.sol";
4 import "./IPCVEquityMinter.sol";
5 import "../../Constants.sol";
6 import "../../pcv/IPCVSwapper.sol";
7 import "@openzeppelin/contracts/utils/math/SafeCast.sol";
8 
9 /// @title PCVEquityMinter
10 /// @notice A FeiTimedMinter that mints based on a percentage of PCV equity
11 contract PCVEquityMinter is IPCVEquityMinter, FeiTimedMinter {
12     using SafeCast for int256;
13 
14     /// @notice The maximum percentage of PCV equity to be minted per year, in basis points
15     uint256 public immutable override MAX_APR_BASIS_POINTS;
16 
17     /// @notice the collateralization oracle used to determine PCV equity
18     ICollateralizationOracle public override collateralizationOracle;
19 
20     /// @notice the APR paid out from pcv equity per year expressed in basis points
21     uint256 public override aprBasisPoints;
22 
23     /**
24         @notice constructor for PCVEquityMinter
25         @param _core the Core address to reference
26         @param _target the target to receive minted FEI
27         @param _incentive the incentive amount for calling buy paid in FEI
28         @param _frequency the frequency buybacks happen
29         @param _collateralizationOracle the collateralization oracle used for PCV equity calculations
30         @param _aprBasisPoints the APR paid out from pcv equity per year expressed in basis points
31     */
32     constructor(
33         address _core,
34         address _target,
35         uint256 _incentive,
36         uint256 _frequency,
37         ICollateralizationOracle _collateralizationOracle,
38         uint256 _aprBasisPoints,
39         uint256 _maxAPRBasisPoints,
40         uint256 _feiMintingLimitPerSecond
41     ) FeiTimedMinter(_core, _target, _incentive, _frequency, _feiMintingLimitPerSecond * _frequency) {
42         _setCollateralizationOracle(_collateralizationOracle);
43         _setAPRBasisPoints(_aprBasisPoints);
44 
45         MAX_APR_BASIS_POINTS = _maxAPRBasisPoints;
46 
47         // Set flag to allow equity minter to mint some value up to the cap if the cap is reached
48         doPartialAction = true;
49     }
50 
51     /// @notice triggers a minting of FEI based on the PCV equity
52     function mint() public override {
53         collateralizationOracle.update();
54         super.mint();
55     }
56 
57     function mintAmount() public view override returns (uint256) {
58         (, , int256 equity, bool valid) = collateralizationOracle.pcvStats();
59 
60         require(equity > 0, "PCVEquityMinter: Equity is nonpositive");
61         require(valid, "PCVEquityMinter: invalid CR oracle");
62 
63         // return total equity scaled proportionally by the APR and the ratio of the mint frequency to the entire year
64         return
65             (((equity.toUint256() * aprBasisPoints) / Constants.BASIS_POINTS_GRANULARITY) * duration) /
66             Constants.ONE_YEAR;
67     }
68 
69     /// @notice set the collateralization oracle
70     function setCollateralizationOracle(ICollateralizationOracle newCollateralizationOracle)
71         external
72         override
73         onlyGovernor
74     {
75         _setCollateralizationOracle(newCollateralizationOracle);
76     }
77 
78     /// @notice sets the new APR for determining buyback size from PCV equity
79     function setAPRBasisPoints(uint256 newAprBasisPoints) external override onlyGovernorOrAdmin {
80         require(newAprBasisPoints <= MAX_APR_BASIS_POINTS, "PCVEquityMinter: APR above max");
81         _setAPRBasisPoints(newAprBasisPoints);
82     }
83 
84     function _setAPRBasisPoints(uint256 newAprBasisPoints) internal {
85         require(newAprBasisPoints != 0, "PCVEquityMinter: zero APR");
86 
87         uint256 oldAprBasisPoints = aprBasisPoints;
88         aprBasisPoints = newAprBasisPoints;
89         emit APRUpdate(oldAprBasisPoints, newAprBasisPoints);
90     }
91 
92     function _setCollateralizationOracle(ICollateralizationOracle newCollateralizationOracle) internal {
93         require(address(newCollateralizationOracle) != address(0), "PCVEquityMinter: zero address");
94         address oldCollateralizationOracle = address(collateralizationOracle);
95         collateralizationOracle = newCollateralizationOracle;
96         emit CollateralizationOracleUpdate(address(oldCollateralizationOracle), address(newCollateralizationOracle));
97     }
98 
99     function _afterMint() internal override {
100         IPCVSwapper(target).swap();
101     }
102 }
