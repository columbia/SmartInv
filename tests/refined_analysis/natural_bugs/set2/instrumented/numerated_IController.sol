1 //SPDX-License-Identifier: Unlicense
2 
3 pragma solidity 0.6.12;
4 
5 interface IController {
6     // [Grey list]
7     // An EOA can safely interact with the system no matter what.
8     // If you're using Metamask, you're using an EOA.
9     // Only smart contracts may be affected by this grey list.
10     //
11     // This contract will not be able to ban any EOA from the system
12     // even if an EOA is being added to the greyList, he/she will still be able
13     // to interact with the whole system as if nothing happened.
14     // Only smart contracts will be affected by being added to the greyList.
15     // This grey list is only used in Vault.sol, see the code there for reference
16     function greyList(address _target) external view returns(bool);
17 
18     function addVaultAndStrategy(address _vault, address _strategy) external;
19     function doHardWork(address _vault) external;
20     function hasVault(address _vault) external returns(bool);
21 
22     function salvage(address _token, uint256 amount) external;
23     function salvageStrategy(address _strategy, address _token, uint256 amount) external;
24 
25     function notifyFee(address _underlying, uint256 fee) external;
26     function profitSharingNumerator() external view returns (uint256);
27     function profitSharingDenominator() external view returns (uint256);
28 
29     function feeRewardForwarder() external view returns(address);
30     function setFeeRewardForwarder(address _value) external;
31 }
