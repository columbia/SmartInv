1 contract SHA3_512 {
2     function SHA3_512() public {}
3 
4     function keccak_f(uint[25] A) pure internal returns(uint[25]) {
5         uint[5] memory C;
6         uint[5] memory D;
7         //uint x;
8         //uint y;
9         //uint D_0; uint D_1; uint D_2; uint D_3; uint D_4;
10         uint[25] memory B;
11 
12         uint[24] memory RC= [
13                    uint(0x0000000000000001),
14                    0x0000000000008082,
15                    0x800000000000808A,
16                    0x8000000080008000,
17                    0x000000000000808B,
18                    0x0000000080000001,
19                    0x8000000080008081,
20                    0x8000000000008009,
21                    0x000000000000008A,
22                    0x0000000000000088,
23                    0x0000000080008009,
24                    0x000000008000000A,
25                    0x000000008000808B,
26                    0x800000000000008B,
27                    0x8000000000008089,
28                    0x8000000000008003,
29                    0x8000000000008002,
30                    0x8000000000000080,
31                    0x000000000000800A,
32                    0x800000008000000A,
33                    0x8000000080008081,
34                    0x8000000000008080,
35                    0x0000000080000001,
36                    0x8000000080008008 ];
37 
38         for( uint i = 0 ; i < 24 ; i++ ) {
39             /*
40             for( x = 0 ; x < 5 ; x++ ) {
41                 C[x] = A[5*x]^A[5*x+1]^A[5*x+2]^A[5*x+3]^A[5*x+4];
42             }*/
43 
44             C[0]=A[0]^A[1]^A[2]^A[3]^A[4];
45             C[1]=A[5]^A[6]^A[7]^A[8]^A[9];
46             C[2]=A[10]^A[11]^A[12]^A[13]^A[14];
47             C[3]=A[15]^A[16]^A[17]^A[18]^A[19];
48             C[4]=A[20]^A[21]^A[22]^A[23]^A[24];
49 
50             /*
51             for( x = 0 ; x < 5 ; x++ ) {
52                 D[x] = C[(x+4)%5]^((C[(x+1)%5] * 2)&0xffffffffffffffff | (C[(x+1)%5]/(2**63)));
53             }*/
54 
55 
56             D[0]=C[4] ^ ((C[1] * 2)&0xffffffffffffffff | (C[1] / (2 ** 63)));
57             D[1]=C[0] ^ ((C[2] * 2)&0xffffffffffffffff | (C[2] / (2 ** 63)));
58             D[2]=C[1] ^ ((C[3] * 2)&0xffffffffffffffff | (C[3] / (2 ** 63)));
59             D[3]=C[2] ^ ((C[4] * 2)&0xffffffffffffffff | (C[4] / (2 ** 63)));
60             D[4]=C[3] ^ ((C[0] * 2)&0xffffffffffffffff | (C[0] / (2 ** 63)));
61 
62             /*
63             for( x = 0 ; x < 5 ; x++ ) {
64                 for( y = 0 ; y < 5 ; y++ ) {
65                     A[5*x+y] = A[5*x+y] ^ D[x];
66                 }
67             }*/
68 
69 
70 
71             A[0]=A[0] ^ D[0];
72             A[1]=A[1] ^ D[0];
73             A[2]=A[2] ^ D[0];
74             A[3]=A[3] ^ D[0];
75             A[4]=A[4] ^ D[0];
76             A[5]=A[5] ^ D[1];
77             A[6]=A[6] ^ D[1];
78             A[7]=A[7] ^ D[1];
79             A[8]=A[8] ^ D[1];
80             A[9]=A[9] ^ D[1];
81             A[10]=A[10] ^ D[2];
82             A[11]=A[11] ^ D[2];
83             A[12]=A[12] ^ D[2];
84             A[13]=A[13] ^ D[2];
85             A[14]=A[14] ^ D[2];
86             A[15]=A[15] ^ D[3];
87             A[16]=A[16] ^ D[3];
88             A[17]=A[17] ^ D[3];
89             A[18]=A[18] ^ D[3];
90             A[19]=A[19] ^ D[3];
91             A[20]=A[20] ^ D[4];
92             A[21]=A[21] ^ D[4];
93             A[22]=A[22] ^ D[4];
94             A[23]=A[23] ^ D[4];
95             A[24]=A[24] ^ D[4];
96 
97             /*Rho and pi steps*/
98             B[0]=A[0];
99             B[8]=((A[1] * (2 ** 36))&0xffffffffffffffff | (A[1] / (2 ** 28)));
100             B[11]=((A[2] * (2 ** 3))&0xffffffffffffffff | (A[2] / (2 ** 61)));
101             B[19]=((A[3] * (2 ** 41))&0xffffffffffffffff | (A[3] / (2 ** 23)));
102             B[22]=((A[4] * (2 ** 18))&0xffffffffffffffff | (A[4] / (2 ** 46)));
103             B[2]=((A[5] * (2 ** 1))&0xffffffffffffffff | (A[5] / (2 ** 63)));
104             B[5]=((A[6] * (2 ** 44))&0xffffffffffffffff | (A[6] / (2 ** 20)));
105             B[13]=((A[7] * (2 ** 10))&0xffffffffffffffff | (A[7] / (2 ** 54)));
106             B[16]=((A[8] * (2 ** 45))&0xffffffffffffffff | (A[8] / (2 ** 19)));
107             B[24]=((A[9] * (2 ** 2))&0xffffffffffffffff | (A[9] / (2 ** 62)));
108             B[4]=((A[10] * (2 ** 62))&0xffffffffffffffff | (A[10] / (2 ** 2)));
109             B[7]=((A[11] * (2 ** 6))&0xffffffffffffffff | (A[11] / (2 ** 58)));
110             B[10]=((A[12] * (2 ** 43))&0xffffffffffffffff | (A[12] / (2 ** 21)));
111             B[18]=((A[13] * (2 ** 15))&0xffffffffffffffff | (A[13] / (2 ** 49)));
112             B[21]=((A[14] * (2 ** 61))&0xffffffffffffffff | (A[14] / (2 ** 3)));
113             B[1]=((A[15] * (2 ** 28))&0xffffffffffffffff | (A[15] / (2 ** 36)));
114             B[9]=((A[16] * (2 ** 55))&0xffffffffffffffff | (A[16] / (2 ** 9)));
115             B[12]=((A[17] * (2 ** 25))&0xffffffffffffffff | (A[17] / (2 ** 39)));
116             B[15]=((A[18] * (2 ** 21))&0xffffffffffffffff | (A[18] / (2 ** 43)));
117             B[23]=((A[19] * (2 ** 56))&0xffffffffffffffff | (A[19] / (2 ** 8)));
118             B[3]=((A[20] * (2 ** 27))&0xffffffffffffffff | (A[20] / (2 ** 37)));
119             B[6]=((A[21] * (2 ** 20))&0xffffffffffffffff | (A[21] / (2 ** 44)));
120             B[14]=((A[22] * (2 ** 39))&0xffffffffffffffff | (A[22] / (2 ** 25)));
121             B[17]=((A[23] * (2 ** 8))&0xffffffffffffffff | (A[23] / (2 ** 56)));
122             B[20]=((A[24] * (2 ** 14))&0xffffffffffffffff | (A[24] / (2 ** 50)));
123 
124             /*Xi state*/
125             /*
126             for( x = 0 ; x < 5 ; x++ ) {
127                 for( y = 0 ; y < 5 ; y++ ) {
128                     A[5*x+y] = B[5*x+y]^((~B[5*((x+1)%5)+y]) & B[5*((x+2)%5)+y]);
129                 }
130             }*/
131 
132 
133             A[0]=B[0]^((~B[5]) & B[10]);
134             A[1]=B[1]^((~B[6]) & B[11]);
135             A[2]=B[2]^((~B[7]) & B[12]);
136             A[3]=B[3]^((~B[8]) & B[13]);
137             A[4]=B[4]^((~B[9]) & B[14]);
138             A[5]=B[5]^((~B[10]) & B[15]);
139             A[6]=B[6]^((~B[11]) & B[16]);
140             A[7]=B[7]^((~B[12]) & B[17]);
141             A[8]=B[8]^((~B[13]) & B[18]);
142             A[9]=B[9]^((~B[14]) & B[19]);
143             A[10]=B[10]^((~B[15]) & B[20]);
144             A[11]=B[11]^((~B[16]) & B[21]);
145             A[12]=B[12]^((~B[17]) & B[22]);
146             A[13]=B[13]^((~B[18]) & B[23]);
147             A[14]=B[14]^((~B[19]) & B[24]);
148             A[15]=B[15]^((~B[20]) & B[0]);
149             A[16]=B[16]^((~B[21]) & B[1]);
150             A[17]=B[17]^((~B[22]) & B[2]);
151             A[18]=B[18]^((~B[23]) & B[3]);
152             A[19]=B[19]^((~B[24]) & B[4]);
153             A[20]=B[20]^((~B[0]) & B[5]);
154             A[21]=B[21]^((~B[1]) & B[6]);
155             A[22]=B[22]^((~B[2]) & B[7]);
156             A[23]=B[23]^((~B[3]) & B[8]);
157             A[24]=B[24]^((~B[4]) & B[9]);
158 
159             /*Last step*/
160             A[0]=A[0]^RC[i];
161         }
162 
163 
164         return A;
165     }
166 
167 
168     function sponge(uint[9] M) pure internal returns(uint[16]) {
169         require( (M.length * 8) == 72 );
170         M[8] = 0x8000000000000001;
171 
172         uint r = 72;
173         uint w = 8;
174         uint size = M.length * 8;
175 
176         uint[25] memory S;
177         uint i; uint y; uint x;
178         /*Absorbing Phase*/
179         for( i = 0 ; i < size/r ; i++ ) {
180             for( y = 0 ; y < 5 ; y++ ) {
181                 for( x = 0 ; x < 5 ; x++ ) {
182                     if( (x+5*y) < (r/w) ) {
183                         S[5*x+y] = S[5*x+y] ^ M[i*9 + x + 5*y];
184                     }
185                 }
186             }
187             S = keccak_f(S);
188         }
189 
190         /*Squeezing phase*/
191         uint[16] memory result;
192         uint b = 0;
193         while( b < 16 ) {
194             for( y = 0 ; y < 5 ; y++ ) {
195                 for( x = 0 ; x < 5 ; x++ ) {
196                     if( (x+5*y)<(r/w) && (b<16) ) {
197                         result[b] = S[5*x+y] & 0xFFFFFFFF;
198                         result[b+1] = S[5*x+y] / 0x100000000;
199                         b+=2;
200                     }
201                 }
202             }
203         }
204 
205         return result;
206    }
207 
208    function hash(uint64[8] input) pure internal returns(uint32[16] output) {
209 
210        uint i;
211        uint[9] memory M;
212        for(i = 0 ; i < 8 ; i++) {
213            M[i] = uint(input[i]);
214        }
215 
216        uint[16] memory result = sponge(M);
217 
218        for(i = 0 ; i < 16 ; i++) {
219            output[i] = uint32(result[i]);
220        }
221    }
222 
223 }
224 
225 
226 contract TeikhosBounty is SHA3_512 {
227 
228     // Proof-of-public-key in format 2xbytes32, to support xor operator and ecrecover r, s v format
229     bytes32 proof_of_public_key1 = hex"bd7c2d389d79b574152c3d9d98e8671a4552f0c0c0e389460eb4e16df173faba";
230     bytes32 proof_of_public_key2 = hex"fe0238309e6e2ee8e4fd0efbcecf0969c8a1084fab7137b124c830ecb016c936";
231     
232     function authenticate(bytes _publicKey) public { // Accepts an array of bytes, for example ["0x00","0xaa", "0xff"]
233 
234         // Get address from public key
235         address signer = address(keccak256(_publicKey));
236 
237         require(signer == msg.sender);
238 
239         // Use SHA3_512 library to get a sha3_512 hash of public key
240 
241         uint64[8] memory input;
242 
243         // The evm is big endian, have to reverse the bytes
244 
245         bytes memory reversed = new bytes(64);
246 
247         for(uint i = 0; i < 64; i++) {
248             reversed[i] = _publicKey[63 - i];
249         }
250 
251         for(i = 0; i < 8; i++) {
252             bytes8 oneEigth;
253             // Load 8 byte from reversed public key at position 32 + i * 8
254             assembly {
255                 oneEigth := mload(add(reversed, add(32, mul(i, 8)))) 
256             }
257             input[7 - i] = uint64(oneEigth);
258         }
259 
260         uint32[16] memory output = hash(input);
261         
262         bytes memory reverseHash = new bytes(64);
263         
264         for(i = 0; i < 16; i++) {
265             bytes4 oneSixteenth = bytes4(output[15 - i]);
266             // Store 4 byte in keyHash at position 32 + i * 4
267             assembly { mstore(add(reverseHash, add(32, mul(i, 4))), oneSixteenth) }
268         }
269 
270         bytes memory keyHash = new bytes(64);
271 
272         for(i = 0; i < 64; i++) {
273             keyHash[i] = reverseHash[63 - i];
274         }
275 
276         // Split hash of public key in 2xbytes32, to support xor operator and ecrecover r, s v format
277 
278         bytes32 hash1;
279         bytes32 hash2;
280 
281         assembly {
282         hash1 := mload(add(keyHash,0x20))
283         hash2 := mload(add(keyHash,0x40))
284         }
285 
286         // Use xor (reverse cipher) to get signature in r, s v format
287         bytes32 r = proof_of_public_key1 ^ hash1;
288         bytes32 s = proof_of_public_key2 ^ hash2;
289 
290         // Get msgHash for use with ecrecover
291         bytes32 msgHash = keccak256("\x19Ethereum Signed Message:\n64", _publicKey);
292 
293         // The value v is not known, try both 27 and 28
294         if(ecrecover(msgHash, 27, r, s) == signer) selfdestruct(msg.sender);
295         if(ecrecover(msgHash, 28, r, s) == signer) selfdestruct(msg.sender);
296     }
297     
298     function() public payable {}
299 
300 }