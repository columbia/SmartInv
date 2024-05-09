1 /* Deployment:
2 Owner: 0xeb5fa6cbf2aca03a0df228f2df67229e2d3bd01e
3 Last address: 0x401e28717a6a35a50938bc7f290f2678fc0a2816
4 ABI: [{"constant":true,"inputs":[],"name":"gotParticipants","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_signature","type":"uint256[]"},{"name":"_x0","type":"uint256"},{"name":"_Ix","type":"uint256"},{"name":"_Iy","type":"uint256"}],"name":"withdrawStart","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"pubkeys2","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"payment","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"pubkeys1","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"participants","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"withdrawStep","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"withdrawFinal","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_pubkey1","type":"uint256"},{"name":"_pubkey2","type":"uint256"}],"name":"deposit","outputs":[],"payable":true,"type":"function"},{"inputs":[{"name":"_participants","type":"uint256"},{"name":"_payment","type":"uint256"}],"type":"constructor"},{"payable":false,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"message","type":"string"}],"name":"LogDebug","type":"event"}]
5 Optimized: yes
6 Solidity version: v0.4.4
7 */
8 
9 pragma solidity ^0.4.0;
10 
11 contract ArithLib {
12 
13     function jdouble(uint _ax, uint _ay, uint _az) constant returns (uint, uint, uint);
14     function jadd(uint _ax, uint _ay, uint _az, uint _bx, uint _by, uint _bz) constant returns (uint, uint, uint);
15     function jsub(uint _ax, uint _ay, uint _az, uint _bx, uint _by, uint _bz) constant returns (uint, uint, uint);
16     function jmul(uint _bx, uint _by, uint _bz, uint _n) constant returns (uint, uint, uint);
17     function jexp(uint _b, uint _e, uint _m) constant returns (uint);
18     function jrecover_y(uint _x, uint _y_bit) constant returns (uint);
19     function jdecompose(uint _q0, uint _q1, uint _q2) constant returns (uint, uint);
20     function isbit(uint _data, uint _bit) constant returns (uint);
21     function hash_pubkey_to_pubkey(uint _pub1, uint _pub2) constant returns (uint, uint);
22 }
23 
24 contract Laundromat {
25 
26     struct WithdrawInfo {
27 
28         address sender;
29         uint Ix;
30         uint Iy;
31         uint[] signature;
32         uint[] ring1;
33         uint[] ring2;
34         
35         uint step;
36         uint prevStep;
37     }
38 
39     uint constant internal safeGas = 25000;
40     uint constant internal P = 115792089237316195423570985008687907853269984665640564039457584007908834671663;
41     uint constant internal Gx = 55066263022277343669578718895168534326250603453777594175500187360389116729240;
42     uint constant internal Gy = 32670510020758816978083085130507043184471273380659243275938904335757337482424;
43 
44     address private owner;
45     bool private atomicLock;
46     
47     address internal constant arithAddress = 0x600ad7b57f3e6aeee53acb8704a5ed50b60cacd6;
48     ArithLib private arithContract;
49     mapping (uint => WithdrawInfo) private withdraws;
50     mapping (uint => bool) private consumed;
51 
52     uint public participants = 0;
53     uint public payment = 0;
54     uint public gotParticipants = 0;
55     uint[] public pubkeys1;
56     uint[] public pubkeys2;
57 
58     event LogDebug(string message);
59 
60     //create new mixing contract with _participants amount of mixing participants,
61     //_payment - expected payment from each participant.
62     function Laundromat(uint _participants, uint _payment) {
63         owner = msg.sender;
64         arithContract = ArithLib(arithAddress);
65 
66         participants = _participants;
67         payment = _payment;
68     }
69     
70     function safeSend(address addr, uint value) internal {
71 
72         if(atomicLock) throw;
73         atomicLock = true;
74         if (!(addr.call.gas(safeGas).value(value)())) {
75             atomicLock = false;
76             throw;
77         }
78         atomicLock = false;
79     }
80 
81     //add new participant to the mixing
82     function deposit(uint _pubkey1, uint _pubkey2) payable {
83         //if(msg.value != payment) throw;
84         if(gotParticipants >= participants) throw;
85 
86         pubkeys1.push(_pubkey1);
87         pubkeys2.push(_pubkey2);
88         gotParticipants++;
89     }
90 
91     //get funds from the mixer. Requires valid signature.
92     function withdrawStart(uint[] _signature, uint _x0, uint _Ix, uint _Iy) {
93         if(gotParticipants < participants) throw;
94         if(consumed[uint(sha3([_Ix, _Iy]))]) throw;
95 
96         WithdrawInfo withdraw = withdraws[uint(msg.sender)];
97 
98         withdraw.sender = msg.sender;
99         withdraw.Ix = _Ix;
100         withdraw.Iy = _Iy;
101         withdraw.signature = _signature;
102 
103         withdraw.ring1.length = 0;
104         withdraw.ring2.length = 0;
105         withdraw.ring1.push(_x0);
106         withdraw.ring2.push(uint(sha3(_x0)));
107         
108         withdraw.step = 1;
109         withdraw.prevStep = 0;
110     }
111 
112     function withdrawStep() {
113         WithdrawInfo withdraw = withdraws[uint(msg.sender)];
114 
115         //throw if existing witdhraw not started
116         if(withdraw.step < 1) throw;
117         if(withdraw.step > participants) throw;
118         if(consumed[uint(sha3([withdraw.Ix, withdraw.Iy]))]) throw;
119 
120         uint k1x;
121         uint k1y;
122         uint k1z;
123         uint k2x;
124         uint k2y;
125         uint k2z;
126         uint pub1x;
127         uint pub1y;
128         
129         (k1x, k1y, k1z) = arithContract.jmul(Gx, Gy, 1,
130             withdraw.signature[withdraw.prevStep % participants]);
131         (k2x, k2y, k2z) = arithContract.jmul(
132             pubkeys1[withdraw.step % participants],
133             pubkeys2[withdraw.step % participants], 1,
134             withdraw.ring2[withdraw.prevStep % participants]);
135         //ksub1
136         (k1x, k1y, k1z) = arithContract.jsub(k1x, k1y, k1z, k2x, k2y, k2z);
137         (pub1x, pub1y) = arithContract.jdecompose(k1x, k1y, k1z);
138         //k3
139         (k1x, k1y) = arithContract.hash_pubkey_to_pubkey(
140             pubkeys1[withdraw.step % participants],
141             pubkeys2[withdraw.step % participants]);
142         //k4 = ecmul(k3, s[prev_i])
143         (k1x, k1y, k1z) = arithContract.jmul(k1x, k1y, 1,
144             withdraw.signature[withdraw.prevStep % participants]);
145         //k5 = ecmul(I, e[prev_i].right)
146         (k2x, k2y, k2z) = arithContract.jmul(withdraw.Ix, withdraw.Iy, 1,
147             withdraw.ring2[withdraw.prevStep % participants]);
148         //ksub2
149         (k1x, k1y, k1z) = arithContract.jsub(k1x, k1y, k1z, k2x, k2y, k2z);
150         //pub2x, pub2y
151         (k1x, k1y) = arithContract.jdecompose(k1x, k1y, k1z);
152         withdraw.ring1.push(uint(sha3([uint(withdraw.sender), pub1x, pub1y, k1x, k1y])));
153         withdraw.ring2.push(uint(sha3(uint(sha3([uint(withdraw.sender), pub1x, pub1y, k1x, k1y])))));
154         withdraw.step++;
155         withdraw.prevStep++;
156     }
157     
158     function withdrawFinal() returns (bool) {
159         WithdrawInfo withdraw = withdraws[uint(msg.sender)];
160         
161         if(withdraw.step != (participants + 1)) throw;
162         if(consumed[uint(sha3([withdraw.Ix, withdraw.Iy]))]) throw;
163         if(withdraw.ring1[participants] != withdraw.ring1[0]) {
164             
165             LogDebug("Wrong signature");
166             return false;
167         }
168         if(withdraw.ring2[participants] != withdraw.ring2[0]) {
169             
170             LogDebug("Wrong signature");
171             return false;
172         }
173         
174         withdraw.step++;
175         consumed[uint(sha3([withdraw.Ix, withdraw.Iy]))] = true;
176         safeSend(withdraw.sender, payment);
177         return true;
178     }
179 
180     function () {
181         throw;
182     }
183 }