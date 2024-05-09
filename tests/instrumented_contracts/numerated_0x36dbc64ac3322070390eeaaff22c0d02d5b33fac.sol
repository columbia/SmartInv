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
49 contract DeviceActivation is Ambi2EnabledFull {
50 
51     mapping (address => bool) activationStatus;
52 
53     event DeviceIsActivated(address device);
54     event DeviceIsDeactivated(address device);
55 
56     function activateDevice(address _device) onlyRole('admin') returns(bool) {
57         activationStatus[_device] = true;
58         DeviceIsActivated(_device);
59         return true;
60     }
61 
62     function deactivateDevice(address _device) onlyRole('admin') returns(bool) {
63         activationStatus[_device] = false;
64         DeviceIsDeactivated(_device);
65         return true;
66     }
67 
68     function isActivated(address _device) public constant returns (bool) {
69         return activationStatus[_device];
70     }
71 
72 }