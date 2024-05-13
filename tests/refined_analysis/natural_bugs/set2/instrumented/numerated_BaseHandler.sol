1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "../../../../interfaces/actions/topup/ITopUpHandler.sol";
5 
6 abstract contract BaseHandler is ITopUpHandler {
7     /// @dev Handlers will be called through delegatecall from the topup action
8     /// so we add a gap to ensure that the children contracts do not
9     /// overwrite the topup action storage
10     uint256[100] private __gap;
11 }
