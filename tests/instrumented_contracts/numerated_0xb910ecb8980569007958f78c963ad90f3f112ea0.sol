1 pragma solidity ^0.4.24;
2 
3 contract BasicAccessControl {
4     address public owner;
5     // address[] public moderators;
6     uint16 public totalModerators = 0;
7     mapping (address => bool) public moderators;
8     bool public isMaintaining = false;
9 
10     constructor() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     modifier onlyModerators() {
20         require(msg.sender == owner || moderators[msg.sender] == true);
21         _;
22     }
23 
24     modifier isActive {
25         require(!isMaintaining);
26         _;
27     }
28 
29     function ChangeOwner(address _newOwner) onlyOwner public {
30         if (_newOwner != address(0)) {
31             owner = _newOwner;
32         }
33     }
34 
35 
36     function AddModerator(address _newModerator) onlyOwner public {
37         if (moderators[_newModerator] == false) {
38             moderators[_newModerator] = true;
39             totalModerators += 1;
40         }
41     }
42 
43     function RemoveModerator(address _oldModerator) onlyOwner public {
44         if (moderators[_oldModerator] == true) {
45             moderators[_oldModerator] = false;
46             totalModerators -= 1;
47         }
48     }
49 
50     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
51         isMaintaining = _isMaintaining;
52     }
53 }
54 
55 contract CubegoCoreInterface {
56     function getMaterialSupply(uint _mId) constant external returns(uint);
57     function getMyMaterialById(address _owner, uint _mId) constant external returns(uint);
58     function mineMaterial(address _owner, uint _mId, uint _amount) external;
59 }
60 
61 
62 /*
63 12 Diamond
64 11 Gold
65 10 Ice
66 9 Silver
67 8 Iron
68 7 Stone
69 6 Wood
70 5 Brick
71 4 Leaf
72 3 Fur
73 2 Paper
74 0 Plastic
75 */
76 
77 
78 contract CubegoStarterClaim is BasicAccessControl {
79     mapping (address => bool) private _claimed;
80     CubegoCoreInterface public cubegoCore;
81     uint public mId = 0;
82     uint public mAmount = 50;
83     uint public claimedCount = 0;
84 
85     function setConfig(address _cubegoCoreAddress, uint _mid, uint _mAmount) onlyModerators external {
86         cubegoCore = CubegoCoreInterface(_cubegoCoreAddress);
87         mId = _mid;
88         mAmount = _mAmount;
89     }
90 
91     function getClaimStatus(address _player) constant public returns (bool) {
92         return _claimed[_player];
93     }
94 
95     function getClaimedCount() constant public returns (uint) {
96         return claimedCount;
97     }
98 
99     function claimStarterPack() public isActive returns (bool) {
100         if (_claimed[msg.sender]) revert();
101         cubegoCore.mineMaterial(msg.sender, mId, mAmount);
102         _claimed[msg.sender] = true;
103         claimedCount += 1;
104         return true;
105     }
106 }