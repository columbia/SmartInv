1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.8.17;
3 import { InsufficientBalance, NullAddrIsNotAnERC20Token, NullAddrIsNotAValidSpender, NoTransferToNullAddress, InvalidAmount, NativeAssetTransferFailed } from "../Errors/GenericErrors.sol";
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
6 import { LibSwap } from "./LibSwap.sol";
7 
8 /// @title LibAsset
9 /// @notice This library contains helpers for dealing with onchain transfers
10 ///         of assets, including accounting for the native asset `assetId`
11 ///         conventions and any noncompliant ERC20 transfers
12 library LibAsset {
13     uint256 private constant MAX_UINT = type(uint256).max;
14 
15     address internal constant NULL_ADDRESS = address(0);
16 
17     /// @dev All native assets use the empty address for their asset id
18     ///      by convention
19 
20     address internal constant NATIVE_ASSETID = NULL_ADDRESS; //address(0)
21 
22     /// @notice Gets the balance of the inheriting contract for the given asset
23     /// @param assetId The asset identifier to get the balance of
24     /// @return Balance held by contracts using this library
25     function getOwnBalance(address assetId) internal view returns (uint256) {
26         return
27             isNativeAsset(assetId)
28                 ? address(this).balance
29                 : IERC20(assetId).balanceOf(address(this));
30     }
31 
32     /// @notice Transfers ether from the inheriting contract to a given
33     ///         recipient
34     /// @param recipient Address to send ether to
35     /// @param amount Amount to send to given recipient
36     function transferNativeAsset(
37         address payable recipient,
38         uint256 amount
39     ) private {
40         if (recipient == NULL_ADDRESS) revert NoTransferToNullAddress();
41         if (amount > address(this).balance)
42             revert InsufficientBalance(amount, address(this).balance);
43         // solhint-disable-next-line avoid-low-level-calls
44         (bool success, ) = recipient.call{ value: amount }("");
45         if (!success) revert NativeAssetTransferFailed();
46     }
47 
48     /// @notice If the current allowance is insufficient, the allowance for a given spender
49     /// is set to MAX_UINT.
50     /// @param assetId Token address to transfer
51     /// @param spender Address to give spend approval to
52     /// @param amount Amount to approve for spending
53     function maxApproveERC20(
54         IERC20 assetId,
55         address spender,
56         uint256 amount
57     ) internal {
58         if (isNativeAsset(address(assetId))) {
59             return;
60         }
61         if (spender == NULL_ADDRESS) {
62             revert NullAddrIsNotAValidSpender();
63         }
64 
65         if (assetId.allowance(address(this), spender) < amount) {
66             SafeERC20.safeApprove(IERC20(assetId), spender, 0);
67             SafeERC20.safeApprove(IERC20(assetId), spender, MAX_UINT);
68         }
69     }
70 
71     /// @notice Transfers tokens from the inheriting contract to a given
72     ///         recipient
73     /// @param assetId Token address to transfer
74     /// @param recipient Address to send token to
75     /// @param amount Amount to send to given recipient
76     function transferERC20(
77         address assetId,
78         address recipient,
79         uint256 amount
80     ) private {
81         if (isNativeAsset(assetId)) {
82             revert NullAddrIsNotAnERC20Token();
83         }
84         if (recipient == NULL_ADDRESS) {
85             revert NoTransferToNullAddress();
86         }
87 
88         uint256 assetBalance = IERC20(assetId).balanceOf(address(this));
89         if (amount > assetBalance) {
90             revert InsufficientBalance(amount, assetBalance);
91         }
92         SafeERC20.safeTransfer(IERC20(assetId), recipient, amount);
93     }
94 
95     /// @notice Transfers tokens from a sender to a given recipient
96     /// @param assetId Token address to transfer
97     /// @param from Address of sender/owner
98     /// @param to Address of recipient/spender
99     /// @param amount Amount to transfer from owner to spender
100     function transferFromERC20(
101         address assetId,
102         address from,
103         address to,
104         uint256 amount
105     ) internal {
106         if (isNativeAsset(assetId)) {
107             revert NullAddrIsNotAnERC20Token();
108         }
109         if (to == NULL_ADDRESS) {
110             revert NoTransferToNullAddress();
111         }
112 
113         IERC20 asset = IERC20(assetId);
114         uint256 prevBalance = asset.balanceOf(to);
115         SafeERC20.safeTransferFrom(asset, from, to, amount);
116         if (asset.balanceOf(to) - prevBalance != amount) {
117             revert InvalidAmount();
118         }
119     }
120 
121     function depositAsset(address assetId, uint256 amount) internal {
122         if (amount == 0) revert InvalidAmount();
123         if (isNativeAsset(assetId)) {
124             if (msg.value < amount) revert InvalidAmount();
125         } else {
126             uint256 balance = IERC20(assetId).balanceOf(msg.sender);
127             if (balance < amount) revert InsufficientBalance(amount, balance);
128             transferFromERC20(assetId, msg.sender, address(this), amount);
129         }
130     }
131 
132     function depositAssets(LibSwap.SwapData[] calldata swaps) internal {
133         for (uint256 i = 0; i < swaps.length; ) {
134             LibSwap.SwapData calldata swap = swaps[i];
135             if (swap.requiresDeposit) {
136                 depositAsset(swap.sendingAssetId, swap.fromAmount);
137             }
138             unchecked {
139                 i++;
140             }
141         }
142     }
143 
144     /// @notice Determines whether the given assetId is the native asset
145     /// @param assetId The asset identifier to evaluate
146     /// @return Boolean indicating if the asset is the native asset
147     function isNativeAsset(address assetId) internal pure returns (bool) {
148         return assetId == NATIVE_ASSETID;
149     }
150 
151     /// @notice Wrapper function to transfer a given asset (native or erc20) to
152     ///         some recipient. Should handle all non-compliant return value
153     ///         tokens as well by using the SafeERC20 contract by open zeppelin.
154     /// @param assetId Asset id for transfer (address(0) for native asset,
155     ///                token address for erc20s)
156     /// @param recipient Address to send asset to
157     /// @param amount Amount to send to given recipient
158     function transferAsset(
159         address assetId,
160         address payable recipient,
161         uint256 amount
162     ) internal {
163         isNativeAsset(assetId)
164             ? transferNativeAsset(recipient, amount)
165             : transferERC20(assetId, recipient, amount);
166     }
167 
168     /// @dev Checks whether the given address is a contract and contains code
169     function isContract(address _contractAddr) internal view returns (bool) {
170         uint256 size;
171         // solhint-disable-next-line no-inline-assembly
172         assembly {
173             size := extcodesize(_contractAddr)
174         }
175         return size > 0;
176     }
177 }
