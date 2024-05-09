1 pragma solidity 0.4.20;
2 
3 contract Accessible {
4     /** Access Right Management **
5     * Copyright 2019
6     * Florian Weigand
7     * Synalytix UG, Munich
8     * florian(at)synalytix.de
9     */
10 
11     address      public owner;
12     mapping(address => bool)     public accessAllowed;
13 
14     function Accessible() public {
15         owner = msg.sender;
16     }
17 
18     modifier ownership() {
19         require(owner == msg.sender);
20         _;
21     }
22 
23     modifier accessible() {
24         require(accessAllowed[msg.sender]);
25         _;
26     }
27 
28     function allowAccess(address _address) ownership public {
29         if (_address != address(0)) {
30             accessAllowed[_address] = true;
31         }
32     }
33 
34     function denyAccess(address _address) ownership public {
35         if (_address != address(0)) {
36             accessAllowed[_address] = false;
37         }
38     }
39 
40     function transferOwnership(address _address) ownership public {
41         if (_address != address(0)) {
42             owner = _address;
43         }
44     }
45 }
46 
47 contract TrueProfileStorage is Accessible {
48     /** Data Storage Contract **
49     * Copyright 2019
50     * Florian Weigand
51     * Synalytix UG, Munich
52     * florian(at)synalytix.de
53     */
54 
55     /**** signature struct ****/
56     struct Signature {
57         uint8 v;
58         bytes32 r;
59         bytes32 s;
60         uint8 revocationReasonId;
61         bool isValue;
62     }
63 
64     /**** signature storage ****/
65     mapping(bytes32 => Signature)   public signatureStorage;
66 
67     /**** general storage of non-struct data which might
68     be needed for further development of main contract ****/
69     mapping(bytes32 => uint256)     public uIntStorage;
70     mapping(bytes32 => string)      public stringStorage;
71     mapping(bytes32 => address)     public addressStorage;
72     mapping(bytes32 => bytes)       public bytesStorage;
73     mapping(bytes32 => bool)        public boolStorage;
74     mapping(bytes32 => int256)      public intStorage;
75 
76     /**** CRUD for Signature storage ****/
77     function getSignature(bytes32 _key) external view returns (uint8 v, bytes32 r, bytes32 s, uint8 revocationReasonId) {
78         Signature memory tempSignature = signatureStorage[_key];
79         if (tempSignature.isValue) {
80             return(tempSignature.v, tempSignature.r, tempSignature.s, tempSignature.revocationReasonId);
81         } else {
82             return(0, bytes32(0), bytes32(0), 0);
83         }
84     }
85 
86     function setSignature(bytes32 _key, uint8 _v, bytes32 _r, bytes32 _s, uint8 _revocationReasonId) accessible external {
87         require(ecrecover(_key, _v, _r, _s) != 0x0);
88         Signature memory tempSignature = Signature({
89             v: _v,
90             r: _r,
91             s: _s,
92             revocationReasonId: _revocationReasonId,
93             isValue: true
94         });
95         signatureStorage[_key] = tempSignature;
96     }
97 
98     function deleteSignature(bytes32 _key) accessible external {
99         require(signatureStorage[_key].isValue);
100         Signature memory tempSignature = Signature({
101             v: 0,
102             r: bytes32(0),
103             s: bytes32(0),
104             revocationReasonId: 0,
105             isValue: false
106         });
107         signatureStorage[_key] = tempSignature;
108     }
109 
110     /**** Get Methods for additional storage ****/
111     function getAddress(bytes32 _key) external view returns (address) {
112         return addressStorage[_key];
113     }
114 
115     function getUint(bytes32 _key) external view returns (uint) {
116         return uIntStorage[_key];
117     }
118 
119     function getString(bytes32 _key) external view returns (string) {
120         return stringStorage[_key];
121     }
122 
123     function getBytes(bytes32 _key) external view returns (bytes) {
124         return bytesStorage[_key];
125     }
126 
127     function getBool(bytes32 _key) external view returns (bool) {
128         return boolStorage[_key];
129     }
130 
131     function getInt(bytes32 _key) external view returns (int) {
132         return intStorage[_key];
133     }
134 
135     /**** Set Methods for additional storage ****/
136     function setAddress(bytes32 _key, address _value) accessible external {
137         addressStorage[_key] = _value;
138     }
139 
140     function setUint(bytes32 _key, uint _value) accessible external {
141         uIntStorage[_key] = _value;
142     }
143 
144     function setString(bytes32 _key, string _value) accessible external {
145         stringStorage[_key] = _value;
146     }
147 
148     function setBytes(bytes32 _key, bytes _value) accessible external {
149         bytesStorage[_key] = _value;
150     }
151 
152     function setBool(bytes32 _key, bool _value) accessible external {
153         boolStorage[_key] = _value;
154     }
155 
156     function setInt(bytes32 _key, int _value) accessible external {
157         intStorage[_key] = _value;
158     }
159 
160     /**** Delete Methods for additional storage ****/
161     function deleteAddress(bytes32 _key) accessible external {
162         delete addressStorage[_key];
163     }
164 
165     function deleteUint(bytes32 _key) accessible external {
166         delete uIntStorage[_key];
167     }
168 
169     function deleteString(bytes32 _key) accessible external {
170         delete stringStorage[_key];
171     }
172 
173     function deleteBytes(bytes32 _key) accessible external {
174         delete bytesStorage[_key];
175     }
176 
177     function deleteBool(bytes32 _key) accessible external {
178         delete boolStorage[_key];
179     }
180 
181     function deleteInt(bytes32 _key) accessible external {
182         delete intStorage[_key];
183     }
184 }
185 
186 contract TrueProfileLogic is Accessible {
187     /** Logic Contract (updatable) **
188     * Copyright 2019
189     * Florian Weigand
190     * Synalytix UG, Munich
191     * florian(at)synalytix.de
192     */
193 
194     TrueProfileStorage trueProfileStorage;
195 
196     function TrueProfileLogic(address _trueProfileStorage) public {
197         trueProfileStorage = TrueProfileStorage(_trueProfileStorage);
198     }
199 
200     /**** Signature logic methods ****/
201 
202     // add or update TrueProof
203     // if not present add to array
204     // if present the old TrueProof can be replaced with a new TrueProof
205     function addTrueProof(bytes32 _key, uint8 _v, bytes32 _r, bytes32 _s) accessible external {
206         require(accessAllowed[ecrecover(_key, _v, _r, _s)]);
207         // the certifcate is valid, so set the revokationReasonId to 0
208         uint8 revokationReasonId = 0;
209         trueProfileStorage.setSignature(_key, _v, _r, _s, revokationReasonId);
210     }
211 
212     // if the TrueProof was issued by error it can be revoked
213     // for revocation a reason id needs to be given
214     function revokeTrueProof(bytes32 _key, uint8 _revocationReasonId) accessible external {
215         require(_revocationReasonId != 0);
216 
217         uint8 v;
218         bytes32 r;
219         bytes32 s;
220         uint8 oldRevocationReasonId;
221         (v, r, s, oldRevocationReasonId) = trueProfileStorage.getSignature(_key);
222 
223         require(v != 0);
224 
225         // set the revokation reason id to the new value
226         trueProfileStorage.setSignature(_key, v, r, s, _revocationReasonId);
227     }
228 
229     function isValidTrueProof(bytes32 _key) external view returns (bool) {
230         // needs to be not revoked AND needs to have a valid signature
231         if (this.isValidSignatureTrueProof(_key) && this.isNotRevokedTrueProof(_key)) {
232             return true;
233         } else {
234             return false;   
235         }
236     }
237 
238     function isValidSignatureTrueProof(bytes32 _key) external view returns (bool) {
239         uint8 v;
240         bytes32 r;
241         bytes32 s;
242         uint8 revocationReasonId;
243         (v, r, s, revocationReasonId) = trueProfileStorage.getSignature(_key);
244 
245         // needs to have a valid signature
246         if (accessAllowed[ecrecover(_key, v, r, s)]) {
247             return true;
248         } else {
249             return false;   
250         }
251     }
252 
253     function isNotRevokedTrueProof(bytes32 _key) external view returns (bool) {
254         uint8 v;
255         bytes32 r;
256         bytes32 s;
257         uint8 revocationReasonId;
258         (v, r, s, revocationReasonId) = trueProfileStorage.getSignature(_key);
259 
260         // needs to be not revoked
261         if (revocationReasonId == 0) {
262             return true;
263         } else {
264             return false;
265         }
266     }
267 
268     function getSignature(bytes32 _key) external view returns (uint8 v, bytes32 r, bytes32 s, uint8 revocationReasonId) {
269         return trueProfileStorage.getSignature(_key);
270     }
271 
272     function getRevocationReasonId(bytes32 _key) external view returns (uint8) {
273         uint8 v;
274         bytes32 r;
275         bytes32 s;
276         uint8 revocationReasonId;
277         (v, r, s, revocationReasonId) = trueProfileStorage.getSignature(_key);
278 
279         return revocationReasonId;
280     }
281 }