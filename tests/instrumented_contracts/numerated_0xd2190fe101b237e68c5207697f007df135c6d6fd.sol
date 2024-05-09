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
61     function mineMaterial(address _owner, uint _mId, uint _amount) external;
62 }
63 
64 contract CubegoPresale is BasicAccessControl {
65     
66     struct SinglePack {
67         uint mId;
68         uint amount;
69         uint price;
70     }
71     
72     struct UltimatePack {
73         uint mId1;
74         uint amount1;
75         uint mId2;
76         uint amount2;
77         uint mId3;
78         uint amount3;
79         uint mId4;
80         uint amount4;
81         uint mId5;
82         uint amount5;
83         uint mId6;
84         uint amount6;
85         uint price;
86     }
87     
88     mapping(uint => SinglePack) public singlePacks;
89     mapping(uint => uint) public packQuantityFactor; // percentage
90     UltimatePack public ultimatePack;
91     CubegoCoreInterface public cubegoCore;
92     EMONTInterface public emontToken;
93     uint public discountFactor = 90; // percentage
94     uint public ethEmontRate = 1500 * 10 ** 8; // each 10 ** 18 ETH
95     
96     function setAddress(address _cubegoCoreAddress, address _emontTokenAddress) onlyModerators external {
97         cubegoCore = CubegoCoreInterface(_cubegoCoreAddress);
98         emontToken = EMONTInterface(_emontTokenAddress);
99     }
100     
101     function initConfig() onlyModerators external {
102         singlePacks[1] = SinglePack(8, 120, 0.40 * 10 ** 18);
103         singlePacks[2] = SinglePack(7, 125, 0.40 * 10 ** 18);
104         singlePacks[3] = SinglePack(6, 125, 0.40 * 10 ** 18);
105 
106         singlePacks[4] = SinglePack(11, 40, 0.70 * 10 ** 18);
107         singlePacks[5] = SinglePack(10, 45, 0.70 * 10 ** 18);
108         singlePacks[6] = SinglePack(9, 45, 0.70 * 10 ** 18);
109         
110         ultimatePack.mId1 = 11;
111         ultimatePack.amount1 = 16;
112         ultimatePack.mId2 = 10;
113         ultimatePack.amount2 = 18;
114         ultimatePack.mId3 = 9;
115         ultimatePack.amount3 = 18;
116         ultimatePack.mId4 = 8;
117         ultimatePack.amount4 = 48;
118         ultimatePack.mId5 = 7;
119         ultimatePack.amount5 = 50;
120         ultimatePack.mId6 = 6;
121         ultimatePack.amount6 = 50;
122         ultimatePack.price = 1.25 * 10 ** 18;
123         
124         packQuantityFactor[1] = 100;
125         packQuantityFactor[3] = 300;
126         packQuantityFactor[6] = 570;
127         packQuantityFactor[10] = 900;
128         
129         discountFactor = 90;
130     }
131     
132     function setConfig(uint _discountFactor, uint _ethEmontRate) onlyModerators external {
133         discountFactor = _discountFactor;
134         ethEmontRate = _ethEmontRate;
135     }
136     
137     function setSinglePack(uint _packId, uint _mId, uint _amount, uint _price) onlyModerators external {
138         singlePacks[_packId] = SinglePack(_mId, _amount, _price);
139     }
140     
141     function setUltimatePack(uint _mId1, uint _amount1, uint _mId2, uint _amount2, uint _mId3, uint _amount3,
142         uint _mId4, uint _amount4, uint _mId5, uint _amount5, uint _mId6, uint _amount6, uint _price) onlyModerators external {
143         ultimatePack.mId1 = _mId1;
144         ultimatePack.amount1 = _amount1;
145         
146         ultimatePack.mId2 = _mId2;
147         ultimatePack.amount2 = _amount2;
148         
149         ultimatePack.mId3 = _mId3;
150         ultimatePack.amount3 = _amount3;
151         
152         ultimatePack.mId4 = _mId4;
153         ultimatePack.amount4 = _amount4;
154         
155         ultimatePack.mId5 = _mId5;
156         ultimatePack.amount5 = _amount5;
157         
158         ultimatePack.mId6 = _mId6;
159         ultimatePack.amount6 = _amount6;
160         
161         ultimatePack.price = _price;
162     }
163     
164     function setPackQuantityFactor(uint _quantity, uint _priceFactor) onlyModerators external {
165         packQuantityFactor[_quantity] = _priceFactor;
166     }
167     
168     function withdrawEther(address _sendTo, uint _amount) onlyModerators public {
169         if (_amount > address(this).balance) {
170             revert();
171         }
172         _sendTo.transfer(_amount);
173     }
174     
175     function withdrawToken(address _sendTo, uint _amount) onlyModerators external {
176         if (_amount > emontToken.balanceOf(address(this))) {
177             revert();
178         }
179         emontToken.transfer(_sendTo, _amount);
180     }
181     
182     // emont payment
183     
184     function buySinglePackByToken(address _buyer, uint _tokens, uint _packId, uint _amount) onlyModerators external{
185         uint packFactor = packQuantityFactor[_amount];
186         if (packFactor == 0) revert();
187         SinglePack memory pack = singlePacks[_packId];
188         if (pack.price == 0) revert();
189         
190         uint payAmount = (pack.price * packFactor * discountFactor) / 10000;
191         uint payTokenAmount = payAmount * ethEmontRate / 10 ** 18;
192         if (_tokens < payTokenAmount) revert();
193         
194         cubegoCore.mineMaterial(_buyer, pack.mId, pack.amount * _amount);
195         
196     }
197     
198     function buyUltimatePackByToken(address _buyer, uint _tokens, uint _amount) onlyModerators external {
199         uint packFactor = packQuantityFactor[_amount];
200         if (packFactor == 0) revert();
201         
202         uint payAmount = (ultimatePack.price * packFactor * discountFactor) / 10000;
203         uint payTokenAmount = payAmount * ethEmontRate / 10 ** 18;
204         if (_tokens < payTokenAmount) revert();
205         
206         cubegoCore.mineMaterial(_buyer, ultimatePack.mId1, ultimatePack.amount1 * _amount);
207         cubegoCore.mineMaterial(_buyer, ultimatePack.mId2, ultimatePack.amount2 * _amount);
208         cubegoCore.mineMaterial(_buyer, ultimatePack.mId3, ultimatePack.amount3 * _amount);
209         cubegoCore.mineMaterial(_buyer, ultimatePack.mId4, ultimatePack.amount4 * _amount);
210         cubegoCore.mineMaterial(_buyer, ultimatePack.mId5, ultimatePack.amount5 * _amount);
211         cubegoCore.mineMaterial(_buyer, ultimatePack.mId6, ultimatePack.amount6 * _amount);
212     }
213 
214     // public
215 
216     function getSinglePack(uint _packId) constant external returns(uint _mId, uint _amount, uint _price) {
217         SinglePack memory pack = singlePacks[_packId];
218         return (pack.mId, pack.amount, pack.price);
219     }
220     
221     function getUltimatePack() constant external returns(uint _mId1, uint _amount1, uint _mId2, uint _amount2, uint _mId3, 
222         uint _amount3, uint _mId4, uint _amount4, uint _mId5, uint _amount5, uint _mId6, uint _amount6, uint _price) {
223         return (ultimatePack.mId1, ultimatePack.amount1, ultimatePack.mId2, ultimatePack.amount2, ultimatePack.mId3, ultimatePack.amount3, 
224             ultimatePack.mId4, ultimatePack.amount4, ultimatePack.mId5, ultimatePack.amount5,
225             ultimatePack.mId6, ultimatePack.amount6, ultimatePack.price);
226     }
227     
228     function getSinglePackPrice(uint _packId, uint _amount) constant external returns(uint ethPrice, uint emontPrice) {
229         ethPrice = (singlePacks[_packId].price * packQuantityFactor[_amount] * discountFactor) / 10000;
230         emontPrice = ethPrice * ethEmontRate / 10 ** 18;
231     }
232     
233     function getUltimatePackPrice(uint _amount) constant external returns(uint ethPrice, uint emontPrice) {
234         ethPrice = (ultimatePack.price * packQuantityFactor[_amount] * discountFactor) / 10000;
235         emontPrice = ethPrice * ethEmontRate / 10 ** 18;
236     }
237     
238     function buySinglePackFor(address _buyer, uint _packId, uint _amount) isActive payable public {
239         uint packFactor = packQuantityFactor[_amount];
240         if (packFactor == 0) revert();
241         SinglePack memory pack = singlePacks[_packId];
242         if (pack.price == 0) revert();
243         
244         uint payAmount = (pack.price * packFactor * discountFactor) / 10000;
245         if (payAmount > msg.value) revert();
246         
247         cubegoCore.mineMaterial(_buyer, pack.mId, pack.amount * _amount);
248     }
249     
250     function buyUltimatePackFor(address _buyer, uint _amount) isActive payable public {
251         uint packFactor = packQuantityFactor[_amount];
252         if (packFactor == 0) revert();
253         
254         uint payAmount = (ultimatePack.price * packFactor * discountFactor) / 10000;
255         if (payAmount > msg.value) revert();
256         
257         cubegoCore.mineMaterial(_buyer, ultimatePack.mId1, ultimatePack.amount1 * _amount);
258         cubegoCore.mineMaterial(_buyer, ultimatePack.mId2, ultimatePack.amount2 * _amount);
259         cubegoCore.mineMaterial(_buyer, ultimatePack.mId3, ultimatePack.amount3 * _amount);
260         cubegoCore.mineMaterial(_buyer, ultimatePack.mId4, ultimatePack.amount4 * _amount);
261         cubegoCore.mineMaterial(_buyer, ultimatePack.mId5, ultimatePack.amount5 * _amount);
262         cubegoCore.mineMaterial(_buyer, ultimatePack.mId6, ultimatePack.amount6 * _amount);
263     }
264     
265     function buySinglePack(uint _packId, uint _amount) isActive payable external {
266         buySinglePackFor(msg.sender, _packId, _amount);
267     }
268     
269     function buyUltimatePack(uint _amount) isActive payable external {
270         buyUltimatePackFor(msg.sender, _amount);
271     }
272     
273 }