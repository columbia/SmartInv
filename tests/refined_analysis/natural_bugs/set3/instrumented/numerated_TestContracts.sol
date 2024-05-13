1 // SPDX-License-Identifier: LGPL-3.0-only
2 pragma solidity 0.8.11;
3 pragma experimental ABIEncoderV2;
4 
5 import "./utils/SafeCast.sol";
6 import "./handlers/HandlerHelpers.sol";
7 
8 contract NoArgument {
9     event NoArgumentCalled();
10 
11     function noArgument() external {
12         emit NoArgumentCalled();
13     }
14 }
15 
16 contract OneArgument {
17     event OneArgumentCalled(uint256 indexed argumentOne);
18 
19     function oneArgument(uint256 argumentOne) external {
20         emit OneArgumentCalled(argumentOne);
21     }
22 }
23 
24 contract TwoArguments {
25     event TwoArgumentsCalled(address[] argumentOne, bytes4 argumentTwo);
26 
27     function twoArguments(address[] calldata argumentOne, bytes4 argumentTwo) external {
28         emit TwoArgumentsCalled(argumentOne, argumentTwo);
29     }
30 }
31 
32 contract ThreeArguments {
33     event ThreeArgumentsCalled(string argumentOne, int8 argumentTwo, bool argumentThree);
34 
35     function threeArguments(string calldata argumentOne, int8 argumentTwo, bool argumentThree) external {
36         emit ThreeArgumentsCalled(argumentOne, argumentTwo, argumentThree);
37     }
38 }
39 
40 contract WithDepositer {
41     event WithDepositerCalled(address argumentOne, uint256 argumentTwo);
42 
43     function withDepositer(address argumentOne, uint256 argumentTwo) external {
44         emit WithDepositerCalled(argumentOne, argumentTwo);
45     }
46 }
47 
48 contract SafeCaster {
49     using SafeCast for *;
50 
51     function toUint200(uint input) external pure returns(uint200) {
52         return input.toUint200();
53     }
54 }
55 
56 contract ReturnData {
57     function returnData(string memory argument) external pure returns(bytes32 response) {
58         assembly {
59             response := mload(add(argument, 32))
60         }
61     }
62 }
63 
64 contract HandlerRevert is HandlerHelpers {
65     uint private _totalAmount;
66 
67     constructor(
68         address          bridgeAddress
69     ) public HandlerHelpers(bridgeAddress) {
70     }
71 
72     function executeProposal(bytes32, bytes calldata) external view {
73         if (_totalAmount == 0) {
74             revert('Something bad happened');
75         }
76         return;
77     }
78 
79     function virtualIncreaseBalance(uint amount) external {
80         _totalAmount = amount;
81     }
82 }
83 
84 contract TestForwarder {
85     function execute(bytes memory data, address to, address sender) external {
86         bytes memory callData = abi.encodePacked(data, sender);
87         (bool success, ) = to.call(callData);
88         require(success, "Relay call failed");
89     }
90 }
91 
92 contract TestTarget {
93     uint public calls = 0;
94     uint public gasLeft;
95     bytes public data;
96     bool public burnAllGas;
97     fallback() external payable {
98         gasLeft = gasleft();
99         calls++;
100         data = msg.data;
101         if (burnAllGas) {
102             assert(false);
103         }
104     }
105 
106     function setBurnAllGas() public {
107         burnAllGas = true;
108     }
109 }
