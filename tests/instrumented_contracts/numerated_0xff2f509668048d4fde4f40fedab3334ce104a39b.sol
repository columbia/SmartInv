1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.5;
3 
4 /**
5  * @title TieredCrowdfundStorage
6  * @author MirrorXYZ
7  */
8 contract TieredCrowdfundStorage {
9     // The two states that this contract can exist in. "FUNDING" allows
10     // contributors to add funds.
11     enum Status {FUNDING, TRADING}
12 
13     // ============ Constants ============
14 
15     // The factor by which ETH contributions will multiply into crowdfund tokens.
16     uint16 internal constant TOKEN_SCALE = 1000;
17     uint256 internal constant REENTRANCY_NOT_ENTERED = 1;
18     uint256 internal constant REENTRANCY_ENTERED = 2;
19     uint8 public constant decimals = 18;
20 
21     // ============ Immutable Storage ============
22 
23     // The operator has a special role to change contract status.
24     address payable public operator;
25     address payable public fundingRecipient;
26     // We add a hard cap to prevent raising more funds than deemed reasonable.
27     uint256 public fundingCap;
28     // The operator takes some equity in the tokens, represented by this percent.
29     uint256 public operatorPercent;
30     string public symbol;
31     string public name;
32 
33     // ============ Mutable Storage ============
34 
35     // Represents the current state of the campaign.
36     Status public status;
37     uint256 internal reentrancy_status;
38 
39     // ============ Mutable ERC20 Attributes ============
40 
41     uint256 public totalSupply;
42     mapping(address => uint256) public balanceOf;
43     mapping(address => mapping(address => uint256)) public allowance;
44     mapping(address => uint256) public nonces;
45 
46     // ============ Delegation logic ============
47     address public logic;
48 
49     // ============ Tiered Campaigns ============
50     // Address of the editions contract to purchase from.
51     address public editions;
52 }
53 
54 
55 // File contracts/TieredCrowdfundProxy.sol
56 
57 
58 interface ITieredCrowdfundFactory {
59     function mediaAddress() external returns (address);
60 
61     function logic() external returns (address);
62 
63     function editions() external returns (address);
64 
65     // ERC20 data.
66     function parameters()
67         external
68         returns (
69             address payable operator,
70             address payable fundingRecipient,
71             uint256 fundingCap,
72             uint256 operatorPercent,
73             string memory name,
74             string memory symbol
75         );
76 }
77 
78 /**
79  * @title TieredCrowdfundProxy
80  * @author MirrorXYZ
81  */
82 contract TieredCrowdfundProxy is TieredCrowdfundStorage {
83     constructor() {
84         logic = ITieredCrowdfundFactory(msg.sender).logic();
85         editions = ITieredCrowdfundFactory(msg.sender).editions();
86         // Crowdfund-specific data.
87         (
88             operator,
89             fundingRecipient,
90             fundingCap,
91             operatorPercent,
92             name,
93             symbol
94         ) = ITieredCrowdfundFactory(msg.sender).parameters();
95         // Initialize mutable storage.
96         status = Status.FUNDING;
97     }
98 
99     fallback() external payable {
100         address _impl = logic;
101         assembly {
102             let ptr := mload(0x40)
103             calldatacopy(ptr, 0, calldatasize())
104             let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
105             let size := returndatasize()
106             returndatacopy(ptr, 0, size)
107 
108             switch result
109                 case 0 {
110                     revert(ptr, size)
111                 }
112                 default {
113                     return(ptr, size)
114                 }
115         }
116     }
117 
118     receive() external payable {}
119 }