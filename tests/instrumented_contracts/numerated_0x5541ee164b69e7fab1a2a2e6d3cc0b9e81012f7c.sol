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
29 
30 contract Ambi2EnabledFull is Ambi2Enabled {
31     // Setup and claim atomically.
32     function setupAmbi2(Ambi2 _ambi2) returns(bool) {
33         if (address(ambi2) != 0x0) {
34             return false;
35         }
36         if (!_ambi2.claimFor(this, msg.sender) && !_ambi2.isOwner(this, msg.sender)) {
37             return false;
38         }
39 
40         ambi2 = _ambi2;
41         return true;
42     }
43 }
44 
45 contract AssetProxyInterface {
46     function transferFromWithReference(address _from, address _to, uint _value, string _reference) returns(bool);
47 }
48 
49 contract DeviceActivationInterface {
50     function isActivated(address _device) public constant returns (bool);
51 }
52 
53 contract DeviceReputationInterface {
54     function getReputationProblems(address _device, string _description) public constant returns(bool);
55 }
56 
57 contract Statuses is Ambi2EnabledFull {
58 
59     DeviceActivationInterface public activation;
60     DeviceReputationInterface public reputation;
61 
62     function _isValidStatus(address _sender, string _reference) internal returns(bool) {
63         if (!activation.isActivated(_sender)) {
64             return false;
65         }
66         if (reputation.getReputationProblems(_sender, _reference)) {
67             return false;
68         }
69         return true;
70     }
71 
72     function setActivation(DeviceActivationInterface _activation) onlyRole('admin') returns(bool) {
73         activation = DeviceActivationInterface(_activation);
74         return true;
75     }
76 
77     function setReputation(DeviceReputationInterface _reputation) onlyRole('admin') returns(bool) {
78         reputation = DeviceReputationInterface(_reputation);
79         return true;
80     }
81 
82     function checkStatus(address _to, uint _value, string _reference, address _sender) returns(bool) {
83         return _isValidStatus(_sender, _reference);
84     }
85 
86     function checkStatusICAP(bytes32 _icap, uint _value, string _reference, address _sender) returns(bool) {
87         return _isValidStatus(_sender, _reference);
88     }
89 }