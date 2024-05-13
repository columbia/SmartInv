1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.7.6;
4 pragma experimental ABIEncoderV2;
5 
6 import {LibUnripe, SafeMath, AppStorage} from "contracts/libraries/LibUnripe.sol";
7 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
8 import {IBean} from "contracts/interfaces/IBean.sol";
9 import {LibAppStorage} from "./LibAppStorage.sol";
10 
11 /**
12  * @title LibChop
13  * @author deadmanwalking
14  */
15 library LibChop {
16     using SafeMath for uint256;
17 
18     /**
19      * @notice Chops an Unripe Token into its Ripe Token.
20      * @dev The output amount is based on the % of Sprouts that are Rinsable or Rinsed
21      * and the % of Fertilizer that has been bought.
22      * @param unripeToken The address of the Unripe Token to be Chopped.
23      * @param amount The amount of the of the Unripe Token to be Chopped.
24      * @return underlyingToken The address of Ripe Tokens received after the Chop.
25      * @return underlyingAmount The amount of Ripe Tokens received after the Chop.
26      */
27     function chop(
28         address unripeToken,
29         uint256 amount,
30         uint256 supply
31     ) internal returns (address underlyingToken, uint256 underlyingAmount) {
32         AppStorage storage s = LibAppStorage.diamondStorage();
33         underlyingAmount = LibUnripe._getPenalizedUnderlying(unripeToken, amount, supply);
34         LibUnripe.decrementUnderlying(unripeToken, underlyingAmount);
35         underlyingToken = s.u[unripeToken].underlyingToken;
36     }
37 }
