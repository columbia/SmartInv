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
13     // network
14     function listPairForReserve(address reserve, address src, address dest, bool add) public;
15 
16     // reserve
17     function approveWithdrawAddress(address token, address addr, bool approve) public;
18     function withdrawToken(address token, uint amount, address sendTo) external;
19     function withdrawEther(uint amount, address sendTo) external;
20 
21     // conversion rate
22     function addToken(address token) public;
23     function enableTokenTrade(address token) public;
24     function setTokenControlInfo(
25         address token,
26         uint minimalRecordResolution,
27         uint maxPerBlockImbalance,
28         uint maxTotalImbalance
29     ) public;
30     function setQtyStepFunction(
31         ERC20 token,
32         int[] xBuy,
33         int[] yBuy,
34         int[] xSell,
35         int[] ySell
36     ) public;
37 
38     function setImbalanceStepFunction(
39         ERC20 token,
40         int[] xBuy,
41         int[] yBuy,
42         int[] xSell,
43         int[] ySell
44     ) public;
45 }
46 
47 
48 contract TokenAdder {
49     TokenConfigInterface public network;
50     TokenConfigInterface public reserve;
51     TokenConfigInterface public conversionRate;
52     address public multisigAddress;
53     address public withdrawAddress;
54     address public ETH = 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;
55     ERC20 public ENG = ERC20(0xf0ee6b27b759c9893ce4f094b49ad28fd15a23e4);
56     ERC20 public SALT = ERC20(0x4156D3342D5c385a87D264F90653733592000581);
57     ERC20 public APPC = ERC20(0x1a7a8bd9106f2b8d977e08582dc7d24c723ab0db);
58     ERC20 public RDN = ERC20(0x255aa6df07540cb5d3d297f0d0d4d84cb52bc8e6);
59     ERC20 public OMG = ERC20(0xd26114cd6EE289AccF82350c8d8487fedB8A0C07);
60     ERC20 public KNC = ERC20(0xdd974D5C2e2928deA5F71b9825b8b646686BD200);
61     ERC20 public EOS = ERC20(0x86Fa049857E0209aa7D9e616F7eb3b3B78ECfdb0);
62     ERC20 public SNT = ERC20(0x744d70fdbe2ba4cf95131626614a1763df805b9e);
63     ERC20 public ELF = ERC20(0xbf2179859fc6d5bee9bf9158632dc51678a4100e);
64     ERC20 public POWR = ERC20(0x595832f8fc6bf59c85c527fec3740a1b7a361269);
65     ERC20 public MANA = ERC20(0x0f5d2fb29fb7d3cfee444a200298f468908cc942);
66     ERC20 public BAT = ERC20(0x0d8775f648430679a709e98d2b0cb6250d2887ef);
67     ERC20 public REQ = ERC20(0x8f8221afbb33998d8584a2b05749ba73c37a938a);
68     ERC20 public GTO = ERC20(0xc5bbae50781be1669306b9e001eff57a2957b09d);
69 
70     address[] public newTokens = [
71         ENG,
72         SALT,
73         APPC,
74         RDN];
75     int[] zeroArray;
76 
77     function TokenAdder(TokenConfigInterface _network,
78                         TokenConfigInterface _reserve,
79                         TokenConfigInterface _conversionRate,
80                         address              _withdrawAddress,
81                         address              _multisigAddress) public {
82 
83         network = _network;
84         reserve = _reserve;
85         conversionRate = _conversionRate;
86         withdrawAddress = _withdrawAddress;
87         multisigAddress = _multisigAddress;
88     }
89 
90     function listPairs() public {
91         address orgAdmin = network.admin();
92         network.claimAdmin();
93 
94         for( uint i = 0 ; i < newTokens.length ; i++ ) {
95             network.listPairForReserve(reserve,ETH,newTokens[i],true);
96             network.listPairForReserve(reserve,newTokens[i],ETH,true);
97         }
98 
99         network.transferAdminQuickly(orgAdmin);
100         require(orgAdmin == network.admin());
101     }
102 
103     function approveWithdrawAddress() public {
104         address orgAdmin = reserve.admin();
105         reserve.claimAdmin();
106 
107         for( uint i = 0 ; i < newTokens.length ; i++ ) {
108             reserve.approveWithdrawAddress(newTokens[i], withdrawAddress, true);
109         }
110 
111 
112         reserve.transferAdminQuickly(orgAdmin);
113         require(orgAdmin == reserve.admin());
114     }
115 
116     function addTokens() public {
117         address orgAdmin = conversionRate.admin();
118         conversionRate.claimAdmin();
119 
120         conversionRate.setTokenControlInfo(
121             RDN,
122             1000000000000000,
123             2191833834271476809728,
124             3001716436034787475456 );
125 
126         conversionRate.setTokenControlInfo(
127             APPC,
128             1000000000000000,
129             8346369318913311768576,
130             11430352782251779948544 );
131 
132         conversionRate.setTokenControlInfo(
133             ENG,
134             10000,
135             245309013986,
136             335950694654 );
137 
138         conversionRate.setTokenControlInfo(
139             SALT,
140             10000,
141             117682709761,
142             117682709761 );
143 
144         zeroArray.length = 0;
145         zeroArray.push(int(0));
146         for( uint i = 0 ; i < newTokens.length ; i++ ) {
147             conversionRate.addToken(newTokens[i]);
148             conversionRate.enableTokenTrade(newTokens[i]);
149 /*
150             conversionRate.setQtyStepFunction(ERC20(newTokens[i]),
151                                               zeroArray,
152                                               zeroArray,
153                                               zeroArray,
154                                               zeroArray);
155 
156             conversionRate.setImbalanceStepFunction(ERC20(newTokens[i]),
157                                               zeroArray,
158                                               zeroArray,
159                                               zeroArray,
160                                               zeroArray);
161 */                                              
162         }
163 
164         conversionRate.transferAdminQuickly(orgAdmin);
165         require(orgAdmin == conversionRate.admin());
166     }
167 
168     function tranferToReserve() public {
169         ENG.transferFrom(multisigAddress,reserve,790805150356);
170         RDN.transferFrom(multisigAddress,reserve,5991690723304920842240);
171         APPC.transferFrom(multisigAddress,reserve,28294946522551069704192);
172         SALT.transferFrom(multisigAddress,reserve,512404807997);
173     }
174 
175     function withdrawToMultisig() public {
176         address orgAdmin = reserve.admin();
177         reserve.claimAdmin();
178 
179         reserve.withdrawToken(OMG,579712353000204795904,multisigAddress);
180         //reserve.withdrawToken(KNC,0,multisigAddress);
181         reserve.withdrawToken(EOS,404333617684274479104,multisigAddress);
182         //reserve.withdrawToken(SNT,0,multisigAddress);
183         reserve.withdrawToken(ELF,2851672250969491505152,multisigAddress);
184         //reserve.withdrawToken(POWR,0,multisigAddress);
185         reserve.withdrawToken(MANA,18906283885644627312640,multisigAddress);
186         reserve.withdrawToken(BAT,5034264918417995726848,multisigAddress);
187         reserve.withdrawToken(REQ,6848892587322741096448,multisigAddress);
188         reserve.withdrawToken(GTO,3232686829,multisigAddress);
189 
190 
191         reserve.transferAdminQuickly(orgAdmin);
192         require(orgAdmin == reserve.admin());
193     }
194 }