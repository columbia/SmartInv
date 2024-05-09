1 /*
2 Copyright (c) 2015-2016 Oraclize SRL
3 Copyright (c) 2016 Oraclize LTD
4 */
5 
6 /*
7 Oraclize Connector v1.1.0
8 */
9 
10 pragma solidity ^0.4.11;
11 
12 contract Oraclize {
13     mapping (address => uint) reqc;
14 
15     mapping (address => byte) public cbAddresses;
16 
17     event Log1(address sender, bytes32 cid, uint timestamp, string datasource, string arg, uint gaslimit, byte proofType, uint gasPrice);
18     event Log2(address sender, bytes32 cid, uint timestamp, string datasource, string arg1, string arg2, uint gaslimit, byte proofType, uint gasPrice);
19     event LogN(address sender, bytes32 cid, uint timestamp, string datasource, bytes args, uint gaslimit, byte proofType, uint gasPrice);
20     event Log1_fnc(address sender, bytes32 cid, uint timestamp, string datasource, string arg, function() external callback, uint gaslimit, byte proofType, uint gasPrice);
21     event Log2_fnc(address sender, bytes32 cid, uint timestamp, string datasource, string arg1, string arg2, function() external callback, uint gaslimit, byte proofType, uint gasPrice);
22     event LogN_fnc(address sender, bytes32 cid, uint timestamp, string datasource, bytes args, function() external callback, uint gaslimit, byte proofType, uint gasPrice);
23 
24     address owner;
25 
26     modifier onlyadmin {
27         if (msg.sender != owner) throw;
28        _;
29     }
30     
31     function changeAdmin(address _newAdmin) 
32     onlyadmin {
33         owner = _newAdmin;
34     }
35 
36     // proof is currently a placeholder for when associated proof for addressType is added
37     function addCbAddress(address newCbAddress, byte addressType, bytes proof) 
38     onlyadmin {
39         cbAddresses[newCbAddress] = addressType;
40     }
41 
42     function addCbAddress(address newCbAddress, byte addressType)
43     onlyadmin {
44         bytes memory nil = '';
45         addCbAddress(newCbAddress, addressType, nil);
46     }
47 
48     function removeCbAddress(address newCbAddress)
49     onlyadmin {
50         delete cbAddresses[newCbAddress];
51     }
52 
53     function cbAddress()
54     constant
55     returns (address _cbAddress) {
56         if (cbAddresses[tx.origin] != 0)
57             _cbAddress = tx.origin;
58     }
59 
60     function addDSource(string dsname, uint multiplier) {
61         addDSource(dsname, 0x00, multiplier);
62     }
63 
64     function addDSource(string dsname, byte proofType, uint multiplier) onlyadmin {
65         bytes32 dsname_hash = sha3(dsname, proofType);
66         dsources[dsources.length++] = dsname_hash;
67         price_multiplier[dsname_hash] = multiplier;
68     }
69 
70     function multisetProofType(uint[] _proofType, address[] _addr) onlyadmin {
71         for (uint i=0; i<_addr.length; i++) addr_proofType[_addr[i]] = byte(_proofType[i]);
72     }
73 
74     function multisetCustomGasPrice(uint[] _gasPrice, address[] _addr) onlyadmin {
75         for (uint i=0; i<_addr.length; i++) addr_gasPrice[_addr[i]] = _gasPrice[i];
76     }
77 
78     uint gasprice = 20000000000;
79 
80     function setGasPrice(uint newgasprice)
81     onlyadmin {
82         gasprice = newgasprice;
83     }
84 
85     function setBasePrice(uint new_baseprice)
86     onlyadmin { //0.001 usd in ether
87         baseprice = new_baseprice;
88         for (uint i=0; i<dsources.length; i++) price[dsources[i]] = new_baseprice*price_multiplier[dsources[i]];
89     }
90 
91     function setBasePrice(uint new_baseprice, bytes proofID)
92     onlyadmin { //0.001 usd in ether
93         baseprice = new_baseprice;
94         for (uint i=0; i<dsources.length; i++) price[dsources[i]] = new_baseprice*price_multiplier[dsources[i]];
95     }
96 
97     function withdrawFunds(address _addr)
98     onlyadmin {
99         _addr.send(this.balance);
100     }
101 
102     function() onlyadmin {}
103 
104     function Oraclize() {
105         owner = msg.sender;
106     }
107 
108     modifier costs(string datasource, uint gaslimit) {
109         uint price = getPrice(datasource, gaslimit, msg.sender);
110         if (msg.value >= price){
111             uint diff = msg.value - price;
112             if (diff > 0) msg.sender.send(diff);
113            _;
114         } else throw;
115     }
116 
117     mapping (address => byte) addr_proofType;
118     mapping (address => uint) addr_gasPrice;
119     uint public baseprice;
120     mapping (bytes32 => uint) price;
121     mapping (bytes32 => uint) price_multiplier;
122     bytes32[] dsources;
123 
124     bytes32[] public randomDS_sessionPubKeysHash;
125 
126     function randomDS_updateSessionPubKeysHash(bytes32[] _newSessionPubKeysHash) onlyadmin {
127         randomDS_sessionPubKeysHash.length = 0;
128         for (uint i=0; i<_newSessionPubKeysHash.length; i++) randomDS_sessionPubKeysHash.push(_newSessionPubKeysHash[i]);
129     }
130 
131     function randomDS_getSessionPubKeyHash() constant returns (bytes32) {
132         uint i = uint(sha3(reqc[msg.sender]))%randomDS_sessionPubKeysHash.length;
133         return randomDS_sessionPubKeysHash[i];
134     }
135 
136     function setProofType(byte _proofType) {
137         addr_proofType[msg.sender] = _proofType;
138     }
139 
140     function setCustomGasPrice(uint _gasPrice) {
141         addr_gasPrice[msg.sender] = _gasPrice;
142     }
143 
144     function getPrice(string _datasource)
145     public
146     returns (uint _dsprice) {
147         return getPrice(_datasource, msg.sender);
148     }
149 
150     function getPrice(string _datasource, uint _gaslimit)
151     public
152     returns (uint _dsprice) {
153         return getPrice(_datasource, _gaslimit, msg.sender);
154     }
155 
156     function getPrice(string _datasource, address _addr)
157     private
158     returns (uint _dsprice) {
159         return getPrice(_datasource, 200000, _addr);
160     }
161 
162     function getPrice(string _datasource, uint _gaslimit, address _addr)
163     private
164     returns (uint _dsprice) {
165         uint gasprice_ = addr_gasPrice[_addr];
166         if ((_gaslimit <= 200000)&&(reqc[_addr] == 0)&&(gasprice_ <= gasprice)&&(tx.origin != cbAddress())) return 0;
167         if (gasprice_ == 0) gasprice_ = gasprice;
168         _dsprice = price[sha3(_datasource, addr_proofType[_addr])];
169         _dsprice += _gaslimit*gasprice_;
170         return _dsprice;
171     }
172 
173     function getCodeSize(address _addr)
174     private
175     constant
176     returns(uint _size) {
177     assembly {
178         _size := extcodesize(_addr)
179         }
180     }
181 
182     function query(string _datasource, string _arg)
183     payable
184     returns (bytes32 _id) {
185         return query1(0, _datasource, _arg, 200000);
186     }
187 
188     function query1(string _datasource, string _arg)
189     payable
190     returns (bytes32 _id) {
191         return query1(0, _datasource, _arg, 200000);
192     }
193 
194     function query2(string _datasource, string _arg1, string _arg2)
195     payable
196     returns (bytes32 _id) {
197         return query2(0, _datasource, _arg1, _arg2, 200000);
198     }
199 
200     function queryN(string _datasource, bytes _args)
201     payable
202     returns (bytes32 _id) {
203         return queryN(0, _datasource, _args, 200000);
204     }
205 
206     function query(uint _timestamp, string _datasource, string _arg)
207     payable
208     returns (bytes32 _id) {
209         return query1(_timestamp, _datasource, _arg, 200000);
210     }
211 
212     function query1(uint _timestamp, string _datasource, string _arg)
213     payable
214     returns (bytes32 _id) {
215         return query1(_timestamp, _datasource, _arg, 200000);
216     }
217 
218     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2)
219     payable
220     returns (bytes32 _id) {
221         return query2(_timestamp, _datasource, _arg1, _arg2, 200000);
222     }
223 
224     function queryN(uint _timestamp, string _datasource, bytes _args)
225     payable
226     returns (bytes32 _id) {
227         return queryN(_timestamp, _datasource, _args, 200000);
228     }
229 
230     function query(uint _timestamp, string _datasource, string _arg, uint _gaslimit)
231     payable
232     returns (bytes32 _id) {
233         return query1(_timestamp, _datasource, _arg, _gaslimit);
234     }
235 
236     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit)
237     payable
238     returns (bytes32 _id) {
239         return query(_timestamp, _datasource, _arg, _gaslimit);
240     }
241 
242     function query1_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit)
243     payable
244     returns (bytes32 _id) {
245         return query1(_timestamp, _datasource, _arg, _gaslimit);
246     }
247 
248     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit)
249     payable
250     returns (bytes32 _id) {
251         return query2(_timestamp, _datasource, _arg1, _arg2, _gaslimit);
252     }
253 
254     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _args, uint _gaslimit)
255     payable
256     returns (bytes32 _id) {
257         return queryN(_timestamp, _datasource, _args, _gaslimit);
258     }
259 
260     function query1(uint _timestamp, string _datasource, string _arg, uint _gaslimit) costs(_datasource, _gaslimit)
261     payable
262     returns (bytes32 _id) {
263     	if ((_timestamp > now+3600*24*60)||(_gaslimit > block.gaslimit)) throw;
264 
265         _id = sha3(this, msg.sender, reqc[msg.sender]);
266         reqc[msg.sender]++;
267         Log1(msg.sender, _id, _timestamp, _datasource, _arg, _gaslimit, addr_proofType[msg.sender], addr_gasPrice[msg.sender]);
268         return _id;
269     }
270 
271     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit)
272     costs(_datasource, _gaslimit)
273     payable
274     returns (bytes32 _id) {
275     	if ((_timestamp > now+3600*24*60)||(_gaslimit > block.gaslimit)) throw;
276 
277         _id = sha3(this, msg.sender, reqc[msg.sender]);
278         reqc[msg.sender]++;
279         Log2(msg.sender, _id, _timestamp, _datasource, _arg1, _arg2, _gaslimit, addr_proofType[msg.sender], addr_gasPrice[msg.sender]);
280         return _id;
281     }
282 
283     function queryN(uint _timestamp, string _datasource, bytes _args, uint _gaslimit) costs(_datasource, _gaslimit)
284     payable
285     returns (bytes32 _id) {
286     	if ((_timestamp > now+3600*24*60)||(_gaslimit > block.gaslimit)) throw;
287 
288         _id = sha3(this, msg.sender, reqc[msg.sender]);
289         reqc[msg.sender]++;
290         LogN(msg.sender, _id, _timestamp, _datasource, _args, _gaslimit, addr_proofType[msg.sender], addr_gasPrice[msg.sender]);
291         return _id;
292     }
293 
294     function query1_fnc(uint _timestamp, string _datasource, string _arg, function() external _fnc, uint _gaslimit)
295     costs(_datasource, _gaslimit)
296     payable
297     returns (bytes32 _id) {
298         if ((_timestamp > now+3600*24*60)||(_gaslimit > block.gaslimit)||address(_fnc) != msg.sender) throw;
299 
300         _id = sha3(this, msg.sender, reqc[msg.sender]);
301         reqc[msg.sender]++;
302         Log1_fnc(msg.sender, _id, _timestamp, _datasource, _arg, _fnc, _gaslimit, addr_proofType[msg.sender], addr_gasPrice[msg.sender]);
303         return _id;
304     }
305 
306     function query2_fnc(uint _timestamp, string _datasource, string _arg1, string _arg2, function() external _fnc, uint _gaslimit)
307     costs(_datasource, _gaslimit)
308     payable
309     returns (bytes32 _id) {
310         if ((_timestamp > now+3600*24*60)||(_gaslimit > block.gaslimit)||address(_fnc) != msg.sender) throw;
311 
312         _id = sha3(this, msg.sender, reqc[msg.sender]);
313         reqc[msg.sender]++;
314         Log2_fnc(msg.sender, _id, _timestamp, _datasource, _arg1, _arg2, _fnc,  _gaslimit, addr_proofType[msg.sender], addr_gasPrice[msg.sender]);
315         return _id;
316     }
317 
318     function queryN_fnc(uint _timestamp, string _datasource, bytes _args, function() external _fnc, uint _gaslimit)
319     costs(_datasource, _gaslimit)
320     payable
321     returns (bytes32 _id) {
322         if ((_timestamp > now+3600*24*60)||(_gaslimit > block.gaslimit)||address(_fnc) != msg.sender) throw;
323 
324         _id = sha3(this, msg.sender, reqc[msg.sender]);
325         reqc[msg.sender]++;
326         LogN_fnc(msg.sender, _id, _timestamp, _datasource, _args, _fnc, _gaslimit, addr_proofType[msg.sender], addr_gasPrice[msg.sender]);
327         return _id;
328     }
329 }