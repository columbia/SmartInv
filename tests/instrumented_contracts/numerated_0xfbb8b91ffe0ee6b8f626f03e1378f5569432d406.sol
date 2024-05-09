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