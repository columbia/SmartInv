1 pragma solidity ^0.5.17;
2 
3 
4 library SafeMath {
5     function add(uint a, uint b) internal pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function sub(uint a, uint b) internal pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function mul(uint a, uint b) internal pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function div(uint a, uint b) internal pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 
23 
24 contract tERC20 {
25     function transferFrom(address _from, address _to, uint256 _value) public;
26 }
27 
28 
29 contract Pcontract {
30     function () payable external {}
31     function callContract(address _contract, uint256 _EthAmount, bytes calldata _data) external;
32     function approve(address _contract, uint256 _amount) external;
33 }
34 
35 
36 contract Owned {
37     address public owner;
38     address public newOwner;
39     
40     event OwnershipTransferred(address indexed _from, address indexed _to);
41     
42     constructor() public {
43         owner = msg.sender;
44     }
45     
46     modifier onlyOwner {
47         require(msg.sender == owner, "Sender Must be Owner");
48         _;
49     }
50     
51     function transferOwnership(address _newOwner) public onlyOwner {
52         newOwner = _newOwner;
53     }
54     
55     function acceptOwnership() public {
56         require(msg.sender == newOwner);
57         emit OwnershipTransferred(owner, newOwner);
58         owner = newOwner;
59         newOwner = address(0);
60     }
61     
62     
63 }
64 
65 contract Signs {
66     
67     constructor() public {}
68     
69     
70     function getSigner(string memory _func, address _to, uint256 _EthAmount, uint256 _amount, string memory _ticker, string memory _feeTicker, uint256 _nonce, bool _parent, bytes memory _cdata, bytes memory _sign) public view returns (address){
71         bytes32 typedData = keccak256(
72             abi.encodePacked( byte(0x19), byte(0x01), 
73                 keccak256(abi.encode(
74                     keccak256(abi.encodePacked("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)")),
75                     keccak256("MetaTransact"), //dappName
76                     keccak256("1.2"), //version
77                     1, // network
78                     this, 
79                     0x6572776572776c48385a7978356c7430556b5554324c47664b6331756b364e53
80                 )),
81                 keccak256(abi.encode( keccak256(abi.encodePacked("MetaTransact(string Method,address Address,uint256 EthAmount,uint256 Amount,string Ticker,string FeeTicker,uint256 Nonce,bool IsParent,bytes InputData)")) ,
82                     keccak256(bytes(_func)), _to, _EthAmount, _amount, keccak256(bytes(_ticker)), keccak256(bytes(_feeTicker)), _nonce, _parent, keccak256(_cdata)
83                 ))
84             )
85         );
86         
87         return recover(typedData, _sign);
88     }
89     
90     
91     function recover(bytes32 hash, bytes memory signature) internal pure returns (address){
92         bytes32 r;
93         bytes32 s;
94         uint8 v;
95 
96         (v, r, s) = splitSignature(signature);
97 
98         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
99         if (v < 27) {
100             v += 27;
101         }
102 
103         // If the version is correct return the signer address
104         if (v != 27 && v != 28) {
105             return (address(0));
106         } else {
107             // solium-disable-next-line arg-overflow
108             return ecrecover(hash, v, r, s);
109         }
110     }
111     
112     
113     function splitSignature(bytes memory sig) internal pure returns (uint8, bytes32, bytes32){
114         require(sig.length == 65);
115 
116         bytes32 r;
117         bytes32 s;
118         uint8 v;
119 
120         assembly {
121             // first 32 bytes, after the length prefix
122             r := mload(add(sig, 32))
123             // second 32 bytes
124             s := mload(add(sig, 64))
125             // final byte (first byte of the next 32 bytes)
126             v := byte(0, mload(add(sig, 96)))
127         }
128         return (v, r, s);
129     }
130 }
131 
132 
133 contract metaTransact is Owned, Signs {
134     using SafeMath for uint256;
135     
136     
137     address public proxyContract;
138     
139     mapping(string  => address) public tickers;
140     mapping(address => uint256) public tickerFee;
141     
142     mapping(address => uint256) public currentNonce;
143     mapping(address => address payable) public userProxy;
144     mapping(address => address) public parantAddress;
145     
146     mapping(address => addressMeta) metaAddresses;
147     
148     
149     struct addressMeta {
150         uint currIndex;
151         mapping(uint => address) childAddresses;
152         mapping(address => mapping(address => uint256)) allowances;
153     }
154     
155     
156     
157     
158     constructor() public {}
159     
160     
161     function interactDappUProxy(address _dapp, uint256 _EthAmount, uint256 _amount, string calldata _feeTicker, uint256 _nonce, bytes calldata _sign, bytes calldata _calldata, address _relayer) external {
162         require(tickers[_feeTicker] != address(0x0));
163         
164         address cAddress = getSigner("interactDappUProxy", _dapp, _EthAmount, _amount, "", _feeTicker, _nonce, false, _calldata, _sign);
165         address payable cpAddress = userProxy[cAddress];
166         
167         require(cpAddress != address(0x0));
168         require(currentNonce[cpAddress] == _nonce);
169         currentNonce[cpAddress] = currentNonce[cpAddress].add(1);
170         
171         internalTransfer(cpAddress, _relayer, _amount, false, tickers[_feeTicker], address(0x0), address(0x0));
172         Pcontract(cpAddress).callContract(_dapp, _EthAmount, _calldata);
173     }
174     
175     
176     function interactDapp(address _dapp, uint256 _EthAmount, uint256 _amount, string calldata _feeTicker, uint256 _nonce, bytes calldata _sign, bytes calldata _calldata, address _relayer) external {
177         require(tickers[_feeTicker] != address(0x0));
178         
179         address cAddress = getSigner("interactDapp", _dapp, _EthAmount, _amount, "", _feeTicker, _nonce, false, _calldata, _sign);
180         address payable cpAddress = userProxy[cAddress];
181         
182         require(cpAddress != address(0x0));
183         require(currentNonce[cAddress] == _nonce);
184         currentNonce[cAddress] = currentNonce[cAddress].add(1);
185         
186         internalTransfer(cAddress, _relayer, _amount, false, tickers[_feeTicker], address(0x0), address(0x0));
187         Pcontract(cpAddress).callContract(_dapp, _EthAmount, _calldata);
188     }
189     
190     
191     function processTxn(address _to, uint256 _amount, string calldata _ticker, string calldata _feeTicker, uint256 _nonce, bool _isParent, bytes calldata _sign, address _relayer) external {
192         address cAddress = getSigner("processTxn", _to, 0, _amount, _ticker, _feeTicker, _nonce, _isParent, bytes(""), _sign);
193         address tickerAddress = tickers[_ticker];
194         address feeTickerAddress;
195         
196         if(keccak256(abi.encodePacked(_ticker)) == keccak256(abi.encodePacked(_feeTicker))){
197             feeTickerAddress = tickerAddress;
198             require(tickerAddress != address(0x0));
199         } else {
200             feeTickerAddress = tickers[_feeTicker];
201             require(tickerAddress != address(0x0) && feeTickerAddress != address(0x0));
202         }
203         
204         
205         if(_isParent){
206             address pAddress = parantAddress[cAddress];
207             require(pAddress != address(0x0));
208             
209             addressMeta storage am = metaAddresses[pAddress];
210             
211             require(am.allowances[cAddress][tickerAddress] >= _amount);
212             am.allowances[cAddress][tickerAddress] = am.allowances[cAddress][tickerAddress].sub(_amount);
213             
214             if(tickerAddress != feeTickerAddress){
215                 uint256 _fee = tickerFee[feeTickerAddress];
216                 require(am.allowances[cAddress][feeTickerAddress] >= _fee);
217                 am.allowances[cAddress][feeTickerAddress] = am.allowances[cAddress][feeTickerAddress].sub(_fee);
218             }
219             
220             cAddress = pAddress;
221         } 
222         
223         require(currentNonce[cAddress] == _nonce);
224         currentNonce[cAddress] = currentNonce[cAddress].add(1);
225         
226         internalTransfer(cAddress, _to, _amount, true, tickerAddress, feeTickerAddress, _relayer);
227     }
228     
229     
230     
231     
232     
233     function internalTransfer(address _from, address _to, uint256 _amount, bool _payfee, address _tickerAddress, address _feeTickerAddress, address _relayer) internal {
234         if(_payfee){
235             uint256 _fee = tickerFee[_feeTickerAddress];
236             if(_fee > 0){
237                 if(_tickerAddress == _feeTickerAddress){
238                     require(_amount > _fee);
239                     _amount = _amount.sub(_fee);
240                 }
241                 
242                 tERC20(_feeTickerAddress).transferFrom(_from, _relayer, _fee);
243             }
244         }
245         
246         if(_amount > 0){
247             tERC20(_tickerAddress).transferFrom(_from, _to, _amount);
248         }
249     }
250     
251     
252     
253     
254     
255     
256     
257     
258     function createProxy(address _address) external {
259         require(proxyContract != address(0x0));
260         require(userProxy[_address] == address(0x0));
261         
262         address payable _proxyAddress;
263         bytes20 targetBytes = bytes20(proxyContract);
264         
265         assembly {
266             let clone := mload(0x40)
267             mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
268             mstore(add(clone, 0x14), targetBytes)
269             mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
270             _proxyAddress := create(0, clone, 0x37)
271         }
272         
273         userProxy[_address] = address(_proxyAddress);
274     }
275     
276     
277     function createProxyUT(address _address, uint256 _amount, string calldata _feeTicker, uint256 _nonce, bytes calldata _sign, address _relayer) external {
278         address cAddress = getSigner("createProxyUT", _address, 0, _amount, "", _feeTicker, _nonce, false, bytes(""), _sign);
279         
280         require(proxyContract != address(0x0));
281         require(userProxy[_address] == address(0x0));
282         require(tickers[_feeTicker] != address(0x0));
283         
284         require(currentNonce[cAddress] == _nonce);
285         currentNonce[cAddress] = currentNonce[cAddress].add(1);
286         
287         internalTransfer(cAddress, _relayer, _amount, false, tickers[_feeTicker], address(0x0), address(0x0));
288         
289         address payable _proxyAddress;
290         bytes20 targetBytes = bytes20(proxyContract);
291         
292         assembly {
293             let clone := mload(0x40)
294             mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
295             mstore(add(clone, 0x14), targetBytes)
296             mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
297             _proxyAddress := create(0, clone, 0x37)
298         }
299         
300         userProxy[_address] = address(_proxyAddress);
301     }
302     
303     
304     
305     function pApprove(address _address, string calldata _ticker, uint256 _amount) external {
306         require(tickers[_ticker] != address(0x0));
307         require(userProxy[_address] != address(0x0));
308         
309         Pcontract(userProxy[_address]).approve(tickers[_ticker], _amount);
310     }
311     
312     
313     
314     
315     //  ----------------------------------------------------------------------------
316     
317     
318     function getTotalChild(address _address) public view returns (uint) {
319         addressMeta storage am = metaAddresses[_address];
320         return am.currIndex;
321     }
322     
323     
324     function getChildAddressAtIndex(address _parent, uint _index) public view returns (address) {
325         addressMeta storage am = metaAddresses[_parent];
326         return am.childAddresses[_index];
327     }
328     
329     
330     function getChildAllowance(address _parent, address _childAddress, string memory _ticker) public view returns (uint) {
331         addressMeta storage am = metaAddresses[_parent];
332         return am.allowances[_childAddress][tickers[_ticker]];
333     }
334     
335     
336     // ----------------------------------------------------------------------------
337     
338     function addChildAddress(address _child) external {
339         require(parantAddress[_child] == address(0x0));
340         
341         addressMeta storage am = metaAddresses[msg.sender];
342         am.childAddresses[am.currIndex] = _child;
343         am.currIndex = (am.currIndex).add(1);
344         
345         parantAddress[_child] = msg.sender;
346     }
347     
348     
349     function addChildAddressUT(address _child, string calldata _feeTicker, uint256 _nonce, bytes calldata _sign, address _relayer) external {
350         require(parantAddress[_child] == address(0x0));
351         address cAddress = getSigner("addChildAddressUT", _child, 0, 0, "", _feeTicker, _nonce, false, bytes(""), _sign);
352         
353         
354         require(currentNonce[cAddress] == _nonce);
355         currentNonce[cAddress] = currentNonce[cAddress].add(1);
356         
357         address feeTickerAddress = tickers[_feeTicker];
358         require(feeTickerAddress != address(0x0));
359         
360         internalTransfer(cAddress, _relayer, tickerFee[feeTickerAddress], false, feeTickerAddress, address(0x0), address(0x0));
361         
362         
363         addressMeta storage am = metaAddresses[cAddress];
364         am.childAddresses[am.currIndex] = _child;
365         am.currIndex = (am.currIndex).add(1);
366         
367         parantAddress[_child] = cAddress;
368     }
369     
370     
371     // -------------------------------
372     
373     
374     function _childAllowance(address _parent, address _child, address _tickerAddress, uint256 _allowance) internal {
375         addressMeta storage am = metaAddresses[_parent];
376         am.allowances[_child][_tickerAddress] = _allowance;
377     }
378     
379     
380     
381     function childAllowance(address _child, uint256 _allowance, string calldata _ticker) external {
382         address tickerAddress = tickers[_ticker];
383         require(tickerAddress != address(0x0));
384         require(parantAddress[_child] == msg.sender);
385         
386         addressMeta storage am = metaAddresses[msg.sender];
387         am.allowances[_child][tickerAddress] = _allowance;
388     }
389     
390     
391     function childAllowanceUT(address _child, uint256 _allowance, string calldata _ticker, string calldata _feeTicker, uint256 _nonce, bytes calldata _sign, address _relayer) external {
392         address cAddress = getSigner("childAllowanceUT", _child, 0, _allowance, _ticker, _feeTicker, _nonce, false, bytes(""), _sign);
393         
394         require(parantAddress[_child] == cAddress);
395         require(currentNonce[cAddress] == _nonce);
396         currentNonce[cAddress] = currentNonce[cAddress].add(1);
397         
398         
399         address tickerAddress = tickers[_ticker];
400         address feeTickerAddress = tickers[_feeTicker];
401         require(tickerAddress != address(0x0) && feeTickerAddress != address(0x0));
402         
403         internalTransfer(cAddress, _relayer, tickerFee[feeTickerAddress], false, feeTickerAddress, address(0x0), address(0x0));
404         _childAllowance(cAddress, _child, tickerAddress, _allowance);
405     }
406     
407     
408     // ----------------------------------------------------------------------------
409     
410     
411     function destroyNonce() external {
412         currentNonce[msg.sender] = currentNonce[msg.sender].add(1);
413     }
414     
415     
416     // ------------->
417     
418     function _addTicker(string calldata _ticker, address _tickerAddress, uint256 _fee) external onlyOwner {
419         require(tickers[_ticker] == address(0x0) && _tickerAddress != address(0x0));
420         
421         tickers[_ticker] = _tickerAddress;
422         tickerFee[_tickerAddress] = _fee;
423     }
424     
425     
426     function _removeTicker(string calldata _ticker) external onlyOwner {
427         require(tickers[_ticker] != address(0x0));
428         
429         delete tickerFee[tickers[_ticker]];
430         delete tickers[_ticker];
431     }
432     
433     
434     function _updateTickerFee(string calldata _ticker, uint256 _fee) external onlyOwner {
435         require(tickers[_ticker] != address(0x0));
436         
437         tickerFee[tickers[_ticker]] = _fee;
438     }
439     
440     
441     function _setProxyContract(address _address) external onlyOwner {
442         require(proxyContract == address(0x0));
443         
444         proxyContract = _address;
445     }
446     
447 }