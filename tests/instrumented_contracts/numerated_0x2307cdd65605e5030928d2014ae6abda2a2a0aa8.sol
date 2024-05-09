1 pragma solidity ^0.4.11;
2 
3 /// @title Splitter
4 /// @author 0xcaff (Martin Charles)
5 /// @notice An ethereum smart contract to split received funds between a number
6 /// of outputs.
7 contract Splitter {
8     // Mapping between addresses and how much money they have withdrawn. This is
9     // used to calculate the balance of each account. The public keyword allows
10     // reading from the map but not writing to the map using the
11     // amountsWithdrew(address) method of the contract. It's public mainly for
12     // testing.
13     mapping(address => uint) public amountsWithdrew;
14 
15     // A set of parties to split the funds between. They are initialized in the
16     // constructor.
17     mapping(address => bool) public between;
18 
19     // The number of ways incoming funds will we split.
20     uint public count;
21 
22     // The total amount of funds which has been deposited into the contract.
23     uint public totalInput;
24 
25     // This is the constructor of the contract. It is called at deploy time.
26 
27     /// @param addrs The address received funds will be split between.
28     function Splitter(address[] addrs) {
29         count = addrs.length;
30 
31         for (uint i = 0; i < addrs.length; i++) {
32             // loop over addrs and update set of included accounts
33             address included = addrs[i];
34             between[included] = true;
35         }
36     }
37 
38     // To save on transaction fees, it's beneficial to withdraw in one big
39     // transaction instead of many little ones. That's why a withdrawl flow is
40     // being used.
41 
42     /// @notice Withdraws from the sender's share of funds and deposits into the
43     /// sender's account. If there are insufficient funds in the contract, or
44     /// more than the share is being withdrawn, throws, canceling the
45     /// transaction.
46     /// @param amount The amount of funds in wei to withdraw from the contract.
47     function withdraw(uint amount) {
48         Splitter.withdrawInternal(amount, false);
49     }
50 
51     /// @notice Withdraws all funds available to the sender and deposits them
52     /// into the sender's account.
53     function withdrawAll() {
54         Splitter.withdrawInternal(0, true);
55     }
56 
57     // Since `withdrawInternal` is internal, it isn't in the ABI and can't be
58     // called from outside of the contract.
59 
60     /// @notice Checks whether the sender is allowed to withdraw and has
61     /// sufficient funds, then withdraws.
62     /// @param requested The amount of funds in wei to withdraw from the
63     /// contract. If the `all` parameter is true, the `amount` parameter is
64     /// ignored. If funds are insufficient, throws.
65     /// @param all If true, withdraws all funds the sender has access to from
66     /// this contract.
67     function withdrawInternal(uint requested, bool all) internal {
68         // Require the withdrawer to be included in `between` at contract
69         // creation time.
70         require(between[msg.sender]);
71 
72         // Decide the amount to withdraw based on the `all` parameter.
73         uint available = Splitter.balance();
74         uint transferring = 0;
75 
76         if (all) { transferring = available; }
77         else { available = requested; }
78 
79         // Ensures the funds are available to make the transfer, otherwise
80         // throws.
81         require(transferring <= available);
82 
83         // Updates the internal state, this is done before the transfer to
84         // prevent re-entrancy bugs.
85         amountsWithdrew[msg.sender] += transferring;
86 
87         // Transfer funds from the contract to the sender. The gas for this
88         // transaction is paid for by msg.sender.
89         msg.sender.transfer(transferring);
90     }
91 
92     // We do integer division (floor(a / b)) when calculating each share, because
93     // solidity doesn't have a decimal number type. This means there will be a
94     // maximum remainder of count - 1 wei locked in the contract. We ignore this
95     // because it is such a small amount of ethereum (1 Wei = 10^(-18)
96     // Ethereum). The extra Wei can be extracted by depositing an amount to make
97     // totalInput evenly divisable between count parties.
98 
99     /// @notice Gets the amount of funds in Wei available to the sender.
100     function balance() constant returns (uint) {
101         if (!between[msg.sender]) {
102             // The sender of the message isn't part of the split. Ignore them.
103             return 0;
104         }
105 
106         // `share` is the amount of funds which are available to each of the
107         // accounts specified in the constructor.
108         uint share = totalInput / count;
109         uint withdrew = amountsWithdrew[msg.sender];
110         uint available = share - withdrew;
111 
112         assert(available >= 0 && available <= share);
113 
114         return available;
115     }
116 
117     // This function will be run when a transaction is sent to the contract
118     // without any data. It is minimal to save on gas costs.
119     function() payable {
120         totalInput += msg.value;
121     }
122 }