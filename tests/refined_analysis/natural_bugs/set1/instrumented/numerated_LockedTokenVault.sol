1 /*
2 
3     Copyright 2020 DODO ZOO.
4     SPDX-License-Identifier: Apache-2.0
5 
6 */
7 
8 pragma solidity 0.6.9;
9 pragma experimental ABIEncoderV2;
10 
11 import {SafeMath} from "../lib/SafeMath.sol";
12 import {DecimalMath} from "../lib/DecimalMath.sol";
13 import {Ownable} from "../lib/Ownable.sol";
14 import {SafeERC20} from "../lib/SafeERC20.sol";
15 import {IERC20} from "../intf/IERC20.sol";
16 
17 
18 /**
19  * @title LockedTokenVault
20  * @author DODO Breeder
21  *
22  * @notice Lock Token and release it linearly
23  */
24 
25 contract LockedTokenVault is Ownable {
26     using SafeMath for uint256;
27     using SafeERC20 for IERC20;
28 
29     address _TOKEN_;
30 
31     mapping(address => uint256) internal originBalances;
32     mapping(address => uint256) internal claimedBalances;
33 
34     uint256 public _UNDISTRIBUTED_AMOUNT_;
35     uint256 public _START_RELEASE_TIME_;
36     uint256 public _RELEASE_DURATION_;
37     uint256 public _CLIFF_RATE_;
38 
39     bool public _DISTRIBUTE_FINISHED_;
40 
41     // ============ Modifiers ============
42 
43     event Claim(address indexed holder, uint256 origin, uint256 claimed, uint256 amount);
44 
45     // ============ Modifiers ============
46 
47     modifier beforeStartRelease() {
48         require(block.timestamp < _START_RELEASE_TIME_, "RELEASE START");
49         _;
50     }
51 
52     modifier afterStartRelease() {
53         require(block.timestamp >= _START_RELEASE_TIME_, "RELEASE NOT START");
54         _;
55     }
56 
57     modifier distributeNotFinished() {
58         require(!_DISTRIBUTE_FINISHED_, "DISTRIBUTE FINISHED");
59         _;
60     }
61 
62     // ============ Init Functions ============
63 
64     constructor(
65         address _token,
66         uint256 _startReleaseTime,
67         uint256 _releaseDuration,
68         uint256 _cliffRate
69     ) public {
70         _TOKEN_ = _token;
71         _START_RELEASE_TIME_ = _startReleaseTime;
72         _RELEASE_DURATION_ = _releaseDuration;
73         _CLIFF_RATE_ = _cliffRate;
74     }
75 
76     function deposit(uint256 amount) external onlyOwner {
77         _tokenTransferIn(_OWNER_, amount);
78         _UNDISTRIBUTED_AMOUNT_ = _UNDISTRIBUTED_AMOUNT_.add(amount);
79     }
80 
81     function withdraw(uint256 amount) external onlyOwner {
82         _UNDISTRIBUTED_AMOUNT_ = _UNDISTRIBUTED_AMOUNT_.sub(amount);
83         _tokenTransferOut(_OWNER_, amount);
84     }
85 
86     function finishDistribute() external onlyOwner {
87         _DISTRIBUTE_FINISHED_ = true;
88     }
89 
90     // ============ For Owner ============
91 
92     function grant(address[] calldata holderList, uint256[] calldata amountList)
93         external
94         onlyOwner
95     {
96         require(holderList.length == amountList.length, "batch grant length not match");
97         uint256 amount = 0;
98         for (uint256 i = 0; i < holderList.length; ++i) {
99             // for saving gas, no event for grant
100             originBalances[holderList[i]] = originBalances[holderList[i]].add(amountList[i]);
101             amount = amount.add(amountList[i]);
102         }
103         _UNDISTRIBUTED_AMOUNT_ = _UNDISTRIBUTED_AMOUNT_.sub(amount);
104     }
105 
106     function recall(address holder) external onlyOwner distributeNotFinished {
107         _UNDISTRIBUTED_AMOUNT_ = _UNDISTRIBUTED_AMOUNT_.add(originBalances[holder]).sub(
108             claimedBalances[holder]
109         );
110         originBalances[holder] = 0;
111         claimedBalances[holder] = 0;
112     }
113 
114     // ============ For Holder ============
115 
116     function transferLockedToken(address to) external {
117         originBalances[to] = originBalances[to].add(originBalances[msg.sender]);
118         claimedBalances[to] = claimedBalances[to].add(claimedBalances[msg.sender]);
119 
120         originBalances[msg.sender] = 0;
121         claimedBalances[msg.sender] = 0;
122     }
123 
124     function claim() external {
125         uint256 claimableToken = getClaimableBalance(msg.sender);
126         _tokenTransferOut(msg.sender, claimableToken);
127         claimedBalances[msg.sender] = claimedBalances[msg.sender].add(claimableToken);
128         emit Claim(
129             msg.sender,
130             originBalances[msg.sender],
131             claimedBalances[msg.sender],
132             claimableToken
133         );
134     }
135 
136     // ============ View ============
137 
138     function isReleaseStart() external view returns (bool) {
139         return block.timestamp >= _START_RELEASE_TIME_;
140     }
141 
142     function getOriginBalance(address holder) external view returns (uint256) {
143         return originBalances[holder];
144     }
145 
146     function getClaimedBalance(address holder) external view returns (uint256) {
147         return claimedBalances[holder];
148     }
149 
150     function getClaimableBalance(address holder) public view returns (uint256) {
151         uint256 remainingToken = getRemainingBalance(holder);
152         return originBalances[holder].sub(remainingToken).sub(claimedBalances[holder]);
153     }
154 
155     function getRemainingBalance(address holder) public view returns (uint256) {
156         uint256 remainingRatio = getRemainingRatio(block.timestamp);
157         return DecimalMath.mul(originBalances[holder], remainingRatio);
158     }
159 
160     function getRemainingRatio(uint256 timestamp) public view returns (uint256) {
161         if (timestamp < _START_RELEASE_TIME_) {
162             return DecimalMath.ONE;
163         }
164         uint256 timePast = timestamp.sub(_START_RELEASE_TIME_);
165         if (timePast < _RELEASE_DURATION_) {
166             uint256 remainingTime = _RELEASE_DURATION_.sub(timePast);
167             return DecimalMath.ONE.sub(_CLIFF_RATE_).mul(remainingTime).div(_RELEASE_DURATION_);
168         } else {
169             return 0;
170         }
171     }
172 
173     // ============ Internal Helper ============
174 
175     function _tokenTransferIn(address from, uint256 amount) internal {
176         IERC20(_TOKEN_).safeTransferFrom(from, address(this), amount);
177     }
178 
179     function _tokenTransferOut(address to, uint256 amount) internal {
180         IERC20(_TOKEN_).safeTransfer(to, amount);
181     }
182 }
