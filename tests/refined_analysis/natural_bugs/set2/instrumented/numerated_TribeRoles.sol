1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 /**
5  @title Tribe DAO ACL Roles
6  @notice Holds a complete list of all roles which can be held by contracts inside Tribe DAO.
7          Roles are broken up into 3 categories:
8          * Major Roles - the most powerful roles in the Tribe DAO which should be carefully managed.
9          * Admin Roles - roles with management capability over critical functionality. Should only be held by automated or optimistic mechanisms
10          * Minor Roles - operational roles. May be held or managed by shorter optimistic timelocks or trusted multisigs.
11  */
12 library TribeRoles {
13     /*///////////////////////////////////////////////////////////////
14                                  Major Roles
15     //////////////////////////////////////////////////////////////*/
16 
17     /// @notice the ultimate role of Tribe. Controls all other roles and protocol functionality.
18     bytes32 internal constant GOVERNOR = keccak256("GOVERN_ROLE");
19 
20     /// @notice the protector role of Tribe. Admin of pause, veto, revoke, and minor roles
21     bytes32 internal constant GUARDIAN = keccak256("GUARDIAN_ROLE");
22 
23     /// @notice the role which can arbitrarily move PCV in any size from any contract
24     bytes32 internal constant PCV_CONTROLLER = keccak256("PCV_CONTROLLER_ROLE");
25 
26     /// @notice can mint FEI arbitrarily
27     bytes32 internal constant MINTER = keccak256("MINTER_ROLE");
28 
29     /// @notice Manages lower level - Admin and Minor - roles. Able to grant and revoke these
30     bytes32 internal constant ROLE_ADMIN = keccak256("ROLE_ADMIN");
31 
32     /*///////////////////////////////////////////////////////////////
33                                  Admin Roles
34     //////////////////////////////////////////////////////////////*/
35 
36     /// @notice has access to all admin functionality on pods
37     bytes32 internal constant POD_ADMIN = keccak256("POD_ADMIN");
38 
39     /// @notice capable of granting and revoking other TribeRoles from having veto power over a pod
40     bytes32 internal constant POD_VETO_ADMIN = keccak256("POD_VETO_ADMIN");
41 
42     /// @notice can manage the majority of Tribe protocol parameters
43     bytes32 internal constant PARAMETER_ADMIN = keccak256("PARAMETER_ADMIN");
44 
45     /// @notice manages the Collateralization Oracle as well as other protocol oracles.
46     bytes32 internal constant ORACLE_ADMIN = keccak256("ORACLE_ADMIN_ROLE");
47 
48     /// @notice manages TribalChief incentives and related functionality.
49     bytes32 internal constant TRIBAL_CHIEF_ADMIN = keccak256("TRIBAL_CHIEF_ADMIN_ROLE");
50 
51     /// @notice admin of the Tokemak PCV deposits
52     bytes32 internal constant TOKEMAK_DEPOSIT_ADMIN_ROLE = keccak256("TOKEMAK_DEPOSIT_ADMIN_ROLE");
53 
54     /// @notice admin of PCVGuardian
55     bytes32 internal constant PCV_GUARDIAN_ADMIN = keccak256("PCV_GUARDIAN_ADMIN_ROLE");
56 
57     /// @notice admin of the Fuse protocol
58     bytes32 internal constant FUSE_ADMIN = keccak256("FUSE_ADMIN");
59 
60     /// @notice admin of minting Fei for specific scoped contracts
61     bytes32 internal constant FEI_MINT_ADMIN = keccak256("FEI_MINT_ADMIN");
62 
63     /// @notice capable of admin functionality on PCVDeposits
64     bytes32 internal constant PCV_MINOR_PARAM_ROLE = keccak256("PCV_MINOR_PARAM_ROLE");
65 
66     /// @notice capable of setting FEI Minters within global rate limits and caps
67     bytes32 internal constant RATE_LIMITED_MINTER_ADMIN = keccak256("RATE_LIMITED_MINTER_ADMIN");
68 
69     /// @notice manages meta-governance actions, like voting & delegating.
70     /// Also used to vote for gauge weights & similar liquid governance things.
71     bytes32 internal constant METAGOVERNANCE_VOTE_ADMIN = keccak256("METAGOVERNANCE_VOTE_ADMIN");
72 
73     /// @notice allows to manage locking of vote-escrowed tokens, and staking/unstaking
74     /// governance tokens from a pre-defined contract in order to eventually allow voting.
75     /// Examples: ANGLE <> veANGLE, AAVE <> stkAAVE, CVX <> vlCVX, CRV > cvxCRV.
76     bytes32 internal constant METAGOVERNANCE_TOKEN_STAKING = keccak256("METAGOVERNANCE_TOKEN_STAKING");
77 
78     /// @notice manages whitelisting of gauges where the protocol's tokens can be staked
79     bytes32 internal constant METAGOVERNANCE_GAUGE_ADMIN = keccak256("METAGOVERNANCE_GAUGE_ADMIN");
80 
81     /// @notice capable of performing swaps on Balancer LBP Swapper
82     bytes32 internal constant SWAP_ADMIN_ROLE = keccak256("SWAP_ADMIN_ROLE");
83 
84     /// @notice capable of setting properties on Balancer BasePool utility wrapper
85     bytes32 internal constant BALANCER_MANAGER_ADMIN_ROLE = keccak256("BALANCER_MANAGER_ADMIN_ROLE");
86 
87     /*///////////////////////////////////////////////////////////////
88                                  Minor Roles
89     //////////////////////////////////////////////////////////////*/
90     bytes32 internal constant POD_METADATA_REGISTER_ROLE = keccak256("POD_METADATA_REGISTER_ROLE");
91 
92     /// @notice capable of engaging with Votium for voting incentives.
93     bytes32 internal constant VOTIUM_ADMIN_ROLE = keccak256("VOTIUM_ADMIN_ROLE");
94 
95     /// @notice capable of adding an address to multi rate limited
96     bytes32 internal constant ADD_MINTER_ROLE = keccak256("ADD_MINTER_ROLE");
97 
98     /// @notice capable of changing PCV Deposit and Global Rate Limited Minter in the PSM
99     bytes32 internal constant PSM_ADMIN_ROLE = keccak256("PSM_ADMIN_ROLE");
100 
101     /// @notice capable of moving PCV between safe addresses on the PCVGuardian
102     bytes32 internal constant PCV_SAFE_MOVER_ROLE = keccak256("PCV_SAFE_MOVER_ROLE");
103 }
