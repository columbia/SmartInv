1 pragma solidity ^0.4.24;
2 
3 interface IRescue {
4     function canRescue(address _addr) external returns (bool);
5 }
6 
7 contract TeambrellaWallet {
8     
9     uint public m_opNum;
10     uint public m_teamId;
11     address public m_owner;
12     address[] public m_cosigners;
13     address[] public m_cosignersApprovedDisband;    
14 
15     address m_rescuer;
16     
17     modifier orderedOps(uint opNum) {
18         require(opNum >= m_opNum);
19         _; 
20     }
21 
22     modifier onlyOwner {
23         require(msg.sender == m_owner);
24         _; 
25     }
26     
27     function() public payable { }
28 
29 
30     // Duplicate Solidity's ecrecover, but catching the CALL return value
31     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
32         // We do our own memory management here. Solidity uses memory offset
33         // 0x40 to store the current end of memory. We write past it (as
34         // writes are memory extensions), but don't update the offset so
35         // Solidity will reuse it. The memory used here is only needed for
36         // this context.
37 
38         bool ret;
39         address addr;
40 
41         assembly {
42             let size := mload(0x40)
43             mstore(size, hash)
44             mstore(add(size, 32), v)
45             mstore(add(size, 64), r)
46             mstore(add(size, 96), s)
47 
48             // NOTE: we can reuse the request memory because we deal with
49             //       the return code
50             ret := call(3000, 1, 0, size, 128, size, 32)
51             addr := mload(size)
52         }
53 
54         return (ret, addr);
55     }
56 
57     function ecrecovery(bytes32 hash, bytes sig) private returns (bool, address) {
58         bytes32 r;
59         bytes32 s;
60         uint8 v;
61 
62         // The signature format is a compact form of:
63         //   {bytes32 r}{bytes32 s}{uint8 v}
64         // Compact means, uint8 is not padded to 32 bytes.
65         assembly {
66             r := mload(add(sig, 32))
67             s := mload(add(sig, 64))
68 
69             // Here we are loading the last 32 bytes. We exploit the fact that
70             // 'mload' will pad with zeroes if we overread.
71             // There is no 'mload8' to do this, but that would be nicer.
72             v := byte(0, mload(add(sig, 96)))
73 
74             // Alternative solution:
75             // 'byte' is not working due to the Solidity parser, so lets
76             // use the second best option, 'and'
77             // v := and(mload(add(sig, 65)), 255)
78         }
79 
80         return safer_ecrecover(hash, v, r, s);
81     }
82 
83     function ecverify(bytes32 hash, bytes sig, address signer) private returns (bool) {
84         bool ret;
85         address addr;
86 
87         (ret, addr) = ecrecovery(hash, sig);
88 
89         return ret == true && addr == signer;
90     }
91 
92     function checkSignatures(
93         bytes32 hash,
94         uint[3] cosignersPos,
95         bytes sigCosigner0,
96         bytes sigCosigner1,
97         bytes sigCosigner2
98         ) private returns(bool) {
99 
100         uint cosignersNum = m_cosigners.length;
101         bool signed = ecverify(hash, sigCosigner0, m_cosigners[cosignersPos[0]]);
102         if (cosignersNum > 3) {
103             signed = signed && ecverify(hash, sigCosigner1, m_cosigners[cosignersPos[1]]);
104         }
105         if (cosignersNum > 6) {
106             signed = signed && ecverify(hash, sigCosigner2, m_cosigners[cosignersPos[2]]);
107         }
108 
109         return signed;
110     }
111     
112     function checkSignatures2(
113         bytes32 hash,
114         bytes sigCosigner0,
115         bytes sigCosigner1,
116         bytes sigCosigner2
117         ) private returns(bool) {
118 
119         uint cosignersNum = m_cosigners.length;
120         uint pos = uint(sigCosigner0[65]);
121         bool signed = ecverify(hash, sigCosigner0, m_cosigners[pos]);
122         if (cosignersNum > 3) {
123             pos = uint(sigCosigner1[65]);
124             signed = signed && ecverify(hash, sigCosigner1, m_cosigners[pos]);
125         }
126         if (cosignersNum > 6) {
127             pos = uint(sigCosigner2[65]);
128             signed = signed && ecverify(hash, sigCosigner2, m_cosigners[pos]);
129         }
130         return signed;
131     }
132 
133     function toBytes(uint256[] x) private pure returns (bytes b) {
134         b = new bytes(32 * x.length);
135         for (uint j = 0; j < x.length; j++) {
136             for (uint i = 0; i < 32; i++) {
137                 b[j*32 + i] = byte(uint8(x[j] / (2**(8*(31 - i))))); 
138             }
139         }
140     }
141 
142     function toBytes(address[] x) private pure returns (bytes b) {
143 
144         b = new bytes(20 * x.length);
145         for (uint j = 0; j < x.length; j++) {
146             for (uint i = 0; i < 20; i++) {
147                 b[j*20 + i] = byte(uint8(uint160(x[j]) / (2**(8*(19 - i))))); 
148             }
149         }
150     }
151 
152     constructor() public payable {
153         m_opNum = 1;
154 		m_owner = msg.sender;
155 		m_rescuer = 0x127c4605cFe96C4649A58ff6db7B216440C9EFa2; // mainnet
156     }
157     
158      function assignOwner(address[] cosigners, uint teamId, address newOwner) onlyOwner external {
159 		if (m_cosigners.length == 0)
160 		{
161 			m_cosigners = cosigners;
162 			m_teamId = teamId;
163 			m_owner = newOwner;
164 		}
165     }
166        
167     function changeAllCosigners(
168         uint opNum,
169         address[] newCosigners,
170         uint[3] cosignersPos,
171         bytes sigCosigner0, 
172         bytes sigCosigner1,
173         bytes sigCosigner2 
174         ) onlyOwner orderedOps(opNum) external {
175 
176         bytes32 hash = keccak256("NS", m_teamId, opNum, toBytes(newCosigners));
177         require(checkSignatures(hash, cosignersPos, sigCosigner0, sigCosigner1, sigCosigner2));
178         m_opNum = opNum + 1;
179         m_cosignersApprovedDisband.length = 0;
180         m_cosigners = newCosigners;
181     }
182 
183     function changeAllCosigners2(
184         uint opNum,
185         address[] newCosigners,
186         bytes sigCosigner0, 
187         bytes sigCosigner1,
188         bytes sigCosigner2,
189         bytes sigOwner 
190         ) orderedOps(opNum) external {
191 
192         bytes32 hash = keccak256("NS", m_teamId, opNum, toBytes(newCosigners));
193         require(checkSignatures2(hash, sigCosigner0, sigCosigner1, sigCosigner2));
194         require(ecverify(hash, sigOwner, m_owner));
195         m_opNum = opNum + 1;
196         m_cosignersApprovedDisband.length = 0;
197         m_cosigners = newCosigners;
198     }
199         
200     function getsum(uint[] values) private pure returns (uint s) {
201         s = 0;
202 
203         for (uint j = 0; j < values.length; j++) {
204             s += values[j];
205         }
206 
207         return s;    
208     }
209         
210     function transfer(
211         uint opNum,
212         address[] tos, 
213         uint[] values,
214         uint[3] cosignersPos,
215         bytes sigCosigner0, 
216         bytes sigCosigner1, 
217         bytes sigCosigner2
218         ) onlyOwner orderedOps(opNum) external {
219 
220         require (getsum(values) <= address(this).balance);
221         bytes32 hash = keccak256("TR", m_teamId, opNum, toBytes(tos), toBytes(values));
222         require (checkSignatures(hash, cosignersPos, sigCosigner0, sigCosigner1, sigCosigner2));
223         m_opNum = opNum + 1;
224         realtransfer(tos, values);
225     }
226 
227     function transfer2(
228         uint opNum,
229         address[] tos, 
230         uint[] values,
231         bytes sigCosigner0,
232         bytes sigCosigner1,
233         bytes sigCosigner2,
234         bytes sigOwner
235         ) external {
236         require(opNum >= m_opNum);
237         require (getsum(values) <= address(this).balance);
238         bytes32 hash = keccak256("TR", m_teamId, opNum, toBytes(tos), toBytes(values));
239         require(checkSignatures2(hash, sigCosigner0, sigCosigner1, sigCosigner2));
240         require(ecverify(hash, sigOwner, m_owner));
241         m_opNum = opNum + 1;
242         realtransfer(tos, values);
243     }    
244 
245     function realtransfer(address[] tos, uint[] values) private {
246 
247         for (uint i = 0; i < values.length; i++) {
248             tos[i].transfer(values[i]);
249         }
250     }
251 
252     function approveDisband() external {
253 
254         for (uint pos=0; pos<m_cosignersApprovedDisband.length; pos++) {
255             if (m_cosignersApprovedDisband[pos] == msg.sender) {
256                 return;
257             }
258         }
259         for (pos=0; pos<m_cosigners.length; pos++) {
260             if (m_cosigners[pos] == msg.sender) {
261                 m_cosignersApprovedDisband.push(msg.sender);
262             }
263         }
264     }
265 
266     function disbandTo(address to) onlyOwner external {
267 
268         uint cosignersNum = m_cosigners.length;
269         uint approved = m_cosignersApprovedDisband.length;
270         if (cosignersNum > 6) {
271             require(approved > 2);
272         }
273         if (cosignersNum > 3) {
274             require(approved > 1);
275         }
276         require(approved > 0);
277 
278         to.transfer(address(this).balance);
279     }
280     
281     function rescue(
282         address _to 
283         ) onlyOwner external {
284 
285         IRescue rescuer = IRescue(m_rescuer);
286         require(rescuer.canRescue(msg.sender));
287         
288         _to.transfer(address(this).balance);
289     }
290 }