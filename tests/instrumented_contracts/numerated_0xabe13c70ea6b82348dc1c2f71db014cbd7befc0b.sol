1 /*
2 // Example of using Crowdfund Black List contract
3 // Add interface to CrowdfundBlackList in your crowdfund contract code
4 contract CrowdfundBlackList {
5 	function addrNotInBL(address _addr) public view returns (bool);
6 }
7 
8 contract ExampleCrowdfund {    	
9 	function() internal payable {
10 		// In first line of payable function of your crowdfund add thi
11 		require(CrowdfundBlackList(0xaBE13c70eA6b82348Dc1C2F71Db014cbD7BeFC0B).addrNotInBL(msg.sender),"Sender address in black list!");
12 	}
13 }
14 */
15 pragma solidity ^0.4.25;
16 
17 contract CrowdfundBlackList {
18     address public owner;
19     mapping(address => bool) internal BlackList;
20     
21     constructor () public {
22         owner = msg.sender;
23         // Poloniex addresses
24         BlackList[0x32Be343B94f860124dC4fEe278FDCBD38C102D88] = true;
25         BlackList[0xaB11204cfEacCFfa63C2D23AeF2Ea9aCCDB0a0D5] = true;
26         BlackList[0x209c4784AB1E8183Cf58cA33cb740efbF3FC18EF] = true;
27         BlackList[0xb794F5eA0ba39494cE839613fffBA74279579268] = true;
28         // Binance addresses
29         BlackList[0x3f5CE5FBFe3E9af3971dD833D26bA9b5C936f0bE] = true;
30         BlackList[0xD551234Ae421e3BCBA99A0Da6d736074f22192FF] = true;
31         BlackList[0x564286362092D8e7936f0549571a803B203aAceD] = true;
32         BlackList[0x0681d8Db095565FE8A346fA0277bFfdE9C0eDBBF] = true;
33         BlackList[0xfE9e8709d3215310075d67E3ed32A380CCf451C8] = true;
34         // Bitfinex addresses
35         BlackList[0x1151314c646Ce4E0eFD76d1aF4760aE66a9Fe30F] = true;
36         BlackList[0x7727E5113D1d161373623e5f49FD568B4F543a9E] = true;
37         BlackList[0x4fdd5Eb2FB260149A3903859043e962Ab89D8ED4] = true;
38         BlackList[0x876EabF441B2EE5B5b0554Fd502a8E0600950cFa] = true;
39         BlackList[0x742d35Cc6634C0532925a3b844Bc454e4438f44e] = true;
40         // Kraken addresses
41         BlackList[0x2910543Af39abA0Cd09dBb2D50200b3E800A63D2] = true;
42         BlackList[0x0A869d79a7052C7f1b55a8EbAbbEa3420F0D1E13] = true;
43         BlackList[0xE853c56864A2ebe4576a807D26Fdc4A0adA51919] = true;
44         BlackList[0x267be1C1D684F78cb4F6a176C4911b741E4Ffdc0] = true;
45         BlackList[0xFa52274DD61E1643d2205169732f29114BC240b3] = true;
46         // Bittrex addresses
47         BlackList[0xFBb1b73C4f0BDa4f67dcA266ce6Ef42f520fBB98] = true;
48         BlackList[0xE94b04a0FeD112f3664e45adb2B8915693dD5FF3] = true;
49         // Okex addresses
50         BlackList[0x6cC5F688a315f3dC28A7781717a9A798a59fDA7b] = true;
51         BlackList[0x236F9F97e0E62388479bf9E5BA4889e46B0273C3] = true;
52         // Huobi addresses
53         BlackList[0xaB5C66752a9e8167967685F1450532fB96d5d24f] = true;
54         BlackList[0x6748F50f686bfbcA6Fe8ad62b22228b87F31ff2b] = true;
55         BlackList[0xfdb16996831753d5331fF813c29a93c76834A0AD] = true;
56         BlackList[0xeEe28d484628d41A82d01e21d12E2E78D69920da] = true;
57         BlackList[0x5C985E89DDe482eFE97ea9f1950aD149Eb73829B] = true;
58         BlackList[0xDc76CD25977E0a5Ae17155770273aD58648900D3] = true;
59         BlackList[0xadB2B42F6bD96F5c65920b9ac88619DcE4166f94] = true;
60         BlackList[0xa8660c8ffD6D578F657B72c0c811284aef0B735e] = true;
61         BlackList[0x1062a747393198f70F71ec65A582423Dba7E5Ab3] = true;
62         BlackList[0xE93381fB4c4F14bDa253907b18faD305D799241a] = true;
63         BlackList[0xFA4B5Be3f2f84f56703C42eB22142744E95a2c58] = true;
64         BlackList[0x46705dfff24256421A05D056c29E81Bdc09723B8] = true;
65         BlackList[0x99fe5D6383289CDD56e54Fc0bAF7F67c957A8888] = true;
66         BlackList[0x1B93129F05cc2E840135AAB154223C75097B69bf] = true;
67         BlackList[0xEB6D43Fe241fb2320b5A3c9BE9CDfD4dd8226451] = true;
68         BlackList[0x956e0DBEcC0e873d34a5e39B25f364b2CA036730] = true;
69         // HitBTC addresses
70         BlackList[0x9C67e141C0472115AA1b98BD0088418Be68fD249] = true;
71         BlackList[0x59a5208B32e627891C389EbafC644145224006E8] = true;
72         BlackList[0xA12431D0B9dB640034b0CDFcEEF9CCe161e62be4] = true;
73         // Coinbene addresses
74         BlackList[0x9539e0b14021a43cDE41d9d45Dc34969bE9c7cb0] = true;
75         // UpBit addresses
76         BlackList[0x390dE26d772D2e2005C6d1d24afC902bae37a4bB] = true;
77         // Cryptopia addresses
78         BlackList[0x5BaEac0a0417a05733884852aa068B706967e790] = true;
79         // WithdrawDAO addresses
80         BlackList[0xBf4eD7b27F1d666546E30D74d50d173d20bca754] = true;
81         // Gate.io addresses
82         BlackList[0x0D0707963952f2fBA59dD06f2b425ace40b492Fe] = true;
83         BlackList[0x7793cD85c11a924478d358D49b05b37E91B5810F] = true;
84         BlackList[0x1C4b70a3968436B9A0a9cf5205c787eb81Bb558c] = true;
85     }
86     
87     function addrNotInBL(address _addr) public view returns (bool) {
88 	    return (! BlackList[_addr]);
89 	}
90 	
91 	function() internal payable {
92 	    require(msg.value >= 1);
93 	    BlackList[msg.sender] = true;
94 	}
95 	
96 	function withdraw() public {
97         require(owner.send(address(this).balance));
98 	}
99 	
100 	function _removeFromBL(address _addr) public {
101 	    require(msg.sender==owner);
102         BlackList[_addr] = false;
103 	}
104 }
105 
106 // --------------
107 
108 contract CrowdfundBL {
109 	function addrNotInBL(address _addr) public view returns (bool);
110 }
111 
112 contract ExampleCrowdfund {
113     address internal _crowdfundBL;
114     
115     function _setBL(address _addr) public {
116 		_crowdfundBL = _addr;
117 	}
118 	
119 	function() internal payable {
120 	    require(CrowdfundBL(_crowdfundBL).addrNotInBL(msg.sender),"Sender address in black list!");
121 	}
122 }