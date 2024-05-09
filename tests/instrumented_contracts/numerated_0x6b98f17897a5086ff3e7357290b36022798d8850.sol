1 pragma solidity ^0.4.13;
2 /**
3 // This file is MIT Licensed.
4 //
5 // Copyright 2017 Christian Reitwiessner
6 // Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
7 // The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
8 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
9 */
10 library Pairing {
11 struct G1Point {
12 uint X;
13 uint Y;
14 }
15 // Encoding of field elements is: X[0] * z + X[1]
16 struct G2Point {
17 uint[2] X;
18 uint[2] Y;
19 }
20 /// @return the generator of G1
21 function P1() pure internal returns (G1Point) {
22 return G1Point(1, 2);
23 }
24 /// @return the generator of G2
25 function P2() pure internal returns (G2Point) {
26 return G2Point(
27 [11559732032986387107991004021392285783925812861821192530917403151452391805634,
28 10857046999023057135944570762232829481370756359578518086990519993285655852781],
29 [4082367875863433681332203403145435568316851327593401208105741076214120093531,
30 8495653923123431417604973247489272438418190587263600148770280649306958101930]
31 );
32 }
33 /// @return the negation of p, i.e. p.addition(p.negate()) should be zero.
34 function negate(G1Point p) pure internal returns (G1Point) {
35 // The prime q in the base field F_q for G1
36 uint q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
37 if (p.X == 0 && p.Y == 0)
38 return G1Point(0, 0);
39 return G1Point(p.X, q - (p.Y % q));
40 }
41 /// @return the sum of two points of G1
42 function addition(G1Point p1, G1Point p2) internal returns (G1Point r) {
43 uint[4] memory input;
44 input[0] = p1.X;
45 input[1] = p1.Y;
46 input[2] = p2.X;
47 input[3] = p2.Y;
48 bool success;
49 assembly {
50 success := call(sub(gas, 2000), 6, 0, input, 0xc0, r, 0x60)
51 // Use "invalid" to make gas estimation work
52 switch success case 0 { invalid() }
53 }
54 require(success);
55 }
56 /// @return the product of a point on G1 and a scalar, i.e.
57 /// p == p.scalar_mul(1) and p.addition(p) == p.scalar_mul(2) for all points p.
58 function scalar_mul(G1Point p, uint s) internal returns (G1Point r) {
59 uint[3] memory input;
60 input[0] = p.X;
61 input[1] = p.Y;
62 input[2] = s;
63 bool success;
64 assembly {
65 success := call(sub(gas, 2000), 7, 0, input, 0x80, r, 0x60)
66 // Use "invalid" to make gas estimation work
67 switch success case 0 { invalid() }
68 }
69 require (success);
70 }
71 /// @return the result of computing the pairing check
72 /// e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
73 /// For example pairing([P1(), P1().negate()], [P2(), P2()]) should
74 /// return true.
75 function pairing(G1Point[] p1, G2Point[] p2) internal returns (bool) {
76 require(p1.length == p2.length);
77 uint elements = p1.length;
78 uint inputSize = elements * 6;
79 uint[] memory input = new uint[](inputSize);
80 for (uint i = 0; i < elements; i++)
81 {
82 input[i * 6 + 0] = p1[i].X;
83 input[i * 6 + 1] = p1[i].Y;
84 input[i * 6 + 2] = p2[i].X[0];
85 input[i * 6 + 3] = p2[i].X[1];
86 input[i * 6 + 4] = p2[i].Y[0];
87 input[i * 6 + 5] = p2[i].Y[1];
88 }
89 uint[1] memory out;
90 bool success;
91 assembly {
92 success := call(sub(gas, 2000), 8, 0, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
93 // Use "invalid" to make gas estimation work
94 switch success case 0 { invalid() }
95 }
96 require(success);
97 return out[0] != 0;
98 }
99 /// Convenience method for a pairing check for two pairs.
100 function pairingProd2(G1Point a1, G2Point a2, G1Point b1, G2Point b2) internal returns (bool) {
101 G1Point[] memory p1 = new G1Point[](2);
102 G2Point[] memory p2 = new G2Point[](2);
103 p1[0] = a1;
104 p1[1] = b1;
105 p2[0] = a2;
106 p2[1] = b2;
107 return pairing(p1, p2);
108 }
109 /// Convenience method for a pairing check for three pairs.
110 function pairingProd3(
111 G1Point a1, G2Point a2,
112 G1Point b1, G2Point b2,
113 G1Point c1, G2Point c2
114 ) internal returns (bool) {
115 G1Point[] memory p1 = new G1Point[](3);
116 G2Point[] memory p2 = new G2Point[](3);
117 p1[0] = a1;
118 p1[1] = b1;
119 p1[2] = c1;
120 p2[0] = a2;
121 p2[1] = b2;
122 p2[2] = c2;
123 return pairing(p1, p2);
124 }
125 /// Convenience method for a pairing check for four pairs.
126 function pairingProd4(
127 G1Point a1, G2Point a2,
128 G1Point b1, G2Point b2,
129 G1Point c1, G2Point c2,
130 G1Point d1, G2Point d2
131 ) internal returns (bool) {
132 G1Point[] memory p1 = new G1Point[](4);
133 G2Point[] memory p2 = new G2Point[](4);
134 p1[0] = a1;
135 p1[1] = b1;
136 p1[2] = c1;
137 p1[3] = d1;
138 p2[0] = a2;
139 p2[1] = b2;
140 p2[2] = c2;
141 p2[3] = d2;
142 return pairing(p1, p2);
143 }
144 }
145 
146 
147 
148 
149 contract Verifier {
150 using Pairing for *;
151 struct VerifyingKey {
152 Pairing.G2Point A;
153 Pairing.G1Point B;
154 Pairing.G2Point C;
155 Pairing.G2Point gamma;
156 Pairing.G1Point gammaBeta1;
157 Pairing.G2Point gammaBeta2;
158 Pairing.G2Point Z;
159 Pairing.G1Point[] IC;
160 }
161 struct Proof {
162 Pairing.G1Point A;
163 Pairing.G1Point A_p;
164 Pairing.G2Point B;
165 Pairing.G1Point B_p;
166 Pairing.G1Point C;
167 Pairing.G1Point C_p;
168 Pairing.G1Point K;
169 Pairing.G1Point H;
170 }
171 //uint[] vector; //not used - replaced by a mapping
172 //Pairing.G1Point vk_x = Pairing.G1Point(0, 0); //not used - replaced by a mapping
173 //VerifyingKey private vk; //not used - replaced by a mapping
174 mapping(address => VerifyingKey) private vks;
175 mapping(address => uint[]) private vectors;
176 mapping(address => Pairing.G1Point) private vk_xs;
177 
178 
179 
180 
181 function setKeyLength(uint l) public {
182 vks[msg.sender].IC.length = l;
183 vectors[msg.sender].length = l-1;
184 }
185 
186 
187 
188 
189 function loadVerifyingKeyPreamble(
190 uint[2][2] A,
191 uint[2] B,
192 uint[2][2] C,
193 uint[2][2] gamma,
194 uint[2] gammaBeta1,
195 uint[2][2] gammaBeta2,
196 uint[2][2] Z
197 ) public {
198 /**
199 @notice © Copyright 2018 EYGS LLP and/or other members of the global Ernst & Young/EY network; pat. pending.
200 */
201 vks[msg.sender].A = Pairing.G2Point([A[0][0],A[0][1]],[A[1][0],A[1][1]]);
202 vks[msg.sender].B = Pairing.G1Point(B[0],B[1]);
203 vks[msg.sender].C = Pairing.G2Point([C[0][0],C[0][1]],[C[1][0],C[1][1]]);
204 vks[msg.sender].gamma = Pairing.G2Point([gamma[0][0],gamma[0][1]],[gamma[1][0],gamma[1][1]]);
205 vks[msg.sender].gammaBeta1 = Pairing.G1Point(gammaBeta1[0],gammaBeta1[1]);
206 vks[msg.sender].gammaBeta2 = Pairing.G2Point([gammaBeta2[0][0],gammaBeta2[0][1]],[gammaBeta2[1][0],gammaBeta2[1][1]]);
207 vks[msg.sender].Z = Pairing.G2Point([Z[0][0],Z[0][1]],[Z[1][0],Z[1][1]]);
208 //this seems a good place to initialise the vk_x computation
209 vk_xs[msg.sender] = Pairing.G1Point(0, 0); //initialise
210 
211 
212 
213 
214 }
215 
216 
217 
218 
219 function loadVerifyingKey(uint[2][] points, uint start) public{
220 /**
221 @notice © Copyright 2018 EYGS LLP and/or other members of the global Ernst & Young/EY network; pat. pending.
222 */
223 //vk_xs[addr].X =0; vk_x.Y=0; //reset the vk_x computation for next time
224 for (uint i=0; i<points.length; i++){
225 vks[msg.sender].IC[i+start] = Pairing.G1Point(points[i][0],points[i][1]);
226 }
227 }
228 
229 
230 
231 
232 function loadInputVector(uint[] inp, uint start) public {
233 /**
234 @notice © Copyright 2018 EYGS LLP and/or other members of the global Ernst & Young/EY network; pat. pending.
235 */
236 //vk_x.X =0; vk_x.Y=0; //reset the vk_x computation for next time
237 for (uint i=0; i<inp.length; i++){
238 vectors[msg.sender][i+start] = inp[i];
239 }
240 }
241 /**
242 function to get 64 bits from vector and turn it into a bytes8
243 */
244 function getInputBits(uint start, address addr) public view returns(bytes8 param) {
245 /**
246 @notice © Copyright 2018 EYGS LLP and/or other members of the global Ernst & Young/EY network; pat. pending.
247 */
248 param = 0x0; bytes8 b = bytes8(1);
249 for (uint i=0; i<64; i++){
250 if (vectors[addr][i+start] == 1) param = param | (b<<(63-i));
251 }
252 return param;
253 }
254 
255 
256 
257 
258 function computeVkx(uint start, uint end) public {
259 /**
260 @notice © Copyright 2018 EYGS LLP and/or other members of the global Ernst & Young/EY network; pat. pending.
261 */
262 //end needs to be < vector.length
263 for (uint i = start; i < end; i++)
264 vk_xs[msg.sender] = Pairing.addition(vk_xs[msg.sender], Pairing.scalar_mul(vks[msg.sender].IC[i + 1], vectors[msg.sender][i]));
265 }
266 
267 
268 
269 
270 function getAddress() public returns(address){
271 return address(this);
272 }
273 
274 
275 
276 
277 function verify(Proof proof, address addr) internal returns (uint) {
278 require(vectors[addr].length + 1 == vks[addr].IC.length);
279 // Compute the linear combination vk_x
280 vk_xs[addr] = Pairing.addition(vk_xs[addr], vks[addr].IC[0]);
281 if (!Pairing.pairingProd2(proof.A, vks[addr].A, Pairing.negate(proof.A_p), Pairing.P2())) return 1;
282 if (!Pairing.pairingProd2(vks[addr].B, proof.B, Pairing.negate(proof.B_p), Pairing.P2())) return 2;
283 if (!Pairing.pairingProd2(proof.C, vks[addr].C, Pairing.negate(proof.C_p), Pairing.P2())) return 3;
284 if (!Pairing.pairingProd3(
285 proof.K, vks[addr].gamma,
286 Pairing.negate(Pairing.addition(vk_xs[addr], Pairing.addition(proof.A, proof.C))), vks[addr].gammaBeta2,
287 Pairing.negate(vks[addr].gammaBeta1), proof.B
288 )) return 4;
289 if (!Pairing.pairingProd3(
290 Pairing.addition(vk_xs[addr], proof.A), proof.B,
291 Pairing.negate(proof.H), vks[addr].Z,
292 Pairing.negate(proof.C), Pairing.P2()
293 )) return 5;
294 return 0;
295 }
296 // @dev Fired by function verifyTx
297 // @param _decodeFlag = dec0de
298 // @param _verified A message to output through this event
299 event Verified(bytes4 indexed _decodeFlag, bytes32 indexed _verified);
300 
301 
302 
303 
304 function verifyTx(
305 uint[2] a,
306 uint[2] a_p,
307 uint[2][2] b,
308 uint[2] b_p,
309 uint[2] c,
310 uint[2] c_p,
311 uint[2] h,
312 uint[2] k,
313 address addr
314 ) public returns (bool r) {
315 Proof memory proof;
316 proof.A = Pairing.G1Point(a[0], a[1]);
317 proof.A_p = Pairing.G1Point(a_p[0], a_p[1]);
318 proof.B = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
319 proof.B_p = Pairing.G1Point(b_p[0], b_p[1]);
320 proof.C = Pairing.G1Point(c[0], c[1]);
321 proof.C_p = Pairing.G1Point(c_p[0], c_p[1]);
322 proof.H = Pairing.G1Point(h[0], h[1]);
323 proof.K = Pairing.G1Point(k[0], k[1]);
324 bytes4 decodeFlag = 0xdec0de; // flag to tell humans that _verified is a hex encoding of an ascii string
325 bytes32 verified; // a hex encoding of a string - returned by event Verified
326 if (verify(proof, addr) == 0) {
327 vk_xs[addr].X =0; vk_xs[addr].Y=0; //reset the vk_x computation for next time
328 verified = 0x4559204f7073636861696e202d20547820566572696669656421203a29; //"EY Opschain - Tx Verified! :)" in hex
329 emit Verified(decodeFlag, verified);
330 return true;
331 } else {
332 vk_xs[addr].X =0; vk_xs[addr].Y=0; //reset the vk_x computation for next time
333 verified = 0x4559204f7073636861696e202d205478204e4f54205665726966696564203a28; //"EY Opschain - Tx NOT Verified :(" in hex
334 emit Verified(decodeFlag, verified);
335 return false;
336 }
337 }
338 }