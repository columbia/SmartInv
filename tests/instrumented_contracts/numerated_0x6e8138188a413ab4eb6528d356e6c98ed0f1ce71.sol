1 pragma solidity 0.4.18;
2 
3 
4 
5 interface InternalNetworkInterface {
6 
7 
8     function listPairForReserve(
9         address reserve,
10         address token,
11         bool ethToToken,
12         bool tokenToEth,
13         bool add
14     )
15         external
16         returns(bool);
17 
18 }
19 
20 
21 contract Lister {
22     InternalNetworkInterface constant NETWORK = InternalNetworkInterface(0x9ae49C0d7F8F9EF4B864e004FE86Ac8294E20950);
23     address constant PRYCTO = address(0x21433Dec9Cb634A23c6A4BbcCe08c83f5aC2EC18);
24 
25     modifier onlyListers() {
26         require(msg.sender == 0x7C8cfF2c659A3eE23869497a56129F3da92E8F38 ||
27                 msg.sender == 0xd0643BC0D0C879F175556509dbcEe9373379D5C3);
28         _;
29     }
30 
31     function list(address reserve, address token) internal {
32         require(NETWORK.listPairForReserve(reserve,token,true,true,true));
33     }
34     
35     function listPrycto1() onlyListers public {
36         // OMG
37         list(PRYCTO,0xd26114cd6EE289AccF82350c8d8487fedB8A0C07);
38         // KNC
39         list(PRYCTO,0xdd974D5C2e2928deA5F71b9825b8b646686BD200);
40         // BAT
41         list(PRYCTO,0x0D8775F648430679A709E98d2b0Cb6250d2887EF);
42         // ENG
43         list(PRYCTO,0xf0Ee6b27b759C9893Ce4f094b49ad28fd15A23e4);
44     }
45 
46     function listPrycto2() onlyListers public {
47         // REQ
48         list(PRYCTO,0x8f8221aFbB33998d8584A2B05749bA73c37a938a);
49         // RCN
50         list(PRYCTO,0xF970b8E36e23F7fC3FD752EeA86f8Be8D83375A6);
51         // ADX
52         list(PRYCTO,0x4470BB87d77b963A013DB939BE332f927f2b992e);
53         // DAI
54         list(PRYCTO,0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359);
55     }
56 
57     function listPrycto3() onlyListers public {
58         // REQ
59         list(PRYCTO,0x8f8221aFbB33998d8584A2B05749bA73c37a938a);
60         // RCN
61         list(PRYCTO,0xF970b8E36e23F7fC3FD752EeA86f8Be8D83375A6);
62         // ADX
63         list(PRYCTO,0x4470BB87d77b963A013DB939BE332f927f2b992e);
64         // AST
65         list(PRYCTO,0x27054b13b1B798B345b591a4d22e6562d47eA75a);
66     }
67     
68     function listPrycto4() onlyListers public {
69         // DAI
70         list(PRYCTO,0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359);
71         // IOST
72         list(PRYCTO,0xFA1a856Cfa3409CFa145Fa4e20Eb270dF3EB21ab);
73         // STORM
74         list(PRYCTO,0xD0a4b8946Cb52f0661273bfbC6fD0E0C75Fc6433);
75         // LEND
76         list(PRYCTO,0x80fB784B7eD66730e8b1DBd9820aFD29931aab03);
77     }    
78     
79     function listPrycto5() onlyListers public {
80         // WINGS
81         list(PRYCTO,0x667088b212ce3d06a1b553a7221E1fD19000d9aF);
82         // MTL
83         list(PRYCTO,0xF433089366899D83a9f26A773D59ec7eCF30355e);
84         // WABI
85         list(PRYCTO,0x286BDA1413a2Df81731D4930ce2F862a35A609fE);
86         // OCN
87         list(PRYCTO,0x4092678e4E78230F46A1534C0fbc8fA39780892B);
88     }        
89     
90     function listPrycto6() onlyListers public {
91         // PRO
92         list(PRYCTO,0x226bb599a12C826476e3A771454697EA52E9E220);
93         // SSP
94         list(PRYCTO,0x624d520BAB2E4aD83935Fa503fB130614374E850);
95     }            
96     
97     function listMOT() onlyListers public {
98         list(0x6f50e41885fdc44dbdf7797df0393779a9c0a3a6,0x263c618480DBe35C300D8d5EcDA19bbB986AcaeD);
99     }
100 
101     function listINF() onlyListers public {
102         list(0x4d864b5b4f866f65f53cbaad32eb9574760865e6,0x00E150D741Eda1d49d341189CAE4c08a73a49C95);
103     }
104 
105     function listBBO() onlyListers public {
106         list(0x91be8fa21dc21cff073e07bae365669e154d6ee1,0x84F7c44B6Fed1080f647E354D552595be2Cc602F);
107     }
108 
109     function listCOFI() onlyListers public {
110         list(0xc935cad589bebd8673104073d5a5eccfe67fb7b1,0x3136eF851592aCf49CA4C825131E364170FA32b3);
111     }
112 
113     function listMOC() onlyListers public {
114         list(0x742e8bb8e6bde9cb2df5449f8de7510798727fb1,0x865ec58b06bF6305B886793AA20A2da31D034E68);
115     }
116 
117     function listMAS() onlyListers public {
118         list(0x56e37b6b79d4e895618b8bb287748702848ae8c0,0x23Ccc43365D9dD3882eab88F43d515208f832430);
119     }
120 
121     function listDTH() onlyListers public {
122         list(0x2631a5222522156dfafaa5ca8480223d6465782d,0x5adc961D6AC3f7062D2eA45FEFB8D8167d44b190);
123     }
124 
125     function listTCC() onlyListers public {
126         list(0xa9312cb86d1e532b7c21881ce03a1a9d52f6adb1,0x9389434852b94bbaD4c8AfEd5B7BDBc5Ff0c2275);
127     }
128 
129 }