1 // SPDX-License-Identifier: GPL-3.0-or-later
2 
3 pragma solidity ^0.8.6;
4 
5 // helper methods for interacting with ERC20 tokens
6 library TransferHelper {
7     function safeTransfer(address token, address to, uint value) internal {
8         // bytes4(keccak256(bytes('transfer(address,uint256)')));
9         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
10         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
11     }
12 
13     function safeTransferFrom(address token, address from, address to, uint value) internal {
14         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
15         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
16         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
17     }
18 }
19 
20 contract SwapTokens {
21     address public immutable srcToken;
22     address public immutable dstToken;
23 
24     // eg. if swap rate 1:100 (src:dst), then numeratorOfRate=100, denominatorOfRate=1
25     // eg. if swap rate 2:3 (src:dst), then numeratorOfRate=3, denominatorOfRate=2
26     uint256 public immutable numeratorOfRate;
27     uint256 public immutable denominatorOfRate;
28 
29     uint256 public latestWithdrawRequestTime;
30     uint256 public latestWithdrawRequestAmount;
31     uint256 public constant minWithdrawApprovalInterval = 2 days;
32 
33     address public owner;
34     modifier onlyOwner() {
35         require(msg.sender == owner, "only owner");
36         _;
37     }
38 
39     event Swapped(address indexed sender, uint256 indexed srcAmount, uint256 indexed dstAmount);
40 
41     constructor(address _srcToken, address _dstToken, uint256 _numeratorOfRate, uint256 _denominatorOfRate) {
42         srcToken = _srcToken;
43         dstToken = _dstToken;
44         numeratorOfRate = _numeratorOfRate;
45         denominatorOfRate = _denominatorOfRate;
46         owner = msg.sender;
47     }
48 
49     function transferOwnership(address newOwner) external onlyOwner {
50         require(newOwner != address(0), "the new owner is the zero address");
51         owner = newOwner;
52     }
53 
54     /// @dev swap with `srcAmount` of `srcToken` to get `dstToken`.
55     /// Returns swap result of `dstAmount` of `dstToken`.
56     /// Requirements:
57     ///   - `msg.sender` must have approved at least `srcAmount` `srcToken` to `address(this)`.
58     ///   - `address(this)` must have at least `dstAmount` `dstToken`.
59     function swap(uint256 srcAmount) external returns (uint256 dstAmount) {
60         dstAmount = srcAmount * numeratorOfRate / denominatorOfRate;
61         TransferHelper.safeTransferFrom(srcToken, msg.sender, address(this), srcAmount);
62         TransferHelper.safeTransfer(dstToken, msg.sender, dstAmount);
63         emit Swapped(msg.sender, srcAmount, dstAmount);
64         return dstAmount;
65     }
66 
67     function withdrawRequest(uint256 amount) external onlyOwner {
68         if (amount > 0) {
69             latestWithdrawRequestTime = block.timestamp;
70             latestWithdrawRequestAmount = amount;
71         } else {
72             latestWithdrawRequestTime = 0;
73             latestWithdrawRequestAmount = 0;
74         }
75     }
76 
77     function withdraw() external onlyOwner {
78         require(
79             latestWithdrawRequestTime > 0 && latestWithdrawRequestAmount > 0,
80             "please do withdraw request firstly"
81         );
82         require(
83             latestWithdrawRequestTime + minWithdrawApprovalInterval < block.timestamp,
84             "the minimum withdraw approval interval is not satisfied"
85         );
86         uint256 amount = latestWithdrawRequestAmount;
87         latestWithdrawRequestTime = 0;
88         latestWithdrawRequestAmount = 0;
89         TransferHelper.safeTransfer(dstToken, msg.sender, amount);
90     }
91 }