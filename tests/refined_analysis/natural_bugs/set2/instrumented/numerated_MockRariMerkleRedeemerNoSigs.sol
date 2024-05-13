1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity =0.8.15;
3 
4 import "../shutdown/fuse/RariMerkleRedeemer.sol";
5 
6 contract MockRariMerkleRedeemerNoSigs is RariMerkleRedeemer {
7     constructor(
8         address token,
9         address[] memory cTokens,
10         uint256[] memory rates,
11         bytes32[] memory roots
12     ) RariMerkleRedeemer(token, cTokens, rates, roots) {}
13 
14     // User provides signature, which is checked against their address and the string constant "message"
15     function _sign(bytes calldata _signature) internal override {
16         // check: ensure that the user hasn't yet signed
17         // note: you can't directly compare bytes storage ref's to each other, but you can keccak the empty bytes
18         // such as the one from address zero, and compare this with the keccak'd other bytes; msg.sender *cannot* be the zero address
19         require(
20             keccak256(userSignatures[msg.sender]) == keccak256(userSignatures[address(0)]),
21             "User has already signed"
22         );
23 
24         // check: to ensure the signature is a valid signature for the constant message string from msg.sender
25         // @todo - do we want to use this, which supports ERC1271, or *just* EOA signatures?
26         // @dev signature check *reomved* for testing
27         //require(SignatureChecker.isValidSignatureNow(msg.sender, MESSAGE_HASH, _signature), "Signature not valid.");
28 
29         // effect: update user's stored signature
30         userSignatures[msg.sender] = _signature;
31     }
32 }
