1 pragma solidity ^0.4.21;
2 
3 
4 library RLPEncode {
5     uint8 constant STRING_SHORT_PREFIX = 0x80;
6     uint8 constant STRING_LONG_PREFIX = 0xb7;
7     uint8 constant LIST_SHORT_PREFIX = 0xc0;
8     uint8 constant LIST_LONG_PREFIX = 0xf7;
9 
10     /// @dev Rlp encodes a bytes
11     /// @param self The bytes to be encoded
12     /// @return The rlp encoded bytes
13     function encodeBytes(bytes memory self) internal constant returns (bytes) {
14         bytes memory encoded;
15         if(self.length == 1 && uint(self[0]) < 0x80) {
16             encoded = new bytes(1);
17             encoded = self;
18         } else {
19             encoded = encode(self, STRING_SHORT_PREFIX, STRING_LONG_PREFIX);
20         }
21         return encoded;
22     }
23 
24     /// @dev Rlp encodes a bytes[]. Note that the items in the bytes[] will not automatically be rlp encoded.
25     /// @param self The bytes[] to be encoded
26     /// @return The rlp encoded bytes[]
27     function encodeList(bytes[] memory self) internal constant returns (bytes) {
28         bytes memory list = flatten(self);
29         bytes memory encoded = encode(list, LIST_SHORT_PREFIX, LIST_LONG_PREFIX);
30         return encoded;
31     }
32 
33     function encode(bytes memory self, uint8 prefix1, uint8 prefix2) private constant returns (bytes) {
34         uint selfPtr;
35         assembly { selfPtr := add(self, 0x20) }
36 
37         bytes memory encoded;
38         uint encodedPtr;
39 
40         uint len = self.length;
41         uint lenLen;
42         uint i = 0x1;
43         while(len/i != 0) {
44             lenLen++;
45             i *= 0x100;
46         }
47 
48         if(len <= 55) {
49             encoded = new bytes(len+1);
50 
51             // length encoding byte
52             encoded[0] = byte(prefix1+len);
53 
54             // string/list contents
55             assembly { encodedPtr := add(encoded, 0x21) }
56             memcpy(encodedPtr, selfPtr, len);
57         } else {
58             // 1 is the length of the length of the length
59             encoded = new bytes(1+lenLen+len);
60 
61             // length of the length encoding byte
62             encoded[0] = byte(prefix2+lenLen);
63 
64             // length bytes
65             for(i=1; i<=lenLen; i++) {
66                 encoded[i] = byte((len/(0x100**(lenLen-i)))%0x100);
67             }
68 
69             // string/list contents
70             assembly { encodedPtr := add(add(encoded, 0x21), lenLen) }
71             memcpy(encodedPtr, selfPtr, len);
72         }
73         return encoded;
74     }
75 
76     function flatten(bytes[] memory self) private constant returns (bytes) {
77         if(self.length == 0) {
78             return new bytes(0);
79         }
80 
81         uint len;
82         for(uint i=0; i<self.length; i++) {
83             len += self[i].length;
84         }
85 
86         bytes memory flattened = new bytes(len);
87         uint flattenedPtr;
88         assembly { flattenedPtr := add(flattened, 0x20) }
89 
90         for(i=0; i<self.length; i++) {
91             bytes memory item = self[i];
92 
93             uint selfPtr;
94             assembly { selfPtr := add(item, 0x20)}
95 
96             memcpy(flattenedPtr, selfPtr, item.length);
97             flattenedPtr += self[i].length;
98         }
99 
100         return flattened;
101     }
102 
103     /// This function is from Nick Johnson's string utils library
104     function memcpy(uint dest, uint src, uint len) private {
105         // Copy word-length chunks while possible
106         for(; len >= 32; len -= 32) {
107             assembly {
108                 mstore(dest, mload(src))
109             }
110             dest += 32;
111             src += 32;
112         }
113 
114         // Copy remaining bytes
115         uint mask = 256 ** (32 - len) - 1;
116         assembly {
117             let srcpart := and(mload(src), not(mask))
118             let destpart := and(mload(dest), mask)
119             mstore(dest, or(destpart, srcpart))
120         }
121     }
122 
123     function strToBytes(string data)internal pure returns (bytes){
124         uint _ascii_0 = 48;
125         uint _ascii_A = 65;
126         uint _ascii_a = 97;
127 
128         bytes memory a = bytes(data);
129         uint[] memory b = new uint[](a.length);
130 
131         for (uint i = 0; i < a.length; i++) {
132             uint _a = uint(a[i]);
133 
134             if (_a > 96) {
135                 b[i] = _a - 97 + 10;
136             }
137             else if (_a > 66) {
138                 b[i] = _a - 65 + 10;
139             }
140             else {
141                 b[i] = _a - 48;
142             }
143         }
144 
145         bytes memory c = new bytes(b.length / 2);
146         for (uint _i = 0; _i < b.length; _i += 2) {
147             c[_i / 2] = byte(b[_i] * 16 + b[_i + 1]);
148         }
149 
150         return c;
151     }
152 
153     function bytesToUint(bytes b) internal pure returns (uint256){
154         uint256 number;
155         for(uint i=0;i<b.length;i++){
156             number = number + uint(b[i])*(2**(8*(b.length-(i+1))));
157         }
158         return number;
159     }
160 
161     function addressToBytes(address a) internal pure returns (bytes b){
162         assembly {
163             let m := mload(0x40)
164             mstore(add(m, 20), xor(0x140000000000000000000000000000000000000000, a))
165             mstore(0x40, add(m, 52))
166             b := m
167         }
168     }
169 
170     function stringToUint(string s) internal pure returns (uint) {
171         bytes memory b = bytes(s);
172         uint result = 0;
173         for (uint i = 0; i < b.length; i++) {
174            if (b[i] >= 48 && b[i] <= 57){
175                 result = result * 16 + (uint(b[i]) - 48); // bytes and int are not compatible with the operator -.
176             }
177             else if(b[i] >= 97 && b[i] <= 122)
178             {
179                 result = result * 16 + (uint(b[i]) - 87);
180             }
181         }
182         return result;
183     }
184 
185     function subString(string str, uint startIndex, uint endIndex) internal pure returns (string) {
186         bytes memory strBytes = bytes(str);
187         if(strBytes.length !=48){revert();}
188         bytes memory result = new bytes(endIndex-startIndex);
189         for(uint i = startIndex; i < endIndex; i++) {
190             result[i-startIndex] = strBytes[i];
191         }
192         return string(result);
193     }
194 
195     function strConcat(string _a, string _b) internal pure returns (string){
196         bytes memory _ba = bytes(_a);
197         bytes memory _bb = bytes(_b);
198         string memory ab = new string(_ba.length + _bb.length);
199         bytes memory bab = bytes(ab);
200         uint k = 0;
201         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
202             for (i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
203                 return string(bab);
204         }
205 
206     function stringToAddr(string _input) internal pure returns (address){
207         string memory _a = strConcat("0x",_input);
208         bytes memory tmp = bytes(_a);
209         uint160 iaddr = 0;
210         uint160 b1;
211         uint160 b2;
212         for (uint i=2; i<2+2*20; i+=2){
213             iaddr *= 256;
214             b1 = uint160(tmp[i]);
215             b2 = uint160(tmp[i+1]);
216             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
217             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
218             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
219             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
220             iaddr += (b1*16+b2);
221         }
222             return address(iaddr);
223     }
224 }
225 
226 contract IvtMultiSigWallet {
227     
228     event Deposit(address _sender, uint256 _value);
229     event Transacted(address _to, address _tokenContractAddress, uint256 _value);
230     event SafeModeActivated(address _sender);
231     event Kill(address _safeAddress, uint256 _value);
232     event Debuglog(address _address,bool _flag0,bool _flag1);
233 
234     mapping (address => bool) private signers;
235     mapping (uint256 => bool) private transactions;
236     mapping (address => bool) private signedAddresses;
237 
238     address private owner;
239     bool private safeMode;
240 
241     uint8 private required;
242     uint8 private safeModeConfirmed;
243     address private safeAddress;
244 
245     modifier onlyOwner {
246         require(owner == msg.sender);
247         _;
248     }
249 
250     constructor(address[] _signers, uint8 _required) public{
251         require(_required <= _signers.length && _required > 0 && _signers.length > 0);
252 
253         for (uint8 i = 0; i < _signers.length; i++){
254             require(_signers[i] != address(0));
255             signers[_signers[i]] = true;
256         }
257         required = _required;
258         owner = msg.sender;
259         safeMode = false;
260         safeModeConfirmed = 0;
261         safeAddress = 0;
262     }
263 
264     function() payable public{
265         if (msg.value > 0)
266             emit Deposit(msg.sender, msg.value);
267     }
268 
269     function submitTransaction(address _destination, string _value, string _strTransactionData, uint8[] _v, bytes32[] _r, bytes32[] _s) onlyOwner public{
270         processAndCheckParam(_destination, _strTransactionData, _v, _r, _s);
271 
272         uint256 transactionValue = RLPEncode.stringToUint(_value);
273         bytes32 _msgHash = getMsgHash(_destination, _value, _strTransactionData);
274         verifySignatures(_msgHash, _v, _r, _s);
275 
276         _destination.transfer(transactionValue);
277 
278         emit Transacted(_destination, 0, transactionValue);
279     }
280 
281     function submitTransactionToken(address _destination, address _tokenContractAddress, string _value, string _strTransactionData, uint8[] _v, bytes32[] _r,bytes32[] _s) onlyOwner public{
282         processAndCheckParam(_destination, _strTransactionData, _v, _r, _s);
283 
284         uint256 transactionValue = RLPEncode.stringToUint(_value);
285         bytes32 _msgHash = getMsgHash(_destination, _value, _strTransactionData);
286         verifySignatures(_msgHash, _v, _r, _s);
287 
288         ERC20Interface instance = ERC20Interface(_tokenContractAddress);
289         require(instance.transfer(_destination, transactionValue));
290 
291         emit Transacted(_destination, _tokenContractAddress, transactionValue);
292     }
293 
294 
295     function confirmTransaction(address _safeAddress) public{
296         require(safeMode && signers[msg.sender] && signers[_safeAddress]);
297         if (safeAddress == 0){
298             safeAddress = _safeAddress;
299         }
300         require(safeAddress == _safeAddress);
301         safeModeConfirmed++;
302 
303         delete(signers[msg.sender]);
304 
305         if(safeModeConfirmed >= required){
306             emit Kill(safeAddress, address(this).balance);
307             selfdestruct(safeAddress);
308         }
309     }
310 
311     function activateSafeMode() onlyOwner public {
312         safeMode = true;
313         emit SafeModeActivated(msg.sender);
314     }
315 
316     function getMsgHash(address _destination, string _value, string _strTransactionData) constant internal returns (bytes32){
317         bytes[] memory rawTx = new bytes[](9);
318         bytes[] memory bytesArray = new bytes[](9);
319 
320         rawTx[0] = hex"09";
321         rawTx[1] = hex"09502f9000";
322         rawTx[2] = hex"5208";
323         rawTx[3] = RLPEncode.addressToBytes(_destination);
324         rawTx[4] = RLPEncode.strToBytes(_value);
325         rawTx[5] = RLPEncode.strToBytes(_strTransactionData);
326         rawTx[6] = hex"01"; //03=testnet,01=mainnet
327 
328         for(uint8 i = 0; i < 9; i++){
329             bytesArray[i] = RLPEncode.encodeBytes(rawTx[i]);
330         }
331 
332         bytes memory bytesList = RLPEncode.encodeList(bytesArray);
333 
334         return keccak256(bytesList);
335     }
336 
337     function processAndCheckParam(address _destination, string _strTransactionData, uint8[] _v, bytes32[] _r, bytes32[] _s)  internal{
338         require(!safeMode && _destination != 0 && _destination != address(this) && _v.length == _r.length && _v.length == _s.length && _v.length > 0);
339 
340         string memory strTransactionTime = RLPEncode.subString(_strTransactionData, 40, 48);
341         uint256 transactionTime = RLPEncode.stringToUint(strTransactionTime);
342         require(!transactions[transactionTime]);
343 
344         string memory strTransactionAddress = RLPEncode.subString(_strTransactionData, 0, 40);
345         address contractAddress = RLPEncode.stringToAddr(strTransactionAddress);
346         require(contractAddress == address(this));
347 
348         transactions[transactionTime] = true;
349 
350     }
351 
352     function verifySignatures(bytes32 _msgHash, uint8[] _v, bytes32[] _r,bytes32[] _s)  internal{
353         uint8 hasConfirmed = 0;
354         address[] memory  tempAddresses = new address[](_v.length);
355         address tempAddress;
356         
357         for (uint8 i = 0; i < _v.length; i++){
358             tempAddress = ecrecover(_msgHash, _v[i], _r[i], _s[i]);
359             tempAddresses[i] = tempAddress;
360 
361             require(signers[tempAddress] && (!signedAddresses[tempAddress]));
362             emit Debuglog(tempAddresses[i],signers[tempAddress],!signedAddresses[tempAddress]);
363             signedAddresses[tempAddress] = true;
364             hasConfirmed++;
365         }
366         for (uint8 j = 0; j < _v.length; j++){
367             delete signedAddresses[tempAddresses[j]];
368         }
369         require(hasConfirmed >= required);
370     }
371 }
372 
373 
374 contract ERC20Interface {
375     function transfer(address _to, uint256 _value) public returns (bool success);
376     function balanceOf(address _owner) public constant returns (uint256 balance);
377 }