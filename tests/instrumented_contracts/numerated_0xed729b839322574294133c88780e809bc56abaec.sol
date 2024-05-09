1 pragma solidity ^0.4.16;
2 
3 interface token {
4     function transfer(address receiver, uint amount);
5 }
6 
7 contract knuckCrowdsaleOne {
8     address public beneficiary;
9     uint public amountRaised;
10     uint public price;
11     token public knuckReward;
12     mapping(address => uint256) public balanceOf;
13     bool fundingGoalReached = false;
14     bool crowdsaleClosed = false;
15 
16     event FundTransfer(address backer, uint amount, bool isContribution);
17 
18     /**
19      * Constrctor function
20      *
21      * Setup the owner
22      */
23     function knuckCrowdsaleOne(
24         address ifSuccessfulSendTo,
25         uint CostOfEachKnuck,
26         address addressOfTokenUsedAsReward
27     ) {
28         beneficiary = ifSuccessfulSendTo;
29         price = CostOfEachKnuck * 1 wei;
30         knuckReward = token(addressOfTokenUsedAsReward);
31     }
32 
33     /**
34      * Fallback function
35      *
36      * The function without name is the default function that is called whenever anyone sends funds to a contract
37      */
38     function () payable {
39         uint amount = msg.value;
40         balanceOf[msg.sender] += amount;
41         amountRaised += amount;
42         knuckReward.transfer(msg.sender, ((amount / price) * 1 ether));
43         FundTransfer(msg.sender, amount, true);
44         beneficiary.transfer(amount); 
45         FundTransfer(beneficiary, amount, false);
46             
47        
48 }
49     }