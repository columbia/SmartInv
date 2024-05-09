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
49 contract DeviceDataStorage is Ambi2EnabledFull {
50 
51     uint fee;
52     address feeReceiver;
53 
54     AssetProxyInterface public assetProxy;
55 
56     struct Storage {
57         address device;
58         bytes32 description;
59         uint number;
60         string additionalInfo;
61     }
62 
63     mapping (address => uint) public recordId;
64     mapping (address => mapping (uint => Storage)) public recording;
65 
66     event DataWasRecorded(address device, uint id, bytes32 description, uint number, string additionalInfo);
67 
68     function setAssetProxy(AssetProxyInterface _assetProxy) onlyRole('admin') returns(bool) {
69         assetProxy = AssetProxyInterface(_assetProxy);
70         return true;
71     }
72 
73     function setFeeRecieverValue(uint _fee, address _feeReceiver) onlyRole('admin') returns(bool) {
74         fee = _fee;
75         feeReceiver = _feeReceiver;
76         return true;
77     }
78 
79     function recordInfo(bytes32 _description, uint _number, string _additionalInfo) returns(bool) {
80         require(assetProxy.transferFromWithReference(msg.sender, feeReceiver, fee, 'storage'));
81 
82         recording[msg.sender][recordId[msg.sender]].device = msg.sender;
83         recording[msg.sender][recordId[msg.sender]].description = _description;
84         recording[msg.sender][recordId[msg.sender]].number = _number;
85         recording[msg.sender][recordId[msg.sender]].additionalInfo = _additionalInfo;
86         DataWasRecorded(msg.sender, recordId[msg.sender], _description, _number, _additionalInfo);
87         recordId[msg.sender]++;
88         return true;
89     }
90 
91     function deleteRecording(uint _id) returns(bool) {
92         delete recording[msg.sender][_id];
93         return true;
94     }
95 
96     function getRecording(address _device, uint _id) constant returns(address, bytes32, uint, string) {
97         Storage memory stor = recording[_device][_id];
98         return (stor.device, stor.description, stor.number, stor.additionalInfo);
99     }
100 }