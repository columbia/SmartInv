1 pragma solidity ^0.4.18;
2 
3 /**
4  * Manually audited pub registrar
5  *
6  * State Diagram:
7  * 
8  * UNCONTACTED -> APPLIED <-> REJECTED
9  *      |            |
10  *      v            v
11  *    BOARD       ACCEPTED
12  */
13 contract AllPubs {
14     // the application fee serves to incentivize the board to review applications quickly
15     uint256 constant public registrationBounty = 50 finney;
16     // the board receives less when it rejects candidates
17     uint256 constant public invalidationBounty = 5 finney;
18 
19     enum Membership {
20         UNCONTACTED, // default
21         REJECTED, // rejected applicant
22         APPLIED, // application
23         ACCEPTED, // accepted applicant
24         BOARD, // allowed to approve pubs
25         SOURCE // AllPubs creator
26     }
27 
28     mapping (address => Membership) public membership;
29     // please do not trust REJECTED abis
30     mapping (address => string) public abis;
31     address[] public pubs;
32 
33     function AllPubs()
34     public {
35         membership[msg.sender] = Membership.SOURCE;
36     }
37 
38     event PubRegistered(address location);
39 
40     event PubAccepted(address location);
41 
42     event PubRejected(address location, string reason);
43 
44     function pubCount()
45     public view
46     returns (uint256) {
47         return pubs.length;
48     }
49 
50 
51     function register(address _pubish, string _abi)
52     external payable {
53         assert(msg.value == registrationBounty);
54         assert(membership[_pubish] <= Membership.REJECTED);
55         membership[_pubish] = Membership.APPLIED;
56         abis[_pubish] = _abi;
57         PubRegistered(_pubish);
58     }
59 
60     function accept(address _pubish)
61     external {
62         assert(membership[msg.sender] >= Membership.BOARD);
63         assert(membership[_pubish] == Membership.APPLIED);
64         membership[_pubish] = Membership.ACCEPTED;
65         msg.sender.transfer(registrationBounty);
66         pubs.push(_pubish);
67         PubAccepted(_pubish);
68     }
69 
70     function reject(address _pubish, string _reason)
71     external {
72         assert(membership[msg.sender] >= Membership.BOARD);
73         assert(membership[_pubish] == Membership.APPLIED);
74         membership[_pubish] = Membership.REJECTED;
75         msg.sender.transfer(invalidationBounty);
76         PubRejected(_pubish, _reason);
77     }
78 
79     event NewBoardMember(address _boardMember);
80 
81     function appoint(address _delegate)
82     external {
83         assert(membership[msg.sender] >= Membership.BOARD);
84         assert(membership[_delegate] == Membership.UNCONTACTED);
85         membership[_delegate] = Membership.BOARD;
86         NewBoardMember(_delegate);
87     }
88 }