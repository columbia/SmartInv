1 pragma solidity ^0.4.25;
2 
3 contract GitmanIssue {
4 
5     address private mediator;
6     address public parent; // deposit contract
7     string public owner;
8     string public repository;
9     string public issue;
10 
11     constructor (string ownerId, string repositoryId, string issueId, address mediatorAddress) public payable { 
12         parent = msg.sender;
13         mediator = mediatorAddress;
14         owner = ownerId;
15         repository = repositoryId;
16         issue = issueId;
17     }
18 
19     function resolve(address developerAddress) public {
20         require (msg.sender == mediator, "sender not authorized");
21         selfdestruct(developerAddress);
22     }
23 
24     function recall() public {
25         require (msg.sender == mediator, "sender not authorized");
26         selfdestruct(parent);
27     }
28 }
29 
30 contract GitmanFactory {
31     
32     address private mediator;
33     uint16 public share = 5;
34 
35     event IssueCreated(address contractAddress, string issue);
36 
37     constructor () public {     //address ownerAddress, 
38         mediator = msg.sender;
39     }
40 
41     function setShare(uint8 value) public {
42         require(value > 0 && value <= 100, "share must be between 1 and 100");
43         require (msg.sender == mediator, "sender not authorized");
44         share = value;
45     }
46 
47     function createIssue(string user, string repository, string issue) public payable { // returns (address)
48         require(msg.value > 0, "reward must be greater than 0");
49 
50         uint fee = msg.value / share;
51         uint reward = msg.value - fee;
52         mediator.transfer(fee);
53         
54         address issueContract = (new GitmanIssue).value(reward)(user, repository, issue, mediator);
55         emit IssueCreated(issueContract, issue);
56     }
57 }