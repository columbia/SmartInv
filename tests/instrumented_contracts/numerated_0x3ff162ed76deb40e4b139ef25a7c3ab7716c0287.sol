1 pragma solidity ^0.4.8;
2 contract Owned {
3 
4     address public owner;
5     enum StatusEditor{DisableEdit, EnableEdit}
6     mapping(address => StatusEditor) public editors;
7 
8     function Owned() {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         if (msg.sender != owner) throw;
14         _;
15     }
16 
17     function transferOwnership(address newOwner) onlyOwner {
18         owner = newOwner;
19     }
20 
21     function addNewEditor(address _editorAddress) onlyOwner{
22         editors[_editorAddress] = StatusEditor.EnableEdit;
23     }
24 
25     function deleteEditor(address _editorAddress) onlyOwner{
26         editors[_editorAddress] = StatusEditor.DisableEdit;
27     }
28 
29     modifier onlyEditor{
30         if (editors[msg.sender] != StatusEditor.EnableEdit) throw;
31         _;
32     }
33 
34     modifier onlyOwnerOrEditor{
35         if (msg.sender != owner && editors[msg.sender] != StatusEditor.EnableEdit) throw;
36         _;
37     }
38 
39 }
40 
41 contract Ur is Owned {
42 
43     struct Group{
44 
45         uint percentageBonus;
46         uint price;
47     }
48 
49     struct User{
50 
51         address userAddress;
52         bool splitReceived;
53         //bytes32 userGroup;
54         uint userGroupID;
55         bool convertedToCoins;
56         uint currentPrice;
57         uint currentDifficulty;
58         uint currentTime;
59     }
60 
61     uint256 public totalBalance;
62     string public standard = 'UrToken';
63     string public name;
64     string public symbol;
65     uint8 public decimals;
66     bool public contractPays;
67 
68     uint public Price;
69     uint public Difficulty;
70     uint balanceTemp;
71     bool incrementPriceAndDifficulty;
72     uint public difficultyBalance;
73     uint public increaseStep;
74 
75     mapping(bytes32 => Group) public userGroups;
76     mapping(address => User) public users;
77     mapping(address => uint256) public balanceOf;
78 
79     address[] public userAddresses;
80     bytes32[] public groupArray;
81 
82     uint public sizeOfUserAddresses;
83 
84     event Transfer(address indexed from, address indexed to, int256 value);
85 
86     Group Beginner;
87     Group Advanced;
88     Group Certified;
89     Group Trader;
90     Group Master;
91     Group Ultimate;
92     Group BegAdvCertif;
93     Group AdvCertifTrader;
94     Group CertifiedTrader;
95     Group CertifiedMaster;
96     Group CertifTradMast;
97     Group TradMastUltim;
98 
99     function Ur(){
100         totalBalance = 10000000000000000000000000000;
101         balanceOf[msg.sender] = 10000000000000000000000000000;
102         name = 'UrToken';
103         symbol = 'URT';
104         decimals = 16;
105         contractPays = false;
106 
107         Price = 1;
108         Difficulty = 10;
109         balanceTemp = 0;
110         incrementPriceAndDifficulty = true;
111         increaseStep = 1000000;
112 
113         sizeOfUserAddresses = 0;
114     }
115     
116     function install() onlyOwner {
117         Beginner = Group({percentageBonus: 100, price: 99});
118         Advanced = Group({percentageBonus: 100, price: 600});
119         Certified = Group({percentageBonus: 100, price: 1500});
120         Trader = Group({percentageBonus: 300, price: 5500});
121         Master = Group({percentageBonus: 700, price: 11750});
122         Ultimate = Group({percentageBonus: 1500, price: 22500});
123         BegAdvCertif = Group({percentageBonus: 700, price: 2299});
124         AdvCertifTrader = Group({percentageBonus: 700, price: 7700});
125         CertifiedTrader = Group({percentageBonus: 700, price: 7100});
126         CertifiedMaster = Group({percentageBonus: 1500, price: 13350});
127         CertifTradMast = Group({percentageBonus: 6300, price: 18850});
128         TradMastUltim = Group({percentageBonus: 12700, price: 39750});
129 
130         userGroups[0x426567696e6e6572] = Beginner;                          //000000000000000000000000000000000000000000000000426567696e6e6572
131         userGroups[0x416476616e636564] = Advanced;                          //000000000000000000000000000000000000000000000000416476616e636564
132         userGroups[0x436572746966696564] = Certified;                       //0000000000000000000000000000000000000000000000436572746966696564
133         userGroups[0x547261646572] = Trader;                                //0000000000000000000000000000000000000000000000000000547261646572
134         userGroups[0x4d6173746572] = Master;                                //00000000000000000000000000000000000000000000000000004d6173746572
135         userGroups[0x556c74696d617465] = Ultimate;                          //000000000000000000000000000000000000000000000000556c74696d617465
136         userGroups[0x426567416476436572746966] = BegAdvCertif;              //0000000000000000000000000000000000000000426567416476436572746966
137         userGroups[0x416476436572746966547261646572] = AdvCertifTrader;     //0000000000000000000000000000000000416476436572746966547261646572
138         userGroups[0x436572746966696564547261646572] = CertifiedTrader;     //0000000000000000000000000000000000436572746966696564547261646572
139         userGroups[0x4365727469666965644d6173746572] = CertifiedMaster;     //00000000000000000000000000000000004365727469666965644d6173746572
140         userGroups[0x436572746966547261644d617374] = CertifTradMast;        //000000000000000000000000000000000000436572746966547261644d617374
141         userGroups[0x547261644d617374556c74696d] = TradMastUltim;           //00000000000000000000000000000000000000547261644d617374556c74696d
142 
143         groupArray.push(0x426567696e6e6572);                                //Beginner
144         groupArray.push(0x416476616e636564);                                //Advanced
145         groupArray.push(0x436572746966696564);                              //Certified
146         groupArray.push(0x547261646572);                                    //Trader
147         groupArray.push(0x4d6173746572);                                    //Master
148         groupArray.push(0x556c74696d617465);                                //Ultimate
149         groupArray.push(0x426567416476436572746966);                        //Beginner+Advanced+Certified
150         groupArray.push(0x416476436572746966547261646572);                  //Advanced+Certified+Trader
151         groupArray.push(0x436572746966696564547261646572);                  //Certified+Trader
152         groupArray.push(0x4365727469666965644d6173746572);                  //Certified+Master
153         groupArray.push(0x436572746966547261644d617374);                    //Certified+Trader+Master
154         groupArray.push(0x547261644d617374556c74696d);                      //Trader+Master+Ultimate
155 
156     }                                                                         
157 
158     function addCoins(uint256 _value) onlyOwner{
159 
160         balanceOf[owner] += _value; 
161         totalBalance += _value;
162         Transfer(0, owner, int256(_value));
163     }
164 
165     function addUser(address _userAddress, uint _userGroupID) onlyOwnerOrEditor returns(bool){ 
166 
167         if(groupArray[_userGroupID] == '0x')
168             return false;
169 
170         for(uint i=0;i<groupArray.length;i++){
171 
172             if(i == _userGroupID){
173                 difficultyBalance += userGroups[groupArray[i]].price;
174             }
175         }
176 
177         users[_userAddress].userGroupID = _userGroupID;
178         users[_userAddress].splitReceived = false;
179         users[_userAddress].userAddress = _userAddress;
180         users[_userAddress].convertedToCoins = false;
181         users[_userAddress].currentPrice = 0;
182         users[_userAddress].currentTime = 0;
183 
184         userAddresses.push(_userAddress);
185 
186         //if(difficultyBalance>balanceTemp){
187         //    incrementPriceAndDifficulty = false;
188         //    increasePriceAndDifficulty();
189         //}
190 
191         sizeOfUserAddresses = userAddresses.length;
192                 
193         return true;
194     }
195 
196     function addNewGroup(bytes32 _groupName, uint _percentageBonus, uint _price) onlyOwnerOrEditor returns (bool){ 
197 
198         userGroups[_groupName].percentageBonus = _percentageBonus;
199         userGroups[_groupName].price = _price;
200 
201         groupArray.push(_groupName);
202 
203         return true;
204     }
205 
206     function changeUserGroup(address _userAddress, uint _newUserGroupID) onlyOwner returns (bool){
207 
208         if(groupArray[_newUserGroupID] == '0x')
209             return false;
210 
211         for(uint i=0;i<groupArray.length;i++){
212 
213             if(i == _newUserGroupID){
214                 users[_userAddress].userGroupID = _newUserGroupID;
215             }
216         }
217 
218         return true;
219     }
220 
221     function switchSplitBonusValue(address _userAddress, bool _newSplitValue) onlyOwner{
222 
223         users[_userAddress].splitReceived = _newSplitValue;
224     }
225 
226     function increasePriceAndDifficulty() onlyOwnerOrEditor{
227         if((difficultyBalance - balanceTemp) >= increaseStep){            
228             balanceTemp = difficultyBalance;
229             Difficulty += 10;
230             Price += 1;           
231         }
232     }
233 
234     function changeDifficultyAndPrice(uint _newDifficulty, uint _newPrice) onlyOwner{
235         Difficulty = _newDifficulty;
236         Price = _newPrice;
237         difficultyBalance = 0;
238         balanceTemp = 0;
239     }
240     
241     function changeIncreaseStep (uint _increaseStep) onlyOwner {
242         increaseStep = _increaseStep;
243     }
244 
245     function convert(address _userAddress) onlyOwnerOrEditor{
246 
247         users[_userAddress].convertedToCoins = true;
248         users[_userAddress].currentPrice = Price;
249         users[_userAddress].currentDifficulty = Difficulty;
250         users[_userAddress].currentTime = block.timestamp;
251     }
252 
253     function transfer(address _to, uint256 _value) {
254 
255         if (_value < 0 || balanceOf[msg.sender] < _value)
256             throw;
257 
258         if (users[msg.sender].convertedToCoins) throw;
259 
260         balanceOf[msg.sender] -= _value;
261         balanceOf[_to] += _value;
262         Transfer(msg.sender, _to, int256(_value));
263         if (contractPays && !msg.sender.send(tx.gasprice))
264             throw;
265     }
266 
267     function switchFeePolicy(bool _contractPays) onlyOwner {
268         contractPays = _contractPays;
269     }
270 
271     function showUser(address _userAddress) constant returns(address, bool, bytes32, bool, uint, uint, uint){
272 
273         return (users[_userAddress].userAddress, users[_userAddress].splitReceived, groupArray[users[_userAddress].userGroupID],
274                 users[_userAddress].convertedToCoins, users[_userAddress].currentPrice, users[_userAddress].currentDifficulty, users[_userAddress].currentTime);
275     }
276 
277 }