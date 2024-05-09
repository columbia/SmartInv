1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * ether King contract
6  **/
7 contract etherKing{
8     
9     
10     //contract owner
11     address private owner;
12     
13     uint256 private battleCount = 1;
14     
15     uint256 private price;
16     
17     address[] private countryOwners = new address[](6);
18     
19     uint256 private win = 6;
20     
21     
22     //history
23     uint256 private historyCount;
24     
25     mapping(uint256 => address) private winAddressHistory;
26     
27     mapping(uint256 => uint8) private winItemIdHistory;
28     
29     
30     
31     function etherKing(uint256 _price) public {
32         price = _price;
33         owner = msg.sender;
34     }
35     
36     
37     event BuyCountry(address indexed to, uint256 indexed countryId, uint256 indexed price);
38     
39     event Win(address indexed win, uint256 indexed reward, uint256 indexed winNum);
40     
41     
42     modifier onlyOwner(){
43         require(owner == msg.sender);
44         _;
45     }
46     
47     
48     
49     function withdrawAll () onlyOwner() public {
50         msg.sender.transfer(this.balance);
51     }
52 
53     function withdrawAmount (uint256 _amount) onlyOwner() public {
54         msg.sender.transfer(_amount);
55     }
56     
57     
58     
59     function battleCountOf() public view returns(uint256){
60         return battleCount;
61     }
62     
63     
64     function countryLengthOf()public view returns(uint256){
65         return countryOwners.length;
66     }
67     
68     
69     function winAddressOf() public view returns(address _address, uint256 winNum){
70         if(win >= 6){
71             winNum = win;
72             _address = address(0);
73         } else {
74             winNum = win;
75             _address = countryOwners[winNum];
76         }
77     }
78     
79     function countryOwnersOf() public view returns(address[]){
80         return countryOwners;
81     }
82     
83     
84     
85     function ownerOfCountryCount(address _owner) public view returns(uint256){
86         require(_owner != address(0));
87         uint256 count = 0;
88         for(uint256 i = 0; i < countryOwners.length; i++){
89             if(countryOwners[i] == _owner){
90                 count++;
91             }
92         }
93         return count;
94     }
95     
96 
97     
98     function isBuyFull() public view returns(bool){
99         for(uint256 i = 0; i < countryOwners.length; i++){
100             if(countryOwners[i] == address(0)){
101                 return false;
102             }
103         }
104         return true;
105     }
106     
107     
108     
109     function buyCountry(uint256 countryId) public payable{
110         require(msg.value >= price);
111         require(countryId < countryOwners.length);
112         require(countryOwners[countryId] == address(0));
113         require(!isContract(msg.sender));
114         require(msg.sender != address(0));
115         
116         countryOwners[countryId] = msg.sender;
117         
118         BuyCountry(msg.sender, countryId, msg.value);
119     }
120     
121     
122     function calculateWin() onlyOwner public {
123         require(isBuyFull());
124         
125         win = getRandom(uint128(battleCount), countryOwners.length);
126         
127         address winAddress = countryOwners[win];
128         
129         uint256 reward = 1 ether;
130         
131         if(reward > this.balance)
132         {
133             reward = this.balance;
134         }
135         
136         winAddress.transfer(reward);
137         
138         Win(winAddress, reward, win);
139         
140         //add History
141         addHistory(battleCount, winAddress, uint8(win));
142     }
143     
144         
145     function reset() onlyOwner public {
146         require(win < 6);
147         
148         win = 6;
149         
150         battleCount++;
151         
152         for(uint256 i = 0; i < countryOwners.length; i++){
153             delete countryOwners[i];
154         }
155     }
156     
157     
158     function getRandom(uint128 count, uint256 limit) private view returns(uint256){
159         uint lastblocknumberused = block.number - 1 ;
160     	bytes32 lastblockhashused = block.blockhash(lastblocknumberused);
161     	uint128 lastblockhashused_uint = uint128(lastblockhashused) + count;
162     	uint256 hashymchasherton = sha(lastblockhashused_uint, lastblockhashused);
163     	
164     	return hashymchasherton % limit;
165     }
166     
167 
168     function sha(uint128 wager, bytes32 _lastblockhashused) private view returns(uint256)
169     { 
170         return uint256(keccak256(block.difficulty, block.coinbase, now, _lastblockhashused, wager));  
171     }
172 
173     
174     /* Util */
175     function isContract(address addr) internal view returns (bool) {
176         uint size;
177         assembly { size := extcodesize(addr) } // solium-disable-line
178         return size > 0;
179     }
180    
181     
182     
183     function historyCountOf() public view returns (uint256){
184         return historyCount;
185     }
186     
187     
188     function addressHistoryOf(uint256 _battleId) public view returns(address) {
189         address _address = winAddressHistory[_battleId];
190         return _address;
191     }
192     
193     
194     function itemHistoryOf(uint256 _battleId) public view returns(uint8){
195         uint8 _item = winItemIdHistory[_battleId];
196         return _item;
197     }
198     
199     
200     
201     function getHistory(uint256 minBattleId, uint256 maxBattleId) public view returns(address[] _addressArray, uint8[] _itemArray, uint256 _minBattleId){
202         require(minBattleId > 0);
203         require(maxBattleId <= historyCount);
204         
205         uint256 length = (maxBattleId - minBattleId) + 1;
206         _addressArray = new address[](length);
207         _itemArray = new uint8[](length);
208         _minBattleId = minBattleId;
209         
210         for(uint256 i = 0; i < length; i++){
211             _addressArray[i] = addressHistoryOf(minBattleId + i);
212             _itemArray[i] = itemHistoryOf(minBattleId + i);
213         }
214     }
215     
216     
217     
218     
219     function addHistory(uint256 _battleId, address _win, uint8 _itemId) private {
220         require(addressHistoryOf(_battleId) == address(0));
221         
222         winAddressHistory[_battleId] = _win;
223         winItemIdHistory[_battleId] = _itemId;
224         historyCount++;
225     }
226     
227     
228 
229 }