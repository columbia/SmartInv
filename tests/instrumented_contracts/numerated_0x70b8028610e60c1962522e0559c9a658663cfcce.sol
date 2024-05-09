1 pragma solidity ^0.4.25;
2 
3 contract Olympus {
4     using SafeMath for uint;
5     
6     address private constant supportAddress = 0x0bD47808d4A09aD155b00C39dBb101Fb71e1C0f0;
7     uint private constant supportPercent = 1;
8     
9     mapping(address => uint) private shares;
10     uint private totalShares;
11     uint private totalPersons;
12     
13     function getBalance(address _account) public constant returns (uint) {
14         if (totalShares == 0)
15             return 0;
16         uint contractBalance = address(this).balance;
17         uint profitPercent = calculateProfitPercent(contractBalance, totalPersons);
18         return contractBalance.mul(shares[_account]).mul(profitPercent).div(totalShares).div(100);
19     }
20     
21     function() public payable {
22         address sender = msg.sender;
23         uint amount = msg.value;
24         if (amount > 0) {
25             if (totalPersons > 10)
26                 supportAddress.transfer(calculateSupportPercent(amount));
27             if (totalShares > 0)
28                 amount = amount.mul(totalShares).div(address(this).balance.sub(amount));
29             if (shares[sender] == 0)
30                 totalPersons++;
31             shares[sender] = shares[sender].add(amount);
32             totalShares = totalShares.add(amount);
33         } else {
34             amount = getBalance(sender);
35             totalShares = totalShares.sub(shares[sender]);
36             shares[sender] = 0;
37             totalPersons--;
38             uint percent = calculateSupportPercent(amount);
39             supportAddress.transfer(percent);
40             sender.transfer(amount - percent);
41             if (totalPersons == 0)
42                 supportAddress.transfer(address(this).balance);
43         }
44     }
45     
46     function calculateProfitPercent(uint _balance, uint _totalPersons) private pure returns (uint) {
47         if (_balance >= 8e20 || _totalPersons == 1) // 800 ETH
48             return 95;
49         else if (_balance >= 4e20) // 400 ETH
50             return 94;
51         else if (_balance >= 2e20) // 200 ETH
52             return 93;
53         else if (_balance >= 1e20) // 100 ETH
54             return 92;
55         else if (_balance >= 5e19) // 50 ETH
56             return 91;
57         else
58             return 90;
59     }
60     
61     function calculateSupportPercent(uint _amount) private pure returns (uint) {
62         return _amount * supportPercent / 100;
63     }
64 }
65 
66 library SafeMath {
67     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68         if (a == 0) {
69           return 0;
70         }
71         uint256 c = a * b;
72         require(c / a == b);
73         return c;
74     }
75     
76     function div(uint256 a, uint256 b) internal pure returns (uint256) {
77         require(b > 0); // Solidity only automatically asserts when dividing by 0
78         uint256 c = a / b;
79         return c;
80     }
81     
82     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83         require(b <= a);
84         uint256 c = a - b;
85         return c;
86     }
87     
88     function add(uint256 a, uint256 b) internal pure returns (uint256) {
89         uint256 c = a + b;
90         require(c >= a);
91         return c;
92     }
93     
94     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95         require(b != 0);
96         return a % b;
97     }
98 }