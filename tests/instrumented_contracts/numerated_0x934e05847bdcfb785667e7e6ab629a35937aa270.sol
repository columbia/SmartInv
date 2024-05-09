1 pragma solidity ^0.5.0;
2 
3 
4 interface TubInterface {
5     function join(uint) external;
6     function exit(uint) external;
7     function free(bytes32, uint) external;
8     function give(bytes32, address) external;
9     function gem() external view returns (TokenInterface);
10     function skr() external view returns (TokenInterface);
11     function ink(bytes32) external view returns (uint);
12     function per() external view returns (uint);
13 }
14 
15 
16 interface TokenInterface {
17     function allowance(address, address) external view returns (uint);
18     function balanceOf(address) external view returns (uint);
19     function approve(address, uint) external;
20     function withdraw(uint) external;
21 }
22 
23 
24 contract DSMath {
25 
26     function add(uint x, uint y) internal pure returns (uint z) {
27         require((z = x + y) >= x, "math-not-safe");
28     }
29 
30     function mul(uint x, uint y) internal pure returns (uint z) {
31         require(y == 0 || (z = x * y) / y == x, "math-not-safe");
32     }
33 
34     uint constant RAY = 10 ** 27;
35 
36     function rmul(uint x, uint y) internal pure returns (uint z) {
37         z = add(mul(x, y), RAY / 2) / RAY;
38     }
39 
40     function rdiv(uint x, uint y) internal pure returns (uint z) {
41         z = add(mul(x, RAY), y / 2) / y;
42     }
43 
44 }
45 
46 
47 
48 
49 contract FreeProxy is DSMath {
50     
51     /**
52      * @dev get MakerDAO CDP engine
53      */
54     function getSaiTubAddress() public pure returns (address sai) {
55         sai = 0x448a5065aeBB8E423F0896E6c5D525C040f59af3;
56     }
57 
58     /**
59      * @dev transfer CDP ownership
60      */
61     function give(uint cdpNum, address nextOwner) public {
62         TubInterface(getSaiTubAddress()).give(bytes32(cdpNum), nextOwner);
63     }
64 
65     function free3(uint cdpNum) public {
66         address tubAddr = getSaiTubAddress();
67         TubInterface tub = TubInterface(tubAddr);
68 
69         uint freeJam = tub.gem().balanceOf(address(this)); // withdraw possible previous stuck WETH as well
70         tub.gem().withdraw(freeJam);
71         
72         address(msg.sender).transfer(freeJam);
73 
74     }
75     
76     function free2(uint ink) public {
77         address tubAddr = getSaiTubAddress();
78         TubInterface tub = TubInterface(tubAddr);
79         TokenInterface peth = tub.skr();
80 
81         setAllowance(peth, tubAddr);
82             
83         tub.exit(ink);
84 
85     }
86 
87     function free(uint cdpNum, uint jam) public {
88         bytes32 cup = bytes32(cdpNum);
89         address tubAddr = getSaiTubAddress();
90         
91         if (jam > 0) {
92             
93             TubInterface tub = TubInterface(tubAddr);
94 
95             uint ink = rdiv(jam, tub.per());
96             ink = rmul(ink, tub.per()) <= jam ? ink : ink - 1;
97             tub.free(cup, ink);
98 
99         }
100     }
101 
102     function setAllowance(TokenInterface token_, address spender_) private {
103         if (token_.allowance(address(this), spender_) != uint(-1)) {
104             token_.approve(spender_, uint(-1));
105         }
106     }
107 
108 }