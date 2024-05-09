1 pragma solidity ^0.4.24;
2 
3 contract CrowdsaleRC {
4     uint public createdTimestamp; uint public start; uint public deadline;
5     address public owner;
6     address public beneficiary;
7     uint public amountRaised;
8     uint public maxAmount;
9     mapping(address => uint256) public balanceOf;
10     mapping (address => bool) public whitelist;
11     event FundTransfer(address backer, uint amount, bool isContribution);
12 
13     function CrowdsaleRC () public {
14         createdTimestamp = block.timestamp;
15         start = 1532080800;
16         deadline = 1538301600;
17         amountRaised = 0;
18         beneficiary = 0x72B98e23422e58EAA1268d33eAe68089eBE74567;
19         owner = msg.sender;
20         maxAmount = 20000 ether;
21     }
22 
23     function () payable public {
24         require( (msg.value >= 0.1 ether) &&  block.timestamp >= start && block.timestamp <= deadline && amountRaised < maxAmount
25         && ( (msg.value <= 100 ether) || (msg.value > 100 ether && whitelist[msg.sender]==true) )
26         );
27 
28         uint amount = msg.value;
29         balanceOf[msg.sender] += amount;
30         amountRaised += amount;
31         FundTransfer(msg.sender, amount, true);
32         if (beneficiary.send(amount)) {
33             FundTransfer(beneficiary, amount, false);
34         }
35     }
36 
37     function whitelistAddress (address uaddress) public {
38         require (owner == msg.sender || beneficiary == msg.sender);
39         whitelist[uaddress] = true;
40     }
41 
42     function removeAddressFromWhitelist (address uaddress) public {
43         require (owner == msg.sender || beneficiary == msg.sender);
44         whitelist[uaddress] = false;
45     }
46 }