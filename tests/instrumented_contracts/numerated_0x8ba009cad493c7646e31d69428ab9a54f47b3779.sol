1 pragma solidity 0.5.10;
2 
3 contract owned {
4     address public owner;
5     constructor() public {
6         owner = msg.sender;
7     }
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12     function transferOwnership(address newOwner) onlyOwner public {
13         owner = newOwner;
14     }
15 }
16 
17 contract VirgoX_ERC20 is owned {
18 
19     mapping(address => uint256) public balanceOf;
20     mapping(address => uint256) public lockCreateTime;
21     mapping(address => uint256) public lockMonths;
22     mapping(address => uint256) public lockSumValue;
23     mapping(address => uint256) public unlockMonths;
24 
25     string public name = "VirgoX Token";
26     string public symbol = "VXT";
27     uint8 public decimals = 18;
28     uint256 public totalSupply = 500000000 * (uint256(10) ** decimals);
29 
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 
32     constructor() public {
33         balanceOf[msg.sender] = totalSupply;
34         emit Transfer(address(0), msg.sender, totalSupply);
35     }
36 
37     function transfer(address to, uint256 value) public returns (bool success) {
38         require(value >= 0);
39         require(balanceOf[msg.sender] >= value);
40 
41         if (lockSumValue[msg.sender] > 0) {
42             uint256 beginUnlockTime = lockCreateTime[msg.sender] + lockMonths[msg.sender] * (30 days);
43             uint256 endUnlockTime = beginUnlockTime + (unlockMonths[msg.sender]-1) * (30 days);
44             if (now >= endUnlockTime) {
45                 lockCreateTime[msg.sender] = 0;
46                 lockMonths[msg.sender] = 0;
47                 lockSumValue[msg.sender] = 0;
48                 unlockMonths[msg.sender] = 0;
49             } else {
50                 uint256 count = 0;
51                 if (now >= beginUnlockTime) {
52                     count = (now - beginUnlockTime) / (30 days) + 1;
53                 }
54                 uint256 lastLockValue = lockSumValue[msg.sender] - (lockSumValue[msg.sender] / unlockMonths[msg.sender]) * count;
55                 require(balanceOf[msg.sender] - lastLockValue >= value);
56             }
57 
58         }
59 
60         balanceOf[msg.sender] -= value;
61         balanceOf[to] += value;
62         emit Transfer(msg.sender, to, value);
63         return true;
64     }
65 
66     function transferToLock(address to, uint256 _lockValue, uint256 _lockMonths, uint256 _unlockMonths)
67     public onlyOwner
68     returns (bool success)
69     {
70         require(to != msg.sender);
71         require(_lockValue > 0);
72         require(_lockMonths >= 0);
73         require(_unlockMonths > 0);
74         require(lockSumValue[to] == 0);
75         require(balanceOf[msg.sender] >= _lockValue);
76 
77         lockCreateTime[to] = now;
78         lockMonths[to] = _lockMonths;
79         lockSumValue[to] = _lockValue;
80         unlockMonths[to] = _unlockMonths;
81 
82         balanceOf[msg.sender] -= _lockValue;
83         balanceOf[to] += _lockValue;
84         emit Transfer(msg.sender, to, _lockValue);
85         return true;
86     }
87 
88     function unlock(address to)
89     public onlyOwner
90     returns (bool success)
91     {
92         require(to != msg.sender);
93         lockCreateTime[to] = 0;
94         lockMonths[to] = 0;
95         lockSumValue[to] = 0;
96         unlockMonths[to] = 0;
97         return true;
98     }
99 
100 }