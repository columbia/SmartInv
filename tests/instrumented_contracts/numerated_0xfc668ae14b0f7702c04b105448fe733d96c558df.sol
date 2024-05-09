1 pragma solidity ^0.4.8;
2 
3 //solc --bin --abi --optimize  --optimize-runs 20000 -o . Testpool.sol 
4 
5 contract SHA3_512 {
6     function SHA3_512() {}
7     
8     function keccak_f(uint[25] A) constant internal returns(uint[25]) {
9         uint[5] memory C;
10         uint[5] memory D;
11         uint x;
12         uint y;
13         //uint D_0; uint D_1; uint D_2; uint D_3; uint D_4;
14         uint[25] memory B;
15         
16         uint[24] memory RC= [
17                    uint(0x0000000000000001),
18                    0x0000000000008082,
19                    0x800000000000808A,
20                    0x8000000080008000,
21                    0x000000000000808B,
22                    0x0000000080000001,
23                    0x8000000080008081,
24                    0x8000000000008009,
25                    0x000000000000008A,
26                    0x0000000000000088,
27                    0x0000000080008009,
28                    0x000000008000000A,
29                    0x000000008000808B,
30                    0x800000000000008B,
31                    0x8000000000008089,
32                    0x8000000000008003,
33                    0x8000000000008002,
34                    0x8000000000000080,
35                    0x000000000000800A,
36                    0x800000008000000A,
37                    0x8000000080008081,
38                    0x8000000000008080,
39                    0x0000000080000001,
40                    0x8000000080008008 ];
41         
42         for( uint i = 0 ; i < 24 ; i++ ) {
43             /*
44             for( x = 0 ; x < 5 ; x++ ) {
45                 C[x] = A[5*x]^A[5*x+1]^A[5*x+2]^A[5*x+3]^A[5*x+4];                
46             }*/
47                        
48             C[0]=A[0]^A[1]^A[2]^A[3]^A[4];
49             C[1]=A[5]^A[6]^A[7]^A[8]^A[9];
50             C[2]=A[10]^A[11]^A[12]^A[13]^A[14];
51             C[3]=A[15]^A[16]^A[17]^A[18]^A[19];
52             C[4]=A[20]^A[21]^A[22]^A[23]^A[24];
53 
54             /*
55             for( x = 0 ; x < 5 ; x++ ) {
56                 D[x] = C[(x+4)%5]^((C[(x+1)%5] * 2)&0xffffffffffffffff | (C[(x+1)%5]/(2**63)));
57             }*/
58                         
59             
60             D[0]=C[4] ^ ((C[1] * 2)&0xffffffffffffffff | (C[1] / (2 ** 63)));
61             D[1]=C[0] ^ ((C[2] * 2)&0xffffffffffffffff | (C[2] / (2 ** 63)));
62             D[2]=C[1] ^ ((C[3] * 2)&0xffffffffffffffff | (C[3] / (2 ** 63)));
63             D[3]=C[2] ^ ((C[4] * 2)&0xffffffffffffffff | (C[4] / (2 ** 63)));
64             D[4]=C[3] ^ ((C[0] * 2)&0xffffffffffffffff | (C[0] / (2 ** 63)));
65 
66             /*
67             for( x = 0 ; x < 5 ; x++ ) {
68                 for( y = 0 ; y < 5 ; y++ ) {
69                     A[5*x+y] = A[5*x+y] ^ D[x];
70                 }            
71             }*/
72             
73 
74             
75             A[0]=A[0] ^ D[0];
76             A[1]=A[1] ^ D[0];
77             A[2]=A[2] ^ D[0];
78             A[3]=A[3] ^ D[0];
79             A[4]=A[4] ^ D[0];
80             A[5]=A[5] ^ D[1];
81             A[6]=A[6] ^ D[1];
82             A[7]=A[7] ^ D[1];
83             A[8]=A[8] ^ D[1];
84             A[9]=A[9] ^ D[1];
85             A[10]=A[10] ^ D[2];
86             A[11]=A[11] ^ D[2];
87             A[12]=A[12] ^ D[2];
88             A[13]=A[13] ^ D[2];
89             A[14]=A[14] ^ D[2];
90             A[15]=A[15] ^ D[3];
91             A[16]=A[16] ^ D[3];
92             A[17]=A[17] ^ D[3];
93             A[18]=A[18] ^ D[3];
94             A[19]=A[19] ^ D[3];
95             A[20]=A[20] ^ D[4];
96             A[21]=A[21] ^ D[4];
97             A[22]=A[22] ^ D[4];
98             A[23]=A[23] ^ D[4];
99             A[24]=A[24] ^ D[4];
100 
101             /*Rho and pi steps*/            
102             B[0]=A[0];
103             B[8]=((A[1] * (2 ** 36))&0xffffffffffffffff | (A[1] / (2 ** 28)));
104             B[11]=((A[2] * (2 ** 3))&0xffffffffffffffff | (A[2] / (2 ** 61)));
105             B[19]=((A[3] * (2 ** 41))&0xffffffffffffffff | (A[3] / (2 ** 23)));
106             B[22]=((A[4] * (2 ** 18))&0xffffffffffffffff | (A[4] / (2 ** 46)));
107             B[2]=((A[5] * (2 ** 1))&0xffffffffffffffff | (A[5] / (2 ** 63)));
108             B[5]=((A[6] * (2 ** 44))&0xffffffffffffffff | (A[6] / (2 ** 20)));
109             B[13]=((A[7] * (2 ** 10))&0xffffffffffffffff | (A[7] / (2 ** 54)));
110             B[16]=((A[8] * (2 ** 45))&0xffffffffffffffff | (A[8] / (2 ** 19)));
111             B[24]=((A[9] * (2 ** 2))&0xffffffffffffffff | (A[9] / (2 ** 62)));
112             B[4]=((A[10] * (2 ** 62))&0xffffffffffffffff | (A[10] / (2 ** 2)));
113             B[7]=((A[11] * (2 ** 6))&0xffffffffffffffff | (A[11] / (2 ** 58)));
114             B[10]=((A[12] * (2 ** 43))&0xffffffffffffffff | (A[12] / (2 ** 21)));
115             B[18]=((A[13] * (2 ** 15))&0xffffffffffffffff | (A[13] / (2 ** 49)));
116             B[21]=((A[14] * (2 ** 61))&0xffffffffffffffff | (A[14] / (2 ** 3)));
117             B[1]=((A[15] * (2 ** 28))&0xffffffffffffffff | (A[15] / (2 ** 36)));
118             B[9]=((A[16] * (2 ** 55))&0xffffffffffffffff | (A[16] / (2 ** 9)));
119             B[12]=((A[17] * (2 ** 25))&0xffffffffffffffff | (A[17] / (2 ** 39)));
120             B[15]=((A[18] * (2 ** 21))&0xffffffffffffffff | (A[18] / (2 ** 43)));
121             B[23]=((A[19] * (2 ** 56))&0xffffffffffffffff | (A[19] / (2 ** 8)));
122             B[3]=((A[20] * (2 ** 27))&0xffffffffffffffff | (A[20] / (2 ** 37)));
123             B[6]=((A[21] * (2 ** 20))&0xffffffffffffffff | (A[21] / (2 ** 44)));
124             B[14]=((A[22] * (2 ** 39))&0xffffffffffffffff | (A[22] / (2 ** 25)));
125             B[17]=((A[23] * (2 ** 8))&0xffffffffffffffff | (A[23] / (2 ** 56)));
126             B[20]=((A[24] * (2 ** 14))&0xffffffffffffffff | (A[24] / (2 ** 50)));
127 
128             /*Xi state*/
129             /*
130             for( x = 0 ; x < 5 ; x++ ) {
131                 for( y = 0 ; y < 5 ; y++ ) {
132                     A[5*x+y] = B[5*x+y]^((~B[5*((x+1)%5)+y]) & B[5*((x+2)%5)+y]);
133                 }
134             }*/
135             
136             
137             A[0]=B[0]^((~B[5]) & B[10]);
138             A[1]=B[1]^((~B[6]) & B[11]);
139             A[2]=B[2]^((~B[7]) & B[12]);
140             A[3]=B[3]^((~B[8]) & B[13]);
141             A[4]=B[4]^((~B[9]) & B[14]);
142             A[5]=B[5]^((~B[10]) & B[15]);
143             A[6]=B[6]^((~B[11]) & B[16]);
144             A[7]=B[7]^((~B[12]) & B[17]);
145             A[8]=B[8]^((~B[13]) & B[18]);
146             A[9]=B[9]^((~B[14]) & B[19]);
147             A[10]=B[10]^((~B[15]) & B[20]);
148             A[11]=B[11]^((~B[16]) & B[21]);
149             A[12]=B[12]^((~B[17]) & B[22]);
150             A[13]=B[13]^((~B[18]) & B[23]);
151             A[14]=B[14]^((~B[19]) & B[24]);
152             A[15]=B[15]^((~B[20]) & B[0]);
153             A[16]=B[16]^((~B[21]) & B[1]);
154             A[17]=B[17]^((~B[22]) & B[2]);
155             A[18]=B[18]^((~B[23]) & B[3]);
156             A[19]=B[19]^((~B[24]) & B[4]);
157             A[20]=B[20]^((~B[0]) & B[5]);
158             A[21]=B[21]^((~B[1]) & B[6]);
159             A[22]=B[22]^((~B[2]) & B[7]);
160             A[23]=B[23]^((~B[3]) & B[8]);
161             A[24]=B[24]^((~B[4]) & B[9]);
162 
163             /*Last step*/
164             A[0]=A[0]^RC[i];            
165         }
166 
167         
168         return A;
169     }
170  
171     
172     function sponge(uint[9] M) constant internal returns(uint[16]) {
173         if( (M.length * 8) != 72 ) throw;
174         M[5] = 0x01;
175         M[8] = 0x8000000000000000;
176         
177         uint r = 72;
178         uint w = 8;
179         uint size = M.length * 8;
180         
181         uint[25] memory S;
182         uint i; uint y; uint x;
183         /*Absorbing Phase*/
184         for( i = 0 ; i < size/r ; i++ ) {
185             for( y = 0 ; y < 5 ; y++ ) {
186                 for( x = 0 ; x < 5 ; x++ ) {
187                     if( (x+5*y) < (r/w) ) {
188                         S[5*x+y] = S[5*x+y] ^ M[i*9 + x + 5*y];
189                     }
190                 }
191             }
192             S = keccak_f(S);
193         }
194 
195         /*Squeezing phase*/
196         uint[16] memory result;
197         uint b = 0;
198         while( b < 16 ) {
199             for( y = 0 ; y < 5 ; y++ ) {
200                 for( x = 0 ; x < 5 ; x++ ) {
201                     if( (x+5*y)<(r/w) && (b<16) ) {
202                         result[b] = S[5*x+y] & 0xFFFFFFFF; 
203                         result[b+1] = S[5*x+y] / 0x100000000;
204                         b+=2;
205                     }
206                 }
207             }
208         }
209          
210         return result;
211    }
212 
213 }
214 
215 ////////////////////////////////////////////////////////////////////////////////
216 
217 contract Ethash is SHA3_512 {
218     
219     mapping(address=>bool) public owners;
220     
221     function Ethash(address[3] _owners) {
222         owners[_owners[0]] = true;
223         owners[_owners[1]] = true;
224         owners[_owners[2]] = true;                
225     }
226      
227     function fnv( uint v1, uint v2 ) constant internal returns(uint) {
228         return ((v1*0x01000193) ^ v2) & 0xFFFFFFFF;
229     }
230 
231 
232 
233     function computeCacheRoot( uint index,
234                                uint indexInElementsArray,
235                                uint[] elements,
236                                uint[] witness,
237                                uint branchSize ) constant private returns(uint) {
238  
239                        
240         uint leaf = computeLeaf(elements, indexInElementsArray) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
241 
242         uint left;
243         uint right;
244         uint node;
245         bool oddBranchSize = (branchSize % 2) > 0;
246          
247         assembly {
248             branchSize := div(branchSize,2)
249             //branchSize /= 2;
250         }
251         uint witnessIndex = indexInElementsArray * branchSize;
252         if( oddBranchSize ) witnessIndex += indexInElementsArray;  
253 
254         for( uint depth = 0 ; depth < branchSize ; depth++ ) {
255             assembly {
256                 node := mload(add(add(witness,0x20),mul(add(depth,witnessIndex),0x20)))
257             }
258             //node  = witness[witnessIndex + depth] & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
259             if( index & 0x1 == 0 ) {
260                 left = leaf;
261                 assembly{
262                     //right = node & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;                
263                     right := and(node,0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
264                 }
265                 
266             }
267             else {
268                 assembly{
269                     //left = node & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
270                     left := and(node,0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
271                 }
272                 right = leaf;
273             }
274             
275             leaf = uint(sha3(left,right)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
276             assembly {
277                 index := div(index,2) 
278             }
279             //index = index / 2;
280 
281             //node  = witness[witnessIndex + depth] / (2**128);
282             if( index & 0x1 == 0 ) {
283                 left = leaf;
284                 assembly{
285                     right := div(node,0x100000000000000000000000000000000)
286                     //right = node / 0x100000000000000000000000000000000;
287                 }
288             }
289             else {
290                 assembly {
291                     //left = node / 0x100000000000000000000000000000000;
292                     left := div(node,0x100000000000000000000000000000000)
293                 }
294                 right = leaf;
295             }
296             
297             leaf = uint(sha3(left,right)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
298             assembly {
299                 index := div(index,2) 
300             }
301             //index = index / 2;
302         }
303         
304         if( oddBranchSize ) {
305             assembly {
306                 node := mload(add(add(witness,0x20),mul(add(depth,witnessIndex),0x20)))
307             }
308         
309             //node  = witness[witnessIndex + depth] & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
310             if( index & 0x1 == 0 ) {
311                 left = leaf;
312                 assembly{
313                     //right = node & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;                
314                     right := and(node,0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
315                 }                
316             }
317             else {
318                 assembly{
319                     //left = node & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;                
320                     left := and(node,0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
321                 }
322             
323                 right = leaf;
324             }
325             
326             leaf = uint(sha3(left,right)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;        
327         }
328         
329         
330         return leaf;
331     }
332 
333     
334     function toBE( uint x ) constant internal returns(uint) {
335         uint y = 0;
336         for( uint i = 0 ; i < 32 ; i++ ) {
337             y = y * 256;
338             y += (x & 0xFF);
339             x = x / 256;            
340         }
341         
342         return y;
343         
344     }
345     
346     function computeSha3( uint[16] s, uint[8] cmix ) constant internal returns(uint) {
347         uint s0 = s[0] + s[1] * (2**32) + s[2] * (2**64) + s[3] * (2**96) +
348                   (s[4] + s[5] * (2**32) + s[6] * (2**64) + s[7] * (2**96))*(2**128);
349 
350         uint s1 = s[8] + s[9] * (2**32) + s[10] * (2**64) + s[11] * (2**96) +
351                   (s[12] + s[13] * (2**32) + s[14] * (2**64) + s[15] * (2**96))*(2**128);
352                   
353         uint c = cmix[0] + cmix[1] * (2**32) + cmix[2] * (2**64) + cmix[3] * (2**96) +
354                   (cmix[4] + cmix[5] * (2**32) + cmix[6] * (2**64) + cmix[7] * (2**96))*(2**128);
355 
356         
357         /* god knows why need to convert to big endian */
358         return uint( sha3(toBE(s0),toBE(s1),toBE(c)) );
359     }
360  
361  
362     function computeLeaf( uint[] dataSetLookup, uint index ) constant internal returns(uint) {
363         return uint( sha3(dataSetLookup[4*index],
364                           dataSetLookup[4*index + 1],
365                           dataSetLookup[4*index + 2],
366                           dataSetLookup[4*index + 3]) );
367                                     
368     }
369  
370     function computeS( uint header, uint nonceLe ) constant internal returns(uint[16]) {
371         uint[9]  memory M;
372         
373         header = reverseBytes(header);
374         
375         M[0] = uint(header) & 0xFFFFFFFFFFFFFFFF;
376         header = header / 2**64;
377         M[1] = uint(header) & 0xFFFFFFFFFFFFFFFF;
378         header = header / 2**64;
379         M[2] = uint(header) & 0xFFFFFFFFFFFFFFFF;
380         header = header / 2**64;
381         M[3] = uint(header) & 0xFFFFFFFFFFFFFFFF;
382 
383         // make little endian nonce
384         M[4] = nonceLe;
385         return sponge(M);
386     }
387     
388     function reverseBytes( uint input ) constant internal returns(uint) {
389         uint result = 0;
390         for(uint i = 0 ; i < 32 ; i++ ) {
391             result = result * 256;
392             result += input & 0xff;
393             
394             input /= 256;
395         }
396         
397         return result;
398     }
399     
400     struct EthashCacheOptData {
401         uint[512]    merkleNodes;
402         uint         fullSizeIn128Resultion;
403         uint         branchDepth;
404     }
405     
406     mapping(uint=>EthashCacheOptData) epochData;
407     
408     function getEpochData( uint epochIndex, uint nodeIndex ) constant returns(uint[3]) {
409         return [epochData[epochIndex].merkleNodes[nodeIndex],
410                 epochData[epochIndex].fullSizeIn128Resultion,
411                 epochData[epochIndex].branchDepth];
412     }
413     
414     function isEpochDataSet( uint epochIndex ) constant returns(bool) {
415         return epochData[epochIndex].fullSizeIn128Resultion != 0;
416     
417     }
418         
419     event SetEpochData( address indexed sender, uint error, uint errorInfo );    
420     function setEpochData( uint epoch,
421                            uint fullSizeIn128Resultion,
422                            uint branchDepth,
423                            uint[] merkleNodes,
424                            uint start,
425                            uint numElems ) {
426 
427         if( ! owners[msg.sender] ) {
428             //ErrorLog( "setEpochData: only owner can set data", uint(msg.sender) );
429             SetEpochData( msg.sender, 0x82000000, uint(msg.sender) );
430             return;        
431         }                           
432                            
433         for( uint i = 0 ; i < numElems ; i++ ) {
434             if( epochData[epoch].merkleNodes[start+i] > 0 ) {
435                 //ErrorLog("epoch already set", epoch[i]);
436                 SetEpochData( msg.sender, 0x82000001, epoch * (2**128) + start + i );
437                 return;            
438 
439             } 
440             epochData[epoch].merkleNodes[start+i] = merkleNodes[i];
441         }
442         epochData[epoch].fullSizeIn128Resultion = fullSizeIn128Resultion;
443         epochData[epoch].branchDepth = branchDepth;
444         
445         SetEpochData( msg.sender, 0 , 0 );        
446     }
447 
448     function getMerkleLeave( uint epochIndex, uint p ) constant internal returns(uint) {        
449         uint rootIndex = p >> epochData[epochIndex].branchDepth;
450         uint expectedRoot = epochData[epochIndex].merkleNodes[(rootIndex/2)];
451         if( (rootIndex % 2) == 0 ) expectedRoot = expectedRoot & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
452         else expectedRoot = expectedRoot / (2**128);
453         
454         return expectedRoot;
455     }
456 
457 
458     function hashimoto( bytes32      header,
459                         bytes8       nonceLe,
460                         uint[]       dataSetLookup,
461                         uint[]       witnessForLookup,
462                         uint         epochIndex ) constant returns(uint) {
463          
464         uint[16] memory s;
465         uint[32] memory mix;
466         uint[8]  memory cmix;
467         
468         uint[2]  memory depthAndFullSize = [epochData[epochIndex].branchDepth, 
469                                             epochData[epochIndex].fullSizeIn128Resultion];
470                 
471         uint i;
472         uint j;
473         
474         if( ! isEpochDataSet( epochIndex ) ) return 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE;
475         
476         if( depthAndFullSize[1] == 0 ) {
477             return 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
478         }
479 
480         
481         s = computeS(uint(header), uint(nonceLe));
482         for( i = 0 ; i < 16 ; i++ ) {            
483             assembly {
484                 let offset := mul(i,0x20)
485                 
486                 //mix[i] = s[i];
487                 mstore(add(mix,offset),mload(add(s,offset)))
488                 
489                 // mix[i+16] = s[i];
490                 mstore(add(mix,add(0x200,offset)),mload(add(s,offset)))    
491             }
492         }
493 
494         for( i = 0 ; i < 64 ; i++ ) {
495             uint p = fnv( i ^ s[0], mix[i % 32]) % depthAndFullSize[1];
496             
497             
498             if( computeCacheRoot( p, i, dataSetLookup,  witnessForLookup, depthAndFullSize[0] )  != getMerkleLeave( epochIndex, p ) ) {
499             
500                 // PoW failed
501                 return 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
502             }       
503 
504             for( j = 0 ; j < 8 ; j++ ) {
505 
506                 assembly{
507                     //mix[j] = fnv(mix[j], dataSetLookup[4*i] & varFFFFFFFF );
508                     let dataOffset := add(mul(0x80,i),add(dataSetLookup,0x20))
509                     let dataValue   := and(mload(dataOffset),0xFFFFFFFF)
510                     
511                     let mixOffset := add(mix,mul(0x20,j))
512                     let mixValue  := mload(mixOffset)
513                     
514                     // fnv = return ((v1*0x01000193) ^ v2) & 0xFFFFFFFF;
515                     let fnvValue := and(xor(mul(mixValue,0x01000193),dataValue),0xFFFFFFFF)                    
516                     mstore(mixOffset,fnvValue)
517                     
518                     //mix[j+8] = fnv(mix[j+8], dataSetLookup[4*i + 1] & 0xFFFFFFFF );
519                     dataOffset := add(dataOffset,0x20)
520                     dataValue   := and(mload(dataOffset),0xFFFFFFFF)
521                     
522                     mixOffset := add(mixOffset,0x100)
523                     mixValue  := mload(mixOffset)
524                     
525                     // fnv = return ((v1*0x01000193) ^ v2) & 0xFFFFFFFF;
526                     fnvValue := and(xor(mul(mixValue,0x01000193),dataValue),0xFFFFFFFF)                    
527                     mstore(mixOffset,fnvValue)
528 
529                     //mix[j+16] = fnv(mix[j+16], dataSetLookup[4*i + 2] & 0xFFFFFFFF );
530                     dataOffset := add(dataOffset,0x20)
531                     dataValue   := and(mload(dataOffset),0xFFFFFFFF)
532                     
533                     mixOffset := add(mixOffset,0x100)
534                     mixValue  := mload(mixOffset)
535                     
536                     // fnv = return ((v1*0x01000193) ^ v2) & 0xFFFFFFFF;
537                     fnvValue := and(xor(mul(mixValue,0x01000193),dataValue),0xFFFFFFFF)                    
538                     mstore(mixOffset,fnvValue)
539 
540                     //mix[j+24] = fnv(mix[j+24], dataSetLookup[4*i + 3] & 0xFFFFFFFF );
541                     dataOffset := add(dataOffset,0x20)
542                     dataValue   := and(mload(dataOffset),0xFFFFFFFF)
543                     
544                     mixOffset := add(mixOffset,0x100)
545                     mixValue  := mload(mixOffset)
546                     
547                     // fnv = return ((v1*0x01000193) ^ v2) & 0xFFFFFFFF;
548                     fnvValue := and(xor(mul(mixValue,0x01000193),dataValue),0xFFFFFFFF)                    
549                     mstore(mixOffset,fnvValue)                    
550                                         
551                 }
552 
553                 
554                 //mix[j] = fnv(mix[j], dataSetLookup[4*i] & 0xFFFFFFFF );
555                 //mix[j+8] = fnv(mix[j+8], dataSetLookup[4*i + 1] & 0xFFFFFFFF );
556                 //mix[j+16] = fnv(mix[j+16], dataSetLookup[4*i + 2] & 0xFFFFFFFF );                
557                 //mix[j+24] = fnv(mix[j+24], dataSetLookup[4*i + 3] & 0xFFFFFFFF );
558                 
559                 
560                 //dataSetLookup[4*i    ] = dataSetLookup[4*i    ]/(2**32);
561                 //dataSetLookup[4*i + 1] = dataSetLookup[4*i + 1]/(2**32);
562                 //dataSetLookup[4*i + 2] = dataSetLookup[4*i + 2]/(2**32);
563                 //dataSetLookup[4*i + 3] = dataSetLookup[4*i + 3]/(2**32);                
564                 
565                 assembly{
566                     let offset := add(add(dataSetLookup,0x20),mul(i,0x80))
567                     let value  := div(mload(offset),0x100000000)
568                     mstore(offset,value)
569                                        
570                     offset := add(offset,0x20)
571                     value  := div(mload(offset),0x100000000)
572                     mstore(offset,value)
573                     
574                     offset := add(offset,0x20)
575                     value  := div(mload(offset),0x100000000)
576                     mstore(offset,value)                    
577                     
578                     offset := add(offset,0x20)
579                     value  := div(mload(offset),0x100000000)
580                     mstore(offset,value)                                                                                
581                 }                
582             }
583         }
584         
585         
586         for( i = 0 ; i < 32 ; i += 4) {
587             cmix[i/4] = (fnv(fnv(fnv(mix[i], mix[i+1]), mix[i+2]), mix[i+3]));
588         }
589         
590 
591         uint result = computeSha3(s,cmix); 
592 
593         return result;
594         
595     }
596 }
597 
598 /**
599 * @title RLPReader
600 *
601 * RLPReader is used to read and parse RLP encoded data in memory.
602 *
603 * @author Andreas Olofsson (androlo1980@gmail.com)
604 */
605 library RLP {
606 
607  uint constant DATA_SHORT_START = 0x80;
608  uint constant DATA_LONG_START = 0xB8;
609  uint constant LIST_SHORT_START = 0xC0;
610  uint constant LIST_LONG_START = 0xF8;
611 
612  uint constant DATA_LONG_OFFSET = 0xB7;
613  uint constant LIST_LONG_OFFSET = 0xF7;
614 
615 
616  struct RLPItem {
617      uint _unsafe_memPtr;    // Pointer to the RLP-encoded bytes.
618      uint _unsafe_length;    // Number of bytes. This is the full length of the string.
619  }
620 
621  struct Iterator {
622      RLPItem _unsafe_item;   // Item that's being iterated over.
623      uint _unsafe_nextPtr;   // Position of the next item in the list.
624  }
625 
626  /* Iterator */
627 
628  function next(Iterator memory self) internal constant returns (RLPItem memory subItem) {
629      if(hasNext(self)) {
630          var ptr = self._unsafe_nextPtr;
631          var itemLength = _itemLength(ptr);
632          subItem._unsafe_memPtr = ptr;
633          subItem._unsafe_length = itemLength;
634          self._unsafe_nextPtr = ptr + itemLength;
635      }
636      else
637          throw;
638  }
639 
640  function next(Iterator memory self, bool strict) internal constant returns (RLPItem memory subItem) {
641      subItem = next(self);
642      if(strict && !_validate(subItem))
643          throw;
644      return;
645  }
646 
647  function hasNext(Iterator memory self) internal constant returns (bool) {
648      var item = self._unsafe_item;
649      return self._unsafe_nextPtr < item._unsafe_memPtr + item._unsafe_length;
650  }
651 
652  /* RLPItem */
653 
654  /// @dev Creates an RLPItem from an array of RLP encoded bytes.
655  /// @param self The RLP encoded bytes.
656  /// @return An RLPItem
657  function toRLPItem(bytes memory self) internal constant returns (RLPItem memory) {
658      uint len = self.length;
659      if (len == 0) {
660          return RLPItem(0, 0);
661      }
662      uint memPtr;
663      assembly {
664          memPtr := add(self, 0x20)
665      }
666      return RLPItem(memPtr, len);
667  }
668 
669  /// @dev Creates an RLPItem from an array of RLP encoded bytes.
670  /// @param self The RLP encoded bytes.
671  /// @param strict Will throw if the data is not RLP encoded.
672  /// @return An RLPItem
673  function toRLPItem(bytes memory self, bool strict) internal constant returns (RLPItem memory) {
674      var item = toRLPItem(self);
675      if(strict) {
676          uint len = self.length;
677          if(_payloadOffset(item) > len)
678              throw;
679          if(_itemLength(item._unsafe_memPtr) != len)
680              throw;
681          if(!_validate(item))
682              throw;
683      }
684      return item;
685  }
686 
687  /// @dev Check if the RLP item is null.
688  /// @param self The RLP item.
689  /// @return 'true' if the item is null.
690  function isNull(RLPItem memory self) internal constant returns (bool ret) {
691      return self._unsafe_length == 0;
692  }
693 
694  /// @dev Check if the RLP item is a list.
695  /// @param self The RLP item.
696  /// @return 'true' if the item is a list.
697  function isList(RLPItem memory self) internal constant returns (bool ret) {
698      if (self._unsafe_length == 0)
699          return false;
700      uint memPtr = self._unsafe_memPtr;
701      assembly {
702          ret := iszero(lt(byte(0, mload(memPtr)), 0xC0))
703      }
704  }
705 
706  /// @dev Check if the RLP item is data.
707  /// @param self The RLP item.
708  /// @return 'true' if the item is data.
709  function isData(RLPItem memory self) internal constant returns (bool ret) {
710      if (self._unsafe_length == 0)
711          return false;
712      uint memPtr = self._unsafe_memPtr;
713      assembly {
714          ret := lt(byte(0, mload(memPtr)), 0xC0)
715      }
716  }
717 
718  /// @dev Check if the RLP item is empty (string or list).
719  /// @param self The RLP item.
720  /// @return 'true' if the item is null.
721  function isEmpty(RLPItem memory self) internal constant returns (bool ret) {
722      if(isNull(self))
723          return false;
724      uint b0;
725      uint memPtr = self._unsafe_memPtr;
726      assembly {
727          b0 := byte(0, mload(memPtr))
728      }
729      return (b0 == DATA_SHORT_START || b0 == LIST_SHORT_START);
730  }
731 
732  /// @dev Get the number of items in an RLP encoded list.
733  /// @param self The RLP item.
734  /// @return The number of items.
735  function items(RLPItem memory self) internal constant returns (uint) {
736      if (!isList(self))
737          return 0;
738      uint b0;
739      uint memPtr = self._unsafe_memPtr;
740      assembly {
741          b0 := byte(0, mload(memPtr))
742      }
743      uint pos = memPtr + _payloadOffset(self);
744      uint last = memPtr + self._unsafe_length - 1;
745      uint itms;
746      while(pos <= last) {
747          pos += _itemLength(pos);
748          itms++;
749      }
750      return itms;
751  }
752 
753  /// @dev Create an iterator.
754  /// @param self The RLP item.
755  /// @return An 'Iterator' over the item.
756  function iterator(RLPItem memory self) internal constant returns (Iterator memory it) {
757      if (!isList(self))
758          throw;
759      uint ptr = self._unsafe_memPtr + _payloadOffset(self);
760      it._unsafe_item = self;
761      it._unsafe_nextPtr = ptr;
762  }
763 
764  /// @dev Return the RLP encoded bytes.
765  /// @param self The RLPItem.
766  /// @return The bytes.
767  function toBytes(RLPItem memory self) internal constant returns (bytes memory bts) {
768      var len = self._unsafe_length;
769      if (len == 0)
770          return;
771      bts = new bytes(len);
772      _copyToBytes(self._unsafe_memPtr, bts, len);
773  }
774 
775  /// @dev Decode an RLPItem into bytes. This will not work if the
776  /// RLPItem is a list.
777  /// @param self The RLPItem.
778  /// @return The decoded string.
779  function toData(RLPItem memory self) internal constant returns (bytes memory bts) {
780      if(!isData(self))
781          throw;
782      var (rStartPos, len) = _decode(self);
783      bts = new bytes(len);
784      _copyToBytes(rStartPos, bts, len);
785  }
786 
787  /// @dev Get the list of sub-items from an RLP encoded list.
788  /// Warning: This is inefficient, as it requires that the list is read twice.
789  /// @param self The RLP item.
790  /// @return Array of RLPItems.
791  function toList(RLPItem memory self) internal constant returns (RLPItem[] memory list) {
792      if(!isList(self))
793          throw;
794      var numItems = items(self);
795      list = new RLPItem[](numItems);
796      var it = iterator(self);
797      uint idx;
798      while(hasNext(it)) {
799          list[idx] = next(it);
800          idx++;
801      }
802  }
803 
804  /// @dev Decode an RLPItem into an ascii string. This will not work if the
805  /// RLPItem is a list.
806  /// @param self The RLPItem.
807  /// @return The decoded string.
808  function toAscii(RLPItem memory self) internal constant returns (string memory str) {
809      if(!isData(self))
810          throw;
811      var (rStartPos, len) = _decode(self);
812      bytes memory bts = new bytes(len);
813      _copyToBytes(rStartPos, bts, len);
814      str = string(bts);
815  }
816 
817  /// @dev Decode an RLPItem into a uint. This will not work if the
818  /// RLPItem is a list.
819  /// @param self The RLPItem.
820  /// @return The decoded string.
821  function toUint(RLPItem memory self) internal constant returns (uint data) {
822      if(!isData(self))
823          throw;
824      var (rStartPos, len) = _decode(self);
825      if (len > 32 || len == 0)
826          throw;
827      assembly {
828          data := div(mload(rStartPos), exp(256, sub(32, len)))
829      }
830  }
831 
832  /// @dev Decode an RLPItem into a boolean. This will not work if the
833  /// RLPItem is a list.
834  /// @param self The RLPItem.
835  /// @return The decoded string.
836  function toBool(RLPItem memory self) internal constant returns (bool data) {
837      if(!isData(self))
838          throw;
839      var (rStartPos, len) = _decode(self);
840      if (len != 1)
841          throw;
842      uint temp;
843      assembly {
844          temp := byte(0, mload(rStartPos))
845      }
846      if (temp > 1)
847          throw;
848      return temp == 1 ? true : false;
849  }
850 
851  /// @dev Decode an RLPItem into a byte. This will not work if the
852  /// RLPItem is a list.
853  /// @param self The RLPItem.
854  /// @return The decoded string.
855  function toByte(RLPItem memory self) internal constant returns (byte data) {
856      if(!isData(self))
857          throw;
858      var (rStartPos, len) = _decode(self);
859      if (len != 1)
860          throw;
861      uint temp;
862      assembly {
863          temp := byte(0, mload(rStartPos))
864      }
865      return byte(temp);
866  }
867 
868  /// @dev Decode an RLPItem into an int. This will not work if the
869  /// RLPItem is a list.
870  /// @param self The RLPItem.
871  /// @return The decoded string.
872  function toInt(RLPItem memory self) internal constant returns (int data) {
873      return int(toUint(self));
874  }
875 
876  /// @dev Decode an RLPItem into a bytes32. This will not work if the
877  /// RLPItem is a list.
878  /// @param self The RLPItem.
879  /// @return The decoded string.
880  function toBytes32(RLPItem memory self) internal constant returns (bytes32 data) {
881      return bytes32(toUint(self));
882  }
883 
884  /// @dev Decode an RLPItem into an address. This will not work if the
885  /// RLPItem is a list.
886  /// @param self The RLPItem.
887  /// @return The decoded string.
888  function toAddress(RLPItem memory self) internal constant returns (address data) {
889      if(!isData(self))
890          throw;
891      var (rStartPos, len) = _decode(self);
892      if (len != 20)
893          throw;
894      assembly {
895          data := div(mload(rStartPos), exp(256, 12))
896      }
897  }
898 
899  // Get the payload offset.
900  function _payloadOffset(RLPItem memory self) private constant returns (uint) {
901      if(self._unsafe_length == 0)
902          return 0;
903      uint b0;
904      uint memPtr = self._unsafe_memPtr;
905      assembly {
906          b0 := byte(0, mload(memPtr))
907      }
908      if(b0 < DATA_SHORT_START)
909          return 0;
910      if(b0 < DATA_LONG_START || (b0 >= LIST_SHORT_START && b0 < LIST_LONG_START))
911          return 1;
912      if(b0 < LIST_SHORT_START)
913          return b0 - DATA_LONG_OFFSET + 1;
914      return b0 - LIST_LONG_OFFSET + 1;
915  }
916 
917  // Get the full length of an RLP item.
918  function _itemLength(uint memPtr) private constant returns (uint len) {
919      uint b0;
920      assembly {
921          b0 := byte(0, mload(memPtr))
922      }
923      if (b0 < DATA_SHORT_START)
924          len = 1;
925      else if (b0 < DATA_LONG_START)
926          len = b0 - DATA_SHORT_START + 1;
927      else if (b0 < LIST_SHORT_START) {
928          assembly {
929              let bLen := sub(b0, 0xB7) // bytes length (DATA_LONG_OFFSET)
930              let dLen := div(mload(add(memPtr, 1)), exp(256, sub(32, bLen))) // data length
931              len := add(1, add(bLen, dLen)) // total length
932          }
933      }
934      else if (b0 < LIST_LONG_START)
935          len = b0 - LIST_SHORT_START + 1;
936      else {
937          assembly {
938              let bLen := sub(b0, 0xF7) // bytes length (LIST_LONG_OFFSET)
939              let dLen := div(mload(add(memPtr, 1)), exp(256, sub(32, bLen))) // data length
940              len := add(1, add(bLen, dLen)) // total length
941          }
942      }
943  }
944 
945  // Get start position and length of the data.
946  function _decode(RLPItem memory self) private constant returns (uint memPtr, uint len) {
947      if(!isData(self))
948          throw;
949      uint b0;
950      uint start = self._unsafe_memPtr;
951      assembly {
952          b0 := byte(0, mload(start))
953      }
954      if (b0 < DATA_SHORT_START) {
955          memPtr = start;
956          len = 1;
957          return;
958      }
959      if (b0 < DATA_LONG_START) {
960          len = self._unsafe_length - 1;
961          memPtr = start + 1;
962      } else {
963          uint bLen;
964          assembly {
965              bLen := sub(b0, 0xB7) // DATA_LONG_OFFSET
966          }
967          len = self._unsafe_length - 1 - bLen;
968          memPtr = start + bLen + 1;
969      }
970      return;
971  }
972 
973  // Assumes that enough memory has been allocated to store in target.
974  function _copyToBytes(uint btsPtr, bytes memory tgt, uint btsLen) private constant {
975      // Exploiting the fact that 'tgt' was the last thing to be allocated,
976      // we can write entire words, and just overwrite any excess.
977      assembly {
978          {
979                  let i := 0 // Start at arr + 0x20
980                  let words := div(add(btsLen, 31), 32)
981                  let rOffset := btsPtr
982                  let wOffset := add(tgt, 0x20)
983              tag_loop:
984                  jumpi(end, eq(i, words))
985                  {
986                      let offset := mul(i, 0x20)
987                      mstore(add(wOffset, offset), mload(add(rOffset, offset)))
988                      i := add(i, 1)
989                  }
990                  jump(tag_loop)
991              end:
992                  mstore(add(tgt, add(0x20, mload(tgt))), 0)
993          }
994      }
995  }
996 
997      // Check that an RLP item is valid.
998      function _validate(RLPItem memory self) private constant returns (bool ret) {
999          // Check that RLP is well-formed.
1000          uint b0;
1001          uint b1;
1002          uint memPtr = self._unsafe_memPtr;
1003          assembly {
1004              b0 := byte(0, mload(memPtr))
1005              b1 := byte(1, mload(memPtr))
1006          }
1007          if(b0 == DATA_SHORT_START + 1 && b1 < DATA_SHORT_START)
1008              return false;
1009          return true;
1010      }
1011 }
1012 
1013 
1014 
1015 
1016 contract Agt {
1017     using RLP for RLP.RLPItem;
1018     using RLP for RLP.Iterator;
1019     using RLP for bytes;
1020  
1021     struct BlockHeader {
1022         uint       prevBlockHash; // 0
1023         uint       coinbase;      // 1
1024         uint       blockNumber;   // 8
1025         //uint       gasUsed;       // 10
1026         uint       timestamp;     // 11
1027         bytes32    extraData;     // 12
1028     }
1029  
1030     function Agt() {}
1031      
1032     function parseBlockHeader( bytes rlpHeader ) constant internal returns(BlockHeader) {
1033         BlockHeader memory header;
1034         
1035         var it = rlpHeader.toRLPItem().iterator();        
1036         uint idx;
1037         while(it.hasNext()) {
1038             if( idx == 0 ) header.prevBlockHash = it.next().toUint();
1039             else if ( idx == 2 ) header.coinbase = it.next().toUint();
1040             else if ( idx == 8 ) header.blockNumber = it.next().toUint();
1041             else if ( idx == 11 ) header.timestamp = it.next().toUint();
1042             else if ( idx == 12 ) header.extraData = bytes32(it.next().toUint());
1043             else it.next();
1044             
1045             idx++;
1046         }
1047  
1048         return header;        
1049     }
1050             
1051     //event VerifyAgt( string msg, uint index );
1052     event VerifyAgt( uint error, uint index );    
1053     
1054     struct VerifyAgtData {
1055         uint rootHash;
1056         uint rootMin;
1057         uint rootMax;
1058         
1059         uint leafHash;
1060         uint leafCounter;        
1061     }
1062 
1063     function verifyAgt( VerifyAgtData data,
1064                         uint   branchIndex,
1065                         uint[] countersBranch,
1066                         uint[] hashesBranch ) constant internal returns(bool) {
1067                         
1068         uint currentHash = data.leafHash & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1069         
1070         uint leftCounterMin;
1071         uint leftCounterMax;        
1072         uint leftHash;
1073         
1074         uint rightCounterMin;
1075         uint rightCounterMax;        
1076         uint rightHash;
1077         
1078         uint min = data.leafCounter;
1079         uint max = data.leafCounter;
1080         
1081         for( uint i = 0 ; i < countersBranch.length ; i++ ) {
1082             if( branchIndex & 0x1 > 0 ) {
1083                 leftCounterMin = countersBranch[i] & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1084                 leftCounterMax = countersBranch[i] >> 128;                
1085                 leftHash    = hashesBranch[i];
1086                 
1087                 rightCounterMin = min;
1088                 rightCounterMax = max;
1089                 rightHash    = currentHash;                
1090             }
1091             else {                
1092                 leftCounterMin = min;
1093                 leftCounterMax = max;
1094                 leftHash    = currentHash;
1095                 
1096                 rightCounterMin = countersBranch[i] & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1097                 rightCounterMax = countersBranch[i] >> 128;                
1098                 rightHash    = hashesBranch[i];                                            
1099             }
1100             
1101             currentHash = uint(sha3(leftCounterMin + (leftCounterMax << 128),
1102                                     leftHash,
1103                                     rightCounterMin + (rightCounterMax << 128),
1104                                     rightHash)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1105             
1106             if( (leftCounterMin >= leftCounterMax) || (rightCounterMin >= rightCounterMax) ) {
1107                 if( i > 0 ) {
1108                     //VerifyAgt( "counters mismatch",i);
1109                     VerifyAgt( 0x80000000, i );
1110                     return false;
1111                 }
1112                 if( leftCounterMin > leftCounterMax ) {
1113                     //VerifyAgt( "counters mismatch",i);
1114                     VerifyAgt( 0x80000001, i );                
1115                     return false;
1116                 }
1117                 if( rightCounterMin > rightCounterMax ) {
1118                     //VerifyAgt( "counters mismatch",i);
1119                     VerifyAgt( 0x80000002, i );                
1120                     return false;
1121                 }                
1122             }
1123             
1124             if( leftCounterMax >= rightCounterMin ) {
1125                 VerifyAgt( 0x80000009, i );            
1126                 return false;
1127             }
1128 
1129             min = leftCounterMin;
1130             max = rightCounterMax;
1131             
1132             branchIndex = branchIndex / 2;
1133         }
1134 
1135         if( min != data.rootMin ) {
1136             //VerifyAgt( "min does not match root min",min);
1137             VerifyAgt( 0x80000003, min );                        
1138             return false;
1139         }
1140         if( max != data.rootMax ) {
1141             //VerifyAgt( "max does not match root max",max);
1142             VerifyAgt( 0x80000004, max );                    
1143             return false;
1144         }
1145         
1146         if( currentHash != data.rootHash ) {
1147             //VerifyAgt( "hash does not match root hash",currentHash);        
1148             VerifyAgt( 0x80000005, currentHash );
1149             return false;
1150         }
1151         
1152         return true;
1153     }
1154     
1155     function verifyAgtDebugForTesting( uint rootHash,
1156                                        uint rootMin,
1157                                        uint rootMax,
1158                                        uint leafHash,
1159                                        uint leafCounter,
1160                                        uint branchIndex,
1161                                        uint[] countersBranch,
1162                                        uint[] hashesBranch ) returns(bool) {
1163                                        
1164         VerifyAgtData memory data;
1165         data.rootHash = rootHash;
1166         data.rootMin = rootMin;
1167         data.rootMax = rootMax;
1168         data.leafHash = leafHash;
1169         data.leafCounter = leafCounter;
1170         
1171         return verifyAgt( data, branchIndex, countersBranch, hashesBranch );
1172     }         
1173 }
1174 
1175 contract WeightedSubmission {
1176     function WeightedSubmission(){}
1177     
1178     struct SingleSubmissionData {
1179         uint128 numShares;
1180         uint128 submissionValue;
1181         uint128 totalPreviousSubmissionValue;
1182         uint128 min;
1183         uint128 max;
1184         uint128 augRoot;
1185     }
1186     
1187     struct SubmissionMetaData {
1188         uint64  numPendingSubmissions;
1189         uint32  readyForVerification; // suppose to be bool
1190         uint32  lastSubmissionBlockNumber;
1191         uint128 totalSubmissionValue;
1192         uint128 difficulty;
1193         uint128 lastCounter;
1194         
1195         uint    submissionSeed;
1196         
1197     }
1198     
1199     mapping(address=>SubmissionMetaData) submissionsMetaData;
1200     
1201     // (user, submission number)=>data
1202     mapping(address=>mapping(uint=>SingleSubmissionData)) submissionsData;
1203     
1204     event SubmitClaim( address indexed sender, uint error, uint errorInfo );
1205     function submitClaim( uint numShares, uint difficulty, uint min, uint max, uint augRoot, bool lastClaimBeforeVerification ) {
1206         SubmissionMetaData memory metaData = submissionsMetaData[msg.sender];
1207         
1208         if( metaData.lastCounter >= min ) {
1209             // miner cheated. min counter is too low
1210             SubmitClaim( msg.sender, 0x81000001, metaData.lastCounter ); 
1211             return;        
1212         }
1213         
1214         if( metaData.readyForVerification > 0 ) {
1215             // miner cheated - should go verification first
1216             SubmitClaim( msg.sender, 0x81000002, 0 ); 
1217             return;
1218         }
1219         
1220         if( metaData.numPendingSubmissions > 0 ) {
1221             if( metaData.difficulty != difficulty ) {
1222                 // could not change difficulty before verification
1223                 SubmitClaim( msg.sender, 0x81000003, metaData.difficulty ); 
1224                 return;            
1225             }
1226         }
1227         
1228         SingleSubmissionData memory submissionData;
1229         
1230         submissionData.numShares = uint64(numShares);
1231         uint blockDifficulty;
1232         if( block.difficulty == 0 ) {
1233             // testrpc - fake increasing difficulty
1234             blockDifficulty = (900000000 * (metaData.numPendingSubmissions+1)); 
1235         }
1236         else {
1237             blockDifficulty = block.difficulty;
1238         }
1239         
1240         submissionData.submissionValue = uint128((uint(numShares * difficulty) * (5 ether)) / blockDifficulty);
1241         
1242         submissionData.totalPreviousSubmissionValue = metaData.totalSubmissionValue;
1243         submissionData.min = uint128(min);
1244         submissionData.max = uint128(max);
1245         submissionData.augRoot = uint128(augRoot);
1246         
1247         (submissionsData[msg.sender])[metaData.numPendingSubmissions] = submissionData;
1248         
1249         // update meta data
1250         metaData.numPendingSubmissions++;
1251         metaData.lastSubmissionBlockNumber = uint32(block.number);
1252         metaData.difficulty = uint128(difficulty);
1253         metaData.lastCounter = uint128(max);
1254         metaData.readyForVerification = lastClaimBeforeVerification ? uint32(1) : uint32(0);
1255 
1256         uint128 temp128;
1257         
1258         
1259         temp128 = metaData.totalSubmissionValue; 
1260 
1261         metaData.totalSubmissionValue += submissionData.submissionValue;
1262         
1263         if( temp128 > metaData.totalSubmissionValue ) {
1264             // overflow in calculation
1265             // note that this code is reachable if user is dishonest and give false
1266             // report on his submission. but even without
1267             // this validation, user cannot benifit from the overflow
1268             SubmitClaim( msg.sender, 0x81000005, 0 ); 
1269             return;                                
1270         }
1271                 
1272         
1273         submissionsMetaData[msg.sender] = metaData;
1274         
1275         // everything is ok
1276         SubmitClaim( msg.sender, 0, numShares * difficulty );
1277     }
1278 
1279     function getClaimSeed(address sender) constant returns(uint){
1280         SubmissionMetaData memory metaData = submissionsMetaData[sender];
1281         if( metaData.readyForVerification == 0 ) return 0;
1282         
1283         if( metaData.submissionSeed != 0 ) return metaData.submissionSeed; 
1284         
1285         uint lastBlockNumber = uint(metaData.lastSubmissionBlockNumber);
1286         
1287         if( block.number > lastBlockNumber + 200 ) return 0;
1288         if( block.number <= lastBlockNumber + 15 ) return 0;
1289                 
1290         return uint(block.blockhash(lastBlockNumber + 10));
1291     }
1292     
1293     event StoreClaimSeed( address indexed sender, uint error, uint errorInfo );
1294     function storeClaimSeed( address miner ) {
1295         // anyone who is willing to pay gas fees can call this function
1296         uint seed = getClaimSeed( miner );
1297         if( seed != 0 ) {
1298             submissionsMetaData[miner].submissionSeed = seed;
1299             StoreClaimSeed( msg.sender, 0, uint(miner) );
1300             return;
1301         }
1302         
1303         // else
1304         SubmissionMetaData memory metaData = submissionsMetaData[miner];
1305         uint lastBlockNumber = uint(metaData.lastSubmissionBlockNumber);
1306                 
1307         if( metaData.readyForVerification == 0 ) {
1308             // submission is not ready for verification
1309             StoreClaimSeed( msg.sender, 0x8000000, uint(miner) );
1310         }
1311         else if( block.number > lastBlockNumber + 200 ) {
1312             // submission is not ready for verification
1313             StoreClaimSeed( msg.sender, 0x8000001, uint(miner) );
1314         }
1315         else if( block.number <= lastBlockNumber + 15 ) {
1316             // it is too late to call store function
1317             StoreClaimSeed( msg.sender, 0x8000002, uint(miner) );
1318         }
1319         else {
1320             // unknown error
1321             StoreClaimSeed( msg.sender, 0x8000003, uint(miner) );
1322         }
1323     }
1324 
1325     function verifySubmissionIndex( address sender, uint seed, uint submissionNumber, uint shareIndex ) constant returns(bool) {
1326         if( seed == 0 ) return false;
1327     
1328         uint totalValue = uint(submissionsMetaData[sender].totalSubmissionValue);
1329         uint numPendingSubmissions = uint(submissionsMetaData[sender].numPendingSubmissions);
1330 
1331         SingleSubmissionData memory submissionData = (submissionsData[sender])[submissionNumber];        
1332         
1333         if( submissionNumber >= numPendingSubmissions ) return false;
1334         
1335         uint seed1 = seed & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1336         uint seed2 = seed / (2**128);
1337         
1338         uint selectedValue = seed1 % totalValue;
1339         if( uint(submissionData.totalPreviousSubmissionValue) >= selectedValue ) return false;
1340         if( uint(submissionData.totalPreviousSubmissionValue + submissionData.submissionValue) < selectedValue ) return false;  
1341 
1342         uint expectedShareshareIndex = (seed2 % uint(submissionData.numShares));
1343         if( expectedShareshareIndex != shareIndex ) return false;
1344         
1345         return true;
1346     }
1347     
1348     function calculateSubmissionIndex( address sender, uint seed ) constant returns(uint[2]) {
1349         // this function should be executed off chain - hene, it is not optimized
1350         uint seed1 = seed & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1351         uint seed2 = seed / (2**128);
1352 
1353         uint totalValue = uint(submissionsMetaData[sender].totalSubmissionValue);
1354         uint numPendingSubmissions = uint(submissionsMetaData[sender].numPendingSubmissions);
1355 
1356         uint selectedValue = seed1 % totalValue;
1357         
1358         SingleSubmissionData memory submissionData;        
1359         
1360         for( uint submissionInd = 0 ; submissionInd < numPendingSubmissions ; submissionInd++ ) {
1361             submissionData = (submissionsData[sender])[submissionInd];        
1362             if( uint(submissionData.totalPreviousSubmissionValue + submissionData.submissionValue) >= selectedValue ) break;  
1363         }
1364         
1365         // unexpected error
1366         if( submissionInd == numPendingSubmissions ) return [uint(0xFFFFFFFFFFFFFFFF),0xFFFFFFFFFFFFFFFF];
1367 
1368         uint shareIndex = seed2 % uint(submissionData.numShares); 
1369         
1370         return [submissionInd, shareIndex];
1371     }
1372     
1373     // should be called only from verify claim
1374     function closeSubmission( address sender ) internal {
1375         SubmissionMetaData memory metaData = submissionsMetaData[sender];
1376         metaData.numPendingSubmissions = 0;
1377         metaData.totalSubmissionValue = 0;
1378         metaData.readyForVerification = 0;
1379         metaData.submissionSeed = 0;
1380         
1381         // last counter must not be reset
1382         // last submission block number and difficulty are also kept, but it is not a must
1383         // only to save some gas        
1384         
1385         submissionsMetaData[sender] = metaData;
1386     }
1387     
1388     struct SubmissionDataForClaimVerification {
1389         uint lastCounter;
1390         uint shareDifficulty;
1391         uint totalSubmissionValue;
1392         uint min;
1393         uint max;
1394         uint augMerkle;
1395         
1396         bool indicesAreValid;
1397         bool readyForVerification;
1398     }
1399     
1400     function getClaimData( address sender, uint submissionIndex, uint shareIndex, uint seed )
1401                            constant internal returns(SubmissionDataForClaimVerification){
1402                            
1403         SubmissionDataForClaimVerification memory output;
1404 
1405         SubmissionMetaData memory metaData = submissionsMetaData[sender];
1406         
1407         output.lastCounter = uint(metaData.lastCounter);
1408         output.shareDifficulty = uint(metaData.difficulty);
1409         output.totalSubmissionValue = metaData.totalSubmissionValue;
1410         
1411 
1412         SingleSubmissionData memory submissionData = (submissionsData[sender])[submissionIndex];
1413         
1414         output.min = uint(submissionData.min);
1415         output.max = uint(submissionData.max);
1416         output.augMerkle = uint(submissionData.augRoot);
1417         
1418         output.indicesAreValid = verifySubmissionIndex( sender, seed, submissionIndex, shareIndex );
1419         output.readyForVerification = (metaData.readyForVerification > 0);
1420         
1421         return output; 
1422     }
1423     
1424     function debugGetNumPendingSubmissions( address sender ) constant returns(uint) {
1425         return uint(submissionsMetaData[sender].numPendingSubmissions);
1426     }
1427     
1428     event DebugResetSubmissions( address indexed sender, uint error, uint errorInfo );
1429     function debugResetSubmissions( ) {
1430         // should be called only in emergency
1431         // msg.sender will loose all its pending shares
1432         closeSubmission(msg.sender);
1433         DebugResetSubmissions( msg.sender, 0, 0 );
1434     }    
1435 }
1436 
1437 
1438 contract SmartPool is Agt, WeightedSubmission {    
1439     string  public version = "0.1.1";
1440     
1441     Ethash  public ethashContract; 
1442     address public withdrawalAddress;
1443     mapping(address=>bool) public owners; 
1444     
1445     bool public newVersionReleased = false;
1446         
1447     struct MinerData {
1448         bytes32        minerId;
1449         address        paymentAddress;
1450     }
1451 
1452     mapping(address=>MinerData) minersData;
1453     mapping(bytes32=>bool)      public existingIds;        
1454     
1455     bool public whiteListEnabled;
1456     bool public blackListEnabled;
1457     mapping(address=>bool) whiteList;
1458     mapping(address=>bool) blackList;    
1459     
1460     function SmartPool( address[] _owners,
1461                         Ethash _ethashContract,
1462                         address _withdrawalAddress,
1463                         bool _whiteListEnabeled,
1464                         bool _blackListEnabled ) payable {
1465                         
1466         for( uint i = 0 ; i < _owners.length ; i++ ) {
1467             owners[_owners[0]] = true; 
1468             owners[_owners[1]] = true;
1469             owners[_owners[2]] = true;
1470         }
1471         
1472         ethashContract = _ethashContract;
1473         withdrawalAddress = _withdrawalAddress;
1474         
1475         whiteListEnabled = _whiteListEnabeled;
1476         blackListEnabled = _blackListEnabled;               
1477     }
1478     
1479     function declareNewerVersion() {
1480         if( ! owners[msg.sender] ) throw;
1481         
1482         newVersionReleased = true;
1483         
1484         //if( ! msg.sender.send(this.balance) ) throw;
1485     }
1486     
1487     event Withdraw( address indexed sender, uint error, uint errorInfo );
1488     function withdraw( uint amount ) {
1489         if( ! owners[msg.sender] ) {
1490             // only ownder can withdraw
1491             Withdraw( msg.sender, 0x80000000, amount );
1492             return;
1493         }
1494         
1495         if( ! withdrawalAddress.send( amount ) ) throw;
1496         
1497         Withdraw( msg.sender, 0, amount );            
1498     }
1499     
1500     function to62Encoding( uint id, uint numChars ) constant returns(bytes32) {
1501         if( id >= (26+26+10)**numChars ) throw;
1502         uint result = 0;
1503         for( uint i = 0 ; i < numChars ; i++ ) {
1504             uint b = id % (26+26+10);
1505             uint8 char;
1506             if( b < 10 ) {
1507                 char = uint8(b + 0x30); // 0x30 = '0' 
1508             }
1509             else if( b < 26 + 10 ) {
1510                 char = uint8(b + 0x61 - 10); //0x61 = 'a'
1511             }
1512             else {
1513                 char = uint8(b + 0x41 - 26 - 10); // 0x41 = 'A'         
1514             }
1515             
1516             result = (result * 256) + char;
1517             id /= (26+26+10);
1518         }
1519 
1520         return bytes32(result);
1521     }
1522         
1523     event Register( address indexed sender, uint error, uint errorInfo );    
1524     function register( address paymentAddress ) {
1525         address minerAddress = msg.sender;
1526         
1527         // build id
1528         uint id = uint(minerAddress) % (26+26+10)**11;        
1529         bytes32 minerId = to62Encoding(id,11);
1530         
1531         if( existingIds[minersData[minerAddress].minerId] ) {
1532             // miner id is already in use
1533             Register( msg.sender, 0x80000000, uint(minerId) ); 
1534             return;
1535         }
1536         
1537         if( paymentAddress == address(0) ) {
1538             // payment address is 0
1539             Register( msg.sender, 0x80000001, uint(paymentAddress) ); 
1540             return;
1541         }
1542         
1543         if( whiteListEnabled ) {
1544             if( ! whiteList[ msg.sender ] ) {
1545                 // miner not in white list
1546                 Register( msg.sender, 0x80000002, uint(minerId) );
1547                 return;                 
1548             }
1549         }
1550         
1551         if( blackListEnabled ) {
1552             if( blackList[ msg.sender ] ) {
1553                 // miner on black list
1554                 Register( msg.sender, 0x80000003, uint(minerId) );
1555                 return;                 
1556             }        
1557         }
1558         
1559         
1560         
1561         // last counter is set to 0. 
1562         // It might be safer to change it to now.
1563         //minersData[minerAddress].lastCounter = now * (2**64);
1564         minersData[minerAddress].paymentAddress = paymentAddress;        
1565         minersData[minerAddress].minerId = minerId;
1566         existingIds[minersData[minerAddress].minerId] = true;
1567         
1568         // succesful registration
1569         Register( msg.sender, 0, 0 ); 
1570     }
1571 
1572     function canRegister(address sender) constant returns(bool) {
1573         uint id = uint(sender) % (26+26+10)**11;
1574         bytes32 expectedId = to62Encoding(id,11);
1575         
1576         if( whiteListEnabled ) {
1577             if( ! whiteList[ sender ] ) return false; 
1578         }
1579         if( blackListEnabled ) {
1580             if( blackList[ sender ] ) return false;        
1581         }
1582         
1583         return ! existingIds[expectedId];
1584     }
1585     
1586     function isRegistered(address sender) constant returns(bool) {
1587         return minersData[sender].paymentAddress != address(0);
1588     }
1589     
1590     function getMinerId(address sender) constant returns(bytes32) {
1591         return minersData[sender].minerId;
1592     }
1593 
1594     event UpdateWhiteList( address indexed miner, uint error, uint errorInfo, bool add );
1595     event UpdateBlackList( address indexed miner, uint error, uint errorInfo, bool add );    
1596 
1597     function unRegister( address miner ) internal {
1598         minersData[miner].paymentAddress = address(0);
1599         existingIds[minersData[miner].minerId] = false;            
1600     }
1601     
1602     function updateWhiteList( address miner, bool add ) {
1603         if( ! owners[ msg.sender ] ) {
1604             // only owner can update list
1605             UpdateWhiteList( msg.sender, 0x80000000, 0, add );
1606             return;
1607         }
1608         if( ! whiteListEnabled ) {
1609             // white list is not enabeled
1610             UpdateWhiteList( msg.sender, 0x80000001, 0, add );        
1611             return;
1612         }
1613         
1614         whiteList[ miner ] = add;
1615         if( ! add && isRegistered( miner ) ) {
1616             // unregister
1617             unRegister( miner );
1618         }
1619         
1620         UpdateWhiteList( msg.sender, 0, uint(miner), add );
1621     }
1622 
1623     function updateBlackList( address miner, bool add ) {
1624         if( ! owners[ msg.sender ] ) {
1625             // only owner can update list
1626             UpdateBlackList( msg.sender, 0x80000000, 0, add );
1627             return;
1628         }
1629         if( ! blackListEnabled ) {
1630             // white list is not enabeled
1631             UpdateBlackList( msg.sender, 0x80000001, 0, add );        
1632             return;
1633         }
1634         
1635         blackList[ miner ] = add;
1636         if( add && isRegistered( miner ) ) {
1637             // unregister
1638             unRegister( miner );
1639         }
1640         
1641         UpdateBlackList( msg.sender, 0, uint(miner), add );
1642     }
1643     
1644     event DisableBlackListForever( address indexed sender, uint error, uint errorInfo );    
1645     function disableBlackListForever() {
1646         if( ! owners[ msg.sender ] ) {
1647             // only owner can update list
1648             DisableBlackListForever( msg.sender, 0x80000000, 0 );
1649             return;
1650         }
1651         
1652         blackListEnabled = false;
1653         
1654         DisableBlackListForever( msg.sender, 0, 0 );        
1655     }
1656 
1657     event DisableWhiteListForever( address indexed sender, uint error, uint errorInfo );
1658     function disableWhiteListForever() {
1659         if( ! owners[ msg.sender ] ) {
1660             // only owner can update list
1661             DisableWhiteListForever( msg.sender, 0x80000000, 0 );
1662             return;
1663         }
1664         
1665         whiteListEnabled = false;
1666         
1667         DisableWhiteListForever( msg.sender, 0, 0 );            
1668     }
1669     
1670     event VerifyExtraData( address indexed sender, uint error, uint errorInfo );    
1671     function verifyExtraData( bytes32 extraData, bytes32 minerId, uint difficulty ) constant internal returns(bool) {
1672         uint i;
1673         // compare id
1674         for( i = 0 ; i < 11 ; i++ ) {
1675             if( extraData[10+i] != minerId[21+i] ) {
1676                 //ErrorLog( "verifyExtraData: miner id not as expected", 0 );
1677                 VerifyExtraData( msg.sender, 0x83000000, uint(minerId) );         
1678                 return false;            
1679             }
1680         }
1681         
1682         // compare difficulty
1683         bytes32 encodedDiff = to62Encoding(difficulty,11);
1684         for( i = 0 ; i < 11 ; i++ ) {
1685             if(extraData[i+21] != encodedDiff[21+i]) {
1686                 //ErrorLog( "verifyExtraData: difficulty is not as expected", uint(encodedDiff) );
1687                 VerifyExtraData( msg.sender, 0x83000001, uint(encodedDiff) );
1688                 return false;            
1689             }  
1690         }
1691                 
1692         return true;            
1693     }    
1694     
1695     event VerifyClaim( address indexed sender, uint error, uint errorInfo );
1696     
1697         
1698     function verifyClaim( bytes rlpHeader,
1699                           uint  nonce,
1700                           uint  submissionIndex,
1701                           uint  shareIndex,
1702                           uint[] dataSetLookup,
1703                           uint[] witnessForLookup,
1704                           uint[] augCountersBranch,
1705                           uint[] augHashesBranch ) {
1706 
1707         if( ! isRegistered(msg.sender) ) {
1708             // miner is not registered
1709             VerifyClaim( msg.sender, 0x8400000c, 0 );
1710             return;         
1711         }
1712 
1713         SubmissionDataForClaimVerification memory submissionData = getClaimData( msg.sender,
1714             submissionIndex, shareIndex, getClaimSeed( msg.sender ) ); 
1715                               
1716         if( ! submissionData.readyForVerification ) {
1717             //ErrorLog( "there are no pending claims", 0 );
1718             VerifyClaim( msg.sender, 0x84000003, 0 );            
1719             return;
1720         }
1721         
1722         BlockHeader memory header = parseBlockHeader(rlpHeader);
1723 
1724         // check extra data
1725         if( ! verifyExtraData( header.extraData,
1726                                minersData[ msg.sender ].minerId,
1727                                submissionData.shareDifficulty ) ) {
1728             //ErrorLog( "extra data not as expected", uint(header.extraData) );
1729             VerifyClaim( msg.sender, 0x84000004, uint(header.extraData) );            
1730             return;                               
1731         }
1732         
1733         // check coinbase data
1734         if( header.coinbase != uint(this) ) {
1735             //ErrorLog( "coinbase not as expected", uint(header.coinbase) );
1736             VerifyClaim( msg.sender, 0x84000005, uint(header.coinbase) );            
1737             return;
1738         }
1739          
1740         
1741         // check counter
1742         uint counter = header.timestamp * (2 ** 64) + nonce;
1743         if( counter < submissionData.min ) {
1744             //ErrorLog( "counter is smaller than min",counter);
1745             VerifyClaim( msg.sender, 0x84000007, counter );            
1746             return;                         
1747         }
1748         if( counter > submissionData.max ) {
1749             //ErrorLog( "counter is smaller than max",counter);
1750             VerifyClaim( msg.sender, 0x84000008, counter );            
1751             return;                         
1752         }
1753         
1754         // verify agt
1755         uint leafHash = uint(sha3(rlpHeader));
1756         VerifyAgtData memory agtData;
1757         agtData.rootHash = submissionData.augMerkle;
1758         agtData.rootMin = submissionData.min;
1759         agtData.rootMax = submissionData.max;
1760         agtData.leafHash = leafHash;
1761         agtData.leafCounter = counter;
1762                 
1763 
1764         if( ! verifyAgt( agtData,
1765                          shareIndex,
1766                          augCountersBranch,
1767                          augHashesBranch ) ) {
1768             //ErrorLog( "verifyAgt failed",0);
1769             VerifyClaim( msg.sender, 0x84000009, 0 );            
1770             return;
1771         }
1772                           
1773         
1774         /*
1775         // check epoch data - done inside hashimoto
1776         if( ! ethashContract.isEpochDataSet( header.blockNumber / 30000 ) ) {
1777             //ErrorLog( "epoch data was not set",header.blockNumber / 30000);
1778             VerifyClaim( msg.sender, 0x8400000a, header.blockNumber / 30000 );                        
1779             return;        
1780         }*/
1781 
1782 
1783         // verify ethash
1784         uint ethash = ethashContract.hashimoto( bytes32(leafHash),
1785                                                 bytes8(nonce),
1786                                                 dataSetLookup,
1787                                                 witnessForLookup,
1788                                                 header.blockNumber / 30000 );
1789         if( ethash > ((2**256-1)/submissionData.shareDifficulty )) {
1790             if( ethash == 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE ) {
1791                 //ErrorLog( "epoch data was not set",header.blockNumber / 30000);
1792                 VerifyClaim( msg.sender, 0x8400000a, header.blockNumber / 30000 );                                        
1793             }
1794             else {
1795                 //ErrorLog( "ethash difficulty too low",ethash);
1796                 VerifyClaim( msg.sender, 0x8400000b, ethash );
1797             }            
1798             return;        
1799         }
1800         
1801         if( getClaimSeed(msg.sender) == 0 ) {
1802             //ErrorLog( "claim seed is 0", 0 );
1803             VerifyClaim( msg.sender, 0x84000001, 0 );
1804             return;        
1805         }
1806         
1807         if( ! submissionData.indicesAreValid ) {
1808             //ErrorLog( "share index or submission are not as expected. should be:", getShareIndex() );
1809             VerifyClaim( msg.sender, 0x84000002, 0 );
1810             return;                
1811         } 
1812         
1813         // recrusive attack is not possible as doPayment is using send and not call.
1814         if( ! doPayment(submissionData.totalSubmissionValue,
1815                         minersData[ msg.sender ].paymentAddress) ) {
1816             // error msg is given in doPayment function
1817             return;
1818         }
1819         
1820         closeSubmission( msg.sender );
1821         //minersData[ msg.sender ].pendingClaim = false;
1822         
1823         
1824         VerifyClaim( msg.sender, 0, 0 );                        
1825         
1826         
1827         return;
1828     }    
1829     
1830 
1831     // 10000 = 100%
1832     uint public uncleRate = 500; // 5%
1833     // 10000 = 100%
1834     uint public poolFees = 0;
1835 
1836 
1837     event IncomingFunds( address sender, uint amountInWei );
1838     function() payable {
1839         IncomingFunds( msg.sender, msg.value );
1840     }
1841 
1842     event SetUnlceRateAndFees( address indexed sender, uint error, uint errorInfo );
1843     function setUnlceRateAndFees( uint _uncleRate, uint _poolFees ) {
1844         if( ! owners[msg.sender] ) {
1845             // only owner should change rates
1846             SetUnlceRateAndFees( msg.sender, 0x80000000, 0 );
1847             return;
1848         }
1849         
1850         uncleRate = _uncleRate;
1851         poolFees = _poolFees;
1852         
1853         SetUnlceRateAndFees( msg.sender, 0, 0 );
1854     }
1855         
1856     event DoPayment( address indexed sender, address paymentAddress, uint valueInWei );
1857     function doPayment( uint submissionValue,
1858                         address paymentAddress ) internal returns(bool) {
1859 
1860         uint payment = submissionValue;
1861         // take uncle rate into account
1862         
1863         // payment = payment * (1-0.25*uncleRate)
1864         // uncleRate in [0,10000]
1865         payment = (payment * (4*10000 - uncleRate)) / (4*10000);
1866         
1867         // fees
1868         payment = (payment * (10000 - poolFees)) / 10000;
1869 
1870         if( payment > this.balance ){
1871             //ErrorLog( "cannot afford to pay", calcPayment( submissionData.numShares, submissionData.difficulty ) );
1872             VerifyClaim( msg.sender, 0x84000000, payment );        
1873             return false;
1874         }
1875                 
1876         if( ! paymentAddress.send( payment ) ) throw;
1877         
1878         DoPayment( msg.sender, paymentAddress, payment ); 
1879         
1880         return true;
1881     }
1882     
1883     function getPoolETHBalance( ) constant returns(uint) {
1884         // debug function for testrpc
1885         return this.balance;
1886     }
1887 
1888     event GetShareIndexDebugForTestRPCSubmissionIndex( uint index );    
1889     event GetShareIndexDebugForTestRPCShareIndex( uint index );
1890      
1891     function getShareIndexDebugForTestRPC( address sender ) {
1892         uint seed = getClaimSeed( sender );
1893         uint[2] memory result = calculateSubmissionIndex( sender, seed );
1894         
1895         GetShareIndexDebugForTestRPCSubmissionIndex( result[0] );
1896         GetShareIndexDebugForTestRPCShareIndex( result[1] );        
1897             
1898     }        
1899 }