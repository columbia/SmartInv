1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0;
4 
5 import '../interfaces/IBEP20.sol';
6 import '../libraries/SafeMath.sol';
7 import '../libraries/Address.sol';
8 
9 /**
10  * @title SafeBEP20
11  * @dev Wrappers around BEP20 operations that throw on failure (when the token
12  * contract returns false). Tokens that return no value (and instead revert or
13  * throw on failure) are also supported, non-reverting calls are assumed to be
14  * successful.
15  * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
16  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
17  */
18 library SafeBEP20 {
19     using SafeMath for uint256;
20     using Address for address;
21 
22     function safeTransfer(
23         IBEP20 token,
24         address to,
25         uint256 value
26     ) internal {
27         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
28     }
29 
30     function safeTransferFrom(
31         IBEP20 token,
32         address from,
33         address to,
34         uint256 value
35     ) internal {
36         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
37     }
38 
39     /**
40      * @dev Deprecated. This function has issues similar to the ones found in
41      * {IBEP20-approve}, and its usage is discouraged.
42      *
43      * Whenever possible, use {safeIncreaseAllowance} and
44      * {safeDecreaseAllowance} instead.
45      */
46     function safeApprove(
47         IBEP20 token,
48         address spender,
49         uint256 value
50     ) internal {
51         // safeApprove should only be called when setting an initial allowance,
52         // or when resetting it to zero. To increase and decrease it, use
53         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
54         // solhint-disable-next-line max-line-length
55         require(
56             (value == 0) || (token.allowance(address(this), spender) == 0),
57             'SafeBEP20: approve from non-zero to non-zero allowance'
58         );
59         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
60     }
61 
62     function safeIncreaseAllowance(
63         IBEP20 token,
64         address spender,
65         uint256 value
66     ) internal {
67         uint256 newAllowance = token.allowance(address(this), spender).add(value);
68         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
69     }
70 
71     function safeDecreaseAllowance(
72         IBEP20 token,
73         address spender,
74         uint256 value
75     ) internal {
76         uint256 newAllowance = token.allowance(address(this), spender).sub(
77             value,
78             'SafeBEP20: decreased allowance below zero'
79         );
80         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
81     }
82 
83     /**
84      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
85      * on the return value: the return value is optional (but if data is returned, it must not be false).
86      * @param token The token targeted by the call.
87      * @param data The call data (encoded using abi.encode or one of its variants).
88      */
89     function _callOptionalReturn(IBEP20 token, bytes memory data) private {
90         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
91         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
92         // the target address contains contract code and also asserts for success in the low-level call.
93 
94         bytes memory returndata = address(token).functionCall(data, 'SafeBEP20: low-level call failed');
95         if (returndata.length > 0) {
96             // Return data is optional
97             // solhint-disable-next-line max-line-length
98             require(abi.decode(returndata, (bool)), 'SafeBEP20: BEP20 operation did not succeed');
99         }
100     }
101 }
