1 pragma solidity ^0.4.25;
2 
3 contract token {
4     function transfer(address receiver, uint256 amount) public;
5     function balanceOf(address _owner) public constant returns (uint256 balance);
6     function burnFrom(address from, uint256 value) public;
7 }
8 
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33   
34 }
35 
36 contract owned {
37         address public owner;
38 
39         constructor() public {
40             owner = 0x953600669b794BB7a2E0Bc6C5a7f5fA96c3c1928;
41         }
42 
43         modifier onlyOwner {
44             require(msg.sender == owner);
45             _;
46         }
47 
48         function transferOwnership(address newOwner) onlyOwner public {
49             owner = newOwner;
50         }
51 }
52 
53 contract EzyStayzCrowdsale is owned{
54     using SafeMath for uint256;
55     
56     address public beneficiary;
57     uint256 public SoftCap;
58     uint256 public HardCap;
59     uint256 public amountRaised;
60     uint256 public preSaleStartdate;
61     uint256 public preSaleDeadline;
62     uint256 public mainSaleStartdate;
63     uint256 public mainSaleDeadline;
64     uint256 public price;
65     uint256 public fundTransferred;
66     uint256 public tokenSold;
67     token public tokenReward;
68     mapping(address => uint256) public balanceOf;
69     bool crowdsaleClosed = false;
70     bool returnFunds = false;
71 	
72 	event GoalReached(address recipient, uint totalAmountRaised);
73     event FundTransfer(address backer, uint amount, bool isContribution);
74 
75     /**
76      * Constrctor function
77      *
78      * Setup the owner
79      */
80     constructor() public {
81         beneficiary = 0x953600669b794BB7a2E0Bc6C5a7f5fA96c3c1928;
82         SoftCap = 15000 ether;
83         HardCap = 150000 ether;
84         preSaleStartdate = 1541030400;
85         preSaleDeadline = 1543622399;
86         mainSaleStartdate = 1543622400;
87         mainSaleDeadline = 1551398399;
88         price = 0.0004 ether;
89         tokenReward = token(0x49246EF0e2eF35CD7523072BE75bC857B9eC63d9);
90     }
91 
92     /**
93      * Fallback function
94      *
95      * The function without name is the default function that is called whenever anyone sends funds to a contract
96      */
97     function () payable public {
98         require(!crowdsaleClosed);
99         uint256 bonus = 0;
100         uint256 amount;
101         uint256 ethamount = msg.value;
102         balanceOf[msg.sender] = balanceOf[msg.sender].add(ethamount);
103         amountRaised = amountRaised.add(ethamount);
104         
105         //add bounus for funders
106         if(now >= preSaleStartdate && now <= preSaleDeadline){
107             amount =  ethamount.div(price);
108             bonus = amount * 33 / 100;
109             amount = amount.add(bonus);
110         }
111         else if(now >= mainSaleStartdate && now <= mainSaleStartdate + 30 days){
112             amount =  ethamount.div(price);
113             bonus = amount * 25/100;
114             amount = amount.add(bonus);
115         }
116         else if(now >= mainSaleStartdate + 30 days && now <= mainSaleStartdate + 45 days){
117             amount =  ethamount.div(price);
118             bonus = amount * 15/100;
119             amount = amount.add(bonus);
120         }
121         else if(now >= mainSaleStartdate + 45 days && now <= mainSaleStartdate + 60 days){
122             amount =  ethamount.div(price);
123             bonus = amount * 10/100;
124             amount = amount.add(bonus);
125         } else {
126             amount =  ethamount.div(price);
127             bonus = amount * 7/100;
128             amount = amount.add(bonus);
129         }
130         
131         amount = amount.mul(100000000000000);
132         tokenReward.transfer(msg.sender, amount);
133         tokenSold = tokenSold.add(amount);
134 		emit FundTransfer(msg.sender, ethamount, true);
135     }
136 
137     modifier afterDeadline() { if (now >= mainSaleDeadline) _; }
138 
139     /**
140      *ends the campaign after deadline
141      */
142      
143     function endCrowdsale() public afterDeadline  onlyOwner {
144           crowdsaleClosed = true;
145     }
146     
147     function EnableReturnFunds() public onlyOwner {
148           returnFunds = true;
149     }
150     
151     function DisableReturnFunds() public onlyOwner {
152           returnFunds = false;
153     }
154 	
155 	function ChangePrice(uint256 _price) public onlyOwner {
156 		  price = _price;	
157 	}
158 	
159 	function ChangeBeneficiary(address _beneficiary) public onlyOwner {
160 		  beneficiary = _beneficiary;	
161 	}
162 	 
163     function ChangePreSaleDates(uint256 _preSaleStartdate, uint256 _preSaleDeadline) onlyOwner public{
164           if(_preSaleStartdate != 0){
165                preSaleStartdate = _preSaleStartdate;
166           }
167           if(_preSaleDeadline != 0){
168                preSaleDeadline = _preSaleDeadline;
169           }
170 		  
171 		  if(crowdsaleClosed == true){
172 			 crowdsaleClosed = false;
173 		  }
174     }
175     
176     function ChangeMainSaleDates(uint256 _mainSaleStartdate, uint256 _mainSaleDeadline) onlyOwner public{
177           if(_mainSaleStartdate != 0){
178                mainSaleStartdate = _mainSaleStartdate;
179           }
180           if(_mainSaleDeadline != 0){
181                mainSaleDeadline = _mainSaleDeadline; 
182           }
183 		  
184 		  if(crowdsaleClosed == true){
185 			 crowdsaleClosed = false;
186 		  }
187     }
188     
189     function getTokensBack() onlyOwner public{
190         uint256 remaining = tokenReward.balanceOf(this);
191         tokenReward.transfer(beneficiary, remaining);
192     }
193     
194     function safeWithdrawal() public afterDeadline {
195 	   if (returnFunds) {
196 			uint amount = balanceOf[msg.sender];
197 			if (amount > 0) {
198 				if (msg.sender.send(amount)) {
199 				   emit FundTransfer(msg.sender, amount, false);
200 				   balanceOf[msg.sender] = 0;
201 				   fundTransferred = fundTransferred.add(amount);
202 				} 
203 			}
204 		}
205 
206 		if (returnFunds == false && beneficiary == msg.sender) {
207 		    uint256 ethToSend = amountRaised - fundTransferred;
208 			if (beneficiary.send(ethToSend)) {
209 			  fundTransferred = fundTransferred.add(ethToSend);
210 			} 
211 		}
212     }
213 }