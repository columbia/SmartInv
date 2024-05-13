1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.8.17;
3 
4 import { LibAsset } from "../Libraries/LibAsset.sol";
5 import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
6 
7 /// External wrapper interface
8 interface IWrapper {
9     function deposit() external payable;
10 
11     function withdraw(uint wad) external;
12 }
13 
14 /// @title TokenWrapper
15 /// @author LI.FI (https://li.fi)
16 /// @notice Provides functionality for wrapping and unwrapping tokens
17 /// @custom:version 1.0.0
18 contract TokenWrapper {
19     uint256 private constant MAX_INT = 2 ** 256 - 1;
20     address public wrappedToken;
21 
22     /// Errors ///
23     error WithdrawFailure();
24 
25     /// Constructor ///
26     // solhint-disable-next-line no-empty-blocks
27     constructor(address _wrappedToken) {
28         wrappedToken = _wrappedToken;
29         IERC20(wrappedToken).approve(address(this), MAX_INT);
30     }
31 
32     /// External Methods ///
33 
34     /// @notice Wraps the native token
35     function deposit() external payable {
36         IWrapper(wrappedToken).deposit{ value: msg.value }();
37         IERC20(wrappedToken).transfer(msg.sender, msg.value);
38     }
39 
40     /// @notice Unwraps all the caller's balance of wrapped token
41     function withdraw() external {
42         // While in a general purpose contract it would make sense
43         // to have `wad` equal to the minimum between the balance and the
44         // given allowance, in our specific usecase allowance is always
45         // nearly MAX_UINT256. Using the balance only is a gas optimisation.
46         uint256 wad = IERC20(wrappedToken).balanceOf(msg.sender);
47         IERC20(wrappedToken).transferFrom(msg.sender, address(this), wad);
48         IWrapper(wrappedToken).withdraw(wad);
49         (bool success, ) = payable(msg.sender).call{ value: wad }("");
50         if (!success) {
51             revert WithdrawFailure();
52         }
53     }
54 
55     // Needs to be able to receive native on `withdraw`
56     receive() external payable {}
57 }
