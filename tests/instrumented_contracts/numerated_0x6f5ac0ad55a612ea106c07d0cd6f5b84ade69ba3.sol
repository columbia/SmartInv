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
12     function addOperator(address newOperator) public;
13     function removeOperator (address operator) public;
14 
15 
16         //    // network
17 //    function listPairForReserve(address reserve, address src, address dest, bool add) public;
18 //
19 //    // reserve
20 //    function approveWithdrawAddress(address token, address addr, bool approve) public;
21 //    function withdrawToken(address token, uint amount, address sendTo) external;
22 //    function withdrawEther(uint amount, address sendTo) external;
23 //
24 //    // conversion rate
25 //    function addToken(address token) public;
26 //    function enableTokenTrade(address token) public;
27 //    function setTokenControlInfo(
28 //        address token,
29 //        uint minimalRecordResolution,
30 //        uint maxPerBlockImbalance,
31 //        uint maxTotalImbalance
32 //    ) public;
33     function setQtyStepFunction(
34         ERC20 token,
35         int[] xBuy,
36         int[] yBuy,
37         int[] xSell,
38         int[] ySell
39     ) public;
40 
41     function setImbalanceStepFunction(
42         ERC20 token,
43         int[] xBuy,
44         int[] yBuy,
45         int[] xSell,
46         int[] ySell
47     ) public;
48 }
49 
50 
51 contract TokenAdder {
52     TokenConfigInterface public network;
53     TokenConfigInterface public reserve;
54     TokenConfigInterface public conversionRate;
55     address public multisigAddress;
56     address public withdrawAddress;
57     address public ETH = 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;
58     ERC20 public ENG = ERC20(0xf0ee6b27b759c9893ce4f094b49ad28fd15a23e4);
59     ERC20 public SALT = ERC20(0x4156D3342D5c385a87D264F90653733592000581);
60     ERC20 public APPC = ERC20(0x1a7a8bd9106f2b8d977e08582dc7d24c723ab0db);
61     ERC20 public RDN = ERC20(0x255aa6df07540cb5d3d297f0d0d4d84cb52bc8e6);
62 //    ERC20 public OMG = ERC20(0xd26114cd6EE289AccF82350c8d8487fedB8A0C07);
63 //    ERC20 public KNC = ERC20(0xdd974D5C2e2928deA5F71b9825b8b646686BD200);
64 //    ERC20 public EOS = ERC20(0x86Fa049857E0209aa7D9e616F7eb3b3B78ECfdb0);
65 //    ERC20 public SNT = ERC20(0x744d70fdbe2ba4cf95131626614a1763df805b9e);
66 //    ERC20 public ELF = ERC20(0xbf2179859fc6d5bee9bf9158632dc51678a4100e);
67 //    ERC20 public POWR = ERC20(0x595832f8fc6bf59c85c527fec3740a1b7a361269);
68 //    ERC20 public MANA = ERC20(0x0f5d2fb29fb7d3cfee444a200298f468908cc942);
69 //    ERC20 public BAT = ERC20(0x0d8775f648430679a709e98d2b0cb6250d2887ef);
70 //    ERC20 public REQ = ERC20(0x8f8221afbb33998d8584a2b05749ba73c37a938a);
71 //    ERC20 public GTO = ERC20(0xc5bbae50781be1669306b9e001eff57a2957b09d);
72 
73     address[] public newTokens = [
74     ENG,
75     SALT,
76     APPC,
77     RDN];
78     int[] zeroArray;
79 
80     function TokenAdder(
81 //        TokenConfigInterface _network,
82 //        TokenConfigInterface _reserve,
83         TokenConfigInterface _conversionRate
84 //        address              _withdrawAddress,
85 //        address              _multisigAddress
86         )
87         public {
88 
89 //        network = _network;
90 //        reserve = _reserve;
91         conversionRate = _conversionRate;
92 //        withdrawAddress = _withdrawAddress;
93 //        multisigAddress = _multisigAddress;
94     }
95 
96 //    function listPairs() public {
97 //        address orgAdmin = network.admin();
98 //        network.claimAdmin();
99 //
100 //        for( uint i = 0 ; i < newTokens.length ; i++ ) {
101 //            network.listPairForReserve(reserve,ETH,newTokens[i],true);
102 //            network.listPairForReserve(reserve,newTokens[i],ETH,true);
103 //        }
104 //
105 //        network.transferAdminQuickly(orgAdmin);
106 //        require(orgAdmin == network.admin());
107 //    }
108 //
109 //    function approveWithdrawAddress() public {
110 //        address orgAdmin = reserve.admin();
111 //        reserve.claimAdmin();
112 //
113 //        for( uint i = 0 ; i < newTokens.length ; i++ ) {
114 //            reserve.approveWithdrawAddress(newTokens[i], withdrawAddress, true);
115 //        }
116 //
117 //
118 //        reserve.transferAdminQuickly(orgAdmin);
119 //        require(orgAdmin == reserve.admin());
120 //    }
121 
122     function setStepFunctions() public {
123         address orgAdmin = conversionRate.admin();
124         conversionRate.claimAdmin();
125 
126         conversionRate.addOperator(address(this));
127 
128         zeroArray.length = 0;
129         zeroArray.push(int(0));
130 
131         for( uint i = 0 ; i < newTokens.length ; i++ ) {
132             conversionRate.setQtyStepFunction(ERC20(newTokens[i]),
133                                               zeroArray,
134                                               zeroArray,
135                                               zeroArray,
136                                               zeroArray);
137 
138             conversionRate.setImbalanceStepFunction(ERC20(newTokens[i]),
139                                               zeroArray,
140                                               zeroArray,
141                                               zeroArray,
142                                               zeroArray);
143         }
144 
145 
146         conversionRate.removeOperator(address(this));
147 
148         conversionRate.transferAdminQuickly(orgAdmin);
149         require(orgAdmin == conversionRate.admin());
150     }
151 
152 
153     //    function addTokens() public {
154 //        address orgAdmin = conversionRate.admin();
155 //        conversionRate.claimAdmin();
156 //
157 //        conversionRate.setTokenControlInfo(
158 //            RDN,
159 //            1000000000000000,
160 //            2191833834271476809728,
161 //            3001716436034787475456 );
162 //
163 //        conversionRate.setTokenControlInfo(
164 //            APPC,
165 //            1000000000000000,
166 //            8346369318913311768576,
167 //            11430352782251779948544 );
168 //
169 //        conversionRate.setTokenControlInfo(
170 //            ENG,
171 //            10000,
172 //            245309013986,
173 //            335950694654 );
174 //
175 //        conversionRate.setTokenControlInfo(
176 //            SALT,
177 //            10000,
178 //            117682709761,
179 //            117682709761 );
180 //
181 //        zeroArray.length = 0;
182 //        zeroArray.push(int(0));
183 //        for( uint i = 0 ; i < newTokens.length ; i++ ) {
184 //            conversionRate.addToken(newTokens[i]);
185 //            conversionRate.enableTokenTrade(newTokens[i]);
186 //            /*
187 //                        conversionRate.setQtyStepFunction(ERC20(newTokens[i]),
188 //                                                          zeroArray,
189 //                                                          zeroArray,
190 //                                                          zeroArray,
191 //                                                          zeroArray);
192 //
193 //                        conversionRate.setImbalanceStepFunction(ERC20(newTokens[i]),
194 //                                                          zeroArray,
195 //                                                          zeroArray,
196 //                                                          zeroArray,
197 //                                                          zeroArray);
198 //            */
199 //        }
200 //
201 //        conversionRate.transferAdminQuickly(orgAdmin);
202 //        require(orgAdmin == conversionRate.admin());
203 //    }
204 
205 //    function tranferToReserve() public {
206 //        ENG.transferFrom(multisigAddress,reserve,790805150356);
207 //        RDN.transferFrom(multisigAddress,reserve,5991690723304920842240);
208 //        APPC.transferFrom(multisigAddress,reserve,28294946522551069704192);
209 //        SALT.transferFrom(multisigAddress,reserve,512404807997);
210 //    }
211 
212 //    function withdrawToMultisig() public {
213 //        address orgAdmin = reserve.admin();
214 //        reserve.claimAdmin();
215 //
216 //        reserve.withdrawToken(OMG,579712353000204795904,multisigAddress);
217 //        //reserve.withdrawToken(KNC,0,multisigAddress);
218 //        reserve.withdrawToken(EOS,404333617684274479104,multisigAddress);
219 //        //reserve.withdrawToken(SNT,0,multisigAddress);
220 //        reserve.withdrawToken(ELF,2851672250969491505152,multisigAddress);
221 //        //reserve.withdrawToken(POWR,0,multisigAddress);
222 //        reserve.withdrawToken(MANA,18906283885644627312640,multisigAddress);
223 //        reserve.withdrawToken(BAT,5034264918417995726848,multisigAddress);
224 //        reserve.withdrawToken(REQ,6848892587322741096448,multisigAddress);
225 //        reserve.withdrawToken(GTO,3232686829,multisigAddress);
226 //
227 //
228 //        reserve.transferAdminQuickly(orgAdmin);
229 //        require(orgAdmin == reserve.admin());
230 //    }
231 }