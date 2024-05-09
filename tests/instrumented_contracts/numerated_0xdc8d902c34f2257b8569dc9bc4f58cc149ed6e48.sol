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
33     uint16 public share = 10;
34 
35     event IssueCreated(address contractAddress, string issue);
36 
37     constructor () public {     //address ownerAddress, 
38         mediator = msg.sender;
39     }
40 
41     function setShare(uint8 value) public {
42         require(value > 0 && value <= 100, "share must be between 1 and 100");
43         share = value;
44     }
45 
46     function createIssue(string user, string repository, string issue) public payable { // returns (address)
47         require(msg.value > 0, "reward must be greater than 0");
48 
49         uint cut = msg.value / share;
50         uint reward = msg.value - cut;
51         mediator.transfer(cut);
52         
53         address issueContract = (new GitmanIssue).value(reward)(user, repository, issue, mediator);
54         emit IssueCreated(issueContract, issue);
55     }
56 }