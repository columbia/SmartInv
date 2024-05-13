1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../refs/CoreRef.sol";
5 import "@openzeppelin/contracts/utils/math/Math.sol";
6 
7 /// @title abstract contract for putting a rate limit on how fast a contract can perform an action e.g. Minting
8 /// @author Fei Protocol
9 abstract contract RateLimited is CoreRef {
10     /// @notice maximum rate limit per second governance can set for this contract
11     uint256 public immutable MAX_RATE_LIMIT_PER_SECOND;
12 
13     /// @notice the rate per second for this contract
14     uint256 public rateLimitPerSecond;
15 
16     /// @notice the last time the buffer was used by the contract
17     uint256 public lastBufferUsedTime;
18 
19     /// @notice the cap of the buffer that can be used at once
20     uint256 public bufferCap;
21 
22     /// @notice a flag for whether to allow partial actions to complete if the buffer is less than amount
23     bool public doPartialAction;
24 
25     /// @notice the buffer at the timestamp of lastBufferUsedTime
26     uint256 public bufferStored;
27 
28     event BufferUsed(uint256 amountUsed, uint256 bufferRemaining);
29     event BufferCapUpdate(uint256 oldBufferCap, uint256 newBufferCap);
30     event RateLimitPerSecondUpdate(uint256 oldRateLimitPerSecond, uint256 newRateLimitPerSecond);
31 
32     constructor(
33         uint256 _maxRateLimitPerSecond,
34         uint256 _rateLimitPerSecond,
35         uint256 _bufferCap,
36         bool _doPartialAction
37     ) {
38         lastBufferUsedTime = block.timestamp;
39 
40         _setBufferCap(_bufferCap);
41         bufferStored = _bufferCap;
42 
43         require(_rateLimitPerSecond <= _maxRateLimitPerSecond, "RateLimited: rateLimitPerSecond too high");
44         _setRateLimitPerSecond(_rateLimitPerSecond);
45 
46         MAX_RATE_LIMIT_PER_SECOND = _maxRateLimitPerSecond;
47         doPartialAction = _doPartialAction;
48     }
49 
50     /// @notice set the rate limit per second
51     function setRateLimitPerSecond(uint256 newRateLimitPerSecond) external virtual onlyGovernorOrAdmin {
52         require(newRateLimitPerSecond <= MAX_RATE_LIMIT_PER_SECOND, "RateLimited: rateLimitPerSecond too high");
53         _updateBufferStored();
54 
55         _setRateLimitPerSecond(newRateLimitPerSecond);
56     }
57 
58     /// @notice set the buffer cap
59     function setBufferCap(uint256 newBufferCap) external virtual onlyGovernorOrAdmin {
60         _setBufferCap(newBufferCap);
61     }
62 
63     /// @notice the amount of action used before hitting limit
64     /// @dev replenishes at rateLimitPerSecond per second up to bufferCap
65     function buffer() public view returns (uint256) {
66         uint256 elapsed = block.timestamp - lastBufferUsedTime;
67         return Math.min(bufferStored + (rateLimitPerSecond * elapsed), bufferCap);
68     }
69 
70     /** 
71         @notice the method that enforces the rate limit. Decreases buffer by "amount". 
72         If buffer is <= amount either
73         1. Does a partial mint by the amount remaining in the buffer or
74         2. Reverts
75         Depending on whether doPartialAction is true or false
76     */
77     function _depleteBuffer(uint256 amount) internal virtual returns (uint256) {
78         uint256 newBuffer = buffer();
79 
80         uint256 usedAmount = amount;
81         if (doPartialAction && usedAmount > newBuffer) {
82             usedAmount = newBuffer;
83         }
84 
85         require(newBuffer != 0, "RateLimited: no rate limit buffer");
86         require(usedAmount <= newBuffer, "RateLimited: rate limit hit");
87 
88         bufferStored = newBuffer - usedAmount;
89 
90         lastBufferUsedTime = block.timestamp;
91 
92         emit BufferUsed(usedAmount, bufferStored);
93 
94         return usedAmount;
95     }
96 
97     /// @notice function to replenish buffer
98     /// @param amount to increase buffer by if under buffer cap
99     function _replenishBuffer(uint256 amount) internal {
100         uint256 newBuffer = buffer();
101 
102         uint256 _bufferCap = bufferCap; /// gas opti, save an SLOAD
103 
104         /// cannot replenish any further if already at buffer cap
105         if (newBuffer == _bufferCap) {
106             return;
107         }
108 
109         lastBufferUsedTime = block.timestamp;
110 
111         /// ensure that bufferStored cannot be gt buffer cap
112         bufferStored = Math.min(newBuffer + amount, _bufferCap);
113     }
114 
115     function _setRateLimitPerSecond(uint256 newRateLimitPerSecond) internal {
116         uint256 oldRateLimitPerSecond = rateLimitPerSecond;
117         rateLimitPerSecond = newRateLimitPerSecond;
118 
119         emit RateLimitPerSecondUpdate(oldRateLimitPerSecond, newRateLimitPerSecond);
120     }
121 
122     function _setBufferCap(uint256 newBufferCap) internal {
123         _updateBufferStored();
124 
125         uint256 oldBufferCap = bufferCap;
126         bufferCap = newBufferCap;
127 
128         emit BufferCapUpdate(oldBufferCap, newBufferCap);
129     }
130 
131     function _resetBuffer() internal {
132         bufferStored = bufferCap;
133     }
134 
135     function _updateBufferStored() internal {
136         bufferStored = buffer();
137         lastBufferUsedTime = block.timestamp;
138     }
139 }
