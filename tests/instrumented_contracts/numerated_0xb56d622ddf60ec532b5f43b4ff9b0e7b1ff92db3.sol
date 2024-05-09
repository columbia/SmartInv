1 pragma solidity 0.4.11;
2 
3 contract Fundraiser {
4 
5   /* State */
6 
7   address signer1;
8   address signer2;
9   bool public accept; // are contributions accepted
10 
11   enum Action {
12     None,
13     Withdraw,
14     Close,
15     Open
16   }
17   
18   struct Proposal {
19     Action action;
20     address destination;
21     uint256 amount;
22   }
23   
24   Proposal signer1_proposal;
25   Proposal signer2_proposal;
26 
27   /* Constructor, choose signers. Those cannot be changed */
28   function Fundraiser(address init_signer1,
29                       address init_signer2) {
30     accept = false; // must call Open first
31     signer1 = init_signer1;
32     signer2 = init_signer2;
33     signer1_proposal.action = Action.None;
34     signer2_proposal.action = Action.None;
35   }
36 
37   /* no default action, in case people forget to send their data
38      or in case they use a buggy app that forgets to send the data */
39   function () {
40     throw;
41   }
42 
43   /* Entry point for contributors */
44 
45   event Deposit (
46                  bytes20 tezos_pk_hash,
47                  uint amount
48                  );
49 
50   function Contribute(bytes24 tezos_pkh_and_chksum) payable {
51     // Don't accept contributions if fundraiser closed
52     if (!accept) { throw; }
53     bytes20 tezos_pk_hash = bytes20(tezos_pkh_and_chksum);
54     /* shift left 20 bytes to extract checksum */
55     bytes4 expected_chksum = bytes4(tezos_pkh_and_chksum << 160);
56     bytes4 chksum = bytes4(sha256(sha256(tezos_pk_hash)));
57     /* revert transaction if the checksum cannot be verified */
58     if (chksum != expected_chksum) { throw; }
59     Deposit(tezos_pk_hash, msg.value);
60   }
61 
62   /* Entry points for signers */
63 
64   function Withdraw(address proposed_destination,
65                     uint256 proposed_amount) {
66     /* check amount */
67     if (proposed_amount > this.balance) { throw; }
68     /* update action */
69     if (msg.sender == signer1) {
70       signer1_proposal.action = Action.Withdraw;
71       signer1_proposal.destination = proposed_destination;
72       signer1_proposal.amount = proposed_amount;
73     } else if (msg.sender == signer2) {
74       signer2_proposal.action = Action.Withdraw;
75       signer2_proposal.destination = proposed_destination;
76       signer2_proposal.amount = proposed_amount;
77     } else { throw; }
78     /* perform action */
79     MaybePerformWithdraw();
80   }
81 
82   function Close(address proposed_destination) {
83     /* update action */
84     if (msg.sender == signer1) {
85       signer1_proposal.action = Action.Close;
86       signer1_proposal.destination = proposed_destination;
87     } else if (msg.sender == signer2) {
88       signer2_proposal.action = Action.Close;
89       signer2_proposal.destination = proposed_destination;
90     } else { throw; }
91     /* perform action */
92     MaybePerformClose();
93   }
94 
95   function Open() {
96     /* update action */
97     if (msg.sender == signer1) {
98       signer1_proposal.action = Action.Open;
99     } else if (msg.sender == signer2) {
100       signer2_proposal.action = Action.Open;
101     } else { throw; }
102     /* perform action */
103     MaybePerformOpen();
104   }
105 
106   function MaybePerformWithdraw() internal {
107     if (signer1_proposal.action == Action.Withdraw
108         && signer2_proposal.action == Action.Withdraw
109         && signer1_proposal.amount == signer2_proposal.amount
110         && signer1_proposal.destination == signer2_proposal.destination) {
111       signer1_proposal.action = Action.None;
112       signer2_proposal.action = Action.None;
113       signer1_proposal.destination.transfer(signer1_proposal.amount);
114     }
115   }
116 
117   function MaybePerformClose() internal {
118     if (signer1_proposal.action == Action.Close
119         && signer2_proposal.action == Action.Close
120         && signer1_proposal.destination == signer2_proposal.destination) {
121       accept = false;
122       signer1_proposal.destination.transfer(this.balance);
123     }
124   }
125 
126   function MaybePerformOpen() internal {
127     if (signer1_proposal.action == Action.Open
128         && signer2_proposal.action == Action.Open) {
129       accept = true;
130     }
131   }
132 }