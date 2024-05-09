1 pragma solidity 0.4.15;
2 
3 contract Ambi2 {
4     function claimFor(address _address, address _owner) returns(bool);
5     function hasRole(address _from, bytes32 _role, address _to) constant returns(bool);
6     function isOwner(address _node, address _owner) constant returns(bool);
7 }
8 
9 contract Ambi2Enabled {
10     Ambi2 ambi2;
11 
12     modifier onlyRole(bytes32 _role) {
13         if (address(ambi2) != 0x0 && ambi2.hasRole(this, _role, msg.sender)) {
14             _;
15         }
16     }
17 
18     // Perform only after claiming the node, or claim in the same tx.
19     function setupAmbi2(Ambi2 _ambi2) returns(bool) {
20         if (address(ambi2) != 0x0) {
21             return false;
22         }
23 
24         ambi2 = _ambi2;
25         return true;
26     }
27 }
28 
29 contract Ambi2EnabledFull is Ambi2Enabled {
30     // Setup and claim atomically.
31     function setupAmbi2(Ambi2 _ambi2) returns(bool) {
32         if (address(ambi2) != 0x0) {
33             return false;
34         }
35         if (!_ambi2.claimFor(this, msg.sender) && !_ambi2.isOwner(this, msg.sender)) {
36             return false;
37         }
38 
39         ambi2 = _ambi2;
40         return true;
41     }
42 }
43 
44 contract AssetProxyInterface {
45     function transferFromWithReference(address _from, address _to, uint _value, string _reference) returns(bool);
46 }
47 
48 contract DeviceActivationInterface {
49     function isActivated(address _device) public constant returns (bool);
50 }
51 
52 contract DeviceReputationInterface {
53     function getReputationProblems(address _device, string _description) public constant returns(bool);
54 }
55 
56 contract Statuses is Ambi2EnabledFull {
57 
58     DeviceActivationInterface public activation;
59     DeviceReputationInterface public reputation;
60 
61     event TransactionCancelled(address to, uint value, string reference, address sender);
62     event TransactionCancelledICAP(bytes32 icap, uint value, string reference, address sender);
63     event TransactionSucceeded(address to, uint value, string reference, address sender);
64     event TransactionSucceededICAP(bytes32 icap, uint value, string reference, address sender);
65 
66     function _isValidStatus(address _sender, string _reference) internal returns(bool) {
67         if (!activation.isActivated(_sender)) {
68             return false;
69         }
70         if (reputation.getReputationProblems(_sender, _reference)) {
71             return false;
72         }
73         return true;
74     }
75 
76     function setActivation(DeviceActivationInterface _activation) onlyRole('admin') returns(bool) {
77         activation = DeviceActivationInterface(_activation);
78         return true;
79     }
80 
81     function setReputation(DeviceReputationInterface _reputation) onlyRole('admin') returns(bool) {
82         reputation = DeviceReputationInterface(_reputation);
83         return true;
84     }
85 
86     function checkStatus(address _to, uint _value, string _reference, address _sender) returns(bool) {
87         if (_isValidStatus(_sender, _reference)) {
88             TransactionSucceeded(_to, _value, _reference, _sender);
89             return true;
90         }
91         TransactionCancelled(_to, _value, _reference, _sender);
92         return false;
93     }
94 
95     function checkStatusICAP(bytes32 _icap, uint _value, string _reference, address _sender) returns(bool) {
96         if (_isValidStatus(_sender, _reference)) {
97             TransactionSucceededICAP(_icap, _value, _reference, _sender);
98             return true;
99         }
100         TransactionCancelledICAP(_icap, _value, _reference, _sender);
101         return false;
102     }
103 }