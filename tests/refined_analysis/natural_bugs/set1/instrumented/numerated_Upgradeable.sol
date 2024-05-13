1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.19;
3 
4 import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
5 
6 import { IUpgradeable } from "./interfaces/IUpgradeable.sol";
7 
8 import { AccessDenied } from "./Utils.sol";
9 
10 import { MAX_GAP } from "./Constants.sol";
11 
12 /**
13  * @dev this contract provides common utilities for upgradeable contracts
14  *
15  * note that we're using the Transparent Upgradeable Proxy pattern and *not* the Universal Upgradeable Proxy Standard
16  * (UUPS) pattern, therefore initializing the implementation contracts is not necessary or required
17  */
18 abstract contract Upgradeable is IUpgradeable, AccessControlEnumerableUpgradeable {
19     error AlreadyInitialized();
20 
21     // the admin role is used to allow a non-proxy admin to perform additional initialization/setup during contract
22     // upgrades
23     bytes32 internal constant ROLE_ADMIN = keccak256("ROLE_ADMIN");
24 
25     uint16 internal _initializations;
26 
27     // upgrade forward-compatibility storage gap
28     uint256[MAX_GAP - 1] private __gap;
29 
30     // solhint-disable func-name-mixedcase
31 
32     /**
33      * @dev initializes the contract and its parents
34      */
35     function __Upgradeable_init() internal onlyInitializing {
36         __AccessControl_init();
37 
38         __Upgradeable_init_unchained();
39     }
40 
41     /**
42      * @dev performs contract-specific initialization
43      */
44     function __Upgradeable_init_unchained() internal onlyInitializing {
45         _initializations = 1;
46 
47         // set up administrative roles
48         _setRoleAdmin(ROLE_ADMIN, ROLE_ADMIN);
49 
50         // allow the deployer to initially be the admin of the contract
51         _setupRole(ROLE_ADMIN, msg.sender);
52     }
53 
54     // solhint-enable func-name-mixedcase
55 
56     modifier onlyAdmin() {
57         _hasRole(ROLE_ADMIN, msg.sender);
58 
59         _;
60     }
61 
62     modifier onlyRoleMember(bytes32 role) {
63         _hasRole(role, msg.sender);
64 
65         _;
66     }
67 
68     function version() public view virtual override returns (uint16);
69 
70     /**
71      * @dev returns the admin role
72      */
73     function roleAdmin() external pure returns (bytes32) {
74         return ROLE_ADMIN;
75     }
76 
77     /**
78      * @dev performs post-upgrade initialization
79      *
80      * requirements:
81      *
82      * - this must and can be called only once per-upgrade
83      */
84     function postUpgrade(bytes calldata data) external {
85         uint16 initializations = _initializations + 1;
86         if (initializations != version()) {
87             revert AlreadyInitialized();
88         }
89 
90         _initializations = initializations;
91 
92         _postUpgrade(data);
93     }
94 
95     /**
96      * @dev an optional post-upgrade callback that can be implemented by child contracts
97      */
98     function _postUpgrade(bytes calldata /* data */) internal virtual {}
99 
100     function _hasRole(bytes32 role, address account) internal view {
101         if (!hasRole(role, account)) {
102             revert AccessDenied();
103         }
104     }
105 }
