1 pragma solidity ^0.4.24;
2 
3 /*
4  *  @notice the token contract used as reward 
5  */
6 interface token {
7     /*
8      *  @notice exposes the transfer method of the token contract
9      *  @param _receiver address receiving tokens
10      *  @param _amount number of tokens being transferred       
11      */    
12     function transfer(address _receiver, uint _amount) returns (bool success);
13 }
14 
15 /*
16  * is owned
17  */
18 contract owned {
19     address public owner;
20 
21     function owned() {
22         owner = msg.sender;
23     }
24 
25     modifier onlyOwner() { 
26         require (msg.sender == owner); 
27         _; 
28     }
29 
30     function ownerTransferOwnership(address newOwner) onlyOwner
31     {
32         owner = newOwner;
33     }
34 }
35 
36 /**
37  * Math operations with safety checks
38  */
39 contract SafeMath {
40   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
41     uint256 c = a * b;
42     assert(a == 0 || c / a == b);
43     return c;
44   }
45 
46   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
47     assert(b > 0);
48     uint256 c = a / b;
49     assert(a == b * c + a % b);
50     return c;
51   }
52 
53   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
59     uint256 c = a + b;
60     assert(c>=a && c>=b);
61     return c;
62   }
63 
64   function assert(bool assertion) internal {
65     if (!assertion) {
66       throw;
67     }
68   }
69 }
70 
71 /* 
72 *  BOSTokenCrowdfund contract
73 *  Funds sent to this address transfer a customized ERC20 token to msg.sender for the duration of the crowdfund
74 *  Deployment order:
75 *  1. BOSToken, BOSTokenCrowdfund
76 *  2. Send tokens to this
77 *  3. -- crowdfund is open --
78 */
79 contract BOSTokenCrowdfund is owned, SafeMath {
80 
81     /*=================================
82     =            MODIFIERS            =
83     =================================*/
84 
85     /**
86      * check only allowPublicWithdraw
87      */
88     modifier onlyAllowPublicWithdraw() { 
89         require (allowPublicWithdraw); 
90         _; 
91     }
92 
93    /*================================
94     =            DATASETS            =
95     ================================*/
96     /* 0.000004 ETH per token base price */
97     uint public sellPrice = 0.000004 ether;
98     /* total amount of ether raised */
99     uint public amountRaised;
100     /* address of token used as reward */
101     token public tokenReward;
102     /* crowdsale is open */
103     bool public crowdsaleClosed = false;
104     /* map balance of address */
105     mapping (address => uint) public balanceOf;
106     /* allow public withdraw */
107     bool public allowPublicWithdraw = false;
108 
109     /*==============================
110     =            EVENTS            =
111     ==============================*/
112     /* log events */
113     event LogFundTransfer(address indexed Backer, uint indexed Amount, bool indexed IsContribution);
114 
115     /*
116      *  @param _fundingGoalInEthers the funding goal of the crowdfund
117      *  @param _durationInMinutes the length of the crowdfund in minutes
118      *  @param _addressOfTokenUsedAsReward the token address   
119      */  
120     function BOSTokenCrowdfund(
121         /* token */
122         token _addressOfTokenUsedAsReward
123     ) {
124         tokenReward = token(_addressOfTokenUsedAsReward);
125     }
126 
127     /*
128      *  @notice public function
129      *  default function is payable
130      *  responsible for transfer of tokens based on price, msg.sender and msg.value
131      *  tracks investment total of msg.sender
132      *  refunds any spare change
133      */      
134     function () payable
135     {
136         require (!crowdsaleClosed);
137         /* do not allow creating 0 */
138         require (msg.value > 0);
139 
140         uint tokens = SafeMath.safeMul(SafeMath.safeDiv(msg.value, sellPrice), 1 ether);
141         if(tokenReward.transfer(msg.sender, tokens)) {
142             LogFundTransfer(msg.sender, msg.value, true); 
143         } else {
144             throw;
145         }
146 
147         /* add to amountRaised */
148         amountRaised = SafeMath.safeAdd(amountRaised, msg.value);
149         /* track ETH balanceOf address in case emergency refund is required */
150         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], msg.value);
151     }
152 
153     /*
154      *  @notice public function
155      *  emergency manual refunds
156      */     
157     function publicWithdraw() public
158         onlyAllowPublicWithdraw
159     {
160         /* manual refunds */
161         calcRefund(msg.sender);
162     }
163 
164     /*==========================================
165     =            INTERNAL FUNCTIONS            =
166     ==========================================*/
167     /*
168      *  @notice internal function
169      *  @param _addressToRefund the address being refunded
170      *  accessed via public functions publicWithdraw
171      *  calculates refund amount available for an address
172      */
173     function calcRefund(address _addressToRefund) internal
174     {
175         /* assigns var amount to balance of _addressToRefund */
176         uint amount = balanceOf[_addressToRefund];
177         /* sets balance to 0 */
178         balanceOf[_addressToRefund] = 0;
179         /* is there any balance? */
180         if (amount > 0) {
181             /* call to untrusted address */
182             _addressToRefund.transfer(amount);
183             /* log event */
184             LogFundTransfer(_addressToRefund, amount, false);
185         }
186     }
187 
188     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
189     /*
190      *  @notice public function
191      *  onlyOwner
192      *  moves ether to _to address
193      */
194     function withdrawAmountTo (uint256 _amount, address _to) public
195         onlyOwner
196     {
197         _to.transfer(_amount);
198         LogFundTransfer(_to, _amount, false);
199     }
200 
201     /**
202      *  @notice owner restricted function
203      *  @param status boolean
204      *  sets contract crowdsaleClosed
205      */
206     function ownerSetCrowdsaleClosed (bool status) public onlyOwner
207     {
208         crowdsaleClosed = status;
209     }
210 
211     /**
212      *  @notice owner restricted function
213      *  @param status boolean
214      *  sets contract allowPublicWithdraw
215      */
216     function ownerSetAllowPublicWithdraw (bool status) public onlyOwner
217     {
218         allowPublicWithdraw = status;
219     }
220 }