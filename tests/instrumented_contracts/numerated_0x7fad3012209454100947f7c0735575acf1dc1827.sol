1 pragma solidity ^0.4.18;
2 
3 interface TokenConfigInterface {
4     function admin() public returns(address);
5     function claimAdmin() public;
6     function transferAdminQuickly(address newAdmin) public;
7 
8     // network
9     function listPairForReserve(address reserve, address src, address dest, bool add) public;
10 
11     // reserve
12     function approveWithdrawAddress(address token, address addr, bool approve) public;
13 
14     // conversion rate
15     function addToken(address token) public;
16     function enableTokenTrade(address token) public;
17     function setTokenControlInfo(
18         address token,
19         uint minimalRecordResolution,
20         uint maxPerBlockImbalance,
21         uint maxTotalImbalance
22     ) public;
23 }
24 
25 
26 contract TokenAdder {
27     TokenConfigInterface public network;
28     TokenConfigInterface public reserve;
29     TokenConfigInterface public conversionRate;
30     address public withdrawAddress;
31     address public ETH = 0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;
32     address[] public newTokens = [
33         0x00f0ee6b27b759c9893ce4f094b49ad28fd15a23e4,
34         0x004156D3342D5c385a87D264F90653733592000581,
35         0x001a7a8bd9106f2b8d977e08582dc7d24c723ab0db,
36         0x00255aa6df07540cb5d3d297f0d0d4d84cb52bc8e6];
37 
38     function TokenAdder(TokenConfigInterface _network,
39                         TokenConfigInterface _reserve,
40                         TokenConfigInterface _conversionRate,
41                         address              _withdrawAddress) public {
42 
43         network = _network;
44         reserve = _reserve;
45         conversionRate = _conversionRate;
46         withdrawAddress = _withdrawAddress;
47     }
48 
49     function listPairs() public {
50         address orgAdmin = network.admin();
51         network.claimAdmin();
52 
53         for( uint i = 0 ; i < newTokens.length ; i++ ) {
54             network.listPairForReserve(reserve,ETH,newTokens[i],true);
55             network.listPairForReserve(reserve,newTokens[i],ETH,true);
56         }
57 
58         network.transferAdminQuickly(orgAdmin);
59         require(orgAdmin == network.admin());
60     }
61 
62     function approveWithdrawAddress() public {
63         address orgAdmin = reserve.admin();
64         reserve.claimAdmin();
65 
66         for( uint i = 0 ; i < newTokens.length ; i++ ) {
67             reserve.approveWithdrawAddress(newTokens[i], withdrawAddress, true);
68         }
69 
70 
71         reserve.transferAdminQuickly(orgAdmin);
72         require(orgAdmin == reserve.admin());
73     }
74 
75     function addTokens() public {
76         address orgAdmin = conversionRate.admin();
77         conversionRate.claimAdmin();
78 
79         for( uint i = 0 ; i < newTokens.length ; i++ ) {
80             conversionRate.addToken(newTokens[i]);
81             conversionRate.enableTokenTrade(newTokens[i]);
82         }
83 
84         conversionRate.transferAdminQuickly(orgAdmin);
85         require(orgAdmin == conversionRate.admin());
86     }
87 
88     function setTokenControlInfos() public {
89         address orgAdmin = conversionRate.admin();
90         conversionRate.claimAdmin();
91 
92         conversionRate.setTokenControlInfo(
93             0x00255aa6df07540cb5d3d297f0d0d4d84cb52bc8e6,
94             1000000000000000,
95             8000000000000000000000,
96             8000000000000000000000 );
97 
98         conversionRate.setTokenControlInfo(
99             0x001a7a8bd9106f2b8d977e08582dc7d24c723ab0db,
100             100000000000000,
101             24000000000000000000000,
102             24000000000000000000000 );
103 
104         conversionRate.setTokenControlInfo(
105             0x00f0ee6b27b759c9893ce4f094b49ad28fd15a23e4,
106             10000,
107             800000000000,
108             800000000000 );
109 
110         conversionRate.setTokenControlInfo(
111             0x004156D3342D5c385a87D264F90653733592000581,
112             10000,
113             800000000000,
114             800000000000 );
115 
116         conversionRate.transferAdminQuickly(orgAdmin);
117         require(orgAdmin == conversionRate.admin());
118     }
119 }