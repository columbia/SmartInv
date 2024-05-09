1 pragma solidity ^0.4.25;
2 
3 /**
4  * token contract functions
5 */
6 contract token {
7     function transfer(address receiver, uint256 amount) public;
8     function balanceOf(address _owner) public view returns (uint256 balance);
9 }
10 
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35   
36 }
37 
38 contract owned {
39         address public owner;
40 
41         constructor() public {
42             owner = msg.sender;
43         }
44 
45         modifier onlyOwner {
46             require(msg.sender == owner);
47             _;
48         }
49 
50         function transferOwnership(address newOwner) onlyOwner public {
51             owner = newOwner;
52         }
53 }
54 
55 contract GenjiCrowdsale is owned{
56     using SafeMath for uint256;
57     
58     address public beneficiary;
59     uint256 public amountRaised;
60     uint256 public preSaleStartdate;
61     uint256 public preSaleDeadline;
62     uint256 public mainSaleStartdate;
63     uint256 public mainSaleDeadline;
64     uint256 public preSalePrice;
65     uint256 public price;
66     uint256 public fundTransferred;
67     token public tokenReward;
68     mapping(address => uint256) public balanceOf;
69     bool crowdsaleClosed = false;
70 
71     /**
72      * Constrctor function
73      *
74      */
75     constructor() public{
76         beneficiary = 0xBCEb3a1Ff8dF1eD574bdEeBf8c2feEf47351Ba42;
77         preSaleStartdate = 1563580800;
78         preSaleDeadline = 1564617599;
79         mainSaleStartdate = 1564617600;
80         mainSaleDeadline = 1567641599;
81         preSalePrice = 0.00002345 ether;
82         price = 0.0000335 ether;
83         tokenReward = token(0xb49b4d400D66AAa53ec07184A8C7c6C9c23374c9);
84     }
85 
86     /**
87      * Fallback function
88      *
89      * The function without name is the default function that is called whenever anyone sends funds to a contract
90      */
91     function () payable external {
92         require(!crowdsaleClosed);
93         uint256 bonus;
94         uint256 amount;
95         uint256 ethamount = msg.value;
96         balanceOf[msg.sender] = balanceOf[msg.sender].add(ethamount);
97         amountRaised = amountRaised.add(ethamount);
98         
99         //add bounus for funders
100         if(now >= preSaleStartdate && now <= preSaleDeadline){
101             amount =  ethamount.div(preSalePrice);
102             bonus = amount * 50 / 100;
103             amount = amount.add(bonus);
104         }
105         else if(now >= mainSaleStartdate && now <= mainSaleStartdate + 1 weeks){
106             amount =  ethamount.div(price);
107             bonus = amount * 40/100;
108             amount = amount.add(bonus);
109         }
110         else if(now >= mainSaleStartdate + 1 weeks && now <= mainSaleStartdate + 2 weeks){
111             amount =  ethamount.div(price);
112             bonus = amount * 33/100;
113             amount = amount.add(bonus);
114         }
115         else if(now >= mainSaleStartdate + 2 weeks && now <= mainSaleStartdate + 3 weeks){
116             amount =  ethamount.div(price);
117             bonus = amount * 25/100;
118             amount = amount.add(bonus);
119         }
120         else if(now >= mainSaleStartdate + 3 weeks && now <= mainSaleStartdate + 4 weeks){
121             amount =  ethamount.div(price);
122             bonus = amount * 15/100;
123             amount = amount.add(bonus);
124         }
125         else {
126             amount =  ethamount.div(price);
127             bonus = amount * 8/100;
128             amount = amount.add(bonus);
129         }
130         
131         amount = amount.mul(1000000000000000000);
132         tokenReward.transfer(msg.sender, amount);
133         beneficiary.transfer(ethamount);
134         fundTransferred = fundTransferred.add(ethamount);
135     }
136 
137     modifier afterDeadline() { if (now >= mainSaleDeadline) _; }
138 
139     /**
140      *ends the campaign after deadline
141      */
142      
143     function endCrowdsale() public afterDeadline onlyOwner {
144          crowdsaleClosed = true;
145     }
146     
147     /**
148      *change pre sale price
149     */
150 	function ChangepreSalePrice(uint256 _preSalePrice) public onlyOwner {
151 		  preSalePrice = _preSalePrice;	
152 	}
153 	
154     /**
155      *change price
156     */
157 	function ChangePrice(uint256 _price) public onlyOwner {
158 		  price = _price;	
159 	}
160 	
161 	/**
162      *change beneficiary
163     */
164 	function ChangeBeneficiary(address _beneficiary) public onlyOwner {
165 		  beneficiary = _beneficiary;	
166 	}
167 	
168 	/**
169      *change dates
170     */
171     function ChangeDates(uint256 _preSaleStartdate, uint256 _preSaleDeadline, uint256 _mainSaleStartdate, uint256 _mainSaleDeadline) public onlyOwner {
172         
173           if(_preSaleStartdate != 0){
174                preSaleStartdate = _preSaleStartdate;
175           }
176           if(_preSaleDeadline != 0){
177                preSaleDeadline = _preSaleDeadline;
178           }
179           if(_mainSaleStartdate != 0){
180                mainSaleStartdate = _mainSaleStartdate;
181           }
182           if(_mainSaleDeadline != 0){
183                mainSaleDeadline = _mainSaleDeadline; 
184           }
185 		  
186 		  if(crowdsaleClosed == true){
187 			 crowdsaleClosed = false;
188 		  }
189     }
190     
191     function getTokensBack() public onlyOwner {
192         uint256 remaining = tokenReward.balanceOf(this);
193         tokenReward.transfer(beneficiary, remaining);
194     }
195 }