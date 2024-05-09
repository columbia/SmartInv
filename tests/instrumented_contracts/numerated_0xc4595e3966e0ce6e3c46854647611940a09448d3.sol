1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 pragma experimental ABIEncoderV2;
4 
5 /*
6   Copyright 2021 Flashbots: Scott Bigelow (scott@flashbots.net).
7 */
8 
9 // This contract performs one or many staticcall's, compares their output, and pays
10 // the miner directly if all calls exactly match the specified result
11 // For how to use this script, read the Flashbots searcher docs: https://hackmd.io/@flashbots/ryxxWuD6D
12 contract FlashbotsCheckAndSend {
13     function check32BytesAndSend(address _target, bytes memory _payload, bytes32 _resultMatch) external payable {
14         _check32Bytes(_target, _payload, _resultMatch);
15         block.coinbase.transfer(msg.value);
16     }
17 
18     function check32BytesAndSendMulti(address[] memory _targets, bytes[] memory _payloads, bytes32[] memory _resultMatches) external payable {
19         require (_targets.length == _payloads.length);
20         require (_targets.length == _resultMatches.length);
21         for (uint256 i = 0; i < _targets.length; i++) {
22             _check32Bytes(_targets[i], _payloads[i], _resultMatches[i]);
23         }
24         block.coinbase.transfer(msg.value);
25     }
26 
27     function checkBytesAndSend(address _target, bytes memory _payload, bytes memory _resultMatch) external payable {
28         _checkBytes(_target, _payload, _resultMatch);
29         block.coinbase.transfer(msg.value);
30     }
31 
32     function checkBytesAndSendMulti(address[] memory _targets, bytes[] memory _payloads, bytes[] memory _resultMatches) external payable {
33         require (_targets.length == _payloads.length);
34         require (_targets.length == _resultMatches.length);
35         for (uint256 i = 0; i < _targets.length; i++) {
36             _checkBytes(_targets[i], _payloads[i], _resultMatches[i]);
37         }
38         block.coinbase.transfer(msg.value);
39     }
40 
41     // ======== INTERNAL ========
42     
43     function _check32Bytes(address _target, bytes memory _payload, bytes32 _resultMatch) internal view {
44         (bool _success, bytes memory _response) = _target.staticcall(_payload);
45         require(_success, "!success");
46         require(_response.length >= 32, "response less than 32 bytes");
47         bytes32 _responseScalar;
48         assembly {
49             _responseScalar := mload(add(_response, 0x20))
50         }
51         require(_responseScalar == _resultMatch, "response mismatch");
52     }
53 
54     function _checkBytes(address _target, bytes memory _payload, bytes memory _resultMatch) internal view {
55         (bool _success, bytes memory _response) = _target.staticcall(_payload);
56         require(_success, "!success");
57         require(keccak256(_resultMatch) == keccak256(_response), "response bytes mismatch");
58     }
59 }