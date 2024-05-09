1 pragma solidity 0.4.24;
2 
3 contract Token {
4     function transfer(address receiver, uint amount) public;
5     function balanceOf(address _address) public returns(uint);
6 }
7 
8 contract Crowdsale {
9 
10     address public beneficiary;
11     uint public amountRaised;
12     uint public startTime;
13     uint public endTime;
14     uint public price;
15     Token public tokenReward;
16     address public owner;
17 
18     event FundTransfer(address backer, uint amount, bool isContribution);
19 
20     /**
21      * Constrctor function
22      *
23      * Setup the owner
24      */
25     function Crowdsale() public {
26         beneficiary = address(0x02063eFBC5653989BdDeddaCD3949260aC451ee2);
27         startTime = 1530403200;
28         endTime = 1533081599;
29         price = 5000;
30         tokenReward = Token(0xa5982ff8a26818d6a78a0bc49f080d4a96dd0491);
31     }
32 
33 
34 
35     function isActive() constant returns (bool) {
36 
37         return (
38             now >= startTime && // Must be after the START date
39             now <= endTime // Must be before the end date
40             
41             );
42     }
43 
44 
45     /**
46      * Fallback function
47      *
48      * The function without name is the default function that is called whenever anyone sends funds to a contract
49      */
50     function () public payable {
51         require(isActive());
52         uint amount = msg.value;
53         amountRaised += amount;
54         uint TokenAmount = uint((msg.value/(10 ** 10)) * price);
55         tokenReward.transfer(msg.sender, TokenAmount);
56         beneficiary.transfer(msg.value);
57         FundTransfer(msg.sender, amount, true);
58     }
59 
60     function finish() public {
61         require(now > endTime);
62         uint balance = tokenReward.balanceOf(address(this));
63         if(balance > 0){
64             tokenReward.transfer(address(0x02063eFBC5653989BdDeddaCD3949260aC451ee2), balance);
65         }
66     }
67 
68 }