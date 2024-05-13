1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./MockERC20.sol";
5 
6 contract MockStEthToken is MockERC20 {
7     uint256 public pooledEth;
8     uint256 public totalShares;
9     mapping(address => uint256) public shares;
10 
11     constructor() {
12         pooledEth = 1_000_000e18;
13         totalShares = 999_999e18;
14         shares[address(msg.sender)] = totalShares;
15     }
16 
17     function submit(
18         address /* _referral*/
19     ) external payable returns (uint256 amount_) {
20         amount_ = msg.value;
21 
22         uint256 _shares = getSharesByPooledEth(amount_);
23 
24         pooledEth += amount_;
25 
26         _mintShares(_shares, msg.sender);
27     }
28 
29     function mintAt(address _dst) public {
30         uint256 _shares = getSharesByPooledEth(100_000e18);
31 
32         pooledEth += 100_000e18;
33 
34         _mintShares(_shares, _dst);
35     }
36 
37     function balanceOf(address _account) public view override returns (uint256 amount_) {
38         return getPooledEthByShares(shares[_account]);
39     }
40 
41     function getSharesByPooledEth(uint256 _ethAmount) public view returns (uint256 shares_) {
42         shares_ = (_ethAmount * totalShares) / pooledEth;
43     }
44 
45     function transfer(address dst, uint256 amount) public override returns (bool) {
46         _transfer(msg.sender, dst, amount);
47         return true;
48     }
49 
50     function transferFrom(
51         address from,
52         address to,
53         uint256 amount
54     ) public override returns (bool) {
55         _transfer(from, to, amount);
56         return true;
57     }
58 
59     function _transfer(
60         address _sender,
61         address _recipient,
62         uint256 _amount
63     ) internal override {
64         uint256 _sharesToTransfer = getSharesByPooledEth(_amount);
65 
66         uint256 _currentSenderShares = shares[_sender];
67         require(_sharesToTransfer <= _currentSenderShares, "TRANSFER_AMOUNT_EXCEEDS_BALANCE");
68 
69         shares[_sender] = _currentSenderShares - _sharesToTransfer;
70         shares[_recipient] = shares[_recipient] + _sharesToTransfer;
71     }
72 
73     function getPooledEthByShares(uint256 _sharesAmount) public view returns (uint256 eth_) {
74         eth_ = (_sharesAmount * pooledEth) / totalShares;
75     }
76 
77     function _mintShares(uint256 _sharesAmount, address _recipient) internal {
78         totalShares += _sharesAmount;
79 
80         shares[_recipient] += _sharesAmount;
81     }
82 
83     function getTotalPooledEther() public view returns (uint256 totalEther_) {
84         totalEther_ = pooledEth;
85     }
86 
87     function getTotalShares() public view returns (uint256 totalShares_) {
88         totalShares_ = totalShares;
89     }
90 
91     receive() external payable {}
92 }
