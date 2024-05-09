1 pragma solidity ^0.4.24;
2 // Spielley's King of the crypto hill beta Coallition expansion v1.01
3 // Coallition owner sets shares for the alliance, alliance members send in their eth winnings to share among the group
4 // Coallition owner can increase or decrease members and shares
5 // this is not a trustless situation, alliance owner can screw everyone over, only join an alliance you trust
6 
7 // play at https://kotch.dvx.me/# 
8 // 28/08/2018
9 
10 // ----------------------------------------------------------------------------
11 // Safe maths
12 // ----------------------------------------------------------------------------
13 library SafeMath {
14     function add(uint a, uint b) internal pure returns (uint c) {
15         c = a + b;
16         require(c >= a);
17     }
18     function sub(uint a, uint b) internal pure returns (uint c) {
19         require(b <= a);
20         c = a - b;
21     }
22     function mul(uint a, uint b) internal pure returns (uint c) {
23         c = a * b;
24         require(a == 0 || c / a == b);
25     }
26     function div(uint a, uint b) internal pure returns (uint c) {
27         require(b > 0);
28         c = a / b;
29     }
30 }
31 // ----------------------------------------------------------------------------
32 // Owned contract
33 // ----------------------------------------------------------------------------
34 contract Owned {
35     address public owner;
36     address public newOwner;
37 
38     event OwnershipTransferred(address indexed _from, address indexed _to);
39 
40     constructor() public {
41         owner = msg.sender;
42     }
43 
44     modifier onlyOwner {
45         require(msg.sender == owner);
46         _;
47     }
48 
49     function transferOwnership(address _newOwner) public onlyOwner {
50         newOwner = _newOwner;
51     }
52     function acceptOwnership() public {
53         require(msg.sender == newOwner);
54         emit OwnershipTransferred(owner, newOwner);
55         owner = newOwner;
56         newOwner = address(0);
57     }
58 }
59 contract Coallition is Owned {
60      using SafeMath for uint;
61      
62      mapping(uint256 => address) public members;
63      mapping(address => uint256) public shares;
64      
65      uint256 public total;
66      constructor () public {
67          
68     }
69      function addmember(uint256 index , address newmember) public onlyOwner  {
70    members[index] = newmember;
71 }
72      function addshares(uint256 sharestoadd , address member) public onlyOwner  {
73 shares[member] += sharestoadd;
74 }
75 function deductshares(uint256 sharestoadd , address member) public onlyOwner  {
76    shares[member] -= sharestoadd;
77 }
78 function setshares(uint256 sharestoadd , address member) public onlyOwner  {
79    shares[member] = sharestoadd;
80 }
81 // set total number of members
82 function settotal(uint256 set) public onlyOwner  {
83    total = set;
84 }
85     function payout() public payable {
86         
87    for(uint i=0; i< total; i++)
88         {
89             uint256 totalshares;
90             totalshares += shares[members[i]];
91         }
92         uint256 base = msg.value.div(totalshares);
93     for(i=0; i< total; i++)
94         {
95             
96             uint256 amounttotransfer = base.mul(shares[members[i]]);
97             members[i].transfer(amounttotransfer);
98             
99         }
100 }
101 function collectdustatcontract() public payable {
102         
103    for(uint i=0; i< total; i++)
104         {
105             uint256 totalshares;
106             totalshares += shares[members[i]];
107         }
108        
109         uint256 base = address(this).balance.div(totalshares);
110     for(i=0; i< total; i++)
111         {
112             
113             uint256 amounttotransfer = base.mul(shares[members[i]]);
114             members[i].transfer(amounttotransfer);
115             
116         }
117 }
118  function () external payable{payout();}     
119 }