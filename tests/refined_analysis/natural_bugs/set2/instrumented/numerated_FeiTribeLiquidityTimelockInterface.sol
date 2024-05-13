1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import {Decimal} from "../../external/Decimal.sol";
5 
6 /// @title Uniswap FEI TRIBE liquidity timelock interface
7 /// @author Fei Protocol
8 interface FeiTribeLiquidityTimelockInterface {
9     // ----------- Events -----------
10 
11     event Deploy(uint256 _amountFei, uint256 _amountTribe);
12 
13     // ----------- Read only API -------------
14     /// @notice Beneficiary of the linear timelock funds
15     function beneficiary() external returns (address);
16 
17     /// @notice Get the pending beneficiary
18     function pendingBeneficiary(address) external;
19 
20     /// @notice Get the amount of tokens unlocked and available for release
21     function availableForRelease() external;
22 
23     // ----------- Beneficiary state changing API  -------------
24     /// @notice Set the pending timelock beneficiary for it to later be accepted
25     function setPendingBeneficiary(address) external;
26 
27     /// @notice Accept the beneficiary, called by the beneficiary in setPendingBeneficiary
28     function acceptBeneficiary() external;
29 
30     /// @notice Release the maximum amount of unlocked tokens to an address
31     function releaseMax(address) external;
32 
33     /// @notice Release a specific amount of unlocked tokens to an address
34     function release(address, uint256) external;
35 
36     // ----------- Genesis Group only state changing API -----------
37 
38     /// @notice Add FEI/TRIBE liquidity to Uniswap at Genesis
39     function deploy(Decimal.D256 calldata feiRatio) external;
40 
41     /// @notice Swap Genesis group FEI on Uniswap for TRIBE
42     function swapFei(uint256 amountFei) external returns (uint256);
43 
44     // ----------- Governor only state changing API -----------
45 
46     /// @notice Unlock all liquidity vesting in the timelock to the beneficiary
47     function unlockLiquidity() external;
48 }
