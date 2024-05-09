1 contract BountyEscrow {
2 
3   address public admin;
4 
5   function BountyEscrow() {
6     admin = msg.sender;
7   }
8 
9   event Bounty(
10     address indexed sender,
11     uint256 amount
12   );
13 
14   event Payout(
15     address indexed sender,
16     address indexed recipient,
17     uint256 indexed sequenceNum,
18     uint256 amount,
19     bool success
20   );
21 
22   // transfer deposits funds to recipients
23   // Gas used in each `send` will be default stipend, 2300
24   function payout(address[] recipients, uint256[] amounts) {
25     require(recipients.length == amounts.length);
26     for (uint i = 0; i < recipients.length; i++) {
27       Payout(
28         msg.sender,
29         recipients[i],
30         i + 1,
31         amounts[i],
32         recipients[i].send(amounts[i])
33       );
34     }
35   }
36 
37   // Use default `send` to receive bounty deposits.
38   // Add a log to the tx receipt so we can track.
39   function () payable {
40     Bounty(msg.sender, msg.value);
41   }
42 }