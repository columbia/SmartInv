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
55 contract CubegoERC20 {
56     function emitTransferEvent(address from, address to, uint tokens) external;
57 }
58 
59 contract CubegoCore is BasicAccessControl {
60     uint constant MAX_MATERIAL = 32;
61     
62     struct MaterialData {
63         uint price;
64         uint totalSupply;
65         CubegoERC20 erc20;
66     }
67     
68     MaterialData[MAX_MATERIAL] public materials;
69     mapping(address => uint[MAX_MATERIAL]) public myMaterials;
70     
71     function setMaterialData(uint _mId, uint _price, address _erc20Address) onlyModerators external {
72         MaterialData storage material = materials[_mId];
73         material.price = _price;
74         material.erc20 = CubegoERC20(_erc20Address);
75     }
76     
77     function mineMaterial(address _owner, uint _mId, uint _amount) onlyModerators external {
78         myMaterials[_owner][_mId] += _amount;
79         MaterialData storage material = materials[_mId];
80         material.totalSupply += _amount;
81         material.erc20.emitTransferEvent(address(0), _owner, _amount);
82     }
83     
84     function transferMaterial(address _sender, address _receiver, uint _mId, uint _amount) onlyModerators external {
85         if (myMaterials[_sender][_mId] < _amount) revert();
86         myMaterials[_sender][_mId] -= _amount;
87         myMaterials[_receiver][_mId] += _amount;
88         materials[_mId].erc20.emitTransferEvent(_sender, _receiver, _amount);
89     }
90 
91     function buyMaterials(address _owner, uint _mId1, uint _amount1, uint _mId2, uint _amount2, 
92                             uint _mId3, uint _amount3, uint _mId4, uint _amount4) onlyModerators external returns(uint) {
93         uint totalPrice = 0;
94         MaterialData storage material = materials[_mId1];
95         
96         if (_mId1 > 0) {
97             if (material.price == 0) revert();
98             myMaterials[_owner][_mId1] += _amount1;
99             totalPrice += material.price * _amount1;
100             material.totalSupply += _amount1;
101             material.erc20.emitTransferEvent(address(0), _owner, _amount1);
102         }
103         if (_mId2 > 0) {
104             material = materials[_mId2];
105             if (material.price == 0) revert();
106             myMaterials[_owner][_mId2] += _amount2;
107             totalPrice += material.price * _amount2;
108             material.totalSupply += _amount1;
109             material.erc20.emitTransferEvent(address(0), _owner, _amount2);
110         }
111         if (_mId3 > 0) {
112             material = materials[_mId3];
113             if (material.price == 0) revert();
114             myMaterials[_owner][_mId3] += _amount3;
115             totalPrice += material.price * _amount3;
116             material.totalSupply += _amount1;
117             material.erc20.emitTransferEvent(address(0), _owner, _amount3);
118         }
119         if (_mId4 > 0) {
120             material = materials[_mId3];
121             if (material.price == 0) revert();
122             myMaterials[_owner][_mId4] += _amount4;
123             totalPrice += material.price * _amount4;
124             material.totalSupply += _amount1;
125             material.erc20.emitTransferEvent(address(0), _owner, _amount4);
126         }
127     
128         return totalPrice;
129     }
130     
131     // dismantle cubegon
132     function addMaterials(address _owner, uint _mId1, uint _amount1, uint _mId2, uint _amount2, 
133                             uint _mId3, uint _amount3, uint _mId4, uint _amount4) onlyModerators external {
134         
135         if (_mId1 > 0) {
136             myMaterials[_owner][_mId1] += _amount1;
137             materials[_mId1].erc20.emitTransferEvent(address(0), _owner, _amount1);
138         }
139         if (_mId2 > 0) {
140             myMaterials[_owner][_mId2] += _amount2;
141             materials[_mId2].erc20.emitTransferEvent(address(0), _owner, _amount2);
142         }
143         if (_mId3 > 0) {
144             myMaterials[_owner][_mId3] += _amount3;
145             materials[_mId3].erc20.emitTransferEvent(address(0), _owner, _amount3);
146         }
147         if (_mId4 > 0) {
148             myMaterials[_owner][_mId4] += _amount4;
149             materials[_mId4].erc20.emitTransferEvent(address(0), _owner, _amount4);
150         }
151     }
152     
153     function removeMaterials(address _owner, uint _mId1, uint _amount1, uint _mId2, uint _amount2, 
154                             uint _mId3, uint _amount3, uint _mId4, uint _amount4) onlyModerators external {
155         if (_mId1 > 0) {
156             if (myMaterials[_owner][_mId1] < _amount1) revert();
157             myMaterials[_owner][_mId1] -= _amount1;
158             materials[_mId1].erc20.emitTransferEvent(_owner, address(0), _amount1);
159         }
160         if (_mId2 > 0) {
161             if (myMaterials[_owner][_mId2] < _amount2) revert();
162             myMaterials[_owner][_mId2] -= _amount2;
163             materials[_mId2].erc20.emitTransferEvent(_owner, address(0), _amount2);
164         }
165         if (_mId3 > 0) {
166             if (myMaterials[_owner][_mId3] < _amount3) revert();
167             myMaterials[_owner][_mId3] -= _amount3;
168             materials[_mId3].erc20.emitTransferEvent(_owner, address(0), _amount3);
169         }
170         if (_mId4 > 0) {
171             if (myMaterials[_owner][_mId4] < _amount4) revert();
172             myMaterials[_owner][_mId4] -= _amount4;
173             materials[_mId4].erc20.emitTransferEvent(_owner, address(0), _amount4);
174         }
175     }
176     
177     
178     // public function
179     function getMaterialSupply(uint _mId) constant external returns(uint) {
180         return materials[_mId].totalSupply;
181     }
182     
183     function getMaterialData(uint _mId) constant external returns(uint price, uint totalSupply, address erc20Address) {
184         MaterialData storage material = materials[_mId];
185         return (material.price, material.totalSupply, address(material.erc20));
186     }
187     
188     function getMyMaterials(address _owner) constant external returns(uint[MAX_MATERIAL]) {
189         return myMaterials[_owner];
190     }
191     
192     function getMyMaterialById(address _owner, uint _mId) constant external returns(uint) {
193         return myMaterials[_owner][_mId];
194     }
195     
196     function getMyMaterialsByIds(address _owner, uint _mId1, uint _mId2, uint _mId3, uint _mId4) constant external returns(
197         uint, uint, uint, uint) {
198         return (myMaterials[_owner][_mId1], myMaterials[_owner][_mId2], myMaterials[_owner][_mId3], myMaterials[_owner][_mId4]);    
199     }
200 }