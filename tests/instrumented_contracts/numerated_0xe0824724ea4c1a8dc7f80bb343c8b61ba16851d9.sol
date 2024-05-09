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
71     event Converted(address _converter, uint256 _evaluated, address _from, address _to, uint256 _amount, uint256 _return);
72     event SetAvailableProvider(address _converter, address _provider);
73     event SetExtraLimit(uint256 _extraLimit);
74     event RemovedConverter(address _converter);
75     
76     event WithdrawTokens(address _token, address _to, uint256 _amount);
77     event WithdrawEth(address _to, uint256 _amount);
78 
79     /*
80      *  @notice External function isWorker.
81      *  @dev Takes _worker, checks if the worker is valid. 
82      *  @param _worker Worker address.
83      *  @return bool True if worker is valid, false otherwise.
84      */
85     function _issetConverter(address _converter) internal view returns (bool) {
86         return converterToIndex[_converter] != 0;
87     }
88     
89     /*
90     *  @notice External function allConverters.
91     *  @dev Return all convertes.
92     *  @return array with all address the converters.
93     */
94     function getConverters() external view returns (address[] memory result) {
95         result = new address[](converters.length - 1);
96         for (uint256 i = 1; i < converters.length; i++) {
97             result[i - 1] = converters[i];
98         }
99     }
100     
101     /*
102      *  @notice External function addConverter.
103      *  @dev Takes _converter.
104      *       Add converter.
105      *  @param _converter Converter address.
106      *  @return bool True if converter is added, false otherwise.
107      */
108     function addConverter(TokenConverter _converter) external onlyOwner returns (bool) {
109         require(!_issetConverter(_converter), "The converter it already exist");
110         uint256 index = converters.push(_converter) - 1;
111         converterToIndex[_converter] = index;
112         emit AddedConverter(_converter);
113         return true;
114     }
115     
116     /*
117      *  @notice External function removeConverter.
118      *  @dev Takes _converter and removes the converter.
119      *  @param _worker Converter address.
120      *  @return bool true if existed, false otherwise.
121      */
122     function removeConverter(address _converter) external onlyOwner returns (bool) {
123         require(_issetConverter(_converter), "The converter is not exist.");
124         uint256 index = converterToIndex[_converter];
125         TokenConverter lastConverter = converters[converters.length - 1];
126         converterToIndex[lastConverter] = index;
127         converters[index] = lastConverter;
128         converters.length--;
129         delete converterToIndex[_converter];
130         emit RemovedConverter(_converter);
131         return true;
132     }
133     
134     function setAvailableProvider(
135         TokenConverter _converter,
136         AvailableProvider _provider
137     ) external onlyOwner {
138         emit SetAvailableProvider(_converter, _provider);
139         availability[_converter] = _provider;        
140     }
141     
142     function setExtraLimit(uint256 _extraLimit) external onlyOwner {
143         emit SetExtraLimit(_extraLimit);
144         extraLimit = _extraLimit;
145     }
146 
147     function convert(Token _from, Token _to, uint256 _amount, uint256 _minReturn) external payable returns (uint256) {
148         (TokenConverter converter, uint256 evaluated) = _getBestConverter(_from, _to, _amount);
149 
150         if (_from == ETH_ADDRESS) {
151             require(msg.value == _amount, "ETH not enought");
152         } else {
153             require(msg.value == 0, "ETH not required");
154             require(_from.transferFrom(msg.sender, this, _amount), "Error pulling Token amount");
155             require(_from.approve(converter, _amount), "Error approving token transfer");
156         }
157 
158         uint256 result = converter.convert.value(msg.value)(_from, _to, _amount, _minReturn);
159         require(result >= _minReturn, "Funds received below min return");
160 
161         emit Converted({
162             _converter: converter,
163             _from: _from,
164             _to: _to,
165             _amount: _amount,
166             _return: result,
167             _evaluated: evaluated
168         });
169 
170         if (_from != ETH_ADDRESS) {
171             require(_from.approve(converter, 0), "Error removing approve");
172         }
173 
174         if (_to == ETH_ADDRESS) {
175             msg.sender.transfer(result);
176         } else {
177             require(_to.transfer(msg.sender, result), "Error sending tokens");
178         }
179 
180         if (_isSimulation()) {
181             // this is a simulation, we need a pessimistic simulation we add
182             // the extraLimit. reasons: this algorithm is not deterministic
183             // different gas depending on the best route (Kyber, Bancor, etc)
184             _addExtraGasLimit();
185         }
186     }
187 
188     function getReturn(Token _from, Token _to, uint256 _amount) external view returns (uint256) {
189         (TokenConverter best, ) = _getBestConverter(_from, _to, _amount);
190         return best.getReturn(_from, _to, _amount);
191     }
192 
193     function _isSimulation() internal view returns (bool) {
194         return gasleft() > block.gaslimit;
195     }
196     
197     function _addExtraGasLimit() internal view {
198         uint256 limit;
199         uint256 startGas;
200         while (limit < extraLimit) {          
201             startGas = gasleft();
202             assembly {
203                 let x := mload(0x0)
204             }
205             limit += startGas - gasleft();
206         }
207     }
208 
209     function _getBestConverter(Token _from, Token _to, uint256 _amount) internal view returns (TokenConverter, uint256) {
210         uint maxRate;
211         TokenConverter converter;
212         TokenConverter best;
213         uint length = converters.length;
214         uint256 evaluated;
215 
216         for (uint256 i = 0; i < length; i++) {
217             converter = converters[i];
218             if (_isAvailable(converter, _from, _to, _amount)) {
219                 evaluated++;
220                 uint newRate = converter.getReturn(_from, _to, _amount);
221                 if (newRate > maxRate) {
222                     maxRate = newRate;
223                     best = converter;
224                 }
225             }
226         }
227         
228         return (best, evaluated);
229     }
230 
231     function _isAvailable(address converter, Token _from, Token _to, uint256 _amount) internal view returns (bool) {
232         AvailableProvider provider = availability[converter];
233         return provider != address(0) ? provider.isAvailable(_from, _to, _amount) : true;
234     }
235 
236     function withdrawEther(
237         address _to,
238         uint256 _amount
239     ) external onlyOwner {
240         emit WithdrawEth(_to, _amount);
241         _to.transfer(_amount);
242     }
243 
244     function withdrawTokens(
245         Token _token,
246         address _to,
247         uint256 _amount
248     ) external onlyOwner returns (bool) {
249         emit WithdrawTokens(_token, _to, _amount);
250         return _token.transfer(_to, _amount);
251     }
252 
253     function() external payable {}
254 }