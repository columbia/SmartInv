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
55 contract EMONTInterface {
56     function balanceOf(address tokenOwner) public constant returns (uint balance);
57     function transfer(address to, uint tokens) public;
58 }
59 
60 contract CubegoCoreInterface {
61     function buyMaterials(address _owner, uint _mId1, uint _amount1, uint _mId2, uint _amount2, 
62                             uint _mId3, uint _amount3, uint _mId4, uint _amount4) external returns(uint);
63     function addMaterials(address _owner, uint _mId1, uint _amount1, uint _mId2, uint _amount2, 
64                             uint _mId3, uint _amount3, uint _mId4, uint _amount4) external;
65     function removeMaterials(address _owner, uint _mId1, uint _amount1, uint _mId2, uint _amount2, 
66                             uint _mId3, uint _amount3, uint _mId4, uint _amount4) external;
67 }
68 
69 contract CubegonNFTInterface {
70     function mineCubegon(address _owner, bytes32 _ch, uint _mId1, uint _amount1, uint _mId2, uint _amount2, 
71         uint _mId3, uint _amount3, uint _mId4, uint _amount4, uint _energyLimit) external returns(uint);
72     function updateCubegon(address _owner, uint _tokenId, uint _energyLimit) external;
73     function dismantleCubegon(address _owner, uint _tokenId) external returns(uint mId1, uint amount1, uint mId2, uint amount2,
74         uint mId3, uint amount3, uint mId4, uint amount4);
75 }
76 
77 contract CubegonBuilder is BasicAccessControl {
78     bytes constant SIG_PREFIX = "\x19Ethereum Signed Message:\n32";
79     
80     struct CubegonMaterial {
81         uint mId1;
82         uint amount1;
83         uint mId2;
84         uint amount2;
85         uint mId3;
86         uint amount3;
87         uint mId4;
88         uint amount4;
89         uint energyLimit;
90     }
91     
92     CubegoCoreInterface public cubegoCore;
93     CubegonNFTInterface public cubegonNFT;
94     EMONTInterface public emontToken;
95     address public verifyAddress;
96     mapping (uint => uint) public energyPrices;
97     uint public ethEmontRate = 1500 * 10 ** 8; // each 10 ** 18 ETH
98     
99     function setAddress(address _cubegoCoreAddress, address _emontTokenAddress, address _cubegonNFTAddress, address _verifyAddress) onlyModerators external {
100         cubegoCore = CubegoCoreInterface(_cubegoCoreAddress);
101         emontToken = EMONTInterface(_emontTokenAddress);
102         cubegonNFT = CubegonNFTInterface(_cubegonNFTAddress);
103         verifyAddress = _verifyAddress;
104     }
105     
106     function setEnergyPrice(uint _energy, uint _price) onlyModerators external {
107         energyPrices[_energy] = _price;
108     }
109     
110     function setConfig(uint _ethEmontRate) onlyModerators external {
111         ethEmontRate = _ethEmontRate;
112     }
113     
114     function withdrawEther(address _sendTo, uint _amount) onlyModerators public {
115         if (_amount > address(this).balance) {
116             revert();
117         }
118         _sendTo.transfer(_amount);
119     }
120     
121     function withdrawToken(address _sendTo, uint _amount) onlyModerators external {
122         if (_amount > emontToken.balanceOf(address(this))) {
123             revert();
124         }
125         emontToken.transfer(_sendTo, _amount);
126     }
127     
128     // emont payment
129     function updateCubegonEnergyLimitByToken(address _owner, uint _tokens, uint _tokenId, uint _energyLimit) onlyModerators external {
130         uint payAmount = energyPrices[_energyLimit];
131         if (payAmount == 0) revert();
132         uint payTokenAmount = payAmount * ethEmontRate / 10 ** 18;
133         if (payTokenAmount > _tokens) revert();
134         
135         cubegonNFT.updateCubegon(_owner, _tokenId, _energyLimit);
136     }
137     
138     // public 
139     function extractMaterialToken(bytes32 _mt) public pure returns(uint mId1, uint amount1, uint mId2, uint amount2, 
140         uint mId3, uint amount3, uint mId4, uint amount4) {
141         amount4 = uint32(_mt);
142         mId4 = uint32(_mt>>32);
143         amount3 = uint32(_mt>>64);
144         mId3 = uint32(_mt>>96);
145         amount2 = uint32(_mt>>128);
146         mId2 = uint32(_mt>>160);
147         amount1 = uint32(_mt>>192);
148         mId1 = uint32(_mt>>224);
149     }
150     
151     function getVerifySignature(address sender, bytes32 _ch, bytes32 _cmt, bytes32 _tmt, uint _energyLimit, uint _expiryTime) public pure returns(bytes32) {
152         return keccak256(abi.encodePacked(sender, _ch, _cmt, _tmt, _energyLimit, _expiryTime));
153     }
154     
155     function getVerifyAddress(address sender, bytes32 _ch, bytes32 _cmt, bytes32 _tmt, uint _energyLimit, uint _expiryTime, uint8 _v, bytes32 _r, bytes32 _s) public pure returns(address) {
156         bytes32 hashValue = keccak256(abi.encodePacked(sender, _ch, _cmt, _tmt, _energyLimit, _expiryTime));
157         bytes32 prefixedHash = keccak256(abi.encodePacked(SIG_PREFIX, hashValue));
158         return ecrecover(prefixedHash, _v, _r, _s);
159     }
160     
161     function createCubegon(bytes32 _ch, bytes32 _cmt, bytes32 _tmt, uint _energyLimit, uint _expiryTime, uint8 _v, bytes32 _r, bytes32 _s) isActive payable external {
162         if (verifyAddress == address(0)) revert();
163         if (_expiryTime < block.timestamp) revert();
164         if (getVerifyAddress(msg.sender, _ch, _cmt, _tmt, _energyLimit, _expiryTime, _v, _r, _s) != verifyAddress) revert();
165         uint payAmount = energyPrices[_energyLimit];
166         if (payAmount == 0 || payAmount > msg.value) revert();
167         
168         CubegonMaterial memory cm;
169         (cm.mId1, cm.amount1, cm.mId2, cm.amount2, cm.mId3, cm.amount3, cm.mId4, cm.amount4) = extractMaterialToken(_tmt);
170         payAmount += cubegoCore.buyMaterials(msg.sender, cm.mId1, cm.amount1, cm.mId2, cm.amount2, cm.mId3, cm.amount3, cm.mId4, cm.amount4);
171         if (payAmount > msg.value) revert();
172 
173         (cm.mId1, cm.amount1, cm.mId2, cm.amount2, cm.mId3, cm.amount3, cm.mId4, cm.amount4) = extractMaterialToken(_cmt);
174         cubegoCore.removeMaterials(msg.sender, cm.mId1, cm.amount1, cm.mId2, cm.amount2, cm.mId3, cm.amount3, cm.mId4, cm.amount4);
175         
176         // refund extra
177         if (msg.value > payAmount) {
178             msg.sender.transfer((msg.value - payAmount));
179         }
180         
181         cm.energyLimit = _energyLimit;
182         cubegonNFT.mineCubegon(msg.sender, _ch, cm.mId1, cm.amount1, cm.mId2, cm.amount2, cm.mId3, cm.amount3, cm.mId4, cm.amount4, cm.energyLimit);
183     }
184     
185     function dismantleCubegon(uint _tokenId) isActive external {
186         CubegonMaterial memory cm;
187         (cm.mId1, cm.amount1, cm.mId2, cm.amount2, cm.mId3, cm.amount3, cm.mId4, cm.amount4) = cubegonNFT.dismantleCubegon(msg.sender, _tokenId);
188         cubegoCore.addMaterials(msg.sender, cm.mId1, cm.amount1, cm.mId2, cm.amount2, cm.mId3, cm.amount3, cm.mId4, cm.amount4);
189     }
190     
191     function updateCubegonEnergyLimit(uint _tokenId, uint _energyLimit) isActive payable external {
192         uint payAmount = energyPrices[_energyLimit];
193         if (payAmount == 0) revert();
194         if (msg.value < payAmount) revert();
195         
196         cubegonNFT.updateCubegon(msg.sender, _tokenId, _energyLimit);
197         
198     }
199 }