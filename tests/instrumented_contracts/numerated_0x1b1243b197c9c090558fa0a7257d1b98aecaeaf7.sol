1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface token { function transferFrom(address _from, address _to, uint256 _value) public returns (bool success); }
21 
22 contract CZRSnowLocker is owned {
23     
24     address public tokenAddr;
25     bool public isPaused = false;
26 
27     event Lock(address indexed addr, uint index, uint amount);
28     event Unlock(address indexed addr, uint index, uint lockAmount, uint rewardAmount);
29     
30     struct LockRecord {
31         uint time;
32         uint amount;
33         bool completed;
34     }
35     
36     mapping(address => LockRecord[]) public lockRecordMap;
37     
38     function CZRSnowLocker(address _tokenAddr) public {
39         tokenAddr = _tokenAddr;
40     }
41     
42     function start() onlyOwner public {
43         isPaused = false;
44     }
45     
46     function pause() onlyOwner public {
47         isPaused = true;
48     }
49 
50     /// @notice impl tokenRecipient interface
51     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public {
52         require(_token == tokenAddr);
53         require(_extraData.length == 0);
54         _lock(_from, _value);
55     }
56 
57     function _lock(address addr, uint amount) internal {
58         require(!isPaused);
59         require(amount >= 100 ether);
60 
61         token t = token(tokenAddr);
62         t.transferFrom(addr, owner, amount);
63 
64         lockRecordMap[addr].push(LockRecord(now, amount, false));
65         
66         uint index = lockRecordMap[addr].length - 1;
67         Lock(addr, index, amount);
68     }
69     
70     /// @notice withdraw CZR
71     /// @param addr address to withdraw
72     /// @param index deposit index
73     function unlock(address addr, uint index) public {
74         require(addr == msg.sender);
75         
76         var lock = lockRecordMap[addr][index];
77         require(lock.amount > 0 && !lock.completed);
78 
79         var during = now - lock.time;
80         var reward = _calcReward(during, lock.amount);
81 
82         token t = token(tokenAddr);
83         t.transferFrom(owner, addr, lock.amount + reward);
84 
85         lock.completed = true;
86 
87         Unlock(addr, index, lock.amount, reward);        
88     }
89 
90     function _calcReward(uint during, uint amount) internal view returns (uint) {
91         uint n = during / 90 days;
92         if (n == 0)
93              return 0;
94         if (n == 1)
95             return amount * 2 / 100;
96         if (n == 2)
97             return amount * 5 / 100;
98         if (n == 3)
99             return amount * 8 / 100;
100         return amount * 12 / 100;
101     }
102 }