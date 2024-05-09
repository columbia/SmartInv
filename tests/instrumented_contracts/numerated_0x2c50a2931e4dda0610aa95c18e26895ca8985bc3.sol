1 pragma solidity ^0.4.0;
2 
3 contract Hellevator {
4 
5     event GiveUpTheDough(address indexed beneficiary);
6     event JoinTheFray(address indexed rube);
7 
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12 
13     uint public buyin = 0.01 ether;
14     uint public newRubesUntilPayout = 3;
15     uint public payout = 0.02 ether;
16     uint public queueFront;
17     uint public queueSize;
18 
19     address owner;
20     mapping (address => uint) pendingWithdrawals;
21     mapping (uint => address) rubes;
22 
23     function Hellevator() public {
24         owner = msg.sender;
25     }
26 
27     function() public payable {
28         joinTheFray();
29     }
30 
31     function withdraw() public {
32         uint amount = pendingWithdrawals[msg.sender];
33         pendingWithdrawals[msg.sender] = 0;
34         msg.sender.transfer(amount);
35     }
36 
37     // Internal
38 
39     function addRube() internal {
40         rubes[queueSize] = msg.sender;
41         queueSize += 1;
42     }
43 
44     function giveUpTheDough() internal {
45         address undeservingBeneficiary = rubes[queueFront];
46         pendingWithdrawals[undeservingBeneficiary] += payout;
47         queueFront += 1;
48         GiveUpTheDough(undeservingBeneficiary);
49     }
50 
51     function isPayoutTime() internal view returns (bool) {
52         return queueSize % newRubesUntilPayout == 0;
53     }
54 
55     function joinTheFray() internal {
56         bool isCheapskate = msg.value < buyin;
57 
58         if (isCheapskate) {
59             return;
60         }
61 
62         addRube();
63         JoinTheFray(msg.sender);
64 
65         if (isPayoutTime()) {
66             giveUpTheDough();
67         }
68     }
69 
70     // Administration
71 
72     function changeBuyin(uint _buyin) public onlyOwner {
73         buyin = _buyin;
74     }
75 
76     function changeNewRubesUntilPayout(uint _newRubesUntilPayout) public onlyOwner {
77         newRubesUntilPayout = _newRubesUntilPayout;
78     }
79 
80     function changeOwner(address _owner) public onlyOwner {
81         owner = _owner;
82     }
83 
84     function changePayout(uint _payout) public onlyOwner {
85         payout = _payout;
86     }
87 
88     function payTheMan(uint amount) public onlyOwner {
89         owner.transfer(amount);
90     }
91 }