1 pragma solidity ^0.4.21;
2 
3 contract ERC223Interface {
4     uint public totalSupply;
5     function balanceOf(address who) constant returns (uint);
6     function transfer(address to, uint value) public returns (bool success);
7     function transfer(address to, uint value, bytes data) public returns (bool success);
8     function transferFrom(address from, address to, uint tokens) public returns (bool success);
9     event Transfer(address indexed from, address indexed to, uint value);
10     event Transfer(address indexed from, address indexed to, uint value, bytes data);
11 }
12 
13 contract Deal {
14 
15     enum Status { created, destroyed, finished }
16 
17     event CreateCampaign(bytes32 campaignId);
18     event SendCoinForCampaign(bytes32 campaignId);
19 
20     struct Campaign {
21         address creator;
22         uint tokenAmount;
23         uint currentBalance;
24         Status status;
25     }
26 
27     address public owner;
28 
29     address public fee;
30 
31     ERC223Interface public token;
32 
33     mapping (bytes32 => Campaign) public campaigns;
34 
35     modifier onlyOwner() {
36         require(msg.sender == owner);
37         _;
38     }
39 
40     function Deal(address tokenAddress, address _owner, address _fee) {
41       owner = _owner;
42       fee = _fee;
43       token = ERC223Interface(tokenAddress);
44     }
45 
46     function transferOwnership(address newOwner) public onlyOwner {
47       if (newOwner != address(0)) {
48         owner = newOwner;
49       }
50     }
51 
52     function safeMul(uint a, uint b) internal returns (uint) {
53       uint c = a * b;
54       assert(a == 0 || c / a == b);
55       return c;
56     }
57 
58     function safeDiv(uint a, uint b) internal returns (uint) {
59       assert(b > 0);
60       uint c = a / b;
61       assert(a == b * c + a % b);
62       return c;
63     }
64 
65     function safeSub(uint a, uint b) internal returns (uint) {
66       assert(b <= a);
67       return a - b;
68     }
69 
70     function safeAdd(uint a, uint b) internal returns (uint) {
71       uint c = a + b;
72       assert(c>=a && c>=b);
73       return c;
74     }
75 
76     function sum(uint[] array) public returns (uint) {
77         uint summa;
78         for (uint i; i < array.length; i++) {
79             summa += array[i];
80         }
81         return summa;
82     }
83 
84     function changeFeeAddress(address newFee) onlyOwner {
85         fee = newFee;
86     }
87 
88     function createCampaign(bytes32 id, uint value, address campaignCreator) onlyOwner returns (uint) {
89        require(getAddressCreatorById(id) == address(0));
90        token.transferFrom(campaignCreator, this, value);
91        campaigns[id] = Campaign(campaignCreator, value, value, Status.created);
92        CreateCampaign(id);
93     }
94 
95     function addTokensToCampaign(bytes32 id, uint value) onlyOwner returns (bool success) {
96         token.transferFrom(getAddressCreatorById(id), this, value);
97         campaigns[id].tokenAmount += value;
98         campaigns[id].currentBalance += value;
99     }
100 
101     function updateTokenAddress(address newAddr) onlyOwner {
102         token = ERC223Interface(newAddr);
103     }
104 
105     function destroyCampaign(bytes32 id) onlyOwner returns (bool success) {
106         token.transfer(campaigns[id].creator, campaigns[id].tokenAmount);
107         campaigns[id].status = Status.destroyed;
108         campaigns[id].currentBalance = 0;
109     }
110 
111     function checkStatus(bytes32 id) public constant returns (Status status) {
112         return campaigns[id].status;
113     }
114 
115     function getAddressCreatorById(bytes32 id) public constant returns(address) {
116         return campaigns[id].creator;
117     }
118 
119     function getTokenAmountForCampaign(bytes32 id) public constant returns (uint value) {
120         return campaigns[id].tokenAmount;
121     }
122 
123     function getCurrentBalanceForCampaign(bytes32 id) public constant returns (uint value) {
124         return campaigns[id].currentBalance;
125     }
126 
127     function finishCampaign(bytes32 id) onlyOwner returns (bool success) {
128         campaigns[id].status = Status.finished;
129         token.transfer(campaigns[id].creator, campaigns[id].currentBalance);
130         campaigns[id].currentBalance = 0;
131     }
132 
133     function sendCoin(address[] _routerOwners, uint[] amount, bytes32 id) onlyOwner {
134         require(campaigns[id].status == Status.created);
135         require(amount.length == _routerOwners.length);
136         require(sum(amount) <= campaigns[id].tokenAmount);
137 
138         for (var i = 0; i < amount.length; i++) {
139            token.transfer(_routerOwners[i], safeDiv(safeMul(amount[i], 95), 100)); 
140         }
141         token.transfer(fee, safeDiv(safeMul(sum(amount), 5), 100) );
142         campaigns[id].currentBalance = safeSub(campaigns[id].currentBalance, sum(amount));
143         SendCoinForCampaign(id);
144     }
145 }