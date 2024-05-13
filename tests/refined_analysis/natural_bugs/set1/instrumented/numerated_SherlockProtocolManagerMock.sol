1 // include claimPremiums func()
2 
3 // SPDX-License-Identifier: GPL-2.0-or-later
4 pragma solidity 0.8.10;
5 
6 /******************************************************************************\
7 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
8 * Sherlock Protocol: https://sherlock.xyz
9 /******************************************************************************/
10 
11 import '../managers/Manager.sol';
12 import '../interfaces/managers/ISherlockProtocolManager.sol';
13 
14 contract SherlockProtocolManagerMock is ISherlockProtocolManager, Manager {
15   uint256 amount;
16 
17   uint256 public claimCalled;
18 
19   IERC20 token;
20 
21   constructor(IERC20 _token) {
22     token = _token;
23   }
24 
25   function setAmount(uint256 _amount) external {
26     amount = _amount;
27   }
28 
29   function claimablePremiums() external view override returns (uint256) {}
30 
31   function claimPremiumsForStakers() external override {
32     token.transfer(msg.sender, amount);
33     claimCalled++;
34   }
35 
36   function protocolAgent(bytes32 _protocol) external view override returns (address) {}
37 
38   function premium(bytes32 _protocol) external view override returns (uint256) {}
39 
40   function activeBalance(bytes32 _protocol) external view override returns (uint256) {}
41 
42   function secondsOfCoverageLeft(bytes32 _protocol) external view override returns (uint256) {}
43 
44   function protocolAdd(
45     bytes32 _protocol,
46     address _protocolAgent,
47     bytes32 _coverage,
48     uint256 _nonStakers,
49     uint256 _coverageAmount
50   ) external override {}
51 
52   function protocolUpdate(
53     bytes32 _protocol,
54     bytes32 _coverage,
55     uint256 _nonStakers,
56     uint256 _coverageAmount
57   ) external override {}
58 
59   function protocolRemove(bytes32 _protocol) external override {}
60 
61   function forceRemoveByActiveBalance(bytes32 _protocol) external override {}
62 
63   function forceRemoveBySecondsOfCoverage(bytes32 _protocol) external override {}
64 
65   function minActiveBalance() external view override returns (uint256) {}
66 
67   function setMinActiveBalance(uint256 _minBalance) external override {}
68 
69   function setProtocolPremium(bytes32 _protocol, uint256 _premium) external override {}
70 
71   function setProtocolPremiums(bytes32[] calldata _protocol, uint256[] calldata _premium)
72     external
73     override
74   {}
75 
76   function depositToActiveBalance(bytes32 _protocol, uint256 _amount) external override {}
77 
78   function withdrawActiveBalance(bytes32 _protocol, uint256 _amount) external override {}
79 
80   function transferProtocolAgent(bytes32 _protocol, address _protocolAgent) external override {}
81 
82   function nonStakersClaimable(bytes32 _protocol) external view override returns (uint256) {}
83 
84   function nonStakersClaim(
85     bytes32 _protocol,
86     uint256 _amount,
87     address _receiver
88   ) external override {}
89 
90   function coverageAmounts(bytes32 _protocol)
91     external
92     view
93     override
94     returns (uint256 current, uint256 previous)
95   {}
96 
97   function isActive() external view override returns (bool) {}
98 }
