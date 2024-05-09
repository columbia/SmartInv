1 /* */
2 
3 /* Deployment:
4 Owner: 0xeb5fa6cbf2aca03a0df228f2df67229e2d3bd01e
5 Last address: TBD
6 ABI: TBD
7 Optimized: yes
8 Solidity version: v0.4.3
9 */
10 
11 pragma solidity ^0.4.0;
12 
13 contract Arith {
14     
15     address private owner;
16     uint constant internal P = 115792089237316195423570985008687907853269984665640564039457584007908834671663;
17     uint constant internal N = 115792089237316195423570985008687907852837564279074904382605163141518161494337;
18     uint constant internal M = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
19     uint constant internal Gx = 55066263022277343669578718895168534326250603453777594175500187360389116729240;
20     uint constant internal Gy = 32670510020758816978083085130507043184471273380659243275938904335757337482424;
21     
22     uint k1x;
23     uint k1y;
24     uint k1z;
25     uint k2x;
26     uint k2y;
27     uint k2z;
28     uint pub1x;
29     uint pub1y;
30     uint pub2x;
31     uint pub2y;
32     uint k3x;
33     uint k3y;
34 
35     modifier onlyOwner {
36         if (msg.sender != owner)
37           throw;
38         _;
39     }
40     
41     function Arith() { owner = msg.sender; }
42 
43     function kill() onlyOwner { suicide(owner); }
44 
45     function jdouble(uint _ax, uint _ay, uint _az) returns (uint, uint, uint) {
46 
47         if(_ay == 0) return (0, 0, 0);
48 
49         uint ysq = _ay * _ay;
50         uint s = 4 * _ax * ysq;
51         uint m = 3 * _ax * _ax;
52         uint nx = m * m - 2 * s;
53         uint ny = m * (s - nx) - 8 * ysq * ysq;
54         uint nz = 2 * _ay * _az;
55         return (nx, ny, nz);
56     }
57 
58     function jadd(uint _ax, uint _ay, uint _az, uint _bx, uint _by, uint _bz) returns (uint, uint, uint) {
59 
60         if(_ay == 0) return (0, 0, 0);
61         if(_ay == 0) return(_bx, _by, _bz);
62         if(_by == 0) return(_ax, _ay, _az);
63 
64         uint u1 = _ax * _bz * _bz;
65         uint u2 = _bx * _az * _az;
66         uint s1 = _ay * _bz * _bz * _bz;
67         uint s2 = _by * _az * _az * _az;
68 
69         if(u1 == u2) {
70            if(s1 != s2) return(0, 0, 1);
71            return jdouble(_ax, _ay, _az);
72         }
73         
74         uint nx = (s2 - s1) * (s2 - s1) - (u2 - u1) * (u2 - u1) * (u2 - u1) - 2 * u1 * (u2 - u1) * (u2 - u1);
75 
76         return
77             (nx,
78              (s2 - s1) * (u1 * (u2 - u1) * (u2 - u1) - nx) - s1 * (u2 - u1) * (u2 - u1) * (u2 - u1),
79              (u2 - u1) * _az * _bz);
80     }
81 
82     function jmul(uint _bx, uint _by, uint _bz, uint _n) returns (uint, uint, uint) {
83 
84         _n = _n % N;
85         if(((_bx == 0) && (_by == 0)) || (_n == 0)) return(0, 0, 1);
86 
87         uint ax;
88         uint ay;
89         uint az;
90         (ax, ay, az) = (0, 0, 1);
91         uint b = M;
92         
93         while(b > 0) {
94 
95            (ax, ay, az) = jdouble(ax, ay, az);
96            if((_n & b) != 0) {
97               
98               if(ay == 0) {
99                  (ax, ay, az) = (_bx, _by, _bz);
100               } else {
101                  (ax, ay, az) = jadd(ax, ay, az, _bx, _by, _bz);
102               }
103            }
104 
105            b = b / 2;
106         }
107 
108         return (ax, ay, az);
109     }
110     
111     function jexp(uint _b, uint _e, uint _m) returns (uint) {
112         uint o = 1;
113         uint bit = M;
114         
115         while (bit > 0) {
116             uint bitval = 0;
117             if(_e & bit > 0) bitval = 1;
118             o = mulmod(mulmod(o, o, _m), _b ** bitval, _m);
119             bitval = 0;
120             if(_e & (bit / 2) > 0) bitval = 1;
121             o = mulmod(mulmod(o, o, _m), _b ** bitval, _m);
122             bitval = 0;
123             if(_e & (bit / 4) > 0) bitval = 1;
124             o = mulmod(mulmod(o, o, _m), _b ** bitval, _m);
125             bitval = 0;
126             if(_e & (bit / 8) > 0) bitval = 1;
127             o = mulmod(mulmod(o, o, _m), _b ** bitval, _m);
128             bit = (bit / 16);
129         }
130         return o;
131     }
132     
133     function jrecover_y(uint _x, uint _y_bit) returns (uint) {
134 
135         uint xcubed = mulmod(mulmod(_x, _x, P), _x, P);
136         uint beta = jexp(addmod(xcubed, 7, P), ((P + 1) / 4), P);
137         uint y_is_positive = _y_bit ^ (beta % 2) ^ 1;
138         return(beta * y_is_positive + (P - beta) * (1 - y_is_positive));
139     }
140 
141     function jdecompose(uint _q0, uint _q1, uint _q2) returns (uint, uint) {
142         uint ox = mulmod(_q0, jexp(_q2, P - 3, P), P);
143         uint oy = mulmod(_q1, jexp(_q2, P - 4, P), P);
144         return(ox, oy);
145     }
146 
147     function ecmul(uint _x, uint _y, uint _z, uint _n) returns (uint, uint, uint) {
148         return jmul(_x, _y, _z, _n);
149     }
150 
151     function ecadd(uint _ax, uint _ay, uint _az, uint _bx, uint _by, uint _bz) returns (uint, uint, uint) {
152         return jadd(_ax, _ay, _az, _bx, _by, _bz);
153     }
154 
155     function ecsubtract(uint _ax, uint _ay, uint _az, uint _bx, uint _by, uint _bz) returns (uint, uint, uint) {
156         return jadd(_ax, _ay, _az, _bx, P - _by, _bz);
157     }
158 
159     function bit(uint _data, uint _bit) returns (uint) {
160         return (_data / 2**(_bit % 8)) % 2;
161     }
162 
163     function hash_pubkey_to_pubkey(uint _pub1, uint _pub2) returns (uint, uint) {
164         uint x = uint(sha3(_pub1, _pub2));
165         while(true) {
166             uint xcubed = mulmod(mulmod(x, x, P), x, P);
167             uint beta = jexp(addmod(xcubed, 7, P), ((P + 1) / 4), P);
168             uint y = beta * (beta % 2) + (P - beta) * (1 - (beta % 2));
169             if(addmod(xcubed, 7, P) == mulmod(y, y, P)) return(x, y);
170             x = ((x + 1) % P);
171         }
172     }
173     
174     function verify(uint _msgHash, uint _x0, uint[] _s, uint _Ix, uint _Iy, uint[] _pub_xs, uint[] _pub_ys) returns (bool) {
175         //_Iy = jrecover_y(_Ix, _Iy);
176         uint[] memory ex = new uint[](_pub_xs.length);
177         uint[] memory ey = new uint[](_pub_xs.length);
178         ex[0] = _x0;
179         ey[0] = uint(sha3(_x0));
180         uint i = 1;
181         while(i < (_pub_xs.length + 1)) {
182 
183            //uint pub_yi = jrecover_y(_pub_xs[i % _pub_xs.length], bit(_pub_ys, i % _pub_xs.length));
184            (k1x, k1y, k1z) = ecmul(Gx, Gy, 1, _s[(i - 1) % _pub_xs.length]);
185            (k2x, k2y, k2z) = ecmul(_pub_xs[i % _pub_xs.length], _pub_ys[i % _pub_xs.length], 1, ey[(i - 1) % _pub_xs.length]);
186            (k1x, k1y, k1z) = ecsubtract(k1x, k1y, k1z, k2x, k2y, k2z);
187            (pub1x, pub1y) = jdecompose(k1x, k1y, k1z);
188            (k3x, k3y) = hash_pubkey_to_pubkey(_pub_xs[i % _pub_xs.length], _pub_ys[i % _pub_xs.length]);
189            (k1x, k1y, k1z) = ecmul(k3x, k3y, 1, _s[(i - 1) % _pub_xs.length]);
190            (k2x, k2y, k2z) = ecmul(_Ix, _Iy, 1, ey[(i - 1) % _pub_xs.length]);
191            (k1x, k1y, k1z) = ecsubtract(k1x, k1y, k1z, k2x, k2y, k2z);
192            (pub2x, pub2y) = jdecompose(k1x, k1y, k1z);
193            uint left = uint(sha3([_msgHash, pub1x, pub1y, pub2x, pub2y]));
194            uint right = uint(sha3(left));
195            ex[i] = left;
196            ey[i] = right;
197            i += 1;
198         }
199         
200         return((ex[_pub_xs.length] == ex[0]) && (ey[_pub_xs.length] == ey[0]));
201     }
202 
203     function () {
204         throw;
205     }
206 }