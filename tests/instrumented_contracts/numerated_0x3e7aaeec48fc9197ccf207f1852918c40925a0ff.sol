1 // File: contracts/v-DaiMaker.sol
2 /*
3 
4 Read code from https://github.com/onbjerg/dai.how
5 
6 */
7 interface IMaker {
8     function sai() public view returns (ERC20);
9     function skr() public view returns (ERC20);
10     function gem() public view returns (ERC20);
11 
12     function open() public returns (bytes32 cup);
13     function give(bytes32 cup, address guy) public;
14 
15     function gap() public view returns (uint);
16     function per() public view returns (uint);
17 
18     function ask(uint wad) public view returns (uint);
19     function bid(uint wad) public view returns (uint);
20 
21     function join(uint wad) public;
22     function lock(bytes32 cup, uint wad) public;
23     function free(bytes32 cup, uint wad) public;
24     function draw(bytes32 cup, uint wad) public;
25     function cage(uint fit_, uint jam) public;
26 }
27 
28 interface ERC20 {
29     function totalSupply() public view returns (uint256);
30     function balanceOf(address who) public view returns (uint256);
31     function transfer(address to, uint256 value) public returns (bool);
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     function allowance(address owner, address spender) public view returns (uint256);
34     function transferFrom(address from, address to, uint256 value) public returns (bool);
35     function approve(address spender, uint256 value) public returns (bool);
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 interface IWETH {
40     function deposit() public payable;
41     function withdraw(uint wad) public;
42 }
43 
44 contract DSMath {
45     function add(uint x, uint y) internal pure returns (uint z) {
46         require((z = x + y) >= x);
47     }
48     function sub(uint x, uint y) internal pure returns (uint z) {
49         require((z = x - y) <= x);
50     }
51     function mul(uint x, uint y) internal pure returns (uint z) {
52         require(y == 0 || (z = x * y) / y == x);
53     }
54 
55     function min(uint x, uint y) internal pure returns (uint z) {
56         return x <= y ? x : y;
57     }
58     function max(uint x, uint y) internal pure returns (uint z) {
59         return x >= y ? x : y;
60     }
61     function imin(int x, int y) internal pure returns (int z) {
62         return x <= y ? x : y;
63     }
64     function imax(int x, int y) internal pure returns (int z) {
65         return x >= y ? x : y;
66     }
67 
68     uint constant WAD = 10 ** 18;
69     uint constant RAY = 10 ** 27;
70 
71     function wmul(uint x, uint y) internal pure returns (uint z) {
72         z = add(mul(x, y), WAD / 2) / WAD;
73     }
74     function rmul(uint x, uint y) internal pure returns (uint z) {
75         z = add(mul(x, y), RAY / 2) / RAY;
76     }
77     function wdiv(uint x, uint y) public pure returns (uint z) {
78         z = add(mul(x, WAD), y / 2) / y;
79     }
80     function rdiv(uint x, uint y) public pure returns (uint z) {
81         z = add(mul(x, RAY), y / 2) / y;
82     }
83 
84     // This famous algorithm is called "exponentiation by squaring"
85     // and calculates x^n with x as fixed-point and n as regular unsigned.
86     //
87     // It's O(log n), instead of O(n) for naive repeated multiplication.
88     //
89     // These facts are why it works:
90     //
91     //  If n is even, then x^n = (x^2)^(n/2).
92     //  If n is odd,  then x^n = x * x^(n-1),
93     //   and applying the equation for even x gives
94     //    x^n = x * (x^2)^((n-1) / 2).
95     //
96     //  Also, EVM division is flooring and
97     //    floor[(n-1) / 2] = floor[n / 2].
98     //
99     function rpow(uint x, uint n) internal pure returns (uint z) {
100         z = n % 2 != 0 ? x : RAY;
101 
102         for (n /= 2; n != 0; n /= 2) {
103             x = rmul(x, x);
104 
105             if (n % 2 != 0) {
106                 z = rmul(z, x);
107             }
108         }
109     }
110 }
111 
112 contract DaiMaker is DSMath {
113     IMaker public maker;
114     ERC20 public weth;
115     ERC20 public peth;
116     ERC20 public dai;
117 
118     event MakeDai(address indexed daiOwner, address indexed cdpOwner, uint256 ethAmount, uint256 daiAmount, uint256 pethAmount);
119 
120     function DaiMaker(IMaker _maker) {
121         maker = _maker;
122         weth = maker.gem();
123         peth = maker.skr();
124         dai = maker.sai();
125     }
126 
127     function makeDai(uint256 daiAmount, address cdpOwner, address daiOwner) payable public returns (bytes32 cdpId) {
128         IWETH(weth).deposit.value(msg.value)();      // wrap eth in weth token
129         weth.approve(maker, msg.value);              // allow maker to pull weth
130 
131         // calculate how much peth we need to enter with
132         uint256 inverseAsk = rdiv(msg.value, wmul(maker.gap(), maker.per())) - 1;
133 
134         maker.join(inverseAsk);                      // convert weth to peth
135         uint256 pethAmount = peth.balanceOf(this);
136 
137         peth.approve(maker, pethAmount);             // allow maker to pull peth
138 
139         cdpId = maker.open();                        // create cdp in maker
140         maker.lock(cdpId, pethAmount);               // lock peth into cdp
141         maker.draw(cdpId, daiAmount);                // create dai from cdp
142 
143         dai.transfer(daiOwner, daiAmount);           // transfer dai to owner
144         maker.give(cdpId, cdpOwner);                 // transfer cdp to owner
145 
146         MakeDai(daiOwner, cdpOwner, msg.value, daiAmount, pethAmount);
147     }
148 }