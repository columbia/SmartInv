1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
5 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
6 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
7 import "@openzeppelin/contracts/proxy/Clones.sol";
8 
9 import "../../interfaces/IStakerVault.sol";
10 import "../../interfaces/IVault.sol";
11 import "../../interfaces/ILpToken.sol";
12 import "../../interfaces/IAdmin.sol";
13 import "../../interfaces/IController.sol";
14 import "../../interfaces/pool/ILiquidityPool.sol";
15 import "../../interfaces/pool/IErc20Pool.sol";
16 import "../../interfaces/pool/IEthPool.sol";
17 
18 import "../../libraries/ScaledMath.sol";
19 import "../../libraries/AddressProviderHelpers.sol";
20 
21 import "../access/Authorization.sol";
22 
23 contract PoolFactory is Authorization {
24     using AddressProviderHelpers for IAddressProvider;
25 
26     struct Addresses {
27         address pool;
28         address vault;
29         address lpToken;
30         address stakerVault;
31     }
32 
33     struct ImplementationNames {
34         bytes32 pool;
35         bytes32 vault;
36         bytes32 lpToken;
37         bytes32 stakerVault;
38     }
39 
40     struct VaultArgs {
41         uint256 debtLimit;
42         uint256 targetAllocation;
43         uint256 bound;
44     }
45 
46     struct LpTokenArgs {
47         string name;
48         string symbol;
49         uint8 decimals;
50     }
51 
52     struct DeployPoolVars {
53         address lpTokenImplementation;
54         address poolImplementation;
55         address stakerVaultImplementation;
56         address vaultImplementation;
57     }
58 
59     bytes32 internal constant _POOL_KEY = "pool";
60     bytes32 internal constant _LP_TOKEN_KEY = "lp_token";
61     bytes32 internal constant _STAKER_VAULT_KEY = "staker_vault";
62     bytes32 internal constant _VAULT_KEY = "vault";
63 
64     IController public immutable controller;
65     IAddressProvider public immutable addressProvider;
66 
67     /**
68      * @dev maps a contract type (e.g. "pool" or "lp_token", as defined in constants above)
69      * to a mapping from an implementation name to the actual implementation
70      * The implementation name is decided when registering the implementation
71      * and can be arbitrary (e.g. "ERC20PoolV1")
72      */
73     mapping(bytes32 => mapping(bytes32 => address)) public implementations;
74 
75     event NewPool(address pool, address vault, address lpToken, address stakerVault);
76     event NewImplementation(bytes32 key, bytes32 name, address implementation);
77 
78     constructor(IController _controller)
79         Authorization(_controller.addressProvider().getRoleManager())
80     {
81         controller = IController(_controller);
82         addressProvider = IController(_controller).addressProvider();
83     }
84 
85     /**
86      * @notice Add a new pool implementation to the factory.
87      * @param name of the pool implementation.
88      * @param implementation of pool implementation to add.
89      */
90     function addPoolImplementation(bytes32 name, address implementation)
91         external
92         onlyGovernance
93         returns (bool)
94     {
95         return _addImplementation(_POOL_KEY, name, implementation);
96     }
97 
98     /**
99      * @notice Add a new LP token implementation to the factory.
100      * @param name of the LP token implementation.
101      * @param implementation of lp token implementation to add.
102      */
103     function addLpTokenImplementation(bytes32 name, address implementation)
104         external
105         onlyGovernance
106         returns (bool)
107     {
108         return _addImplementation(_LP_TOKEN_KEY, name, implementation);
109     }
110 
111     /**
112      * @notice Add a new vault implementation to the factory.
113      * @param name of the vault implementation.
114      * @param implementation of vault implementation to add.
115      */
116     function addVaultImplementation(bytes32 name, address implementation)
117         external
118         onlyGovernance
119         returns (bool)
120     {
121         return _addImplementation(_VAULT_KEY, name, implementation);
122     }
123 
124     /**
125      * @notice Add a new staker vault implementation to the factory.
126      * @param name of the staker vault implementation.
127      * @param implementation of staker vault implementation to add.
128      */
129     function addStakerVaultImplementation(bytes32 name, address implementation)
130         external
131         onlyGovernance
132         returns (bool)
133     {
134         return _addImplementation(_STAKER_VAULT_KEY, name, implementation);
135     }
136 
137     /**
138      * @notice Deploys a new pool and LP token.
139      * @dev Decimals is an argument as not all ERC20 tokens implement the ERC20Detailed interface.
140      *      An implementation where `getUnderlying()` returns the zero address is for ETH pools.
141      * @param poolName Name of the pool.
142      * @param underlying Address of the pool's underlying.
143      * @param lpTokenArgs Arguments to create the LP token for the pool
144      * @param vaultArgs Arguments to create the vault
145      * @param implementationNames Name of the implementations to use
146      * @return addrs Address of the deployed pool, address of the pool's deployed LP token.
147      */
148     function deployPool(
149         string calldata poolName,
150         uint256 depositCap,
151         address underlying,
152         LpTokenArgs calldata lpTokenArgs,
153         VaultArgs calldata vaultArgs,
154         ImplementationNames calldata implementationNames
155     ) external onlyGovernance returns (Addresses memory addrs) {
156         DeployPoolVars memory vars;
157 
158         vars.poolImplementation = implementations[_POOL_KEY][implementationNames.pool];
159         require(vars.poolImplementation != address(0), Error.INVALID_POOL_IMPLEMENTATION);
160 
161         vars.lpTokenImplementation = implementations[_LP_TOKEN_KEY][implementationNames.lpToken];
162         require(vars.lpTokenImplementation != address(0), Error.INVALID_LP_TOKEN_IMPLEMENTATION);
163 
164         vars.vaultImplementation = implementations[_VAULT_KEY][implementationNames.vault];
165         require(vars.vaultImplementation != address(0), Error.INVALID_VAULT_IMPLEMENTATION);
166 
167         vars.stakerVaultImplementation = implementations[_STAKER_VAULT_KEY][
168             implementationNames.stakerVault
169         ];
170         require(
171             vars.stakerVaultImplementation != address(0),
172             Error.INVALID_STAKER_VAULT_IMPLEMENTATION
173         );
174 
175         addrs.pool = Clones.clone(vars.poolImplementation);
176         addrs.vault = Clones.clone(vars.vaultImplementation);
177 
178         if (underlying == address(0)) {
179             // ETH pool
180             require(
181                 ILiquidityPool(vars.poolImplementation).getUnderlying() == address(0),
182                 Error.INVALID_POOL_IMPLEMENTATION
183             );
184             require(lpTokenArgs.decimals == 18, Error.INVALID_DECIMALS);
185             IEthPool(addrs.pool).initialize(poolName, depositCap, addrs.vault);
186         } else {
187             IErc20Pool(addrs.pool).initialize(poolName, underlying, depositCap, addrs.vault);
188         }
189 
190         addrs.lpToken = Clones.clone(vars.lpTokenImplementation);
191 
192         ILpToken(addrs.lpToken).initialize(
193             lpTokenArgs.name,
194             lpTokenArgs.symbol,
195             lpTokenArgs.decimals,
196             addrs.pool
197         );
198 
199         addrs.stakerVault = Clones.clone(vars.stakerVaultImplementation);
200         IStakerVault(addrs.stakerVault).initialize(addrs.lpToken);
201         controller.addStakerVault(addrs.stakerVault);
202 
203         ILiquidityPool(addrs.pool).setLpToken(addrs.lpToken);
204         ILiquidityPool(addrs.pool).setStaker();
205 
206         IVault(addrs.vault).initialize(
207             addrs.pool,
208             vaultArgs.debtLimit,
209             vaultArgs.targetAllocation,
210             vaultArgs.bound
211         );
212 
213         addressProvider.addPool(addrs.pool);
214 
215         emit NewPool(addrs.pool, addrs.vault, addrs.lpToken, addrs.stakerVault);
216         return addrs;
217     }
218 
219     /**
220      * @notice Add a new implementation of type `name` to the factory.
221      * @param key of the implementation to add.
222      * @param name of the implementation to add.
223      * @param implementation of lp token implementation to add.
224      */
225     function _addImplementation(
226         bytes32 key,
227         bytes32 name,
228         address implementation
229     ) internal returns (bool) {
230         mapping(bytes32 => address) storage currentImplementations = implementations[key];
231         if (currentImplementations[name] != address(0)) {
232             return false;
233         }
234         currentImplementations[name] = implementation;
235         emit NewImplementation(key, name, implementation);
236         return true;
237     }
238 }
