1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9 
10     address public owner;
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     function Ownable() public {
14         owner = msg.sender;
15     }
16 
17     modifier onlyOwner() {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     function transferOwnership(address newOwner) public onlyOwner {
23         require(newOwner != address(0));
24         emit OwnershipTransferred(owner, newOwner);
25         owner = newOwner;
26     }
27 }
28 
29 /** @dev contract extended Ownable */
30 contract ManageableContract is Ownable {
31 
32     mapping (address => bool) internal pf_manager; // SP maganer, Artificial Intelligence AI in the fuature
33     uint256[] internal pf_m_count; // clients tasks counter
34 
35     mapping (address => bool) internal performers;
36     uint256[] internal pf_count; // clients tasks counter
37 
38     mapping (address => bool) internal cr_manager; // client relations manager CR-Manager
39     uint256[] internal cr_count; // clients tasks counter
40 
41     mapping (address => bool) internal clients;
42     uint256[] internal cli_count; // clients tasks counter
43 
44     // MODIFIERS
45     modifier is_cli() {
46         require(clients[msg.sender] == true);
47         _;
48     }
49 
50     modifier is_no_cli() {
51         require(clients[msg.sender] != true);
52         _;
53     }
54 
55     modifier is_cr_mng() {
56         require(cr_manager[msg.sender] == true);
57         _;
58     }
59 
60     modifier is_pfm() {
61         require(performers[msg.sender] == true);
62         _;
63     }
64 
65     modifier is_pf_mng() {
66         require(pf_manager[msg.sender] == true);
67         _;
68     }
69 
70     modifier is_cli_trust() {
71         require(
72             owner == msg.sender            ||
73             cr_manager[msg.sender] == true
74             );
75         _;
76     }
77 
78     modifier is_cli_or_trust() {
79         require(
80             clients[msg.sender] == true    ||
81             owner == msg.sender            ||
82             cr_manager[msg.sender] == true ||
83             performers[msg.sender] == true ||
84             pf_manager[msg.sender] == true
85             );
86         _;
87     }
88 
89     modifier is_trust() {
90         require(
91             owner == msg.sender            ||
92             cr_manager[msg.sender] == true ||
93             performers[msg.sender] == true ||
94             pf_manager[msg.sender] == true
95             );
96         _;
97     }
98 
99     function setPFManager(address _manager) public onlyOwner
100         returns (bool, address)
101     {
102         pf_manager[_manager] = true;
103         pf_m_count.push(1);
104         return (true, _manager);
105     }
106 
107     function setPerformer(address _to) public onlyOwner
108         returns (bool, address)
109     {
110         performers[_to] = true;
111         pf_count.push(1);
112         return (true, _to);
113     }
114 
115     function setCRManager(address _manager) public onlyOwner
116         returns (bool, address)
117     {
118         cr_manager[_manager] = true;
119         cr_count.push(1);
120         return (true, _manager);
121     }
122 
123     /** get client task length */
124     function countPerformers() public view returns (uint256) {
125         return pf_m_count.length;
126     }
127 
128     /** get client task length */
129     function countPerfManagers() public view returns (uint256) {
130         return pf_count.length;
131     }
132 
133     /** get client task length */
134     function countCliManagers() public view returns (uint256) {
135         return cr_count.length;
136     }
137 
138     /** get client task length */
139     function countClients() public view returns (uint256) {
140         return cli_count.length;
141     }
142 }
143 
144 /** @dev contact types transform */
145 contract Converter {
146 
147         function bytes32ToBytes(bytes32 data) internal pure returns (bytes) {
148         uint i = 0;
149         while (i < 32 && uint(data[i]) != 0) {
150             ++i;
151         }
152         bytes memory result = new bytes(i);
153         i = 0;
154         while (i < 32 && data[i] != 0) {
155             result[i] = data[i];
156             ++i;
157         }
158         return result;
159     }
160 
161     /** @dev concat bytes array */
162     function bytes32ArrayToString(bytes32[] data) internal pure returns (string) {
163         bytes memory bytesString = new bytes(data.length * 32);
164         uint urlLength;
165         for (uint i=0; i<data.length; i++) {
166             for (uint j=0; j<32; j++) {
167                 byte char = byte(bytes32(uint(data[i]) * 2 ** (8 * j)));
168                 if (char != 0) {
169                     bytesString[urlLength] = char;
170                     urlLength += 1;
171                 }
172             }
173         }
174         bytes memory bytesStringTrimmed = new bytes(urlLength);
175         for (i=0; i<urlLength; i++) {
176             bytesStringTrimmed[i] = bytesString[i];
177         }
178         return string(bytesStringTrimmed);
179     }
180 
181 
182     function uintToBytes(uint v) internal pure returns (bytes32 ret) {
183         if (v == 0) {
184             ret = '0';
185         }
186         else {
187             while (v > 0) {
188                 ret = bytes32(uint(ret) / (2 ** 8));
189                 ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
190                 v /= 10;
191             }
192         }
193         return ret;
194     }
195 
196     function addressToBytes(address a) internal pure returns (bytes32 b){
197        assembly {
198             let m := mload(0x40)
199             mstore(add(m, 20), xor(0x140000000000000000000000000000000000000000, a))
200             mstore(0x40, add(m, 52))
201             b := m
202        }
203     }
204 
205     function bytesToBytes32(bytes b, uint offset) internal pure returns (bytes32) {
206       bytes32 out;
207 
208       for (uint i = 0; i < 32; i++) {
209         out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);
210       }
211       return out;
212     }
213 
214     function bytes32ToString(bytes32 x) internal pure returns (string) {
215         bytes memory bytesString = new bytes(32);
216         uint charCount = 0;
217         for (uint j = 0; j < 32; j++) {
218             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
219             if (char != 0) {
220                 bytesString[charCount] = char;
221                 charCount++;
222             }
223         }
224         bytes memory bytesStringTrimmed = new bytes(charCount);
225         for (j = 0; j < charCount; j++) {
226             bytesStringTrimmed[j] = bytesString[j];
227         }
228         return string(bytesStringTrimmed);
229     }
230 }
231 
232 /** contract for deploy */
233 contract ClientsHandler is ManageableContract, Converter {
234 
235     function ClientsHandler() public {
236         setPFManager(owner);
237         setCRManager(owner);
238     }
239 
240     string name = "Clients Handler";
241     string descibe = "Clients data storage, contain methods for their obtaining and auditing";
242     string version = "0.29";
243 
244     // @dev defaul validtor values
245     uint256 dml = 3;
246     uint256 dmxl = 100;
247     uint256 tml = 3;
248     uint256 tmxl = 1000;
249 
250     struct DreamStructData {
251         string  hashId;
252         string  dream;
253         string  target;
254         bool    isDream;
255         bool    hasPerformer;
256         address performer;
257 
258     }
259 
260     struct DreamStruct {
261         bool      isClient;
262         uint256[] key;
263 
264     }
265 
266     mapping(address => mapping(uint256 => DreamStructData)) internal DSData;
267     mapping(address => DreamStruct) internal DStructs;
268     address[] public clientsList; //count users
269 
270     struct DreamStructDataP {
271         bool    isValid;
272         address client;
273         uint256 client_id;
274     }
275 
276     struct DreamStructP {
277         bool      isPerformer;
278         uint256[] key;
279     }
280 
281     mapping(address => mapping(uint256 => DreamStructDataP)) internal DSDataP;
282     mapping(address => DreamStructP) internal DStructsP;
283     address[] public performerList; //count users
284 
285     function watchPreferersTasks(address entityAddress, uint256 _id) public view {
286         DSDataP[entityAddress][_id];
287     }
288 
289     /** @dev return data of client's dream by id */
290     function getDStructData(address _who, uint256 _dream_id)
291         public
292         view
293         is_cli_or_trust
294         returns(string, string)
295     {
296         require(DSData[_who][_dream_id].isDream == true);
297         return (
298             DSData[_who][_dream_id].dream,
299             DSData[_who][_dream_id].target
300         );
301     }
302 
303     function isClient(address entityAddress) public constant returns(bool isIndeed) {
304         return DStructs[entityAddress].isClient;
305     }
306 
307     function countClients() public constant returns(uint256 cCount) {
308         return clientsList.length;
309     }
310 
311     function countAllCliDrm() public constant returns(uint256 acdCount) {
312         uint256 l = countClients();
313         uint256 r = 0;
314         for(uint256 i=0; i<l; i++) {
315             r += countCliDreams(clientsList[i]);
316         }
317         return r;
318     }
319 
320     function countCliDreams(address _addr) public view returns(uint256 cdCount) {
321         return DStructs[_addr].key.length;
322     }
323 
324     function countPerfClients(address _addr) public view returns(uint256 cdpCount) {
325         return DStructsP[_addr].key.length;
326     }
327 
328     function findAllCliWithPendingTask() public returns(address[] noPerform) {
329 
330         uint256 l = countClients();
331         address[] storage r;
332         for(uint256 i=0; i<l; i++) {
333             uint256 ll = countCliDreams(clientsList[i]);
334             for(uint256 ii=0; ii<ll; ii++) {
335                 uint256 li = ii + 1;
336                 if(DSData[clientsList[i]][li].hasPerformer == false) {
337                     r.push(clientsList[i]);
338                 }
339             }
340         }
341         return r;
342     }
343 
344     /** @dev by the address of client set performer for pending task */
345     function findCliPendTAndSetPrfm(address _addr, address _performer) public returns(uint256) {
346 
347         uint256 l = countCliDreams(_addr);
348         for(uint256 i=0; i<l; i++) {
349             uint256 li = i + 1;
350             if(DSData[_addr][li].hasPerformer == false) {
351                 DSData[_addr][li].hasPerformer = true;
352                 DSData[_addr][li].performer = _performer;
353 
354                 uint256 pLen = countPerfClients(_performer);
355                 uint256 iLen = pLen + 1;
356                 DSDataP[_performer][iLen].client = _addr;
357                 DSDataP[_performer][iLen].client_id = li;
358                 DSDataP[_performer][iLen].isValid = true;
359                 return performerList.push(_addr);
360             }
361         }
362     }
363 
364     /** @dev change perferfer for uncomplited task if he is fail */
365     function changePrefererForTask(address _addr, uint256 _id, address _performer) public is_pf_mng returns(bool) {
366         require(performers[_performer] == true);
367         if(DSData[_addr][_id].isDream == true) {
368             DSData[_addr][_id].hasPerformer = true;
369             DSData[_addr][_id].performer = _performer;
370             return true;
371         }
372     }
373 
374     function setValidatorForND(
375         uint256 dream_min_len,
376         uint256 target_min_len,
377         uint256 dream_max_len,
378         uint256 target_max_len
379     )
380         public
381         onlyOwner
382         returns (bool)
383     {
384         dml  = dream_min_len;
385         dmxl = dream_max_len;
386         tml  = target_min_len;
387         tmxl = target_max_len;
388         return true;
389     }
390 
391     modifier validatorD(string dream, string target) {
392         require(
393             (bytes(dream).length  >  dml)  &&
394             (bytes(dream).length  <= dmxl) &&
395             (bytes(target).length >  tml)  &&
396             (bytes(target).length <= tmxl)
397         );
398         _;
399     }
400 
401     /** @dev allow for all who want stand client */
402     function newDream(address entityAddress, string dream, string target)
403         public
404         validatorD(dream, target)
405         returns (uint256 rowNumber)
406     {
407         clients[entityAddress] = true;
408         DStructs[entityAddress].key.push(1);
409         DStructs[entityAddress].isClient = true;
410         uint256 cliLen = countCliDreams(entityAddress);
411         uint256 incLen = cliLen + 1;
412         DSData[entityAddress][incLen].dream = dream;
413         DSData[entityAddress][incLen].target = target;
414         DSData[entityAddress][incLen].isDream = true;
415         return clientsList.push(entityAddress);
416     }
417 
418     /** @dev allow for all who want stand client */
419     function updateDream(address entityAddress, string dream, string target)
420         public
421         is_cli_trust
422         validatorD(dream, target)
423         returns (bool success)
424     {
425         //DStructs[entityAddress].key.push(1);
426         uint256 cliLen = countCliDreams(entityAddress);
427         uint256 incLen = cliLen + 1;
428         DSData[entityAddress][incLen].dream = dream;
429         DSData[entityAddress][incLen].target = target;
430         DSData[entityAddress][incLen].isDream = true;
431         return true;
432     }
433 }