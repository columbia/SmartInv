1 /*
2 
3  Copyright 2017-2019 RigoBlock, Rigo Investment Sagl.
4 
5  Licensed under the Apache License, Version 2.0 (the "License");
6  you may not use this file except in compliance with the License.
7  You may obtain a copy of the License at
8 
9      http://www.apache.org/licenses/LICENSE-2.0
10 
11  Unless required by applicable law or agreed to in writing, software
12  distributed under the License is distributed on an "AS IS" BASIS,
13  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14  See the License for the specific language governing permissions and
15  limitations under the License.
16 
17 */
18 
19 pragma solidity 0.5.2;
20 
21 contract Owned {
22 
23     address public owner;
24 
25     event NewOwner(address indexed old, address indexed current);
26 
27     modifier onlyOwner {
28         require(msg.sender == owner);
29         _;
30     }
31 
32     constructor() public {
33         owner = msg.sender;
34     }
35 
36     function setOwner(address _new)
37         public
38         onlyOwner
39     {
40         require(_new != address(0));
41         owner = _new;
42         emit NewOwner(owner, _new);
43     }
44 }
45 
46 interface RigoToken {
47 
48     /*
49      * EVENTS
50      */
51     event TokenMinted(address indexed recipient, uint256 amount);
52 
53     /*
54      * CORE FUNCTIONS
55      */
56     function mintToken(address _recipient, uint256 _amount) external;
57     function changeMintingAddress(address _newAddress) external;
58     function changeRigoblockAddress(address _newAddress) external;
59     
60     function balanceOf(address _who) external view returns (uint256);
61 }
62 
63 interface Authority {
64 
65     /*
66      * EVENTS
67      */
68     event AuthoritySet(address indexed authority);
69     event WhitelisterSet(address indexed whitelister);
70     event WhitelistedUser(address indexed target, bool approved);
71     event WhitelistedRegistry(address indexed registry, bool approved);
72     event WhitelistedFactory(address indexed factory, bool approved);
73     event WhitelistedVault(address indexed vault, bool approved);
74     event WhitelistedDrago(address indexed drago, bool isWhitelisted);
75     event NewDragoEventful(address indexed dragoEventful);
76     event NewVaultEventful(address indexed vaultEventful);
77     event NewNavVerifier(address indexed navVerifier);
78     event NewExchangesAuthority(address indexed exchangesAuthority);
79 
80     /*
81      * CORE FUNCTIONS
82      */
83     function setAuthority(address _authority, bool _isWhitelisted) external;
84     function setWhitelister(address _whitelister, bool _isWhitelisted) external;
85     function whitelistUser(address _target, bool _isWhitelisted) external;
86     function whitelistDrago(address _drago, bool _isWhitelisted) external;
87     function whitelistVault(address _vault, bool _isWhitelisted) external;
88     function whitelistRegistry(address _registry, bool _isWhitelisted) external;
89     function whitelistFactory(address _factory, bool _isWhitelisted) external;
90     function setDragoEventful(address _dragoEventful) external;
91     function setVaultEventful(address _vaultEventful) external;
92     function setNavVerifier(address _navVerifier) external;
93     function setExchangesAuthority(address _exchangesAuthority) external;
94 
95     /*
96      * CONSTANT PUBLIC FUNCTIONS
97      */
98     function isWhitelistedUser(address _target) external view returns (bool);
99     function isAuthority(address _authority) external view returns (bool);
100     function isWhitelistedRegistry(address _registry) external view returns (bool);
101     function isWhitelistedDrago(address _drago) external view returns (bool);
102     function isWhitelistedVault(address _vault) external view returns (bool);
103     function isWhitelistedFactory(address _factory) external view returns (bool);
104     function getDragoEventful() external view returns (address);
105     function getVaultEventful() external view returns (address);
106     function getNavVerifier() external view returns (address);
107     function getExchangesAuthority() external view returns (address);
108 }
109 
110 contract SafeMath {
111 
112     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
113         uint256 c = a * b;
114         assert(a == 0 || c / a == b);
115         return c;
116     }
117 
118     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
119         assert(b > 0);
120         uint256 c = a / b;
121         assert(a == b * c + a % b);
122         return c;
123     }
124 
125     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
126         assert(b <= a);
127         return a - b;
128     }
129 
130     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
131         uint256 c = a + b;
132         assert(c>=a && c>=b);
133         return c;
134     }
135 
136     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
137         return a >= b ? a : b;
138     }
139 
140     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
141         return a < b ? a : b;
142     }
143 
144     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
145         return a >= b ? a : b;
146     }
147 
148     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
149         return a < b ? a : b;
150     }
151 }
152 
153 interface InflationFace {
154 
155     /*
156      * CORE FUNCTIONS
157      */
158     function mintInflation(address _thePool, uint256 _reward) external returns (bool);
159     function setInflationFactor(address _group, uint256 _inflationFactor) external;
160     function setMinimumRigo(uint256 _minimum) external;
161     function setRigoblock(address _newRigoblock) external;
162     function setAuthority(address _authority) external;
163     function setProofOfPerformance(address _pop) external;
164     function setPeriod(uint256 _newPeriod) external;
165 
166     /*
167      * CONSTANT PUBLIC FUNCTIONS
168      */
169     function canWithdraw(address _thePool) external view returns (bool);
170     function timeUntilClaim(address _thePool) external view returns (uint256);
171     function getInflationFactor(address _group) external view returns (uint256);
172 }
173 
174 /// @title Inflation - Allows ProofOfPerformance to mint tokens.
175 /// @author Gabriele Rigo - <gab@rigoblock.com>
176 // solhint-disable-next-line
177 contract Inflation is
178     SafeMath,
179     InflationFace
180 {
181     address public RIGOTOKENADDRESS;
182 
183     uint256 public period = 1 days;
184     uint256 public minimumGRG = 0;
185     address public proofOfPerformance;
186     address public authority;
187     address public rigoblockDao;
188 
189     mapping(address => Performer) performers;
190     mapping(address => Group) groups;
191 
192     struct Performer {
193         uint256 claimedTokens;
194         mapping(uint256 => bool) claim;
195         uint256 startTime;
196         uint256 endTime;
197         uint256 epoch;
198     }
199 
200     struct Group {
201         uint256 epochReward;
202     }
203 
204     /// @notice in order to qualify for PoP user has to told minimum rigo token
205     modifier minimumRigo(address _ofPool) {
206         RigoToken rigoToken = RigoToken(RIGOTOKENADDRESS);
207         require(
208             rigoToken.balanceOf(getPoolOwner(_ofPool)) >= minimumGRG,
209             "BELOW_MINIMUM_GRG"
210         );
211         _;
212     }
213 
214     modifier onlyRigoblockDao {
215         require(
216             msg.sender == rigoblockDao,
217             "ONLY_RIGOBLOCK_DAO"
218         );
219         _;
220     }
221 
222     modifier onlyProofOfPerformance {
223         require(
224             msg.sender == proofOfPerformance,
225             "ONLY_POP_CONTRACT"
226         );
227         _;
228     }
229 
230     modifier isApprovedFactory(address _factory) {
231         Authority auth = Authority(authority);
232         require(
233             auth.isWhitelistedFactory(_factory),
234             "NOT_APPROVED_AUTHORITY"
235         );
236         _;
237     }
238 
239     modifier timeAtLeast(address _thePool) {
240         require(
241             now >= performers[_thePool].endTime,
242             "TIME_NOT_ENOUGH"
243         );
244         _;
245     }
246 
247     constructor(
248         address _rigoTokenAddress,
249         address _proofOfPerformance,
250         address _authority)
251         public
252     {
253         RIGOTOKENADDRESS = _rigoTokenAddress;
254         rigoblockDao = msg.sender;
255         proofOfPerformance = _proofOfPerformance;
256         authority = _authority;
257     }
258 
259     /*
260      * CORE FUNCTIONS
261      */
262     /// @dev Allows ProofOfPerformance to mint rewards
263     /// @param _thePool Address of the target pool
264     /// @param _reward Number of reward in Rigo tokens
265     /// @return Bool the transaction executed correctly
266     function mintInflation(address _thePool, uint256 _reward)
267         external
268         onlyProofOfPerformance
269         minimumRigo(_thePool)
270         timeAtLeast(_thePool)
271         returns (bool)
272     {
273         performers[_thePool].startTime = now;
274         performers[_thePool].endTime = now + period;
275         ++performers[_thePool].epoch;
276         uint256 reward = _reward * 95 / 100; //5% royalty to rigoblock dao
277         uint256 rigoblockReward = safeSub(_reward, reward);
278         RigoToken rigoToken = RigoToken(RIGOTOKENADDRESS);
279         rigoToken.mintToken(getPoolOwner(_thePool), reward);
280         rigoToken.mintToken(rigoblockDao, rigoblockReward);
281         return true;
282     }
283 
284     /// @dev Allows rigoblock dao to set the inflation factor for a group
285     /// @param _group Address of the group/factory
286     /// @param _inflationFactor Value of the reward factor
287     function setInflationFactor(address _group, uint256 _inflationFactor)
288         external
289         onlyRigoblockDao
290         isApprovedFactory(_group)
291     {
292         groups[_group].epochReward = _inflationFactor;
293     }
294 
295     /// @dev Allows rigoblock dao to set the minimum number of required tokens
296     /// @param _minimum Number of minimum tokens
297     function setMinimumRigo(uint256 _minimum)
298         external
299         onlyRigoblockDao
300     {
301         minimumGRG = _minimum;
302     }
303 
304     /// @dev Allows rigoblock dao to upgrade its address
305     /// @param _newRigoblock Address of the new rigoblock dao
306     function setRigoblock(address _newRigoblock)
307         external
308         onlyRigoblockDao
309     {
310         rigoblockDao = _newRigoblock;
311     }
312 
313     /// @dev Allows rigoblock dao to update the authority
314     /// @param _authority Address of the authority
315     function setAuthority(address _authority)
316         external
317         onlyRigoblockDao
318     {
319         authority = _authority;
320     }
321 
322     /// @dev Allows rigoblock dao to update proof of performance
323     /// @param _pop Address of the Proof of Performance contract
324     function setProofOfPerformance(address _pop)
325         external
326         onlyRigoblockDao
327     {
328         proofOfPerformance = _pop;
329     }
330 
331     /// @dev Allows rigoblock dao to set the minimum time between reward collection
332     /// @param _newPeriod Number of seconds between 2 rewards
333     /// @notice set period on shorter subsets of time for testing
334     function setPeriod(uint256 _newPeriod)
335         external
336         onlyRigoblockDao
337     {
338         period = _newPeriod;
339     }
340 
341     /*
342      * CONSTANT PUBLIC FUNCTIONS
343      */
344     /// @dev Returns whether a wizard can claim reward tokens
345     /// @param _thePool Address of the target pool
346     /// @return Bool the wizard can claim
347     function canWithdraw(address _thePool)
348         external
349         view
350         returns (bool)
351     {
352         if (now >= performers[_thePool].endTime) {
353             return true;
354         }
355     }
356 
357     /// @dev Returns how much time needed until next claim
358     /// @param _thePool Address of the target pool
359     /// @return Number in seconds
360     function timeUntilClaim(address _thePool)
361         external
362         view
363         returns (uint256)
364     {
365         if (now < performers[_thePool].endTime) {
366             return (performers[_thePool].endTime);
367         }
368     }
369 
370     /// @dev Return the reward factor for a group
371     /// @param _group Address of the group
372     /// @return Value of the reward factor
373     function getInflationFactor(address _group)
374         external
375         view
376         returns (uint256)
377     {
378         return groups[_group].epochReward;
379     }
380 
381     /*
382      * INTERNAL FUNCTIONS
383      */
384     /// @dev Returns the address of the pool owner
385     /// @param _ofPool Number of the registered pool
386     /// @return Address of the pool owner
387     function getPoolOwner(address _ofPool)
388         internal
389         view
390         returns (address)
391     {
392         return Owned(_ofPool).owner();
393     }
394 }