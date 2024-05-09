1 pragma solidity ^0.4.17;
2 
3 
4 
5 
6   
7 
8    
9 	
10 
11 contract SafeMath {
12     function safeAdd(uint x, uint y) pure internal returns(uint) {
13       uint z = x + y;
14       assert((z >= x) && (z >= y));
15       return z;
16     }
17 
18     function safeSubtract(uint x, uint y) pure internal returns(uint) {
19       assert(x >= y);
20       uint z = x - y;
21       return z;
22     }
23 
24     function safeMult(uint x, uint y) pure internal returns(uint) {
25       uint z = x * y;
26       assert((x == 0)||(z/x == y));
27       return z;
28     }
29 
30     function getRandomNumber(uint16 maxRandom, uint8 min, address privateAddress) constant public returns(uint8) {
31         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(privateAddress);
32         return uint8(genNum % (maxRandom - min + 1)+min);
33     }
34 }
35 
36 contract Enums {
37     enum ResultCode {
38         SUCCESS,
39         ERROR_CLASS_NOT_FOUND,
40         ERROR_LOW_BALANCE,
41         ERROR_SEND_FAIL,
42         ERROR_NOT_OWNER,
43         ERROR_NOT_ENOUGH_MONEY,
44         ERROR_INVALID_AMOUNT
45     }
46 
47     enum AngelAura { 
48         Blue, 
49         Yellow, 
50         Purple, 
51         Orange, 
52         Red, 
53         Green 
54     }
55 }
56 
57 
58 
59 contract AccessControl {
60     address public creatorAddress;
61     uint16 public totalSeraphims = 0;
62     mapping (address => bool) public seraphims;
63 
64     bool public isMaintenanceMode = true;
65  
66     modifier onlyCREATOR() {
67         require(msg.sender == creatorAddress);
68         _;
69     }
70 
71     modifier onlySERAPHIM() {
72         require(seraphims[msg.sender] == true);
73         _;
74     }
75     
76     modifier isContractActive {
77         require(!isMaintenanceMode);
78         _;
79     }
80     
81     // Constructor
82     function AccessControl() public {
83         creatorAddress = msg.sender;
84     }
85     
86 
87     function addSERAPHIM(address _newSeraphim) onlyCREATOR public {
88         if (seraphims[_newSeraphim] == false) {
89             seraphims[_newSeraphim] = true;
90             totalSeraphims += 1;
91         }
92     }
93     
94     function removeSERAPHIM(address _oldSeraphim) onlyCREATOR public {
95         if (seraphims[_oldSeraphim] == true) {
96             seraphims[_oldSeraphim] = false;
97             totalSeraphims -= 1;
98         }
99     }
100 
101     function updateMaintenanceMode(bool _isMaintaining) onlyCREATOR public {
102         isMaintenanceMode = _isMaintaining;
103     }
104 
105   
106 } 
107 contract IAccessoryData is AccessControl, Enums {
108     uint8 public totalAccessorySeries;    
109     uint32 public totalAccessories;
110     
111  
112     /*** FUNCTIONS ***/
113     //*** Write Access ***//
114     function createAccessorySeries(uint8 _AccessorySeriesId, uint32 _maxTotal, uint _price) onlyCREATOR public returns(uint8) ;
115 	function setAccessory(uint8 _AccessorySeriesId, address _owner) onlySERAPHIM external returns(uint64);
116    function addAccessoryIdMapping(address _owner, uint64 _accessoryId) private;
117 	function transferAccessory(address _from, address _to, uint64 __accessoryId) onlySERAPHIM public returns(ResultCode);
118     function ownerAccessoryTransfer (address _to, uint64 __accessoryId)  public;
119     function updateAccessoryLock (uint64 _accessoryId, bool newValue) public;
120     function removeCreator() onlyCREATOR external;
121     
122     //*** Read Access ***//
123     function getAccessorySeries(uint8 _accessorySeriesId) constant public returns(uint8 accessorySeriesId, uint32 currentTotal, uint32 maxTotal, uint price) ;
124 	function getAccessory(uint _accessoryId) constant public returns(uint accessoryID, uint8 AccessorySeriesID, address owner);
125 	function getOwnerAccessoryCount(address _owner) constant public returns(uint);
126 	function getAccessoryByIndex(address _owner, uint _index) constant public returns(uint) ;
127     function getTotalAccessorySeries() constant public returns (uint8) ;
128     function getTotalAccessories() constant public returns (uint);
129     function getAccessoryLockStatus(uint64 _acessoryId) constant public returns (bool);
130 }
131 
132 contract AccessoryData is IAccessoryData, SafeMath {
133     /*** EVENTS ***/
134     event CreatedAccessory (uint64 accessoryId);
135     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
136 
137     /*** DATA TYPES ***/
138     struct AccessorySeries {
139         uint8 AccessorySeriesId;
140         uint32 currentTotal;
141         uint32 maxTotal;
142         uint price;
143     }
144 
145     struct Accessory {
146         uint32 accessoryId;
147         uint8 accessorySeriesId;
148         address owner;
149         bool ownerLock;
150     }
151 
152 
153     /*** STORAGE ***/
154     mapping(uint8 => AccessorySeries) public AccessorySeriesCollection;
155     mapping(uint => Accessory) public AccessoryCollection;
156     mapping(address => uint64[]) public ownerAccessoryCollection;
157     
158     /*** FUNCTIONS ***/
159     //*** Write Access ***//
160     function AccessoryData() public {
161       
162     }
163 
164     //*** Accessories***/
165     function createAccessorySeries(uint8 _AccessorySeriesId, uint32 _maxTotal, uint _price) onlyCREATOR public returns(uint8) {
166         
167         if ((now > 1517189201) || (totalAccessorySeries >= 18)) {revert();}
168         //This confirms that no one, even the develoopers, can create any accessorySeries after JAN/29/2018 @ 1:26 am (UTC) or more than the original 18 series. 
169         AccessorySeries storage accessorySeries = AccessorySeriesCollection[_AccessorySeriesId];
170         accessorySeries.AccessorySeriesId = _AccessorySeriesId;
171         accessorySeries.maxTotal = _maxTotal;
172         accessorySeries.price = _price;
173 
174         totalAccessorySeries += 1;
175         return totalAccessorySeries;
176     }
177 	
178 	function setAccessory(uint8 _seriesIDtoCreate, address _owner) external onlySERAPHIM returns(uint64) { 
179         AccessorySeries storage series = AccessorySeriesCollection[_seriesIDtoCreate];
180         if (series.maxTotal <= series.currentTotal) {revert();}
181         else {
182         totalAccessories += 1;
183         series.currentTotal +=1;
184        Accessory storage accessory = AccessoryCollection[totalAccessories];
185         accessory.accessoryId = totalAccessories;
186        accessory.accessorySeriesId = _seriesIDtoCreate;
187         accessory.owner = _owner;
188         accessory.ownerLock = true;
189         uint64[] storage owners = ownerAccessoryCollection[_owner];
190         owners.push(accessory.accessoryId);
191        }
192         
193     }
194 
195     
196    function addAccessoryIdMapping(address _owner, uint64 _accessoryId) private  {
197             uint64[] storage owners = ownerAccessoryCollection[_owner];
198           owners.push(_accessoryId);
199           Accessory storage accessory = AccessoryCollection[_accessoryId];
200           accessory.owner = _owner;
201     
202    }
203     
204 
205 	
206 	function transferAccessory(address _from, address _to, uint64 __accessoryId) onlySERAPHIM public returns(ResultCode) {
207         Accessory storage accessory = AccessoryCollection[__accessoryId];
208         if (accessory.owner != _from) {
209             return ResultCode.ERROR_NOT_OWNER;
210         }
211         if (_from == _to) {revert();}
212         if (accessory.ownerLock == true) {revert();}
213      addAccessoryIdMapping(_to, __accessoryId);
214         return ResultCode.SUCCESS;
215     }
216   function ownerAccessoryTransfer (address _to, uint64 __accessoryId)  public  {
217      //Any owner of an accessory can call this function to transfer their accessory to any other address. 
218      
219        if ((__accessoryId > totalAccessories) || ( __accessoryId == 0)) {revert();}
220          Accessory storage accessory = AccessoryCollection[__accessoryId];
221         if (msg.sender == _to) {revert();} //can't send an accessory to yourself
222         if (accessory.owner != msg.sender) {revert();} //can't send an accessory you don't own. 
223         else {
224         accessory.owner = _to;
225       addAccessoryIdMapping(_to, __accessoryId);
226         }
227     }
228     
229        function updateAccessoryLock (uint64 _accessoryId, bool newValue) public {
230         if ((_accessoryId > totalAccessories) || (_accessoryId == 0)) {revert();}
231         Accessory storage accessory = AccessoryCollection[_accessoryId];
232         if (accessory.owner != msg.sender) { revert();}
233         accessory.ownerLock = newValue;
234     }
235     
236        function removeCreator() onlyCREATOR external {
237         //this function is meant to be called once all modules for the game are in place. It will remove our ability to add any new modules and make the game fully decentralized. 
238         creatorAddress = address(0);
239     }
240 
241     //*** Read Access ***//
242     function getAccessorySeries(uint8 _accessorySeriesId) constant public returns(uint8 accessorySeriesId, uint32 currentTotal, uint32 maxTotal, uint price) {
243         AccessorySeries memory series = AccessorySeriesCollection[_accessorySeriesId];
244         accessorySeriesId = series.AccessorySeriesId;
245         currentTotal = series.currentTotal;
246         maxTotal = series.maxTotal;
247         price = series.price;
248     }
249 	
250 	function getAccessory(uint _accessoryId) constant public returns(uint accessoryID, uint8 AccessorySeriesID, address owner) {
251         Accessory memory accessory = AccessoryCollection[_accessoryId];
252         accessoryID = accessory.accessoryId;
253         AccessorySeriesID = accessory.accessorySeriesId;
254         owner = accessory.owner;
255   
256        
257     }
258 	
259 	function getOwnerAccessoryCount(address _owner) constant public returns(uint) {
260         return ownerAccessoryCollection[_owner].length;
261     }
262 	
263 	function getAccessoryByIndex(address _owner, uint _index) constant public returns(uint) {
264         if (_index >= ownerAccessoryCollection[_owner].length)
265             return 0;
266         return ownerAccessoryCollection[_owner][_index];
267     }
268 
269     function getTotalAccessorySeries() constant public returns (uint8) {
270         return totalAccessorySeries;
271     }
272 
273     function getTotalAccessories() constant public returns (uint) {
274         return totalAccessories;
275     }
276       function getAccessoryLockStatus(uint64 _acessoryId) constant public returns (bool) {
277         if ((_acessoryId > totalAccessories) || (_acessoryId == 0)) {revert();}
278        Accessory storage accessory = AccessoryCollection[_acessoryId];
279        return accessory.ownerLock;
280     }
281 }