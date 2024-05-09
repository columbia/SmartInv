1 pragma solidity ^0.4.16;
2 
3 interface token {
4     function transfer(address receiver, uint amount) public;
5 }
6 
7 contract Crowdsale {
8     address public beneficiary;
9     uint public amountRaised;
10     uint public price;
11     bool crowdsaleClosed = false;
12     token public tokenReward;
13     mapping(address => uint256) public balanceOf;
14 
15     event FundTransfer(address backer, uint amount, bool isContribution);
16 
17     /**
18      * Constrctor function
19      *
20      * Setup the owner
21      */
22     function Crowdsale () public {
23         beneficiary = 0x1e19E36928bA65184669d8A7e7A37d8B061B9022;
24         price = 0.00058 * 1 ether;
25         tokenReward = token(0xe8EF8d9d9Ff515720A62d2E2f14f3b5b677C6670);
26     }
27 
28     /**
29      * Fallback function
30      *
31      * The function without name is the default function that is called whenever anyone sends funds to a contract
32      */
33     function () public payable {
34         require(!crowdsaleClosed);
35         uint amount = msg.value;
36         balanceOf[msg.sender] += amount;
37         amountRaised += amount;
38         tokenReward.transfer(msg.sender, (amount  * 1 ether) / price);
39         FundTransfer(msg.sender, amount, true);
40     }
41     
42     function changePrice(uint newprice) public {
43          if (beneficiary == msg.sender) {
44              price = newprice * 1 ether;
45          }
46     }
47 
48     function safeWithdrawal() public {
49 
50         if (beneficiary == msg.sender) {
51             if (beneficiary.send(amountRaised)) {
52                 FundTransfer(beneficiary, amountRaised, false);
53             } else {
54 
55             }
56         }
57     }
58     
59     function safeTokenWithdrawal(uint amount) public {
60          if (beneficiary == msg.sender) {
61              tokenReward.transfer(msg.sender, amount);
62         }
63     }
64     
65      function crowdsaleStop() public {
66          if (beneficiary == msg.sender) {
67             crowdsaleClosed = true;
68         }
69     }
70     
71     function crowdsaleStart() public {
72          if (beneficiary == msg.sender) {
73             crowdsaleClosed = false;
74         }
75     }
76 }