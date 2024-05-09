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
26 contract ZenswapDistribution_ZNTZLTU is Ownable {
27     
28     bool public isLive = true;
29     address public beneficiary;
30     uint256 public rateOfZNT = 500000;
31     uint256 public rateOfZLT = 3000;
32     uint256 public amountEthRaised = 0;
33     uint256 public availableZNT;
34     uint256 public availableZLT;
35     token public tokenZNT;
36     token public tokenZLT;
37     
38     mapping(address => uint256) public donationOf;
39     
40     constructor() public {
41         
42         beneficiary = msg.sender;
43     }
44 
45     // Callback function, distribute tokens to sender when ETH donation is recieved
46     function () payable public {
47         
48         require(isLive);
49         uint256 donation = msg.value;
50         uint256 amountZNT = donation * rateOfZNT;
51         uint256 amountZLT = donation * rateOfZLT;
52         require(availableZNT >= amountZNT && availableZLT >= amountZLT);
53         donationOf[msg.sender] += donation;
54         amountEthRaised += donation;
55         availableZNT -= amountZNT;
56         availableZLT -= amountZLT;
57         tokenZNT.transfer(msg.sender, amountZNT);
58         tokenZLT.transfer(msg.sender, amountZLT);
59         beneficiary.transfer(donation);
60     }
61     
62     // Halts or resumes the distribution process
63     function toggleIsLive() public onlyOwner {
64         if(isLive) {
65             isLive = false;
66         } else {
67             isLive = true;
68         }
69     }
70 
71     // Withdraw available token in this contract
72     function withdrawAvailableToken(address _address, uint256 amountZNT, uint256 amountZLT) public onlyOwner {
73         require(availableZNT >= amountZNT && availableZLT >= amountZLT);
74         availableZNT -= amountZNT;
75         availableZLT -= amountZLT;
76         tokenZNT.transfer(_address, amountZNT);
77         tokenZLT.transfer(_address, amountZLT);
78     }
79     
80     // Set token rate per ETH donation/contribution
81     function setTokensPerEth(uint256 rateZNT, uint256 rateZLT) public onlyOwner {
82         
83         rateOfZNT = rateZNT;
84         rateOfZLT = rateZLT;
85     }
86     
87     // Set token contract addresses of tokens involved in distribution
88     function setTokenReward(address _addressZNT, address _addressZLT) public onlyOwner {
89         
90         tokenZNT = token(_addressZNT);
91         tokenZLT = token(_addressZLT);
92         setAvailableToken();
93     }
94     
95     // Set the available token balance of this contract
96     function setAvailableToken() public onlyOwner {
97         
98         availableZNT = tokenZNT.balanceOf(this);
99         availableZLT = tokenZLT.balanceOf(this);
100     }
101     
102     // Set the available token balance of this contract manually
103     function setAvailableTokenManually(uint256 amountZNT, uint256 amountZLT) public onlyOwner {
104         
105         availableZNT = amountZNT;
106         availableZLT = amountZLT;
107     }
108     
109     // Set the new beneficiary address
110     function setNewBeneficiary(address _address) public onlyOwner {
111         
112         beneficiary = _address;
113     }
114     
115     // Withdraw ETH, this function can only be used just in case there is bug on ETH transfer / payable
116     function withEth(uint256 _amount) public onlyOwner {
117         
118         require(address(this).balance > 0);
119         beneficiary.transfer(_amount);
120     }
121 }