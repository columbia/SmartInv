1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         require((c = a - b) <= a);
7     }
8     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
9         require((c = a + b) >= a);
10     }
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         require((b == 0 || (c = a * b) / b == a));
13     }
14     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         c = a / b;
16     }
17 }
18 
19 interface Token {
20     function mintTokens(address _recipient, uint _value) external returns(bool success);
21     function balanceOf(address _holder) public returns(uint256 tokens);
22     function totalSupply() public returns(uint256 _totalSupply);
23 }
24 
25 contract Presale {
26     using SafeMath for uint256;
27     
28     Token public tokenContract;
29 
30     address public beneficiaryAddress;
31     uint256 public tokensPerEther;
32     uint256 public minimumContribution;
33     uint256 public startTime;
34     uint256 public endTime;
35     uint256 public hardcapInEther;
36     uint256 public fundsRaised;
37     
38 
39     mapping (address => uint256) public contributionBy;
40     
41     event ContributionReceived(address contributer, uint256 amount, uint256 totalContributions,uint totalAmountRaised);
42     event FundsWithdrawn(uint256 funds, address beneficiaryAddress);
43 
44     function Presale(
45         address _beneficiaryAddress,
46         uint256 _tokensPerEther,
47         uint256 _minimumContributionInFinney,
48         uint256 _startTime,
49         uint256 _saleLengthinHours,
50         address _tokenContractAddress,
51         uint256 _hardcapInEther) {
52         startTime = _startTime;
53         endTime = startTime + (_saleLengthinHours * 1 hours);
54         beneficiaryAddress = _beneficiaryAddress;
55         tokensPerEther = _tokensPerEther;
56         minimumContribution = _minimumContributionInFinney * 1 finney;
57         tokenContract = Token(_tokenContractAddress);
58         hardcapInEther = _hardcapInEther * 1 ether;
59     }
60 
61     function () public payable {
62         require(presaleOpen());
63         require(msg.value >= minimumContribution);
64         uint256 contribution = msg.value;
65         uint256 refund;
66         if(this.balance > hardcapInEther){
67             refund = this.balance.sub(hardcapInEther);
68             contribution = msg.value.sub(refund);
69             msg.sender.transfer(refund);
70         }
71         fundsRaised = fundsRaised.add(contribution);
72         contributionBy[msg.sender] = contributionBy[msg.sender].add(contribution);
73         tokenContract.mintTokens(msg.sender, contribution.mul(tokensPerEther));
74         ContributionReceived(msg.sender, contribution, contributionBy[msg.sender], this.balance);
75     }
76 
77 
78     function presaleOpen() public view returns(bool) {return(now >= startTime &&
79                                                             now <= endTime &&
80                                                             fundsRaised < hardcapInEther);} 
81 
82     function withdrawFunds() public {
83         require(this.balance > 0);
84         beneficiaryAddress.transfer(this.balance);
85         FundsWithdrawn(this.balance, beneficiaryAddress);
86     }
87 }