1 pragma solidity ^0.4.11;
2 
3 contract Ownable {
4   address public owner;
5 
6   function Ownable() {
7     owner = msg.sender;
8   }
9 
10   modifier onlyOwner() {
11     require(msg.sender == owner);
12     _;
13   }
14 
15   function transferOwnership(address newOwner) onlyOwner {
16     require(newOwner != address(0));
17     owner = newOwner;
18   }
19 }
20 
21 library SafeMath {
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract EthCapsule is Ownable {
30   struct Depositor {
31     uint numCapsules;
32     mapping (uint => Capsule) capsules;
33   }
34 
35   mapping (address => Depositor) depositors;
36 
37   struct Capsule {
38     uint value;
39     uint id;
40     uint lockTime;
41     uint unlockTime;
42     uint withdrawnTime;
43   }
44 
45   uint public minDeposit = 1000000000000000;
46   uint public minDuration = 0;
47   uint public maxDuration = 157680000;
48   uint public totalCapsules;
49   uint public totalValue;
50   uint public totalBuriedCapsules;
51 
52   function bury(uint unlockTime) payable {
53     require(msg.value >= minDeposit);
54     require(unlockTime <= block.timestamp + maxDuration);
55 
56     if (unlockTime < block.timestamp + minDuration) {
57       unlockTime = SafeMath.add(block.timestamp, minDuration);
58     }
59 
60     if (depositors[msg.sender].numCapsules <= 0) {
61         depositors[msg.sender] = Depositor({ numCapsules: 0 });
62     }
63 
64     Depositor storage depositor = depositors[msg.sender];
65 
66     depositor.numCapsules++;
67     depositor.capsules[depositor.numCapsules] = Capsule({
68         value: msg.value,
69         id: depositors[msg.sender].numCapsules,
70         lockTime: block.timestamp,
71         unlockTime: unlockTime,
72         withdrawnTime: 0
73     });
74 
75     totalBuriedCapsules++;
76     totalCapsules++;
77     totalValue = SafeMath.add(totalValue, msg.value);
78   }
79 
80   function dig(uint capsuleNumber) {
81     Capsule storage capsule = depositors[msg.sender].capsules[capsuleNumber];
82 
83     require(capsule.unlockTime <= block.timestamp);
84     require(capsule.withdrawnTime == 0);
85 
86     totalBuriedCapsules--;
87     capsule.withdrawnTime = block.timestamp;
88     msg.sender.transfer(capsule.value);
89   }
90 
91   function setMinDeposit(uint min) onlyOwner {
92     minDeposit = min;
93   }
94 
95   function setMinDuration(uint min) onlyOwner {
96     minDuration = min;
97   }
98 
99   function setMaxDuration(uint max) onlyOwner {
100     maxDuration = max;
101   }
102   
103   function getCapsuleInfo(uint capsuleNum) constant returns (uint, uint, uint, uint, uint) {
104     return (
105         depositors[msg.sender].capsules[capsuleNum].value,
106         depositors[msg.sender].capsules[capsuleNum].id,
107         depositors[msg.sender].capsules[capsuleNum].lockTime,
108         depositors[msg.sender].capsules[capsuleNum].unlockTime,
109         depositors[msg.sender].capsules[capsuleNum].withdrawnTime
110     );
111   }
112 
113   function getNumberOfCapsules() constant returns (uint) {
114     return depositors[msg.sender].numCapsules;
115   }
116 
117   function totalBuriedValue() constant returns (uint) {
118     return this.balance;
119   }
120 }