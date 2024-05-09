1 pragma solidity ^0.4.17;
2 
3 contract ISmartCert {
4 	// state variables
5 	mapping (bytes32 => SignedData) hashes;
6 	mapping (address => AccessStruct) accessList;
7 	mapping (bytes32 => RevokeStruct) revoked;
8 	mapping (bytes32 => Lvl2Struct[]) idMap;
9 	address owner;
10 
11 	// constants
12 	string constant CODE_ACCESS_DENIED = "A001";
13 	string constant CODE_ACCESS_POSTER_NOT_AUTHORIZED = "A002";
14 	string constant CODE_ACCESS_ISSUER_NOT_AUTHORIZED = "A003";
15 	string constant CODE_ACCESS_VERIFY_NOT_AUTHORIZED = "A004";
16 	string constant MSG_ISSUER_SIG_NOT_MATCHED = "E001"; //"Issuer's address not matched with signed hash";
17 	string constant MSG_DOC_REGISTERED = "E002"; //"Document already registered"; 
18 	string constant MSG_REVOKED = "E003"; //"Document already revoked"; 	
19 	string constant MSG_NOTREG = "E004"; //"Document not registered";
20 	string constant MSG_INVALID = "E005";  //"Document not valid"; 
21 	string constant MSG_NOFOUND = "E006"; //"No record found";
22 	string constant MSG_INVALID_CERT_MERKLE_NOT_MATCHED = "E007";
23 	string constant MSG_INVALID_ACCESS_RIGHT = "E008";
24 	string constant MSG_BATCH_REVOKED = "E009"; //"Batch that the document belong to has already been revoked";
25 	string constant MSG_MERKLE_CANNOT_EMPTY = "E010";
26 	string constant MSG_MERKLE_NOT_REGISTERED = "E011";
27 	string constant STATUS_PASS = "PASS";
28 	string constant STATUS_FAIL = "FAIL";
29 	bytes1 constant ACCESS_ISSUER = 0x04;
30 	bytes1 constant ACCESS_POSTER = 0x02;
31 	bytes1 constant ACCESS_VERIFIER = 0x01;
32 	bytes1 constant ACCESS_ALL = 0x07;
33 	bytes1 constant ACCESS_ISSUER_POSTER = 0x05;
34 	bytes1 constant ACCESS_NONE = 0x00;
35 
36 	struct SignedData {
37 		// string data;
38 		bytes sig;
39 		uint registerDate;
40 		bool exists; // empty entry to this struct initially set to false
41 	}
42 
43 	struct RecordStruct {
44 		bytes32 recordId; // ref id to hashstore
45 		bool exists; // empty entry to this struct initially set to false
46 	}
47 
48 	struct Lvl2Struct {
49 		bytes32 recordId;
50 		bytes32 certhash;
51 		bool exists;
52 	}
53 
54 	struct RevokeStruct {
55 		bool exists;
56 		bytes32 merkleHash;
57 		bool batchFlag;
58 		uint date;
59 	}
60 
61 	struct AccessStruct {
62 		bytes1 accessRight;
63 		uint date;
64 		bool isValue;
65 	}
66 
67 	function ISmartCert() public {
68 		owner = msg.sender;
69 	}
70 
71 	event LogUserRight(string, string);
72 	function userRight(address userAddr, bytes1 accessRight, uint date) public {
73 		if (owner != msg.sender) {
74 			LogUserRight(STATUS_FAIL, CODE_ACCESS_DENIED);
75 			return;
76 		}
77 		if (accessRight != ACCESS_ISSUER && accessRight != ACCESS_POSTER && accessRight != ACCESS_VERIFIER && accessRight != ACCESS_ALL && accessRight != ACCESS_ISSUER_POSTER && accessRight != ACCESS_NONE) {
78 			LogUserRight(STATUS_FAIL, MSG_INVALID_ACCESS_RIGHT);
79 			return;
80 		}
81 		accessList[userAddr].accessRight = accessRight;
82 		accessList[userAddr].date = date;
83 		accessList[userAddr].isValue = true;
84 		LogUserRight(STATUS_PASS, "");
85 	}
86 
87 	function checkAccess(address user, bytes1 access) internal view returns (bool) {
88 		if (accessList[user].isValue) {
89 			if (accessList[user].accessRight & access == access) {
90 				return true;
91 			}
92 		}
93 		return false;
94 	}
95 
96 	function internalRegisterCert(bytes32 certHash, bytes sig, uint registrationDate) internal returns (string, string) {
97 		address issuer;
98 
99 		if (!checkAccess(msg.sender, ACCESS_POSTER)) {
100 			return (STATUS_FAIL, CODE_ACCESS_POSTER_NOT_AUTHORIZED);
101 		}
102 		
103 		issuer =  recoverAddr(certHash, sig);
104 		if (!checkAccess(issuer, ACCESS_ISSUER)) {
105 			return (STATUS_FAIL, CODE_ACCESS_ISSUER_NOT_AUTHORIZED);
106 		}
107 
108 		if (hashes[certHash].exists) {
109 			// check if doc has already been revoked
110 			if (revoked[certHash].exists) {
111 				return (STATUS_FAIL, MSG_REVOKED);
112 			} else {
113 				return (STATUS_FAIL, MSG_DOC_REGISTERED);
114 			}		
115 		}	
116 
117 		// signed data (in r, s, v)
118 		hashes[certHash].sig = sig;
119 		// certificate registration date (YYYYmmdd)
120 		hashes[certHash].registerDate = registrationDate;
121 		// indicate the record exists
122 		hashes[certHash].exists = true;
123 		return (STATUS_PASS, "");
124 	}
125 
126 	function internalRegisterCertWithID(bytes32 certHash, bytes sig, bytes32 merkleHash, uint registrationDate, bytes32 id) internal returns (string, string) {
127 		string memory status;
128 		string memory message;
129 
130 		// check if any record associated with id
131 		for (uint i = 0; i < idMap[id].length; i++) {
132 			if (idMap[id][i].exists == true && idMap[id][i].certhash == certHash) {
133 				return (STATUS_FAIL, MSG_DOC_REGISTERED);
134 			}
135 		}
136 
137 		// check if merkle root has already been revoked
138 		if (merkleHash != 0x00) {
139 			if (revoked[merkleHash].exists && revoked[merkleHash].batchFlag) {
140 				return (STATUS_FAIL, MSG_BATCH_REVOKED);
141 			}		
142 		}
143 
144 		// check if merkle root is empty
145 		if (merkleHash == 0x00) {
146 			return (STATUS_FAIL, MSG_MERKLE_CANNOT_EMPTY);
147 		}
148 
149 		// check if merkle is exists
150 		if (!hashes[merkleHash].exists) {
151 			return (STATUS_FAIL, MSG_MERKLE_NOT_REGISTERED);
152 		}	
153 
154 		// register certificate
155 		(status, message) = internalRegisterCert(certHash, sig, registrationDate);
156 		if (keccak256(status) != keccak256(STATUS_PASS)) {
157 			return (status, message);		
158 		}
159 
160 		// store record id by ID
161 		idMap[id].push(Lvl2Struct({recordId:merkleHash, certhash:certHash, exists:true}));
162 
163 		return (STATUS_PASS, "");
164 	}
165 
166 	function internalRevokeCert(bytes32 certHash, bytes sigCertHash, bytes32 merkleHash, bool batchFlag, uint revocationDate) internal returns (string, string) {
167 		address issuer1;
168 		address issuer2;
169 		// check poster access right
170 		if (!checkAccess(msg.sender, ACCESS_POSTER)) {
171 			return (STATUS_FAIL, CODE_ACCESS_POSTER_NOT_AUTHORIZED);
172 		}
173 		// check issuer access right
174 		issuer1 = recoverAddr(certHash, sigCertHash);
175 		if (!checkAccess(issuer1, ACCESS_ISSUER)) {
176 			return (STATUS_FAIL, CODE_ACCESS_ISSUER_NOT_AUTHORIZED);
177 		}
178 		// if batch, ensure both certHash and merkleHash are same
179 		if (batchFlag) {
180 			if (certHash != merkleHash) {
181 				return (STATUS_FAIL, MSG_INVALID_CERT_MERKLE_NOT_MATCHED);
182 			}
183 			if (merkleHash == 0x00) {
184 				return (STATUS_FAIL, MSG_MERKLE_CANNOT_EMPTY);
185 			}
186 		}
187 		if (merkleHash != 0x00) {
188 			// check if doc (merkle root) is registered
189 			if (hashes[merkleHash].exists == false) {
190 				return (STATUS_FAIL, MSG_NOTREG);
191 			}
192 			// check if requested signature and stored signature is same by comparing two issuer addresses
193 			issuer2 = recoverAddr(merkleHash, hashes[merkleHash].sig);
194 			if (issuer1 != issuer2) {
195 				return (STATUS_FAIL, MSG_ISSUER_SIG_NOT_MATCHED);
196 			}
197 		}				
198 		// check if doc has already been revoked
199 		if (revoked[certHash].exists) {
200 			return (STATUS_FAIL, MSG_REVOKED);
201 		}
202 		// store / update
203 		if (batchFlag) {
204 			revoked[certHash].batchFlag = true;
205 		} else {			
206 			revoked[certHash].batchFlag = false;
207 		}
208 		revoked[certHash].exists = true;
209 		revoked[certHash].merkleHash = merkleHash;
210 		revoked[certHash].date = revocationDate;
211 
212 		return (STATUS_PASS, "");
213 	}
214 
215 	// event as a form of return value, state mutating function cannot return value to external party
216 	event LogRegisterCert(string, string);
217 	function registerCert(bytes32 certHash, bytes sig, uint registrationDate) public {		
218 		string memory status;
219 		string memory message;
220 
221 		(status, message) = internalRegisterCert(certHash, sig, registrationDate);		
222 		LogRegisterCert(status, message);
223 	}
224 
225 	event LogRegisterCertWithID(string, string);
226 	function registerCertWithID(bytes32 certHash, bytes sig, bytes32 merkleHash, uint registrationDate, bytes32 id) public {
227 		string memory status;
228 		string memory message;
229 
230 		// register certificate
231 		(status, message) = internalRegisterCertWithID(certHash, sig, merkleHash, registrationDate, id);
232 		LogRegisterCertWithID(status, message);
233 	}
234 
235 	// for verification 
236 	function internalVerifyCert(bytes32 certHash, bytes32 merkleHash, address issuer) internal view returns (string, string) {
237 		bytes32 tmpCertHash;
238 
239 		// check if doc has already been revoked
240 		if (revoked[certHash].exists && !revoked[certHash].batchFlag) {
241 			return (STATUS_FAIL, MSG_REVOKED);
242 		}
243 		if (merkleHash != 0x00) {
244 			// check if merkle root has already been revoked
245 			if (revoked[merkleHash].exists && revoked[merkleHash].batchFlag) {
246 				return (STATUS_FAIL, MSG_REVOKED);
247 			}
248 			tmpCertHash = merkleHash;
249 		} else {
250 			tmpCertHash = certHash;
251 		}		
252 		// check if doc in hash store
253 		if (hashes[tmpCertHash].exists) {
254 			if (recoverAddr(tmpCertHash, hashes[tmpCertHash].sig) != issuer) {			
255 				return (STATUS_FAIL, MSG_INVALID);
256 			}
257 			return (STATUS_PASS, "");
258 		} else {
259 			return (STATUS_FAIL, MSG_NOTREG);
260 		}
261 	}
262 
263 	function verifyCert(bytes32 certHash, bytes32 merkleHash, address issuer) public view returns (string, string) {
264 		string memory status;
265 		string memory message;
266 		bool isAuthorized;
267 
268 		// check verify access
269 		isAuthorized = checkVerifyAccess();
270 		if (!isAuthorized) {
271 			return (STATUS_FAIL, CODE_ACCESS_VERIFY_NOT_AUTHORIZED);
272 		}
273 
274 		(status, message) = internalVerifyCert(certHash, merkleHash, issuer);
275 		return (status, message);
276 	}
277 
278 	function verifyCertWithID(bytes32 certHash, bytes32 merkleHash, bytes32 id, address issuer) public view returns (string, string) {
279 		string memory status;
280 		string memory message;
281 		bool isAuthorized;
282 
283 		// check verify access
284 		isAuthorized = checkVerifyAccess();
285 		if (!isAuthorized) {
286 			return (STATUS_FAIL, CODE_ACCESS_VERIFY_NOT_AUTHORIZED);
287 		}
288 
289 		// check if any record associated with id
290 		for (uint i = 0; i < idMap[id].length; i++) {
291 			if (idMap[id][i].exists == true && idMap[id][i].certhash == certHash) {
292 				(status, message) = internalVerifyCert(certHash, merkleHash, issuer);
293 				return (status, message);
294 			}
295 		}
296 		// no record found
297 		return (STATUS_FAIL, MSG_NOFOUND);
298 	}
299 
300 	function checkVerifyAccess() internal view returns (bool) {
301 		// check if sender is authorized for cert verification
302 		return checkAccess(msg.sender, ACCESS_VERIFIER);
303 	}
304 
305 	// event as a form of return value, state mutating function cannot return value to external party
306 	event LogRevokeCert(string, string);
307 	function revokeCert(bytes32 certHash, bytes sigCertHash, bytes32 merkleHash, bool batchFlag, uint revocationDate) public {
308 		string memory status;
309 		string memory message;
310 
311 		(status, message) = internalRevokeCert(certHash, sigCertHash, merkleHash, batchFlag, revocationDate);
312 		LogRevokeCert(status, message);
313 	}
314 
315 	// event LogReissueCert(string, bytes32, string);
316 	event LogReissueCert(string, string);
317 	function reissueCert(bytes32 revokeCertHash, bytes revokeSigCertHash, bytes32 revokeMerkleHash, uint revocationDate, bytes32 registerCertHash, bytes registerSig, uint registrationDate) public {
318 		string memory status;
319 		string memory message;
320 
321 		// revoke certificate
322 		(status, message) = internalRevokeCert(revokeCertHash, revokeSigCertHash, revokeMerkleHash, false, revocationDate);
323 		if (keccak256(status) != keccak256(STATUS_PASS)) {
324 			LogReissueCert(status, message);
325 			return;
326 		}
327 
328 		// register certificate
329 		(status, message) = internalRegisterCert(registerCertHash, registerSig, registrationDate);
330 		LogReissueCert(status, message);
331 		if (keccak256(status) != keccak256(STATUS_PASS)) {
332 			revert();			
333 		}
334 
335 		LogReissueCert(STATUS_PASS, "");
336 	}
337 
338 	event LogReissueCertWithID(string, string);
339 	function reissueCertWithID(bytes32 revokeCertHash, bytes revokeSigCertHash, bytes32 revokeMerkleHash, uint revocationDate, bytes32 registerCertHash, bytes registerSig, bytes32 registerMerkleHash, uint registrationDate, bytes32 id) public {
340 		string memory status;
341 		string memory message;
342 
343 		// revoke certificate
344 		(status, message) = internalRevokeCert(revokeCertHash, revokeSigCertHash, revokeMerkleHash, false, revocationDate);
345 		if (keccak256(status) != keccak256(STATUS_PASS)) {
346 			LogReissueCertWithID(status, message);
347 			return;
348 		}
349 
350 		// register certificate
351 		(status, message) = internalRegisterCertWithID(registerCertHash, registerSig, registerMerkleHash, registrationDate, id);
352 		LogReissueCertWithID(status, message);
353 		if (keccak256(status) != keccak256(STATUS_PASS)) {
354 			revert();
355 		}
356 
357 		LogReissueCertWithID(STATUS_PASS, "");
358 	}
359 
360 	function recoverAddr(bytes32 hash, bytes sig) internal pure returns (address) {
361 		bytes32 r;
362 		bytes32 s;
363 		uint8 v;
364 
365 		//Check the signature length
366 		if (sig.length != 65) {
367 			return (address(0));
368 		}
369 		
370 		// Divide the signature in r, s and v variables
371         assembly {
372           r := mload(add(sig, 33))
373           s := mload(add(sig, 65))
374           v := mload(add(sig, 1))
375         }
376         
377         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
378         if (v < 27) {
379           v += 27;
380         }
381 
382 		// If the version is correct return the signer address
383 		if (v != 27 && v != 28) {
384 			return (address(1));
385 		} else {
386 			return ecrecover(hash, v, r, s);
387 		}
388 	}
389 }