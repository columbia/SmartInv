1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.19;
3 
4 import { Strategies, Order } from "../carbon/Strategies.sol";
5 
6 contract TestStrategies is Strategies {
7     function tradeBySourceAmount(Order memory order, uint128 amount) external pure returns (uint128) {
8         return _singleTradeActionSourceAndTargetAmounts(order, amount, false).targetAmount;
9     }
10 
11     function tradeByTargetAmount(Order memory order, uint128 amount) external pure returns (uint128) {
12         return _singleTradeActionSourceAndTargetAmounts(order, amount, true).sourceAmount;
13     }
14 }
