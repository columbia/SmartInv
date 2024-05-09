1 pragma solidity ^0.4.24;
2 
3 /**
4 *
5 HYIP24 - 10% Daily - 10% ref - Invest min 0.1
6 */
7 contract Hyip24_10p {
8 
9     using SafeMath for uint256;
10 
11     mapping(address => uint256) investments;
12     mapping(address => uint256) joined;
13     mapping(address => uint256) withdrawals;
14     mapping(address => uint256) referrer;
15 
16     uint256 public step = 10;
17     uint256 public minimum = 100 finney;
18     uint256 public minbounty = 10 finney;
19     address public ownerWallet;
20     address public owner;
21 
22     event Invest(address investor, uint256 amount);
23     event Withdraw(address investor, uint256 amount);
24     event Bounty(address hunter, uint256 amount);
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27     constructor() public {
28         owner = msg.sender;
29         ownerWallet = msg.sender;
30     }
31 
32     modifier onlyOwner() {
33         require(msg.sender == owner);
34         _;
35     }
36 
37     function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner {
38         require(newOwner != address(0));
39         emit OwnershipTransferred(owner, newOwner);
40         owner = newOwner;
41         ownerWallet = newOwnerWallet;
42     }
43 
44     function () public payable {
45         buy(0x0);
46     }
47 
48     function buy(address _referredBy) public payable {
49         require(msg.value >= minimum);
50 
51         address _customerAddress = msg.sender;
52 
53         if(
54            _referredBy != 0x0000000000000000000000000000000000000000 &&
55 
56            _referredBy != _customerAddress
57 
58        ){
59            referrer[_referredBy] = referrer[_referredBy].add(msg.value.mul(10).div(100));
60        }
61 
62        if (investments[msg.sender] > 0){
63            if (withdraw()){
64                withdrawals[msg.sender] = 0;
65            }
66        }
67        investments[msg.sender] = investments[msg.sender].add(msg.value);
68        joined[msg.sender] = block.timestamp;
69        ownerWallet.transfer(msg.value.mul(5).div(100));
70        emit Invest(msg.sender, msg.value);
71     }
72 
73     function getBalance(address _address) view public returns (uint256) {
74         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
75         uint256 percent = investments[_address].mul(step).div(100);
76         uint256 different = percent.mul(minutesCount).div(1440);
77         uint256 balance = different.sub(withdrawals[_address]);
78 
79         return balance;
80     }
81 
82     function withdraw() public returns (bool){
83         require(joined[msg.sender] > 0);
84         uint256 balance = getBalance(msg.sender);
85         if (address(this).balance > balance){
86             if (balance > 0){
87                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
88                 msg.sender.transfer(balance);
89                 emit Withdraw(msg.sender, balance);
90             }
91             return true;
92         } else {
93             return false;
94         }
95     }
96 
97     function bounty() public {
98         uint256 refBalance = checkReferral(msg.sender);
99         if(refBalance >= minbounty) {
100              if (address(this).balance > refBalance) {
101                 referrer[msg.sender] = 0;
102                 msg.sender.transfer(refBalance);
103                 emit Bounty(msg.sender, refBalance);
104              }
105         }
106     }
107 
108     function checkBalance() public view returns (uint256) {
109         return getBalance(msg.sender);
110     }
111 
112     function checkWithdrawals(address _investor) public view returns (uint256) {
113         return withdrawals[_investor];
114     }
115 
116     function checkInvestments(address _investor) public view returns (uint256) {
117         return investments[_investor];
118     }
119 
120     function checkReferral(address _hunter) public view returns (uint256) {
121         return referrer[_hunter];
122     }
123 }
124 
125 library SafeMath {
126     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
127         if (a == 0) {
128             return 0;
129         }
130         uint256 c = a * b;
131         assert(c / a == b);
132         return c;
133     }
134 
135     function div(uint256 a, uint256 b) internal pure returns (uint256) {
136         uint256 c = a / b;
137         return c;
138     }
139 
140     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141         assert(b <= a);
142         return a - b;
143     }
144 
145     function add(uint256 a, uint256 b) internal pure returns (uint256) {
146         uint256 c = a + b;
147         assert(c >= a);
148         return c;
149     }
150 }