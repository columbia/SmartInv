1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity 0.7.6;
3 
4 import {IVisorService} from "../interfaces/IVisorService.sol";
5 
6 contract MockVisorService is IVisorService {
7 
8   event SubscriberTokensReceived(address token, address operator, address from, address to, uint256 amount);
9  
10   constructor() {}
11 
12   function subscriberTokensReceived(
13         address token,
14         address operator,
15         address from,
16         address to,
17         uint256 amount,
18         bytes calldata userData,
19         bytes calldata operatorData
20     ) external override {
21       emit SubscriberTokensReceived(token, operator, from, to, amount); 
22     } 
23 }
