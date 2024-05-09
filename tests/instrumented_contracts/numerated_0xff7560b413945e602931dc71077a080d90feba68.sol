1 pragma solidity ^0.4.18;
2 
3 interface token {
4     function transfer(address receiver, uint amount) public;
5 }
6 
7 contract Crowdsale {
8     address public owner;
9     uint public amountRaised;
10     uint public deadline;
11     uint public rateOfEther;
12     token public tokenReward;
13     mapping(address => uint256) public balanceOf;
14     bool crowdsaleClosed = false;
15 
16     event FundTransfer(address backer, uint amount, bool isContribution);
17 
18     /**
19      * Constrctor function
20      *
21      * Setup the owner
22      */
23     function Crowdsale(
24         uint durationInMinutes,
25         address addressOfTokenUsedAsReward
26     ) public {
27         owner = msg.sender;
28         deadline = now + durationInMinutes * 1 minutes;
29         rateOfEther = 42352;
30         tokenReward = token(addressOfTokenUsedAsReward);
31     }
32 
33 function setPrice(uint tokenRateOfEachEther) public {
34     if(msg.sender == owner) {
35       rateOfEther = tokenRateOfEachEther;
36     }
37 }
38 
39 function changeOwner (address newOwner) public {
40   if(msg.sender == owner) {
41     owner = newOwner;
42   }
43 }
44 
45 function changeCrowdsale(bool isClose) public {
46     if(msg.sender == owner) {
47         crowdsaleClosed = isClose;
48     }
49 }
50 
51 
52   function finishPresale(uint value) public {
53     if(msg.sender == owner) {
54         if(owner.send(value)) {
55             FundTransfer(owner, value, false);
56         }
57     }
58   }
59 
60     function buyToken() payable public {
61         require(!crowdsaleClosed);
62         require(now <= deadline);
63         uint amount = msg.value;
64         amountRaised += amount;
65         uint tokens = amount * rateOfEther;
66         balanceOf[msg.sender] += tokens;
67         tokenReward.transfer(msg.sender, tokens);
68         FundTransfer(msg.sender, tokens, true);
69     }
70     /**
71      * Fallback function
72      *
73      * The function without name is the default function that is called whenever anyone sends funds to a contract
74      */
75     function () payable public {
76         buyToken();
77     }
78 }