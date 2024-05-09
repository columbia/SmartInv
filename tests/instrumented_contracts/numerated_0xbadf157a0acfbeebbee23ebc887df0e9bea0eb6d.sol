1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract ItemToken {
46   using SafeMath for uint256;
47 
48   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
49   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
50 
51   address private owner;
52   mapping (address => bool) private admins;
53   bool private erc721Enabled = false;
54 
55   uint256 private L = 500;
56   uint256 private itemIdCounter = 0;
57   uint256 private pointsDecayFactor = 1209600000; // half-time: week
58 
59   uint256[] private listedItems;
60   mapping (uint256 => address) private ownerOfItem;
61   mapping (uint256 => string) private nameOfItem;
62   mapping (uint256 => string) private descOfItem;
63   mapping (uint256 => string) private URLOfItem;
64   mapping (uint256 => uint256) private pointOfItem;
65   mapping (uint256 => uint256) private timeOfItem;
66   mapping (uint256 => address) private approvedOfItem;
67 
68   mapping (uint256 => uint256[]) private pointArrayOfArray;
69   mapping (uint256 => uint256[]) private timeArrayOfArray;
70 
71   function ItemToken () public {
72     owner = msg.sender;
73     admins[owner] = true;
74   }
75 
76   /* Modifiers */
77   modifier onlyOwner() {
78     require(owner == msg.sender);
79     _;
80   }
81 
82   modifier onlyAdmins() {
83     require(admins[msg.sender]);
84     _;
85   }
86 
87   modifier onlyERC721() {
88     require(erc721Enabled);
89     _;
90   }
91 
92   /* Owner */
93   function setOwner (address _owner) onlyOwner() public {
94     owner = _owner;
95   }
96 
97   function addAdmin (address _admin) onlyOwner() public {
98     admins[_admin] = true;
99   }
100 
101   function removeAdmin (address _admin) onlyOwner() public {
102     delete admins[_admin];
103   }
104   
105   function adjustL (uint256 _L) onlyOwner() public {
106     L = _L;
107   }
108   
109   function adjustPointsDecayFactor (uint256 _pointsDecayFactor) onlyOwner() public {
110     pointsDecayFactor = _pointsDecayFactor;
111   }
112 
113   // Unlocks ERC721 behaviour, allowing for trading on third party platforms.
114   function enableERC721 () onlyOwner() public {
115     erc721Enabled = true;
116   }
117 
118   /* Withdraw */
119   function withdrawAll () onlyOwner() public {
120     owner.transfer(this.balance);
121   }
122 
123   function withdrawAmount (uint256 _amount) onlyOwner() public {
124     owner.transfer(_amount);
125   }
126 
127   /* Listing */
128   function Time_call() returns (uint256 _now){
129     return now;
130   }
131 
132   function listDapp (string _itemName, string _itemDesc, string _itemURL) public {
133     require(bytes(_itemName).length > 2);
134     require(bytes(_itemDesc).length > 2);
135     require(bytes(_itemURL).length > 2);
136     
137     uint256 _itemId = itemIdCounter;
138     itemIdCounter = itemIdCounter + 1;
139 
140     ownerOfItem[_itemId] = msg.sender;
141     nameOfItem[_itemId] = _itemName;
142     descOfItem[_itemId] = _itemDesc;
143     URLOfItem[_itemId] = _itemURL;
144     pointOfItem[_itemId] = 10; //This is 10 free token for whom sign-up
145     timeOfItem[_itemId] = Time_call();
146     listedItems.push(_itemId);
147     
148     pointArrayOfArray[_itemId].push(10);
149     timeArrayOfArray[_itemId].push(Time_call());
150   }
151 
152   /* Buying */
153   function buyPoints (uint256 _itemId) payable public {
154     require(msg.value > 0);
155     require(ownerOf(_itemId) == msg.sender);
156     require(!isContract(msg.sender));
157     
158     uint256 point = msg.value.mul(L).div(1000000000000000000);
159     
160     pointOfItem[_itemId] = point;
161     timeOfItem[_itemId] = Time_call();
162     
163     owner.transfer(msg.value);
164     
165     pointArrayOfArray[_itemId].push(point);
166     timeArrayOfArray[_itemId].push(Time_call());
167   }
168 
169   /* ERC721 */
170   function implementsERC721() public view returns (bool _implements) {
171     return erc721Enabled;
172   }
173 
174   function name() public pure returns (string _name) {
175     return "DappTalk.org";
176   }
177 
178   function symbol() public pure returns (string _symbol) {
179     return "DTC";
180   }
181 
182   function totalSupply() public view returns (uint256 _totalSupply) {
183     return listedItems.length;
184   }
185 
186   function balanceOf (address _owner) public view returns (uint256 _balance) {
187     uint256 counter = 0;
188 
189     for (uint256 i = 0; i < listedItems.length; i++) {
190       if (ownerOf(listedItems[i]) == _owner) {
191         counter++;
192       }
193     }
194 
195     return counter;
196   }
197 
198   function ownerOf (uint256 _itemId) public view returns (address _owner) {
199     return ownerOfItem[_itemId];
200   }
201 
202   function tokensOf (address _owner) public view returns (uint256[] _tokenIds) {
203     uint256[] memory items = new uint256[](balanceOf(_owner));
204 
205     uint256 itemCounter = 0;
206     for (uint256 i = 0; i < listedItems.length; i++) {
207       if (ownerOf(listedItems[i]) == _owner) {
208         items[itemCounter] = listedItems[i];
209         itemCounter += 1;
210       }
211     }
212 
213     return items;
214   }
215 
216   function tokenExists (uint256 _itemId) public view returns (bool _exists) {
217     return bytes(nameOf(_itemId)).length > 2;
218   }
219 
220   function approvedFor(uint256 _itemId) public view returns (address _approved) {
221     return approvedOfItem[_itemId];
222   }
223 
224   function approve(address _to, uint256 _itemId) onlyERC721() public {
225     require(msg.sender != _to);
226     require(tokenExists(_itemId));
227     require(ownerOf(_itemId) == msg.sender);
228 
229     if (_to == 0) {
230       if (approvedOfItem[_itemId] != 0) {
231         delete approvedOfItem[_itemId];
232         Approval(msg.sender, 0, _itemId);
233       }
234     } else {
235       approvedOfItem[_itemId] = _to;
236       Approval(msg.sender, _to, _itemId);
237     }
238   }
239 
240   function transfer(address _to, uint256 _itemId) onlyERC721() public {
241     require(msg.sender == ownerOf(_itemId));
242     _transfer(msg.sender, _to, _itemId);
243   }
244 
245   function transferFrom(address _from, address _to, uint256 _itemId) onlyERC721() public {
246     require(approvedFor(_itemId) == msg.sender);
247     _transfer(_from, _to, _itemId);
248   }
249 
250   function _transfer(address _from, address _to, uint256 _itemId) internal {
251     require(tokenExists(_itemId));
252     require(ownerOf(_itemId) == _from);
253     require(_to != address(0));
254     require(_to != address(this));
255 
256     ownerOfItem[_itemId] = _to;
257     approvedOfItem[_itemId] = 0;
258 
259     Transfer(_from, _to, _itemId);
260   }
261 
262   /* Read */
263   function isAdmin (address _admin) public view returns (bool _isAdmin) {
264     return admins[_admin];
265   }
266 
267   function nameOf (uint256 _itemId) public view returns (string _itemName) {
268     return nameOfItem[_itemId];
269   }
270   
271   function descOf (uint256 _itemId) public view returns (string _itemDesc) {
272     return descOfItem[_itemId];
273   }
274   
275   function URLOf (uint256 _itemId) public view returns (string _itemURL) {
276     return URLOfItem[_itemId];
277   }
278   
279   function pointOf (uint256 _itemId) public view returns (uint256 _itemPoint) {
280     return pointOfItem[_itemId];
281   }
282   
283   function pointArrayOf (uint256 _itemId) public view returns (uint256[] _pointArray) {
284     return pointArrayOfArray[_itemId];
285   }
286   
287   function timeArrayOf (uint256 _itemId) public view returns (uint256[] _timeArray) {
288     return timeArrayOfArray[_itemId];
289   }
290 
291   function initTimeOf (uint256 _itemId) public view returns (uint256 _initTime) {
292     return timeArrayOfArray[_itemId][0];
293   }
294 
295   function timeOf (uint256 _itemId) public view returns (uint256 _itemTime) {
296     return timeOfItem[_itemId];
297   }
298 
299   function getPointOf (uint256 _itemId) public view returns (uint256 _getPoint) {
300     uint256 t = Time_call();
301     _getPoint = 0;
302     uint256 temp = 0;
303 
304     for (uint256 i = 0; i < pointArrayOfArray[_itemId].length; i++) {
305         if (timeArrayOfArray[_itemId][i] + pointsDecayFactor > t) {
306             temp = timeArrayOfArray[_itemId][i];
307             temp = temp - t;
308             temp = temp + pointsDecayFactor;
309             temp = temp.mul(pointArrayOfArray[_itemId][i]);
310             temp = temp.div(pointsDecayFactor);
311             _getPoint = temp.add(_getPoint);
312         }
313     }
314     
315     return _getPoint;
316   }
317 
318   function allOf (uint256 _itemId) public view returns (address _owner, string _itemName, string _itemDesc, string _itemURL, uint256[] _pointArray, uint256[] _timeArray, uint256 _curPoint) {
319     return (ownerOf(_itemId), nameOf(_itemId), descOf(_itemId), URLOf(_itemId), pointArrayOf(_itemId), timeArrayOf(_itemId), getPointOf(_itemId));
320   }
321   
322   function getAllDapps () public view returns (address[] _owners, bytes32[] _itemNames, bytes32[] _itemDescs, bytes32[] _itemURL, uint256[] _points, uint256[] _initTime, uint256[] _lastTime) {
323       _owners = new address[](itemIdCounter);
324       _itemNames = new bytes32[](itemIdCounter);
325       _itemDescs = new bytes32[](itemIdCounter);
326       _itemURL = new bytes32[](itemIdCounter);
327       _points = new uint256[](itemIdCounter);
328       _initTime = new uint256[](itemIdCounter);
329       _lastTime = new uint256[](itemIdCounter);
330       for (uint256 i = 0; i < itemIdCounter; i++) {
331           _owners[i] = ownerOf(i);
332           _itemNames[i] = stringToBytes32(nameOf(i));
333           _itemDescs[i] = stringToBytes32(descOf(i));
334           _itemURL[i] = stringToBytes32(URLOf(i));
335           _points[i] = getPointOf(i);
336           _initTime[i] = initTimeOf(i);
337           _lastTime[i] = timeOf(i);
338       }
339       return (_owners, _itemNames, _itemDescs, _itemURL, _points, _initTime, _lastTime);
340   }
341 
342   /* Util */
343   function isContract(address addr) internal view returns (bool) {
344     uint size;
345     assembly { size := extcodesize(addr) } // solium-disable-line
346     return size > 0;
347   }
348   
349   function stringToBytes32(string memory source) returns (bytes32 result) {
350         bytes memory tempEmptyStringTest = bytes(source);
351         if (tempEmptyStringTest.length == 0) {
352             return 0x0;
353         }
354     
355         assembly {
356             result := mload(add(source, 32))
357         }
358     }
359 }