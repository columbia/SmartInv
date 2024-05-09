1 pragma solidity ^0.4.15;
2 
3 contract Versionable {
4     string public versionCode;
5 
6     function getVersionByte(uint index) constant returns (bytes1) { 
7         return bytes(versionCode)[index];
8     }
9 
10     function getVersionLength() constant returns (uint256) {
11         return bytes(versionCode).length;
12     }
13 }
14 
15 
16 contract Token {
17     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
18     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
19     function approve(address _spender, uint256 _value) returns (bool success);
20 }
21 
22 contract ContractCatalog {
23     uint256 public constant VERSION = 3;
24     string public constant SEPARATOR = "-";
25 
26     Token public token;
27     address public owner;
28     
29     event RegisteredPrefix(string _prefix, address _owner);
30     event TransferredPrefix(string _prefix, address _from, address _to);
31     event UnregisteredPrefix(string _prefix, address _from);
32     event NewPrefixPrice(uint256 _length, uint256 _price);
33     event RegisteredContract(string _version, address _by);
34 
35     struct ContractType {
36         string code;
37         address sample;
38     }
39 
40     function ContractCatalog() {
41         token = Token(address(0xF970b8E36e23F7fC3FD752EeA86f8Be8D83375A6));
42         owner = address(0xA1091481AEde4adDe00C1a26992AE49a7e0E1FB0);
43 
44         // Set up all forgived chars
45         addForgivedChar(" ");
46         addForgivedChar("‐");
47         addForgivedChar("‑");
48         addForgivedChar("‒");
49         addForgivedChar("–");
50         addForgivedChar("﹘");
51         addForgivedChar("۔");
52         addForgivedChar("⁃");
53         addForgivedChar("˗");
54         addForgivedChar("−");
55         addForgivedChar("➖");
56         addForgivedChar("Ⲻ");
57     }
58 
59     mapping(string => ContractType) types;
60     mapping(string => address) prefixes;
61     mapping(uint256 => uint256) prefixesPrices;
62 
63     string[] public forgivedChars;
64 
65     function getPrefixOwner(string prefix) constant returns (address) {
66         return prefixes[prefix];
67     }
68 
69     function getPrefixPrice(string prefix) constant returns (uint256) { 
70         return prefixesPrices[stringLen(prefix)];
71     }
72 
73     function transfer(address to) {
74         require(to != address(0));
75         require(msg.sender == owner);
76         owner = to;
77     }
78 
79     function replaceToken(Token _token) {
80         require(_token != address(0));
81         require(msg.sender == owner);
82         token = _token;
83     }
84 
85     function setPrefixPrice(uint256 lenght, uint256 price) {
86         require(msg.sender == owner);
87         require(lenght != 0);
88         prefixesPrices[lenght] = price;
89         NewPrefixPrice(lenght, price);
90     }
91 
92     function loadVersion(Versionable from) private returns (string) {
93         uint size = from.getVersionLength();
94         bytes memory out = new bytes(size);
95         for (uint i = 0; i < size; i++) {
96             out[i] = from.getVersionByte(i);
97         }
98         return string(out);
99     }
100 
101     function getContractOwner(string code) constant returns (address) {
102         string memory prefix = splitFirst(code, "-");
103         return prefixes[prefix];
104     }
105 
106     function getContractSample(string code) constant returns (address) {
107         return types[code].sample;
108     }
109 
110     function getContractBytecode(string code) constant returns (bytes) {
111         return getContractCode(types[code].sample);
112     }
113 
114     function hasForgivedChar(string s) private returns (bool) {
115         for (uint i = 0; i < forgivedChars.length; i++) {
116             if (stringContains(s, forgivedChars[i]))
117                 return true;
118         }
119     }
120 
121     function addForgivedChar(string c) {
122         require(msg.sender == owner || msg.sender == address(this));
123         if (!hasForgivedChar(c)) {
124             forgivedChars.push(c);
125         }
126     }
127 
128     function removeForgivedChar(uint256 index, string char) {
129         require(msg.sender == owner);
130         require(stringEquals(char, forgivedChars[index]));
131         string storage lastChar = forgivedChars[forgivedChars.length - 1];
132         delete forgivedChars[forgivedChars.length - 1];
133         forgivedChars[index] = lastChar;
134     }
135 
136     function registerPrefix(string prefix) returns (bool) {
137         require(!stringContains(prefix, SEPARATOR));
138         require(!hasForgivedChar(prefix));
139         require(prefixes[prefix] == address(0));
140         RegisteredPrefix(prefix, msg.sender);
141         if (msg.sender == owner) {
142             prefixes[prefix] = owner;
143             return true;
144         } else {
145             uint256 price = prefixesPrices[stringLen(prefix)];
146             require(price != 0);
147             require(token.transferFrom(msg.sender, owner, price));
148             prefixes[prefix] = msg.sender;
149             return true;
150         }
151     }
152 
153     function transferPrefix(string prefix, address to) {
154         require(to != address(0));
155         require(prefixes[prefix] == msg.sender);
156         prefixes[prefix] = to;
157         TransferredPrefix(prefix, msg.sender, to);
158     }
159 
160     function unregisterPrefix(string prefix) {
161         require(prefixes[prefix] == msg.sender);
162         prefixes[prefix] = address(0);
163         UnregisteredPrefix(prefix, msg.sender);
164     }
165 
166     function registerContract(string code, address sample) {
167         var prefix = splitFirst(code, SEPARATOR);
168         require(prefixes[prefix] == msg.sender);
169         require(types[code].sample == address(0));
170         require(getContractCode(sample).length != 0);
171         types[code] = ContractType(code, sample);
172         RegisteredContract(code, msg.sender);
173     }
174 
175     function validateContract(Versionable target) constant returns (bool) {
176         return validateContractWithCode(target, loadVersion(target));
177     }
178 
179     function validateContractWithCode(address target, string code) constant returns (bool) {
180         require(stringEquals(types[code].code, code)); // Sanity check
181         bytes memory expected = getContractCode(types[code].sample);
182         bytes memory bytecode = getContractCode(target);
183         require(expected.length != 0);
184         if (bytecode.length != expected.length) return false;
185         for (uint i = 0; i < expected.length; i++) {
186             if (bytecode[i] != expected[i]) return false;
187         }
188         return true;
189     }
190 
191     function getContractCode(address _addr) private returns (bytes o_code) {
192         assembly {
193           let size := extcodesize(_addr)
194           o_code := mload(0x40)
195           mstore(0x40, add(o_code, and(add(add(size, 0x20), 0x1f), not(0x1f))))
196           mstore(o_code, size)
197           extcodecopy(_addr, add(o_code, 0x20), 0, size)
198         }
199     }
200 
201     // @dev Returns the first slice of a split
202     function splitFirst(string source, string point) private returns (string) {
203         bytes memory s = bytes(source);
204         if (s.length == 0) {
205             return "";
206         } else {
207             int index = stringIndexOf(source, point);
208             if (index == - 1) {
209                 return "";
210             } else {
211                 bytes memory output = new bytes(uint(index));
212                 for (int i = 0; i < index; i++) {
213                     output[uint(i)] = s[uint(i)];
214                 }
215                 return string(output);
216             }
217         }
218     }
219 
220     function stringToBytes32(string memory source) private returns (bytes32 result) {
221         assembly {
222             result := mload(add(source, 32))
223         }
224     }
225 
226         /*
227      * @dev Returns the length of a null-terminated bytes32 string.
228      * @param self The value to find the length of.
229      * @return The length of the string, from 0 to 32.
230      */
231     function stringLen(string s) private returns (uint) {
232         var self = stringToBytes32(s);
233         uint ret;
234         if (self == 0)
235             return 0;
236         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
237             ret += 16;
238             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
239         }
240         if (self & 0xffffffffffffffff == 0) {
241             ret += 8;
242             self = bytes32(uint(self) / 0x10000000000000000);
243         }
244         if (self & 0xffffffff == 0) {
245             ret += 4;
246             self = bytes32(uint(self) / 0x100000000);
247         }
248         if (self & 0xffff == 0) {
249             ret += 2;
250             self = bytes32(uint(self) / 0x10000);
251         }
252         if (self & 0xff == 0) {
253             ret += 1;
254         }
255         return 32 - ret;
256     }
257 
258     /// @dev Finds the index of the first occurrence of _needle in _haystack
259     function stringIndexOf(string _haystack, string _needle) private returns (int) {
260     	bytes memory h = bytes(_haystack);
261     	bytes memory n = bytes(_needle);
262     	if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
263     		return -1;
264     	} else if (h.length > (2**128 - 1)) { // since we have to be able to return -1 (if the char isn't found or input error), this function must return an "int" type with a max length of (2^128 - 1)
265     		return -1;									
266     	} else {
267     		uint subindex = 0;
268     		for (uint i = 0; i < h.length; i ++) {
269     			if (h[i] == n[0]) { // found the first char of b
270     				subindex = 1;
271     				while (subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) { // search until the chars don't match or until we reach the end of a or b
272     					subindex++;
273     				}	
274     				if (subindex == n.length)
275     					return int(i);
276     			}
277     		}
278     		return -1;
279     	}	
280     }
281 
282     function stringEquals(string _a, string _b) private returns (bool) {
283     	bytes memory a = bytes(_a);
284     	bytes memory b = bytes(_b);
285         if (a.length != b.length) return false;
286         for (uint i = 0; i < a.length; i++) {
287             if (a[i] != b[i]) return false;
288         }
289         return true;
290     }
291 
292     function stringContains(string self, string needle) private returns (bool) {
293         return stringIndexOf(self, needle) != int(-1);
294     }
295 }