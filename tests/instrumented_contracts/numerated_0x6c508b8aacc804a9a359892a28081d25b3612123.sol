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
24     uint constant public START_TIME = 1515427200;
25     uint constant public GOAL = 60000 ether;
26 
27     bool isPaused = false;
28     uint public totalReceived;
29     uint public goalCompletedBlock;
30     address public tokenAddr;
31     address public unlocker;
32     
33     event AddLock(address addr, uint index, uint startLockTime, uint lockMonth, uint lockedAmount);
34     event RemoveLock(address addr, uint index);
35     event Unlock(address addr, uint index, uint unlockAmount);
36     
37     struct LockedCZR {
38         uint startLockTime;
39         uint lockMonth;
40         uint lockedAmount;
41         uint unlockedAmount;
42     }
43     
44     mapping(address => LockedCZR[]) public lockedCZRMap;
45     
46     function CZRLocker(address _tokenAddr, address _unlocker) public {
47         tokenAddr = _tokenAddr;
48         unlocker = _unlocker;
49     }
50     
51     function start() onlyOwner public {
52         isPaused = false;
53     }
54     
55     function pause() onlyOwner public {
56         isPaused = true;
57     }
58 
59     /// @notice remove CZR lock (only set all field to 0)
60     /// @param addr address to remove lock
61     /// @param index index to remove
62     function removeCZRLock(address addr, uint index) onlyOwner public {
63         LockedCZR[] storage lockArr = lockedCZRMap[addr];
64         require(lockArr.length > 0 && index < lockArr.length);
65     
66         delete lockArr[index];      //delete just set all feilds to zero value, not remove item out of array;
67         RemoveLock(addr, index);
68     }
69     
70     /// @notice add CZR lock
71     /// @param addr address to add lock
72     /// @param startLockTime start lock time, 0 for now
73     /// @param amount CZR amount
74     /// @param lockMonth months to lock
75     function addCZRLock(address addr, uint startLockTime, uint amount, uint lockMonth) onlyOwner public {
76         require(amount > 0);
77         if (startLockTime == 0)
78             startLockTime = now;
79         lockedCZRMap[addr].push(LockedCZR(startLockTime, lockMonth, amount, 0));
80         uint index = lockedCZRMap[addr].length - 1;
81         AddLock(addr, index, startLockTime, lockMonth, amount);
82     }
83     
84     /// @notice unlock CZR
85     /// @param addr address to unlock
86     /// @param limit max unlock number
87     function unlockCZR(address addr, uint limit) public {
88         require(msg.sender == owner || msg.sender == unlocker);
89         
90         LockedCZR[] storage lockArr = lockedCZRMap[addr];
91         require(lockArr.length > 0);
92         token t = token(tokenAddr);
93         
94         uint num = 0;
95         for (uint i = 0; i < lockArr.length; i++) {
96             var lock = lockArr[i];
97             if (lock.lockedAmount > 0) {
98                 uint time = now - lock.startLockTime;
99                 uint month = time / 30 days;
100                 
101                 if (month == 0) 
102                     continue;
103 
104                 uint unlockAmount;
105                 if (month >= lock.lockMonth)
106                     unlockAmount = lock.lockedAmount;
107                 else
108                     unlockAmount = (lock.lockedAmount + lock.unlockedAmount) * month / lock.lockMonth - lock.unlockedAmount;
109                         
110                 if (unlockAmount == 0) 
111                     continue;
112                     
113                 lock.unlockedAmount += unlockAmount;
114                 lock.lockedAmount -= unlockAmount;
115                         
116                 t.transferFrom(owner, addr, unlockAmount);
117                 Unlock(addr, i, unlockAmount);
118                 
119                 num++;
120                 if (limit > 0 && num == limit)
121                     break;
122             }
123         }
124         
125         require(num > 0);
126     }
127     
128     /// @notice withdraw eth
129     /// @param to Address to receive the eth
130     /// @param value the amount of eth it will receive
131     function withdrawEth(address to, uint256 value) onlyOwner public {
132         to.transfer(value);
133     }
134     
135     /// record total received eth and check whether goal completed
136     function() payable public {
137         require(!isPaused);
138         require(now > START_TIME);
139         totalReceived += msg.value;
140         if (goalCompletedBlock == 0 && totalReceived >= GOAL)
141             goalCompletedBlock = block.number;
142     }
143 }