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
18 
19     event GoalReached(address recipient, uint totalAmountRaised);
20     event FundTransfer(address backer, uint amount, uint price, bool isContribution);
21 
22     /**
23      * Constrctor function
24      *
25      * Setup the owner
26      */
27     function Crowdsale() {
28         beneficiary = 0xA4047af02a2Fd8e6BB43Cfe8Ab25292aC52c73f4;
29         tokenReward = token(0x12AC8d8F0F48b7954bcdA736AF0576a12Dc8C387);
30     }
31 
32     modifier onlyOwner {
33         require(msg.sender == beneficiary);
34         _;
35     }
36 
37     /**
38      * Check ownership
39      */
40     function checkAdmin() onlyOwner {
41         adminVer = true;
42     }
43 
44     /**
45      * Change crowdsale discount stage
46      */
47     function changeStage(uint stage) onlyOwner {
48         saleStage = stage;
49     }
50 
51     /**
52      * Return unsold tokens to beneficiary address
53      */
54     function getUnsoldTokens(uint val_) onlyOwner {
55         tokenReward.transfer(beneficiary, val_);
56     }
57 
58     /**
59      * Return unsold tokens to beneficiary address with decimals
60      */
61     function getUnsoldTokensWithDecimals(uint val_, uint dec_) onlyOwner {
62         val_ = val_ * 10 ** dec_;
63         tokenReward.transfer(beneficiary, val_);
64     }
65 
66     /**
67      * Close/Open crowdsale
68      */
69     function closeCrowdsale(bool closeType) onlyOwner {
70         crowdsaleClosed = closeType;
71     }
72 
73     /**
74      * Return current token price
75      *
76      * The price depends on `saleStage` and `amountRaised`
77      */
78     function getPrice() returns (uint) {
79         if (amountRaised > 12000 ether || saleStage == 4) {
80             return 0.000142857 ether;
81         } else if (amountRaised > 8000 ether || saleStage == 3) {
82             return 0.000125000 ether;
83         } else if (amountRaised > 4000 ether || saleStage == 2) {
84             return 0.000119047 ether;
85         }
86         return 0.000109890 ether;
87     }
88 
89     /**
90      * Fallback function
91      *
92      * The function without name is the default function that is called whenever anyone sends funds to a contract
93      */
94     function () payable {
95         require(!crowdsaleClosed && msg.value >= 1 ether);                                 //1 ether is minimum to contribute
96         price = getPrice();                                                                //get current token price
97         uint amount = msg.value;                                                           //save users eth value
98         balanceOf[msg.sender] += amount;                                                   //save users eth value in balance list 
99         amountRaised += amount;                                                            //update total amount of crowdsale
100         uint sendTokens = (amount / price) * 10 ** uint256(18);                            //calculate user's tokens
101         tokenReward.transfer(msg.sender, sendTokens);                                      //send tokens to user
102         soldTokensCounter += sendTokens;                                                   //update total sold tokens counter
103         FundTransfer(msg.sender, amount, price, true);                                     //pin transaction data in blockchain
104         if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } //send users amount to beneficiary
105     }
106 }