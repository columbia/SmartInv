1 pragma solidity 0.4.11;
2 
3 contract Fundraiser {
4 
5   /* State */
6 
7   address public signer1;
8   address public signer2;
9 
10   enum Action {
11     None,
12     Withdraw
13   }
14   
15   struct Proposal {
16     Action action;
17     address destination;
18     uint256 amount;
19   }
20   
21   Proposal public signer1_proposal;
22   Proposal public signer2_proposal;
23 
24   /* Constructor, choose signers. Those cannot be changed */
25   function Fundraiser(address init_signer1,
26                       address init_signer2) {
27     signer1 = init_signer1;
28     signer2 = init_signer2;
29     signer1_proposal.action = Action.None;
30     signer2_proposal.action = Action.None;
31   }
32 
33   /* allow simple send transactions */
34   function () payable {
35   }
36 
37   
38   /* Entry points for signers */
39 
40   function Withdraw(address proposed_destination,
41                     uint256 proposed_amount) {
42     /* check amount */
43     if (proposed_amount > this.balance) { throw; }
44     /* update action */
45     if (msg.sender == signer1) {
46       signer1_proposal.action = Action.Withdraw;
47       signer1_proposal.destination = proposed_destination;
48       signer1_proposal.amount = proposed_amount;
49     } else if (msg.sender == signer2) {
50       signer2_proposal.action = Action.Withdraw;
51       signer2_proposal.destination = proposed_destination;
52       signer2_proposal.amount = proposed_amount;
53     } else { throw; }
54     /* perform action */
55     MaybePerformWithdraw();
56   }
57 
58   function MaybePerformWithdraw() internal {
59     if (signer1_proposal.action == Action.Withdraw
60         && signer2_proposal.action == Action.Withdraw
61         && signer1_proposal.amount == signer2_proposal.amount
62         && signer1_proposal.destination == signer2_proposal.destination) {
63       signer1_proposal.action = Action.None;
64       signer2_proposal.action = Action.None;
65       signer1_proposal.destination.transfer(signer1_proposal.amount);
66     }
67   }
68 
69 }