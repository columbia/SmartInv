1 pragma solidity ^0.4.24;
2 
3 interface token {
4     function transfer(address receiver, uint256 amount) external;
5     function balanceOf(address _address) external returns(uint256);
6 }
7 
8 contract Ownable {
9 
10     address public owner;
11 
12     constructor() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner() {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     function transferOwnership(address newOwner) public onlyOwner {
22         owner = newOwner;
23     }
24 }
25 
26 contract ZNTZLTDistributionTest is Ownable {
27     
28     bool public isLive = true;
29     string public name = "ZNT-ZLT Distribution Test";
30     address public beneficiary;
31     uint256 public rateOfZNT = 500000;
32     uint256 public rateOfZLT = 3000;
33     uint256 public amountEthRaised = 0;
34     uint256 public availableZNT;
35     uint256 public availableZLT;
36     token public tokenZNT;
37     token public tokenZLT;
38     
39     mapping(address => uint256) public donationOf;
40     
41     constructor() public {
42         
43         beneficiary = msg.sender;
44     }
45 
46     // Callback function, distribute tokens to sender when ETH donation is recieved
47     function () payable public {
48         
49         require(isLive);
50         uint256 donation = msg.value;
51         uint256 amountZNT = donation * rateOfZNT;
52         uint256 amountZLT = donation * rateOfZLT;
53         require(availableZNT >= amountZNT && availableZLT >= amountZLT);
54         donationOf[msg.sender] += donation;
55         amountEthRaised += donation;
56         availableZNT -= amountZNT;
57         availableZLT -= amountZLT;
58         tokenZNT.transfer(msg.sender, amountZNT);
59         tokenZLT.transfer(msg.sender, amountZLT);
60         beneficiary.transfer(donation);
61     }
62     
63     // Halts or resumes the distribution process
64     function toggleIsLive() public onlyOwner {
65         if(isLive) {
66             isLive = false;
67         } else {
68             isLive = true;
69         }
70     }
71     
72 
73     // Withdraw available token in this contract
74     function withdrawAvailableToken(address _address, uint256 amountZNT, uint256 amountZLT) public onlyOwner {
75         require(availableZNT >= amountZNT && availableZLT >= amountZLT);
76         availableZNT -= amountZNT;
77         availableZLT -= amountZLT;
78         tokenZNT.transfer(_address, amountZNT);
79         tokenZLT.transfer(_address, amountZLT);
80     }
81     
82     // Set token rate per ETH donation/contribution
83     function setTokensPerEth(uint256 rateZNT, uint256 rateZLT) public onlyOwner {
84         
85         rateOfZNT = rateZNT;
86         rateOfZLT = rateZLT;
87     }
88     
89     // Set token contract addresses of tokens involved in distribution
90     function setTokenReward(address _addressZNT, address _addressZLT) public onlyOwner {
91         
92         tokenZNT = token(_addressZNT);
93         tokenZLT = token(_addressZLT);
94         setAvailableToken();
95     }
96     
97     // Set the available token balance of this contract
98     function setAvailableToken() public onlyOwner {
99         
100         availableZNT = tokenZNT.balanceOf(this);
101         availableZLT = tokenZLT.balanceOf(this);
102     }
103     
104     // Set the available token balance of this contract manually
105     function setAvailableTokenManually(uint256 amountZNT, uint256 amountZLT) public onlyOwner {
106         
107         availableZNT = amountZNT;
108         availableZLT = amountZLT;
109     }
110 }