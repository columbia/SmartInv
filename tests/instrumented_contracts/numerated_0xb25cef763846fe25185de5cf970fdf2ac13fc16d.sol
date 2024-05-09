1 pragma solidity ^0.4.19;
2 
3 interface token {
4     function transfer(address receiver, uint amount);
5 }
6 
7 contract Crowdsale {
8     address public beneficiary;
9     uint public amountRaised;
10     token public tokenReward;
11     uint256 public soldTokensCounter;
12     uint public price;
13     uint public saleStage = 1;
14     bool public crowdsaleClosed = false;
15     bool public adminVer = false;
16     mapping(address => uint256) public balanceOf;
17 
18     event FundTransfer(address backer, uint amount, uint price, bool isContribution);
19 
20     /**
21      * Constrctor function
22      *
23      * Setup the owner
24      */
25     function Crowdsale() {
26         beneficiary = msg.sender;
27         tokenReward = token(0x745Fa4002332C020f6a05B3FE04BCCf060e36dD3);
28     }
29 
30     modifier onlyOwner {
31         require(msg.sender == beneficiary);
32         _;
33     }
34 
35     /**
36      * Check ownership
37      */
38     function checkAdmin() onlyOwner {
39         adminVer = true;
40     }
41 
42     /**
43      * Change crowdsale discount stage
44      */
45     function changeStage(uint stage) onlyOwner {
46         saleStage = stage;
47     }
48 
49     /**
50      * Return unsold tokens to beneficiary address
51      */
52     function getUnsoldTokens(uint val_) onlyOwner {
53         tokenReward.transfer(beneficiary, val_);
54     }
55 
56     /**
57      * Return unsold tokens to beneficiary address with decimals
58      */
59     function getUnsoldTokensWithDecimals(uint val_, uint dec_) onlyOwner {
60         val_ = val_ * 10 ** dec_;
61         tokenReward.transfer(beneficiary, val_);
62     }
63 
64     /**
65      * Close/Open crowdsale
66      */
67     function closeCrowdsale(bool closeType) onlyOwner {
68         crowdsaleClosed = closeType;
69     }
70 
71     /**
72      * Return current token price
73      *
74      * The price depends on `saleStage` and `amountRaised`
75      */
76     function getPrice() returns (uint) {
77         if (saleStage == 4) {
78             return 0.0002000 ether;
79         } else if (saleStage == 3) {
80             return 0.0001667 ether;
81         } else if (saleStage == 2) {
82             return 0.0001429 ether;
83         }
84         return 0.000125 ether;
85     }
86 
87     /**
88      * Fallback function
89      *
90      * The function without name is the default function that is called whenever anyone sends funds to a contract
91      */
92     function () payable {
93         require(!crowdsaleClosed);                                                         
94         price = getPrice();                                                                //get current token price
95         uint amount = msg.value;                                                           //save users eth value
96         balanceOf[msg.sender] += amount;                                                   //save users eth value in balance list 
97         amountRaised += amount;                                                            //update total amount of crowdsale
98         uint sendTokens = (amount / price) * 10 ** uint256(18);                            //calculate user's tokens
99         tokenReward.transfer(msg.sender, sendTokens);                                      //send tokens to user
100         soldTokensCounter += sendTokens;                                                   //update total sold tokens counter
101         FundTransfer(msg.sender, amount, price, true);                                     //pin transaction data in blockchain
102         if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } //send users amount to beneficiary
103     }
104 }