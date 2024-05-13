1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../IPCVDeposit.sol";
5 import "../../refs/CoreRef.sol";
6 
7 /// @title a contract to skim excess FEI from addresses
8 /// @author Fei Protocol
9 contract FeiSkimmer is CoreRef {
10     event ThresholdUpdate(uint256 newThreshold);
11     event SourceUpdate(address newSource);
12 
13     /// @notice source PCV deposit to skim excess FEI from
14     IPCVDeposit public source;
15 
16     /// @notice the threshold of FEI above which to skim
17     uint256 public threshold;
18 
19     /// @notice FEI Skimmer
20     /// @param _core Fei Core for reference
21     /// @param _source the target to skim from
22     /// @param _threshold the threshold of FEI to be maintained by source
23     constructor(
24         address _core,
25         IPCVDeposit _source,
26         uint256 _threshold
27     ) CoreRef(_core) {
28         source = _source;
29         threshold = _threshold;
30         _setContractAdminRole(keccak256("PCV_MINOR_PARAM_ROLE"));
31         emit ThresholdUpdate(threshold);
32     }
33 
34     /// @return true if FEI balance of source exceeds threshold
35     function skimEligible() external view returns (bool) {
36         return fei().balanceOf(address(source)) > threshold;
37     }
38 
39     /// @notice skim FEI above the threshold from the source. Pausable. Requires skimEligible()
40     function skim() external whenNotPaused {
41         IFei _fei = fei();
42         uint256 feiTotal = _fei.balanceOf(address(source));
43 
44         require(feiTotal > threshold, "under threshold");
45 
46         uint256 burnAmount = feiTotal - threshold;
47         source.withdrawERC20(address(_fei), address(this), burnAmount);
48 
49         _fei.burn(burnAmount);
50     }
51 
52     /// @notice set the threshold for FEI skims. Only Governor or Admin
53     /// @param newThreshold the new value above which FEI is skimmed.
54     function setThreshold(uint256 newThreshold) external onlyGovernorOrAdmin {
55         threshold = newThreshold;
56         emit ThresholdUpdate(newThreshold);
57     }
58 
59     /// @notice Set the target to skim from. Only Governor
60     /// @param newSource the new source to skim from
61     function setSource(address newSource) external onlyGovernor {
62         source = IPCVDeposit(newSource);
63         emit SourceUpdate(newSource);
64     }
65 }
