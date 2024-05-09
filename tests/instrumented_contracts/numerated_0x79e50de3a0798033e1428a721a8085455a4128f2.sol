1 pragma solidity ^0.4.13;
2 
3 contract token { function transfer(address receiver, uint amount); }
4 
5 contract SchmeckleTokenSale {
6   int public currentStage;
7   uint public priceInWei;
8   uint public availableTokensOnCurrentStage;
9 
10   address beneficiary;
11   uint decimalBase;
12   uint totalAmount;
13   token public tokenReward;
14   event SaleStageUp(int newSaleStage, uint newTokenPrice);
15 
16   function SchmeckleTokenSale() {
17       beneficiary = msg.sender;
18       priceInWei = 700 szabo;
19       decimalBase = 1000000000000000000;
20       tokenReward = token(0x0bB664f7b6FC928B2d1e5aA32182Ae07023Ed4aA);
21       availableTokensOnCurrentStage = 2000000;
22       totalAmount = 0;
23       currentStage = -3;
24   }
25 
26   function () payable {
27       uint amount = msg.value;
28 
29       if (amount < 1 finney) revert();
30 
31       uint tokens = amount * decimalBase / priceInWei;
32 
33       if (tokens > availableTokensOnCurrentStage * decimalBase) revert();
34 
35       if (currentStage > 21) revert();
36 
37       totalAmount += amount;
38       availableTokensOnCurrentStage -= tokens / decimalBase + 1;
39       if (totalAmount >= 21 ether && currentStage == -3) {
40           currentStage = -2;
41           priceInWei = 800 szabo;
42           SaleStageUp(currentStage, priceInWei);
43       }
44       if (totalAmount >= 333 ether && currentStage == -2) {
45           currentStage = -1;
46           priceInWei = 1000 szabo;
47           SaleStageUp(currentStage, priceInWei);
48       }
49       if (availableTokensOnCurrentStage < 1000 && currentStage >= 0) {
50           currentStage++;
51           priceInWei = priceInWei * 2;
52           availableTokensOnCurrentStage = 1000000;
53           SaleStageUp(currentStage, priceInWei);
54       }
55 
56       tokenReward.transfer(msg.sender, tokens);
57   }
58 
59   modifier onlyBeneficiary {
60       if (msg.sender != beneficiary) revert();
61       _;
62   }
63 
64  function withdraw(address recipient, uint amount) onlyBeneficiary {
65       if (recipient == 0x0) revert();
66       recipient.transfer(amount);
67  }
68 
69  function launchSale() onlyBeneficiary () {
70       if (currentStage > -1) revert();
71       currentStage = 0;
72       priceInWei = priceInWei * 2;
73       availableTokensOnCurrentStage = 2100000;
74       SaleStageUp(currentStage, priceInWei);
75  }
76 }