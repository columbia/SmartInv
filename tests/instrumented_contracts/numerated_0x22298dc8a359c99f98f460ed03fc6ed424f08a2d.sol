1 pragma solidity ^0.4.18;
2 
3 contract ERC20 {
4 
5     uint256 public totalSupply;
6 
7     event Transfer(address indexed from, address indexed to, uint256 value);
8     event Approval(address indexed owner, address indexed spender, uint256 value);
9 
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12 
13     function allowance(address owner, address spender) public view returns (uint256);
14     function approve(address spender, uint256 value) public returns (bool);
15     function transferFrom(address from, address to, uint256 value) public returns (bool);
16 
17 }
18 
19 contract Ownable {
20     address public owner;
21 
22     event OwnerChanged(address oldOwner, address newOwner);
23 
24     function Ownable() public {
25         owner = msg.sender;
26     }
27 
28     modifier onlyOwner {
29         require(msg.sender == owner);
30         _;
31     }
32 
33     function transferOwnership(address newOwner) onlyOwner public {
34         require(newOwner != owner && newOwner != address(0x0));
35         address oldOwner = owner;
36         owner = newOwner;
37         OwnerChanged(oldOwner, newOwner);
38     }
39 }
40 
41 
42 contract TeamTokenLock is Ownable {
43 
44     ERC20 public token;
45 
46     // address where receives funds when unlock period
47     address public beneficiary;
48 
49     uint public startTime = 1514592000;
50     uint public firstLockTime = 365 days;
51     uint public secondLockTime = 2 * 365 days;
52 
53     uint public firstLockAmount = 120000000 * (10 ** 18);
54     uint public secondLockAmount = 120000000 * (10 ** 18);
55 
56     modifier onlyOfficial {
57         require(msg.sender == owner || msg.sender == beneficiary);
58         _;
59     }
60 
61     modifier firstLockTimeEnd {
62         require(isFirstLockTimeEnd());
63         _;
64     }
65 
66     modifier secondLockTimeEnd {
67         require(isSecondLockTimeEnd());
68         _;
69     }
70 
71     function TeamTokenLock(address _beneficiary, address _token) public {
72         require(_beneficiary != address(0));
73         require(_token != address(0));
74 
75         beneficiary = _beneficiary;
76         token = ERC20(_token);
77     }
78 
79     function getTokenBalance() public view returns(uint) {
80         return token.balanceOf(address(this));
81     }
82 
83     function isFirstLockTimeEnd() public view returns(bool) {
84         return now > startTime + firstLockTime;
85     }
86 
87     function isSecondLockTimeEnd() public view returns(bool) {
88         return now > startTime + secondLockTime;
89     }
90 
91     function unlockFirstTokens() public onlyOfficial firstLockTimeEnd {
92         require(firstLockAmount > 0);
93 
94         uint unlockAmount = firstLockAmount < getTokenBalance() ? firstLockAmount : getTokenBalance();
95         require(unlockAmount <= firstLockAmount);
96         firstLockAmount = firstLockAmount - unlockAmount;
97         require(token.transfer(beneficiary, unlockAmount));
98     }
99 
100     function unlockSecondTokens() public onlyOfficial secondLockTimeEnd {
101         require(secondLockAmount > 0);
102 
103         uint unlockAmount = secondLockAmount < getTokenBalance() ? secondLockAmount : getTokenBalance();
104         require(unlockAmount <= secondLockAmount);
105         secondLockAmount = secondLockAmount - unlockAmount;
106         require(token.transfer(beneficiary, unlockAmount));
107     }
108 
109     function changeBeneficiary(address _beneficiary) public onlyOwner {
110         require(_beneficiary != address(0));
111         beneficiary = _beneficiary;
112     }
113 }