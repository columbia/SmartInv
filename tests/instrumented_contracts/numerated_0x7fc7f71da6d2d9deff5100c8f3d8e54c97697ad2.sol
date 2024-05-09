1 pragma solidity ^0.4.24;
2 
3 // Delegate voting power for stake based voting and governance.
4 // Enables safe in-app voting participation, by letting users
5 // delegate their cold wallet VP to a convenient hot wallet.
6 contract VotingPowerDelegator {
7     // delegator => beneficiary
8     mapping (address => address) public delegations;
9     mapping (address => uint)    public delegatedAt;
10     event Delegated(address delegator, address beneficiary);
11 
12     constructor() public { }
13 
14     function delegate(address beneficiary) public {
15         if (beneficiary == msg.sender) {
16             beneficiary = 0;
17         }
18         delegations[msg.sender] = beneficiary;
19         delegatedAt[msg.sender] = now;
20         emit Delegated(msg.sender, beneficiary);
21     }
22 
23     function () public payable {
24         revert();
25     }
26 }