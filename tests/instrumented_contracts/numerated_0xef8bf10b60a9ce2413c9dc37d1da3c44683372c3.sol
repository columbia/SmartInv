1 /**
2  * Copyright (C) 2017-2018 Hashfuture Inc. All rights reserved.
3  */
4 
5 pragma solidity ^0.4.22;
6 
7 /**
8  * @title String & slice utility library for Solidity contracts.
9  * @author Nick Johnson <arachnid@notdot.net>
10  */
11 library strings {
12     struct slice {
13         uint _len;
14         uint _ptr;
15     }
16     
17     function memcpy(uint dest, uint src, uint len) private pure {
18         // Copy word-length chunks while possible
19         for(; len >= 32; len -= 32) {
20             assembly {
21                 mstore(dest, mload(src))
22             }
23             dest += 32;
24             src += 32;
25         }
26 
27         // Copy remaining bytes
28         uint mask = 256 ** (32 - len) - 1;
29         assembly {
30             let srcpart := and(mload(src), not(mask))
31             let destpart := and(mload(dest), mask)
32             mstore(dest, or(destpart, srcpart))
33         }
34     }
35     
36     /*
37      * @dev Copies a slice to a new string.
38      * @param self The slice to copy.
39      * @return A newly allocated string containing the slice's text.
40      */
41     function toString(slice memory self) internal pure returns (string memory) {
42         string memory ret = new string(self._len);
43         uint retptr;
44         assembly { retptr := add(ret, 32) }
45 
46         memcpy(retptr, self._ptr, self._len);
47         return ret;
48     }
49     
50     /*
51      * @dev Returns a slice containing the entire string.
52      * @param self The string to make a slice from.
53      * @return A newly allocated slice containing the entire string.
54      */
55     function toSlice(string memory self) internal pure returns (slice memory) {
56         uint ptr;
57         assembly {
58             ptr := add(self, 0x20)
59         }
60         return slice(bytes(self).length, ptr);
61     }
62     
63     /*
64      * @dev Returns true if the slice is empty (has a length of 0).
65      * @param self The slice to operate on.
66      * @return True if the slice is empty, False otherwise.
67      */
68     function empty(slice memory self) internal pure returns (bool) {
69         return self._len == 0;
70     }
71     
72     /*
73      * @dev Splits the slice, setting `self` to everything after the first
74      *      occurrence of `needle`, and `token` to everything before it. If
75      *      `needle` does not occur in `self`, `self` is set to the empty slice,
76      *      and `token` is set to the entirety of `self`.
77      * @param self The slice to split.
78      * @param needle The text to search for in `self`.
79      * @param token An output parameter to which the first token is written.
80      * @return `token`.
81      */
82     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
83         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
84         token._ptr = self._ptr;
85         token._len = ptr - self._ptr;
86         if (ptr == self._ptr + self._len) {
87             // Not found
88             self._len = 0;
89         } else {
90             self._len -= token._len + needle._len;
91             self._ptr = ptr + needle._len;
92         }
93         return token;
94     }
95 
96     /*
97      * @dev Splits the slice, setting `self` to everything after the first
98      *      occurrence of `needle`, and returning everything before it. If
99      *      `needle` does not occur in `self`, `self` is set to the empty slice,
100      *      and the entirety of `self` is returned.
101      * @param self The slice to split.
102      * @param needle The text to search for in `self`.
103      * @return The part of `self` up to the first occurrence of `delim`.
104      */
105     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
106         split(self, needle, token);
107     }
108     
109     // Returns the memory address of the first byte of the first occurrence of
110     // `needle` in `self`, or the first byte after `self` if not found.
111     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
112         uint ptr = selfptr;
113         uint idx;
114 
115         if (needlelen <= selflen) {
116             if (needlelen <= 32) {
117                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
118 
119                 bytes32 needledata;
120                 assembly { needledata := and(mload(needleptr), mask) }
121 
122                 uint end = selfptr + selflen - needlelen;
123                 bytes32 ptrdata;
124                 assembly { ptrdata := and(mload(ptr), mask) }
125 
126                 while (ptrdata != needledata) {
127                     if (ptr >= end)
128                         return selfptr + selflen;
129                     ptr++;
130                     assembly { ptrdata := and(mload(ptr), mask) }
131                 }
132                 return ptr;
133             } else {
134                 // For long needles, use hashing
135                 bytes32 hash;
136                 assembly { hash := keccak256(needleptr, needlelen) }
137 
138                 for (idx = 0; idx <= selflen - needlelen; idx++) {
139                     bytes32 testHash;
140                     assembly { testHash := keccak256(ptr, needlelen) }
141                     if (hash == testHash)
142                         return ptr;
143                     ptr += 1;
144                 }
145             }
146         }
147         return selfptr + selflen;
148     }
149 
150     /*
151      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
152      * @param self The slice to search.
153      * @param needle The text to search for in `self`.
154      * @return The number of occurrences of `needle` found in `self`.
155      */
156     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
157         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
158         while (ptr <= self._ptr + self._len) {
159             cnt++;
160             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
161         }
162     }
163     
164 }
165 
166 contract owned {
167     address public holder;
168 
169     constructor() public {
170         holder = msg.sender;
171     }
172 
173     modifier onlyHolder {
174         require(msg.sender == holder, "This function can only be called by holder");
175         _;
176     }
177 }
178 
179 contract asset is owned {
180     using strings for *;
181 
182     /**
183     * Asset Struct
184     */
185     struct data {
186         //link URL of the original information for storing data
187         //     null means undisclosed
188         string link;
189         //The encryption method of the original data, such as SHA-256
190         string encryptionType;
191         //Hash value
192         string hashValue;
193     }
194 
195     data[] dataArray;
196     uint dataNum;
197 
198     //The validity of the contract
199     bool public isValid;
200     
201     //The init status
202     bool public isInit;
203     
204     //The tradeable status of asset
205     bool public isTradeable;
206     uint public price;
207 
208     //Some notes
209     string public remark1;
210 
211     //Other notes, holder can be written
212     //Reservations for validation functions
213     string public remark2;
214 
215     /** constructor */
216     constructor() public {
217         isValid = true;
218         isInit = false;
219         isTradeable = false;
220         price = 0;
221         dataNum = 0;
222     }
223 
224     /**
225      * Initialize a new asset
226      * @param dataNumber The number of data array
227      * @param linkSet The set of URL of the original information for storing data, empty means undisclosed
228      *          needle is " "
229      * @param encryptionTypeSet The set of encryption method of the original data, such as SHA-256
230      *          needle is " "
231      * @param hashValueSet The set of hashvalue
232      *          needle is " "
233      */
234     function initAsset(
235         uint dataNumber,
236         string linkSet,
237         string encryptionTypeSet,
238         string hashValueSet) public onlyHolder {
239         // split string to array
240         var links = linkSet.toSlice();
241         var encryptionTypes = encryptionTypeSet.toSlice();
242         var hashValues = hashValueSet.toSlice();
243         var delim = " ".toSlice();
244         
245         dataNum = dataNumber;
246         
247         // after init, the initAsset function cannot be called
248         require(isInit == false, "The contract has been initialized");
249 
250         //check data
251         require(dataNumber >= 1, "Param dataNumber smaller than 1");
252         require(dataNumber - 1 == links.count(delim), "Param linkSet invalid");
253         require(dataNumber - 1 == encryptionTypes.count(delim), "Param encryptionTypeSet invalid");
254         require(dataNumber - 1 == hashValues.count(delim), "Param hashValueSet invalid");
255         
256         isInit = true;
257         
258         var empty = "".toSlice();
259         
260         for (uint i = 0; i < dataNumber; i++) {
261             var link = links.split(delim);
262             var encryptionType = encryptionTypes.split(delim);
263             var hashValue = hashValues.split(delim);
264             
265             //require data not null
266             // link can be empty
267             require(!encryptionType.empty(), "Param encryptionTypeSet data error");
268             require(!hashValue.empty(), "Param hashValueSet data error");
269             
270             dataArray.push(
271                 data(link.toString(), encryptionType.toString(), hashValue.toString())
272                 );
273         }
274     }
275     
276      /**
277      * Get base asset info
278      */
279     function getAssetBaseInfo() public view returns (uint _price,
280                                                  bool _isTradeable,
281                                                  uint _dataNum,
282                                                  string _remark1,
283                                                  string _remark2) {
284         require(isValid == true, "contract invaild");
285         _price = price;
286         _isTradeable = isTradeable;
287         _dataNum = dataNum;
288         _remark1 = remark1;
289         _remark2 = remark2;
290     }
291     
292     /**
293      * Get data info by index
294      * @param index index of dataArray
295      */
296     function getDataByIndex(uint index) public view returns (string link, string encryptionType, string hashValue) {
297         require(isValid == true, "contract invaild");
298         require(index >= 0, "Param index smaller than 0");
299         require(index < dataNum, "Param index not smaller than dataNum");
300         link = dataArray[index].link;
301         encryptionType = dataArray[index].encryptionType;
302         hashValue = dataArray[index].hashValue;
303     }
304 
305     /**
306      * set the price of asset
307      * @param newPrice price of asset
308      * Only can be called by holder
309      */
310     function setPrice(uint newPrice) public onlyHolder {
311         require(isValid == true, "contract invaild");
312         price = newPrice;
313     }
314 
315     /**
316      * set the tradeable status of asset
317      * @param status status of isTradeable
318      * Only can be called by holder
319      */
320     function setTradeable(bool status) public onlyHolder {
321         require(isValid == true, "contract invaild");
322         isTradeable = status;
323     }
324 
325     /**
326      * set the remark1
327      * @param content new content of remark1
328      * Only can be called by holder
329      */
330     function setRemark1(string content) public onlyHolder {
331         require(isValid == true, "contract invaild");
332         remark1 = content;
333     }
334 
335     /**
336      * set the remark2
337      * @param content new content of remark2
338      * Only can be called by holder
339      */
340     function setRemark2(string content) public onlyHolder {
341         require(isValid == true, "contract invaild");
342         remark2 = content;
343     }
344 
345     /**
346      * Modify the link of the indexth data to be url
347      * @param index index of assetInfo
348      * @param url new link
349      * Only can be called by holder
350      */
351     function setDataLink(uint index, string url) public onlyHolder {
352         require(isValid == true, "contract invaild");
353         require(index >= 0, "Param index smaller than 0");
354         require(index < dataNum, "Param index not smaller than dataNum");
355         dataArray[index].link = url;
356     }
357 
358     /**
359      * cancel contract
360      * Only can be called by holder
361      */
362     function cancelContract() public onlyHolder {
363         isValid = false;
364     }
365     
366     /**
367      * Get the number of assetInfo
368      */
369     function getDataNum() public view returns (uint num) {
370         num = dataNum;
371     }
372 
373     /**
374      * Transfer holder
375      */
376     function transferOwnership(address newHolder, bool status) public onlyHolder {
377         holder = newHolder;
378         isTradeable = status;
379     }
380 }