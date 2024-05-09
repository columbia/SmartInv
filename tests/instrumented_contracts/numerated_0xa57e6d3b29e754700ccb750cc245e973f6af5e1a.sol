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
22 contract CZRLocker is owned {
23     
24     event AddLock(address addr, uint index, uint startLockTime, uint lockMonth, uint lockedAmount);
25     event RemoveLock(address addr, uint index);
26     event Unlock(address addr, uint index, uint unlockAmount);
27 
28     address public tokenAddr;
29     address public unlocker;
30     
31     struct LockedCZR {
32         uint startLockTime;
33         uint lockMonth;
34         uint lockedAmount;
35         uint unlockedAmount;
36     }
37     
38     mapping(address => LockedCZR[]) public lockedCZRMap;
39     
40     function CZRLocker(address _tokenAddr, address _unlocker) public {
41         tokenAddr = _tokenAddr;
42         unlocker = _unlocker;
43     }
44 
45     /// @notice remove CZR lock (only set all field to 0)
46     /// @param addr address to remove lock
47     /// @param index index to remove
48     function removeCZRLock(address addr, uint index) onlyOwner public {
49         LockedCZR[] storage lockArr = lockedCZRMap[addr];
50         require(lockArr.length > 0 && index < lockArr.length);
51     
52         delete lockArr[index];      //delete just set all feilds to zero value, not remove item out of array;
53         RemoveLock(addr, index);
54     }
55     
56     /// @notice add CZR lock
57     /// @param addr address to add lock
58     /// @param startLockTime start lock time, 0 for now
59     /// @param amount CZR amount
60     /// @param lockMonth months to lock
61     function addCZRLock(address addr, uint startLockTime, uint amount, uint lockMonth) onlyOwner public {
62         require(amount > 0);
63         if (startLockTime == 0)
64             startLockTime = now;
65         lockedCZRMap[addr].push(LockedCZR(startLockTime, lockMonth, amount, 0));
66         uint index = lockedCZRMap[addr].length - 1;
67         AddLock(addr, index, startLockTime, lockMonth, amount);
68     }
69     
70     /// @notice unlock CZR
71     /// @param addr address to unlock
72     /// @param limit max unlock number
73     function unlockCZR(address addr, uint limit) public {
74         require(msg.sender == owner || msg.sender == unlocker);
75         
76         LockedCZR[] storage lockArr = lockedCZRMap[addr];
77         require(lockArr.length > 0);
78         token t = token(tokenAddr);
79         
80         uint num = 0;
81         for (uint i = 0; i < lockArr.length; i++) {
82             var lock = lockArr[i];
83             if (lock.lockedAmount > 0) {
84                 uint time = now - lock.startLockTime;
85                 uint month = time / 30 days;
86                 
87                 if (month == 0) 
88                     continue;
89 
90                 uint unlockAmount;
91                 if (month >= lock.lockMonth)
92                     unlockAmount = lock.lockedAmount;
93                 else
94                     unlockAmount = (lock.lockedAmount + lock.unlockedAmount) * month / lock.lockMonth - lock.unlockedAmount;
95                         
96                 if (unlockAmount == 0) 
97                     continue;
98                     
99                 lock.unlockedAmount += unlockAmount;
100                 lock.lockedAmount -= unlockAmount;
101                         
102                 t.transferFrom(owner, addr, unlockAmount);
103                 Unlock(addr, i, unlockAmount);
104                 
105                 num++;
106                 if (limit > 0 && num == limit)
107                     break;
108             }
109         }
110         
111         require(num > 0);
112     }
113     
114     /// @notice withdraw eth
115     /// @param to Address to receive the eth
116     /// @param value the amount of eth it will receive
117     function withdrawEth(address to, uint256 value) onlyOwner public {
118         to.transfer(value);
119     }
120     
121     /// record total received eth and check whether goal completed
122     function() payable public {
123     }
124 }