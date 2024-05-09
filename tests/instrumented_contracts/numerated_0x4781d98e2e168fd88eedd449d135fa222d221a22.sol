1 pragma solidity ^0.4.21;
2 
3 interface token {
4   function transfer(address receiver, uint amount) external;
5 }
6 
7 library SafeMath {
8 
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a / b;
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 contract Ownable {
36   address public owner;
37 
38   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40   function Ownable() public {
41     owner = msg.sender;
42   }
43 
44   modifier onlyOwner() {
45     require(msg.sender == owner);
46     _;
47   }
48 
49   function transferOwnership(address newOwner) public onlyOwner {
50     require(newOwner != address(0));
51     emit OwnershipTransferred(owner, newOwner);
52     owner = newOwner;
53   }
54 
55 }
56 
57 contract KeplerTokenCrowdsale is Ownable {
58 
59   using SafeMath for uint256;
60 
61     uint256 public TokensPerETH;
62     token public tokenReward;
63     event FundTransfer(address backer, uint256 amount, bool isContribution);
64 
65     function KeplerTokenCrowdsale(
66         uint256 etherPrice,
67         address addressOfTokenUsedAsReward
68     ) public {
69         TokensPerETH = etherPrice * 150 / 125;
70         tokenReward = token(addressOfTokenUsedAsReward);
71     }
72 
73     function () payable public {
74     	require(msg.value != 0);
75         uint256 amount = msg.value;
76         tokenReward.transfer(msg.sender, amount * TokensPerETH);
77         emit FundTransfer(msg.sender, amount, true);
78     }
79 
80     function changeEtherPrice(uint256 newEtherPrice) onlyOwner public {
81         TokensPerETH = newEtherPrice * 150 / 125 ;
82     }
83 
84     function withdraw(uint256 value) onlyOwner public {
85         uint256 amount = value * 1 ether / 100;
86         owner.transfer(amount);
87         emit FundTransfer(owner, amount, false);
88     }
89 
90     function withdrawTokens(address otherTokenAddress, uint256 amount) onlyOwner public {
91         token otherToken = token(otherTokenAddress);
92         otherToken.transfer(owner, amount);
93     }
94 
95     function destroy() onlyOwner public {
96         selfdestruct(owner);
97     }
98 }