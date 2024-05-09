1 pragma solidity ^0.4.18;
2 
3 interface token {
4     function transfer(address receiver, uint amount) public;
5 }
6 
7 contract Crowdsale {
8     address public owner;
9     uint public tokenRaised;
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
50     /**
51      * Fallback function
52      *
53      * The function without name is the default function that is called whenever anyone sends funds to a contract
54      */
55     function () payable public {
56         require(!crowdsaleClosed);
57         require(now <= deadline);
58         uint amount = msg.value;
59         uint tokens = amount * rateOfEther;
60         require((tokenRaised + tokens) <= 100000000 * 1 ether);
61         balanceOf[msg.sender] += tokens;
62         tokenRaised += tokens;
63         tokenReward.transfer(msg.sender, tokens);
64         FundTransfer(msg.sender, tokens, true);
65         if(owner.send(amount)) {
66             FundTransfer(owner, amount, false);
67         }
68     }
69 }