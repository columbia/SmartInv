1 pragma solidity 0.5.0;
2 
3 ///////// BEGIN LIB IMPORT
4 
5 /*
6  * @title String & slice utility library for Solidity contracts.
7  * @author Nick Johnson <arachnid@notdot.net>
8  */
9 
10 library strings {
11     struct slice {
12         uint _len;
13         uint _ptr;
14     }
15 
16     function memcpy(uint dest, uint src, uint len) private pure {
17         // Copy word-length chunks while possible
18         for(; len >= 32; len -= 32) {
19             assembly {
20                 mstore(dest, mload(src))
21             }
22             dest += 32;
23             src += 32;
24         }
25 
26         // Copy remaining bytes
27         uint mask = 256 ** (32 - len) - 1;
28         assembly {
29             let srcpart := and(mload(src), not(mask))
30             let destpart := and(mload(dest), mask)
31             mstore(dest, or(destpart, srcpart))
32         }
33     }
34 
35     /*
36      * @dev Returns a slice containing the entire string.
37      * @param self The string to make a slice from.
38      * @return A newly allocated slice containing the entire string.
39      */
40     function toSlice(string memory self) internal pure returns (slice memory) {
41         uint ptr;
42         assembly {
43             ptr := add(self, 0x20)
44         }
45         return slice(bytes(self).length, ptr);
46     }
47 
48     /*
49      * @dev Copies a slice to a new string.
50      * @param self The slice to copy.
51      * @return A newly allocated string containing the slice's text.
52      */
53     function toString(slice memory self) internal pure returns (string memory) {
54         string memory ret = new string(self._len);
55         uint retptr;
56         assembly { retptr := add(ret, 32) }
57 
58         memcpy(retptr, self._ptr, self._len);
59         return ret;
60     }
61 
62     /*
63      * @dev Returns a newly allocated string containing the concatenation of
64      *      `self` and `other`.
65      * @param self The first slice to concatenate.
66      * @param other The second slice to concatenate.
67      * @return The concatenation of the two strings.
68      */
69     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
70         string memory ret = new string(self._len + other._len);
71         uint retptr;
72         assembly { retptr := add(ret, 32) }
73         memcpy(retptr, self._ptr, self._len);
74         memcpy(retptr + self._len, other._ptr, other._len);
75         return ret;
76     }
77 
78     /*
79      * @dev Joins an array of slices, using `self` as a delimiter, returning a
80      *      newly allocated string.
81      * @param self The delimiter to use.
82      * @param parts A list of slices to join.
83      * @return A newly allocated string containing all the slices in `parts`,
84      *         joined with `self`.
85      */
86     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
87         if (parts.length == 0)
88             return "";
89 
90         uint length = self._len * (parts.length - 1);
91         for(uint i = 0; i < parts.length; i++)
92             length += parts[i]._len;
93 
94         string memory ret = new string(length);
95         uint retptr;
96         assembly { retptr := add(ret, 32) }
97 
98         for(uint256 i = 0; i < parts.length; i++) {
99             memcpy(retptr, parts[i]._ptr, parts[i]._len);
100             retptr += parts[i]._len;
101             if (i < parts.length - 1) {
102                 memcpy(retptr, self._ptr, self._len);
103                 retptr += self._len;
104             }
105         }
106 
107         return ret;
108     }
109 }
110 
111 ///////// END LIB IMPORT
112 
113 /*
114  * v1.0
115  */
116 contract Themis {
117 
118     struct Stamp {
119         string hash;
120         string data;
121         bool exists;
122     }
123 
124     struct AuthorityStamps {
125         bool enabled;
126         Stamp[] stamps;
127         mapping(string => Stamp) hashToStamp;
128     }
129 
130     event TransferChairEvent (
131         address indexed newChair
132     );
133 
134     event StampEvent (
135         address indexed authority,
136         string indexed hash,
137         string data
138     );
139 
140     event AuthorityAbilitation (
141         address indexed authority,
142         bool enabled
143     );
144 
145     address public chairAuthority;
146     mapping(address => AuthorityStamps) private authorities;
147     address[] private authorityAddresses;
148 
149     constructor() public {
150         chairAuthority = msg.sender;
151         authorities[msg.sender].enabled = true;
152         authorityAddresses.push(msg.sender);
153     }
154 
155     function transferChair(address authority) public {
156         require(msg.sender == chairAuthority, 'unauthorised');
157         chairAuthority = authority;
158         emit TransferChairEvent(authority);
159     }
160 
161     function enableAuthority(address authority) public {
162         require(msg.sender == chairAuthority);
163         authorities[authority].enabled = true;
164         bool found = false;
165         for(uint256 i = 0; i < authorityAddresses.length; i++) {
166             if(authorityAddresses[i] == authority) {
167                 found = true;
168                 break;
169             }
170         }
171         if(!found) {
172             authorityAddresses.push(authority);
173         }
174         emit AuthorityAbilitation(authority, true);
175     }
176 
177     function disableAuthority(address authority) public {
178         require(msg.sender == chairAuthority);
179         authorities[authority].enabled = false;
180         emit AuthorityAbilitation(authority, false);
181     }
182 
183     function stamp(string memory hash, string memory data) public {
184         require(bytes(hash).length > 0, 'hash cannot be empty');
185         AuthorityStamps storage authority = authorities[msg.sender];
186         require (authority.enabled, 'authority is not enabled');
187         require(authority.hashToStamp[hash].exists == false, 'Hash has been already stamped');
188         Stamp memory _stamp = Stamp(hash, data, true);
189         authority.stamps.push(_stamp);
190         authority.hashToStamp[hash] = _stamp;
191         emit StampEvent(msg.sender, hash, data);
192     }
193 
194     function getAuthoritiesCount() public view returns(uint256 chain) {
195         return authorityAddresses.length;
196     }
197 
198     function getAuthorityAddress(uint i) public view returns(address authority) {
199         return authorityAddresses[i];
200     }
201 
202     function isAuthorityEnabled(address authority) public view returns(bool enabled) {
203         return authorities[authority].enabled;
204     }
205 
206     function getStampsCount(address authority) public view returns(uint256 count) {
207         return authorities[authority].stamps.length;
208     }
209 
210     function getStampHash(address authority, uint256 i) public view returns(string memory hash) {
211         Stamp memory _stamp = authorities[authority].stamps[i];
212         require(_stamp.exists);
213         return _stamp.hash;
214     }
215 
216     function getStampData(address authority, uint256 i) public view returns(string memory data) {
217         Stamp memory _stamp = authorities[authority].stamps[i];
218         require(_stamp.exists);
219         return _stamp.data;
220     }
221 
222     function getStampsRange(address authority, uint256 frm, uint256 to, string memory separator) public view returns(string memory hashstr, string memory datastr) {
223         Stamp[] memory stamps = authorities[authority].stamps;
224         strings.slice memory hashBuf = strings.toSlice("");
225         strings.slice memory dataBuf = strings.toSlice("");
226         strings.slice memory sep = strings.toSlice(separator);
227         for(uint256 c = frm; c < to; c++) {
228             hashBuf = strings.toSlice(strings.concat(hashBuf, strings.toSlice(strings.concat(strings.toSlice(stamps[c].hash), sep))));
229             dataBuf = strings.toSlice(strings.concat(dataBuf, strings.toSlice(strings.concat(strings.toSlice(stamps[c].data), sep))));
230         }
231         return (strings.toString(hashBuf), strings.toString(dataBuf));
232     }
233 
234     function getStampByHash(address authority, string memory hash) public view returns (string memory data, bool exists) {
235         Stamp memory _stamp = authorities[authority].hashToStamp[hash];
236         return (_stamp.data, _stamp.exists);
237     }
238 
239 }