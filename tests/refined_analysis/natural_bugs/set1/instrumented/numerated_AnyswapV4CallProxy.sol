1 // SPDX-License-Identifier: GPL-3.0-or-later
2 
3 pragma solidity 0.8.3;
4 
5 
6 contract AnyCallProxy {
7     // configurable delay for timelock functions
8     uint public delay = 2*24*3600;
9 
10     // primary controller of the token contract
11     address public mpc;
12     address public pendingMPC;
13     uint public delayMPC;
14 
15     uint public pendingDelay;
16     uint public delayDelay;
17 
18     modifier onlyMPC() {
19         require(msg.sender == mpc, "AnyswapCallProxy: FORBIDDEN");
20         _;
21     }
22 
23     function setMPC(address _mpc) external onlyMPC {
24         pendingMPC = _mpc;
25         delayMPC = block.timestamp + delay;
26         emit LogChangeMPC(mpc, pendingMPC, delayMPC);
27     }
28 
29     function applyMPC() external {
30         require(msg.sender == pendingMPC);
31         require(block.timestamp >= delayMPC);
32         mpc = pendingMPC;
33     }
34 
35     event LogChangeMPC(address indexed oldMPC, address indexed newMPC, uint indexed effectiveTime);
36     event LogAnyExec(address indexed from, address[] to, bytes[] data, bool[] success, bytes[] result, address[] callbacks, uint[] nonces, uint fromChainID, uint toChainID);
37     event LogAnyCall(address indexed from, address[] to, bytes[] data, address[] callbacks, uint[] nonces, uint fromChainID, uint toChainID);
38 
39     function cID() public view returns (uint id) {
40         assembly {id := chainid()}
41     }
42 
43     constructor(address _mpc) {
44         mpc = _mpc;
45     }
46     /*
47         @notice Trigger a cross-chain contract interaction
48         @param to - list of addresses to call
49         @param data - list of data payloads to send / call
50         @param callbacks - the callbacks on the fromChainID to call `callback(address to, bytes data, uint nonces, uint fromChainID, bool success, bytes result)`
51         @param nonces - the nonces (ordering) to include for the resulting callback
52         @param toChainID - the recipient chain that will receive the events
53     */
54     function anyCall(address[] memory to, bytes[] memory data, address[] memory callbacks, uint[] memory nonces, uint toChainID) external {
55         emit LogAnyCall(msg.sender, to, data, callbacks, nonces, cID(), toChainID);
56     }
57 
58     function anyCall(address from, address[] memory to, bytes[] memory data, address[] memory callbacks, uint[] memory nonces, uint fromChainID) external onlyMPC {
59         bool[] memory success = new bool[](to.length);
60         bytes[] memory results = new bytes[](to.length);
61         for (uint i = 0; i < to.length; i++) {
62             (success[i], results[i]) = to[i].call{value:0}(data[i]);
63         }
64         emit LogAnyExec(from, to, data, success, results, callbacks, nonces, fromChainID, cID());
65     }
66 
67     function encode(string memory signature, bytes memory data) external pure returns (bytes memory) {
68         return abi.encodePacked(bytes4(keccak256(bytes(signature))), data);
69     }
70 
71     function encodePermit(address target, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external pure returns (bytes memory) {
72         return abi.encodeWithSignature("permit(address,address,uint256,uint256,uint8,bytes32,bytes32)", target, spender, value, deadline, v, r, s);
73     }
74 
75     function encodeTransferFrom(address sender, address recipient, uint256 amount) external pure returns (bytes memory) {
76         return abi.encodeWithSignature("transferFrom(address,address,uint256)", sender, recipient, amount);
77     }
78 }
