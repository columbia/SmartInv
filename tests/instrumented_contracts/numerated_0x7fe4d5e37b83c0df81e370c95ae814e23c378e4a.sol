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
33   /* Entry points for signers */
34 
35   function Withdraw(address proposed_destination,
36                     uint256 proposed_amount) {
37     /* check amount */
38     if (proposed_amount > this.balance) { throw; }
39     /* update action */
40     if (msg.sender == signer1) {
41       signer1_proposal.action = Action.Withdraw;
42       signer1_proposal.destination = proposed_destination;
43       signer1_proposal.amount = proposed_amount;
44     } else if (msg.sender == signer2) {
45       signer2_proposal.action = Action.Withdraw;
46       signer2_proposal.destination = proposed_destination;
47       signer2_proposal.amount = proposed_amount;
48     } else { throw; }
49     /* perform action */
50     MaybePerformWithdraw();
51   }
52 
53   function MaybePerformWithdraw() internal {
54     if (signer1_proposal.action == Action.Withdraw
55         && signer2_proposal.action == Action.Withdraw
56         && signer1_proposal.amount == signer2_proposal.amount
57         && signer1_proposal.destination == signer2_proposal.destination) {
58       signer1_proposal.action = Action.None;
59       signer2_proposal.action = Action.None;
60       signer1_proposal.destination.transfer(signer1_proposal.amount);
61     }
62   }
63 
64 }