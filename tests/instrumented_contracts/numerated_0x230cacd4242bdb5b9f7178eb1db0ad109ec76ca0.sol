1 contract BountyEscrow {
2 
3   address public admin;
4 
5   function BountyEscrow() {
6     admin = msg.sender;
7   }
8 
9 
10   event Bounty(
11     address indexed sender,
12     uint256 amount
13   );
14 
15   event Payout(
16     address indexed sender,
17     address indexed recipient,
18     uint256 indexed sequenceNum,
19     uint256 amount,
20     bool success
21   );
22 
23   // transfer deposits funds to recipients
24   // Gas used in each `send` will be default stipend, 2300
25   function payout(address[] recipients, uint256[] amounts) {
26     require(admin == msg.sender);
27     require(recipients.length == amounts.length);
28     for (uint i = 0; i < recipients.length; i++) {
29       Payout(
30         msg.sender,
31         recipients[i],
32         i + 1,
33         amounts[i],
34         recipients[i].send(amounts[i])
35       );
36     }
37   }
38 
39   // Use default `send` to receive bounty deposits.
40   // Add a log to the tx receipt so we can track.
41   function () payable {
42     Bounty(msg.sender, msg.value);
43   }
44 }