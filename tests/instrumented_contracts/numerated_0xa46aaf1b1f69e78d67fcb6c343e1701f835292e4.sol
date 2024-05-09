1 pragma solidity ^0.4.15;
2 
3 contract Token {
4     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
5     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
6     function approve(address _spender, uint256 _value) returns (bool success);
7 }
8 
9 contract Versionable {
10     string public versionCode;
11 
12     function getVersionByte(uint index) constant returns (bytes1) { 
13         return bytes(versionCode)[index];
14     }
15 
16     function getVersionLength() constant returns (uint256) {
17         return bytes(versionCode).length;
18     }
19 }
20 
21 contract ContractCatalog {
22     uint256 public constant VERSION = 2;
23     string public constant SEPARATOR = "-";
24 
25     Token public token;
26     address public owner;
27     
28     event RegisteredPrefix(string _prefix, address _owner);
29     event TransferredPrefix(string _prefix, address _from, address _to);
30     event UnregisteredPrefix(string _prefix, address _from);
31     event NewPrefixPrice(uint256 _length, uint256 _price);
32     event RegisteredContract(string _version, address _by);
33 
34     struct ContractType {
35         string code;
36         address sample;
37     }
38 
39     function ContractCatalog() {
40         token = Token(address(0xF970b8E36e23F7fC3FD752EeA86f8Be8D83375A6));
41         owner = address(0xA1091481AEde4adDe00C1a26992AE49a7e0E1FB0);
42 
43         // Set up all forgived chars
44         addForgivedChar(" ");
45         addForgivedChar("‐");
46         addForgivedChar("‑");
47         addForgivedChar("‒");
48         addForgivedChar("–");
49         addForgivedChar("﹘");
50         addForgivedChar("۔");
51         addForgivedChar("⁃");
52         addForgivedChar("˗");
53         addForgivedChar("−");
54         addForgivedChar("➖");
55         addForgivedChar("Ⲻ");
56     }
57 
58     mapping(string => ContractType) types;
59     mapping(string => address) prefixes;
60     mapping(uint256 => uint256) prefixesPrices;
61 
62     string[] public forgivedChars;
63 
64     function transfer(address to) {
65         require(to != address(0));
66         require(msg.sender == owner);
67         owner = to;
68     }
69 
70     function replaceToken(Token _token) {
71         require(_token != address(0));
72         require(msg.sender == owner);
73         token = _token;
74     }
75 
76     function setPrefixPrice(uint256 lenght, uint256 price) {
77         require(msg.sender == owner);
78         require(lenght != 0);
79         prefixesPrices[lenght] = price;
80         NewPrefixPrice(lenght, price);
81     }
82 
83     function loadVersion(Versionable from) private returns (string) {
84         uint size = from.getVersionLength();
85         bytes memory out = new bytes(size);
86         for (uint i = 0; i < size; i++) {
87             out[i] = from.getVersionByte(i);
88         }
89         return string(out);
90     }
91 
92     function getContractOwner(string code) constant returns (address) {
93         string memory prefix = splitFirst(code, "-");
94         return prefixes[prefix];
95     }
96 
97     function getContractSample(string code) constant returns (address) {
98         return types[code].sample;
99     }
100 
101     function getContractBytecode(string code) constant returns (bytes) {
102         return getContractCode(types[code].sample);
103     }
104 
105     function hasForgivedChar(string s) constant returns (bool) {
106         for (uint i = 0; i < forgivedChars.length; i++) {
107             if (stringContains(s, forgivedChars[i]))
108                 return true;
109         }
110     }
111 
112     function addForgivedChar(string c) {
113         require(msg.sender == owner || msg.sender == address(this));
114         if (!hasForgivedChar(c)) {
115             forgivedChars.push(c);
116         }
117     }
118 
119     function removeForgivedChar(uint256 index, string char) {
120         require(msg.sender == owner);
121         require(stringEquals(char, forgivedChars[index]));
122         string storage lastChar = forgivedChars[forgivedChars.length - 1];
123         delete forgivedChars[forgivedChars.length - 1];
124         forgivedChars[index] = lastChar;
125     }
126 
127     function registerPrefix(string prefix) returns (bool) {
128         require(!stringContains(prefix, SEPARATOR));
129         require(!hasForgivedChar(prefix));
130         require(prefixes[prefix] == address(0));
131         if (msg.sender == owner) {
132             prefixes[prefix] = owner;
133             return true;
134         } else {
135             uint256 price = prefixesPrices[stringLen(prefix)];
136             require(price != 0);
137             require(token.transferFrom(msg.sender, owner, price));
138             prefixes[prefix] = owner;
139             return true;
140         }
141         RegisteredPrefix(prefix, msg.sender);
142     }
143 
144     function transferPrefix(string prefix, address to) {
145         require(to != address(0));
146         require(prefixes[prefix] == msg.sender);
147         prefixes[prefix] = to;
148         TransferredPrefix(prefix, msg.sender, to);
149     }
150 
151     function unregisterPrefix(string prefix) {
152         require(prefixes[prefix] == msg.sender);
153         prefixes[prefix] == address(0);
154         UnregisteredPrefix(prefix, msg.sender);
155     }
156 
157     function registerContract(string code, address sample) {
158         var prefix = splitFirst(code, SEPARATOR);
159         require(prefixes[prefix] == msg.sender);
160         require(types[code].sample == address(0));
161         require(getContractCode(sample).length != 0);
162         types[code] = ContractType(code, sample);
163         RegisteredContract(code, msg.sender);
164     }
165 
166     function validateContract(Versionable target) constant returns (bool) {
167         return validateContractWithCode(target, loadVersion(target));
168     }
169 
170     function validateContractWithCode(address target, string code) constant returns (bool) {
171         require(stringEquals(types[code].code, code)); // Sanity check
172         bytes memory expected = getContractCode(types[code].sample);
173         bytes memory bytecode = getContractCode(target);
174         require(expected.length != 0);
175         if (bytecode.length != expected.length) return false;
176         for (uint i = 0; i < expected.length; i++) {
177             if (bytecode[i] != expected[i]) return false;
178         }
179         return true;
180     }
181 
182     function getContractCode(address _addr) private returns (bytes o_code) {
183         assembly {
184           let size := extcodesize(_addr)
185           o_code := mload(0x40)
186           mstore(0x40, add(o_code, and(add(add(size, 0x20), 0x1f), not(0x1f))))
187           mstore(o_code, size)
188           extcodecopy(_addr, add(o_code, 0x20), 0, size)
189         }
190     }
191 
192     // @dev Returns the first slice of a split
193     function splitFirst(string source, string point) private returns (string) {
194         bytes memory s = bytes(source);
195         if (s.length == 0) {
196             return "";
197         } else {
198             int index = stringIndexOf(source, point);
199             if (index == - 1) {
200                 return "";
201             } else {
202                 bytes memory output = new bytes(uint(index));
203                 for (int i = 0; i < index; i++) {
204                     output[uint(i)] = s[uint(i)];
205                 }
206                 return string(output);
207             }
208         }
209     }
210 
211     function stringToBytes32(string memory source) private returns (bytes32 result) {
212         assembly {
213             result := mload(add(source, 32))
214         }
215     }
216 
217         /*
218      * @dev Returns the length of a null-terminated bytes32 string.
219      * @param self The value to find the length of.
220      * @return The length of the string, from 0 to 32.
221      */
222     function stringLen(string s) private returns (uint) {
223         var self = stringToBytes32(s);
224         uint ret;
225         if (self == 0)
226             return 0;
227         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
228             ret += 16;
229             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
230         }
231         if (self & 0xffffffffffffffff == 0) {
232             ret += 8;
233             self = bytes32(uint(self) / 0x10000000000000000);
234         }
235         if (self & 0xffffffff == 0) {
236             ret += 4;
237             self = bytes32(uint(self) / 0x100000000);
238         }
239         if (self & 0xffff == 0) {
240             ret += 2;
241             self = bytes32(uint(self) / 0x10000);
242         }
243         if (self & 0xff == 0) {
244             ret += 1;
245         }
246         return 32 - ret;
247     }
248 
249     /// @dev Finds the index of the first occurrence of _needle in _haystack
250     function stringIndexOf(string _haystack, string _needle) private returns (int) {
251     	bytes memory h = bytes(_haystack);
252     	bytes memory n = bytes(_needle);
253     	if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
254     		return -1;
255     	} else if (h.length > (2**128 - 1)) { // since we have to be able to return -1 (if the char isn't found or input error), this function must return an "int" type with a max length of (2^128 - 1)
256     		return -1;									
257     	} else {
258     		uint subindex = 0;
259     		for (uint i = 0; i < h.length; i ++) {
260     			if (h[i] == n[0]) { // found the first char of b
261     				subindex = 1;
262     				while (subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) { // search until the chars don't match or until we reach the end of a or b
263     					subindex++;
264     				}	
265     				if (subindex == n.length)
266     					return int(i);
267     			}
268     		}
269     		return -1;
270     	}	
271     }
272 
273     function stringEquals(string _a, string _b) private returns (bool) {
274     	bytes memory a = bytes(_a);
275     	bytes memory b = bytes(_b);
276         if (a.length != b.length) return false;
277         for (uint i = 0; i < a.length; i++) {
278             if (a[i] != b[i]) return false;
279         }
280         return true;
281     }
282 
283     function stringContains(string self, string needle) private returns (bool) {
284         return stringIndexOf(self, needle) != int(-1);
285     }
286 }