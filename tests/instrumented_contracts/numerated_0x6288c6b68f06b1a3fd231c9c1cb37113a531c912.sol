1 pragma solidity ^0.4.25;
2 
3 //
4 // https://github.com/TheWeakestHodler/TheWeakestHodler
5 //
6 // HODL UNTIL YOU ARE HOMELESS
7 //
8 contract TheWeakestHodler {
9     using SafeMath for uint256;
10 
11     uint256 constant public percentsRemaining = 90;
12     mapping(address => uint256) public shares;
13     uint256 public totalShares;
14     
15     function () public payable {
16         if (msg.value > 0) {
17             if (totalShares == 0) {
18                 uint256 amount = msg.value;
19             } else {
20                 amount = msg.value.mul(totalShares).div(address(this).balance.sub(msg.value));
21             }
22             shares[msg.sender] = shares[msg.sender].add(amount);
23             totalShares = totalShares.add(amount);
24         } else {
25             amount = balanceOf(msg.sender);
26             totalShares = totalShares.sub(shares[msg.sender]);
27             shares[msg.sender] = 0;
28             msg.sender.transfer(amount);
29         }
30     }
31 
32     function balanceOf(address _account) public view returns(uint256) {
33         if (totalShares == 0) {
34             return 0;
35         }
36         return address(this).balance.mul(shares[_account]).mul(percentsRemaining).div(totalShares).div(100);
37     }
38 }
39 
40 library SafeMath {
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         if (a == 0) {
43           return 0;
44         }
45         uint256 c = a * b;
46         require(c / a == b);
47         return c;
48     }
49     
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         require(b > 0); // Solidity only automatically asserts when dividing by 0
52         uint256 c = a / b;
53         return c;
54     }
55     
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         require(b <= a);
58         uint256 c = a - b;
59         return c;
60     }
61     
62     function add(uint256 a, uint256 b) internal pure returns (uint256) {
63         uint256 c = a + b;
64         require(c >= a);
65         return c;
66     }
67     
68     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b != 0);
70         return a % b;
71     }
72 }