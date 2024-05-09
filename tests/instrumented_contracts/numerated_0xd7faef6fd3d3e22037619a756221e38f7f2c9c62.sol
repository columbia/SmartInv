1 pragma solidity ^0.4.20;
2 
3 contract CreateBlogger {
4     address [] public deployedBlogs;
5 
6     function createBlogger() public returns(address) {
7         address newBlogger = new Blogger(msg.sender);
8         deployedBlogs.push(newBlogger);
9         return newBlogger;
10     }
11 
12     function getDeployedBlogs() public view returns(address[]) {
13         return deployedBlogs;
14     }
15 }
16 
17 
18 contract Blogger {
19 
20     address public author;
21     uint public donationCount;
22     uint public withdrawalDate;
23 
24 
25     struct Donate {
26         address funder;
27         uint value;
28     }
29     mapping(address => bool) public didGive;
30     mapping(address => Donate) public donationRecords;
31 
32 
33     modifier restricted() {
34         require (msg.sender == author);
35         _;
36     }
37 
38     constructor (address sender) public {
39         author = sender;
40         donationCount = 0;
41         withdrawalDate = now + 30 days;
42     }
43 
44     function donate() public payable {
45         donationCount ++;
46         didGive[msg.sender] = true;
47 
48         Donate memory newDonation = Donate({
49             funder: msg.sender,
50             value: msg.value
51         });
52         donationRecords[msg.sender] = newDonation;
53 
54     }
55 
56     function requestRefund() public {
57         require(didGive[msg.sender]);
58         Donate storage record = donationRecords[msg.sender];
59 
60         require(record.funder == msg.sender);
61         record.funder.transfer(record.value);
62 
63         didGive[msg.sender] = false;
64         Donate memory clearRecords = Donate({
65             funder: 0,
66             value: 0
67         });
68         donationRecords[msg.sender] = clearRecords;
69     }
70 
71     function withdraw() public restricted {
72         require(withdrawalDate < now);
73 
74         author.transfer(address(this).balance);
75         withdrawalDate = now + 30 days;
76 
77     }
78 
79     function getContractValue() public view returns(uint) {
80         return address(this).balance;
81     }
82 
83     function getSummary() public view returns (address, uint, uint, uint) {
84         return (
85             author,
86             donationCount,
87             withdrawalDate,
88             address(this).balance
89             );
90     }
91 }