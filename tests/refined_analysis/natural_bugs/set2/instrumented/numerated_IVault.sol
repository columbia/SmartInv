1 //SPDX-License-Identifier: Unlicense
2 
3 pragma solidity 0.6.12;
4 
5 interface IVault {
6     function underlyingBalanceInVault() external view returns (uint256);
7     function underlyingBalanceWithInvestment() external view returns (uint256);
8 
9     // function store() external view returns (address);
10     function underlying() external view returns (address);
11     function strategy() external view returns (address);
12 
13     function setStrategy(address _strategy) external;
14     function announceStrategyUpdate(address _strategy) external;
15     function setVaultFractionToInvest(uint256 numerator, uint256 denominator) external;
16 
17     function deposit(uint256 amountWei) external;
18     function depositFor(uint256 amountWei, address holder) external;
19 
20     function withdrawAll() external;
21     function withdraw(uint256 numberOfShares) external;
22     function getPricePerFullShare() external view returns (uint256);
23 
24     function underlyingBalanceWithInvestmentForHolder(address holder) view external returns (uint256);
25 
26     // hard work should be callable only by the controller (by the hard worker) or by governance
27     function doHardWork() external;
28 }
