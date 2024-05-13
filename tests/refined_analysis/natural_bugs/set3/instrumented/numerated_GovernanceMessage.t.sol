1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 pragma experimental ABIEncoderV2;
4 
5 import "forge-std/Test.sol";
6 import {TypedMemView} from "@summa-tx/memview-sol/contracts/TypedMemView.sol";
7 import {GovernanceMessage} from "../governance/GovernanceMessage.sol";
8 
9 contract GovernanceMessageTest is Test {
10     using TypedMemView for bytes;
11     using TypedMemView for bytes29;
12     using GovernanceMessage for bytes29;
13 
14     function setUp() public {}
15 
16     function test_typesSetToCorrectOrder() public {
17         assertEq(uint256(GovernanceMessage.Types.Invalid), 0);
18         assertEq(uint256(GovernanceMessage.Types.Batch), 1);
19         assertEq(uint256(GovernanceMessage.Types.TransferGovernor), 2);
20     }
21 
22     // Check the type of the data from the type of the TypedMemView
23     // view
24     function test_messageTypeCorrectRead() public {
25         bytes memory data = "whatever";
26         assertEq(uint256(data.ref(0).messageType()), 0);
27         assertEq(uint256(data.ref(1).messageType()), 1);
28         assertEq(uint256(data.ref(2).messageType()), 2);
29     }
30 
31     // Check the type of the data from the first byte of the bytes
32     // array, not from the view
33     function test_identifierReadsFirstByte() public {
34         bytes memory data = hex"00";
35         assertEq(uint256(data.ref(0).identifier()), 0);
36         data = hex"01";
37         assertEq(uint256(data.ref(0).identifier()), 1);
38         data = hex"02";
39         assertEq(uint256(data.ref(0).identifier()), 2);
40     }
41 
42     function test_serializeCall() public {
43         bytes32 to = "0xBEEF";
44         bytes memory data = "random data";
45         GovernanceMessage.Call memory call = GovernanceMessage.Call(to, data);
46         bytes29 serializedCall = abi
47             .encodePacked(to, uint32(data.length), data)
48             .ref(0);
49         assertEq(
50             GovernanceMessage.serializeCall(call).keccak(),
51             serializedCall.keccak()
52         );
53     }
54 
55     function test_serializeCallFuzzed(bytes32 to, bytes memory data) public {
56         GovernanceMessage.Call memory call = GovernanceMessage.Call(to, data);
57         bytes29 serializedCall = abi
58             .encodePacked(to, uint32(data.length), data)
59             .ref(0);
60         assertEq(
61             GovernanceMessage.serializeCall(call).keccak(),
62             serializedCall.keccak()
63         );
64     }
65 
66     function test_formatBatchSingleCall() public {
67         bytes32 to = "0xBEEF";
68         bytes memory data = "random data";
69         GovernanceMessage.Call[] memory calls = new GovernanceMessage.Call[](1);
70         calls[0] = GovernanceMessage.Call(to, data);
71         assertEq(
72             GovernanceMessage.formatBatch(calls),
73             abi.encodePacked(
74                 GovernanceMessage.Types.Batch,
75                 GovernanceMessage.getBatchHash(calls)
76             )
77         );
78     }
79 
80     function test_formatBatchSingleCallFuzzed(bytes32 to, bytes memory data)
81         public
82     {
83         GovernanceMessage.Call[] memory calls = new GovernanceMessage.Call[](1);
84         calls[0] = GovernanceMessage.Call(to, data);
85         assertEq(
86             GovernanceMessage.formatBatch(calls),
87             abi.encodePacked(
88                 GovernanceMessage.Types.Batch,
89                 GovernanceMessage.getBatchHash(calls)
90             )
91         );
92     }
93 
94     function test_getBatchHash() public {
95         // we only have 1 call
96         bytes memory prefix = hex"01";
97         bytes32 to = "0xBEEF";
98         bytes memory data = "random data";
99         bytes memory serializedCall = abi.encodePacked(
100             to,
101             uint32(data.length),
102             data
103         );
104         bytes memory batch = abi.encodePacked(prefix, serializedCall);
105         bytes32 batchHash = keccak256(batch);
106         GovernanceMessage.Call[] memory calls = new GovernanceMessage.Call[](1);
107         calls[0] = GovernanceMessage.Call(to, data);
108         assertEq(GovernanceMessage.getBatchHash(calls), batchHash);
109     }
110 
111     function test_getBatchHashFuzzedIdenticalCalls(
112         bytes memory data,
113         bytes32 to,
114         uint8 numCalls
115     ) public {
116         vm.assume(numCalls > 0);
117         GovernanceMessage.Call[] memory calls = new GovernanceMessage.Call[](
118             numCalls
119         );
120         bytes memory serializedCall = abi.encodePacked(
121             to,
122             uint32(data.length),
123             data
124         );
125         bytes memory prefix = abi.encodePacked(numCalls);
126         bytes memory batch = prefix;
127         for (uint256 i = 0; i < numCalls; i++) {
128             calls[i] = GovernanceMessage.Call(to, data);
129             batch = abi.encodePacked(batch, serializedCall);
130         }
131         bytes32 batchHash = keccak256(batch);
132         assertEq(GovernanceMessage.getBatchHash(calls), batchHash);
133     }
134 
135     // storage array that persists between fuzzing test calls,
136     // allowing us to create a batch of many fuzzed calls
137     GovernanceMessage.Call[] diffCalls;
138 
139     function test_getBatchHashFuzzedDifferentCalls(
140         bytes[255] memory data,
141         bytes32[255] memory to
142     ) public {
143         // types(uint8).max = 255
144         bytes memory serializedCall;
145         bytes memory prefix = abi.encodePacked(uint8(255));
146         bytes memory batch = prefix;
147         for (uint256 i; i < data.length; i++) {
148             diffCalls.push(GovernanceMessage.Call(to[i], data[i]));
149             serializedCall = abi.encodePacked(
150                 to[i],
151                 uint32(data[i].length),
152                 data[i]
153             );
154             batch = abi.encodePacked(batch, serializedCall);
155         }
156         bytes32 batchHash = keccak256(batch);
157         assertEq(GovernanceMessage.getBatchHash(diffCalls), batchHash);
158     }
159 
160     function test_isValidBatchDetectBatch() public pure {
161         // batch type in the form of a uint8
162         bytes memory data = hex"01";
163         // Append an empty bytes array of 32 bytes
164         data = abi.encodePacked(data, new bytes(32));
165         assert(GovernanceMessage.isValidBatch(data.ref(0)));
166     }
167 
168     function test_isValidBatchDetectBatchFuzzed(bytes32 data) public pure {
169         bytes memory dataByte = abi.encodePacked(hex"01", data);
170         assert(GovernanceMessage.isValidBatch(dataByte.ref(0)));
171     }
172 
173     function test_isValidBatchWrongIdentifier() public {
174         // batch type in the form of a uint8
175         bytes memory data = hex"02";
176         // Append an empty bytes array of 32 bytes
177         data = abi.encodePacked(data, new bytes(32));
178         assertFalse(GovernanceMessage.isValidBatch(data.ref(0)));
179     }
180 
181     function test_isValidBatchWrongIdentifierFuzzed(uint8 viewType) public {
182         // batch type in the form of a uint8
183         // Append an empty bytes array of 32 bytes
184         bytes memory data = abi.encodePacked(
185             abi.encodePacked(viewType),
186             new bytes(32)
187         );
188         if (viewType == 1) {
189             assert(GovernanceMessage.isValidBatch(data.ref(0)));
190         } else {
191             assertFalse(GovernanceMessage.isValidBatch(data.ref(0)));
192         }
193     }
194 
195     function test_isValidBatchWrongIdentifierFuzzed(
196         uint8 viewType,
197         bytes32 data
198     ) public {
199         vm.assume(viewType != 1);
200         bytes memory dataByte = abi.encodePacked(
201             abi.encodePacked(viewType),
202             data
203         );
204         assertFalse(GovernanceMessage.isValidBatch(dataByte.ref(0)));
205     }
206 
207     function test_isValidBatchWrongLength() public {
208         // batch type in the form of a uint8
209         bytes memory data = hex"01";
210         // Append an empty bytes array of 23 bytes
211         data = abi.encodePacked(data, new bytes(23));
212         assertFalse(GovernanceMessage.isValidBatch(data.ref(0)));
213     }
214 
215     function test_isValidBatchWrongLengthFuzzed(bytes memory data) public {
216         vm.assume(data.length != 32);
217         data = abi.encodePacked(hex"01", data);
218         assertFalse(GovernanceMessage.isValidBatch(data.ref(0)));
219     }
220 
221     function test_isBatchDetectsViewType() public {
222         bytes memory data = hex"01";
223         // Append an empty bytes array of 32 bytes
224         data = abi.encodePacked(data, new bytes(32));
225         assert(GovernanceMessage.isBatch(data.ref(1)));
226         assertFalse(GovernanceMessage.isBatch(data.ref(2)));
227     }
228 
229     function test_isBatchDetectsViewTypeFuzzed(uint8 viewType, bytes32 data)
230         public
231     {
232         bytes memory prefix = abi.encodePacked(viewType);
233         // Append an empty bytes array of 32 bytes
234         bytes memory dataByte = abi.encodePacked(prefix, data);
235         if (viewType == 1) {
236             assert(GovernanceMessage.isBatch(dataByte.ref(viewType)));
237         } else {
238             assertFalse(GovernanceMessage.isBatch(dataByte.ref(viewType)));
239         }
240     }
241 
242     function test_isBatchDifferentViewTypeToPrefixFuzzed(
243         uint8 viewType,
244         bytes32 data
245     ) public {
246         vm.assume(viewType < 3);
247         // the prefix is different to the type of the view
248         bytes memory prefix = hex"01";
249         // Append an empty bytes array of 32 bytes
250         bytes memory dataByte = abi.encodePacked(prefix, data);
251         if (viewType == 1) {
252             assert(GovernanceMessage.isBatch(dataByte.ref(viewType)));
253         } else {
254             assertFalse(GovernanceMessage.isBatch(dataByte.ref(viewType)));
255         }
256     }
257 
258     function test_tryAsBatchForBatchReturnsBatch() public {
259         bytes memory data = hex"01";
260         // Appnend an empty bytes array of 32 bytes
261         data = abi.encodePacked(data, new bytes(32));
262         bytes29 dataView = data.ref(1);
263         // We compare both the type of the view and the contents of the memory location
264         // to where the view points
265         assertEq(uint256(dataView.tryAsBatch().typeOf()), 1);
266         assertEq(dataView.tryAsBatch().keccak(), dataView.keccak());
267         dataView = data.ref(34);
268         // even if instantiate the view with a differerent type, it can still
269         // be cast to a Batch type (1)
270         assertEq(uint256(dataView.tryAsBatch().typeOf()), 1);
271         assertEq(dataView.tryAsBatch().keccak(), dataView.keccak());
272     }
273 
274     function test_tryAsBatchForBatchReturnsBatchFuzzed(uint40 viewType) public {
275         bytes memory data = hex"01";
276         // Append an empty bytes array of 32 bytes
277         data = abi.encodePacked(data, new bytes(32));
278         bytes29 dataView = data.ref(viewType);
279         // We compare both the type of the view and the contents of the memory location
280         // to where the view points
281         assertEq(uint256(dataView.tryAsBatch().typeOf()), 1);
282         assertEq(dataView.tryAsBatch().keccak(), dataView.keccak());
283     }
284 
285     function test_tryAsBatchForNonBatchReturnsNull() public {
286         // not a batch
287         bytes memory data = hex"03";
288         // Append an empty bytes array of 32 bytes
289         data = abi.encodePacked(data, new bytes(32));
290         bytes29 dataView = data.ref(1);
291         assertEq(dataView.tryAsBatch(), TypedMemView.nullView());
292     }
293 
294     function test_batchHashSingleCall() public {
295         bytes32 to = "0xBEEF";
296         bytes memory data = "random data";
297         GovernanceMessage.Call[] memory calls = new GovernanceMessage.Call[](1);
298         calls[0] = GovernanceMessage.Call(to, data);
299         assertEq(
300             // format Batch, instantiate view, get batchHash of that view
301             GovernanceMessage.formatBatch(calls).ref(0).batchHash(),
302             // get batch hash of the calls
303             GovernanceMessage.getBatchHash(calls)
304         );
305     }
306 
307     function test_formatTransferGovernor() public {
308         uint32 domain = 123;
309         bytes32 governor = "all hail to the new governor";
310         bytes memory data = abi.encodePacked(uint8(2), domain, governor);
311         assertEq(
312             data,
313             GovernanceMessage.formatTransferGovernor(domain, governor)
314         );
315     }
316 
317     function test_formatTransferGovernorFuzzed(uint32 domain, bytes32 governor)
318         public
319     {
320         bytes memory data = abi.encodePacked(uint8(2), domain, governor);
321         assertEq(
322             data,
323             GovernanceMessage.formatTransferGovernor(domain, governor)
324         );
325     }
326 
327     function test_isValidTransferGovernorSuccess() public pure {
328         uint32 domain = 123;
329         bytes32 governor = "all hail to the new governor";
330         bytes memory data = abi.encodePacked(uint8(2), domain, governor);
331         // it doesn't check the type of the view
332         assert(GovernanceMessage.isValidTransferGovernor(data.ref(0)));
333     }
334 
335     function test_isValidTrasnferGovernorWrongType() public {
336         uint32 domain = 123;
337         bytes32 governor = "all hail to the new governor";
338         bytes memory data = abi.encodePacked(uint8(0), domain, governor);
339         // it doesn't check the type of the view
340         assertFalse(GovernanceMessage.isValidTransferGovernor(data.ref(0)));
341         data = abi.encodePacked(uint8(1), domain, governor);
342         // it doesn't check the type of the view
343         assertFalse(GovernanceMessage.isValidTransferGovernor(data.ref(0)));
344     }
345 
346     function test_isValidTrasnferGovernorWrongLength() public {
347         uint96 domain = 123;
348         bytes32 governor = "all hail to the new governor";
349         bytes memory data = abi.encodePacked(uint8(0), domain, governor);
350         // it doesn't check the type of the view
351         assertFalse(GovernanceMessage.isValidTransferGovernor(data.ref(0)));
352     }
353 
354     function test_isValidTransferGovernorFuzzed(
355         uint8 messageType,
356         uint32 domain,
357         bytes32 governor
358     ) public {
359         bytes memory data = abi.encodePacked(messageType, domain, governor);
360         // it doesn't check the type of the view
361         if (messageType == 2) {
362             assert(GovernanceMessage.isValidTransferGovernor(data.ref(0)));
363         } else {
364             assertFalse(GovernanceMessage.isValidTransferGovernor(data.ref(0)));
365         }
366     }
367 
368     function test_isTransferGovernorVerifyCorrectTypeAndForm() public {
369         uint32 domain = 123;
370         bytes32 governor = "all hail to the new governor";
371         bytes memory data = abi.encodePacked(uint8(2), domain, governor);
372         // it doesn't check the type of the view
373         assert(GovernanceMessage.isTransferGovernor(data.ref(2)));
374         assertFalse(GovernanceMessage.isTransferGovernor(data.ref(0)));
375     }
376 
377     function test_isTransferGovernorVerifyCorrectTypeAndFormFuzzed(
378         uint32 domain,
379         bytes32 governor,
380         uint8 viewType
381     ) public {
382         bytes memory data = abi.encodePacked(viewType, domain, governor);
383         // it doesn't check the type of the view
384         if (viewType == 2) {
385             assert(GovernanceMessage.isTransferGovernor(data.ref(viewType)));
386         } else {
387             assertFalse(
388                 GovernanceMessage.isTransferGovernor(data.ref(viewType))
389             );
390         }
391     }
392 
393     function test_tryAsTransferGovernorCorrectPrefix() public {
394         uint32 domain = 123;
395         bytes32 governor = "all hail to the new governor";
396         bytes memory data = abi.encodePacked(uint8(2), domain, governor);
397         assertEq(
398             uint256(
399                 GovernanceMessage.tryAsTransferGovernor(data.ref(0)).typeOf()
400             ),
401             2
402         );
403     }
404 
405     function test_tryAsTransferGovernorWrongPrefix() public {
406         uint32 domain = 123;
407         bytes32 governor = "all hail to the new governor";
408         bytes memory data = abi.encodePacked(uint8(1), domain, governor);
409         assertEq(
410             GovernanceMessage.tryAsTransferGovernor(data.ref(0)),
411             TypedMemView.nullView()
412         );
413     }
414 
415     function test_tryAsTransferGovernorCorrectPrefixFuzzed(
416         uint32 domain,
417         bytes32 governor,
418         uint40 viewType
419     ) public {
420         bytes memory data = abi.encodePacked(uint8(2), domain, governor);
421         assertEq(
422             uint256(
423                 GovernanceMessage
424                     .tryAsTransferGovernor(data.ref(viewType))
425                     .typeOf()
426             ),
427             2
428         );
429     }
430 
431     function test_mustBeTransferGovernorSuccess() public {
432         uint32 domain = 123;
433         bytes32 governor = "all hail to the new governor";
434         bytes memory data = abi.encodePacked(uint8(2), domain, governor);
435         assertEq(
436             GovernanceMessage.mustBeTransferGovernor(data.ref(0)),
437             data.ref(2)
438         );
439     }
440 
441     function test_mustBeTransferGovernorSuccessFuzzed(
442         uint32 domain,
443         bytes32 governor
444     ) public {
445         bytes memory data = abi.encodePacked(uint8(2), domain, governor);
446         assertEq(
447             GovernanceMessage.mustBeTransferGovernor(data.ref(0)),
448             data.ref(2)
449         );
450     }
451 
452     function test_mustBeTransferGovernorRevert() public {
453         uint32 domain = 123;
454         bytes32 governor = "all hail to the new governor";
455         bytes memory data = abi.encodePacked(uint8(234), domain, governor);
456         vm.expectRevert("Validity assertion failed");
457         GovernanceMessage.mustBeTransferGovernor(data.ref(0));
458     }
459 
460     function test_mustBeTransferGovernorRevertFuzzed(
461         uint32 domain,
462         bytes32 governor,
463         uint8 viewType
464     ) public {
465         vm.assume(viewType != 2);
466         bytes memory data = abi.encodePacked(viewType, domain, governor);
467         vm.expectRevert("Validity assertion failed");
468         GovernanceMessage.mustBeTransferGovernor(data.ref(0));
469     }
470 
471     function test_extractGovernorMessageDetails() public {
472         uint32 domain = 123;
473         bytes32 governor = "all hail to the new governor";
474         bytes memory data = abi.encodePacked(uint8(234), domain, governor);
475         assertEq(uint256(data.ref(0).domain()), domain);
476         assertEq(data.ref(0).governor(), governor);
477     }
478 
479     function test_extractGovernorMessageDetailsFuzzed(
480         bytes32 governor,
481         uint32 domain,
482         uint8 viewType
483     ) public {
484         bytes memory data = abi.encodePacked(viewType, domain, governor);
485         assertEq(uint256(data.ref(0).domain()), domain);
486         assertEq(data.ref(0).governor(), governor);
487     }
488 }
