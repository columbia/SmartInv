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
45     function balanceOf(address _owner) constant returns(uint);
46     function transferFrom(address _from, address _to, uint _value) returns(bool);
47     function transferFromToICAP(address _from, bytes32 _icap, uint _value) returns(bool);
48     function transferFromWithReference(address _from, address _to, uint _value, string _reference) returns(bool);
49     function transfer(address _to, uint _value) returns(bool);
50     function transferToICAP(bytes32 _icap, uint _value) returns(bool);
51     function transferWithReference(address _to, uint _value, string _reference) returns(bool);
52     function totalSupply() constant returns(uint);
53     function approve(address _spender, uint _value) returns(bool);
54 }
55 
56 contract VestingInterface {
57     function createVesting(address _receiver, AssetProxyInterface _AssetProxy, uint _amount, uint _parts, uint _paymentInterval, uint _schedule) returns(bool);
58     function sendVesting(uint _id) returns(bool);
59     function getReceiverVesting(address _receiver, address _ERC20) constant returns(uint);
60 }
61 
62 contract CryptykVestingManager is Ambi2EnabledFull {
63 
64     AssetProxyInterface public assetProxy;
65     VestingInterface public vesting;
66 
67     uint public paymentInterval;
68     uint public schedule;
69     uint public presaleDeadline;
70 
71     function setVesting(VestingInterface _vesting) onlyRole('admin') returns(bool) {
72         require(address(vesting) == 0x0);
73 
74         vesting = _vesting;
75         return true;
76     }
77 
78     function setAssetProxy(AssetProxyInterface _assetProxy) onlyRole('admin') returns(bool) {
79         require(address(assetProxy) == 0x0);
80         require(address(vesting) != 0x0);
81 
82         assetProxy = _assetProxy;
83         assetProxy.approve(vesting, ((2 ** 256) - 1));
84         return true;
85     }
86 
87     function setIntervalSchedulePresale(uint _paymentInterval, uint _schedule, uint _presaleDeadline) onlyRole('admin') returns(bool) {
88         paymentInterval = _paymentInterval;
89         schedule = _schedule;
90         presaleDeadline = _presaleDeadline;
91         return true;
92     }
93 
94     function transfer(address _to, uint _value) returns(bool) {
95         if (now < presaleDeadline) {
96             require(assetProxy.transferFrom(msg.sender, address(this), _value));
97             require(vesting.createVesting(_to, assetProxy, _value, 1, paymentInterval, schedule));
98             return true;
99         }
100         return assetProxy.transferFrom(msg.sender, _to, _value);
101     }
102 
103     function transferToICAP(bytes32 _icap, uint _value) returns(bool) {
104         return assetProxy.transferFromToICAP(msg.sender, _icap, _value);
105     }
106 
107     function transferWithReference(address _to, uint _value, string _reference) returns(bool) {
108         if (now < presaleDeadline) {
109             require(assetProxy.transferFromWithReference(msg.sender, address(this), _value, _reference));
110             require(vesting.createVesting(_to, assetProxy, _value, 1, paymentInterval, schedule));
111             return true;
112         }
113         return assetProxy.transferFromWithReference(msg.sender, _to, _value, _reference);
114     }
115 
116     function balanceOf(address _address) constant returns(uint) {
117         return (vesting.getReceiverVesting(_address, assetProxy) + assetProxy.balanceOf(_address));
118     }
119 
120     function totalSupply() constant returns(uint) {
121         return assetProxy.totalSupply();
122     }
123 }