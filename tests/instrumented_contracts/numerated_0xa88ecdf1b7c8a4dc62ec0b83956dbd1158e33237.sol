1 pragma solidity 0.5.4; /*
2 
3 ___________________________________________________________________
4   _      _                                        ______           
5   |  |  /          /                                /              
6 --|-/|-/-----__---/----__----__---_--_----__-------/-------__------
7   |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
8 __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_
9 
10 
11  .----------------.   .----------------.   .----------------.   .----------------. 
12 | .--------------. | | .--------------. | | .--------------. | | .--------------. |
13 | |     _____    | | | |   ______     | | | | _____  _____ | | | |  ____  ____  | |
14 | |    |_   _|   | | | |  |_   __ \   | | | ||_   _||_   _|| | | | |_  _||_  _| | |
15 | |      | |     | | | |    | |__) |  | | | |  | |    | |  | | | |   \ \  / /   | |
16 | |      | |     | | | |    |  ___/   | | | |  | '    ' |  | | | |    > `' <    | |
17 | |     _| |_    | | | |   _| |_      | | | |   \ `--' /   | | | |  _/ /'`\ \_  | |
18 | |    |_____|   | | | |  |_____|     | | | |    `.__.'    | | | | |____||____| | |
19 | |              | | | |              | | | |              | | | |              | |
20 | '--------------' | | '--------------' | | '--------------' | | '--------------' |
21  '----------------'   '----------------'   '----------------'   '----------------' 
22 
23                                 __________________________________________________________________
24                                       __                                      __                  
25                                     /    )                          /       /    )         /      
26                                 ---/--------)__----__-----------__-/--------\--------__---/----__-
27                                   /        /   ) /   )| /| /  /   /          \     /   ) /   /___)
28                                 _(____/___/_____(___/_|/_|/__(___/_______(____/___(___(_/___(___ _
29                                                                                                   
30                                                                   
31   
32 // ----------------------------------------------------------------------------
33 // 'IPUX' Crowdsale contract with following features
34 //      => Token address change
35 //      => SafeMath implementation 
36 //      => Ether sent to owner immediately
37 //      => Phased ICO
38 //
39 // Copyright (c) 2019 TradeWeIPUX Limited ( https://ipux.io )
40 // Contract designed by EtherAuthority ( https://EtherAuthority.io )
41 // ----------------------------------------------------------------------------
42   
43 */ 
44 
45 //*******************************************************************//
46 //------------------------ SafeMath Library -------------------------//
47 //*******************************************************************//
48 /**
49  * @title SafeMath
50  * @dev Math operations with safety checks that throw on error
51  */
52 library SafeMath {
53   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54     if (a == 0) {
55       return 0;
56     }
57     uint256 c = a * b;
58     assert(c / a == b);
59     return c;
60   }
61 
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     // assert(b > 0); // Solidity automatically throws when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66     return c;
67   }
68 
69   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70     assert(b <= a);
71     return a - b;
72   }
73 
74   function add(uint256 a, uint256 b) internal pure returns (uint256) {
75     uint256 c = a + b;
76     assert(c >= a);
77     return c;
78   }
79 }
80 
81 
82 //*******************************************************************//
83 //------------------ Contract to Manage Ownership -------------------//
84 //*******************************************************************//
85     
86 contract owned {
87     address payable public owner;
88     
89      constructor () public {
90         owner = msg.sender;
91     }
92 
93     modifier onlyOwner {
94         require(msg.sender == owner);
95         _;
96     }
97 
98     function transferOwnership(address payable newOwner) onlyOwner public {
99         owner = newOwner;
100     }
101 }
102 
103 
104 interface TokenRecipient { function transfer(address _to, uint256 _value) external; }
105 
106 contract IPUXcrowdsale is owned {
107     
108     /*==============================
109     =   TECHNICAL SPECIFICATIONS   =
110     ===============================
111     => ICO period 1 start:  15 Jan 2019 00:00:00 GMT
112     => ICO period 1 end:    17 Feb 2019 00:00:00 GMT
113     => ICO period 1 bonus:  30%
114     => ICO period 2 start:  01 Mar 2019 00:00:00 GMT
115     => ICO period 2 end:    31 Mar 2019 00:00:00 GMT
116     => ICO period 2 bonus:  20%
117     => ICO period 3 start:  15 Apr 2019 00:00:00 GMT
118     => ICO period 3 end:    30 Apr 2019 00:00:00 GMT
119     
120     => Token distribution only if ICO phases are going on. Else, it will accept ether but no tokens given
121     => There is no minimum or maximum of contrubution
122     => No acceptance of ether if hard cap is reached
123     */
124     
125 
126     /*==============================
127     =       PUBLIC VARIABLES       =
128     ==============================*/
129     address public tokenAddress;
130     uint256 public tokenDecimal;
131     using SafeMath for uint256;
132     TokenRecipient tokenContract = TokenRecipient(tokenAddress);
133     
134     /*==============================
135     =        ICO VARIABLES         =
136     ==============================*/
137     uint256 public icoPeriod1start  = 1547510400;   //15 Jan 2019 00:00:00 GMT
138     uint256 public icoPeriod1end    = 1550361600;   //17 Feb 2019 00:00:00 GMT
139     uint256 public icoPeriod2start  = 1551398400;   //01 Mar 2019 00:00:00 GMT
140     uint256 public icoPeriod2end    = 1553990400;   //31 Mar 2019 00:00:00 GMT
141     uint256 public icoPeriod3start  = 1555286400;   //15 Apr 2019 00:00:00 GMT
142     uint256 public icoPeriod3end    = 1556582400;   //30 Apr 2019 00:00:00 GMT
143     uint256 public softcap          = 70000 ether;
144     uint256 public hardcap          = 400000 ether;
145     uint256 public fundRaised       = 0;
146     uint256 public exchangeRate     = 500;           //1 ETH = 500 Tokens which equals to approx 0.002 ETH / token
147     
148 
149 
150     /*==============================
151     =       PUBLIC FUNCTIONS       =
152     ==============================*/
153     
154     /**
155      * @notice Constructor function, which actually does not do anything 
156      */
157     constructor () public { }
158     
159     /**
160      * @notice Function to update the token address
161      * @param _tokenAddress Address of the token
162      */
163     function updateToken(address _tokenAddress, uint256 _tokenDecimal) public onlyOwner {
164         require(_tokenAddress != address(0), 'Address is invalid');
165         tokenAddress = _tokenAddress;
166         tokenDecimal = _tokenDecimal;
167     }
168     
169     /**
170      * @notice Payble fallback function which accepts ether and sends tokens to caller according to ETH amount
171      */
172     function () payable external {
173         // no acceptance of ether if hard cap is reached
174         require(fundRaised < hardcap, 'hard cap is reached');
175         // token distribution only if ICO is going on. Else, it will accept ether but no tokens given
176 		if((icoPeriod1start < now && icoPeriod1end > now) || (icoPeriod2start < now && icoPeriod2end > now) || icoPeriod3start < now && icoPeriod3end > now){
177         // calculate token amount to be sent, as pe weiamount * exchangeRate
178 		uint256 token = msg.value.mul(exchangeRate);                    
179 		// adding purchase bonus if application
180 		uint256 finalTokens = token.add(calculatePurchaseBonus(token));
181         // makes the token transfers
182 		tokenContract.transfer(msg.sender, finalTokens);
183 		}
184 		fundRaised += msg.value;
185 		// transfer ether to owner
186 		owner.transfer(msg.value);                                           
187 	}
188 
189     /**
190      * @notice Internal function to calculate the purchase bonus
191      * @param token Amount of total tokens
192      * @return uint256 total payable purchase bonus
193      */
194     function calculatePurchaseBonus(uint256 token) internal view returns(uint256){
195 	    if(icoPeriod1start < now && icoPeriod1end > now){
196 	        return token.mul(30).div(100);  //30% bonus in period 1
197 	    }
198 	    else if(icoPeriod2start < now && icoPeriod2end > now){
199 	        return token.mul(20).div(100);  //20% bonus in period 2
200 	    }
201 	    else{
202 	        return 0;                       // No bonus otherwise
203 	    }
204 	}
205       
206     /**
207      * @notice Just in rare case, owner wants to transfer Ether from contract to owner address
208      */
209     function manualWithdrawEther()onlyOwner public{
210         address(owner).transfer(address(this).balance);
211     }
212     
213     function manualWithdrawTokens(uint256 tokenAmount) public onlyOwner{
214         // no need for overflow checking as that will be done in transfer function
215         //_transfer(address(this), owner, tokenAmount);
216         tokenContract.transfer(owner, tokenAmount);
217     }
218     
219 }