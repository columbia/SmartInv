1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import {CoreRef} from "../refs/CoreRef.sol";
5 import {TribeRoles} from "./../core/TribeRoles.sol";
6 import {RateLimited} from "./RateLimited.sol";
7 import {IMultiRateLimited} from "./IMultiRateLimited.sol";
8 import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
9 import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
10 
11 /// @title abstract contract for putting a rate limit on how fast an address can perform an action e.g. Minting
12 /// there are two buffers, one buffer which is each individual addresses's current buffer,
13 /// and then there is a global buffer which is the buffer that each individual address must respect as well
14 /// @author Elliot Friedman, Fei Protocol
15 /// this contract was made abstract so that other contracts that already construct an instance of CoreRef
16 /// do not collide with this one
17 abstract contract MultiRateLimited is RateLimited, IMultiRateLimited {
18     using SafeCast for *;
19 
20     /// @notice the struct containing all information per rate limited address
21     struct RateLimitData {
22         uint32 lastBufferUsedTime;
23         uint112 bufferCap;
24         uint112 bufferStored;
25         uint112 rateLimitPerSecond;
26     }
27 
28     /// @notice rate limited address information
29     mapping(address => RateLimitData) public rateLimitPerAddress;
30 
31     /// @notice max rate limit per second allowable by non governor per contract
32     uint256 public individualMaxRateLimitPerSecond;
33 
34     /// @notice max buffer cap allowable by non governor per contract
35     uint256 public individualMaxBufferCap;
36 
37     /// @param _maxRateLimitPerSecond maximum amount of fei that can replenish per second ever, this amount cannot be changed by governance
38     /// @param _rateLimitPerSecond maximum rate limit per second per address
39     /// @param _individualMaxRateLimitPerSecond maximum rate limit per second per address in multi rate limited
40     /// @param _individualMaxBufferCap maximum buffer cap in multi rate limited
41     /// @param _globalBufferCap maximum global buffer cap
42     constructor(
43         uint256 _maxRateLimitPerSecond,
44         uint256 _rateLimitPerSecond,
45         uint256 _individualMaxRateLimitPerSecond,
46         uint256 _individualMaxBufferCap,
47         uint256 _globalBufferCap
48     ) RateLimited(_maxRateLimitPerSecond, _rateLimitPerSecond, _globalBufferCap, false) {
49         require(_individualMaxBufferCap < _globalBufferCap, "MultiRateLimited: max buffer cap invalid");
50 
51         individualMaxRateLimitPerSecond = _individualMaxRateLimitPerSecond;
52         individualMaxBufferCap = _individualMaxBufferCap;
53     }
54 
55     modifier addressIsRegistered(address rateLimitedAddress) {
56         require(
57             rateLimitPerAddress[rateLimitedAddress].lastBufferUsedTime != 0,
58             "MultiRateLimited: rate limit address does not exist"
59         );
60         _;
61     }
62 
63     // ----------- Governor and Admin only state changing api -----------
64 
65     /// @notice update the ADD_MINTER_ROLE rate limit per second
66     /// @param newRateLimitPerSecond new maximum rate limit per second for add minter role
67     function updateMaxRateLimitPerSecond(uint256 newRateLimitPerSecond) external override onlyGovernor {
68         require(
69             newRateLimitPerSecond <= MAX_RATE_LIMIT_PER_SECOND,
70             "MultiRateLimited: exceeds global max rate limit per second"
71         );
72 
73         uint256 oldMaxRateLimitPerSecond = individualMaxRateLimitPerSecond;
74         individualMaxRateLimitPerSecond = newRateLimitPerSecond;
75 
76         emit MultiMaxRateLimitPerSecondUpdate(oldMaxRateLimitPerSecond, newRateLimitPerSecond);
77     }
78 
79     /// @notice update the ADD_MINTER_ROLE max buffer cap
80     /// @param newBufferCap new buffer cap for ADD_MINTER_ROLE added addresses
81     function updateMaxBufferCap(uint256 newBufferCap) external override onlyGovernor {
82         require(newBufferCap <= bufferCap, "MultiRateLimited: exceeds global buffer cap");
83 
84         uint256 oldBufferCap = individualMaxBufferCap;
85         individualMaxBufferCap = newBufferCap;
86 
87         emit MultiBufferCapUpdate(oldBufferCap, newBufferCap);
88     }
89 
90     /// @notice add an authorized rateLimitedAddress contract
91     /// @param rateLimitedAddress the new address to add as a rateLimitedAddress
92     /// @param _rateLimitPerSecond the rate limit per second for this rateLimitedAddress
93     /// @param _bufferCap  the buffer cap for this rateLimitedAddress
94     function addAddress(
95         address rateLimitedAddress,
96         uint112 _rateLimitPerSecond,
97         uint112 _bufferCap
98     ) external override onlyGovernor {
99         _addAddress(rateLimitedAddress, _rateLimitPerSecond, _bufferCap);
100     }
101 
102     /// @notice add an authorized rateLimitedAddress contract
103     /// @param rateLimitedAddress the address whose buffer and rate limit per second will be set
104     /// @param _rateLimitPerSecond the new rate limit per second for this rateLimitedAddress
105     /// @param _bufferCap  the new buffer cap for this rateLimitedAddress
106     function updateAddress(
107         address rateLimitedAddress,
108         uint112 _rateLimitPerSecond,
109         uint112 _bufferCap
110     )
111         external
112         override
113         addressIsRegistered(rateLimitedAddress)
114         hasAnyOfTwoRoles(TribeRoles.ADD_MINTER_ROLE, TribeRoles.GOVERNOR)
115     {
116         if (core().hasRole(TribeRoles.ADD_MINTER_ROLE, msg.sender)) {
117             require(
118                 _rateLimitPerSecond <= individualMaxRateLimitPerSecond,
119                 "MultiRateLimited: rate limit per second exceeds non governor allowable amount"
120             );
121             require(
122                 _bufferCap <= individualMaxBufferCap,
123                 "MultiRateLimited: max buffer cap exceeds non governor allowable amount"
124             );
125         }
126         require(_bufferCap <= bufferCap, "MultiRateLimited: buffercap too high");
127         require(_rateLimitPerSecond <= MAX_RATE_LIMIT_PER_SECOND, "MultiRateLimited: rateLimitPerSecond too high");
128 
129         _updateAddress(rateLimitedAddress, _rateLimitPerSecond, _bufferCap);
130     }
131 
132     /// @notice add an authorized rateLimitedAddress contract
133     /// @param rateLimitedAddress the new address to add as a rateLimitedAddress
134     /// gives the newly added contract the maximum allowable rate limit per second and buffer cap
135     function addAddressAsMinter(address rateLimitedAddress)
136         external
137         override
138         onlyTribeRole(TribeRoles.ADD_MINTER_ROLE)
139     {
140         _addAddress(rateLimitedAddress, uint112(individualMaxRateLimitPerSecond), uint112(individualMaxBufferCap));
141     }
142 
143     /// @notice add an authorized rateLimitedAddress contract
144     /// @param rateLimitedAddress the new address to add as a rateLimitedAddress
145     /// gives the newly added contract the maximum allowable rate limit per second and buffer cap
146     function addAddressAsMinter(
147         address rateLimitedAddress,
148         uint112 _rateLimitPerSecond,
149         uint112 _bufferCap
150     ) external onlyTribeRole(TribeRoles.ADD_MINTER_ROLE) {
151         require(_rateLimitPerSecond <= individualMaxRateLimitPerSecond, "MultiRateLimited: rlps exceeds role amt");
152         require(_bufferCap <= individualMaxBufferCap, "MultiRateLimited: buffercap exceeds role amt");
153         _addAddress(rateLimitedAddress, _rateLimitPerSecond, _bufferCap);
154     }
155 
156     /// @notice remove an authorized rateLimitedAddress contract
157     /// @param rateLimitedAddress the address to remove from the whitelist of addresses
158     function removeAddress(address rateLimitedAddress)
159         external
160         override
161         addressIsRegistered(rateLimitedAddress)
162         onlyGuardianOrGovernor
163     {
164         uint256 oldRateLimitPerSecond = rateLimitPerAddress[rateLimitedAddress].rateLimitPerSecond;
165 
166         delete rateLimitPerAddress[rateLimitedAddress];
167 
168         emit IndividualRateLimitPerSecondUpdate(rateLimitedAddress, oldRateLimitPerSecond, 0);
169     }
170 
171     // ----------- Getters -----------
172 
173     /// @notice the amount of action used before hitting limit
174     /// @dev replenishes at rateLimitPerSecond per second up to bufferCap
175     /// @param rateLimitedAddress the address whose buffer will be returned
176     /// @return the buffer of the specified rate limited address
177     function individualBuffer(address rateLimitedAddress) public view override returns (uint112) {
178         RateLimitData memory rateLimitData = rateLimitPerAddress[rateLimitedAddress];
179 
180         uint256 elapsed = block.timestamp - rateLimitData.lastBufferUsedTime;
181         return
182             uint112(
183                 Math.min(
184                     rateLimitData.bufferStored + (rateLimitData.rateLimitPerSecond * elapsed),
185                     rateLimitData.bufferCap
186                 )
187             );
188     }
189 
190     /// @notice the rate per second for each address
191     function getRateLimitPerSecond(address limiter) external view override returns (uint256) {
192         return rateLimitPerAddress[limiter].rateLimitPerSecond;
193     }
194 
195     /// @notice the last time the buffer was used by each address
196     function getLastBufferUsedTime(address limiter) external view override returns (uint256) {
197         return rateLimitPerAddress[limiter].lastBufferUsedTime;
198     }
199 
200     /// @notice the cap of the buffer that can be used at once
201     function getBufferCap(address limiter) external view override returns (uint256) {
202         return rateLimitPerAddress[limiter].bufferCap;
203     }
204 
205     // ----------- Helper Methods -----------
206 
207     function _updateAddress(
208         address rateLimitedAddress,
209         uint112 _rateLimitPerSecond,
210         uint112 _bufferCap
211     ) internal {
212         RateLimitData storage rateLimitData = rateLimitPerAddress[rateLimitedAddress];
213 
214         uint112 oldRateLimitPerSecond = rateLimitData.rateLimitPerSecond;
215         uint112 currentBufferStored = individualBuffer(rateLimitedAddress);
216         uint32 newBlockTimestamp = block.timestamp.toUint32();
217 
218         rateLimitData.bufferStored = currentBufferStored;
219         rateLimitData.lastBufferUsedTime = newBlockTimestamp;
220         rateLimitData.bufferCap = _bufferCap;
221         rateLimitData.rateLimitPerSecond = _rateLimitPerSecond;
222 
223         emit IndividualRateLimitPerSecondUpdate(rateLimitedAddress, oldRateLimitPerSecond, _rateLimitPerSecond);
224     }
225 
226     /// @param rateLimitedAddress the new address to add as a rateLimitedAddress
227     /// @param _rateLimitPerSecond the rate limit per second for this rateLimitedAddress
228     /// @param _bufferCap  the buffer cap for this rateLimitedAddress
229     function _addAddress(
230         address rateLimitedAddress,
231         uint112 _rateLimitPerSecond,
232         uint112 _bufferCap
233     ) internal {
234         require(_bufferCap <= bufferCap, "MultiRateLimited: new buffercap too high");
235         require(
236             rateLimitPerAddress[rateLimitedAddress].lastBufferUsedTime == 0,
237             "MultiRateLimited: address already added"
238         );
239         require(_rateLimitPerSecond <= MAX_RATE_LIMIT_PER_SECOND, "MultiRateLimited: rateLimitPerSecond too high");
240 
241         RateLimitData memory rateLimitData = RateLimitData({
242             lastBufferUsedTime: block.timestamp.toUint32(),
243             bufferCap: _bufferCap,
244             rateLimitPerSecond: _rateLimitPerSecond,
245             bufferStored: _bufferCap
246         });
247 
248         rateLimitPerAddress[rateLimitedAddress] = rateLimitData;
249 
250         emit IndividualRateLimitPerSecondUpdate(rateLimitedAddress, 0, _rateLimitPerSecond);
251     }
252 
253     /// @notice the method that enforces the rate limit. Decreases buffer by "amount".
254     /// @param rateLimitedAddress the address whose buffer will be depleted
255     /// @param amount the amount to remove from the rateLimitedAddress's buffer
256     function _depleteIndividualBuffer(address rateLimitedAddress, uint256 amount) internal {
257         _depleteBuffer(amount);
258 
259         uint256 newBuffer = individualBuffer(rateLimitedAddress);
260 
261         require(newBuffer != 0, "MultiRateLimited: no rate limit buffer");
262         require(amount <= newBuffer, "MultiRateLimited: rate limit hit");
263 
264         uint32 lastBufferUsedTime = block.timestamp.toUint32();
265 
266         uint112 newBufferStored = uint112(newBuffer - amount);
267         uint112 currentBufferCap = rateLimitPerAddress[rateLimitedAddress].bufferCap;
268 
269         rateLimitPerAddress[rateLimitedAddress].lastBufferUsedTime = lastBufferUsedTime;
270         rateLimitPerAddress[rateLimitedAddress].bufferCap = currentBufferCap;
271         rateLimitPerAddress[rateLimitedAddress].bufferStored = newBufferStored;
272 
273         emit IndividualBufferUsed(rateLimitedAddress, amount, newBuffer - amount);
274     }
275 }
