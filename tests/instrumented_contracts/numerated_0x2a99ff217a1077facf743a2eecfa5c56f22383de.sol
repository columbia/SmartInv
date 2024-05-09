1 pragma solidity ^0.4.16;
2 
3 interface token {
4     function transfer(address receiver, uint amount);
5 }
6 
7 contract Crowdsale {
8     uint public createdTimestamp; uint public start; uint public deadline;
9     address public beneficiary;
10     uint public amountRaised;
11     mapping(address => uint256) public balanceOf;
12     bool crowdsaleClosed = false;
13     event FundTransfer(address backer, uint amount, bool isContribution);
14     /**
15      * Constructor function
16      *
17      * Setup the owner
18      */
19     function Crowdsale(
20     ) {
21         createdTimestamp = block.timestamp;
22         start = 1526292000;//createdTimestamp + 0 * 1 days + 30 * 1 minutes;
23         deadline = 1529143200;//;createdTimestamp + 1 * 1 days + 0 * 1 minutes;
24         amountRaised=0;
25         beneficiary = 0xDfD0500541c6F14eb9eD2A6e61BB63bc78693925;
26     }
27     /**
28      * Fallback function
29      *
30      * The function without name is the default function that is called whenever anyone sends funds to a contract
31      */
32     function () payable {
33         require(block.timestamp >= start && block.timestamp <= deadline && amountRaised<(6000 ether) );
34 
35         uint amount = msg.value;
36         balanceOf[msg.sender] += amount;
37         amountRaised += amount;
38         FundTransfer(msg.sender, amount, true);
39         if (beneficiary.send(amount)) {
40             FundTransfer(beneficiary, amount, false);
41         }
42     }
43 
44 }