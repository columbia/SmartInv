1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.19;
3 import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
4 import { Token } from "../token/Token.sol";
5 import { MAX_GAP } from "../utility/Constants.sol";
6 
7 struct Pool {
8     uint256 id;
9     Token[2] tokens;
10 }
11 
12 abstract contract Pools is Initializable {
13     struct StoredPool {
14         Token[2] tokens;
15     }
16 
17     error PoolAlreadyExists();
18     error PoolDoesNotExist();
19 
20     // unique incremental id representing a pool
21     uint256 private _lastPoolId;
22 
23     // mapping of pairs of tokens to their pool id, tokens are sorted at any order
24     mapping(Token => mapping(Token => uint256)) private _poolIds;
25 
26     // mapping between a poolId to its Pool object
27     mapping(uint256 => StoredPool) private _poolsStorage;
28 
29     // upgrade forward-compatibility storage gap
30     uint256[MAX_GAP - 3] private __gap;
31 
32     /**
33      * @dev triggered when a new pool is created
34      */
35     event PoolCreated(uint256 indexed poolId, Token indexed token0, Token indexed token1);
36 
37     // solhint-disable func-name-mixedcase
38 
39     /**
40      * @dev initializes the contract and its parents
41      */
42     function __Pools_init() internal onlyInitializing {
43         __Pools_init_unchained();
44     }
45 
46     /**
47      * @dev performs contract-specific initialization
48      */
49     function __Pools_init_unchained() internal onlyInitializing {}
50 
51     // solhint-enable func-name-mixedcase
52 
53     /**
54      * @dev generates and stores a new pool, tokens are assumed unique and valid
55      */
56     function _createPool(Token token0, Token token1) internal returns (Pool memory) {
57         // validate pool existance
58         if (_poolExists(token0, token1)) {
59             revert PoolAlreadyExists();
60         }
61 
62         // sort tokens
63         Token[2] memory sortedTokens = _sortTokens(token0, token1);
64 
65         // increment pool id
66         _lastPoolId++;
67         uint256 id = _lastPoolId;
68 
69         // store pool
70         StoredPool memory newPool = StoredPool({ tokens: sortedTokens });
71         _poolsStorage[id] = newPool;
72         _poolIds[sortedTokens[0]][sortedTokens[1]] = id;
73 
74         emit PoolCreated(id, newPool.tokens[0], newPool.tokens[1]);
75         return Pool({ id: id, tokens: sortedTokens });
76     }
77 
78     /**
79      * @dev return a pool matching the given tokens
80      */
81     function _pool(Token token0, Token token1) internal view returns (Pool memory) {
82         // sort tokens
83         Token[2] memory sortedTokens = _sortTokens(token0, token1);
84 
85         // validate pool existance
86         if (!_poolExists(token0, token1)) {
87             revert PoolDoesNotExist();
88         }
89 
90         // return pool
91         uint256 id = _poolIds[sortedTokens[0]][sortedTokens[1]];
92         return Pool({ id: id, tokens: sortedTokens });
93     }
94 
95     function _poolById(uint256 poolId) internal view returns (Pool memory) {
96         StoredPool memory storedPool = _poolsStorage[poolId];
97         if (address(storedPool.tokens[0]) == address(0)) {
98             revert PoolDoesNotExist();
99         }
100         return Pool({ id: poolId, tokens: storedPool.tokens });
101     }
102 
103     /**
104      * @dev check for the existance of a pool (pool id's are sequential intergers starting at 1)
105      */
106     function _poolExists(Token token0, Token token1) internal view returns (bool) {
107         // sort tokens
108         Token[2] memory sortedTokens = _sortTokens(token0, token1);
109 
110         if (_poolIds[sortedTokens[0]][sortedTokens[1]] == 0) {
111             return false;
112         }
113         return true;
114     }
115 
116     /**
117      * @dev returns a list of all supported pairs
118      */
119     function _pairs() internal view returns (Token[2][] memory) {
120         uint256 length = _lastPoolId;
121         Token[2][] memory list = new Token[2][](length);
122         for (uint256 i = 0; i < length; i++) {
123             StoredPool memory pool = _poolsStorage[i + 1];
124             list[i] = pool.tokens;
125         }
126 
127         return list;
128     }
129 
130     /**
131      * returns the given tokens sorted by address value, smaller first
132      */
133     function _sortTokens(Token token0, Token token1) private pure returns (Token[2] memory) {
134         return token0 < token1 ? [token0, token1] : [token1, token0];
135     }
136 }
