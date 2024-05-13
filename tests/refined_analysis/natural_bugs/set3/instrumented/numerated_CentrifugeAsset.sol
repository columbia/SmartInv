1 // SPDX-License-Identifier: LGPL-3.0-only
2 pragma solidity 0.8.11;
3 pragma experimental ABIEncoderV2;
4 
5 /**
6     @title Represents a bridged Centrifuge asset.
7     @author ChainSafe Systems.
8  */
9 contract CentrifugeAsset {
10   mapping (bytes32 => bool) public _assetsStored;
11 
12   event AssetStored(bytes32 indexed asset);
13 
14   /**
15     @notice Marks {asset} as stored.
16     @param asset Hash of asset deposited on Centrifuge chain.
17     @notice {asset} must not have already been stored.
18     @notice Emits {AssetStored} event.
19    */
20   function store(bytes32 asset) external {
21       require(!_assetsStored[asset], "asset is already stored");
22 
23       _assetsStored[asset] = true;
24       emit AssetStored(asset);
25   }
26 }