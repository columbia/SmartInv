1 pragma solidity ^0.4.21;
2 
3 
4 /** @title Manager
5   * @author M.H. Kang
6   */
7 contract Managed {
8 
9   event Commission(uint256 basisPoint);
10 
11   address public manager;
12   uint256 public commission;
13 
14   function Managed() public {
15     manager = msg.sender;
16   }
17 
18   function() public payable {}
19 
20   /* FUNCTION */
21 
22   function setCommission(uint256 _commission) external {
23     require(_commission < 10000);
24     commission = _commission;
25 
26     emit Commission(commission);
27   }
28 
29   function withdrawBalance() external {
30     manager.transfer(address(this).balance);
31   }
32 
33   function transferPower(address _newManager) external onlyManager {
34     manager = _newManager;
35   }
36 
37   function callFor(address _to, uint256 _value, uint256 _gas, bytes _code)
38     external
39     payable
40     onlyManager
41     returns (bool)
42   {
43     return _to.call.value(_value).gas(_gas)(_code);
44   }
45 
46   /* MODIFIER */
47 
48   modifier onlyManager
49   {
50     require(msg.sender == manager);
51     _;
52   }
53 
54 }
55 
56 
57 /** @title EthernameRaw
58   * @author M.H. Kang
59   */
60 contract EthernameRaw is Managed {
61 
62   /* EVENT */
63 
64   event Transfer(
65     address indexed from,
66     address indexed to,
67     bytes32 indexed name
68   );
69   event Approval(
70     address indexed owner,
71     address indexed approved,
72     bytes32 indexed name
73   );
74   event SendEther(
75     address indexed from,
76     address indexed to,
77     bytes32 sender,
78     bytes32 recipient,
79     uint256 value
80   );
81   event Name(address indexed owner, bytes32 indexed name);
82   event Price(bytes32 indexed name, uint256 price);
83   event Buy(bytes32 indexed name, address buyer, uint256 price);
84   event Attribute(bytes32 indexed name, bytes32 key);
85 
86   /* DATA STRUCT */
87 
88   struct Record {
89     address owner;
90     uint256 price;
91     mapping (bytes32 => bytes) attrs;
92   }
93 
94   /* STORAGE */
95 
96   string public constant name = "Ethername";
97   string public constant symbol = "ENM";
98 
99   mapping (address => bytes32) public ownerToName;
100   mapping (bytes32 => Record) public nameToRecord;
101   mapping (bytes32 => address) public nameToApproved;
102 
103   /* FUNCTION */
104 
105   function rawRegister(bytes32 _name) public payable {
106     _register(_name, msg.sender);
107   }
108 
109   function rawTransfer(address _to, bytes32 _name)
110     public
111     onlyOwner(msg.sender, _name)
112   {
113     _transfer(msg.sender, _to, _name);
114   }
115 
116   function rawApprove(address _to, bytes32 _name)
117     public
118     onlyOwner(msg.sender, _name)
119   {
120     _approve(msg.sender, _to, _name);
121   }
122 
123   function rawTransferFrom(address _from, address _to, bytes32 _name)
124     public
125     onlyOwner(_from, _name)
126     onlyApproved(msg.sender, _name)
127   {
128     _transfer(_from, _to, _name);
129   }
130 
131   function rawSetPrice(bytes32 _name, uint256 _price)
132     public
133     onlyOwner(msg.sender, _name)
134   {
135     require(_price == uint256(uint128(_price)));
136     nameToRecord[_name].price = _price;
137 
138     emit Price(_name, _price);
139   }
140 
141   function rawBuy(bytes32 _name) public payable {
142     Record memory _record = nameToRecord[_name];
143     require(_record.price > 0);
144     uint256 _price = _computePrice(_record.price);
145     require(msg.value >= _price);
146 
147     _record.owner.transfer(_record.price);
148     _transfer(_record.owner, msg.sender, _name);
149     msg.sender.transfer(msg.value - _price);
150 
151     emit Buy(_name, msg.sender, _price);
152   }
153 
154   function rawUseName(bytes32 _name) public onlyOwner(msg.sender, _name) {
155     _useName(msg.sender, _name);
156   }
157 
158   function rawSetAttribute(bytes32 _name, bytes32 _key, bytes _value)
159     public
160     onlyOwner(msg.sender, _name)
161   {
162     nameToRecord[_name].attrs[_key] = _value;
163 
164     emit Attribute(_name, _key);
165   }
166 
167   function rawWipeAttributes(bytes32 _name, bytes32[] _keys)
168     public
169     onlyOwner(msg.sender, _name)
170   {
171     mapping (bytes32 => bytes) attrs = nameToRecord[_name].attrs;
172 		for (uint i = 0; i < _keys.length; i++) {
173       delete attrs[_keys[i]];
174 
175       emit Attribute(_name, _keys[i]);
176 		}
177   }
178 
179   function rawSendEther(bytes32 _name) public payable returns (bool _result) {
180     address _to = nameToRecord[_name].owner;
181     _result = (_name != bytes32(0)) &&
182       (_to != address(0)) &&
183       _to.send(msg.value);
184     if (_result) {
185       emit SendEther(
186         msg.sender,
187         _to,
188         rawNameOf(msg.sender),
189         _name,
190         msg.value
191       );
192     }
193   }
194 
195   /* VIEW FUNCTION */
196 
197   function rawNameOf(address _address) public view returns (bytes32 _name) {
198     _name = ownerToName[_address];
199   }
200 
201   function rawOwnerOf(bytes32 _name) public view returns (address _owner) {
202     _owner = nameToRecord[_name].owner;
203   }
204 
205   function rawDetailsOf(bytes32 _name, bytes32 _key)
206     public
207     view
208     returns (address _owner, uint256 _price, bytes _value)
209   {
210     _owner = nameToRecord[_name].owner;
211     _price = _computePrice(nameToRecord[_name].price);
212     _value = nameToRecord[_name].attrs[_key];
213   }
214 
215   /* INTERNAL FUNCTION */
216 
217   function _register(bytes32 _name, address _to) internal {
218     require(nameToRecord[_name].owner == address(0));
219 		for (uint i = 0; i < _name.length; i++) {
220 		 	require((_name[i] == 0) ||
221               (_name[i] > 96 && _name[i] < 123) ||
222               (_name[i] > 47 && _name[i] < 58));
223 		}
224 
225     _transfer(0, _to, _name);
226   }
227 
228   /**
229    * @dev When transferred,
230    *  price and approved are set to 0 but attrs remains.
231    */
232   function _transfer(address _from, address _to, bytes32 _name) internal {
233     address _null = address(0);
234 
235     if (nameToApproved[_name] != _null) {
236       _approve(_from, _null, _name);
237     }
238 
239     if (ownerToName[_from] == _name) {
240       _useName(_from, 0);
241     }
242 
243     nameToRecord[_name] = Record(_to, 0);
244 
245     if (ownerToName[_to] == bytes32(0)) {
246       _useName(_to, _name);
247     }
248 
249     emit Transfer(_from, _to, _name);
250   }
251 
252   function _approve(address _owner, address _to, bytes32 _name) internal {
253     nameToApproved[_name] = _to;
254     emit Approval(_owner, _to, _name);
255   }
256 
257   function _useName(address _owner, bytes32 _name) internal {
258     ownerToName[_owner] = _name;
259     emit Name(_owner, _name);
260   }
261 
262   function _computePrice(uint256 _price) internal view returns (uint256) {
263     return _price * (10000 + commission) / 10000;
264   }
265 
266   function _stringToBytes32(string _string)
267     internal
268     pure
269     returns (bytes32 _bytes32)
270   {
271     require(bytes(_string).length < 33);
272     assembly {
273       _bytes32 := mload(add(_string, 0x20))
274     }
275   }
276 
277   function _bytes32ToString(bytes32 _bytes32)
278     internal
279     pure
280     returns (string _string)
281   {
282     assembly {
283       let m := mload(0x40)
284       mstore(m, 0x20)
285       mstore(add(m, 0x20), _bytes32)
286       mstore(0x40, add(m, 0x40))
287       _string := m
288     }
289   }
290 
291   /* MODIFIER */
292 
293   modifier onlyOwner(address _claimant, bytes32 _name) {
294     require(nameToRecord[_name].owner == _claimant);
295     _;
296   }
297 
298   modifier onlyApproved(address _claimant, bytes32 _name) {
299     require(nameToApproved[_name] == _claimant);
300     _;
301   }
302 
303 }
304 
305 /** @title Ethername
306   * @author M.H. Kang
307   * @notice This contract is designed for any DAPPs to have
308   *  username feature without additional implementation.
309   */
310 contract Ethername is EthernameRaw {
311 
312   /* CONSTRUCTOR */
313 
314   function Ethername() public {
315     commission = 200;
316 
317     // reserved word
318     nameToRecord[bytes32('')] = Record(this, 0);
319 
320     // initial register
321     _register(bytes32('ethername'), this);
322     _register(bytes32('root'), msg.sender);
323   }
324 
325 
326   /* FUNCTION */
327 
328   function register(string _name) external payable {
329     rawRegister(_stringToBytes32(_name));
330   }
331 
332   function transfer(address _to, string _name) external {
333     rawTransfer(_to, _stringToBytes32(_name));
334   }
335 
336   function approve(address _to, string _name) external {
337     rawApprove(_to, _stringToBytes32(_name));
338   }
339 
340   function transferFrom(address _from, address _to, string _name) external {
341     rawTransferFrom(_from, _to, _stringToBytes32(_name));
342   }
343 
344   function setPrice(string _name, uint256 _price) external {
345     rawSetPrice(_stringToBytes32(_name), _price);
346   }
347 
348   function buy(string _name) external payable {
349     rawBuy(_stringToBytes32(_name));
350   }
351 
352   function useName(string _name) external {
353     rawUseName(_stringToBytes32(_name));
354   }
355 
356   function setAttribute(string _name, string _key, bytes _value) external {
357     rawSetAttribute(_stringToBytes32(_name), _stringToBytes32(_key), _value);
358   }
359 
360   function wipeAttributes(string _name, bytes32[] _keys) external {
361     rawWipeAttributes(_stringToBytes32(_name), _keys);
362   }
363 
364   function sendEther(string _name) external payable returns (bool _result) {
365     _result = rawSendEther(_stringToBytes32(_name));
366   }
367 
368   /* VIEW FUNCTION */
369 
370   function nameOf(address _address) external view returns (string _name) {
371     _name = _bytes32ToString(rawNameOf(_address));
372   }
373 
374   function ownerOf(string _name) external view returns (address _owner) {
375     _owner = rawOwnerOf(_stringToBytes32(_name));
376   }
377 
378   function detailsOf(string _name, string _key)
379     external
380     view
381     returns (address _owner, uint256 _price, bytes _value)
382   {
383     return rawDetailsOf(_stringToBytes32(_name), _stringToBytes32(_key));
384   }
385 
386 }