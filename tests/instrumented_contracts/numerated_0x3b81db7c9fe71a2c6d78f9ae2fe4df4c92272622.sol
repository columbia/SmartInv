1 pragma solidity ^0.4.24;
2 
3 // File: contracts/interfaces/Token.sol
4 
5 contract Token {
6     function transfer(address _to, uint _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
9     function approve(address _spender, uint256 _value) public returns (bool success);
10     function increaseApproval (address _spender, uint _addedValue) public returns (bool success);
11     function balanceOf(address _owner) public view returns (uint256 balance);
12 }
13 
14 // File: contracts/interfaces/TokenConverter.sol
15 
16 contract TokenConverter {
17     address public constant ETH_ADDRESS = 0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;
18     function getReturn(Token _fromToken, Token _toToken, uint256 _fromAmount) external view returns (uint256 amount);
19     function convert(Token _fromToken, Token _toToken, uint256 _fromAmount, uint256 _minReturn) external payable returns (uint256 amount);
20 }
21 
22 // File: contracts/interfaces/AvailableProvider.sol
23 
24 interface AvailableProvider {
25    function isAvailable(Token _from, Token _to, uint256 _amount) external view returns (bool);
26 }
27 
28 // File: contracts/utils/Ownable.sol
29 
30 contract Ownable {
31     address public owner;
32 
33     event SetOwner(address _owner);
34 
35     modifier onlyOwner() {
36         require(msg.sender == owner, "msg.sender is not the owner");
37         _;
38     }
39 
40     constructor() public {
41         owner = msg.sender;
42         emit SetOwner(msg.sender);
43     }
44 
45     /**
46         @dev Transfers the ownership of the contract.
47 
48         @param _to Address of the new owner
49     */
50     function transferTo(address _to) public onlyOwner returns (bool) {
51         require(_to != address(0), "Can't transfer to address 0x0");
52         emit SetOwner(_to);
53         owner = _to;
54         return true;
55     }
56 }
57 
58 // File: contracts/TokenConverterRouter.sol
59 
60 contract TokenConverterRouter is TokenConverter, Ownable {
61     address public constant ETH_ADDRESS = 0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;
62 
63     TokenConverter[] public converters;
64     
65     mapping(address => uint256) private converterToIndex;    
66     mapping (address => AvailableProvider) public availability;
67 
68     uint256 extraLimit;
69     
70     event AddedConverter(address _converter);
71     event Converted(address _converter, address _from, address _to, uint256 _amount, uint256 _return);
72     event SetAvailableProvider(address _converter, address _provider);
73     event SetExtraLimit(uint256 _extraLimit);
74     event RemovedConverter(address _converter);
75 
76     event ConverterEvaluated(address _converter, address _from, address _to, uint256 _srcQty, uint256 _destQty);
77     event ConverterNotAvailable(address _converter, address _provider, address _from, address _to, uint256 _srcQty);
78     event ConverterError(address _converter, address _from, address _to, uint256 _srcQty);
79     event ConverterAvailableError(address _converter, address _provider, address _from, address _to, uint256 _srcQty);
80 
81     event WithdrawTokens(address _token, address _to, uint256 _amount);
82     event WithdrawEth(address _to, uint256 _amount);
83 
84     /*
85      *  @notice External function isWorker.
86      *  @dev Takes _worker, checks if the worker is valid. 
87      *  @param _worker Worker address.
88      *  @return bool True if worker is valid, false otherwise.
89      */
90     function _issetConverter(address _converter) internal view returns (bool) {
91         return converterToIndex[_converter] != 0;
92     }
93     
94     /*
95     *  @notice External function allConverters.
96     *  @dev Return all convertes.
97     *  @return array with all address the converters.
98     */
99     function getConverters() external view returns (address[] memory result) {
100         result = new address[](converters.length - 1);
101         for (uint256 i = 1; i < converters.length; i++) {
102             result[i - 1] = converters[i];
103         }
104     }
105     
106     /*
107      *  @notice External function addConverter.
108      *  @dev Takes _converter.
109      *       Add converter.
110      *  @param _converter Converter address.
111      *  @return bool True if converter is added, false otherwise.
112      */
113     function addConverter(TokenConverter _converter) external onlyOwner returns (bool) {
114         require(!_issetConverter(_converter), "The converter it already exist");
115         uint256 index = converters.push(_converter) - 1;
116         converterToIndex[_converter] = index;
117         emit AddedConverter(_converter);
118         return true;
119     }
120     
121     /*
122      *  @notice External function removeConverter.
123      *  @dev Takes _converter and removes the converter.
124      *  @param _worker Converter address.
125      *  @return bool true if existed, false otherwise.
126      */
127     function removeConverter(address _converter) external onlyOwner returns (bool) {
128         require(_issetConverter(_converter), "The converter is not exist.");
129         uint256 index = converterToIndex[_converter];
130         TokenConverter lastConverter = converters[converters.length - 1];
131         converterToIndex[lastConverter] = index;
132         converters[index] = lastConverter;
133         converters.length--;
134         delete converterToIndex[_converter];
135         emit RemovedConverter(_converter);
136         return true;
137     }
138     
139     function setAvailableProvider(
140         TokenConverter _converter,
141         AvailableProvider _provider
142     ) external onlyOwner {
143         emit SetAvailableProvider(_converter, _provider);
144         availability[_converter] = _provider;        
145     }
146     
147     function setExtraLimit(uint256 _extraLimit) external onlyOwner {
148         emit SetExtraLimit(_extraLimit);
149         extraLimit = _extraLimit;
150     }
151 
152     function convert(Token _from, Token _to, uint256 _amount, uint256 _minReturn) external payable returns (uint256 result) {
153         TokenConverter converter = _getBestConverter(_from, _to, _amount);
154         require(converter != address(0), "No converter candidates");
155 
156         if (_from == ETH_ADDRESS) {
157             require(msg.value == _amount, "ETH not enought");
158         } else {
159             require(msg.value == 0, "ETH not required");
160             require(_from.transferFrom(msg.sender, this, _amount), "Error pulling Token amount");
161             require(_from.approve(converter, _amount), "Error approving token transfer");
162         }
163 
164         result = converter.convert.value(msg.value)(_from, _to, _amount, _minReturn);
165         require(result >= _minReturn, "Funds received below min return");
166 
167         emit Converted({
168             _converter: converter,
169             _from: _from,
170             _to: _to,
171             _amount: _amount,
172             _return: result
173         });
174 
175         if (_from != ETH_ADDRESS) {
176             require(_from.approve(converter, 0), "Error removing approve");
177         }
178 
179         if (_to == ETH_ADDRESS) {
180             msg.sender.transfer(result);
181         } else {
182             require(_to.transfer(msg.sender, result), "Error sending tokens");
183         }
184 
185         if (_isSimulation()) {
186             // this is a simulation, we need a pessimistic simulation we add
187             // the extraLimit. reasons: this algorithm is not deterministic
188             // different gas depending on the best route (Kyber, Bancor, etc)
189             _addExtraGasLimit();
190         }
191     }
192 
193     function getReturn(Token _from, Token _to, uint256 _amount) external view returns (uint256) {
194         return _getBestConverterView(_from, _to, _amount).getReturn(_from, _to, _amount);
195     }
196 
197     function _isSimulation() internal view returns (bool) {
198         return gasleft() > block.gaslimit;
199     }
200     
201     function _addExtraGasLimit() internal view {
202         uint256 startGas = gasleft();
203         while (startGas - gasleft() < extraLimit) {          
204             assembly {
205                 let x := mload(0x0)
206             }
207         }
208     }
209 
210     function _getBestConverterView(Token _from, Token _to, uint256 _amount) internal view returns (TokenConverter best) {
211         uint256 length = converters.length;
212         bytes32 bestReturn;
213 
214         for (uint256 i = 0; i < length; i++) {
215             TokenConverter converter = converters[i];
216             if (_isAvailableView(converter, _from, _to, _amount)) {
217                 (uint256 success, bytes32 newReturn) = _safeStaticCall(
218                     converter,
219                     abi.encodeWithSelector(
220                         converter.getReturn.selector,
221                         _from,
222                         _to,
223                         _amount
224                     )
225                 );
226 
227                 if (success == 1 && newReturn > bestReturn) {
228                     bestReturn = newReturn;
229                     best = converter;
230                 }
231             }
232         }
233     }
234 
235     function _getBestConverter(Token _from, Token _to, uint256 _amount) internal returns (TokenConverter best) {
236         uint256 length = converters.length;
237         bytes32 bestReturn;
238 
239         for (uint256 i = 0; i < length; i++) {
240             TokenConverter converter = converters[i];
241             if (_isAvailable(converter, _from, _to, _amount)) {
242                 (uint256 success, bytes32 newReturn) = _safeCall(
243                     converter,
244                     abi.encodeWithSelector(
245                         converter.getReturn.selector,
246                         _from,
247                         _to,
248                         _amount
249                     )
250                 );
251 
252                 if (success == 1) {
253                     emit ConverterEvaluated(converter, _from, _to, _amount, uint256(newReturn));
254                     if (newReturn > bestReturn) {
255                         bestReturn = newReturn;
256                         best = converter;
257                     }
258                 } else {
259                     emit ConverterError(converter, _from, _to, _amount);
260                 }
261             }
262         }
263     }
264 
265     function _isAvailable(address converter, Token _from, Token _to, uint256 _amount) internal returns (bool) {
266         AvailableProvider provider = availability[converter];
267         if (provider == address(0)) return true;
268         (uint256 success,bytes32 available) = _safeCall(
269             provider, abi.encodeWithSelector(
270                 provider.isAvailable.selector,
271                 _from,
272                 _to,
273                 _amount
274             )
275         );
276 
277         if (success != 1) {
278             emit ConverterAvailableError(converter, provider, _from, _to, _amount);
279             return false;
280         }
281 
282         if (available != bytes32(1)) {
283             emit ConverterNotAvailable(converter, provider, _from, _to, _amount);
284             return false;
285         }
286         
287         return true;
288     }
289 
290     function _isAvailableView(address converter, Token _from, Token _to, uint256 _amount) internal view returns (bool) {
291         AvailableProvider provider = availability[converter];
292         if (provider == address(0)) return true;
293         (uint256 success,bytes32 available) = _safeStaticCall(
294             provider, abi.encodeWithSelector(
295                 provider.isAvailable.selector,
296                 _from,
297                 _to,
298                 _amount
299             )
300         );
301         return success == 1 && available == bytes32(1);
302     }
303 
304     function withdrawEther(
305         address _to,
306         uint256 _amount
307     ) external onlyOwner {
308         emit WithdrawEth(_to, _amount);
309         _to.transfer(_amount);
310     }
311 
312     function withdrawTokens(
313         Token _token,
314         address _to,
315         uint256 _amount
316     ) external onlyOwner returns (bool) {
317         emit WithdrawTokens(_token, _to, _amount);
318         return _token.transfer(_to, _amount);
319     }
320 
321     function _safeStaticCall(
322         address _contract,
323         bytes _data
324     ) internal view returns (uint256 success, bytes32 result) {
325         assembly {
326             let x := mload(0x40)
327             success := staticcall(
328                             gas,                  // Send almost all gas
329                             _contract,            // To addr
330                             add(0x20, _data),     // Input is data past the first 32 bytes
331                             mload(_data),         // Input size is the lenght of data
332                             x,                    // Store the ouput on x
333                             0x20                  // Output is a single bytes32, has 32 bytes
334                         )
335 
336             result := mload(x)
337         }
338     }
339 
340     function _safeCall(
341         address _contract,
342         bytes _data
343     ) internal returns (uint256 success, bytes32 result) {
344         assembly {
345             let x := mload(0x40)
346             success := call(
347                             gas,                  // Send almost all gas
348                             _contract,            // To addr
349                             0,                    // Send ETH
350                             add(0x20, _data),     // Input is data past the first 32 bytes
351                             mload(_data),         // Input size is the lenght of data
352                             x,                    // Store the ouput on x
353                             0x20                  // Output is a single bytes32, has 32 bytes
354                         )
355 
356             result := mload(x)
357         }
358     }
359 
360     function() external payable {}
361 }