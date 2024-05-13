1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 import "./IERC20.sol";
6 import "../../math/SafeMath.sol";
7 import "../../utils/Address.sol";
8 
9 /**
10  * @title SafeERC20
11  * @dev Wrappers around ERC20 operations that throw on failure (when the token
12  * contract returns false). Tokens that return no value (and instead revert or
13  * throw on failure) are also supported, non-reverting calls are assumed to be
14  * successful.
15  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
16  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
17  */
18 library SafeERC20 {
19     using SafeMath for uint256;
20     using Address for address;
21 
22     function safeTransfer(IERC20 token, address to, uint256 value) internal {
23         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
24     }
25 
26     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
27         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
28     }
29 
30     /**
31      * @dev Deprecated. This function has issues similar to the ones found in
32      * {IERC20-approve}, and its usage is discouraged.
33      *
34      * Whenever possible, use {safeIncreaseAllowance} and
35      * {safeDecreaseAllowance} instead.
36      */
37     function safeApprove(IERC20 token, address spender, uint256 value) internal {
38         // safeApprove should only be called when setting an initial allowance,
39         // or when resetting it to zero. To increase and decrease it, use
40         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
41         // solhint-disable-next-line max-line-length
42         require((value == 0) || (token.allowance(address(this), spender) == 0),
43             "SafeERC20: approve from non-zero to non-zero allowance"
44         );
45         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
46     }
47 
48     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
49         uint256 newAllowance = token.allowance(address(this), spender).add(value);
50         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
51     }
52 
53     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
54         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
55         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
56     }
57 
58     /**
59      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
60      * on the return value: the return value is optional (but if data is returned, it must not be false).
61      * @param token The token targeted by the call.
62      * @param data The call data (encoded using abi.encode or one of its variants).
63      */
64     function _callOptionalReturn(IERC20 token, bytes memory data) private {
65         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
66         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
67         // the target address contains contract code and also asserts for success in the low-level call.
68 
69         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
70         if (returndata.length > 0) { // Return data is optional
71             // solhint-disable-next-line max-line-length
72             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
73         }
74     }
75 }