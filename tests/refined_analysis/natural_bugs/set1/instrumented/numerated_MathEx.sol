1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.19;
3 
4 /**
5  * @dev this library provides a set of complex math operations
6  */
7 library MathEx {
8     error Overflow();
9 
10     struct Uint512 {
11         uint256 hi; // 256 most significant bits
12         uint256 lo; // 256 least significant bits
13     }
14 
15     /**
16      * @dev returns the largest integer smaller than or equal to `x * y / z`
17      */
18     function mulDivF(uint256 x, uint256 y, uint256 z) internal pure returns (uint256) {
19         Uint512 memory xy = _mul512(x, y);
20 
21         // if `x * y < 2 ^ 256`
22         if (xy.hi == 0) {
23             return xy.lo / z;
24         }
25 
26         // assert `x * y / z < 2 ^ 256`
27         if (xy.hi >= z) {
28             revert Overflow();
29         }
30 
31         uint256 m = _mulMod(x, y, z); // `m = x * y % z`
32         Uint512 memory n = _sub512(xy, m); // `n = x * y - m` hence `n / z = floor(x * y / z)`
33 
34         // if `n < 2 ^ 256`
35         if (n.hi == 0) {
36             return n.lo / z;
37         }
38 
39         uint256 p = _unsafeSub(0, z) & z; // `p` is the largest power of 2 which `z` is divisible by
40         uint256 q = _div512(n, p); // `n` is divisible by `p` because `n` is divisible by `z` and `z` is divisible by `p`
41         uint256 r = _inv256(z / p); // `z / p = 1 mod 2` hence `inverse(z / p) = 1 mod 2 ^ 256`
42         return _unsafeMul(q, r); // `q * r = (n / p) * inverse(z / p) = n / z`
43     }
44 
45     /**
46      * @dev returns the smallest integer larger than or equal to `x * y / z`
47      */
48     function mulDivC(uint256 x, uint256 y, uint256 z) internal pure returns (uint256) {
49         uint256 w = mulDivF(x, y, z);
50         if (_mulMod(x, y, z) > 0) {
51             if (w >= type(uint256).max) {
52                 revert Overflow();
53             }
54 
55             return w + 1;
56         }
57         return w;
58     }
59 
60     /**
61      * @dev returns the value of `x * y`
62      */
63     function _mul512(uint256 x, uint256 y) private pure returns (Uint512 memory) {
64         uint256 p = _mulModMax(x, y);
65         uint256 q = _unsafeMul(x, y);
66         if (p >= q) {
67             return Uint512({ hi: p - q, lo: q });
68         }
69         return Uint512({ hi: _unsafeSub(p, q) - 1, lo: q });
70     }
71 
72     /**
73      * @dev returns the value of `x - y`
74      */
75     function _sub512(Uint512 memory x, uint256 y) private pure returns (Uint512 memory) {
76         if (x.lo >= y) {
77             return Uint512({ hi: x.hi, lo: x.lo - y });
78         }
79         return Uint512({ hi: x.hi - 1, lo: _unsafeSub(x.lo, y) });
80     }
81 
82     /**
83      * @dev returns the value of `x / pow2n`, given that `x` is divisible by `pow2n`
84      */
85     function _div512(Uint512 memory x, uint256 pow2n) private pure returns (uint256) {
86         uint256 pow2nInv = _unsafeAdd(_unsafeSub(0, pow2n) / pow2n, 1); // `1 << (256 - n)`
87         return _unsafeMul(x.hi, pow2nInv) | (x.lo / pow2n); // `(x.hi << (256 - n)) | (x.lo >> n)`
88     }
89 
90     /**
91      * @dev returns the inverse of `d` modulo `2 ^ 256`, given that `d` is congruent to `1` modulo `2`
92      */
93     function _inv256(uint256 d) private pure returns (uint256) {
94         // approximate the root of `f(x) = 1 / x - d` using the newton–raphson convergence method
95         uint256 x = 1;
96         for (uint256 i = 0; i < 8; i++) {
97             x = _unsafeMul(x, _unsafeSub(2, _unsafeMul(x, d))); // `x = x * (2 - x * d) mod 2 ^ 256`
98         }
99         return x;
100     }
101 
102     /**
103      * @dev returns `(x + y) % 2 ^ 256`
104      */
105     function _unsafeAdd(uint256 x, uint256 y) private pure returns (uint256) {
106         unchecked {
107             return x + y;
108         }
109     }
110 
111     /**
112      * @dev returns `(x - y) % 2 ^ 256`
113      */
114     function _unsafeSub(uint256 x, uint256 y) private pure returns (uint256) {
115         unchecked {
116             return x - y;
117         }
118     }
119 
120     /**
121      * @dev returns `(x * y) % 2 ^ 256`
122      */
123     function _unsafeMul(uint256 x, uint256 y) private pure returns (uint256) {
124         unchecked {
125             return x * y;
126         }
127     }
128 
129     /**
130      * @dev returns `x * y % (2 ^ 256 - 1)`
131      */
132     function _mulModMax(uint256 x, uint256 y) private pure returns (uint256) {
133         return mulmod(x, y, type(uint256).max);
134     }
135 
136     /**
137      * @dev returns `x * y % z`
138      */
139     function _mulMod(uint256 x, uint256 y, uint256 z) private pure returns (uint256) {
140         return mulmod(x, y, z);
141     }
142 }
