1 pragma solidity ^0.4.19;
2 
3 contract TeambrellaWallet {
4     
5     uint public m_opNum;
6     uint public m_teamId;
7     address public m_owner;
8     address[] public m_cosigners;
9     address[] public m_cosignersApprovedDisband;    
10     
11     modifier orderedOps(uint opNum) {
12         require(opNum >= m_opNum);
13         _; 
14     }
15 
16     modifier onlyOwner {
17         require(msg.sender == m_owner);
18         _; 
19     }
20     
21     function() public payable { }
22 
23 
24     // Duplicate Solidity's ecrecover, but catching the CALL return value
25     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
26         // We do our own memory management here. Solidity uses memory offset
27         // 0x40 to store the current end of memory. We write past it (as
28         // writes are memory extensions), but don't update the offset so
29         // Solidity will reuse it. The memory used here is only needed for
30         // this context.
31 
32         bool ret;
33         address addr;
34 
35         assembly {
36             let size := mload(0x40)
37             mstore(size, hash)
38             mstore(add(size, 32), v)
39             mstore(add(size, 64), r)
40             mstore(add(size, 96), s)
41 
42             // NOTE: we can reuse the request memory because we deal with
43             //       the return code
44             ret := call(3000, 1, 0, size, 128, size, 32)
45             addr := mload(size)
46         }
47 
48         return (ret, addr);
49     }
50 
51     function ecrecovery(bytes32 hash, bytes sig) private returns (bool, address) {
52         bytes32 r;
53         bytes32 s;
54         uint8 v;
55 
56         // The signature format is a compact form of:
57         //   {bytes32 r}{bytes32 s}{uint8 v}
58         // Compact means, uint8 is not padded to 32 bytes.
59         assembly {
60             r := mload(add(sig, 32))
61             s := mload(add(sig, 64))
62 
63             // Here we are loading the last 32 bytes. We exploit the fact that
64             // 'mload' will pad with zeroes if we overread.
65             // There is no 'mload8' to do this, but that would be nicer.
66             v := byte(0, mload(add(sig, 96)))
67 
68             // Alternative solution:
69             // 'byte' is not working due to the Solidity parser, so lets
70             // use the second best option, 'and'
71             // v := and(mload(add(sig, 65)), 255)
72         }
73 
74         return safer_ecrecover(hash, v, r, s);
75     }
76 
77     function ecverify(bytes32 hash, bytes sig, address signer) private returns (bool) {
78         bool ret;
79         address addr;
80 
81         (ret, addr) = ecrecovery(hash, sig);
82 
83         return ret == true && addr == signer;
84     }
85 
86     function checkSignatures(
87         bytes32 hash,
88         uint[3] cosignersPos,
89         bytes sigCosigner0,
90         bytes sigCosigner1,
91         bytes sigCosigner2
92         ) private returns(bool) {
93 
94         uint cosignersNum = m_cosigners.length;
95         bool signed = ecverify(hash, sigCosigner0, m_cosigners[cosignersPos[0]]);
96         if (cosignersNum > 3) {
97             signed = signed && ecverify(hash, sigCosigner1, m_cosigners[cosignersPos[1]]);
98         }
99         if (cosignersNum > 6) {
100             signed = signed && ecverify(hash, sigCosigner2, m_cosigners[cosignersPos[2]]);
101         }
102 
103         return signed;
104     }
105     
106     function checkSignatures2(
107         bytes32 hash,
108         bytes sigCosigner0,
109         bytes sigCosigner1,
110         bytes sigCosigner2
111         ) private returns(bool) {
112 
113         uint cosignersNum = m_cosigners.length;
114         uint pos = uint(sigCosigner0[65]);
115         bool signed = ecverify(hash, sigCosigner0, m_cosigners[pos]);
116         if (cosignersNum > 3) {
117             pos = uint(sigCosigner1[65]);
118             signed = signed && ecverify(hash, sigCosigner1, m_cosigners[pos]);
119         }
120         if (cosignersNum > 6) {
121             pos = uint(sigCosigner2[65]);
122             signed = signed && ecverify(hash, sigCosigner2, m_cosigners[pos]);
123         }
124         return signed;
125     }
126 
127     function toBytes(uint256[] x) private pure returns (bytes b) {
128         b = new bytes(32 * x.length);
129         for (uint j = 0; j < x.length; j++) {
130             for (uint i = 0; i < 32; i++) {
131                 b[j*32 + i] = byte(uint8(x[j] / (2**(8*(31 - i))))); 
132             }
133         }
134     }
135 
136     function toBytes(address[] x) private pure returns (bytes b) {
137 
138         b = new bytes(20 * x.length);
139         for (uint j = 0; j < x.length; j++) {
140             for (uint i = 0; i < 20; i++) {
141                 b[j*20 + i] = byte(uint8(uint160(x[j]) / (2**(8*(19 - i))))); 
142             }
143         }
144     }
145 
146     function TeambrellaWallet() public payable {
147         m_opNum = 1;
148 		m_owner = msg.sender;
149     }
150     
151      function assignOwner(address[] cosigners, uint teamId, address newOwner) onlyOwner external {
152 		if (m_cosigners.length == 0)
153 		{
154 			m_cosigners = cosigners;
155 			m_teamId = teamId;
156 			m_owner = newOwner;
157 		}
158     }
159        
160     function changeAllCosigners(
161         uint opNum,
162         address[] newCosigners,
163         uint[3] cosignersPos,
164         bytes sigCosigner0, 
165         bytes sigCosigner1,
166         bytes sigCosigner2 
167         ) onlyOwner orderedOps(opNum) external {
168 
169         bytes32 hash = keccak256("NS", m_teamId, opNum, toBytes(newCosigners));
170         require(checkSignatures(hash, cosignersPos, sigCosigner0, sigCosigner1, sigCosigner2));
171         m_opNum = opNum + 1;
172         m_cosignersApprovedDisband.length = 0;
173         m_cosigners = newCosigners;
174     }
175 
176     function changeAllCosigners2(
177         uint opNum,
178         address[] newCosigners,
179         bytes sigCosigner0, 
180         bytes sigCosigner1,
181         bytes sigCosigner2,
182         bytes sigOwner 
183         ) onlyOwner orderedOps(opNum) external {
184 
185         bytes32 hash = keccak256("NS", m_teamId, opNum, toBytes(newCosigners));
186         require(checkSignatures2(hash, sigCosigner0, sigCosigner1, sigCosigner2));
187         require(ecverify(hash, sigOwner, m_owner));
188         m_opNum = opNum + 1;
189         m_cosignersApprovedDisband.length = 0;
190         m_cosigners = newCosigners;
191     }
192         
193     function getsum(uint[] values) private pure returns (uint s) {
194         s = 0;
195 
196         for (uint j = 0; j < values.length; j++) {
197             s += values[j];
198         }
199 
200         return s;    
201     }
202         
203     function transfer(
204         uint opNum,
205         address[] tos, 
206         uint[] values,
207         uint[3] cosignersPos,
208         bytes sigCosigner0, 
209         bytes sigCosigner1, 
210         bytes sigCosigner2
211         ) onlyOwner orderedOps(opNum) external {
212 
213         require (getsum(values) <= this.balance);
214         bytes32 hash = keccak256("TR", m_teamId, opNum, toBytes(tos), toBytes(values));
215         require (checkSignatures(hash, cosignersPos, sigCosigner0, sigCosigner1, sigCosigner2));
216         m_opNum = opNum + 1;
217         realtransfer(tos, values);
218     }
219 
220     function transfer2(
221         uint opNum,
222         address[] tos, 
223         uint[] values,
224         bytes sigCosigner0,
225         bytes sigCosigner1,
226         bytes sigCosigner2,
227         bytes sigOwner
228         ) external {
229         require(opNum >= m_opNum);
230         require (getsum(values) <= this.balance);
231         bytes32 hash = keccak256("TR", m_teamId, opNum, toBytes(tos), toBytes(values));
232         require(checkSignatures2(hash, sigCosigner0, sigCosigner1, sigCosigner2));
233         require(ecverify(hash, sigOwner, m_owner));
234         m_opNum = opNum + 1;
235         realtransfer(tos, values);
236     }    
237 
238     function realtransfer(address[] tos, uint[] values) private {
239 
240         for (uint i = 0; i < values.length; i++) {
241             tos[i].transfer(values[i]);
242         }
243     }
244 
245     function approveDisband() external {
246 
247         for (uint pos=0; pos<m_cosignersApprovedDisband.length; pos++) {
248             if (m_cosignersApprovedDisband[pos] == msg.sender) {
249                 return;
250             }
251         }
252         for (pos=0; pos<m_cosigners.length; pos++) {
253             if (m_cosigners[pos] == msg.sender) {
254                 m_cosignersApprovedDisband.push(msg.sender);
255             }
256         }
257     }
258 
259     function disbandTo(address to) onlyOwner external {
260 
261         uint cosignersNum = m_cosigners.length;
262         uint approved = m_cosignersApprovedDisband.length;
263         if (cosignersNum > 6) {
264             require(approved > 2);
265         }
266         if (cosignersNum > 3) {
267             require(approved > 1);
268         }
269         require(approved > 0);
270 
271         to.transfer(this.balance);
272     }
273 }