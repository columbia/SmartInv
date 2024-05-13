1 pragma solidity ^0.8.0;
2 
3 import "../../refs/CoreRef.sol";
4 import "../../utils/Timed.sol";
5 import "../../utils/Incentivized.sol";
6 import "./RateLimitedMinter.sol";
7 import "./IFeiTimedMinter.sol";
8 
9 /// @title FeiTimedMinter
10 /// @notice a contract which mints FEI to a target address on a timed cadence
11 contract FeiTimedMinter is IFeiTimedMinter, CoreRef, Timed, Incentivized, RateLimitedMinter {
12     /// @notice most frequent that mints can happen
13     uint256 public constant override MIN_MINT_FREQUENCY = 1 hours; // Min 1 hour per mint
14 
15     /// @notice least frequent that mints can happen
16     uint256 public constant override MAX_MINT_FREQUENCY = 30 days; // Max 1 month per mint
17 
18     uint256 private _mintAmount;
19 
20     /// @notice the target receiving minted FEI
21     address public override target;
22 
23     /**
24         @notice constructor for FeiTimedMinter
25         @param _core the Core address to reference
26         @param _target the target for minted FEI
27         @param _incentive the incentive amount for calling mint paid in FEI
28         @param _frequency the frequency minting happens
29         @param _initialMintAmount the initial FEI amount to mint
30     */
31     constructor(
32         address _core,
33         address _target,
34         uint256 _incentive,
35         uint256 _frequency,
36         uint256 _initialMintAmount
37     )
38         CoreRef(_core)
39         Timed(_frequency)
40         Incentivized(_incentive)
41         RateLimitedMinter((_initialMintAmount + _incentive) / _frequency, (_initialMintAmount + _incentive), true)
42     {
43         _initTimed();
44 
45         _setTarget(_target);
46         _setMintAmount(_initialMintAmount);
47     }
48 
49     /// @notice triggers a minting of FEI
50     /// @dev timed and incentivized
51     function mint() public virtual override whenNotPaused afterTime {
52         /// Reset the timer
53         _initTimed();
54 
55         uint256 amount = mintAmount();
56 
57         // incentivizing before minting so if there is a partial mint it goes to target not caller
58         _incentivize();
59 
60         if (amount != 0) {
61             // Calls the overriden RateLimitedMinter _mintFei which includes the rate limiting logic
62             _mintFei(target, amount);
63 
64             emit FeiMinting(msg.sender, amount);
65         }
66         // After mint called whether a "mint" happens or not to allow incentivized target hooks
67         _afterMint();
68     }
69 
70     function mintAmount() public view virtual override returns (uint256) {
71         return _mintAmount;
72     }
73 
74     /// @notice set the new FEI target
75     function setTarget(address newTarget) external override onlyGovernor {
76         _setTarget(newTarget);
77     }
78 
79     /// @notice set the mint frequency
80     function setFrequency(uint256 newFrequency) external override onlyGovernorOrAdmin {
81         require(newFrequency >= MIN_MINT_FREQUENCY, "FeiTimedMinter: frequency low");
82         require(newFrequency <= MAX_MINT_FREQUENCY, "FeiTimedMinter: frequency high");
83 
84         _setDuration(newFrequency);
85     }
86 
87     function setMintAmount(uint256 newMintAmount) external override onlyGovernorOrAdmin {
88         _setMintAmount(newMintAmount);
89     }
90 
91     function _setTarget(address newTarget) internal {
92         require(newTarget != address(0), "FeiTimedMinter: zero address");
93         address oldTarget = target;
94         target = newTarget;
95         emit TargetUpdate(oldTarget, newTarget);
96     }
97 
98     function _setMintAmount(uint256 newMintAmount) internal {
99         uint256 oldMintAmount = _mintAmount;
100         _mintAmount = newMintAmount;
101         emit MintAmountUpdate(oldMintAmount, newMintAmount);
102     }
103 
104     function _mintFei(address to, uint256 amountIn) internal override(CoreRef, RateLimitedMinter) {
105         RateLimitedMinter._mintFei(to, amountIn);
106     }
107 
108     function _afterMint() internal virtual {}
109 }
