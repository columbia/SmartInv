1 pragma solidity ^0.4.8;
2 
3 //solc --bin --abi --optimize  --optimize-runs 20000 -o . Testpool.sol 
4 
5 
6 //import "./SHA3_512.sol";
7 
8 contract SHA3_512 {
9     function SHA3_512() {}
10     
11     function keccak_f(uint[25] A) constant internal returns(uint[25]) {
12         uint[5] memory C;
13         uint[5] memory D;
14         uint x;
15         uint y;
16         //uint D_0; uint D_1; uint D_2; uint D_3; uint D_4;
17         uint[25] memory B;
18         
19         uint[24] memory RC= [
20                    uint(0x0000000000000001),
21                    0x0000000000008082,
22                    0x800000000000808A,
23                    0x8000000080008000,
24                    0x000000000000808B,
25                    0x0000000080000001,
26                    0x8000000080008081,
27                    0x8000000000008009,
28                    0x000000000000008A,
29                    0x0000000000000088,
30                    0x0000000080008009,
31                    0x000000008000000A,
32                    0x000000008000808B,
33                    0x800000000000008B,
34                    0x8000000000008089,
35                    0x8000000000008003,
36                    0x8000000000008002,
37                    0x8000000000000080,
38                    0x000000000000800A,
39                    0x800000008000000A,
40                    0x8000000080008081,
41                    0x8000000000008080,
42                    0x0000000080000001,
43                    0x8000000080008008 ];
44         
45         for( uint i = 0 ; i < 24 ; i++ ) {
46             /*
47             for( x = 0 ; x < 5 ; x++ ) {
48                 C[x] = A[5*x]^A[5*x+1]^A[5*x+2]^A[5*x+3]^A[5*x+4];                
49             }*/
50                        
51             C[0]=A[0]^A[1]^A[2]^A[3]^A[4];
52             C[1]=A[5]^A[6]^A[7]^A[8]^A[9];
53             C[2]=A[10]^A[11]^A[12]^A[13]^A[14];
54             C[3]=A[15]^A[16]^A[17]^A[18]^A[19];
55             C[4]=A[20]^A[21]^A[22]^A[23]^A[24];
56 
57             /*
58             for( x = 0 ; x < 5 ; x++ ) {
59                 D[x] = C[(x+4)%5]^((C[(x+1)%5] * 2)&0xffffffffffffffff | (C[(x+1)%5]/(2**63)));
60             }*/
61                         
62             
63             D[0]=C[4] ^ ((C[1] * 2)&0xffffffffffffffff | (C[1] / (2 ** 63)));
64             D[1]=C[0] ^ ((C[2] * 2)&0xffffffffffffffff | (C[2] / (2 ** 63)));
65             D[2]=C[1] ^ ((C[3] * 2)&0xffffffffffffffff | (C[3] / (2 ** 63)));
66             D[3]=C[2] ^ ((C[4] * 2)&0xffffffffffffffff | (C[4] / (2 ** 63)));
67             D[4]=C[3] ^ ((C[0] * 2)&0xffffffffffffffff | (C[0] / (2 ** 63)));
68 
69             /*
70             for( x = 0 ; x < 5 ; x++ ) {
71                 for( y = 0 ; y < 5 ; y++ ) {
72                     A[5*x+y] = A[5*x+y] ^ D[x];
73                 }            
74             }*/
75             
76 
77             
78             A[0]=A[0] ^ D[0];
79             A[1]=A[1] ^ D[0];
80             A[2]=A[2] ^ D[0];
81             A[3]=A[3] ^ D[0];
82             A[4]=A[4] ^ D[0];
83             A[5]=A[5] ^ D[1];
84             A[6]=A[6] ^ D[1];
85             A[7]=A[7] ^ D[1];
86             A[8]=A[8] ^ D[1];
87             A[9]=A[9] ^ D[1];
88             A[10]=A[10] ^ D[2];
89             A[11]=A[11] ^ D[2];
90             A[12]=A[12] ^ D[2];
91             A[13]=A[13] ^ D[2];
92             A[14]=A[14] ^ D[2];
93             A[15]=A[15] ^ D[3];
94             A[16]=A[16] ^ D[3];
95             A[17]=A[17] ^ D[3];
96             A[18]=A[18] ^ D[3];
97             A[19]=A[19] ^ D[3];
98             A[20]=A[20] ^ D[4];
99             A[21]=A[21] ^ D[4];
100             A[22]=A[22] ^ D[4];
101             A[23]=A[23] ^ D[4];
102             A[24]=A[24] ^ D[4];
103 
104             /*Rho and pi steps*/            
105             B[0]=A[0];
106             B[8]=((A[1] * (2 ** 36))&0xffffffffffffffff | (A[1] / (2 ** 28)));
107             B[11]=((A[2] * (2 ** 3))&0xffffffffffffffff | (A[2] / (2 ** 61)));
108             B[19]=((A[3] * (2 ** 41))&0xffffffffffffffff | (A[3] / (2 ** 23)));
109             B[22]=((A[4] * (2 ** 18))&0xffffffffffffffff | (A[4] / (2 ** 46)));
110             B[2]=((A[5] * (2 ** 1))&0xffffffffffffffff | (A[5] / (2 ** 63)));
111             B[5]=((A[6] * (2 ** 44))&0xffffffffffffffff | (A[6] / (2 ** 20)));
112             B[13]=((A[7] * (2 ** 10))&0xffffffffffffffff | (A[7] / (2 ** 54)));
113             B[16]=((A[8] * (2 ** 45))&0xffffffffffffffff | (A[8] / (2 ** 19)));
114             B[24]=((A[9] * (2 ** 2))&0xffffffffffffffff | (A[9] / (2 ** 62)));
115             B[4]=((A[10] * (2 ** 62))&0xffffffffffffffff | (A[10] / (2 ** 2)));
116             B[7]=((A[11] * (2 ** 6))&0xffffffffffffffff | (A[11] / (2 ** 58)));
117             B[10]=((A[12] * (2 ** 43))&0xffffffffffffffff | (A[12] / (2 ** 21)));
118             B[18]=((A[13] * (2 ** 15))&0xffffffffffffffff | (A[13] / (2 ** 49)));
119             B[21]=((A[14] * (2 ** 61))&0xffffffffffffffff | (A[14] / (2 ** 3)));
120             B[1]=((A[15] * (2 ** 28))&0xffffffffffffffff | (A[15] / (2 ** 36)));
121             B[9]=((A[16] * (2 ** 55))&0xffffffffffffffff | (A[16] / (2 ** 9)));
122             B[12]=((A[17] * (2 ** 25))&0xffffffffffffffff | (A[17] / (2 ** 39)));
123             B[15]=((A[18] * (2 ** 21))&0xffffffffffffffff | (A[18] / (2 ** 43)));
124             B[23]=((A[19] * (2 ** 56))&0xffffffffffffffff | (A[19] / (2 ** 8)));
125             B[3]=((A[20] * (2 ** 27))&0xffffffffffffffff | (A[20] / (2 ** 37)));
126             B[6]=((A[21] * (2 ** 20))&0xffffffffffffffff | (A[21] / (2 ** 44)));
127             B[14]=((A[22] * (2 ** 39))&0xffffffffffffffff | (A[22] / (2 ** 25)));
128             B[17]=((A[23] * (2 ** 8))&0xffffffffffffffff | (A[23] / (2 ** 56)));
129             B[20]=((A[24] * (2 ** 14))&0xffffffffffffffff | (A[24] / (2 ** 50)));
130 
131             /*Xi state*/
132             /*
133             for( x = 0 ; x < 5 ; x++ ) {
134                 for( y = 0 ; y < 5 ; y++ ) {
135                     A[5*x+y] = B[5*x+y]^((~B[5*((x+1)%5)+y]) & B[5*((x+2)%5)+y]);
136                 }
137             }*/
138             
139             
140             A[0]=B[0]^((~B[5]) & B[10]);
141             A[1]=B[1]^((~B[6]) & B[11]);
142             A[2]=B[2]^((~B[7]) & B[12]);
143             A[3]=B[3]^((~B[8]) & B[13]);
144             A[4]=B[4]^((~B[9]) & B[14]);
145             A[5]=B[5]^((~B[10]) & B[15]);
146             A[6]=B[6]^((~B[11]) & B[16]);
147             A[7]=B[7]^((~B[12]) & B[17]);
148             A[8]=B[8]^((~B[13]) & B[18]);
149             A[9]=B[9]^((~B[14]) & B[19]);
150             A[10]=B[10]^((~B[15]) & B[20]);
151             A[11]=B[11]^((~B[16]) & B[21]);
152             A[12]=B[12]^((~B[17]) & B[22]);
153             A[13]=B[13]^((~B[18]) & B[23]);
154             A[14]=B[14]^((~B[19]) & B[24]);
155             A[15]=B[15]^((~B[20]) & B[0]);
156             A[16]=B[16]^((~B[21]) & B[1]);
157             A[17]=B[17]^((~B[22]) & B[2]);
158             A[18]=B[18]^((~B[23]) & B[3]);
159             A[19]=B[19]^((~B[24]) & B[4]);
160             A[20]=B[20]^((~B[0]) & B[5]);
161             A[21]=B[21]^((~B[1]) & B[6]);
162             A[22]=B[22]^((~B[2]) & B[7]);
163             A[23]=B[23]^((~B[3]) & B[8]);
164             A[24]=B[24]^((~B[4]) & B[9]);
165 
166             /*Last step*/
167             A[0]=A[0]^RC[i];            
168         }
169 
170         
171         return A;
172     }
173  
174     
175     function sponge(uint[9] M) constant internal returns(uint[16]) {
176         if( (M.length * 8) != 72 ) throw;
177         M[5] = 0x01;
178         M[8] = 0x8000000000000000;
179         
180         uint r = 72;
181         uint w = 8;
182         uint size = M.length * 8;
183         
184         uint[25] memory S;
185         uint i; uint y; uint x;
186         /*Absorbing Phase*/
187         for( i = 0 ; i < size/r ; i++ ) {
188             for( y = 0 ; y < 5 ; y++ ) {
189                 for( x = 0 ; x < 5 ; x++ ) {
190                     if( (x+5*y) < (r/w) ) {
191                         S[5*x+y] = S[5*x+y] ^ M[i*9 + x + 5*y];
192                     }
193                 }
194             }
195             S = keccak_f(S);
196         }
197 
198         /*Squeezing phase*/
199         uint[16] memory result;
200         uint b = 0;
201         while( b < 16 ) {
202             for( y = 0 ; y < 5 ; y++ ) {
203                 for( x = 0 ; x < 5 ; x++ ) {
204                     if( (x+5*y)<(r/w) && (b<16) ) {
205                         result[b] = S[5*x+y] & 0xFFFFFFFF; 
206                         result[b+1] = S[5*x+y] / 0x100000000;
207                         b+=2;
208                     }
209                 }
210             }
211         }
212          
213         return result;
214    }
215 
216 }
217 
218 ////////////////////////////////////////////////////////////////////////////////
219 
220 contract Ethash is SHA3_512 {
221     
222     mapping(address=>bool) public owners;
223     
224     function Ethash(address[3] _owners) {
225         owners[_owners[0]] = true;
226         owners[_owners[1]] = true;
227         owners[_owners[2]] = true;                
228     }
229      
230     function fnv( uint v1, uint v2 ) constant internal returns(uint) {
231         return ((v1*0x01000193) ^ v2) & 0xFFFFFFFF;
232     }
233 
234 
235 
236     function computeCacheRoot( uint index,
237                                uint indexInElementsArray,
238                                uint[] elements,
239                                uint[] witness,
240                                uint branchSize ) constant private returns(uint) {
241  
242                        
243         uint leaf = computeLeaf(elements, indexInElementsArray) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
244 
245         uint left;
246         uint right;
247         uint node;
248         bool oddBranchSize = (branchSize % 2) > 0;
249          
250         assembly {
251             branchSize := div(branchSize,2)
252             //branchSize /= 2;
253         }
254         uint witnessIndex = indexInElementsArray * branchSize;
255         if( oddBranchSize ) witnessIndex += indexInElementsArray;  
256 
257         for( uint depth = 0 ; depth < branchSize ; depth++ ) {
258             assembly {
259                 node := mload(add(add(witness,0x20),mul(add(depth,witnessIndex),0x20)))
260             }
261             //node  = witness[witnessIndex + depth] & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
262             if( index & 0x1 == 0 ) {
263                 left = leaf;
264                 assembly{
265                     //right = node & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;                
266                     right := and(node,0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
267                 }
268                 
269             }
270             else {
271                 assembly{
272                     //left = node & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
273                     left := and(node,0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
274                 }
275                 right = leaf;
276             }
277             
278             leaf = uint(sha3(left,right)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
279             assembly {
280                 index := div(index,2) 
281             }
282             //index = index / 2;
283 
284             //node  = witness[witnessIndex + depth] / (2**128);
285             if( index & 0x1 == 0 ) {
286                 left = leaf;
287                 assembly{
288                     right := div(node,0x100000000000000000000000000000000)
289                     //right = node / 0x100000000000000000000000000000000;
290                 }
291             }
292             else {
293                 assembly {
294                     //left = node / 0x100000000000000000000000000000000;
295                     left := div(node,0x100000000000000000000000000000000)
296                 }
297                 right = leaf;
298             }
299             
300             leaf = uint(sha3(left,right)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
301             assembly {
302                 index := div(index,2) 
303             }
304             //index = index / 2;
305         }
306         
307         if( oddBranchSize ) {
308             assembly {
309                 node := mload(add(add(witness,0x20),mul(add(depth,witnessIndex),0x20)))
310             }
311         
312             //node  = witness[witnessIndex + depth] & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
313             if( index & 0x1 == 0 ) {
314                 left = leaf;
315                 assembly{
316                     //right = node & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;                
317                     right := and(node,0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
318                 }                
319             }
320             else {
321                 assembly{
322                     //left = node & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;                
323                     left := and(node,0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
324                 }
325             
326                 right = leaf;
327             }
328             
329             leaf = uint(sha3(left,right)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;        
330         }
331         
332         
333         return leaf;
334     }
335 
336     
337     function toBE( uint x ) constant internal returns(uint) {
338         uint y = 0;
339         for( uint i = 0 ; i < 32 ; i++ ) {
340             y = y * 256;
341             y += (x & 0xFF);
342             x = x / 256;            
343         }
344         
345         return y;
346         
347     }
348     
349     function computeSha3( uint[16] s, uint[8] cmix ) constant internal returns(uint) {
350         uint s0 = s[0] + s[1] * (2**32) + s[2] * (2**64) + s[3] * (2**96) +
351                   (s[4] + s[5] * (2**32) + s[6] * (2**64) + s[7] * (2**96))*(2**128);
352 
353         uint s1 = s[8] + s[9] * (2**32) + s[10] * (2**64) + s[11] * (2**96) +
354                   (s[12] + s[13] * (2**32) + s[14] * (2**64) + s[15] * (2**96))*(2**128);
355                   
356         uint c = cmix[0] + cmix[1] * (2**32) + cmix[2] * (2**64) + cmix[3] * (2**96) +
357                   (cmix[4] + cmix[5] * (2**32) + cmix[6] * (2**64) + cmix[7] * (2**96))*(2**128);
358 
359         
360         /* god knows why need to convert to big endian */
361         return uint( sha3(toBE(s0),toBE(s1),toBE(c)) );
362     }
363  
364  
365     function computeLeaf( uint[] dataSetLookup, uint index ) constant internal returns(uint) {
366         return uint( sha3(dataSetLookup[4*index],
367                           dataSetLookup[4*index + 1],
368                           dataSetLookup[4*index + 2],
369                           dataSetLookup[4*index + 3]) );
370                                     
371     }
372  
373     function computeS( uint header, uint nonceLe ) constant internal returns(uint[16]) {
374         uint[9]  memory M;
375         
376         header = reverseBytes(header);
377         
378         M[0] = uint(header) & 0xFFFFFFFFFFFFFFFF;
379         header = header / 2**64;
380         M[1] = uint(header) & 0xFFFFFFFFFFFFFFFF;
381         header = header / 2**64;
382         M[2] = uint(header) & 0xFFFFFFFFFFFFFFFF;
383         header = header / 2**64;
384         M[3] = uint(header) & 0xFFFFFFFFFFFFFFFF;
385 
386         // make little endian nonce
387         M[4] = nonceLe;
388         return sponge(M);
389     }
390     
391     function reverseBytes( uint input ) constant internal returns(uint) {
392         uint result = 0;
393         for(uint i = 0 ; i < 32 ; i++ ) {
394             result = result * 256;
395             result += input & 0xff;
396             
397             input /= 256;
398         }
399         
400         return result;
401     }
402     
403     struct EthashCacheOptData {
404         uint[512]    merkleNodes;
405         uint         fullSizeIn128Resultion;
406         uint         branchDepth;
407     }
408     
409     mapping(uint=>EthashCacheOptData) epochData;
410     
411     function getEpochData( uint epochIndex, uint nodeIndex ) constant returns(uint[3]) {
412         return [epochData[epochIndex].merkleNodes[nodeIndex],
413                 epochData[epochIndex].fullSizeIn128Resultion,
414                 epochData[epochIndex].branchDepth];
415     }
416     
417     function isEpochDataSet( uint epochIndex ) constant returns(bool) {
418         return epochData[epochIndex].fullSizeIn128Resultion != 0;
419     
420     }
421         
422     event SetEpochData( address indexed sender, uint error, uint errorInfo );    
423     function setEpochData( uint epoch,
424                            uint fullSizeIn128Resultion,
425                            uint branchDepth,
426                            uint[] merkleNodes,
427                            uint start,
428                            uint numElems ) {
429 
430         if( ! owners[msg.sender] ) {
431             //ErrorLog( "setEpochData: only owner can set data", uint(msg.sender) );
432             SetEpochData( msg.sender, 0x82000000, uint(msg.sender) );
433             return;        
434         }                           
435                            
436         for( uint i = 0 ; i < numElems ; i++ ) {
437             if( epochData[epoch].merkleNodes[start+i] > 0 ) {
438                 //ErrorLog("epoch already set", epoch[i]);
439                 SetEpochData( msg.sender, 0x82000001, epoch * (2**128) + start + i );
440                 return;            
441 
442             } 
443             epochData[epoch].merkleNodes[start+i] = merkleNodes[i];
444         }
445         epochData[epoch].fullSizeIn128Resultion = fullSizeIn128Resultion;
446         epochData[epoch].branchDepth = branchDepth;
447         
448         SetEpochData( msg.sender, 0 , 0 );        
449     }
450 
451     function getMerkleLeave( uint epochIndex, uint p ) constant internal returns(uint) {        
452         uint rootIndex = p >> epochData[epochIndex].branchDepth;
453         uint expectedRoot = epochData[epochIndex].merkleNodes[(rootIndex/2)];
454         if( (rootIndex % 2) == 0 ) expectedRoot = expectedRoot & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
455         else expectedRoot = expectedRoot / (2**128);
456         
457         return expectedRoot;
458     }
459 
460 
461     function hashimoto( bytes32      header,
462                         bytes8       nonceLe,
463                         uint[]       dataSetLookup,
464                         uint[]       witnessForLookup,
465                         uint         epochIndex ) constant returns(uint) {
466          
467         uint[16] memory s;
468         uint[32] memory mix;
469         uint[8]  memory cmix;
470         
471         uint[2]  memory depthAndFullSize = [epochData[epochIndex].branchDepth, 
472                                             epochData[epochIndex].fullSizeIn128Resultion];
473                 
474         uint i;
475         uint j;
476         
477         if( ! isEpochDataSet( epochIndex ) ) return 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE;
478         
479         if( depthAndFullSize[1] == 0 ) {
480             return 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
481         }
482 
483         
484         s = computeS(uint(header), uint(nonceLe));
485         for( i = 0 ; i < 16 ; i++ ) {            
486             assembly {
487                 let offset := mul(i,0x20)
488                 
489                 //mix[i] = s[i];
490                 mstore(add(mix,offset),mload(add(s,offset)))
491                 
492                 // mix[i+16] = s[i];
493                 mstore(add(mix,add(0x200,offset)),mload(add(s,offset)))    
494             }
495         }
496 
497         for( i = 0 ; i < 64 ; i++ ) {
498             uint p = fnv( i ^ s[0], mix[i % 32]) % depthAndFullSize[1];
499             
500             
501             if( computeCacheRoot( p, i, dataSetLookup,  witnessForLookup, depthAndFullSize[0] )  != getMerkleLeave( epochIndex, p ) ) {
502             
503                 // PoW failed
504                 return 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
505             }       
506 
507             for( j = 0 ; j < 8 ; j++ ) {
508 
509                 assembly{
510                     //mix[j] = fnv(mix[j], dataSetLookup[4*i] & varFFFFFFFF );
511                     let dataOffset := add(mul(0x80,i),add(dataSetLookup,0x20))
512                     let dataValue   := and(mload(dataOffset),0xFFFFFFFF)
513                     
514                     let mixOffset := add(mix,mul(0x20,j))
515                     let mixValue  := mload(mixOffset)
516                     
517                     // fnv = return ((v1*0x01000193) ^ v2) & 0xFFFFFFFF;
518                     let fnvValue := and(xor(mul(mixValue,0x01000193),dataValue),0xFFFFFFFF)                    
519                     mstore(mixOffset,fnvValue)
520                     
521                     //mix[j+8] = fnv(mix[j+8], dataSetLookup[4*i + 1] & 0xFFFFFFFF );
522                     dataOffset := add(dataOffset,0x20)
523                     dataValue   := and(mload(dataOffset),0xFFFFFFFF)
524                     
525                     mixOffset := add(mixOffset,0x100)
526                     mixValue  := mload(mixOffset)
527                     
528                     // fnv = return ((v1*0x01000193) ^ v2) & 0xFFFFFFFF;
529                     fnvValue := and(xor(mul(mixValue,0x01000193),dataValue),0xFFFFFFFF)                    
530                     mstore(mixOffset,fnvValue)
531 
532                     //mix[j+16] = fnv(mix[j+16], dataSetLookup[4*i + 2] & 0xFFFFFFFF );
533                     dataOffset := add(dataOffset,0x20)
534                     dataValue   := and(mload(dataOffset),0xFFFFFFFF)
535                     
536                     mixOffset := add(mixOffset,0x100)
537                     mixValue  := mload(mixOffset)
538                     
539                     // fnv = return ((v1*0x01000193) ^ v2) & 0xFFFFFFFF;
540                     fnvValue := and(xor(mul(mixValue,0x01000193),dataValue),0xFFFFFFFF)                    
541                     mstore(mixOffset,fnvValue)
542 
543                     //mix[j+24] = fnv(mix[j+24], dataSetLookup[4*i + 3] & 0xFFFFFFFF );
544                     dataOffset := add(dataOffset,0x20)
545                     dataValue   := and(mload(dataOffset),0xFFFFFFFF)
546                     
547                     mixOffset := add(mixOffset,0x100)
548                     mixValue  := mload(mixOffset)
549                     
550                     // fnv = return ((v1*0x01000193) ^ v2) & 0xFFFFFFFF;
551                     fnvValue := and(xor(mul(mixValue,0x01000193),dataValue),0xFFFFFFFF)                    
552                     mstore(mixOffset,fnvValue)                    
553                                         
554                 }
555 
556                 
557                 //mix[j] = fnv(mix[j], dataSetLookup[4*i] & 0xFFFFFFFF );
558                 //mix[j+8] = fnv(mix[j+8], dataSetLookup[4*i + 1] & 0xFFFFFFFF );
559                 //mix[j+16] = fnv(mix[j+16], dataSetLookup[4*i + 2] & 0xFFFFFFFF );                
560                 //mix[j+24] = fnv(mix[j+24], dataSetLookup[4*i + 3] & 0xFFFFFFFF );
561                 
562                 
563                 //dataSetLookup[4*i    ] = dataSetLookup[4*i    ]/(2**32);
564                 //dataSetLookup[4*i + 1] = dataSetLookup[4*i + 1]/(2**32);
565                 //dataSetLookup[4*i + 2] = dataSetLookup[4*i + 2]/(2**32);
566                 //dataSetLookup[4*i + 3] = dataSetLookup[4*i + 3]/(2**32);                
567                 
568                 assembly{
569                     let offset := add(add(dataSetLookup,0x20),mul(i,0x80))
570                     let value  := div(mload(offset),0x100000000)
571                     mstore(offset,value)
572                                        
573                     offset := add(offset,0x20)
574                     value  := div(mload(offset),0x100000000)
575                     mstore(offset,value)
576                     
577                     offset := add(offset,0x20)
578                     value  := div(mload(offset),0x100000000)
579                     mstore(offset,value)                    
580                     
581                     offset := add(offset,0x20)
582                     value  := div(mload(offset),0x100000000)
583                     mstore(offset,value)                                                                                
584                 }                
585             }
586         }
587         
588         
589         for( i = 0 ; i < 32 ; i += 4) {
590             cmix[i/4] = (fnv(fnv(fnv(mix[i], mix[i+1]), mix[i+2]), mix[i+3]));
591         }
592         
593 
594         uint result = computeSha3(s,cmix); 
595 
596         return result;
597         
598     }
599 }
600 
601 /**
602 * @title RLPReader
603 *
604 * RLPReader is used to read and parse RLP encoded data in memory.
605 *
606 * @author Andreas Olofsson (androlo1980@gmail.com)
607 */
608 library RLP {
609 
610  uint constant DATA_SHORT_START = 0x80;
611  uint constant DATA_LONG_START = 0xB8;
612  uint constant LIST_SHORT_START = 0xC0;
613  uint constant LIST_LONG_START = 0xF8;
614 
615  uint constant DATA_LONG_OFFSET = 0xB7;
616  uint constant LIST_LONG_OFFSET = 0xF7;
617 
618 
619  struct RLPItem {
620      uint _unsafe_memPtr;    // Pointer to the RLP-encoded bytes.
621      uint _unsafe_length;    // Number of bytes. This is the full length of the string.
622  }
623 
624  struct Iterator {
625      RLPItem _unsafe_item;   // Item that's being iterated over.
626      uint _unsafe_nextPtr;   // Position of the next item in the list.
627  }
628 
629  /* Iterator */
630 
631  function next(Iterator memory self) internal constant returns (RLPItem memory subItem) {
632      if(hasNext(self)) {
633          var ptr = self._unsafe_nextPtr;
634          var itemLength = _itemLength(ptr);
635          subItem._unsafe_memPtr = ptr;
636          subItem._unsafe_length = itemLength;
637          self._unsafe_nextPtr = ptr + itemLength;
638      }
639      else
640          throw;
641  }
642 
643  function next(Iterator memory self, bool strict) internal constant returns (RLPItem memory subItem) {
644      subItem = next(self);
645      if(strict && !_validate(subItem))
646          throw;
647      return;
648  }
649 
650  function hasNext(Iterator memory self) internal constant returns (bool) {
651      var item = self._unsafe_item;
652      return self._unsafe_nextPtr < item._unsafe_memPtr + item._unsafe_length;
653  }
654 
655  /* RLPItem */
656 
657  /// @dev Creates an RLPItem from an array of RLP encoded bytes.
658  /// @param self The RLP encoded bytes.
659  /// @return An RLPItem
660  function toRLPItem(bytes memory self) internal constant returns (RLPItem memory) {
661      uint len = self.length;
662      if (len == 0) {
663          return RLPItem(0, 0);
664      }
665      uint memPtr;
666      assembly {
667          memPtr := add(self, 0x20)
668      }
669      return RLPItem(memPtr, len);
670  }
671 
672  /// @dev Creates an RLPItem from an array of RLP encoded bytes.
673  /// @param self The RLP encoded bytes.
674  /// @param strict Will throw if the data is not RLP encoded.
675  /// @return An RLPItem
676  function toRLPItem(bytes memory self, bool strict) internal constant returns (RLPItem memory) {
677      var item = toRLPItem(self);
678      if(strict) {
679          uint len = self.length;
680          if(_payloadOffset(item) > len)
681              throw;
682          if(_itemLength(item._unsafe_memPtr) != len)
683              throw;
684          if(!_validate(item))
685              throw;
686      }
687      return item;
688  }
689 
690  /// @dev Check if the RLP item is null.
691  /// @param self The RLP item.
692  /// @return 'true' if the item is null.
693  function isNull(RLPItem memory self) internal constant returns (bool ret) {
694      return self._unsafe_length == 0;
695  }
696 
697  /// @dev Check if the RLP item is a list.
698  /// @param self The RLP item.
699  /// @return 'true' if the item is a list.
700  function isList(RLPItem memory self) internal constant returns (bool ret) {
701      if (self._unsafe_length == 0)
702          return false;
703      uint memPtr = self._unsafe_memPtr;
704      assembly {
705          ret := iszero(lt(byte(0, mload(memPtr)), 0xC0))
706      }
707  }
708 
709  /// @dev Check if the RLP item is data.
710  /// @param self The RLP item.
711  /// @return 'true' if the item is data.
712  function isData(RLPItem memory self) internal constant returns (bool ret) {
713      if (self._unsafe_length == 0)
714          return false;
715      uint memPtr = self._unsafe_memPtr;
716      assembly {
717          ret := lt(byte(0, mload(memPtr)), 0xC0)
718      }
719  }
720 
721  /// @dev Check if the RLP item is empty (string or list).
722  /// @param self The RLP item.
723  /// @return 'true' if the item is null.
724  function isEmpty(RLPItem memory self) internal constant returns (bool ret) {
725      if(isNull(self))
726          return false;
727      uint b0;
728      uint memPtr = self._unsafe_memPtr;
729      assembly {
730          b0 := byte(0, mload(memPtr))
731      }
732      return (b0 == DATA_SHORT_START || b0 == LIST_SHORT_START);
733  }
734 
735  /// @dev Get the number of items in an RLP encoded list.
736  /// @param self The RLP item.
737  /// @return The number of items.
738  function items(RLPItem memory self) internal constant returns (uint) {
739      if (!isList(self))
740          return 0;
741      uint b0;
742      uint memPtr = self._unsafe_memPtr;
743      assembly {
744          b0 := byte(0, mload(memPtr))
745      }
746      uint pos = memPtr + _payloadOffset(self);
747      uint last = memPtr + self._unsafe_length - 1;
748      uint itms;
749      while(pos <= last) {
750          pos += _itemLength(pos);
751          itms++;
752      }
753      return itms;
754  }
755 
756  /// @dev Create an iterator.
757  /// @param self The RLP item.
758  /// @return An 'Iterator' over the item.
759  function iterator(RLPItem memory self) internal constant returns (Iterator memory it) {
760      if (!isList(self))
761          throw;
762      uint ptr = self._unsafe_memPtr + _payloadOffset(self);
763      it._unsafe_item = self;
764      it._unsafe_nextPtr = ptr;
765  }
766 
767  /// @dev Return the RLP encoded bytes.
768  /// @param self The RLPItem.
769  /// @return The bytes.
770  function toBytes(RLPItem memory self) internal constant returns (bytes memory bts) {
771      var len = self._unsafe_length;
772      if (len == 0)
773          return;
774      bts = new bytes(len);
775      _copyToBytes(self._unsafe_memPtr, bts, len);
776  }
777 
778  /// @dev Decode an RLPItem into bytes. This will not work if the
779  /// RLPItem is a list.
780  /// @param self The RLPItem.
781  /// @return The decoded string.
782  function toData(RLPItem memory self) internal constant returns (bytes memory bts) {
783      if(!isData(self))
784          throw;
785      var (rStartPos, len) = _decode(self);
786      bts = new bytes(len);
787      _copyToBytes(rStartPos, bts, len);
788  }
789 
790  /// @dev Get the list of sub-items from an RLP encoded list.
791  /// Warning: This is inefficient, as it requires that the list is read twice.
792  /// @param self The RLP item.
793  /// @return Array of RLPItems.
794  function toList(RLPItem memory self) internal constant returns (RLPItem[] memory list) {
795      if(!isList(self))
796          throw;
797      var numItems = items(self);
798      list = new RLPItem[](numItems);
799      var it = iterator(self);
800      uint idx;
801      while(hasNext(it)) {
802          list[idx] = next(it);
803          idx++;
804      }
805  }
806 
807  /// @dev Decode an RLPItem into an ascii string. This will not work if the
808  /// RLPItem is a list.
809  /// @param self The RLPItem.
810  /// @return The decoded string.
811  function toAscii(RLPItem memory self) internal constant returns (string memory str) {
812      if(!isData(self))
813          throw;
814      var (rStartPos, len) = _decode(self);
815      bytes memory bts = new bytes(len);
816      _copyToBytes(rStartPos, bts, len);
817      str = string(bts);
818  }
819 
820  /// @dev Decode an RLPItem into a uint. This will not work if the
821  /// RLPItem is a list.
822  /// @param self The RLPItem.
823  /// @return The decoded string.
824  function toUint(RLPItem memory self) internal constant returns (uint data) {
825      if(!isData(self))
826          throw;
827      var (rStartPos, len) = _decode(self);
828      if (len > 32 || len == 0)
829          throw;
830      assembly {
831          data := div(mload(rStartPos), exp(256, sub(32, len)))
832      }
833  }
834 
835  /// @dev Decode an RLPItem into a boolean. This will not work if the
836  /// RLPItem is a list.
837  /// @param self The RLPItem.
838  /// @return The decoded string.
839  function toBool(RLPItem memory self) internal constant returns (bool data) {
840      if(!isData(self))
841          throw;
842      var (rStartPos, len) = _decode(self);
843      if (len != 1)
844          throw;
845      uint temp;
846      assembly {
847          temp := byte(0, mload(rStartPos))
848      }
849      if (temp > 1)
850          throw;
851      return temp == 1 ? true : false;
852  }
853 
854  /// @dev Decode an RLPItem into a byte. This will not work if the
855  /// RLPItem is a list.
856  /// @param self The RLPItem.
857  /// @return The decoded string.
858  function toByte(RLPItem memory self) internal constant returns (byte data) {
859      if(!isData(self))
860          throw;
861      var (rStartPos, len) = _decode(self);
862      if (len != 1)
863          throw;
864      uint temp;
865      assembly {
866          temp := byte(0, mload(rStartPos))
867      }
868      return byte(temp);
869  }
870 
871  /// @dev Decode an RLPItem into an int. This will not work if the
872  /// RLPItem is a list.
873  /// @param self The RLPItem.
874  /// @return The decoded string.
875  function toInt(RLPItem memory self) internal constant returns (int data) {
876      return int(toUint(self));
877  }
878 
879  /// @dev Decode an RLPItem into a bytes32. This will not work if the
880  /// RLPItem is a list.
881  /// @param self The RLPItem.
882  /// @return The decoded string.
883  function toBytes32(RLPItem memory self) internal constant returns (bytes32 data) {
884      return bytes32(toUint(self));
885  }
886 
887  /// @dev Decode an RLPItem into an address. This will not work if the
888  /// RLPItem is a list.
889  /// @param self The RLPItem.
890  /// @return The decoded string.
891  function toAddress(RLPItem memory self) internal constant returns (address data) {
892      if(!isData(self))
893          throw;
894      var (rStartPos, len) = _decode(self);
895      if (len != 20)
896          throw;
897      assembly {
898          data := div(mload(rStartPos), exp(256, 12))
899      }
900  }
901 
902  // Get the payload offset.
903  function _payloadOffset(RLPItem memory self) private constant returns (uint) {
904      if(self._unsafe_length == 0)
905          return 0;
906      uint b0;
907      uint memPtr = self._unsafe_memPtr;
908      assembly {
909          b0 := byte(0, mload(memPtr))
910      }
911      if(b0 < DATA_SHORT_START)
912          return 0;
913      if(b0 < DATA_LONG_START || (b0 >= LIST_SHORT_START && b0 < LIST_LONG_START))
914          return 1;
915      if(b0 < LIST_SHORT_START)
916          return b0 - DATA_LONG_OFFSET + 1;
917      return b0 - LIST_LONG_OFFSET + 1;
918  }
919 
920  // Get the full length of an RLP item.
921  function _itemLength(uint memPtr) private constant returns (uint len) {
922      uint b0;
923      assembly {
924          b0 := byte(0, mload(memPtr))
925      }
926      if (b0 < DATA_SHORT_START)
927          len = 1;
928      else if (b0 < DATA_LONG_START)
929          len = b0 - DATA_SHORT_START + 1;
930      else if (b0 < LIST_SHORT_START) {
931          assembly {
932              let bLen := sub(b0, 0xB7) // bytes length (DATA_LONG_OFFSET)
933              let dLen := div(mload(add(memPtr, 1)), exp(256, sub(32, bLen))) // data length
934              len := add(1, add(bLen, dLen)) // total length
935          }
936      }
937      else if (b0 < LIST_LONG_START)
938          len = b0 - LIST_SHORT_START + 1;
939      else {
940          assembly {
941              let bLen := sub(b0, 0xF7) // bytes length (LIST_LONG_OFFSET)
942              let dLen := div(mload(add(memPtr, 1)), exp(256, sub(32, bLen))) // data length
943              len := add(1, add(bLen, dLen)) // total length
944          }
945      }
946  }
947 
948  // Get start position and length of the data.
949  function _decode(RLPItem memory self) private constant returns (uint memPtr, uint len) {
950      if(!isData(self))
951          throw;
952      uint b0;
953      uint start = self._unsafe_memPtr;
954      assembly {
955          b0 := byte(0, mload(start))
956      }
957      if (b0 < DATA_SHORT_START) {
958          memPtr = start;
959          len = 1;
960          return;
961      }
962      if (b0 < DATA_LONG_START) {
963          len = self._unsafe_length - 1;
964          memPtr = start + 1;
965      } else {
966          uint bLen;
967          assembly {
968              bLen := sub(b0, 0xB7) // DATA_LONG_OFFSET
969          }
970          len = self._unsafe_length - 1 - bLen;
971          memPtr = start + bLen + 1;
972      }
973      return;
974  }
975 
976  // Assumes that enough memory has been allocated to store in target.
977  function _copyToBytes(uint btsPtr, bytes memory tgt, uint btsLen) private constant {
978      // Exploiting the fact that 'tgt' was the last thing to be allocated,
979      // we can write entire words, and just overwrite any excess.
980      assembly {
981          {
982                  let i := 0 // Start at arr + 0x20
983                  let words := div(add(btsLen, 31), 32)
984                  let rOffset := btsPtr
985                  let wOffset := add(tgt, 0x20)
986              tag_loop:
987                  jumpi(end, eq(i, words))
988                  {
989                      let offset := mul(i, 0x20)
990                      mstore(add(wOffset, offset), mload(add(rOffset, offset)))
991                      i := add(i, 1)
992                  }
993                  jump(tag_loop)
994              end:
995                  mstore(add(tgt, add(0x20, mload(tgt))), 0)
996          }
997      }
998  }
999 
1000      // Check that an RLP item is valid.
1001      function _validate(RLPItem memory self) private constant returns (bool ret) {
1002          // Check that RLP is well-formed.
1003          uint b0;
1004          uint b1;
1005          uint memPtr = self._unsafe_memPtr;
1006          assembly {
1007              b0 := byte(0, mload(memPtr))
1008              b1 := byte(1, mload(memPtr))
1009          }
1010          if(b0 == DATA_SHORT_START + 1 && b1 < DATA_SHORT_START)
1011              return false;
1012          return true;
1013      }
1014 }
1015 
1016 
1017 
1018 
1019 contract Agt {
1020     using RLP for RLP.RLPItem;
1021     using RLP for RLP.Iterator;
1022     using RLP for bytes;
1023  
1024     struct BlockHeader {
1025         uint       prevBlockHash; // 0
1026         uint       coinbase;      // 1
1027         uint       blockNumber;   // 8
1028         //uint       gasUsed;       // 10
1029         uint       timestamp;     // 11
1030         bytes32    extraData;     // 12
1031     }
1032  
1033     function Agt() {}
1034      
1035     function parseBlockHeader( bytes rlpHeader ) constant internal returns(BlockHeader) {
1036         BlockHeader memory header;
1037         
1038         var it = rlpHeader.toRLPItem().iterator();        
1039         uint idx;
1040         while(it.hasNext()) {
1041             if( idx == 0 ) header.prevBlockHash = it.next().toUint();
1042             else if ( idx == 2 ) header.coinbase = it.next().toUint();
1043             else if ( idx == 8 ) header.blockNumber = it.next().toUint();
1044             else if ( idx == 11 ) header.timestamp = it.next().toUint();
1045             else if ( idx == 12 ) header.extraData = bytes32(it.next().toUint());
1046             else it.next();
1047             
1048             idx++;
1049         }
1050  
1051         return header;        
1052     }
1053             
1054     //event VerifyAgt( string msg, uint index );
1055     event VerifyAgt( uint error, uint index );    
1056     
1057     struct VerifyAgtData {
1058         uint rootHash;
1059         uint rootMin;
1060         uint rootMax;
1061         
1062         uint leafHash;
1063         uint leafCounter;        
1064     }
1065 
1066     function verifyAgt( VerifyAgtData data,
1067                         uint   branchIndex,
1068                         uint[] countersBranch,
1069                         uint[] hashesBranch ) constant internal returns(bool) {
1070                         
1071         uint currentHash = data.leafHash & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1072         
1073         uint leftCounterMin;
1074         uint leftCounterMax;        
1075         uint leftHash;
1076         
1077         uint rightCounterMin;
1078         uint rightCounterMax;        
1079         uint rightHash;
1080         
1081         uint min = data.leafCounter;
1082         uint max = data.leafCounter;
1083         
1084         for( uint i = 0 ; i < countersBranch.length ; i++ ) {
1085             if( branchIndex & 0x1 > 0 ) {
1086                 leftCounterMin = countersBranch[i] & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1087                 leftCounterMax = countersBranch[i] >> 128;                
1088                 leftHash    = hashesBranch[i];
1089                 
1090                 rightCounterMin = min;
1091                 rightCounterMax = max;
1092                 rightHash    = currentHash;                
1093             }
1094             else {                
1095                 leftCounterMin = min;
1096                 leftCounterMax = max;
1097                 leftHash    = currentHash;
1098                 
1099                 rightCounterMin = countersBranch[i] & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1100                 rightCounterMax = countersBranch[i] >> 128;                
1101                 rightHash    = hashesBranch[i];                                            
1102             }
1103             
1104             currentHash = uint(sha3(leftCounterMin + (leftCounterMax << 128),
1105                                     leftHash,
1106                                     rightCounterMin + (rightCounterMax << 128),
1107                                     rightHash)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1108             
1109             if( (leftCounterMin >= leftCounterMax) || (rightCounterMin >= rightCounterMax) ) {
1110                 if( i > 0 ) {
1111                     //VerifyAgt( "counters mismatch",i);
1112                     VerifyAgt( 0x80000000, i );
1113                     return false;
1114                 }
1115                 if( leftCounterMin > leftCounterMax ) {
1116                     //VerifyAgt( "counters mismatch",i);
1117                     VerifyAgt( 0x80000001, i );                
1118                     return false;
1119                 }
1120                 if( rightCounterMin > rightCounterMax ) {
1121                     //VerifyAgt( "counters mismatch",i);
1122                     VerifyAgt( 0x80000002, i );                
1123                     return false;
1124                 }                
1125             }
1126             
1127             if( leftCounterMax >= rightCounterMin ) {
1128                 VerifyAgt( 0x80000009, i );            
1129                 return false;
1130             }
1131 
1132             min = leftCounterMin;
1133             max = rightCounterMax;
1134             
1135             branchIndex = branchIndex / 2;
1136         }
1137 
1138         if( min != data.rootMin ) {
1139             //VerifyAgt( "min does not match root min",min);
1140             VerifyAgt( 0x80000003, min );                        
1141             return false;
1142         }
1143         if( max != data.rootMax ) {
1144             //VerifyAgt( "max does not match root max",max);
1145             VerifyAgt( 0x80000004, max );                    
1146             return false;
1147         }
1148         
1149         if( currentHash != data.rootHash ) {
1150             //VerifyAgt( "hash does not match root hash",currentHash);        
1151             VerifyAgt( 0x80000005, currentHash );
1152             return false;
1153         }
1154         
1155         return true;
1156     }
1157     
1158     function verifyAgtDebugForTesting( uint rootHash,
1159                                        uint rootMin,
1160                                        uint rootMax,
1161                                        uint leafHash,
1162                                        uint leafCounter,
1163                                        uint branchIndex,
1164                                        uint[] countersBranch,
1165                                        uint[] hashesBranch ) returns(bool) {
1166                                        
1167         VerifyAgtData memory data;
1168         data.rootHash = rootHash;
1169         data.rootMin = rootMin;
1170         data.rootMax = rootMax;
1171         data.leafHash = leafHash;
1172         data.leafCounter = leafCounter;
1173         
1174         return verifyAgt( data, branchIndex, countersBranch, hashesBranch );
1175     }         
1176 }
1177 
1178 contract WeightedSubmission {
1179     function WeightedSubmission(){}
1180     
1181     struct SingleSubmissionData {
1182         uint128 numShares;
1183         uint128 submissionValue;
1184         uint128 totalPreviousSubmissionValue;
1185         uint128 min;
1186         uint128 max;
1187         uint128 augRoot;
1188     }
1189     
1190     struct SubmissionMetaData {
1191         uint64  numPendingSubmissions;
1192         uint32  readyForVerification; // suppose to be bool
1193         uint32  lastSubmissionBlockNumber;
1194         uint128 totalSubmissionValue;
1195         uint128 difficulty;
1196         uint128 lastCounter;
1197         
1198         uint    submissionSeed;
1199         
1200     }
1201     
1202     mapping(address=>SubmissionMetaData) submissionsMetaData;
1203     
1204     // (user, submission number)=>data
1205     mapping(address=>mapping(uint=>SingleSubmissionData)) submissionsData;
1206     
1207     event SubmitClaim( address indexed sender, uint error, uint errorInfo );
1208     function submitClaim( uint numShares, uint difficulty, uint min, uint max, uint augRoot, bool lastClaimBeforeVerification ) {
1209         SubmissionMetaData memory metaData = submissionsMetaData[msg.sender];
1210         
1211         if( metaData.lastCounter >= min ) {
1212             // miner cheated. min counter is too low
1213             SubmitClaim( msg.sender, 0x81000001, metaData.lastCounter ); 
1214             return;        
1215         }
1216         
1217         if( metaData.readyForVerification > 0 ) {
1218             // miner cheated - should go verification first
1219             SubmitClaim( msg.sender, 0x81000002, 0 ); 
1220             return;
1221         }
1222         
1223         if( metaData.numPendingSubmissions > 0 ) {
1224             if( metaData.difficulty != difficulty ) {
1225                 // could not change difficulty before verification
1226                 SubmitClaim( msg.sender, 0x81000003, metaData.difficulty ); 
1227                 return;            
1228             }
1229         }
1230         
1231         SingleSubmissionData memory submissionData;
1232         
1233         submissionData.numShares = uint64(numShares);
1234         uint blockDifficulty;
1235         if( block.difficulty == 0 ) {
1236             // testrpc - fake increasing difficulty
1237             blockDifficulty = (900000000 * (metaData.numPendingSubmissions+1)); 
1238         }
1239         else {
1240             blockDifficulty = block.difficulty;
1241         }
1242         
1243         submissionData.submissionValue = uint128((uint(numShares * difficulty) * (5 ether)) / blockDifficulty);
1244         
1245         submissionData.totalPreviousSubmissionValue = metaData.totalSubmissionValue;
1246         submissionData.min = uint128(min);
1247         submissionData.max = uint128(max);
1248         submissionData.augRoot = uint128(augRoot);
1249         
1250         (submissionsData[msg.sender])[metaData.numPendingSubmissions] = submissionData;
1251         
1252         // update meta data
1253         metaData.numPendingSubmissions++;
1254         metaData.lastSubmissionBlockNumber = uint32(block.number);
1255         metaData.difficulty = uint128(difficulty);
1256         metaData.lastCounter = uint128(max);
1257         metaData.readyForVerification = lastClaimBeforeVerification ? uint32(1) : uint32(0);
1258 
1259         uint128 temp128;
1260         
1261         
1262         temp128 = metaData.totalSubmissionValue; 
1263 
1264         metaData.totalSubmissionValue += submissionData.submissionValue;
1265         
1266         if( temp128 > metaData.totalSubmissionValue ) {
1267             // overflow in calculation
1268             // note that this code is reachable if user is dishonest and give false
1269             // report on his submission. but even without
1270             // this validation, user cannot benifit from the overflow
1271             SubmitClaim( msg.sender, 0x81000005, 0 ); 
1272             return;                                
1273         }
1274                 
1275         
1276         submissionsMetaData[msg.sender] = metaData;
1277         
1278         // everything is ok
1279         SubmitClaim( msg.sender, 0, numShares * difficulty );
1280     }
1281 
1282     function getClaimSeed(address sender) constant returns(uint){
1283         SubmissionMetaData memory metaData = submissionsMetaData[sender];
1284         if( metaData.readyForVerification == 0 ) return 0;
1285         
1286         if( metaData.submissionSeed != 0 ) return metaData.submissionSeed; 
1287         
1288         uint lastBlockNumber = uint(metaData.lastSubmissionBlockNumber);
1289         
1290         if( block.number > lastBlockNumber + 200 ) return 0;
1291         if( block.number <= lastBlockNumber + 15 ) return 0;
1292                 
1293         return uint(block.blockhash(lastBlockNumber + 10));
1294     }
1295     
1296     event StoreClaimSeed( address indexed sender, uint error, uint errorInfo );
1297     function storeClaimSeed( address miner ) {
1298         // anyone who is willing to pay gas fees can call this function
1299         uint seed = getClaimSeed( miner );
1300         if( seed != 0 ) {
1301             submissionsMetaData[miner].submissionSeed = seed;
1302             StoreClaimSeed( msg.sender, 0, uint(miner) );
1303             return;
1304         }
1305         
1306         // else
1307         SubmissionMetaData memory metaData = submissionsMetaData[miner];
1308         uint lastBlockNumber = uint(metaData.lastSubmissionBlockNumber);
1309                 
1310         if( metaData.readyForVerification == 0 ) {
1311             // submission is not ready for verification
1312             StoreClaimSeed( msg.sender, 0x8000000, uint(miner) );
1313         }
1314         else if( block.number > lastBlockNumber + 200 ) {
1315             // submission is not ready for verification
1316             StoreClaimSeed( msg.sender, 0x8000001, uint(miner) );
1317         }
1318         else if( block.number <= lastBlockNumber + 15 ) {
1319             // it is too late to call store function
1320             StoreClaimSeed( msg.sender, 0x8000002, uint(miner) );
1321         }
1322         else {
1323             // unknown error
1324             StoreClaimSeed( msg.sender, 0x8000003, uint(miner) );
1325         }
1326     }
1327 
1328     function verifySubmissionIndex( address sender, uint seed, uint submissionNumber, uint shareIndex ) constant returns(bool) {
1329         if( seed == 0 ) return false;
1330     
1331         uint totalValue = uint(submissionsMetaData[sender].totalSubmissionValue);
1332         uint numPendingSubmissions = uint(submissionsMetaData[sender].numPendingSubmissions);
1333 
1334         SingleSubmissionData memory submissionData = (submissionsData[sender])[submissionNumber];        
1335         
1336         if( submissionNumber >= numPendingSubmissions ) return false;
1337         
1338         uint seed1 = seed & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1339         uint seed2 = seed / (2**128);
1340         
1341         uint selectedValue = seed1 % totalValue;
1342         if( uint(submissionData.totalPreviousSubmissionValue) >= selectedValue ) return false;
1343         if( uint(submissionData.totalPreviousSubmissionValue + submissionData.submissionValue) < selectedValue ) return false;  
1344 
1345         uint expectedShareshareIndex = (seed2 % uint(submissionData.numShares));
1346         if( expectedShareshareIndex != shareIndex ) return false;
1347         
1348         return true;
1349     }
1350     
1351     function calculateSubmissionIndex( address sender, uint seed ) constant returns(uint[2]) {
1352         // this function should be executed off chain - hene, it is not optimized
1353         uint seed1 = seed & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1354         uint seed2 = seed / (2**128);
1355 
1356         uint totalValue = uint(submissionsMetaData[sender].totalSubmissionValue);
1357         uint numPendingSubmissions = uint(submissionsMetaData[sender].numPendingSubmissions);
1358 
1359         uint selectedValue = seed1 % totalValue;
1360         
1361         SingleSubmissionData memory submissionData;        
1362         
1363         for( uint submissionInd = 0 ; submissionInd < numPendingSubmissions ; submissionInd++ ) {
1364             submissionData = (submissionsData[sender])[submissionInd];        
1365             if( uint(submissionData.totalPreviousSubmissionValue + submissionData.submissionValue) >= selectedValue ) break;  
1366         }
1367         
1368         // unexpected error
1369         if( submissionInd == numPendingSubmissions ) return [uint(0xFFFFFFFFFFFFFFFF),0xFFFFFFFFFFFFFFFF];
1370 
1371         uint shareIndex = seed2 % uint(submissionData.numShares); 
1372         
1373         return [submissionInd, shareIndex];
1374     }
1375     
1376     // should be called only from verify claim
1377     function closeSubmission( address sender ) internal {
1378         SubmissionMetaData memory metaData = submissionsMetaData[sender];
1379         metaData.numPendingSubmissions = 0;
1380         metaData.totalSubmissionValue = 0;
1381         metaData.readyForVerification = 0;
1382         metaData.submissionSeed = 0;
1383         
1384         // last counter must not be reset
1385         // last submission block number and difficulty are also kept, but it is not a must
1386         // only to save some gas        
1387         
1388         submissionsMetaData[sender] = metaData;
1389     }
1390     
1391     struct SubmissionDataForClaimVerification {
1392         uint lastCounter;
1393         uint shareDifficulty;
1394         uint totalSubmissionValue;
1395         uint min;
1396         uint max;
1397         uint augMerkle;
1398         
1399         bool indicesAreValid;
1400         bool readyForVerification;
1401     }
1402     
1403     function getClaimData( address sender, uint submissionIndex, uint shareIndex, uint seed )
1404                            constant internal returns(SubmissionDataForClaimVerification){
1405                            
1406         SubmissionDataForClaimVerification memory output;
1407 
1408         SubmissionMetaData memory metaData = submissionsMetaData[sender];
1409         
1410         output.lastCounter = uint(metaData.lastCounter);
1411         output.shareDifficulty = uint(metaData.difficulty);
1412         output.totalSubmissionValue = metaData.totalSubmissionValue;
1413         
1414 
1415         SingleSubmissionData memory submissionData = (submissionsData[sender])[submissionIndex];
1416         
1417         output.min = uint(submissionData.min);
1418         output.max = uint(submissionData.max);
1419         output.augMerkle = uint(submissionData.augRoot);
1420         
1421         output.indicesAreValid = verifySubmissionIndex( sender, seed, submissionIndex, shareIndex );
1422         output.readyForVerification = (metaData.readyForVerification > 0);
1423         
1424         return output; 
1425     }
1426     
1427     function debugGetNumPendingSubmissions( address sender ) constant returns(uint) {
1428         return uint(submissionsMetaData[sender].numPendingSubmissions);
1429     }
1430     
1431     event DebugResetSubmissions( address indexed sender, uint error, uint errorInfo );
1432     function debugResetSubmissions( ) {
1433         // should be called only in emergency
1434         // msg.sender will loose all its pending shares
1435         closeSubmission(msg.sender);
1436         DebugResetSubmissions( msg.sender, 0, 0 );
1437     }    
1438 }
1439 
1440 
1441 contract SmartPool is Agt, WeightedSubmission {    
1442     string  public version = "0.1.1";
1443     
1444     Ethash  public ethashContract; 
1445     address public withdrawalAddress;
1446     mapping(address=>bool) public owners; 
1447     
1448     bool public newVersionReleased = false;
1449         
1450     struct MinerData {
1451         bytes32        minerId;
1452         address        paymentAddress;
1453     }
1454 
1455     mapping(address=>MinerData) minersData;
1456     mapping(bytes32=>bool)      public existingIds;        
1457     
1458     bool public whiteListEnabled;
1459     mapping(address=>bool) whiteList;
1460     
1461     function SmartPool( address[3] _owners,
1462                         Ethash _ethashContract,
1463                         address _withdrawalAddress,
1464                         bool _whiteListEnabeled ) payable {
1465         owners[_owners[0]] = true; 
1466         owners[_owners[1]] = true;
1467         owners[_owners[2]] = true;
1468         
1469         whiteListEnabled = _whiteListEnabeled;
1470         ethashContract = _ethashContract;
1471         withdrawalAddress = _withdrawalAddress;       
1472     }
1473     
1474     function declareNewerVersion() {
1475         if( ! owners[msg.sender] ) throw;
1476         
1477         newVersionReleased = true;
1478         
1479         //if( ! msg.sender.send(this.balance) ) throw;
1480     }
1481     
1482     event Withdraw( address indexed sender, uint error, uint errorInfo );
1483     function withdraw( uint amount ) {
1484         if( ! owners[msg.sender] ) {
1485             // only ownder can withdraw
1486             Withdraw( msg.sender, 0x80000000, amount );
1487             return;
1488         }
1489         
1490         if( ! withdrawalAddress.send( amount ) ) throw;
1491         
1492         Withdraw( msg.sender, 0, amount );            
1493     }
1494     
1495     function to62Encoding( uint id, uint numChars ) constant returns(bytes32) {
1496         if( id >= (26+26+10)**numChars ) throw;
1497         uint result = 0;
1498         for( uint i = 0 ; i < numChars ; i++ ) {
1499             uint b = id % (26+26+10);
1500             uint8 char;
1501             if( b < 10 ) {
1502                 char = uint8(b + 0x30); // 0x30 = '0' 
1503             }
1504             else if( b < 26 + 10 ) {
1505                 char = uint8(b + 0x61 - 10); //0x61 = 'a'
1506             }
1507             else {
1508                 char = uint8(b + 0x41 - 26 - 10); // 0x41 = 'A'         
1509             }
1510             
1511             result = (result * 256) + char;
1512             id /= (26+26+10);
1513         }
1514 
1515         return bytes32(result);
1516     }
1517         
1518     event Register( address indexed sender, uint error, uint errorInfo );    
1519     function register( address paymentAddress ) {
1520         address minerAddress = msg.sender;
1521         
1522         // build id
1523         uint id = uint(minerAddress) % (26+26+10)**11;        
1524         bytes32 minerId = to62Encoding(id,11);
1525         
1526         if( existingIds[minersData[minerAddress].minerId] ) {
1527             // miner id is already in use
1528             Register( msg.sender, 0x80000000, uint(minerId) ); 
1529             return;
1530         }
1531         
1532         if( paymentAddress == address(0) ) {
1533             // payment address is 0
1534             Register( msg.sender, 0x80000001, uint(paymentAddress) ); 
1535             return;
1536         }
1537         
1538         if( whiteListEnabled ) {
1539             if( ! whiteList[ msg.sender ] ) {
1540                 // miner not in white list
1541                 Register( msg.sender, 0x80000002, uint(minerId) );
1542                 return;                 
1543             }
1544         }
1545         
1546         
1547         
1548         // last counter is set to 0. 
1549         // It might be safer to change it to now.
1550         //minersData[minerAddress].lastCounter = now * (2**64);
1551         minersData[minerAddress].paymentAddress = paymentAddress;        
1552         minersData[minerAddress].minerId = minerId;
1553         existingIds[minersData[minerAddress].minerId] = true;
1554         
1555         // succesful registration
1556         Register( msg.sender, 0, 0 ); 
1557     }
1558 
1559     function canRegister(address sender) constant returns(bool) {
1560         uint id = uint(sender) % (26+26+10)**11;
1561         bytes32 expectedId = to62Encoding(id,11);
1562         
1563         if( whiteListEnabled ) {
1564             if( ! whiteList[ sender ] ) return false; 
1565         }
1566         
1567         return ! existingIds[expectedId];
1568     }
1569     
1570     function isRegistered(address sender) constant returns(bool) {
1571         return minersData[sender].paymentAddress != address(0);
1572     }
1573     
1574     function getMinerId(address sender) constant returns(bytes32) {
1575         return minersData[sender].minerId;
1576     }
1577 
1578     event UpdateWhiteList( address indexed miner, uint error, uint errorInfo, bool add );
1579     
1580     function updateWhiteList( address miner, bool add ) {
1581         if( ! owners[ msg.sender ] ) {
1582             // only owner can update list
1583             UpdateWhiteList( msg.sender, 0x80000000, 0, add );
1584             return;
1585         }
1586         if( ! whiteListEnabled ) {
1587             // white list is not enabeled
1588             UpdateWhiteList( msg.sender, 0x80000001, 0, add );        
1589             return;
1590         }
1591         
1592         whiteList[ miner ] = add;
1593         if( ! add && isRegistered( miner ) ) {
1594             // unregister
1595             minersData[miner].paymentAddress = address(0);
1596             existingIds[minersData[miner].minerId] = false;        
1597         }
1598         
1599         UpdateWhiteList( msg.sender, 0, uint(miner), add );
1600     }
1601     
1602     event VerifyExtraData( address indexed sender, uint error, uint errorInfo );    
1603     function verifyExtraData( bytes32 extraData, bytes32 minerId, uint difficulty ) constant internal returns(bool) {
1604         uint i;
1605         // compare id
1606         for( i = 0 ; i < 11 ; i++ ) {
1607             if( extraData[10+i] != minerId[21+i] ) {
1608                 //ErrorLog( "verifyExtraData: miner id not as expected", 0 );
1609                 VerifyExtraData( msg.sender, 0x83000000, uint(minerId) );         
1610                 return false;            
1611             }
1612         }
1613         
1614         // compare difficulty
1615         bytes32 encodedDiff = to62Encoding(difficulty,11);
1616         for( i = 0 ; i < 11 ; i++ ) {
1617             if(extraData[i+21] != encodedDiff[21+i]) {
1618                 //ErrorLog( "verifyExtraData: difficulty is not as expected", uint(encodedDiff) );
1619                 VerifyExtraData( msg.sender, 0x83000001, uint(encodedDiff) );
1620                 return false;            
1621             }  
1622         }
1623                 
1624         return true;            
1625     }    
1626     
1627     event VerifyClaim( address indexed sender, uint error, uint errorInfo );
1628     
1629         
1630     function verifyClaim( bytes rlpHeader,
1631                           uint  nonce,
1632                           uint  submissionIndex,
1633                           uint  shareIndex,
1634                           uint[] dataSetLookup,
1635                           uint[] witnessForLookup,
1636                           uint[] augCountersBranch,
1637                           uint[] augHashesBranch ) {
1638 
1639         if( ! isRegistered(msg.sender) ) {
1640             // miner is not registered
1641             VerifyClaim( msg.sender, 0x8400000c, 0 );
1642             return;         
1643         }
1644 
1645         SubmissionDataForClaimVerification memory submissionData = getClaimData( msg.sender,
1646             submissionIndex, shareIndex, getClaimSeed( msg.sender ) ); 
1647                               
1648         if( ! submissionData.readyForVerification ) {
1649             //ErrorLog( "there are no pending claims", 0 );
1650             VerifyClaim( msg.sender, 0x84000003, 0 );            
1651             return;
1652         }
1653         
1654         BlockHeader memory header = parseBlockHeader(rlpHeader);
1655 
1656         // check extra data
1657         if( ! verifyExtraData( header.extraData,
1658                                minersData[ msg.sender ].minerId,
1659                                submissionData.shareDifficulty ) ) {
1660             //ErrorLog( "extra data not as expected", uint(header.extraData) );
1661             VerifyClaim( msg.sender, 0x84000004, uint(header.extraData) );            
1662             return;                               
1663         }
1664         
1665         // check coinbase data
1666         if( header.coinbase != uint(this) ) {
1667             //ErrorLog( "coinbase not as expected", uint(header.coinbase) );
1668             VerifyClaim( msg.sender, 0x84000005, uint(header.coinbase) );            
1669             return;
1670         }
1671          
1672         
1673         // check counter
1674         uint counter = header.timestamp * (2 ** 64) + nonce;
1675         if( counter < submissionData.min ) {
1676             //ErrorLog( "counter is smaller than min",counter);
1677             VerifyClaim( msg.sender, 0x84000007, counter );            
1678             return;                         
1679         }
1680         if( counter > submissionData.max ) {
1681             //ErrorLog( "counter is smaller than max",counter);
1682             VerifyClaim( msg.sender, 0x84000008, counter );            
1683             return;                         
1684         }
1685         
1686         // verify agt
1687         uint leafHash = uint(sha3(rlpHeader));
1688         VerifyAgtData memory agtData;
1689         agtData.rootHash = submissionData.augMerkle;
1690         agtData.rootMin = submissionData.min;
1691         agtData.rootMax = submissionData.max;
1692         agtData.leafHash = leafHash;
1693         agtData.leafCounter = counter;
1694                 
1695 
1696         if( ! verifyAgt( agtData,
1697                          shareIndex,
1698                          augCountersBranch,
1699                          augHashesBranch ) ) {
1700             //ErrorLog( "verifyAgt failed",0);
1701             VerifyClaim( msg.sender, 0x84000009, 0 );            
1702             return;
1703         }
1704                           
1705         
1706         /*
1707         // check epoch data - done inside hashimoto
1708         if( ! ethashContract.isEpochDataSet( header.blockNumber / 30000 ) ) {
1709             //ErrorLog( "epoch data was not set",header.blockNumber / 30000);
1710             VerifyClaim( msg.sender, 0x8400000a, header.blockNumber / 30000 );                        
1711             return;        
1712         }*/
1713 
1714 
1715         // verify ethash
1716         uint ethash = ethashContract.hashimoto( bytes32(leafHash),
1717                                                 bytes8(nonce),
1718                                                 dataSetLookup,
1719                                                 witnessForLookup,
1720                                                 header.blockNumber / 30000 );
1721         if( ethash > ((2**256-1)/submissionData.shareDifficulty )) {
1722             if( ethash == 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE ) {
1723                 //ErrorLog( "epoch data was not set",header.blockNumber / 30000);
1724                 VerifyClaim( msg.sender, 0x8400000a, header.blockNumber / 30000 );                                        
1725             }
1726             else {
1727                 //ErrorLog( "ethash difficulty too low",ethash);
1728                 VerifyClaim( msg.sender, 0x8400000b, ethash );
1729             }            
1730             return;        
1731         }
1732         
1733         if( getClaimSeed(msg.sender) == 0 ) {
1734             //ErrorLog( "claim seed is 0", 0 );
1735             VerifyClaim( msg.sender, 0x84000001, 0 );
1736             return;        
1737         }
1738         
1739         if( ! submissionData.indicesAreValid ) {
1740             //ErrorLog( "share index or submission are not as expected. should be:", getShareIndex() );
1741             VerifyClaim( msg.sender, 0x84000002, 0 );
1742             return;                
1743         } 
1744         
1745         // recrusive attack is not possible as doPayment is using send and not call.
1746         if( ! doPayment(submissionData.totalSubmissionValue,
1747                         minersData[ msg.sender ].paymentAddress) ) {
1748             // error msg is given in doPayment function
1749             return;
1750         }
1751         
1752         closeSubmission( msg.sender );
1753         //minersData[ msg.sender ].pendingClaim = false;
1754         
1755         
1756         VerifyClaim( msg.sender, 0, 0 );                        
1757         
1758         
1759         return;
1760     }    
1761     
1762 
1763     // 10000 = 100%
1764     uint public uncleRate = 500; // 5%
1765     // 10000 = 100%
1766     uint public poolFees = 0;
1767 
1768 
1769     event IncomingFunds( address sender, uint amountInWei );
1770     function() payable {
1771         IncomingFunds( msg.sender, msg.value );
1772     }
1773 
1774     event SetUnlceRateAndFees( address indexed sender, uint error, uint errorInfo );
1775     function setUnlceRateAndFees( uint _uncleRate, uint _poolFees ) {
1776         if( ! owners[msg.sender] ) {
1777             // only owner should change rates
1778             SetUnlceRateAndFees( msg.sender, 0x80000000, 0 );
1779             return;
1780         }
1781         
1782         uncleRate = _uncleRate;
1783         poolFees = _poolFees;
1784         
1785         SetUnlceRateAndFees( msg.sender, 0, 0 );
1786     }
1787         
1788     event DoPayment( address indexed sender, address paymentAddress, uint valueInWei );
1789     function doPayment( uint submissionValue,
1790                         address paymentAddress ) internal returns(bool) {
1791 
1792         uint payment = submissionValue;
1793         // take uncle rate into account
1794         
1795         // payment = payment * (1-0.25*uncleRate)
1796         // uncleRate in [0,10000]
1797         payment = (payment * (4*10000 - uncleRate)) / (4*10000);
1798         
1799         // fees
1800         payment = (payment * (10000 - poolFees)) / 10000;
1801 
1802         if( payment > this.balance ){
1803             //ErrorLog( "cannot afford to pay", calcPayment( submissionData.numShares, submissionData.difficulty ) );
1804             VerifyClaim( msg.sender, 0x84000000, payment );        
1805             return false;
1806         }
1807                 
1808         if( ! paymentAddress.send( payment ) ) throw;
1809         
1810         DoPayment( msg.sender, paymentAddress, payment ); 
1811         
1812         return true;
1813     }
1814     
1815     function getPoolETHBalance( ) constant returns(uint) {
1816         // debug function for testrpc
1817         return this.balance;
1818     }
1819 
1820     event GetShareIndexDebugForTestRPCSubmissionIndex( uint index );    
1821     event GetShareIndexDebugForTestRPCShareIndex( uint index );
1822      
1823     function getShareIndexDebugForTestRPC( address sender ) {
1824         uint seed = getClaimSeed( sender );
1825         uint[2] memory result = calculateSubmissionIndex( sender, seed );
1826         
1827         GetShareIndexDebugForTestRPCSubmissionIndex( result[0] );
1828         GetShareIndexDebugForTestRPCShareIndex( result[1] );        
1829             
1830     }        
1831 }