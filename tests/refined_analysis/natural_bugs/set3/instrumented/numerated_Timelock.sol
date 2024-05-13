1 // SPDX-License-Identifier: MIT
2 
3 // COPIED FROM https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/GovernorAlpha.sol
4 // Copyright 2020 Compound Labs, Inc.
5 // Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
6 // 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
7 // 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
8 // 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
9 // THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
10 //
11 // Ctrl+f for XXX to see all the modifications.
12 
13 // XXX: pragma solidity ^0.5.16;
14 pragma solidity >=0.6.12;
15 
16 // XXX: import "./SafeMath.sol";
17 import "../libraries/SafeMath.sol";
18 
19 contract Timelock {
20     using SafeMath for uint;
21 
22     event NewAdmin(address indexed newAdmin);
23     event NewPendingAdmin(address indexed newPendingAdmin);
24     event NewDelay(uint indexed newDelay);
25     event CancelTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature,  bytes data, uint eta);
26     event ExecuteTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature,  bytes data, uint eta);
27     event QueueTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature, bytes data, uint eta);
28 
29     uint public constant GRACE_PERIOD = 14 days;
30     uint public constant MINIMUM_DELAY = 6 hours;
31     uint public constant MAXIMUM_DELAY = 30 days;
32 
33     address public admin;
34     address public pendingAdmin;
35     uint public delay;
36     bool public admin_initialized;
37 
38     mapping (bytes32 => bool) public queuedTransactions;
39 
40 
41     constructor(address admin_, uint delay_) {
42         require(delay_ >= MINIMUM_DELAY, "Timelock::constructor: Delay must exceed minimum delay.");
43         require(delay_ <= MAXIMUM_DELAY, "Timelock::constructor: Delay must not exceed maximum delay.");
44 
45         admin = admin_;
46         delay = delay_;
47         admin_initialized = false;
48     }
49 
50     // XXX: function() external payable { }
51     receive() external payable { }
52 
53     function setDelay(uint delay_) public {
54         require(msg.sender == address(this), "Timelock::setDelay: Call must come from Timelock.");
55         require(delay_ >= MINIMUM_DELAY, "Timelock::setDelay: Delay must exceed minimum delay.");
56         require(delay_ <= MAXIMUM_DELAY, "Timelock::setDelay: Delay must not exceed maximum delay.");
57         delay = delay_;
58 
59         emit NewDelay(delay);
60     }
61 
62     function acceptAdmin() public {
63         require(msg.sender == pendingAdmin, "Timelock::acceptAdmin: Call must come from pendingAdmin.");
64         admin = msg.sender;
65         pendingAdmin = address(0);
66 
67         emit NewAdmin(admin);
68     }
69 
70     function setPendingAdmin(address pendingAdmin_) public {
71         // allows one time setting of admin for deployment purposes
72         if (admin_initialized) {
73             require(msg.sender == address(this), "Timelock::setPendingAdmin: Call must come from Timelock.");
74         } else {
75             require(msg.sender == admin, "Timelock::setPendingAdmin: First call must come from admin.");
76             admin_initialized = true;
77         }
78         pendingAdmin = pendingAdmin_;
79 
80         emit NewPendingAdmin(pendingAdmin);
81     }
82 
83     function queueTransaction(address target, uint value, string memory signature, bytes memory data, uint eta) public returns (bytes32) {
84         require(msg.sender == admin, "Timelock::queueTransaction: Call must come from admin.");
85         require(eta >= getBlockTimestamp().add(delay), "Timelock::queueTransaction: Estimated execution block must satisfy delay.");
86 
87         bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));
88         queuedTransactions[txHash] = true;
89 
90         emit QueueTransaction(txHash, target, value, signature, data, eta);
91         return txHash;
92     }
93 
94     function cancelTransaction(address target, uint value, string memory signature, bytes memory data, uint eta) public {
95         require(msg.sender == admin, "Timelock::cancelTransaction: Call must come from admin.");
96 
97         bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));
98         queuedTransactions[txHash] = false;
99 
100         emit CancelTransaction(txHash, target, value, signature, data, eta);
101     }
102 
103     function executeTransaction(address target, uint value, string memory signature, bytes memory data, uint eta) public payable returns (bytes memory) {
104         require(msg.sender == admin, "Timelock::executeTransaction: Call must come from admin.");
105 
106         bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));
107         require(queuedTransactions[txHash], "Timelock::executeTransaction: Transaction hasn't been queued.");
108         require(getBlockTimestamp() >= eta, "Timelock::executeTransaction: Transaction hasn't surpassed time lock.");
109         require(getBlockTimestamp() <= eta.add(GRACE_PERIOD), "Timelock::executeTransaction: Transaction is stale.");
110 
111         queuedTransactions[txHash] = false;
112 
113         bytes memory callData;
114 
115         if (bytes(signature).length == 0) {
116             callData = data;
117         } else {
118             callData = abi.encodePacked(bytes4(keccak256(bytes(signature))), data);
119         }
120 
121         // solium-disable-next-line security/no-call-value
122         (bool success, bytes memory returnData) = target.call{value: value}(callData);
123         require(success, "Timelock::executeTransaction: Transaction execution reverted.");
124 
125         emit ExecuteTransaction(txHash, target, value, signature, data, eta);
126 
127         return returnData;
128     }
129 
130     function getBlockTimestamp() internal view returns (uint) {
131         // solium-disable-next-line security/no-block-members
132         return block.timestamp;
133     }
134 }
