1 // Ethertote - Reward/Recogniton contract
2 // 09.08.18 
3 //
4 // ----------------------------------------------------------------------------
5 // Overview
6 // ----------------------------------------------------------------------------
7 //
8 // There are various individuals we would like to reward over the coming 
9 // weeks with TOTE tokens. Admins will add an ethereum wallet address and a 
10 // number of tokens for each individual to this smart contract. 
11 // The individual simply needs to click on the claim button and claim their tokens.
12 //
13 // This function will open immediately after the completion of the token sale, and will 
14 // remain open for 60 days, after which time admin will be able to recover any 
15 // unclaimed tokens 
16 // ----------------------------------------------------------------------------
17 
18 
19 pragma solidity 0.4.24;
20 
21 ///////////////////////////////////////////////////////////////////////////////
22 // SafeMath Library 
23 ///////////////////////////////////////////////////////////////////////////////
24 library SafeMath {
25 
26   /**
27   * @dev Multiplies two numbers, throws on overflow.
28   */
29   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
30     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
31     // benefit is lost if 'b' is also tested.
32     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
33     if (a == 0) {
34       return 0;
35     }
36 
37     c = a * b;
38     assert(c / a == b);
39     return c;
40   }
41 
42   /**
43   * @dev Integer division of two numbers, truncating the quotient.
44   */
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     // uint256 c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49     return a / b;
50   }
51 
52   /**
53   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
54   */
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   /**
61   * @dev Adds two numbers, throws on overflow.
62   */
63   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
64     c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 }
69 
70 
71 
72 // ----------------------------------------------------------------------------
73 // EXTERNAL CONTRACTS
74 // ----------------------------------------------------------------------------
75 
76 contract EthertoteToken {
77     function thisContractAddress() public pure returns (address) {}
78     function balanceOf(address) public pure returns (uint256) {}
79     function transfer(address, uint) public {}
80 }
81 
82 contract TokenSale {
83     function closingTime() public pure returns (uint) {}
84 }
85 
86 
87 // ----------------------------------------------------------------------------
88 
89 
90 // MAIN CONTRACT
91 
92 contract Reward {
93         using SafeMath for uint256;
94         
95     // VARIABLES
96     address public admin;
97     address public thisContractAddress;
98     address public tokenContractAddress = 0x42be9831FFF77972c1D0E1eC0aA9bdb3CaA04D47;
99     
100     address public tokenSaleAddress = 0x1C49d3c4895E7b136e8F8b804F1279068d4c3c96;
101     
102     uint public contractCreationBlockNumber;
103     uint public contractCreationBlockTime;
104     
105     uint public tokenSaleClosingTime;
106     
107     bool public claimTokenWindowOpen;
108     uint public windowOpenTime;
109   
110     // ENUM
111     EthertoteToken token;       
112     TokenSale tokensale;
113     
114 
115     // EVENTS 
116 	event Log(string text);
117         
118     // MODIFIERS
119     modifier onlyAdmin { 
120         require(
121             msg.sender == admin
122         ); 
123         _; 
124     }
125         
126     modifier onlyContract { 
127         require(
128             msg.sender == admin ||
129             msg.sender == thisContractAddress
130         ); 
131         _; 
132     }   
133         
134  
135     // CONSTRUCTOR
136     constructor() public payable {
137         admin = msg.sender;
138         thisContractAddress = address(this);
139         contractCreationBlockNumber = block.number;
140         token = EthertoteToken(tokenContractAddress);
141         tokensale = TokenSale(tokenSaleAddress);
142 
143 	    emit Log("Reward contract created.");
144     }
145     
146     // FALLBACK FUNCTION
147     function () private payable {}
148     
149         
150 // ----------------------------------------------------------------------------
151 // Admin Only Functions
152 // ----------------------------------------------------------------------------
153 
154     // STRUCT 
155     Claimant[] public claimants;  // special struct variable
156     
157         struct Claimant {
158         address claimantAddress;
159         uint claimantAmount;
160         bool claimantHasClaimed;
161     }
162 
163 
164     // Admin fuction to add claimants
165     function addClaimant(address _address, uint _amount, bool) onlyAdmin public {
166             Claimant memory newClaimant = Claimant ({
167                 claimantAddress: _address,
168                 claimantAmount: _amount,
169                 claimantHasClaimed: false
170                 });
171                 claimants.push(newClaimant);
172     }
173     
174     
175     function adjustEntitlement(address _address, uint _amount) onlyAdmin public {
176         for (uint i = 0; i < claimants.length; i++) {
177             if(_address == claimants[i].claimantAddress) {
178                 claimants[i].claimantAmount = _amount;
179             }
180             else revert();
181             }  
182     }
183     
184     // recover tokens tha were not claimed 
185     function recoverTokens() onlyAdmin public {
186         require(now < (showTokenSaleClosingTime().add(61 days)));
187         token.transfer(admin, token.balanceOf(thisContractAddress));
188     }
189 
190 
191 // ----------------------------------------------------------------------------
192 // This method can be used by admin to extract Eth accidentally 
193 // sent to this smart contract.
194 // ----------------------------------------------------------------------------
195     function ClaimEth() onlyAdmin public {
196         address(admin).transfer(address(this).balance);
197 
198     }  
199     
200     
201     
202 // ----------------------------------------------------------------------------
203 // PUBLIC FUNCTION - To be called by people claiming reward 
204 // ----------------------------------------------------------------------------
205 
206     // callable by claimant after token sale is completed
207     function claimTokens() public {
208         require(now > showTokenSaleClosingTime());
209         require(now < (showTokenSaleClosingTime().add(60 days)));
210           for (uint i = 0; i < claimants.length; i++) {
211             if(msg.sender == claimants[i].claimantAddress) {
212                 require(claimants[i].claimantHasClaimed == false);
213                 token.transfer(msg.sender, claimants[i].claimantAmount);
214                 claimants[i].claimantHasClaimed = true;
215             }
216           }
217     }
218     
219     
220 // ----------------------------------------------------------------------------
221 // public view Functions
222 // ----------------------------------------------------------------------------
223     
224     // check claim entitlement
225     function checkClaimEntitlement() public view returns(uint) {
226         for (uint i = 0; i < claimants.length; i++) {
227             if(msg.sender == claimants[i].claimantAddress) {
228                 require(claimants[i].claimantHasClaimed == false);
229                 return claimants[i].claimantAmount;
230             }
231             else return 0;
232         }  
233     }
234     
235     
236     // check claim entitlement of any wallet
237     function checkClaimEntitlementofWallet(address _address) public view returns(uint) {
238         for (uint i = 0; i < claimants.length; i++) {
239             if(_address == claimants[i].claimantAddress) {
240                 require(claimants[i].claimantHasClaimed == false);
241                 return claimants[i].claimantAmount;
242             }
243             else return 0;
244         }  
245     }
246     
247     
248     
249     // check Eth balance of this contract
250     function thisContractBalance() public view returns(uint) {
251       return address(this).balance;
252     }
253 
254     // check balance of this smart contract
255     function thisContractTokenBalance() public view returns(uint) {
256       return token.balanceOf(thisContractAddress);
257     }
258 
259 
260     function showTokenSaleClosingTime() public view returns(uint) {
261         return tokensale.closingTime();
262     }
263 
264 
265 }