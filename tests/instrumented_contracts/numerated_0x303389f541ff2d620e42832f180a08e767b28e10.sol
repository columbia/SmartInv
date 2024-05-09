1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.17;
4 pragma abicoder v1;
5 
6 /// @title A helper contract to manage nonce with the series
7 contract SeriesNonceManager {
8     error AdvanceNonceFailed();
9     event NonceIncreased(address indexed maker, uint256 series, uint256 newNonce);
10 
11     // {
12     //    1: {
13     //        '0x762f73Ad...842Ffa8': 0,
14     //        '0xd20c41ee...32aaDe2': 1
15     //    },
16     //    2: {
17     //        '0x762f73Ad...842Ffa8': 3,
18     //        '0xd20c41ee...32aaDe2': 15
19     //    },
20     //    ...
21     // }
22     mapping(uint256 => mapping(address => uint256)) public nonce;
23 
24     /// @notice Advances nonce by one
25     function increaseNonce(uint8 series) external {
26         advanceNonce(series, 1);
27     }
28 
29     /// @notice Advances nonce by specified amount
30     function advanceNonce(uint256 series, uint256 amount) public {
31         if (amount == 0 || amount > 255) revert AdvanceNonceFailed();
32         unchecked {
33             uint256 newNonce = nonce[series][msg.sender] + amount;
34             nonce[series][msg.sender] = newNonce;
35             emit NonceIncreased(msg.sender, series, newNonce);
36         }
37     }
38 
39     /// @notice Checks if `makerAddress` has specified `makerNonce` for `series`
40     /// @return Result True if `makerAddress` has specified nonce. Otherwise, false
41     function nonceEquals(uint256 series, address makerAddress, uint256 makerNonce) public view returns(bool) {
42         return nonce[series][makerAddress] == makerNonce;
43     }
44 
45     /// @notice Checks passed time against block timestamp
46     /// @return Result True if current block timestamp is lower than `time`. Otherwise, false
47     function timestampBelow(uint256 time) public view returns(bool) {
48         return block.timestamp < time;  // solhint-disable-line not-rely-on-time
49     }
50 
51     function timestampBelowAndNonceEquals(uint256 timeNonceSeriesAccount) public view returns(bool) {
52         uint256 _time = uint40(timeNonceSeriesAccount >> 216);
53         uint256 _nonce = uint40(timeNonceSeriesAccount >> 176);
54         uint256 _series = uint16(timeNonceSeriesAccount >> 160);
55         address _account = address(uint160(timeNonceSeriesAccount));
56         return timestampBelow(_time) && nonceEquals(_series, _account, _nonce);
57     }
58 }