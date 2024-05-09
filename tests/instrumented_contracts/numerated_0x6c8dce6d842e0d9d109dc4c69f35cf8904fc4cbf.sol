1 pragma solidity ^0.4.19;
2 
3 // copyright contact@etheremon.com
4 
5 contract BasicAccessControl {
6     address public owner;
7     // address[] public moderators;
8     uint16 public totalModerators = 0;
9     mapping (address => bool) public moderators;
10     bool public isMaintaining = false;
11 
12     function BasicAccessControl() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     modifier onlyModerators() {
22         require(msg.sender == owner || moderators[msg.sender] == true);
23         _;
24     }
25 
26     modifier isActive {
27         require(!isMaintaining);
28         _;
29     }
30 
31     function ChangeOwner(address _newOwner) onlyOwner public {
32         if (_newOwner != address(0)) {
33             owner = _newOwner;
34         }
35     }
36 
37 
38     function AddModerator(address _newModerator) onlyOwner public {
39         if (moderators[_newModerator] == false) {
40             moderators[_newModerator] = true;
41             totalModerators += 1;
42         }
43     }
44     
45     function RemoveModerator(address _oldModerator) onlyOwner public {
46         if (moderators[_oldModerator] == true) {
47             moderators[_oldModerator] = false;
48             totalModerators -= 1;
49         }
50     }
51 
52     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
53         isMaintaining = _isMaintaining;
54     }
55 }
56 
57 
58 contract EtheremonEnergy is BasicAccessControl {
59     
60     struct Energy {
61         uint freeAmount;
62         uint paidAmount;
63         uint lastClaim;
64     }
65     
66     struct EnergyPackage {
67         uint ethPrice;
68         uint emontPrice;
69         uint energy;
70     }
71     
72     mapping(address => Energy) energyData;
73     mapping(uint => EnergyPackage) paidPackages;
74     uint public claimMaxAmount = 10;
75     uint public claimTime = 30 * 60; // in second
76     uint public claimAmount = 1;
77     
78     // address
79     address public paymentContract;
80     
81     // event
82     event EventEnergyUpdate(address indexed player, uint freeAmount, uint paidAmount, uint lastClaim);
83     
84     modifier requirePaymentContract {
85         require(paymentContract != address(0));
86         _;
87     }
88     
89     function EtheremonEnergy(address _paymentContract) public {
90         paymentContract = _paymentContract;
91     }
92     
93     // moderator
94     
95     function withdrawEther(address _sendTo, uint _amount) onlyModerators public {
96         if (_amount > address(this).balance) {
97             revert();
98         }
99         _sendTo.transfer(_amount);
100     }
101     
102     function setPaidPackage(uint _packId, uint _ethPrice, uint _emontPrice, uint _energy) onlyModerators external {
103         EnergyPackage storage pack = paidPackages[_packId];
104         pack.ethPrice = _ethPrice;
105         pack.emontPrice = _emontPrice;
106         pack.energy = _energy;
107     }
108     
109     function setConfig(address _paymentContract, uint _claimMaxAmount, uint _claimTime, uint _claimAmount) onlyModerators external {
110         paymentContract = _paymentContract;
111         claimMaxAmount = _claimMaxAmount;
112         claimTime = _claimTime;
113         claimAmount = _claimAmount;
114     }
115     
116     function topupEnergyByToken(address _player, uint _packId, uint _token) requirePaymentContract external {
117         if (msg.sender != paymentContract) revert();
118         EnergyPackage storage pack = paidPackages[_packId];
119         if (pack.energy == 0 || pack.emontPrice != _token)
120             revert();
121 
122         Energy storage energy = energyData[_player];
123         energy.paidAmount += pack.energy;
124         
125         EventEnergyUpdate(_player, energy.freeAmount, energy.paidAmount, energy.lastClaim);
126     }
127     
128     // public update
129     
130     function safeDeduct(uint _a, uint _b) pure public returns(uint) {
131         if (_a < _b) return 0;
132         return (_a - _b);
133     }
134     
135     function topupEnergy(uint _packId) isActive payable external {
136         EnergyPackage storage pack = paidPackages[_packId];
137         if (pack.energy == 0 || pack.ethPrice != msg.value)
138             revert();
139 
140         Energy storage energy = energyData[msg.sender];
141         energy.paidAmount += pack.energy;
142         
143         EventEnergyUpdate(msg.sender, energy.freeAmount, energy.paidAmount, energy.lastClaim);
144     }
145     
146     function claimEnergy() isActive external {
147         Energy storage energy = energyData[msg.sender];
148         uint period = safeDeduct(block.timestamp, energy.lastClaim);
149         uint energyAmount = (period / claimTime) * claimAmount;
150         
151         if (energyAmount == 0) revert();
152         if (energyAmount > claimMaxAmount) energyAmount = claimMaxAmount;
153         
154         energy.freeAmount += energyAmount;
155         energy.lastClaim = block.timestamp;
156         
157         EventEnergyUpdate(msg.sender, energy.freeAmount, energy.paidAmount, energy.lastClaim);
158     }
159     
160     // public get
161     function getPlayerEnergy(address _player) constant external returns(uint freeAmount, uint paidAmount, uint lastClaim) {
162         Energy storage energy = energyData[_player];
163         return (energy.freeAmount, energy.paidAmount, energy.lastClaim);
164     }
165     
166     function getClaimableAmount(address _trainer) constant external returns(uint) {
167         Energy storage energy = energyData[_trainer];
168         uint period = safeDeduct(block.timestamp, energy.lastClaim);
169         uint energyAmount = (period / claimTime) * claimAmount;
170         if (energyAmount > claimMaxAmount) energyAmount = claimMaxAmount;
171         return energyAmount;
172     }
173 }