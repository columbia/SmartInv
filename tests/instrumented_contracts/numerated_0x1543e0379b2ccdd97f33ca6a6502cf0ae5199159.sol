1 /// price-feed.sol
2 
3 // Copyright (C) 2017  DappHub, LLC
4 
5 // Licensed under the Apache License, Version 2.0 (the "License").
6 // You may not use this file except in compliance with the License.
7 
8 // Unless required by applicable law or agreed to in writing, software
9 // distributed under the License is distributed on an "AS IS" BASIS,
10 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
11 
12 pragma solidity ^0.4.17;
13 
14 contract DSAuthority {
15     function canCall(
16         address src, address dst, bytes4 sig
17     ) public view returns (bool);
18 }
19 
20 contract DSAuthEvents {
21     event LogSetAuthority (address indexed authority);
22     event LogSetOwner     (address indexed owner);
23 }
24 
25 contract DSAuth is DSAuthEvents {
26     DSAuthority  public  authority;
27     address      public  owner;
28 
29     function DSAuth() public {
30         owner = msg.sender;
31         LogSetOwner(msg.sender);
32     }
33 
34     function setOwner(address owner_)
35         public
36         auth
37     {
38         owner = owner_;
39         LogSetOwner(owner);
40     }
41 
42     function setAuthority(DSAuthority authority_)
43         public
44         auth
45     {
46         authority = authority_;
47         LogSetAuthority(authority);
48     }
49 
50     modifier auth {
51         require(isAuthorized(msg.sender, msg.sig));
52         _;
53     }
54 
55     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
56         if (src == address(this)) {
57             return true;
58         } else if (src == owner) {
59             return true;
60         } else if (authority == DSAuthority(0)) {
61             return false;
62         } else {
63             return authority.canCall(src, this, sig);
64         }
65     }
66 }
67 
68 contract DSNote {
69     event LogNote(
70         bytes4   indexed  sig,
71         address  indexed  guy,
72         bytes32  indexed  foo,
73         bytes32  indexed  bar,
74         uint              wad,
75         bytes             fax
76     ) anonymous;
77 
78     modifier note {
79         bytes32 foo;
80         bytes32 bar;
81 
82         assembly {
83             foo := calldataload(4)
84             bar := calldataload(36)
85         }
86 
87         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
88 
89         _;
90     }
91 }
92 
93 contract DSMath {
94     function add(uint x, uint y) internal pure returns (uint z) {
95         require((z = x + y) >= x);
96     }
97     function sub(uint x, uint y) internal pure returns (uint z) {
98         require((z = x - y) <= x);
99     }
100     function mul(uint x, uint y) internal pure returns (uint z) {
101         require(y == 0 || (z = x * y) / y == x);
102     }
103 
104     function min(uint x, uint y) internal pure returns (uint z) {
105         return x <= y ? x : y;
106     }
107     function max(uint x, uint y) internal pure returns (uint z) {
108         return x >= y ? x : y;
109     }
110     function imin(int x, int y) internal pure returns (int z) {
111         return x <= y ? x : y;
112     }
113     function imax(int x, int y) internal pure returns (int z) {
114         return x >= y ? x : y;
115     }
116 
117     uint constant WAD = 10 ** 18;
118     uint constant RAY = 10 ** 27;
119 
120     function wmul(uint x, uint y) internal pure returns (uint z) {
121         z = add(mul(x, y), WAD / 2) / WAD;
122     }
123     function rmul(uint x, uint y) internal pure returns (uint z) {
124         z = add(mul(x, y), RAY / 2) / RAY;
125     }
126     function wdiv(uint x, uint y) internal pure returns (uint z) {
127         z = add(mul(x, WAD), y / 2) / y;
128     }
129     function rdiv(uint x, uint y) internal pure returns (uint z) {
130         z = add(mul(x, RAY), y / 2) / y;
131     }
132 
133     // This famous algorithm is called "exponentiation by squaring"
134     // and calculates x^n with x as fixed-point and n as regular unsigned.
135     //
136     // It's O(log n), instead of O(n) for naive repeated multiplication.
137     //
138     // These facts are why it works:
139     //
140     //  If n is even, then x^n = (x^2)^(n/2).
141     //  If n is odd,  then x^n = x * x^(n-1),
142     //   and applying the equation for even x gives
143     //    x^n = x * (x^2)^((n-1) / 2).
144     //
145     //  Also, EVM division is flooring and
146     //    floor[(n-1) / 2] = floor[n / 2].
147     //
148     function rpow(uint x, uint n) internal pure returns (uint z) {
149         z = n % 2 != 0 ? x : RAY;
150 
151         for (n /= 2; n != 0; n /= 2) {
152             x = rmul(x, x);
153 
154             if (n % 2 != 0) {
155                 z = rmul(z, x);
156             }
157         }
158     }
159 }
160 
161 contract DSThing is DSAuth, DSNote, DSMath {
162 }
163 
164 contract PriceFeed is DSThing {
165 
166     uint128 val;
167     uint32 public zzz;
168 
169     function peek() public view
170         returns (bytes32,bool)
171     {
172         return (bytes32(val), now < zzz);
173     }
174 
175     function read() public view
176         returns (bytes32)
177     {
178         assert(now < zzz);
179         return bytes32(val);
180     }
181 
182     function post(uint128 val_, uint32 zzz_, address med_) public note auth
183     {
184         val = val_;
185         zzz = zzz_;
186         bool ret = med_.call(bytes4(keccak256("poke()")));
187         ret;
188     }
189 
190     function void() public note auth
191     {
192         zzz = 0;
193     }
194 
195 }