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
12     uint public price = 0.000109890 ether;
13     bool public crowdsaleClosed = false;
14     bool public adminVer = false;
15     mapping(address => uint256) public balanceOf;
16 
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
27         tokenReward = token(0x12AC8d8F0F48b7954bcdA736AF0576a12Dc8C387);
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
43      * Return unsold tokens to beneficiary address
44      */
45     function getUnsoldTokens(uint val_) onlyOwner {
46         tokenReward.transfer(beneficiary, val_);
47     }
48 
49     /**
50      * Return unsold tokens to beneficiary address with decimals
51      */
52     function getUnsoldTokensWithDecimals(uint val_, uint dec_) onlyOwner {
53         val_ = val_ * 10 ** dec_;
54         tokenReward.transfer(beneficiary, val_);
55     }
56 
57     /**
58      * Close/Open crowdsale
59      */
60     function closeCrowdsale(bool closeType) onlyOwner {
61         crowdsaleClosed = closeType;
62     }
63 
64     /**
65      * Fallback function
66      *
67      * The function without name is the default function that is called whenever anyone sends funds to a contract
68      */
69     function () payable {
70         require(!crowdsaleClosed);                                                         //1 ether is minimum to contribute
71         uint amount = msg.value;                                                           //save users eth value
72         balanceOf[msg.sender] += amount;                                                   //save users eth value in balance list 
73         amountRaised += amount;                                                            //update total amount of crowdsale
74         uint sendTokens = (amount / price) * 10 ** uint256(18);                            //calculate user's tokens
75         tokenReward.transfer(msg.sender, sendTokens);                                      //send tokens to user
76         soldTokensCounter += sendTokens;                                                   //update total sold tokens counter
77         FundTransfer(msg.sender, amount, price, true);                                     //pin transaction data in blockchain
78         if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } //send users amount to beneficiary
79     }
80 }