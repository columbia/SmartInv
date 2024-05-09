1 /**
2  * Copyright (C) 2017-2018 Hashfuture Inc. All rights reserved.
3  */
4 
5 pragma solidity ^0.4.22;
6 
7 library strings {
8     struct slice {
9         uint _len;
10         uint _ptr;
11     }
12     
13     function memcpy(uint dest, uint src, uint len) private pure {
14         // Copy word-length chunks while possible
15         for(; len >= 32; len -= 32) {
16             assembly {
17                 mstore(dest, mload(src))
18             }
19             dest += 32;
20             src += 32;
21         }
22 
23         // Copy remaining bytes
24         uint mask = 256 ** (32 - len) - 1;
25         assembly {
26             let srcpart := and(mload(src), not(mask))
27             let destpart := and(mload(dest), mask)
28             mstore(dest, or(destpart, srcpart))
29         }
30     }
31     
32     /*
33      * @dev Copies a slice to a new string.
34      * @param self The slice to copy.
35      * @return A newly allocated string containing the slice's text.
36      */
37     function toString(slice memory self) internal pure returns (string memory) {
38         string memory ret = new string(self._len);
39         uint retptr;
40         assembly { retptr := add(ret, 32) }
41 
42         memcpy(retptr, self._ptr, self._len);
43         return ret;
44     }
45     
46     /*
47      * @dev Returns a slice containing the entire string.
48      * @param self The string to make a slice from.
49      * @return A newly allocated slice containing the entire string.
50      */
51     function toSlice(string memory self) internal pure returns (slice memory) {
52         uint ptr;
53         assembly {
54             ptr := add(self, 0x20)
55         }
56         return slice(bytes(self).length, ptr);
57     }
58     
59     /*
60      * @dev Returns true if the slice is empty (has a length of 0).
61      * @param self The slice to operate on.
62      * @return True if the slice is empty, False otherwise.
63      */
64     function empty(slice memory self) internal pure returns (bool) {
65         return self._len == 0;
66     }
67     
68     /*
69      * @dev Splits the slice, setting `self` to everything after the first
70      *      occurrence of `needle`, and `token` to everything before it. If
71      *      `needle` does not occur in `self`, `self` is set to the empty slice,
72      *      and `token` is set to the entirety of `self`.
73      * @param self The slice to split.
74      * @param needle The text to search for in `self`.
75      * @param token An output parameter to which the first token is written.
76      * @return `token`.
77      */
78     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
79         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
80         token._ptr = self._ptr;
81         token._len = ptr - self._ptr;
82         if (ptr == self._ptr + self._len) {
83             // Not found
84             self._len = 0;
85         } else {
86             self._len -= token._len + needle._len;
87             self._ptr = ptr + needle._len;
88         }
89         return token;
90     }
91 
92     /*
93      * @dev Splits the slice, setting `self` to everything after the first
94      *      occurrence of `needle`, and returning everything before it. If
95      *      `needle` does not occur in `self`, `self` is set to the empty slice,
96      *      and the entirety of `self` is returned.
97      * @param self The slice to split.
98      * @param needle The text to search for in `self`.
99      * @return The part of `self` up to the first occurrence of `delim`.
100      */
101     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
102         split(self, needle, token);
103     }
104     
105     // Returns the memory address of the first byte of the first occurrence of
106     // `needle` in `self`, or the first byte after `self` if not found.
107     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
108         uint ptr = selfptr;
109         uint idx;
110 
111         if (needlelen <= selflen) {
112             if (needlelen <= 32) {
113                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
114 
115                 bytes32 needledata;
116                 assembly { needledata := and(mload(needleptr), mask) }
117 
118                 uint end = selfptr + selflen - needlelen;
119                 bytes32 ptrdata;
120                 assembly { ptrdata := and(mload(ptr), mask) }
121 
122                 while (ptrdata != needledata) {
123                     if (ptr >= end)
124                         return selfptr + selflen;
125                     ptr++;
126                     assembly { ptrdata := and(mload(ptr), mask) }
127                 }
128                 return ptr;
129             } else {
130                 // For long needles, use hashing
131                 bytes32 hash;
132                 assembly { hash := keccak256(needleptr, needlelen) }
133 
134                 for (idx = 0; idx <= selflen - needlelen; idx++) {
135                     bytes32 testHash;
136                     assembly { testHash := keccak256(ptr, needlelen) }
137                     if (hash == testHash)
138                         return ptr;
139                     ptr += 1;
140                 }
141             }
142         }
143         return selfptr + selflen;
144     }
145 
146     /*
147      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
148      * @param self The slice to search.
149      * @param needle The text to search for in `self`.
150      * @return The number of occurrences of `needle` found in `self`.
151      */
152     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
153         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
154         while (ptr <= self._ptr + self._len) {
155             cnt++;
156             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
157         }
158     }
159     
160 }
161 
162 contract owned {
163     address public holder;
164 
165     constructor() public {
166         holder = msg.sender;
167     }
168 
169     modifier onlyHolder {
170         require(msg.sender == holder, "This func only can be calle by holder");
171         _;
172     }
173 }
174 
175 contract asset is owned {
176     using strings for *;
177     /*Asset Struct*/
178     struct data {
179         //link URL of the original information for storing data
180         //     null means undisclosed
181         string link;
182         //The encryption method of the original data, such as SHA-256
183         string encryptionType;
184         //Hash value
185         string hashValue;
186     }
187 
188     data[] dataArray;
189     uint dataNum;
190 
191     //The validity of the contract
192     bool public isValid;
193     
194     //The init status
195     bool public isInit;
196     
197     //The tradeable status of asset
198     bool public isTradeable;
199     uint public price;
200 
201     //Some notes
202     string public remark1;
203 
204     //Other notes, holder can be written
205     //Reservations for validation functions
206     string public remark2;
207 
208     /** constructor */
209     constructor() public {
210         isValid = true;
211         isInit = false;
212         isTradeable = false;
213         price = 0;
214         dataNum = 0;
215     }
216 
217     /**
218      * Initialize a new asset
219      * @param dataNumber The number of data array
220      * @param linkSet The set of URL of the original information for storing data, if null means undisclosed
221      *          needle is " "
222      * @param encryptionTypeSet The set of encryption method of the original data, such as SHA-256
223      *          needle is " "
224      * @param hashValueSet The set of hashvalue
225      *          needle is " "
226      */
227     function initAsset(
228         uint dataNumber,
229         string linkSet,
230         string encryptionTypeSet,
231         string hashValueSet) public onlyHolder {
232         // split string to array
233         var links = linkSet.toSlice();
234         var encryptionTypes = encryptionTypeSet.toSlice();
235         var hashValues = hashValueSet.toSlice();
236         var delim = " ".toSlice();
237         
238         dataNum = dataNumber;
239         
240         // after init, the initAsset function cannot be called
241         require(isInit == false, "The contract has been initialized");
242 
243         //check data
244         require(dataNumber >= 1, "The dataNumber should bigger than 1");
245         require(dataNumber - 1 == links.count(delim), "The uumber of linkSet error");
246         require(dataNumber - 1 == encryptionTypes.count(delim), "The uumber of encryptionTypeSet error");
247         require(dataNumber - 1 == hashValues.count(delim), "The uumber of hashValues error");
248         
249         isInit = true;
250         
251         var empty = "".toSlice();
252         
253         for (uint i = 0; i < dataNumber; i++) {
254             var link = links.split(delim);
255             var encryptionType = encryptionTypes.split(delim);
256             var hashValue = hashValues.split(delim);
257             
258             //require data not null
259             // link can be empty
260             require(!encryptionType.empty(), "The encryptionTypeSet data error");
261             require(!hashValue.empty(), "The hashValues data error");
262             
263             dataArray.push(
264                 data(link.toString(), encryptionType.toString(), hashValue.toString())
265                 );
266         }
267     }
268     
269      /**
270      * Get base asset info
271      */
272     function getAssetBaseInfo() public view returns (uint _price,
273                                                  bool _isTradeable,
274                                                  uint _dataNum,
275                                                  string _remark1,
276                                                  string _remark2) {
277         require(isValid == true, "contract is invaild");
278         _price = price;
279         _isTradeable = isTradeable;
280         _dataNum = dataNum;
281         _remark1 = remark1;
282         _remark2 = remark2;
283     }
284     
285     /**
286      * Get data info by index
287      * @param index index of dataArray
288      */
289     function getDataByIndex(uint index) public view returns (string link, string encryptionType, string hashValue) {
290         require(isValid == true, "contract is invaild");
291         require(index >= 0, "The idx smaller than 0");
292         require(index < dataNum, "The idx bigger than dataNum");
293         link = dataArray[index].link;
294         encryptionType = dataArray[index].encryptionType;
295         hashValue = dataArray[index].hashValue;
296     }
297 
298     /**
299      * set the price of asset
300      * @param newPrice price of asset
301      * Only can be called by holder
302      */
303     function setPrice(uint newPrice) public onlyHolder {
304         require(isValid == true, "contract is invaild");
305         price = newPrice;
306     }
307 
308     /**
309      * set the tradeable status of asset
310      * @param status status of isTradeable
311      * Only can be called by holder
312      */
313     function setTradeable(bool status) public onlyHolder {
314         require(isValid == true, "contract is invaild");
315         isTradeable = status;
316     }
317 
318     /**
319      * set the remark1
320      * @param content new content of remark1
321      * Only can be called by holder
322      */
323     function setRemark1(string content) public onlyHolder {
324         require(isValid == true, "contract is invaild");
325         remark1 = content;
326     }
327 
328     /**
329      * set the remark2
330      * @param content new content of remark2
331      * Only can be called by holder
332      */
333     function setRemark2(string content) public onlyHolder {
334         require(isValid == true, "contract is invaild");
335         remark2 = content;
336     }
337 
338     /**
339      * Modify the link of the indexth data to be url
340      * @param index index of assetInfo
341      * @param url new link
342      * Only can be called by holder
343      */
344     function setDataLink(uint index, string url) public onlyHolder {
345         require(isValid == true, "contract is invaild");
346         require(index >= 0, "The index smaller than 0");
347         require(index < dataNum, "The index bigger than dataNum");
348         dataArray[index].link = url;
349     }
350 
351     /**
352      * cancel contract
353      * Only can be called by holder
354      */
355     function cancelContract() public onlyHolder {
356         isValid = false;
357     }
358     
359     /**
360      * Get the number of assetInfo
361      */
362     function getDataNum() public view returns (uint num) {
363         num = dataNum;
364     }
365 
366     /**
367      * Transfer holder
368      */
369     function transferOwnership(address newHolder, bool status) public onlyHolder {
370         holder = newHolder;
371         isTradeable = status;
372     }
373 }