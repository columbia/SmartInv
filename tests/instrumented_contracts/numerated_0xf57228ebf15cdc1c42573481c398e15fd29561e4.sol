1 pragma solidity ^0.4.24;
2 
3  /* 
4   *  Handles mapping and calculation of fees for exchanges.
5   */
6 
7 contract DSAuthority {
8     function canCall(
9         address src, address dst, bytes4 sig
10     ) public view returns (bool);
11 }
12 
13 contract DSAuthEvents {
14     event LogSetAuthority (address indexed authority);
15     event LogSetOwner     (address indexed owner);
16 }
17 
18 contract DSAuth is DSAuthEvents {
19     DSAuthority  public  authority;
20     address      public  owner;
21 
22     constructor() public {
23         owner = msg.sender;
24         emit LogSetOwner(msg.sender);
25     }
26 
27     function setOwner(address owner_)
28         public
29         auth
30     {
31         owner = owner_;
32         emit LogSetOwner(owner);
33     }
34 
35     function setAuthority(DSAuthority authority_)
36         public
37         auth
38     {
39         authority = authority_;
40         emit LogSetAuthority(authority);
41     }
42 
43     modifier auth {
44         require(isAuthorized(msg.sender, msg.sig));
45         _;
46     }
47 
48     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
49         if (src == address(this)) {
50             return true;
51         } else if (src == owner) {
52             return true;
53         } else if (authority == DSAuthority(0)) {
54             return false;
55         } else {
56             return authority.canCall(src, this, sig);
57         }
58     }
59 }
60 
61 contract DSMath {
62     function add(uint x, uint y) internal pure returns (uint z) {
63         require((z = x + y) >= x);
64     }
65     function sub(uint x, uint y) internal pure returns (uint z) {
66         require((z = x - y) <= x);
67     }
68     function mul(uint x, uint y) internal pure returns (uint z) {
69         require(y == 0 || (z = x * y) / y == x);
70     }
71     function min(uint x, uint y) internal pure returns (uint z) {
72         return x <= y ? x : y;
73     }
74     function max(uint x, uint y) internal pure returns (uint z) {
75         return x >= y ? x : y;
76     }
77     function imin(int x, int y) internal pure returns (int z) {
78         return x <= y ? x : y;
79     }
80     function imax(int x, int y) internal pure returns (int z) {
81         return x >= y ? x : y;
82     }
83 
84     uint constant WAD = 10 ** 18;
85     uint constant RAY = 10 ** 27;
86 
87     function wmul(uint x, uint y) internal pure returns (uint z) {
88         z = add(mul(x, y), WAD / 2) / WAD;
89     }
90     function rmul(uint x, uint y) internal pure returns (uint z) {
91         z = add(mul(x, y), RAY / 2) / RAY;
92     }
93     function wdiv(uint x, uint y) internal pure returns (uint z) {
94         z = add(mul(x, WAD), y / 2) / y;
95     }
96     function rdiv(uint x, uint y) internal pure returns (uint z) {
97         z = add(mul(x, RAY), y / 2) / y;
98     }
99 
100     function rpow(uint x, uint n) internal pure returns (uint z) {
101         z = n % 2 != 0 ? x : RAY;
102 
103         for (n /= 2; n != 0; n /= 2) {
104             x = rmul(x, x);
105 
106             if (n % 2 != 0) {
107                 z = rmul(z, x);
108             }
109         }
110     }
111 }
112 
113 contract FeeAuthority is DSMath, DSAuth {
114         
115     mapping (address => uint) tokenRates;
116     uint defaultFeePercentage;
117 
118     constructor () public {
119         defaultFeePercentage = 0.02 ether;
120     }
121 
122     function setDefaultFee (uint newFeeWad) public auth {
123         require(newFeeWad < 0.1 ether); /* require <10% fee */
124         defaultFeePercentage = newFeeWad;
125     }
126     
127     function setFee (address token, uint newFeeWad) public auth {
128         /* set the new fee for a token. auth modifier ensures only owner can call. */
129         require(newFeeWad < 0.1 ether); /* require <10% fee */
130         tokenRates[token] = newFeeWad;
131     }
132     
133     function rateOf (address token) internal view returns (uint) {
134         if (tokenRates[token] == 0) {
135         /* use default fee rate if the token's fee rate is not specified */
136             return defaultFeePercentage;
137         } else {
138             return tokenRates[token];
139         }
140     }    
141     
142     function takeFee (uint amt, address token) public view returns (uint fee, uint remaining) {
143         /* shave the fee off of an amount */
144         fee = wmul(amt, rateOf(token));
145         remaining = sub(amt, fee);
146     }
147 }