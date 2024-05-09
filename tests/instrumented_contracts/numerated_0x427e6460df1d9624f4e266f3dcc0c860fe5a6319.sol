1 pragma solidity ^0.4.15;
2 
3 /*
4 author : dungeon_master
5 */
6 
7 contract Bounty {
8     // Track if the bounty has been already paid.
9     bool public bounty_paid = false;
10     // Track the total number of donors.
11     uint256 public count_donors = 0;
12     // Stores the amount given by every donor.
13     mapping (address => uint256) public balances;
14     // Stores the donor status.
15     mapping (address => bool) public has_donated;
16     // Stores the voting state.
17     mapping (address => bool) public has_voted;
18 
19     address public proposed_beneficiary = 0x0;
20     uint256 public votes_for = 0;
21     uint256 public votes_against = 0;
22 
23     bytes32 hash_pwd = 0x1a78e83f94c1bc28c54cfed1fe337e04c31732614ec822978d804283ef6a60c3;
24 
25     modifier onlyDonor {
26         require(!bounty_paid);
27         require(has_donated[msg.sender]);
28         // The rest of the function is inserted where the _; is.
29         _;
30     }
31 
32 
33     // Paying the tipper.
34     function payout(string _password) {
35         require(keccak256(_password) == hash_pwd);
36         require(!bounty_paid);
37         require(proposed_beneficiary != 0x0);
38         // To change, maybe. Find a way to use a ratio.
39         require(votes_for > votes_against);
40         // Minimum of 80% of the donors must have voted.
41         require(votes_for+votes_against > count_donors*8/10);
42         bounty_paid = true;
43         proposed_beneficiary.transfer(this.balance);
44 
45     }
46 
47     function propose_beneficiary(address _proposed) onlyDonor {
48         // Updates the proposed_beneficiary variable.
49         proposed_beneficiary = _proposed;
50         // Resets the voting counts.
51         votes_for = 0;
52         votes_against = 0;
53 
54     }
55 
56     // Allow to vote for the proposed_beneficiary by passing "yes" or "no" in the function.
57     // Any other string won't be counted.
58     function vote_beneficiary(string _vote) onlyDonor {
59         require(!has_voted[msg.sender]);
60         require(proposed_beneficiary != 0x0);
61         if (keccak256(_vote) == keccak256("yes")) {
62             votes_for += 1;
63             has_voted[msg.sender] = true;
64         }
65         if (keccak256(_vote) == keccak256("no")) {
66             votes_against += 1;
67             has_voted[msg.sender] = true;
68         }
69     }
70 
71     // Allow donors to withdraw their donations.
72     function refund() onlyDonor {
73         // Calling a refund withdraws you from the voters
74         has_donated[msg.sender] = false;
75         count_donors -= 1;
76 
77         // Store the user's balance prior to withdrawal in a temporary variable.
78         uint256 eth_to_withdraw = balances[msg.sender];
79         
80         // Update the user's balance prior to sending ETH to prevent recursive call.
81         balances[msg.sender] = 0;
82         
83         // Return the user's funds.  Throws on failure to prevent loss of funds.
84         msg.sender.transfer(eth_to_withdraw);
85     }
86 
87     // Default function. Called whenever someone sent ETH to the contract.
88     function () payable {
89         // Disallow sending if the bounty is already paid.
90         require(!bounty_paid);
91         // Maximum 50 donors are allowed.
92         require(count_donors < 51);
93         // Minimum donation to avoid trolls.
94         require(msg.value >= 0.1 ether);
95         //If you haven't donated before, you are added and counted as a new donor.
96         if (!has_donated[msg.sender]) {
97             has_donated[msg.sender] = true;
98             count_donors += 1;
99         } 
100         balances[msg.sender] += msg.value;
101     }
102 }