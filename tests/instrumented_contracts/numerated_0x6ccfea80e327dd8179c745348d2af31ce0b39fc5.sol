1 pragma solidity ^0.4.16;
2 
3 interface token {
4     function transfer(address receiver, uint amount) public;
5 }
6 
7 contract Crowdsale {
8     address public beneficiary;
9     uint public price;
10     bool crowdsaleClosed = false;
11     token public tokenReward;
12     mapping(address => uint256) public balanceOf;
13 
14     event FundTransfer(address backer, uint amount, bool isContribution);
15 
16     /**
17      * Constrctor function
18      *
19      * Setup the owner
20      */
21     function Crowdsale () public {
22         beneficiary = 0x1e19E36928bA65184669d8A7e7A37d8B061B9022;
23         price = 0.00058 * 1 ether;
24         tokenReward = token(0xe8EF8d9d9Ff515720A62d2E2f14f3b5b677C6670);
25     }
26 
27     /**
28      * Fallback function
29      *
30      * The function without name is the default function that is called whenever anyone sends funds to a contract
31      */
32     function () public payable {
33         require(!crowdsaleClosed);
34         uint amount = msg.value;
35         balanceOf[msg.sender] += amount;
36         tokenReward.transfer(msg.sender, (amount  * 1 ether) / price);
37         FundTransfer(msg.sender, amount, true);
38     }
39     
40     function changePrice(uint newprice) public {
41          if (beneficiary == msg.sender) {
42              price = newprice;
43          }
44     }
45 
46     function safeWithdrawal(uint amount) public {
47 
48         if (beneficiary == msg.sender) {
49             if (beneficiary.send(amount)) {
50                 FundTransfer(beneficiary, amount, false);
51             }
52         }
53     }
54     
55     function safeTokenWithdrawal(uint amount) public {
56          if (beneficiary == msg.sender) {
57              tokenReward.transfer(msg.sender, amount);
58         }
59     }
60     
61      function crowdsaleStop() public {
62          if (beneficiary == msg.sender) {
63             crowdsaleClosed = true;
64         }
65     }
66     
67     function crowdsaleStart() public {
68          if (beneficiary == msg.sender) {
69             crowdsaleClosed = false;
70         }
71     }
72 }