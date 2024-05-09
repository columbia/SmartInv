1 pragma solidity ^0.5.0;
2 
3 
4 interface TubInterface {
5     function open() external returns (bytes32);
6     function join(uint) external;
7     function exit(uint) external;
8     function lock(bytes32, uint) external;
9     function free(bytes32, uint) external;
10     function draw(bytes32, uint) external;
11     function wipe(bytes32, uint) external;
12     function give(bytes32, address) external;
13     function shut(bytes32) external;
14     function cups(bytes32) external view returns (address, uint, uint, uint);
15     function gem() external view returns (TokenInterface);
16     function gov() external view returns (TokenInterface);
17     function skr() external view returns (TokenInterface);
18     function sai() external view returns (TokenInterface);
19     function ink(bytes32) external view returns (uint);
20     function tab(bytes32) external view returns (uint);
21     function rap(bytes32) external view returns (uint);
22     function per() external view returns (uint);
23     function pep() external view returns (PepInterface);
24 }
25 
26 
27 interface TokenInterface {
28     function allowance(address, address) external view returns (uint);
29     function balanceOf(address) external view returns (uint);
30     function approve(address, uint) external;
31     function transfer(address, uint) external returns (bool);
32     function transferFrom(address, address, uint) external returns (bool);
33     function deposit() external payable;
34     function withdraw(uint) external;
35 }
36 
37 
38 interface PepInterface {
39     function peek() external returns (bytes32, bool);
40 }
41 
42 
43 contract DSMath {
44 
45     function add(uint x, uint y) internal pure returns (uint z) {
46         require((z = x + y) >= x, "math-not-safe");
47     }
48 
49     function mul(uint x, uint y) internal pure returns (uint z) {
50         require(y == 0 || (z = x * y) / y == x, "math-not-safe");
51     }
52 
53     uint constant RAY = 10 ** 27;
54 
55     function rmul(uint x, uint y) internal pure returns (uint z) {
56         z = add(mul(x, y), RAY / 2) / RAY;
57     }
58 
59     function rdiv(uint x, uint y) internal pure returns (uint z) {
60         z = add(mul(x, RAY), y / 2) / y;
61     }
62 
63 }
64 
65 
66 contract Helpers is DSMath {
67 
68     /**
69      * @dev get MakerDAO CDP engine
70      */
71     function getSaiTubAddress() public pure returns (address sai) {
72         sai = 0x448a5065aeBB8E423F0896E6c5D525C040f59af3;
73     }
74 
75 }
76 
77 
78 contract CDPResolver is Helpers {
79 
80     /**
81      * @dev transfer CDP ownership
82      */
83     function give(uint cdpNum, address nextOwner) public {
84         TubInterface(getSaiTubAddress()).give(bytes32(cdpNum), nextOwner);
85     }
86 
87     function free(uint cdpNum, uint jam) public {
88         bytes32 cup = bytes32(cdpNum);
89         address tubAddr = getSaiTubAddress();
90         
91         if (jam > 0) {
92             
93             TubInterface tub = TubInterface(tubAddr);
94             TokenInterface peth = tub.skr();
95 
96             uint ink = rdiv(jam, tub.per());
97             ink = rmul(ink, tub.per()) <= jam ? ink : ink - 1;
98             tub.free(cup, ink);
99 
100             setAllowance(peth, tubAddr);
101             
102             tub.exit(ink);
103             uint freeJam = tub.gem().balanceOf(address(this)); // withdraw possible previous stuck WETH as well
104             tub.gem().withdraw(freeJam);
105             
106             address(msg.sender).transfer(freeJam);
107         }
108     }
109 
110     function setAllowance(TokenInterface token_, address spender_) private {
111         if (token_.allowance(address(this), spender_) != uint(-1)) {
112             token_.approve(spender_, uint(-1));
113         }
114     }
115 
116 }
117 
118 
119 contract InstaMaker is CDPResolver {
120 
121     uint public version;
122     
123     /**
124      * @dev setting up variables on deployment
125      * 1...2...3 versioning in each subsequent deployments
126      */
127     constructor() public {
128         version = 1;
129     }
130 
131 }