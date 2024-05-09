1 pragma solidity ^0.5.2;
2 
3 contract DSMath {
4     function add(uint x, uint y) internal pure returns (uint z) {
5         require((z = x + y) >= x, "ds-math-add-overflow");
6     }
7     function sub(uint x, uint y) internal pure returns (uint z) {
8         require((z = x - y) <= x, "ds-math-sub-underflow");
9     }
10     function mul(uint x, uint y) internal pure returns (uint z) {
11         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
12     }
13 
14     function div(uint x, uint y) internal pure returns (uint z) {
15         require(y > 0, "ds-math-div-overflow");
16         z = x / y;
17     }
18 
19     function min(uint x, uint y) internal pure returns (uint z) {
20         return x <= y ? x : y;
21     }
22     function max(uint x, uint y) internal pure returns (uint z) {
23         return x >= y ? x : y;
24     }
25 
26     uint constant WAD = 10 ** 18;
27 
28     function wdiv(uint x, uint y) internal pure returns (uint z) {
29         z = add(mul(x, WAD), y / 2) / y;
30     }
31 
32     /**
33      * @dev x to the power of y power(base, exponent)
34      */
35     function pow(uint256 base, uint256 exponent) public pure returns (uint256) {
36         if (exponent == 0) {
37             return 1;
38         }
39         else if (exponent == 1) {
40             return base;
41         }
42         else if (base == 0 && exponent != 0) {
43             return 0;
44         }
45         else {
46             uint256 z = base;
47             for (uint256 i = 1; i < exponent; i++)
48                 z = mul(z, base);
49             return z;
50         }
51     }
52 }
53 
54 contract DSNote {
55     event LogNote(
56         bytes4   indexed  sig,
57         address  indexed  guy,
58         bytes32  indexed  foo,
59         bytes32  indexed  bar,
60         uint256           wad,
61         bytes             fax
62     ) anonymous;
63 
64     modifier note {
65         bytes32 foo;
66         bytes32 bar;
67         uint256 wad;
68 
69         assembly {
70             foo := calldataload(4)
71             bar := calldataload(36)
72             wad := callvalue
73         }
74 
75         emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
76 
77         _;
78     }
79 }
80 
81 contract DSAuthority {
82     function canCall(
83         address src, address dst, bytes4 sig
84     ) public view returns (bool);
85 }
86 
87 contract DSAuthEvents {
88     event LogSetAuthority (address indexed authority);
89     event LogSetOwner     (address indexed owner);
90     event OwnerUpdate     (address indexed owner, address indexed newOwner);
91 }
92 
93 contract DSAuth is DSAuthEvents {
94     DSAuthority  public  authority;
95     address      public  owner;
96     address      public  newOwner;
97 
98     constructor() public {
99         owner = msg.sender;
100         emit LogSetOwner(msg.sender);
101     }
102 
103     // Warning: you should absolutely sure you want to give up authority!!!
104     function disableOwnership() public onlyOwner {
105         owner = address(0);
106         emit OwnerUpdate(msg.sender, owner);
107     }
108 
109     function transferOwnership(address newOwner_) public onlyOwner {
110         require(newOwner_ != owner, "TransferOwnership: the same owner.");
111         newOwner = newOwner_;
112     }
113 
114     function acceptOwnership() public {
115         require(msg.sender == newOwner, "AcceptOwnership: only new owner do this.");
116         emit OwnerUpdate(owner, newOwner);
117         owner = newOwner;
118         newOwner = address(0x0);
119     }
120 
121     ///[snow] guard is Authority who inherit DSAuth.
122     function setAuthority(DSAuthority authority_)
123         public
124         onlyOwner
125     {
126         authority = authority_;
127         emit LogSetAuthority(address(authority));
128     }
129 
130     modifier onlyOwner {
131         require(isOwner(msg.sender), "ds-auth-non-owner");
132         _;
133     }
134 
135     function isOwner(address src) internal view returns (bool) {
136         return bool(src == owner);
137     }
138 
139     modifier auth {
140         require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
141         _;
142     }
143 
144     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
145         if (src == address(this)) {
146             return true;
147         } else if (src == owner) {
148             return true;
149         } else if (authority == DSAuthority(0)) {
150             return false;
151         } else {
152             return authority.canCall(src, address(this), sig);
153         }
154     }
155 }
156 
157 contract DSThing is DSAuth, DSNote, DSMath {
158     function S(string memory s) internal pure returns (bytes4) {
159         return bytes4(keccak256(abi.encodePacked(s)));
160     }
161 
162 }
163 
164 interface iMedianizer {
165     function poke() external;
166 }
167 
168 contract PriceFeed is DSThing {
169 
170     uint128       val;
171     uint32 public zzz;
172 
173     function peek() external view returns (bytes32, bool) {
174         return (bytes32(uint(val)), now < zzz);
175     }
176 
177     function read() external view returns (bytes32) {
178         require(now < zzz, "Read: expired.");
179         return bytes32(uint(val));
180     }
181 
182     function poke(uint128 val_, uint32 zzz_) external note auth {
183         val = val_;
184         zzz = zzz_;
185     }
186 
187     function post(uint128 val_, uint32 zzz_, iMedianizer med_) external note auth {
188         val = val_;
189         zzz = zzz_;
190         med_.poke();
191     }
192 
193     function void() external note auth {
194         zzz = 0;
195     }
196 }