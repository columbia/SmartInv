1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 /**
5  * @dev This is an empty interface used to represent either ERC20-conforming token contracts or ETH (using the zero
6  * address sentinel value). We're just relying on the fact that `interface` can be used to declare new address-like
7  * types.
8  *
9  * This concept is unrelated to a Pool's Asset Managers.
10  */
11 interface IAsset {
12     // solhint-disable-previous-line no-empty-blocks
13 }