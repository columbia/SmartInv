1 pragma solidity ^0.4.19;
2 
3 contract token {
4     function transfer(address receiver, uint256 amount);
5     function balanceOf(address _owner) constant returns (uint256 balance);
6 }
7 
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32   
33 }
34 
35 contract WashCrowdsale {
36     using SafeMath for uint256;
37     
38     address public beneficiary;
39     uint256 public fundingGoal;
40     uint256 public amountRaised;
41     uint256 public preSaleStartdate;
42     uint256 public preSaleDeadline;
43     uint256 public mainSaleStartdate;
44     uint256 public mainSaleDeadline;
45     uint256 public price;
46     uint256 public fundTransferred;
47     token public tokenReward;
48     mapping(address => uint256) public balanceOf;
49     bool crowdsaleClosed = false;
50 
51     /**
52      * Constrctor function
53      *
54      * Setup the owner
55      */
56     function WashCrowdsale() {
57         beneficiary = 0x7C583E878f851A26A557ba50188Bc8B77d6F0e98;
58         fundingGoal = 2100 ether;
59         preSaleStartdate = 1523318400;
60         preSaleDeadline = 1523836800;
61         mainSaleStartdate = 1523923200;
62         mainSaleDeadline = 1525564800;
63         price = 0.0004166 ether;
64         tokenReward = token(0x5b8c5c4835b2B5dAEF18079389FDaEfE9f7a6063);
65     }
66 
67     /**
68      * Fallback function
69      *
70      * The function without name is the default function that is called whenever anyone sends funds to a contract
71      */
72     function () payable {
73         require(!crowdsaleClosed);
74         uint256 bonus = 0;
75         uint256 amount;
76         uint256 ethamount = msg.value;
77         balanceOf[msg.sender] = balanceOf[msg.sender].add(ethamount);
78         amountRaised = amountRaised.add(ethamount);
79         
80         //add bounus for funders
81         if(now >= preSaleStartdate && now <= preSaleDeadline ){
82             amount =  ethamount.div(price);
83             bonus = amount.div(8);
84             amount = amount.add(bonus);
85         }
86         else if(now >= mainSaleStartdate && now <= mainSaleDeadline){
87             amount =  ethamount.div(price);
88         }
89         
90         amount = amount.mul(1000000000000000000);
91         tokenReward.transfer(msg.sender, amount);
92         beneficiary.send(ethamount);
93         fundTransferred = fundTransferred.add(ethamount);
94     }
95 
96     modifier afterDeadline() { if (now >= mainSaleDeadline) _; }
97 
98     /**
99      *ends the campaign after deadline
100      */
101      
102     function endCrowdsale() afterDeadline {
103 	   if(msg.sender == beneficiary){
104          crowdsaleClosed = true;
105 	  }
106     }
107 	
108     function ChangeDates(uint256 _preSaleStartdate, uint256 _preSaleDeadline, uint256 _mainSaleStartdate, uint256 _mainSaleDeadline) {
109         if(msg.sender == beneficiary){
110               if(_preSaleStartdate != 0){
111                    preSaleStartdate = _preSaleStartdate;
112               }
113               if(_preSaleDeadline != 0){
114                    preSaleDeadline = _preSaleDeadline;
115               }
116               if(_mainSaleStartdate != 0){
117                    mainSaleStartdate = _mainSaleStartdate;
118               }
119               if(_mainSaleDeadline != 0){
120                    mainSaleDeadline = _mainSaleDeadline; 
121               }
122 			  
123 			  if(crowdsaleClosed == true){
124 				 crowdsaleClosed = false;
125 			  }
126         }
127     }
128     
129     function getTokensBack() {
130         uint256 remaining = tokenReward.balanceOf(this);
131         if(msg.sender == beneficiary){
132            tokenReward.transfer(beneficiary, remaining); 
133         }
134     }
135 }