1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {IConvenience} from '../interfaces/IConvenience.sol';
5 import {IPair} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IPair.sol';
6 import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
7 import {Strings} from '@openzeppelin/contracts/utils/Strings.sol';
8 import {DeployLiquidity} from './DeployLiquidity.sol';
9 import {DeployBonds} from './DeployBonds.sol';
10 import {DeployInsurances} from './DeployInsurances.sol';
11 import {DeployCollateralizedDebt} from './DeployCollateralizedDebt.sol';
12 
13 library Deploy {
14     using Strings for uint256;
15     using DeployLiquidity for IConvenience.Native;
16     using DeployBonds for IConvenience.Native;
17     using DeployInsurances for IConvenience.Native;
18     using DeployCollateralizedDebt for IConvenience.Native;
19 
20     /// @dev Emits when the new natives are deployed.
21     /// @param asset The address of the asset ERC20 contract.
22     /// @param collateral The address of the collateral ERC20 contract.
23     /// @param maturity The unix timestamp maturity of the Pool.
24     /// @param native The native ERC20 and ERC721 contracts deployed.
25     event DeployNatives(IERC20 indexed asset, IERC20 indexed collateral, uint256 maturity, IConvenience.Native native);
26 
27     function deploy(
28         IConvenience.Native storage native,
29         IConvenience convenience,
30         IPair pair,
31         IERC20 asset,
32         IERC20 collateral,
33         uint256 maturity
34     ) internal {
35         bytes32 salt = keccak256(abi.encode(asset, collateral, maturity.toString()));
36         native.deployLiquidity(salt, convenience, pair, maturity);
37         native.deployBonds(salt, convenience, pair, maturity);
38         native.deployInsurances(salt, convenience, pair, maturity);
39         native.deployCollateralizedDebt(salt, convenience, pair, maturity);
40         emit DeployNatives(asset, collateral, maturity, native);
41     }
42 }
