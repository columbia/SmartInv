1 contract BountyEscrow {
2 
3   address public admin;
4 
5   function BountyEscrow() {
6     admin = msg.sender;
7   }
8   
9   event Payout(
10     address indexed sender,
11     address indexed recipient,
12     uint256 indexed sequenceNum,
13     uint256 amount,
14     bool success
15   );
16 
17   // transfer deposits funds to recipients
18   // Gas used in each `send` will be default stipend, 2300
19   function payout(address[] recipients, uint256[] amounts) {
20     require(admin == msg.sender);
21     require(recipients.length == amounts.length);
22     for (uint i = 0; i < recipients.length; i++) {
23       Payout(
24         msg.sender,
25         recipients[i],
26         i + 1,
27         amounts[i],
28         recipients[i].send(amounts[i])
29       );
30     }
31   }
32 }