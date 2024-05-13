1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IDeBridgeGate {
5     /// @param fixedNativeFee Transfer fixed fee.
6     /// @param isSupported Whether the chain for the asset is supported.
7     /// @param transferFeeBps Transfer fee rate nominated in basis points (1/10000)
8     ///                       of transferred amount.
9     struct ChainSupportInfo {
10         uint256 fixedNativeFee;
11         bool isSupported;
12         uint16 transferFeeBps;
13     }
14 
15     /// @dev Fallback fixed fee in native asset, used if a chain fixed fee is set to 0
16     function globalFixedNativeFee() external view returns (uint256);
17 
18     /// @dev Whether the chain for the asset is supported to send
19     function getChainToConfig(
20         uint256
21     ) external view returns (ChainSupportInfo memory);
22 
23     /// @dev This method is used for the transfer of assets.
24     ///      It locks an asset in the smart contract in the native chain
25     ///      and enables minting of deAsset on the secondary chain.
26     /// @param _tokenAddress Asset identifier.
27     /// @param _amount Amount to be transferred (note: the fee can be applied).
28     /// @param _chainIdTo Chain id of the target chain.
29     /// @param _receiver Receiver address.
30     /// @param _permit deadline + signature for approving the spender by signature.
31     /// @param _useAssetFee use assets fee for pay protocol fix (work only for specials token)
32     /// @param _referralCode Referral code
33     /// @param _autoParams Auto params for external call in target network
34     function send(
35         address _tokenAddress,
36         uint256 _amount,
37         uint256 _chainIdTo,
38         bytes memory _receiver,
39         bytes memory _permit,
40         bool _useAssetFee,
41         uint32 _referralCode,
42         bytes calldata _autoParams
43     ) external payable;
44 }
