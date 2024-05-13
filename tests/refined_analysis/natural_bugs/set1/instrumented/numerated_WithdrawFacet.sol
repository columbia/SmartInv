1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { LibDiamond } from "../Libraries/LibDiamond.sol";
5 import { LibUtil } from "../Libraries/LibUtil.sol";
6 import { LibAsset } from "../Libraries/LibAsset.sol";
7 import { LibAccess } from "../Libraries/LibAccess.sol";
8 import { NotAContract } from "../Errors/GenericErrors.sol";
9 
10 /// @title Withdraw Facet
11 /// @author LI.FI (https://li.fi)
12 /// @notice Allows admin to withdraw funds that are kept in the contract by accident
13 /// @custom:version 1.0.0
14 contract WithdrawFacet {
15     /// Errors ///
16 
17     error WithdrawFailed();
18 
19     /// Events ///
20 
21     event LogWithdraw(
22         address indexed _assetAddress,
23         address _to,
24         uint256 amount
25     );
26 
27     /// External Methods ///
28 
29     /// @notice Execute call data and withdraw asset.
30     /// @param _callTo The address to execute the calldata on.
31     /// @param _callData The data to execute.
32     /// @param _assetAddress Asset to be withdrawn.
33     /// @param _to address to withdraw to.
34     /// @param _amount amount of asset to withdraw.
35     function executeCallAndWithdraw(
36         address payable _callTo,
37         bytes calldata _callData,
38         address _assetAddress,
39         address _to,
40         uint256 _amount
41     ) external {
42         if (msg.sender != LibDiamond.contractOwner()) {
43             LibAccess.enforceAccessControl();
44         }
45 
46         // Check if the _callTo is a contract
47         bool success;
48         bool isContract = LibAsset.isContract(_callTo);
49         if (!isContract) revert NotAContract();
50 
51         // solhint-disable-next-line avoid-low-level-calls
52         (success, ) = _callTo.call(_callData);
53 
54         if (success) {
55             _withdrawAsset(_assetAddress, _to, _amount);
56         } else {
57             revert WithdrawFailed();
58         }
59     }
60 
61     /// @notice Withdraw asset.
62     /// @param _assetAddress Asset to be withdrawn.
63     /// @param _to address to withdraw to.
64     /// @param _amount amount of asset to withdraw.
65     function withdraw(
66         address _assetAddress,
67         address _to,
68         uint256 _amount
69     ) external {
70         if (msg.sender != LibDiamond.contractOwner()) {
71             LibAccess.enforceAccessControl();
72         }
73         _withdrawAsset(_assetAddress, _to, _amount);
74     }
75 
76     /// Internal Methods ///
77 
78     /// @notice Withdraw asset.
79     /// @param _assetAddress Asset to be withdrawn.
80     /// @param _to address to withdraw to.
81     /// @param _amount amount of asset to withdraw.
82     function _withdrawAsset(
83         address _assetAddress,
84         address _to,
85         uint256 _amount
86     ) internal {
87         address sendTo = (LibUtil.isZeroAddress(_to)) ? msg.sender : _to;
88         LibAsset.transferAsset(_assetAddress, payable(sendTo), _amount);
89         emit LogWithdraw(_assetAddress, sendTo, _amount);
90     }
91 }
