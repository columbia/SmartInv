1 pragma solidity ^0.4.2;
2 
3 contract EC {
4 
5     uint256 constant public gx = 0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798;
6     uint256 constant public gy = 0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8;
7     uint256 constant public n = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;
8     uint256 constant public a = 0;
9     uint256 constant public b = 7;
10     uint256[] public gxs;
11     uint256[] public gys;
12     uint256[] public gzs;
13 
14     function EC() public
15     {
16         gxs.push(gx);
17         gys.push(gy);
18         gzs.push(1);
19     }
20     
21     function prepare(uint count) public
22     {
23         require(gxs.length < 256);
24         uint256 x = gxs[gxs.length - 1];
25         uint256 y = gys[gys.length - 1];
26         uint256 z = gzs[gzs.length - 1];
27         for (uint j = 0; j < count && gxs.length < 256; j++) {
28             (x,y,z) = _ecDouble(x,y,z);
29             gxs.push(x);
30             gys.push(y);
31             gzs.push(z);
32         }
33     }
34 
35     function _jAdd( uint256 x1,uint256 z1,
36                     uint256 x2,uint256 z2) public pure
37         returns(uint256 x3,uint256 z3)
38     {
39         (x3, z3) = (  addmod( mulmod(z2, x1 , n) ,
40                               mulmod(x2, z1 , n),
41                               n),
42                       mulmod(z1, z2 , n)
43                     );
44     }
45 
46     function _jSub( uint256 x1,uint256 z1,
47                     uint256 x2,uint256 z2) public pure
48         returns(uint256 x3,uint256 z3)
49     {
50         (x3, z3) = (  addmod( mulmod(z2, x1, n),
51                               mulmod(n - x2, z1, n),
52                               n),
53                       mulmod(z1, z2 , n)
54                     );
55     }
56 
57     function _jMul( uint256 x1,uint256 z1,
58                     uint256 x2,uint256 z2) public pure
59         returns(uint256 x3,uint256 z3)
60     {
61         (x3, z3) = (  mulmod(x1, x2 , n), mulmod(z1, z2 , n));
62     }
63 
64     function _jDiv( uint256 x1,uint256 z1,
65                     uint256 x2,uint256 z2) public pure
66         returns(uint256 x3,uint256 z3)
67     {
68         (x3, z3) = (  mulmod(x1, z2 , n), mulmod(z1 , x2 , n));
69     }
70 
71     function _inverse( uint256 val) public pure
72         returns(uint256 invVal)
73     {
74         uint256 t=0;
75         uint256 newT=1;
76         uint256 r=n;
77         uint256 newR=val;
78         uint256 q;
79         while (newR != 0) {
80             q = r / newR;
81 
82             (t, newT) = (newT, addmod(t , (n - mulmod(q, newT,n)) , n));
83             (r, newR) = (newR, r - q * newR );
84         }
85 
86         return t;
87     }
88 
89 
90     function _ecAdd( uint256 x1,uint256 y1,uint256 z1,
91                     uint256 x2,uint256 y2,uint256 z2) public pure
92         returns(uint256 x3,uint256 y3,uint256 z3)
93     {
94         uint256 l;
95         uint256 lz;
96         uint256 da;
97         uint256 db;
98 
99         if ((x1==0)&&(y1==0)) {
100             return (x2,y2,z2);
101         }
102 
103         if ((x2==0)&&(y2==0)) {
104             return (x1,y1,z1);
105         }
106 
107         if ((x1==x2)&&(y1==y2)) {
108             (l,lz) = _jMul(x1, z1, x1, z1);
109             (l,lz) = _jMul(l, lz, 3, 1);
110             (l,lz) = _jAdd(l, lz, a, 1);
111 
112             (da,db) = _jMul(y1, z1, 2, 1);
113         } else {
114             (l,lz) = _jSub(y2, z2, y1, z1);
115             (da,db)  = _jSub(x2, z2, x1, z1);
116         }
117 
118         (l, lz) = _jDiv(l, lz, da, db);
119 
120 
121         (x3, da) = _jMul(l, lz, l, lz);
122         (x3, da) = _jSub(x3, da, x1, z1);
123         (x3, da) = _jSub(x3, da, x2, z2);
124 
125         (y3, db) = _jSub(x1, z1, x3, da);
126         (y3, db) = _jMul(y3, db, l, lz );
127         (y3, db) = _jSub(y3, db, y1, z1 );
128 
129 
130         if (da != db) {
131             x3 = mulmod(x3, db, n);
132             y3 = mulmod(y3, da, n);
133             z3 = mulmod(da, db, n);
134         } else {
135             z3 = da;
136         }
137 
138     }
139 
140     function _ecDouble(uint256 x1,uint256 y1,uint256 z1) public pure
141         returns(uint256 x3,uint256 y3,uint256 z3)
142     {
143         (x3,y3,z3) = _ecAdd(x1,y1,z1,x1,y1,z1);
144     }
145 
146 
147 
148     function _ecMul(uint256 d, uint256 x1,uint256 y1,uint256 z1) public pure
149         returns(uint256 x3,uint256 y3,uint256 z3)
150     {
151         uint256 remaining = d;
152         uint256 px = x1;
153         uint256 py = y1;
154         uint256 pz = z1;
155         uint256 acx = 0;
156         uint256 acy = 0;
157         uint256 acz = 1;
158 
159         if (d==0) {
160             return (0,0,1);
161         }
162 
163         while (remaining != 0) {
164             if ((remaining & 1) != 0) {
165                 (acx,acy,acz) = _ecAdd(acx,acy,acz, px,py,pz);
166             }
167             remaining = remaining / 2;
168             (px,py,pz) = _ecDouble(px,py,pz);
169         }
170 
171         (x3,y3,z3) = (acx,acy,acz);
172     }
173 
174     function publicKey(uint256 privKey) public constant
175         returns(uint256 qx, uint256 qy)
176     {
177         uint256 acx = 0;
178         uint256 acy = 0;
179         uint256 acz = 1;
180 
181         if (privKey == 0) {
182             return (0,0);
183         }
184 
185         for (uint i = 0; i < 256; i++) {
186             if (((privKey >> i) & 1) != 0) {
187                 (acx,acy,acz) = _ecAdd(acx,acy,acz, gxs[i],gys[i],gzs[i]);
188             }
189         }
190         
191         acz = _inverse(acz);
192         (qx,qy) = (mulmod(acx,acz,n),mulmod(acy,acz,n));
193     }
194 
195     function deriveKey(uint256 privKey, uint256 pubX, uint256 pubY) public pure
196         returns(uint256 qx, uint256 qy)
197     {
198         uint256 x;
199         uint256 y;
200         uint256 z;
201         (x,y,z) = _ecMul(privKey, pubX, pubY, 1);
202         z = _inverse(z);
203         qx = mulmod(x , z ,n);
204         qy = mulmod(y , z ,n);
205     }
206 
207 }