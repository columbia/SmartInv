1 pragma solidity ^0.4.17;
2 
3 
4 
5 contract AccessControl {
6     address public creatorAddress;
7     uint16 public totalSeraphims = 0;
8     mapping (address => bool) public seraphims;
9 
10     bool public isMaintenanceMode = true;
11  
12     modifier onlyCREATOR() {
13         require(msg.sender == creatorAddress);
14         _;
15     }
16 
17     modifier onlySERAPHIM() {
18         require(seraphims[msg.sender] == true);
19         _;
20     }
21     
22     modifier isContractActive {
23         require(!isMaintenanceMode);
24         _;
25     }
26     
27     // Constructor
28     function AccessControl() public {
29         creatorAddress = msg.sender;
30     }
31     
32 
33     function addSERAPHIM(address _newSeraphim) onlyCREATOR public {
34         if (seraphims[_newSeraphim] == false) {
35             seraphims[_newSeraphim] = true;
36             totalSeraphims += 1;
37         }
38     }
39     
40     function removeSERAPHIM(address _oldSeraphim) onlyCREATOR public {
41         if (seraphims[_oldSeraphim] == true) {
42             seraphims[_oldSeraphim] = false;
43             totalSeraphims -= 1;
44         }
45     }
46 
47     function updateMaintenanceMode(bool _isMaintaining) onlyCREATOR public {
48         isMaintenanceMode = _isMaintaining;
49     }
50 
51   
52 } 
53 
54 contract SafeMath {
55     function safeAdd(uint x, uint y) pure internal returns(uint) {
56       uint z = x + y;
57       assert((z >= x) && (z >= y));
58       return z;
59     }
60 
61     function safeSubtract(uint x, uint y) pure internal returns(uint) {
62       assert(x >= y);
63       uint z = x - y;
64       return z;
65     }
66 
67     function safeMult(uint x, uint y) pure internal returns(uint) {
68       uint z = x * y;
69       assert((x == 0)||(z/x == y));
70       return z;
71     }
72 
73     function getRandomNumber(uint16 maxRandom, uint8 min, address privateAddress) constant public returns(uint8) {
74         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(privateAddress);
75         return uint8(genNum % (maxRandom - min + 1)+min);
76     }
77 }
78 
79 contract Enums {
80     enum ResultCode {
81         SUCCESS,
82         ERROR_CLASS_NOT_FOUND,
83         ERROR_LOW_BALANCE,
84         ERROR_SEND_FAIL,
85         ERROR_NOT_OWNER,
86         ERROR_NOT_ENOUGH_MONEY,
87         ERROR_INVALID_AMOUNT
88     }
89 
90     enum AngelAura { 
91         Blue, 
92         Yellow, 
93         Purple, 
94         Orange, 
95         Red, 
96         Green 
97     }
98 }
99 contract IAccessoryData is AccessControl, Enums {
100     uint8 public totalAccessorySeries;    
101     uint32 public totalAccessories;
102     
103  
104     /*** FUNCTIONS ***/
105     //*** Write Access ***//
106     function createAccessorySeries(uint8 _AccessorySeriesId, uint32 _maxTotal, uint _price) onlyCREATOR public returns(uint8) ;
107 	function setAccessory(uint8 _AccessorySeriesId, address _owner) onlySERAPHIM external returns(uint64);
108    function addAccessoryIdMapping(address _owner, uint64 _accessoryId) private;
109 	function transferAccessory(address _from, address _to, uint64 __accessoryId) onlySERAPHIM public returns(ResultCode);
110     function ownerAccessoryTransfer (address _to, uint64 __accessoryId)  public;
111     
112     //*** Read Access ***//
113     function getAccessorySeries(uint8 _accessorySeriesId) constant public returns(uint8 accessorySeriesId, uint32 currentTotal, uint32 maxTotal, uint price) ;
114 	function getAccessory(uint _accessoryId) constant public returns(uint accessoryID, uint8 AccessorySeriesID, address owner);
115 	function getOwnerAccessoryCount(address _owner) constant public returns(uint);
116 	function getAccessoryByIndex(address _owner, uint _index) constant public returns(uint) ;
117     function getTotalAccessorySeries() constant public returns (uint8) ;
118     function getTotalAccessories() constant public returns (uint);
119 }
120 
121 
122   
123 
124    
125 	
126 
127 
128 contract AccessoryData is IAccessoryData, SafeMath {
129     /*** EVENTS ***/
130     event CreatedAccessory (uint64 accessoryId);
131     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
132 
133     /*** DATA TYPES ***/
134     struct AccessorySeries {
135         uint8 AccessorySeriesId;
136         uint32 currentTotal;
137         uint32 maxTotal;
138         uint price;
139     }
140 
141     struct Accessory {
142         uint32 accessoryId;
143         uint8 accessorySeriesId;
144         address owner;
145     }
146 
147 
148     /*** STORAGE ***/
149     mapping(uint8 => AccessorySeries) public AccessorySeriesCollection;
150     mapping(uint => Accessory) public AccessoryCollection;
151     mapping(address => uint64[]) public ownerAccessoryCollection;
152     
153     /*** FUNCTIONS ***/
154     //*** Write Access ***//
155     function AccessoryData() public {
156       
157     }
158 
159     //*** Accessories***/
160     function createAccessorySeries(uint8 _AccessorySeriesId, uint32 _maxTotal, uint _price) onlyCREATOR public returns(uint8) {
161         
162         if ((now > 1516642200) || (totalAccessorySeries >= 18)) {revert();}
163         //This confirms that no one, even the develoopers, can create any accessorySeries after JAN/22/2018 @ 05:30pm (UTC) or more than the original 18 series. 
164         AccessorySeries storage accessorySeries = AccessorySeriesCollection[_AccessorySeriesId];
165         accessorySeries.AccessorySeriesId = _AccessorySeriesId;
166         accessorySeries.maxTotal = _maxTotal;
167         accessorySeries.price = _price;
168 
169         totalAccessorySeries += 1;
170         return totalAccessorySeries;
171     }
172 	
173 	function setAccessory(uint8 _seriesIDtoCreate, address _owner) external onlySERAPHIM returns(uint64) { 
174         AccessorySeries storage series = AccessorySeriesCollection[_seriesIDtoCreate];
175         if (series.maxTotal <= series.currentTotal) {revert();}
176         else {
177         totalAccessories += 1;
178         series.currentTotal +=1;
179        Accessory storage accessory = AccessoryCollection[totalAccessories];
180         accessory.accessoryId = totalAccessories;
181        accessory.accessorySeriesId = _seriesIDtoCreate;
182         accessory.owner = _owner;
183         uint64[] storage owners = ownerAccessoryCollection[_owner];
184         owners.push(accessory.accessoryId);
185        }
186         
187     }
188 
189     
190    function addAccessoryIdMapping(address _owner, uint64 _accessoryId) private  {
191             uint64[] storage owners = ownerAccessoryCollection[_owner];
192           owners.push(_accessoryId);
193           Accessory storage accessory = AccessoryCollection[_accessoryId];
194           accessory.owner = _owner;
195     
196    }
197     
198 
199 	
200 	function transferAccessory(address _from, address _to, uint64 __accessoryId) onlySERAPHIM public returns(ResultCode) {
201         Accessory storage accessory = AccessoryCollection[__accessoryId];
202         if (accessory.owner != _from) {
203             return ResultCode.ERROR_NOT_OWNER;
204         }
205         if (_from == _to) {revert();}
206      addAccessoryIdMapping(_to, __accessoryId);
207         return ResultCode.SUCCESS;
208     }
209   function ownerAccessoryTransfer (address _to, uint64 __accessoryId)  public  {
210      //Any owner of an accessory can call this function to transfer their accessory to any other address. 
211      
212        if ((__accessoryId > totalAccessories) || ( __accessoryId == 0)) {revert();}
213          Accessory storage accessory = AccessoryCollection[__accessoryId];
214         if (msg.sender == _to) {revert();} //can't send an accessory to yourself
215         if (accessory.owner != msg.sender) {revert();} //can't send an accessory you don't own. 
216         else {
217         accessory.owner = _to;
218       addAccessoryIdMapping(_to, __accessoryId);
219         }
220     }
221 
222     //*** Read Access ***//
223     function getAccessorySeries(uint8 _accessorySeriesId) constant public returns(uint8 accessorySeriesId, uint32 currentTotal, uint32 maxTotal, uint price) {
224         AccessorySeries memory series = AccessorySeriesCollection[_accessorySeriesId];
225         accessorySeriesId = series.AccessorySeriesId;
226         currentTotal = series.currentTotal;
227         maxTotal = series.maxTotal;
228         price = series.price;
229     }
230 	
231 	function getAccessory(uint _accessoryId) constant public returns(uint accessoryID, uint8 AccessorySeriesID, address owner) {
232         Accessory memory accessory = AccessoryCollection[_accessoryId];
233         accessoryID = accessory.accessoryId;
234         AccessorySeriesID = accessory.accessorySeriesId;
235         owner = accessory.owner;
236   
237        
238     }
239 	
240 	function getOwnerAccessoryCount(address _owner) constant public returns(uint) {
241         return ownerAccessoryCollection[_owner].length;
242     }
243 	
244 	function getAccessoryByIndex(address _owner, uint _index) constant public returns(uint) {
245         if (_index >= ownerAccessoryCollection[_owner].length)
246             return 0;
247         return ownerAccessoryCollection[_owner][_index];
248     }
249 
250     function getTotalAccessorySeries() constant public returns (uint8) {
251         return totalAccessorySeries;
252     }
253 
254     function getTotalAccessories() constant public returns (uint) {
255         return totalAccessories;
256     }
257 }