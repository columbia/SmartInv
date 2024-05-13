1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 
6 import "@openzeppelin/contracts/access/AccessControl.sol";
7 import "@openzeppelin/contracts/access/Ownable.sol";
8 import "@openzeppelin/contracts/proxy/Clones.sol";
9 import "../interfaces/ISwap.sol";
10 import "../interfaces/IMetaSwap.sol";
11 import "../interfaces/IMetaSwapDeposit.sol";
12 import "../interfaces/IPoolRegistry.sol";
13 import "../interfaces/IMasterRegistry.sol";
14 
15 /**
16  * @title PermissionlessDeployer
17  * @notice Allows for anyone to indepentantly deploy pools and meta pools of given tokens. A user will set
18  * custom parameters for the pool such as the trading/admin fees, as well as the a-parameter.
19  *
20  * Ownership of the pools are given to the deploying address. Saddle will collect 50% of the trading fees earned
21  * by the pool.
22  */
23 contract PermissionlessDeployer is AccessControl {
24     IMasterRegistry public immutable MASTER_REGISTRY;
25     bytes32 public constant POOL_REGISTRY_NAME =
26         0x506f6f6c52656769737472790000000000000000000000000000000000000000;
27 
28     /// @notice Role responsible for managing target addresses
29     bytes32 public constant SADDLE_MANAGER_ROLE =
30         keccak256("SADDLE_MANAGER_ROLE");
31 
32     address public targetLPToken;
33     address public targetSwap;
34     address public targetMetaSwap;
35     address public targetMetaSwapDeposit;
36     string public constant LP_TOKEN_NAME0 = "Saddle ";
37     string public constant LP_TOKEN_NAME1 = " LP Token";
38 
39     IPoolRegistry public poolRegistryCached;
40 
41     /**
42      * @notice Emmited when a new pool is deployed
43      * @param deployer address of the deployer
44      * @param swapAddress address of the deployed pool
45      * @param pooledTokens, array of addresses of the tokens in the pool
46      */
47     event NewSwapPool(
48         address indexed deployer,
49         address swapAddress,
50         IERC20[] pooledTokens
51     );
52 
53     event NewClone(address indexed target, address cloneAddress);
54 
55     /**
56      * @notice Emmited when the pool registry cache is updated
57      * @param poolRegistry address of the current Saddle Pool Registry
58      */
59     event PoolRegistryUpdated(address indexed poolRegistry);
60     event TargetLPTokenUpdated(address indexed target);
61     event TargetSwapUpdated(address indexed target);
62     event TargetMetaSwapUpdated(address indexed target);
63     event TargetMetaSwapDepositUpdated(address indexed target);
64 
65     struct DeploySwapInput {
66         bytes32 poolName; // name of the pool
67         IERC20[] tokens; // array of addresses of the tokens in the pool
68         uint8[] decimals; // array of decimals of the tokens in the pool
69         string lpTokenSymbol; // symbol of the LPToken
70         uint256 a; // a-parameter of the pool
71         uint256 fee; // trading fee of the pool
72         uint256 adminFee; // admin fee of the pool
73         address owner; // owner address of the pool
74         uint8 typeOfAsset; // USD/BTC/ETH/OTHER
75     }
76 
77     struct DeployMetaSwapInput {
78         bytes32 poolName; // name of the pool
79         IERC20[] tokens; // array of addresses of the tokens in the pool
80         uint8[] decimals; // array of decimals of the tokens in the pool
81         string lpTokenSymbol; // symbol of the LPToken
82         uint256 a; // a-parameter of the pool
83         uint256 fee; // trading fee of the pool
84         uint256 adminFee; // admin fee of the pool
85         address baseSwap; // address of the basepool
86         address owner; // owner address of the pool
87         uint8 typeOfAsset; // USD/BTC/ETH/OTHER
88     }
89 
90     constructor(
91         address admin,
92         address _masterRegistry,
93         address _targetLPToken,
94         address _targetSwap,
95         address _targetMetaSwap,
96         address _targetMetaSwapDeposit
97     ) public payable {
98         require(admin != address(0), "admin == 0");
99         require(_masterRegistry != address(0), "masterRegistry == 0");
100 
101         _setupRole(DEFAULT_ADMIN_ROLE, admin);
102         _setupRole(SADDLE_MANAGER_ROLE, msg.sender);
103 
104         _setTargetLPToken(_targetLPToken);
105         _setTargetSwap(_targetSwap);
106         _setTargetMetaSwap(_targetMetaSwap);
107         _setTargetMetaSwapDeposit(_targetMetaSwapDeposit);
108 
109         MASTER_REGISTRY = IMasterRegistry(_masterRegistry);
110         _updatePoolRegistryCache(_masterRegistry);
111     }
112 
113     modifier onlyManager() {
114         require(hasRole(SADDLE_MANAGER_ROLE, msg.sender), "only manager");
115         _;
116     }
117 
118     /**
119      * @notice Uses openzeppelin's clone mechanism to clone an existing a pool for cheaper deployments.
120      * @param target the address of the target pool to be cloned
121      * @return newClone an address of the cloned pool
122      */
123     function clone(address target) public payable returns (address newClone) {
124         newClone = Clones.clone(target);
125         emit NewClone(target, newClone);
126     }
127 
128     /**
129      * @notice Deploys a new pool, adds an entry in the Saddle Pool Registry.
130      * @param input, a struct containing the input parameters for the pool to be deployed,
131      * must include a unique pool name.
132      * @return deployedSwap the address of the deployed pool.
133      */
134 
135     function deploySwap(DeploySwapInput memory input)
136         external
137         payable
138         returns (address deployedSwap)
139     {
140         require(
141             poolRegistryCached.poolsIndexOfNamePlusOne(input.poolName) == 0,
142             "pool name already exists"
143         );
144 
145         address swapClone = clone(targetSwap);
146 
147         ISwap(swapClone).initialize(
148             input.tokens,
149             input.decimals,
150             string(
151                 abi.encodePacked(
152                     LP_TOKEN_NAME0,
153                     input.lpTokenSymbol,
154                     LP_TOKEN_NAME1
155                 )
156             ),
157             input.lpTokenSymbol,
158             input.a,
159             input.fee,
160             input.adminFee,
161             targetLPToken
162         );
163         Ownable(swapClone).transferOwnership(input.owner);
164         (, , , , , , address lpToken) = ISwap(swapClone).swapStorage();
165 
166         IPoolRegistry.PoolData memory poolData = IPoolRegistry.PoolData({
167             poolAddress: swapClone,
168             lpToken: lpToken,
169             typeOfAsset: input.typeOfAsset,
170             poolName: input.poolName,
171             targetAddress: targetSwap,
172             tokens: input.tokens,
173             underlyingTokens: new IERC20[](0),
174             basePoolAddress: address(0),
175             metaSwapDepositAddress: address(0),
176             isSaddleApproved: false,
177             isRemoved: false,
178             isGuarded: false
179         });
180 
181         emit NewSwapPool(msg.sender, swapClone, input.tokens);
182 
183         poolRegistryCached.addCommunityPool(poolData);
184         return swapClone;
185     }
186 
187     /**
188      * @notice Deploys a new meta pool.
189      * @param input, a DeployMetaSwapInput struct containing the input parameters for the meta pool.
190      */
191     function deployMetaSwap(DeployMetaSwapInput memory input)
192         external
193         payable
194         returns (address deployedMetaSwap, address deployedMetaSwapDeposit)
195     {
196         require(
197             poolRegistryCached.poolsIndexOfNamePlusOne(input.poolName) == 0,
198             "pool name already exists"
199         );
200 
201         deployedMetaSwap = clone(targetMetaSwap);
202         IMetaSwap(deployedMetaSwap).initializeMetaSwap(
203             input.tokens,
204             input.decimals,
205             string(
206                 abi.encodePacked(
207                     LP_TOKEN_NAME0,
208                     input.lpTokenSymbol,
209                     LP_TOKEN_NAME1
210                 )
211             ),
212             input.lpTokenSymbol,
213             input.a,
214             input.fee,
215             input.adminFee,
216             targetLPToken,
217             ISwap(input.baseSwap)
218         );
219         (, , , , , , address lpToken) = ISwap(deployedMetaSwap).swapStorage();
220         Ownable(deployedMetaSwap).transferOwnership(input.owner);
221 
222         deployedMetaSwapDeposit = clone(targetMetaSwapDeposit);
223         IMetaSwapDeposit(deployedMetaSwapDeposit).initialize(
224             ISwap(input.baseSwap),
225             IMetaSwap(deployedMetaSwap),
226             IERC20(lpToken)
227         );
228 
229         IERC20[] memory baseTokens = poolRegistryCached.getTokens(
230             input.baseSwap
231         ); // revert if baseSwap is not registered
232         IERC20[] memory underlyingTokens = new IERC20[](
233             input.tokens.length - 1 + baseTokens.length
234         );
235         uint256 metaLPTokenIndex = input.tokens.length - 1;
236         for (uint256 i = 0; i < metaLPTokenIndex; i++) {
237             underlyingTokens[i] = input.tokens[i];
238         }
239         for (uint256 i = metaLPTokenIndex; i < underlyingTokens.length; i++) {
240             underlyingTokens[i] = baseTokens[i - metaLPTokenIndex];
241         }
242 
243         IPoolRegistry.PoolData memory poolData = IPoolRegistry.PoolData({
244             poolAddress: deployedMetaSwap,
245             lpToken: lpToken,
246             typeOfAsset: input.typeOfAsset,
247             poolName: input.poolName,
248             targetAddress: targetSwap,
249             tokens: input.tokens,
250             underlyingTokens: underlyingTokens,
251             basePoolAddress: input.baseSwap,
252             metaSwapDepositAddress: deployedMetaSwapDeposit,
253             isSaddleApproved: false,
254             isRemoved: false,
255             isGuarded: false
256         });
257 
258         emit NewSwapPool(msg.sender, deployedMetaSwap, input.tokens);
259         emit NewSwapPool(msg.sender, deployedMetaSwapDeposit, underlyingTokens);
260 
261         poolRegistryCached.addCommunityPool(poolData);
262     }
263 
264     /**
265      * @notice Updates cached address of the pool registry **should be onlymanager?
266      */
267     function updatePoolRegistryCache() external {
268         _updatePoolRegistryCache(address(MASTER_REGISTRY));
269     }
270 
271     function _updatePoolRegistryCache(address masterRegistry) internal {
272         poolRegistryCached = IPoolRegistry(
273             IMasterRegistry(masterRegistry).resolveNameToLatestAddress(
274                 POOL_REGISTRY_NAME
275             )
276         );
277     }
278 
279     function setTargetLPToken(address _targetLPToken)
280         external
281         payable
282         onlyManager
283     {
284         _setTargetLPToken(_targetLPToken);
285     }
286 
287     function _setTargetLPToken(address _targetLPToken) internal {
288         require(
289             address(_targetLPToken) != address(0),
290             "Target LPToken cannot be 0"
291         );
292         targetLPToken = _targetLPToken;
293         emit TargetLPTokenUpdated(_targetLPToken);
294     }
295 
296     function setTargetSwap(address _targetSwap) external payable onlyManager {
297         _setTargetSwap(_targetSwap);
298     }
299 
300     function _setTargetSwap(address _targetSwap) internal {
301         require(address(_targetSwap) != address(0), "Target Swap cannot be 0");
302         targetSwap = _targetSwap;
303         emit TargetSwapUpdated(_targetSwap);
304     }
305 
306     function setTargetMetaSwap(address _targetMetaSwap)
307         public
308         payable
309         onlyManager
310     {
311         _setTargetMetaSwap(_targetMetaSwap);
312     }
313 
314     function _setTargetMetaSwap(address _targetMetaSwap) internal {
315         require(
316             address(_targetMetaSwap) != address(0),
317             "Target MetaSwap cannot be 0"
318         );
319         targetMetaSwap = _targetMetaSwap;
320         emit TargetMetaSwapUpdated(_targetMetaSwap);
321     }
322 
323     function setTargetMetaSwapDeposit(address _targetMetaSwapDeposit)
324         external
325         payable
326         onlyManager
327     {
328         _setTargetMetaSwapDeposit(_targetMetaSwapDeposit);
329     }
330 
331     function _setTargetMetaSwapDeposit(address _targetMetaSwapDeposit)
332         internal
333     {
334         require(
335             address(_targetMetaSwapDeposit) != address(0),
336             "Target MetaSwapDeposit cannot be 0"
337         );
338         targetMetaSwapDeposit = _targetMetaSwapDeposit;
339         emit TargetMetaSwapDepositUpdated(_targetMetaSwapDeposit);
340     }
341 }
