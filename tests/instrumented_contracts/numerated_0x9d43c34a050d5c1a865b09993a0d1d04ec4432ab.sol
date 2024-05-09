1 /*
2 
3 Read code from https://github.com/onbjerg/dai.how
4 
5 */
6 interface IMaker {
7     function sai() public view returns (ERC20);
8     function skr() public view returns (ERC20);
9     function gem() public view returns (ERC20);
10 
11     function open() public returns (bytes32 cup);
12     function give(bytes32 cup, address guy) public;
13 
14     function gap() public view returns (uint);
15     function per() public view returns (uint);
16 
17     function ask(uint wad) public view returns (uint);
18     function bid(uint wad) public view returns (uint);
19 
20     function join(uint wad) public;
21     function lock(bytes32 cup, uint wad) public;
22     function free(bytes32 cup, uint wad) public;
23     function draw(bytes32 cup, uint wad) public;
24     function cage(uint fit_, uint jam) public;
25 }
26 
27 interface ERC20 {
28     function totalSupply() public view returns (uint256);
29     function balanceOf(address who) public view returns (uint256);
30     function transfer(address to, uint256 value) public returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     function allowance(address owner, address spender) public view returns (uint256);
33     function transferFrom(address from, address to, uint256 value) public returns (bool);
34     function approve(address spender, uint256 value) public returns (bool);
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 interface IWETH {
39     function deposit() public payable;
40     function withdraw(uint wad) public;
41 }
42 
43 contract DSMath {
44     function add(uint x, uint y) internal pure returns (uint z) {
45         require((z = x + y) >= x);
46     }
47     function sub(uint x, uint y) internal pure returns (uint z) {
48         require((z = x - y) <= x);
49     }
50     function mul(uint x, uint y) internal pure returns (uint z) {
51         require(y == 0 || (z = x * y) / y == x);
52     }
53 
54     function min(uint x, uint y) internal pure returns (uint z) {
55         return x <= y ? x : y;
56     }
57     function max(uint x, uint y) internal pure returns (uint z) {
58         return x >= y ? x : y;
59     }
60     function imin(int x, int y) internal pure returns (int z) {
61         return x <= y ? x : y;
62     }
63     function imax(int x, int y) internal pure returns (int z) {
64         return x >= y ? x : y;
65     }
66 
67     uint constant WAD = 10 ** 18;
68     uint constant RAY = 10 ** 27;
69 
70     function wmul(uint x, uint y) internal pure returns (uint z) {
71         z = add(mul(x, y), WAD / 2) / WAD;
72     }
73     function rmul(uint x, uint y) internal pure returns (uint z) {
74         z = add(mul(x, y), RAY / 2) / RAY;
75     }
76     function wdiv(uint x, uint y) public pure returns (uint z) {
77         z = add(mul(x, WAD), y / 2) / y;
78     }
79     function rdiv(uint x, uint y) public pure returns (uint z) {
80         z = add(mul(x, RAY), y / 2) / y;
81     }
82 
83     // This famous algorithm is called "exponentiation by squaring"
84     // and calculates x^n with x as fixed-point and n as regular unsigned.
85     //
86     // It's O(log n), instead of O(n) for naive repeated multiplication.
87     //
88     // These facts are why it works:
89     //
90     //  If n is even, then x^n = (x^2)^(n/2).
91     //  If n is odd,  then x^n = x * x^(n-1),
92     //   and applying the equation for even x gives
93     //    x^n = x * (x^2)^((n-1) / 2).
94     //
95     //  Also, EVM division is flooring and
96     //    floor[(n-1) / 2] = floor[n / 2].
97     //
98     function rpow(uint x, uint n) internal pure returns (uint z) {
99         z = n % 2 != 0 ? x : RAY;
100 
101         for (n /= 2; n != 0; n /= 2) {
102             x = rmul(x, x);
103 
104             if (n % 2 != 0) {
105                 z = rmul(z, x);
106             }
107         }
108     }
109 }
110 
111 contract DaiMaker is DSMath {
112     IMaker public maker;
113     ERC20 public weth;
114     ERC20 public peth;
115     ERC20 public dai;
116 
117     event MakeDai(address indexed daiOwner, address indexed cdpOwner, uint256 ethAmount, uint256 daiAmount, uint256 pethAmount);
118 
119     function DaiMaker(IMaker _maker) {
120         maker = _maker;
121         weth = maker.gem();
122         peth = maker.skr();
123         dai = maker.sai();
124     }
125 
126     function makeDai(uint256 daiAmount, address cdpOwner, address daiOwner) payable public returns (bytes32 cdpId) {
127         IWETH(weth).deposit.value(msg.value)();      // wrap eth in weth token
128         weth.approve(maker, msg.value);              // allow maker to pull weth
129 
130         // calculate how much peth we need to enter with
131         uint256 inverseAsk = rdiv(msg.value, wmul(maker.gap(), maker.per())) - 1;
132 
133         maker.join(inverseAsk);                      // convert weth to peth
134         uint256 pethAmount = peth.balanceOf(this);
135 
136         peth.approve(maker, pethAmount);             // allow maker to pull peth
137 
138         cdpId = maker.open();                        // create cdp in maker
139         maker.lock(cdpId, pethAmount);               // lock peth into cdp
140         maker.draw(cdpId, daiAmount);                // create dai from cdp
141 
142         dai.transfer(daiOwner, daiAmount);           // transfer dai to owner
143         maker.give(cdpId, cdpOwner);                 // transfer cdp to owner
144 
145         MakeDai(daiOwner, cdpOwner, msg.value, daiAmount, pethAmount);
146     }
147 }