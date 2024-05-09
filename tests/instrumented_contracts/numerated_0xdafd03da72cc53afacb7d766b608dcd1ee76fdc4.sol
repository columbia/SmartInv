1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 ///////////////////////////////////////
5 //   ____       __  ___     __   __  //
6 //  /_  / ___ __\ \/ (_)__ / /__/ /  //
7 //   / /_/ -_) _ \  / / -_) / _  /   //
8 //  /___/\__/_//_/_/_/\__/_/\_,_/    //
9 //               by 0xInuarashi.eth  //
10 ///////////////////////////////////////
11 
12 abstract contract Ownable {
13     address public owner; 
14     constructor() { owner = msg.sender; }
15     modifier onlyOwner { require(owner == msg.sender, "Not Owner!"); _; }
16     function transferOwnership(address new_) external onlyOwner { owner = new_; }
17 }
18 
19 interface iZen {
20     function mintAsController(address to_, uint256 amount_) external;
21 }
22 
23 interface iZenApe {
24     function totalSupply() external view returns (uint256);
25     function balanceOf(address address_) external view returns (uint256);
26     function ownerOf(uint256 tokenId_) external view returns (address);
27 }
28 
29 contract ZenYield is Ownable {
30 
31     // Interfaces
32     iZen public Zen = iZen(0x884345a7B7E7fFd7F4298aD6115f5d5afb2F7660); 
33     function setZen(address address_) external onlyOwner { 
34         Zen = iZen(address_); 
35     }
36 
37     iZenApe public ZenApe = iZenApe(0x838804a3dd7c717396a68F94E736eAf76b911632);
38     function setZenApe(address address_) external onlyOwner {
39         ZenApe = iZenApe(address_);
40     }
41 
42     // Times
43     uint256 public yieldStartTime = 1651327200; // Apr 30 2022 14:00:00 GMT+0000
44     uint256 public yieldEndTime = 1682863200; // Apr 30 2023 14:00:00 GMT+0000
45     function setYieldEndTime(uint256 yieldEndTime_) external onlyOwner { 
46         yieldEndTime = yieldEndTime_; }
47 
48     // Yield Info
49     uint256 public yieldRatePerToken = 5 ether; // 5 Zen per Day
50     function setYieldRatePerToken(uint256 yieldRatePerToken_) external onlyOwner {
51         yieldRatePerToken = yieldRatePerToken_;
52     }
53 
54     // Yield Database
55     mapping(uint256 => uint256) public tokenToLastClaimedTimestamp;
56 
57     // Events
58     event Claim(address to_, uint256[] tokenIds_, uint256 totalClaimed_);
59 
60     // Internal Calculators
61     function _getTimeCurrentOrEnded() internal view returns (uint256) {
62         // Return block.timestamp if it's lower than yieldEndTime, otherwise
63         // return yieldEndTime instead.
64         return block.timestamp < yieldEndTime ? 
65             block.timestamp : yieldEndTime;
66     }
67     function _getTimestampOfToken(uint256 tokenId_) internal view returns (uint256) {
68         // Here, since we have intrinsic token yield, we need to take that into account.
69         // We return the yieldStartTime if SSTORE of tokenToLastClaimedTimestamp is 0
70         return tokenToLastClaimedTimestamp[tokenId_] == 0 ? 
71             yieldStartTime : tokenToLastClaimedTimestamp[tokenId_];
72     }
73 
74     // Yield Accountants
75     function getPendingTokens(uint256 tokenId_) public view 
76     returns (uint256) {
77         
78         // First, grab the timestamp of the token
79         uint256 _lastClaimedTimestamp = _getTimestampOfToken(tokenId_);
80 
81         // Then, we grab the timestamp to compare it with
82         uint256 _timeCurrentOrEnded = _getTimeCurrentOrEnded();
83 
84         // Lastly, we calculate the time-units in seconds of elapsed time 
85         uint256 _timeElapsed = _timeCurrentOrEnded - _lastClaimedTimestamp;
86 
87         // Now, calculate the pending yield
88         return (_timeElapsed * yieldRatePerToken) / 1 days;
89     }
90     function getPendingTokensMany(uint256[] memory tokenIds_) public
91     view returns (uint256) {
92         uint256 _pendingTokens;
93         for (uint256 i = 0; i < tokenIds_.length; i++) {
94             _pendingTokens += getPendingTokens(tokenIds_[i]);
95         }
96         return _pendingTokens;
97     }
98 
99     // Internal Timekeepers    
100     function _updateTimestampOfTokens(uint256[] memory tokenIds_) internal { 
101         uint256 _timeCurrentOrEnded = _getTimeCurrentOrEnded();
102         for (uint256 i = 0; i < tokenIds_.length; i++) {
103             // Prevents duplicate setting of the same token in the same block
104             require(tokenToLastClaimedTimestamp[tokenIds_[i]] != _timeCurrentOrEnded,
105                 "Unable to set timestamp duplication in the same block");
106 
107             tokenToLastClaimedTimestamp[tokenIds_[i]] = _timeCurrentOrEnded;
108         }
109     }
110 
111     // Public Claim
112     function claim(uint256[] calldata tokenIds_) external {
113         // Make sure the sender owns all the tokens
114         for (uint256 i = 0; i < tokenIds_.length; i++) {
115             require(msg.sender == ZenApe.ownerOf(tokenIds_[i]),
116                 "You are not the owner!");
117         }
118 
119         // Calculate the total Pending Tokens to be claimed
120         uint256 _pendingTokens = getPendingTokensMany(tokenIds_);
121         
122         // Set on all the tokens the new timestamp (which sets pending to 0)
123         _updateTimestampOfTokens(tokenIds_);
124         
125         // Mint the total tokens for the msg.sender
126         Zen.mintAsController(msg.sender, _pendingTokens);
127 
128         // Emit claim of total tokens
129         emit Claim(msg.sender, tokenIds_, _pendingTokens);
130     }
131 
132     // Public View Functions for Helpers
133     function walletOfOwner(address address_) public view returns (uint256[] memory) {
134         uint256 _balance = ZenApe.balanceOf(address_);
135         uint256[] memory _tokens = new uint256[] (_balance);
136         uint256 _index;
137         uint256 _loopThrough = ZenApe.totalSupply();
138         for (uint256 i = 0; i < _loopThrough; i++) {
139             address _ownerOf = ZenApe.ownerOf(i);
140             if (_ownerOf == address(0) && _tokens[_balance - 1] == 0) {
141                 _loopThrough++;
142             }
143             if (_ownerOf == address_) {
144                 _tokens[_index++] = i;
145             }
146         }
147         return _tokens;
148     }
149     function getPendingTokensOfAddress(address address_) public view returns (uint256) {
150         uint256[] memory _walletOfAddress = walletOfOwner(address_);
151         return getPendingTokensMany(_walletOfAddress);
152     }
153 }