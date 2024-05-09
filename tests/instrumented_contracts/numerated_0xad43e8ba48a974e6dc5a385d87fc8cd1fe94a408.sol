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
12     uint public price = 0.000142857 ether;
13     bool public crowdsaleClosed = false;
14     bool public adminVer = false;
15     mapping(address => uint256) public balanceOf;
16 
17 
18     event GoalReached(address recipient, uint totalAmountRaised);
19     event FundTransfer(address backer, uint amount, uint price, bool isContribution);
20 
21     /**
22      * Constrctor function
23      *
24      * Setup the owner
25      */
26     function Crowdsale() {
27         beneficiary = 0xA4047af02a2Fd8e6BB43Cfe8Ab25292aC52c73f4;
28         tokenReward = token(0x12AC8d8F0F48b7954bcdA736AF0576a12Dc8C387);
29     }
30 
31     modifier onlyOwner {
32         require(msg.sender == beneficiary);
33         _;
34     }
35 
36     /**
37      * Check ownership
38      */
39     function checkAdmin() onlyOwner {
40         adminVer = true;
41     }
42 
43     /**
44      * Return unsold tokens to beneficiary address
45      */
46     function getUnsoldTokens(uint val_) onlyOwner {
47         tokenReward.transfer(beneficiary, val_);
48     }
49 
50     /**
51      * Return unsold tokens to beneficiary address with decimals
52      */
53     function getUnsoldTokensWithDecimals(uint val_, uint dec_) onlyOwner {
54         val_ = val_ * 10 ** dec_;
55         tokenReward.transfer(beneficiary, val_);
56     }
57 
58     /**
59      * Close/Open crowdsale
60      */
61     function closeCrowdsale(bool closeType) onlyOwner {
62         crowdsaleClosed = closeType;
63     }
64 
65     /**
66      * Fallback function
67      *
68      * The function without name is the default function that is called whenever anyone sends funds to a contract
69      */
70     function () payable {
71         require(!crowdsaleClosed && msg.value <= 2 ether);                                  //1 ether is minimum to contribute                                                                
72         uint amount = msg.value;                                                           //save users eth value
73         balanceOf[msg.sender] += amount;                                                   //save users eth value in balance list 
74         amountRaised += amount;                                                            //update total amount of crowdsale
75         uint sendTokens = (amount / price) * 10 ** uint256(18);                            //calculate user's tokens
76         tokenReward.transfer(msg.sender, sendTokens);                                      //send tokens to user
77         soldTokensCounter += sendTokens;                                                   //update total sold tokens counter
78         FundTransfer(msg.sender, amount, price, true);                                     //pin transaction data in blockchain
79         if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } //send users amount to beneficiary
80     }
81 }