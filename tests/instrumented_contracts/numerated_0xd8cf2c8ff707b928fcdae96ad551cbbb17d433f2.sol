1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath from zeppelin-solidity
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title PNS - Physical Form of CryptoCurrency Name System
51  * @dev Physical form cryptocurrency name system smart contract is implemented 
52  * to manage and record physical form cryptocurrency manufacturers' 
53  * informations, such as the name of the manufacturer, the public key 
54  * of the key pair whose private key signed the certificate of the physical 
55  * form cryptocurrency, etc.
56  * 
57  * @author Hui Xie - <hui.742369@gmail.com>
58  */
59 contract PNS {
60 
61     using SafeMath for uint256; 
62 
63     // Event of register
64     event Register(address indexed _from, string _mfr, bytes32 _mid);
65 
66     // Event of transfer ownership
67     event Transfer(address indexed _from, string _mfr, bytes32 _mid, address _owner);
68 
69     // Event of push a new batch
70     event Push(address indexed _from, string _mfr, bytes32 _mid, string _bn, bytes32 _bid, bytes _key);
71 
72     // Event of set batch number
73     event SetBn(address indexed _from, string _mfr, bytes32 _mid, string _bn, bytes32 _bid, bytes _key);
74 
75     // Event of set public key
76     event SetKey(address indexed _from, string _mfr, bytes32 _mid, string _bn, bytes32 _bid, bytes _key);
77 
78     // Event of lock a batch
79     event Lock(address indexed _from, string _mfr, bytes32 _mid, string _bn, bytes32 _bid, bytes _key);
80 
81     // Manufacturer informations
82     struct Manufacturer {
83         address owner; // owner address
84         string mfr; // manufacturer name
85         mapping (bytes32 => Batch) batchmapping; // mapping of batch: mapping (batch ID => batch structure)
86         mapping (uint256 => bytes32) bidmapping; // mapping of batch ID: mapping (storage index => batch ID), batch ID = keccak256(batch number)
87         uint256 bidcounter; // storage index counter of bidmapping
88     }
89 
90     // Product batch informations
91     struct Batch {
92         string bn; // batch number
93         bytes key; // public key
94         bool lock; // is changeable or not
95     }
96 
97     // Mapping of manufactures: mapping (manufacturer ID => manufacturer struct), Manufacturer ID = keccak256(uppercaseOf(manufacturer name))
98     mapping (bytes32 => Manufacturer) internal mfrmapping;
99 
100     // Mapping of manufacturer ID: mapping (storage index => manufacturer ID)
101     mapping (uint256 => bytes32) internal midmapping;
102 
103     // Storage index counter of midmapping
104     uint256 internal midcounter;
105     
106     /**
107      * @dev Register a manufacturer.
108      * 
109      * @param _mfr Manufacturer name
110      * @return Manufacturer ID
111      */
112     function register(string _mfr) public returns (bytes32) {
113         require(lengthOf(_mfr) > 0);
114         require(msg.sender != address(0));
115 
116         bytes32 mid = keccak256(bytes(uppercaseOf(_mfr)));
117         require(mfrmapping[mid].owner == address(0));
118 
119         midcounter = midcounter.add(1);
120         midmapping[midcounter] = mid;
121 
122         mfrmapping[mid].owner = msg.sender;
123         mfrmapping[mid].mfr = _mfr;
124         
125         emit Register(msg.sender, _mfr, mid);
126 
127         return mid;
128     }
129 
130     /**
131      * @dev Transfer ownership of a manufacturer.
132      * 
133      * @param _mid Manufacturer ID
134      * @param _owner Address of new owner
135      * @return Batch ID
136      */
137     function transfer(bytes32 _mid, address _owner) public returns (bytes32) {
138         require(_mid != bytes32(0));
139         require(_owner != address(0));
140 
141         require(mfrmapping[_mid].owner != address(0));
142         require(msg.sender == mfrmapping[_mid].owner);
143 
144         mfrmapping[_mid].owner = _owner;
145 
146         emit Transfer(msg.sender, mfrmapping[_mid].mfr, _mid, _owner);
147 
148         return _mid;
149     }
150     
151     /**
152      * @dev Push(add) a batch.
153      * 
154      * @param _mid Manufacturer ID
155      * @param _bn Batch number
156      * @param _key Public key
157      * @return Batch ID
158      */
159     function push(bytes32 _mid, string _bn, bytes _key) public returns (bytes32) {
160         require(_mid != bytes32(0));
161         require(lengthOf(_bn) > 0);
162         require(_key.length == 33 || _key.length == 65);
163 
164         require(mfrmapping[_mid].owner != address(0));
165         require(msg.sender == mfrmapping[_mid].owner);
166 
167         bytes32 bid = keccak256(bytes(_bn));
168         require(lengthOf(mfrmapping[_mid].batchmapping[bid].bn) == 0);
169         require(mfrmapping[_mid].batchmapping[bid].key.length == 0);
170         require(mfrmapping[_mid].batchmapping[bid].lock == false);
171 
172         mfrmapping[_mid].bidcounter = mfrmapping[_mid].bidcounter.add(1);
173         mfrmapping[_mid].bidmapping[mfrmapping[_mid].bidcounter] = bid;
174         mfrmapping[_mid].batchmapping[bid].bn = _bn;
175         mfrmapping[_mid].batchmapping[bid].key = _key;
176         mfrmapping[_mid].batchmapping[bid].lock = false;
177 
178         emit Push(msg.sender, mfrmapping[_mid].mfr, _mid, _bn, bid, _key);
179 
180         return bid;
181     }
182 
183     /**
184      * @dev Set(change) batch number of an unlocked batch.
185      * 
186      * @param _mid Manufacturer ID
187      * @param _bid Batch ID
188      * @param _bn Batch number
189      * @return Batch ID
190      */
191     function setBn(bytes32 _mid, bytes32 _bid, string _bn) public returns (bytes32) {
192         require(_mid != bytes32(0));
193         require(_bid != bytes32(0));
194         require(lengthOf(_bn) > 0);
195 
196         require(mfrmapping[_mid].owner != address(0));
197         require(msg.sender == mfrmapping[_mid].owner);
198 
199         bytes32 bid = keccak256(bytes(_bn));
200         require(bid != _bid);
201         require(lengthOf(mfrmapping[_mid].batchmapping[_bid].bn) > 0);
202         require(mfrmapping[_mid].batchmapping[_bid].key.length > 0);
203         require(mfrmapping[_mid].batchmapping[_bid].lock == false);
204         require(lengthOf(mfrmapping[_mid].batchmapping[bid].bn) == 0);
205         require(mfrmapping[_mid].batchmapping[bid].key.length == 0);
206         require(mfrmapping[_mid].batchmapping[bid].lock == false);
207 
208         uint256 counter = 0;
209         for (uint256 i = 1; i <= mfrmapping[_mid].bidcounter; i++) {
210             if (mfrmapping[_mid].bidmapping[i] == _bid) {
211                 counter = i;
212                 break;
213             }
214         }
215         require(counter > 0);
216 
217         mfrmapping[_mid].bidmapping[counter] = bid;
218         mfrmapping[_mid].batchmapping[bid].bn = _bn;
219         mfrmapping[_mid].batchmapping[bid].key = mfrmapping[_mid].batchmapping[_bid].key;
220         mfrmapping[_mid].batchmapping[bid].lock = false;
221         delete mfrmapping[_mid].batchmapping[_bid];
222 
223         emit SetBn(msg.sender, mfrmapping[_mid].mfr, _mid, _bn, bid, mfrmapping[_mid].batchmapping[bid].key);
224 
225         return bid;
226     }
227 
228     /**
229      * @dev Set(change) public key of an unlocked batch.
230      * 
231      * @param _mid Manufacturer ID
232      * @param _bid Batch ID
233      * @param _key Public key
234      * @return Batch ID
235      */
236     function setKey(bytes32 _mid, bytes32 _bid, bytes _key) public returns (bytes32) {
237         require(_mid != bytes32(0));
238         require(_bid != bytes32(0));
239         require(_key.length == 33 || _key.length == 65);
240 
241         require(mfrmapping[_mid].owner != address(0));
242         require(msg.sender == mfrmapping[_mid].owner);
243 
244         require(lengthOf(mfrmapping[_mid].batchmapping[_bid].bn) > 0);
245         require(mfrmapping[_mid].batchmapping[_bid].key.length > 0);
246         require(mfrmapping[_mid].batchmapping[_bid].lock == false);
247 
248         mfrmapping[_mid].batchmapping[_bid].key = _key;
249 
250         emit SetKey(msg.sender, mfrmapping[_mid].mfr, _mid, mfrmapping[_mid].batchmapping[_bid].bn, _bid, _key);
251 
252         return _bid;
253     }
254 
255     /**
256      * @dev Lock batch. Batch number and public key is unchangeable after it is locked.
257      * 
258      * @param _mid Manufacturer ID
259      * @param _bid Batch ID
260      * @return Batch ID
261      */
262     function lock(bytes32 _mid, bytes32 _bid) public returns (bytes32) {
263         require(_mid != bytes32(0));
264         require(_bid != bytes32(0));
265 
266         require(mfrmapping[_mid].owner != address(0));
267         require(msg.sender == mfrmapping[_mid].owner);
268 
269         require(lengthOf(mfrmapping[_mid].batchmapping[_bid].bn) > 0);
270         require(mfrmapping[_mid].batchmapping[_bid].key.length > 0);
271 
272         mfrmapping[_mid].batchmapping[_bid].lock = true;
273 
274         emit Lock(msg.sender, mfrmapping[_mid].mfr, _mid, mfrmapping[_mid].batchmapping[_bid].bn, _bid, mfrmapping[_mid].batchmapping[_bid].key);
275 
276         return _bid;
277     }
278 
279     /**
280      * @dev Check batch by its batch ID and public key.
281      * 
282      * @param _mid Manufacturer ID
283      * @param _bid Batch ID
284      * @param _key Public key
285      * @return True or false
286      */
287     function check(bytes32 _mid, bytes32 _bid, bytes _key) public view returns (bool) {
288         if (mfrmapping[_mid].batchmapping[_bid].key.length != _key.length) {
289             return false;
290         }
291         for (uint256 i = 0; i < _key.length; i++) {
292             if (mfrmapping[_mid].batchmapping[_bid].key[i] != _key[i]) {
293                 return false;
294             }
295         }
296         return true;
297     }
298 
299     /**
300      * @dev Get total number of manufacturers.
301      * 
302      * @return Total number of manufacturers
303      */
304     function totalMfr() public view returns (uint256) {
305         return midcounter;
306     }
307 
308     /**
309      * @dev Get manufacturer ID.
310      * 
311      * @param _midcounter Storage index counter of midmapping
312      * @return Manufacturer ID
313      */
314     function midOf(uint256 _midcounter) public view returns (bytes32) {
315         return midmapping[_midcounter];
316     }
317 
318     /**
319      * @dev Get manufacturer owner.
320      * 
321      * @param _mid Manufacturer ID
322      * @return Manufacturer owner
323      */
324     function ownerOf(bytes32 _mid) public view returns (address) {
325         return mfrmapping[_mid].owner;
326     }
327     
328     /**
329      * @dev Get manufacturer name.
330      * 
331      * @param _mid Manufacturer ID
332      * @return Manufacturer name (Uppercase)
333      */
334     function mfrOf(bytes32 _mid) public view returns (string) {
335         return mfrmapping[_mid].mfr;
336     }
337     
338     /**
339      * @dev Get total batch number of a manufacturer.
340      * 
341      * @param _mid Manufacturer ID
342      * @return Total batch number
343      */
344     function totalBatchOf(bytes32 _mid) public view returns (uint256) {
345         return mfrmapping[_mid].bidcounter;
346     }
347 
348     /**
349      * @dev Get batch ID.
350      * 
351      * @param _mid Manufacturer ID
352      * @param _bidcounter Storage index counter of bidmapping
353      * @return Batch ID
354      */
355     function bidOf(bytes32 _mid, uint256 _bidcounter) public view returns (bytes32) {
356         return mfrmapping[_mid].bidmapping[_bidcounter];
357     }
358 
359     /**
360      * @dev Get batch number.
361      * 
362      * @param _mid Manufacturer ID
363      * @param _bid Batch ID
364      * @return Batch number
365      */
366     function bnOf(bytes32 _mid, bytes32 _bid) public view returns (string) {
367         return mfrmapping[_mid].batchmapping[_bid].bn;
368     }
369     
370     /**
371      * @dev Get batch public key.
372      * 
373      * @param _mid Manufacturer ID
374      * @param _bid Batch ID
375      * @return bytes Batch public key
376      */
377     function keyOf(bytes32 _mid, bytes32 _bid) public view returns (bytes) {
378         if (mfrmapping[_mid].batchmapping[_bid].lock == true) {
379             return mfrmapping[_mid].batchmapping[_bid].key;
380         }
381     }
382 
383     /**
384      * @dev Convert string to uppercase.
385      * 
386      * @param _s String to convert
387      * @return Converted string
388      */
389     function uppercaseOf(string _s) internal pure returns (string) {
390         bytes memory b1 = bytes(_s);
391         uint256 l = b1.length;
392         bytes memory b2 = new bytes(l);
393         for (uint256 i = 0; i < l; i++) {
394             if (b1[i] >= 0x61 && b1[i] <= 0x7A) {
395                 b2[i] = bytes1(uint8(b1[i]) - 32);
396             } else {
397                 b2[i] = b1[i];
398             }
399         }
400         return string(b2);
401     }
402 
403     /**
404      * @dev Get string length.
405      * 
406      * @param _s String
407      * @return length
408      */
409     function lengthOf(string _s) internal pure returns (uint256) {
410         return bytes(_s).length;
411     }
412 }