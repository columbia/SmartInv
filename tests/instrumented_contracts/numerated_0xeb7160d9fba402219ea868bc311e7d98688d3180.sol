1 pragma solidity ^0.4.13;
2 
3 
4 
5 
6 contract Verifier{
7 function verifyTx(
8 uint[2],
9 uint[2],
10 uint[2][2],
11 uint[2],
12 uint[2],
13 uint[2],
14 uint[2],
15 uint[2],
16 address
17 ) public pure returns (bool){}
18 
19 
20 
21 
22 /**
23 @notice © Copyright 2018 EYGS LLP and/or other members of the global Ernst & Young/EY network; pat. pending.
24 */
25 function getInputBits(uint, address) public view returns(bytes8){}
26 }
27 
28 
29 
30 
31 contract TokenShield{
32 
33 
34 
35 
36 /**
37 @notice © Copyright 2018 EYGS LLP and/or other members of the global Ernst & Young/EY network; pat. pending.
38 
39 
40 
41 
42 Contract to enable the management of hidden non fungible toke transactions.
43 */
44 
45 
46 
47 
48 address public owner;
49 bytes8[merkleWidth] private ns; //store spent token nullifiers
50 bytes8[merkleWidth] private ds; //store the double-spend prevention hashes
51 uint constant merkleWidth = 256;
52 uint constant merkleDepth = 9;
53 uint constant lastRow = merkleDepth-1;
54 bytes8[merkleWidth] private zs; //array holding the tokens.  Basically the bottom row of the merkle tree
55 uint private zCount; //remember the number of tokens we hold
56 uint private nCount; //remember the number of tokens we spent
57 bytes8[] private roots; //holds each root we've calculated so that we can pull the one relevant to the prover
58 uint public currentRootIndex; //holds the index for the current root so that the
59 //prover can provide it later and this contract can look up the relevant root
60 Verifier mv; //the verification smart contract that the mint function uses
61 Verifier tv; //the verification smart contract that the transfer function uses
62 Verifier jv; //the verification smart contract that the join function uses
63 Verifier sv; //the verification smart contract that the split function uses
64 //uint i; //just a loop counter, should be local but moved here to preserve stack space
65 struct Proof { //recast this as a struct because otherwise, as a set of local variable, it takes too much stack space
66 uint[2] a;
67 uint[2] a_p;
68 uint[2][2] b;
69 uint[2] b_p;
70 uint[2] c;
71 uint[2] c_p;
72 uint[2] h;
73 uint[2] k;
74 }
75 
76 
77 
78 
79 mapping(address => Proof) private proofs;
80 
81 
82 
83 
84 constructor(address mintVerifier, address transferVerifier, address joinVerifier, address splitVerifier) public {
85 //TODO - you can get a way with a single, generic verifier.
86 owner = msg.sender;
87 mv = Verifier(mintVerifier);
88 tv = Verifier(transferVerifier);
89 jv = Verifier(joinVerifier);
90 sv = Verifier(splitVerifier);
91 }
92 
93 
94 
95 
96 
97 
98 
99 
100 //only owner  modifier
101 modifier onlyOwner () {
102 require(msg.sender == owner);
103 _;
104 }
105 
106 
107 
108 
109 /**
110 self destruct added by westlad
111 */
112 function close() public onlyOwner {
113 selfdestruct(owner);
114 }
115 
116 
117 
118 
119 
120 
121 
122 
123 function getMintVerifier() public view returns(address){
124 return address(mv);
125 }
126 
127 
128 
129 
130 function getTransferVerifier() public view returns(address){
131 return address(tv);
132 }
133 
134 
135 
136 
137 function getJoinVerifier() public view returns(address){
138 return address(jv);
139 }
140 
141 
142 
143 
144 function getSplitVerifier() public view returns(address){
145 return address(sv);
146 }
147 
148 
149 
150 
151 /**
152 The mint function accepts a Preventifier, H(A), where A is the assetHash; a
153 Z token and a proof that both the token and the Preventifier contain A.
154 It's done as an array because the stack on EVM is too small to hold all the locals otherwise.
155 For the same reason, the proof is set up by calling setProofParams first.
156 */
157 function mint() public {
158 //first, verify the proof
159 bool result = mv.verifyTx(
160 proofs[msg.sender].a,
161 proofs[msg.sender].a_p,
162 proofs[msg.sender].b,
163 proofs[msg.sender].b_p,
164 proofs[msg.sender].c,
165 proofs[msg.sender].c_p,
166 proofs[msg.sender].h,
167 proofs[msg.sender].k,
168 msg.sender);
169 
170 
171 
172 
173 require(result); //the proof must check out.
174 bytes8 d = mv.getInputBits(0, msg.sender); //recover the input params from MintVerifier
175 bytes8 z = mv.getInputBits(64, msg.sender);
176 for (uint i=0; i<zCount; i++) { //check the preventifier doesn't exist
177 require(ds[i]!= d);
178 }
179 zs[zCount] = z; //add the commitment
180 ds[zCount++] = d; //add the preventifier
181 bytes8 root = merkle(0,0); //work out the Merkle root as it's now different
182 currentRootIndex = roots.push(root)-1; //and save it to the list
183 }
184 
185 
186 
187 
188 /**
189 The transfer function transfers a commitment to a new owner
190 */
191 function transfer() public {
192 bool result = tv.verifyTx(
193 proofs[msg.sender].a,
194 proofs[msg.sender].a_p,
195 proofs[msg.sender].b,
196 proofs[msg.sender].b_p,
197 proofs[msg.sender].c,
198 proofs[msg.sender].c_p,
199 proofs[msg.sender].h,
200 proofs[msg.sender].k,
201 msg.sender);
202 require(result); //the proof must verify. The spice must flow.
203 bytes8 n = tv.getInputBits(0, msg.sender);
204 bytes8 z = tv.getInputBits(128, msg.sender);
205 for (uint i=0; i<nCount; i++) { //check this is an unspent commitment
206 require(ns[i]!=n);
207 }
208 ns[nCount++] = n; //remember we spent it
209 zs[zCount++] = z; //add Bob's token to the list of tokens
210 bytes8 root = merkle(0,0); //work out the Merkle root as it's now different
211 currentRootIndex = roots.push(root)-1; //and save it to the list
212 }
213 
214 
215 
216 
217 /**
218 The join function joins multiple commitments into one z-commitment and
219 transfers to the public of key recipient specified
220 */
221 function join() public {
222 //verification contract
223 bool result = jv.verifyTx(
224 proofs[msg.sender].a,
225 proofs[msg.sender].a_p,
226 proofs[msg.sender].b,
227 proofs[msg.sender].b_p,
228 proofs[msg.sender].c,
229 proofs[msg.sender].c_p,
230 proofs[msg.sender].h,
231 proofs[msg.sender].k,
232 msg.sender);
233 require(result); //the proof must verify. The spice must flow.
234 bytes8 na1 = jv.getInputBits(0, msg.sender);
235 bytes8 na2 = jv.getInputBits(64, msg.sender);
236 bytes8 zb = jv.getInputBits(192, msg.sender);
237 bytes8 db = jv.getInputBits(256, msg.sender);
238 for (uint i=0; i<nCount; i++) { //check this is an unspent commitment
239 require(ns[i]!=na1 && ns[i]!=na2);
240 }
241 for (uint j=0; j<zCount; j++) { //check the preventifier doesn't exist
242 require(ds[j]!= db);
243 }
244 ns[nCount++] = na1; //remember we spent it
245 ns[nCount++] = na2; //remember we spent it
246 zs[zCount] = zb; //add the commitment
247 ds[zCount++] = db; //add the preventifier
248 bytes8 root = merkle(0,0); //work out the Merkle root as it's now different
249 currentRootIndex = roots.push(root)-1; //and save it to the list
250 }
251 
252 
253 
254 
255 /**
256 The split function splits a commitment into multiple commitments and transfers
257 to the public of key recipient specified
258 */
259 function split() public {
260 //verification contract
261 bool result = sv.verifyTx(
262 proofs[msg.sender].a,
263 proofs[msg.sender].a_p,
264 proofs[msg.sender].b,
265 proofs[msg.sender].b_p,
266 proofs[msg.sender].c,
267 proofs[msg.sender].c_p,
268 proofs[msg.sender].h,
269 proofs[msg.sender].k,
270 msg.sender);
271 require(result); //the proof must verify. The spice must flow.
272 bytes8 na = sv.getInputBits(0, msg.sender);
273 bytes8 zb1 = sv.getInputBits(128, msg.sender);
274 bytes8 zb2 = sv.getInputBits(192, msg.sender);
275 bytes8 db1 = sv.getInputBits(256, msg.sender); //TODO do not add if already in the list of double spend preventifier
276 bytes8 db2 = sv.getInputBits(320, msg.sender); //TODO do not add if already in the list of double spend preventifier
277 for (uint i=0; i<nCount; i++) { //check this is an unspent coin
278 require(ns[i]!=na);
279 }
280 ns[nCount++] = na; //remember we spent it
281 zs[zCount] = zb1; //add the commitment
282 ds[zCount++] = db1; //add the preventifier
283 zs[zCount] = zb2; //add the commitment
284 ds[zCount++] = db2; //add the preventifier
285 bytes8 root = merkle(0,0); //work out the Merkle root as it's now different
286 currentRootIndex = roots.push(root)-1; //and save it to the list
287 }
288 
289 
290 
291 
292 /**
293 This function is only needed because otherwise mint and transfer use too many
294 local variables for the limited stack space. Rather than pass a proof as
295 parameters to these functions (more logical)
296 */
297 function setProofParams(
298 uint[2] a,
299 uint[2] a_p,
300 uint[2][2] b,
301 uint[2] b_p,
302 uint[2] c,
303 uint[2] c_p,
304 uint[2] h,
305 uint[2] k)
306 public {
307 //this is long, think of a better way
308 proofs[msg.sender].a[0] = a[0];
309 proofs[msg.sender].a[1] = a[1];
310 proofs[msg.sender].a_p[0] = a_p[0];
311 proofs[msg.sender].a_p[1] = a_p[1];
312 proofs[msg.sender].b[0][0] = b[0][0];
313 proofs[msg.sender].b[0][1] = b[0][1];
314 proofs[msg.sender].b[1][0] = b[1][0];
315 proofs[msg.sender].b[1][1] = b[1][1];
316 proofs[msg.sender].b_p[0] = b_p[0];
317 proofs[msg.sender].b_p[1] = b_p[1];
318 proofs[msg.sender].c[0] = c[0];
319 proofs[msg.sender].c[1] = c[1];
320 proofs[msg.sender].c_p[0] = c_p[0];
321 proofs[msg.sender].c_p[1] = c_p[1];
322 proofs[msg.sender].h[0] = h[0];
323 proofs[msg.sender].h[1] = h[1];
324 proofs[msg.sender].k[0] = k[0];
325 proofs[msg.sender].k[1] = k[1];
326 }
327 
328 
329 
330 
331 function getTokens() public view returns(bytes8[merkleWidth], uint root) {
332 //need the commitments to compute a proof and also an index to look up the current
333 //root.
334 return (zs,currentRootIndex);
335 }
336 
337 
338 
339 
340 /**
341 Function to return the root that was current at rootIndex
342 */
343 function getRoot(uint rootIndex) view public returns(bytes8) {
344 return roots[rootIndex];
345 }
346 
347 
348 
349 
350 function computeMerkle() public view returns (bytes8){//for backwards compat
351 return merkle(0,0);
352 }
353 
354 
355 
356 
357 function merkle(uint r, uint t) public view returns (bytes8) {
358 //This is a recursive approach, which seems efficient but we do end up
359 //calculating the whole tree fro scratch each time.  Need to look at storing
360 //intermediate values and seeing if that will make it cheaper.
361 if (r==lastRow) {
362 return zs[t];
363 } else {
364 return bytes8(sha256(merkle(r+1,2*t)^merkle(r+1,2*t+1))<<192);
365 }
366 }
367 }