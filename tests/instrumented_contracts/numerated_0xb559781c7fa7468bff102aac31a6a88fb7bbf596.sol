1 pragma solidity ^0.4.18;
2 
3 
4 interface ERC20 {
5     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
6 }
7 
8 interface TokenConfigInterface {
9     function admin() public returns(address);
10     function claimAdmin() public;
11     function transferAdminQuickly(address newAdmin) public;
12 
13     // conversion rate
14     function setTokenControlInfo(
15         address token,
16         uint minimalRecordResolution,
17         uint maxPerBlockImbalance,
18         uint maxTotalImbalance
19     ) public;
20 }
21 
22 
23 contract UpdateConvRate {
24     TokenConfigInterface public conversionRate;
25 
26 //    address public ETH = 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;
27     ERC20 public ENG = ERC20(0xf0Ee6b27b759C9893Ce4f094b49ad28fd15A23e4);
28     ERC20 public SALT = ERC20(0x4156D3342D5c385a87D264F90653733592000581);
29     ERC20 public APPC = ERC20(0x1a7a8BD9106F2B8D977E08582DC7d24c723ab0DB);
30     ERC20 public RDN = ERC20(0x255Aa6DF07540Cb5d3d297f0D0D4D84cb52bc8e6);
31     ERC20 public OMG = ERC20(0xd26114cd6EE289AccF82350c8d8487fedB8A0C07);
32     ERC20 public KNC = ERC20(0xdd974D5C2e2928deA5F71b9825b8b646686BD200);
33     ERC20 public EOS = ERC20(0x86Fa049857E0209aa7D9e616F7eb3b3B78ECfdb0);
34     ERC20 public SNT = ERC20(0x744d70FDBE2Ba4CF95131626614a1763DF805B9E);
35     ERC20 public ELF = ERC20(0xbf2179859fc6D5BEE9Bf9158632Dc51678a4100e);
36     ERC20 public POWR = ERC20(0x595832F8FC6BF59c85C527fEC3740A1b7a361269);
37     ERC20 public MANA = ERC20(0x0F5D2fB29fb7d3CFeE444a200298f468908cC942);
38     ERC20 public BAT = ERC20(0x0D8775F648430679A709E98d2b0Cb6250d2887EF);
39     ERC20 public REQ = ERC20(0x8f8221aFbB33998d8584A2B05749bA73c37a938a);
40     ERC20 public GTO = ERC20(0xC5bBaE50781Be1669306b9e001EFF57a2957b09d);
41 
42     function UpdateConvRate (TokenConfigInterface _conversionRate) public {
43         conversionRate = _conversionRate;
44     }
45 
46     function setTokensControlInfo() public {
47         address orgAdmin = conversionRate.admin();
48         conversionRate.claimAdmin();
49 
50         conversionRate.setTokenControlInfo(
51             KNC,
52             1000000000000000,
53                 3475912029567568052224,
54                 5709185508564730380288);
55         conversionRate.setTokenControlInfo(
56             OMG,
57             1000000000000000,
58                 439794468212403470336,
59                 722362414038872621056);
60         conversionRate.setTokenControlInfo(
61             EOS,
62             1000000000000000,
63                 938890140546807627776,
64                 1542127055848131526656);
65         conversionRate.setTokenControlInfo(
66             SNT,
67             10000000000000000,
68                 43262133595415336976384,
69                 52109239915677776609280);
70         conversionRate.setTokenControlInfo(
71             GTO,
72             10,
73             1200696404,
74             1200696404);
75         conversionRate.setTokenControlInfo(
76             REQ,
77             1000000000000000,
78                 27470469074054960644096,
79                 33088179999699195920384);
80         conversionRate.setTokenControlInfo(
81             BAT,
82             1000000000000000,
83                 13641944431813013274624,
84                 13641944431813013274624);
85         conversionRate.setTokenControlInfo(
86             MANA,
87             1000000000000000,
88                 46289152908501773713408,
89                 46289152908501773713408);
90         conversionRate.setTokenControlInfo(
91             POWR,
92             1000,
93             7989613502,
94             7989613502);
95         conversionRate.setTokenControlInfo(
96             ELF,
97             1000000000000000,
98                 5906192156691986907136,
99                 7114008452735498715136);
100         conversionRate.setTokenControlInfo(
101             APPC,
102             1000000000000000,
103                 10010270788085346205696,
104                 12057371164248796823552);
105         conversionRate.setTokenControlInfo(
106             ENG,
107             10000,
108             288970915691,
109             348065467950);
110         conversionRate.setTokenControlInfo(
111             RDN,
112             1000000000000000,
113                 2392730983766020325376,
114                 2882044469946171260928);
115         conversionRate.setTokenControlInfo(
116             SALT,
117             10000,
118             123819203326,
119             123819203326);
120 
121         conversionRate.transferAdminQuickly(orgAdmin);
122         require(orgAdmin == conversionRate.admin());
123     }
124 }