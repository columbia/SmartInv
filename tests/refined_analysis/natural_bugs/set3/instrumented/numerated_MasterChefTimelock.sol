1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.12;
4 
5 import '../core/Timelock.sol';
6 import './MasterChef.sol';
7 import '../interfaces/IBEP20.sol';
8 import 'hardhat/console.sol';
9 
10 contract MasterChefTimelock is Timelock {
11 
12     mapping(address => bool) public existsPools;
13     mapping(address => uint) public pidOfPool;
14     mapping(uint256 => bool) public isExcludedPidUpdate;
15     MasterChef masterChef;
16 
17     struct SetMigratorData {
18         address migrator;
19         uint timestamp;
20         bool exists;
21     }
22     SetMigratorData setMigratorData;
23 
24     struct TransferOwnershipData {
25         address newOwner;
26         uint timestamp;
27         bool exists;
28     }
29     TransferOwnershipData transferOwnershipData;
30 
31     struct TransferBabyTokenOwnershipData {
32         address newOwner;
33         uint timestamp;
34         bool exists;
35     }
36     TransferBabyTokenOwnershipData transferBabyTokenOwnerShipData;
37 
38     struct TransferSyrupTokenOwnershipData {
39         address newOwner;
40         uint timestamp;
41         bool exists;
42     }
43     TransferSyrupTokenOwnershipData transferSyrupTokenOwnerShipData;
44 
45     constructor(MasterChef masterChef_, address admin_, uint delay_) Timelock(admin_, delay_) {
46         require(address(masterChef_) != address(0), "illegal masterChef address");
47         require(admin_ != address(0), "illegal admin address");
48         masterChef = masterChef_;
49     }
50 
51     modifier onlyAdmin() {
52         require(msg.sender == admin, "Timelock::cancelTransaction: Call must come from admin.?");
53         _;
54     }
55 
56     function excludedPidUpdate(uint256 _pid) external onlyAdmin{
57         isExcludedPidUpdate[_pid] = true;
58     }
59     
60     function includePidUpdate(uint256 _pid) external onlyAdmin{
61         isExcludedPidUpdate[_pid] = false;
62     }
63     
64 
65     function addExistsPools(address pool, uint pid) external onlyAdmin {
66         require(existsPools[pool] == false, "Timelock:: pair already exists");
67         existsPools[pool] = true;
68         pidOfPool[pool] = pid;
69     }
70 
71     function delExistsPools(address pool) external onlyAdmin {
72         require(existsPools[pool] == true, "Timelock:: pair not exists");
73         delete existsPools[pool];
74         delete pidOfPool[pool];
75     }
76 
77     function updateMultiplier(uint256 multiplierNumber) external onlyAdmin {
78         masterChef.updateMultiplier(multiplierNumber);
79     }
80 
81     function add(uint256 _allocPoint, IBEP20 _lpToken, bool _withUpdate) external onlyAdmin {
82         require(address(_lpToken) != address(0), "_lpToken address cannot be 0");
83         require(existsPools[address(_lpToken)] == false, "Timelock:: pair already exists");
84         _lpToken.balanceOf(msg.sender);
85         uint pid = masterChef.poolLength();
86         masterChef.add(_allocPoint, _lpToken, false);
87         if(_withUpdate){
88             massUpdatePools();
89         }
90         pidOfPool[address(_lpToken)] = pid;
91         existsPools[address(_lpToken)] = true;
92     }
93 
94     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) external onlyAdmin {
95         require(_pid < masterChef.poolLength(), 'Pool does not exist');
96 
97         masterChef.set(_pid, _allocPoint, false);
98         if(_withUpdate){
99             massUpdatePools();
100         }
101     }
102 
103     function massUpdatePools() public {
104         uint256 length = masterChef.poolLength();
105         for (uint256 pid = 0; pid < length; ++pid) {
106             if(!isExcludedPidUpdate[pid]){
107                 masterChef.updatePool(pid);
108             }
109         }
110     }
111 
112     function setMigrator(IMigratorChef _migrator) external onlyAdmin {
113         require(address(_migrator) != address(0), "_migrator address cannot be 0");
114         if (setMigratorData.exists) {
115             cancelTransaction(address(masterChef), 0, "", abi.encodeWithSignature("setMigrator(address)", address(_migrator)), setMigratorData.timestamp);
116         }
117         queueTransaction(address(masterChef), 0, "", abi.encodeWithSignature("setMigrator(address)", address(_migrator)), block.timestamp + delay);
118         setMigratorData.migrator = address(_migrator);
119         setMigratorData.timestamp = block.timestamp + delay;
120         setMigratorData.exists = true;
121     }
122 
123     function executeSetMigrator() external onlyAdmin {
124         require(setMigratorData.exists, "Timelock::setMigrator not prepared");
125         executeTransaction(address(masterChef), 0, "", abi.encodeWithSignature("setMigrator(address)", address(setMigratorData.migrator)), setMigratorData.timestamp);
126         setMigratorData.migrator = address(0);
127         setMigratorData.timestamp = 0;
128         setMigratorData.exists = false;
129     }
130     /*
131     function transferBabyTokenOwnerShip(address newOwner_) external onlyAdmin { 
132         masterChef.transferBabyTokenOwnerShip(newOwner_);
133     }
134 
135     function transferSyrupOwnerShip(address newOwner_) external onlyAdmin { 
136         masterChef.transferSyrupOwnerShip(newOwner_);
137     }
138     */
139 
140     function transferBabyTokenOwnerShip(address newOwner) external onlyAdmin {
141         if (transferBabyTokenOwnerShipData.exists) {
142             cancelTransaction(address(masterChef), 0, "", abi.encodeWithSignature("transferBabyTokenOwnerShip(address)", transferBabyTokenOwnerShipData.newOwner), transferBabyTokenOwnerShipData.timestamp);
143         }
144         queueTransaction(address(masterChef), 0, "", abi.encodeWithSignature("transferBabyTokenOwnerShip(address)", address(newOwner)), block.timestamp + delay);
145         transferBabyTokenOwnerShipData.newOwner = newOwner;
146         transferBabyTokenOwnerShipData.timestamp = block.timestamp + delay;
147         transferBabyTokenOwnerShipData.exists = true;
148     }
149 
150     function executeTransferBabyOwnership() external onlyAdmin {
151         require(transferBabyTokenOwnerShipData.exists, "Timelock::setMigrator not prepared");
152         executeTransaction(address(masterChef), 0, "", abi.encodeWithSignature("transferBabyTokenOwnerShip(address)", address(transferBabyTokenOwnerShipData.newOwner)), transferBabyTokenOwnerShipData.timestamp);
153         transferBabyTokenOwnerShipData.newOwner = address(0);
154         transferBabyTokenOwnerShipData.timestamp = 0;
155         transferBabyTokenOwnerShipData.exists = false;
156     }
157 
158     function transferSyrupTokenOwnerShip(address newOwner) external onlyAdmin {
159         if (transferSyrupTokenOwnerShipData.exists) {
160             cancelTransaction(address(masterChef), 0, "", abi.encodeWithSignature("transferSyrupOwnerShip(address)", transferSyrupTokenOwnerShipData.newOwner), transferSyrupTokenOwnerShipData.timestamp);
161         }
162         queueTransaction(address(masterChef), 0, "", abi.encodeWithSignature("transferSyrupOwnerShip(address)", address(newOwner)), block.timestamp + delay);
163         transferSyrupTokenOwnerShipData.newOwner = newOwner;
164         transferSyrupTokenOwnerShipData.timestamp = block.timestamp + delay;
165         transferSyrupTokenOwnerShipData.exists = true;
166     }
167 
168     function executeTransferSyrupOwnership() external onlyAdmin {
169         require(transferSyrupTokenOwnerShipData.exists, "Timelock::setMigrator not prepared");
170         executeTransaction(address(masterChef), 0, "", abi.encodeWithSignature("transferSyrupOwnerShip(address)", address(transferSyrupTokenOwnerShipData.newOwner)), transferSyrupTokenOwnerShipData.timestamp);
171         transferSyrupTokenOwnerShipData.newOwner = address(0);
172         transferSyrupTokenOwnerShipData.timestamp = 0;
173         transferSyrupTokenOwnerShipData.exists = false;
174     }
175 
176     function transferOwnership(address newOwner) external onlyAdmin {
177         if (transferOwnershipData.exists) {
178             cancelTransaction(address(masterChef), 0, "", abi.encodeWithSignature("transferOwnership(address)", transferOwnershipData.newOwner), transferOwnershipData.timestamp);
179         }
180         queueTransaction(address(masterChef), 0, "", abi.encodeWithSignature("transferOwnership(address)", address(newOwner)), block.timestamp + delay);
181         transferOwnershipData.newOwner = newOwner;
182         transferOwnershipData.timestamp = block.timestamp + delay;
183         transferOwnershipData.exists = true;
184     }
185 
186     function executeTransferOwnership() external onlyAdmin {
187         require(transferOwnershipData.exists, "Timelock::setMigrator not prepared");
188         executeTransaction(address(masterChef), 0, "", abi.encodeWithSignature("transferOwnership(address)", address(transferOwnershipData.newOwner)), transferOwnershipData.timestamp);
189         transferOwnershipData.newOwner = address(0);
190         transferOwnershipData.timestamp = 0;
191         transferOwnershipData.exists = false;
192     }
193 
194 }
