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
55 contract CubegoPresale {
56     function buySinglePackByToken(address _buyer, uint _tokens, uint _packId, uint _amount) external;
57     function buyUltimatePackByToken(address _buyer, uint _tokens, uint _amount) external;
58 }
59 
60 contract CubegonNFT {
61     function updateCubegonEnergyLimitByToken(address _owner, uint _tokens, uint _tokenId, uint _energyLimit) external;
62 }
63 
64 contract CubegoEmontPayment is BasicAccessControl {
65     
66     CubegoPresale public cubegoPresale;
67     CubegonNFT public cubegoNFT;
68     
69     enum PayServiceType {
70         NONE,
71         PRESALE_SINGLE_PACK,
72         PRESALE_ULTIMATE_PACK,
73         CUBEGON_UPDATE_ENERGY
74     }
75     
76     function setContract(address _cubegoPresale, address _cubegoNFT) onlyModerators external {
77         cubegoPresale = CubegoPresale(_cubegoPresale);
78         cubegoNFT = CubegonNFT(_cubegoNFT);
79     } 
80     
81     function payService(address _player, uint _tokens, uint _param1, uint _param2, uint64 _param3, uint64 _param4) onlyModerators external {
82         if (_param1 == uint(PayServiceType.PRESALE_SINGLE_PACK)) {
83             cubegoPresale.buySinglePackByToken(_player, _tokens, _param2, _param3);
84         } else if (_param1 == uint(PayServiceType.PRESALE_ULTIMATE_PACK)) {
85             cubegoPresale.buyUltimatePackByToken(_player, _tokens, _param2);
86         } else if (_param1 == uint(PayServiceType.CUBEGON_UPDATE_ENERGY)) {
87             cubegoNFT.updateCubegonEnergyLimitByToken(_player, _tokens, _param2, _param3);
88         } else {
89             revert();
90         }
91     }
92 
93 }