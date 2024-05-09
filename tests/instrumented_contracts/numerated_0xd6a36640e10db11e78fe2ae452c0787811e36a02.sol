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
22     uint256 public constant VERSION = 1;
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
36         bytes bytecode;
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
62     string[] private forgivedChars;
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
83     function loadVersion(Versionable from) constant returns (string) {
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
97     function getContractBytecode(string code) constant returns (bytes) {
98         return types[code].bytecode;
99     }
100 
101     function hasForgivedChar(string s) constant returns (bool) {
102         for (uint i = 0; i < forgivedChars.length; i++) {
103             if (stringContains(s, forgivedChars[i]))
104                 return true;
105         }
106     }
107 
108     function addForgivedChar(string c) {
109         require(msg.sender == owner || msg.sender == address(this));
110         if (!hasForgivedChar(c)) {
111             forgivedChars.push(c);
112         }
113     }
114 
115     function removeForgivedChar(uint256 index, string char) {
116         require(msg.sender == owner);
117         require(stringEquals(char, forgivedChars[index]));
118         string storage lastChar = forgivedChars[forgivedChars.length - 1];
119         delete forgivedChars[forgivedChars.length - 1];
120         forgivedChars[index] = lastChar;
121     }
122 
123     function registerPrefix(string prefix) returns (bool) {
124         require(!stringContains(prefix, SEPARATOR));
125         require(!hasForgivedChar(prefix));
126         require(prefixes[prefix] == address(0));
127         if (msg.sender == owner) {
128             prefixes[prefix] = owner;
129             return true;
130         } else {
131             uint256 price = prefixesPrices[stringLen(prefix)];
132             require(price != 0);
133             require(token.transferFrom(msg.sender, owner, price));
134             prefixes[prefix] = owner;
135             return true;
136         }
137         RegisteredPrefix(prefix, msg.sender);
138     }
139 
140     function transferPrefix(string prefix, address to) {
141         require(to != address(0));
142         require(prefixes[prefix] == msg.sender);
143         prefixes[prefix] = to;
144         TransferredPrefix(prefix, msg.sender, to);
145     }
146 
147     function unregisterPrefix(string prefix) {
148         require(prefixes[prefix] == msg.sender);
149         prefixes[prefix] == address(0);
150         UnregisteredPrefix(prefix, msg.sender);
151     }
152 
153     function registerContract(string code, bytes bytecode) {
154         var prefix = splitFirst(code, SEPARATOR);
155         require(prefixes[prefix] == msg.sender);
156         require(types[code].bytecode.length == 0);
157         require(bytecode.length != 0);
158         types[code] = ContractType(code, bytecode);
159         RegisteredContract(code, msg.sender);
160     }
161 
162     function validateContract(Versionable target) constant returns (bool) {
163         return validateContractWithCode(target, loadVersion(target));
164     }
165 
166     function validateContractWithCode(address target, string code) constant returns (bool) {
167         require(stringEquals(types[code].code, code)); // Sanity check
168         bytes memory expected = types[code].bytecode;
169         bytes memory bytecode = getContractCode(target);
170         if (bytecode.length != expected.length) return false;
171         for (uint i = 0; i < expected.length; i++) {
172             if (bytecode[i] != expected[i]) return false;
173         }
174         return true;
175     }
176 
177     function getContractCode(address _addr) constant returns (bytes o_code) {
178         assembly {
179           let size := extcodesize(_addr)
180           o_code := mload(0x40)
181           mstore(0x40, add(o_code, and(add(add(size, 0x20), 0x1f), not(0x1f))))
182           mstore(o_code, size)
183           extcodecopy(_addr, add(o_code, 0x20), 0, size)
184         }
185     }
186 
187     // @dev Returns the first slice of a split
188     function splitFirst(string source, string point) constant returns (string) {
189         bytes memory s = bytes(source);
190         if (s.length == 0) {
191             return "";
192         } else {
193             int index = stringIndexOf(source, point);
194             if (index == - 1) {
195                 return "";
196             } else {
197                 bytes memory output = new bytes(uint(index));
198                 for (int i = 0; i < index; i++) {
199                     output[uint(i)] = s[uint(i)];
200                 }
201                 return string(output);
202             }
203         }
204     }
205 
206     function stringToBytes32(string memory source) returns (bytes32 result) {
207         assembly {
208             result := mload(add(source, 32))
209         }
210     }
211 
212         /*
213      * @dev Returns the length of a null-terminated bytes32 string.
214      * @param self The value to find the length of.
215      * @return The length of the string, from 0 to 32.
216      */
217     function stringLen(string s) internal returns (uint) {
218         var self = stringToBytes32(s);
219         uint ret;
220         if (self == 0)
221             return 0;
222         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
223             ret += 16;
224             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
225         }
226         if (self & 0xffffffffffffffff == 0) {
227             ret += 8;
228             self = bytes32(uint(self) / 0x10000000000000000);
229         }
230         if (self & 0xffffffff == 0) {
231             ret += 4;
232             self = bytes32(uint(self) / 0x100000000);
233         }
234         if (self & 0xffff == 0) {
235             ret += 2;
236             self = bytes32(uint(self) / 0x10000);
237         }
238         if (self & 0xff == 0) {
239             ret += 1;
240         }
241         return 32 - ret;
242     }
243 
244     /// @dev Finds the index of the first occurrence of _needle in _haystack
245     function stringIndexOf(string _haystack, string _needle) returns (int) {
246     	bytes memory h = bytes(_haystack);
247     	bytes memory n = bytes(_needle);
248     	if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
249     		return -1;
250     	} else if (h.length > (2**128 - 1)) { // since we have to be able to return -1 (if the char isn't found or input error), this function must return an "int" type with a max length of (2^128 - 1)
251     		return -1;									
252     	} else {
253     		uint subindex = 0;
254     		for (uint i = 0; i < h.length; i ++) {
255     			if (h[i] == n[0]) { // found the first char of b
256     				subindex = 1;
257     				while (subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) { // search until the chars don't match or until we reach the end of a or b
258     					subindex++;
259     				}	
260     				if (subindex == n.length)
261     					return int(i);
262     			}
263     		}
264     		return -1;
265     	}	
266     }
267 
268     function stringEquals(string _a, string _b) returns (bool) {
269     	bytes memory a = bytes(_a);
270     	bytes memory b = bytes(_b);
271         if (a.length != b.length) return false;
272         for (uint i = 0; i < a.length; i++) {
273             if (a[i] != b[i]) return false;
274         }
275         return true;
276     }
277 
278     function stringContains(string self, string needle) returns (bool) {
279         return stringIndexOf(self, needle) != int(-1);
280     }
281 }