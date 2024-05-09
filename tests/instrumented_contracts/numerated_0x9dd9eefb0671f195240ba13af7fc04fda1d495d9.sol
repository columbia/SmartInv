1 pragma solidity ^0.4.24;
2 
3 contract _2Percent {
4     address public owner;
5     uint public investedAmount;
6     address[] public addresses;
7     uint public lastPaymentDate;
8     uint constant public interest = 2;
9     uint constant public transactions_limit = 100;
10     mapping(address => Member) public members;
11     uint constant public min_withdraw = 100000000000000 wei;
12     uint constant public min_invest = 10000000000000000 wei;
13 
14     struct Member
15     {
16         uint id;
17         address referrer;
18         uint deposit;
19         uint deposits;
20         uint date;
21     }
22 
23     constructor() public {
24         owner = msg.sender;
25         addresses.length = 1;
26     }
27 
28     function getMemberCount() public view returns (uint) {
29         return addresses.length - 1;
30     }
31 
32     function getMemberDividendsAmount(address addr) public view returns (uint) {
33         return members[addr].deposit / 100 * interest * (now - members[addr].date) / 1 days;
34     }
35 
36     function bytesToAddress(bytes bys) private pure returns (address addr) {
37         assembly {
38             addr := mload(add(bys, 20))
39         }
40     }
41 
42     function selfPayout() private {
43         require(members[msg.sender].id > 0, "Member not found.");
44         uint amount = getMemberDividendsAmount(msg.sender);
45         require(amount >= min_withdraw, "Too small amount, minimum 0.0001 ether");
46         members[msg.sender].date = now;
47         msg.sender.transfer(amount);
48     }
49 
50     function() payable public {
51         if (owner == msg.sender) {
52             return;
53         }
54 
55         if (0 == msg.value) {
56             selfPayout();
57             return;
58         }
59 
60         require(msg.value >= min_invest, "Too small amount, minimum 0.01 ether");
61 
62         Member storage user = members[msg.sender];
63 
64         if (user.id == 0) {
65             msg.sender.transfer(0 wei);
66             user.date = now;
67             user.id = addresses.length;
68             addresses.push(msg.sender);
69 
70             address referrer = bytesToAddress(msg.data);
71 
72             if (members[referrer].deposit > 0 && referrer != msg.sender) {
73                 user.referrer = referrer;
74             }
75         } else {
76             selfPayout();
77         }
78 
79         user.deposits += 1;
80         user.deposit += msg.value;
81 
82         lastPaymentDate = now;
83         investedAmount += msg.value;
84 
85         owner.transfer(msg.value / 5);
86 
87         if (user.referrer > 0x0) {
88             uint bonusAmount = (msg.value / 100) * interest;
89             user.referrer.send(bonusAmount);
90 
91             if (user.deposits == 1) {
92                 msg.sender.send(bonusAmount);
93             }
94         }
95     }
96 }