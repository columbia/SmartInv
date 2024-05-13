1 pragma solidity ^0.5.0;
2 
3 import "./IERC20.sol";
4 import "../../math/SafeMath.sol";
5 import "../../utils/Utils.sol";
6 
7 /**
8  * @title SafeERC20
9  * @dev Wrappers around ERC20 operations that throw on failure (when the token
10  * contract returns false). Tokens that return no value (and instead revert or
11  * throw on failure) are also supported, non-reverting calls are assumed to be
12  * successful.
13  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
14  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
15  */
16 library SafeERC20 {
17     using SafeMath for uint256;
18 
19     function safeTransfer(IERC20 token, address to, uint256 value) internal {
20         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
21     }
22 
23     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
24         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
25     }
26 
27     function safeApprove(IERC20 token, address spender, uint256 value) internal {
28         // safeApprove should only be called when setting an initial allowance,
29         // or when resetting it to zero. To increase and decrease it, use
30         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
31         // solhint-disable-next-line max-line-length
32         require((value == 0) || (token.allowance(address(this), spender) == 0),
33             "SafeERC20: approve from non-zero to non-zero allowance"
34         );
35         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
36     }
37 
38     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
39         uint256 newAllowance = token.allowance(address(this), spender).add(value);
40         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
41     }
42 
43     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
44         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
45         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
46     }
47 
48     /**
49      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
50      * on the return value: the return value is optional (but if data is returned, it must not be false).
51      * @param token The token targeted by the call.
52      * @param data The call data (encoded using abi.encode or one of its variants).
53      */
54     function callOptionalReturn(IERC20 token, bytes memory data) private {
55         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
56         // we're implementing it ourselves.
57 
58         // A Solidity high level call has three parts:
59         //  1. The target address is checked to verify it contains contract code
60         //  2. The call itself is made, and success asserted
61         //  3. The return value is decoded, which in turn checks the size of the returned data.
62         // solhint-disable-next-line max-line-length
63         require(Utils.isContract(address(token)), "SafeERC20: call to non-contract");
64 
65         // solhint-disable-next-line avoid-low-level-calls
66         (bool success, bytes memory returndata) = address(token).call(data);
67         require(success, "SafeERC20: low-level call failed");
68 
69         if (returndata.length > 0) { // Return data is optional
70             // solhint-disable-next-line max-line-length
71             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
72         }
73     }
74 }