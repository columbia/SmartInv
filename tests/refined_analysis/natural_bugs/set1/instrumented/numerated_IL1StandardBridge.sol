1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.17;
3 
4 interface IL1StandardBridge {
5     /// @notice Deposit an amount of ETH to a recipient's balance on L2.
6     /// @param _to L2 address to credit the withdrawal to.
7     /// @param _l2Gas Gas limit required to complete the deposit on L2.
8     /// @param _data Optional data to forward to L2. This data is provided
9     ///        solely as a convenience for external contracts. Aside from enforcing a maximum
10     ///        length, these contracts provide no guarantees about its content.
11     function depositETHTo(
12         address _to,
13         uint32 _l2Gas,
14         bytes calldata _data
15     ) external payable;
16 
17     /// @notice Deposit an amount of the ERC20 to the caller's balance on L2.
18     /// @param _l1Token Address of the L1 ERC20 we are depositing
19     /// @param _l2Token Address of the L1 respective L2 ERC20
20     /// @param _to L2 address to credit the withdrawal to.
21     /// @param _amount Amount of the ERC20 to deposit
22     /// @param _l2Gas Gas limit required to complete the deposit on L2.
23     /// @param _data Optional data to forward to L2. This data is provided
24     ///        solely as a convenience for external contracts. Aside from enforcing a maximum
25     ///        length, these contracts provide no guarantees about its content.
26     function depositERC20To(
27         address _l1Token,
28         address _l2Token,
29         address _to,
30         uint256 _amount,
31         uint32 _l2Gas,
32         bytes calldata _data
33     ) external;
34 
35     /// @notice Deposit an amount of the ERC20 to the caller's balance on L2.
36     /// @dev This function is implemented on SynthetixBridgeToOptimism contract.
37     /// @param _to L2 address to credit the withdrawal to.
38     /// @param _amount Amount of the ERC20 to deposit
39     function depositTo(address _to, uint256 _amount) external;
40 }
