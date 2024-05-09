1 pragma solidity^0.4.17;
2 
3 contract BountyEscrow {
4 
5   address public admin;
6 
7   function BountyEscrow() public {
8     admin = msg.sender;
9   }
10   
11   event Payout(
12     address indexed sender,
13     address indexed recipient,
14     uint256 indexed sequenceNum,
15     uint256 amount,
16     bool success
17   );
18 
19   // transfer deposits funds to recipients
20   // Gas used in each `send` will be default stipend, 2300
21   function payout(address[] recipients, uint256[] amounts) public {
22     require(admin == msg.sender);
23     require(recipients.length == amounts.length);
24     for (uint i = 0; i < recipients.length; i++) {
25       Payout(
26         msg.sender,
27         recipients[i],
28         i + 1,
29         amounts[i],
30         recipients[i].send(amounts[i])
31       );
32     }
33   }
34   
35   function () public payable { }
36 }