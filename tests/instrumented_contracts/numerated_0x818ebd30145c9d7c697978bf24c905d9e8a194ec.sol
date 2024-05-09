1 pragma solidity 0.4.23;
2 
3 contract PasswordEscrow {
4   address public owner;
5   uint256 public commissionFee;
6   uint256 public totalFee;
7 
8   //data
9   struct Transfer {
10     address from;
11     uint256 amount;
12   }
13 
14   mapping(bytes32 => Transfer) private transferToPassword;
15 
16   mapping(address => uint256) private indexToAddress;
17   mapping(address => mapping(uint256 => bytes32)) private passwordToAddress;
18 
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24   modifier passwordOwner(bytes32 _byte) {
25     require(
26       transferToPassword[_byte].from == msg.sender &&
27       transferToPassword[_byte].amount > 0
28     );
29     _;
30   }
31 
32   event LogChangeCommissionFee(uint256 fee);
33   event LogChangeOwner(address indexed exOwner, address indexed newOwner);
34   event LogDeposit(address indexed from, uint256 amount);
35   event LogGetTransfer(address indexed from, address indexed recipient, uint256 amount);
36   event LogEmergency(address indexed from, uint256 amount);
37 
38 
39 
40   constructor(uint256 _fee) public {
41     commissionFee = _fee;
42     owner = msg.sender;
43   }
44 
45   function changeCommissionFee(uint256 _fee) public onlyOwner {
46     commissionFee = _fee;
47 
48     emit LogChangeCommissionFee(_fee);
49   }
50 
51   function changeOwner(address _newOwner) public onlyOwner {
52     address exOwner = owner;
53     owner = _newOwner;
54 
55     emit LogChangeOwner(exOwner, _newOwner);
56   }
57 
58 
59   //simple transfer
60   function deposit(bytes32 _password) public payable {
61     require(
62       msg.value > commissionFee &&
63       transferToPassword[sha3(_password)].amount == 0
64     );
65 
66     bytes32 pass = sha3(_password);
67     transferToPassword[pass] = Transfer(msg.sender, msg.value);
68 
69     uint256 index = indexToAddress[msg.sender];
70 
71     indexToAddress[msg.sender]++;
72     passwordToAddress[msg.sender][index] = pass;
73 
74     emit LogDeposit(msg.sender, msg.value);
75   }
76 
77   function getTransfer(bytes32 _password) public payable {
78     require(
79       transferToPassword[sha3(_password)].amount > 0
80     );
81 
82     bytes32 pass = sha3(_password);
83     address from = transferToPassword[pass].from;
84     uint256 amount = transferToPassword[pass].amount - commissionFee;
85     totalFee += commissionFee;
86 
87     transferToPassword[pass].amount = 0;
88 
89     msg.sender.transfer(amount);
90 
91     emit LogGetTransfer(from, msg.sender, amount);
92   }
93 
94 
95 
96   //advanced transfer
97   function AdvancedDeposit(bytes32 _password, bytes32 _num) public payable {
98     require(
99       msg.value >= commissionFee &&
100       transferToPassword[sha3(_password, _num)].amount == 0
101     );
102 
103     bytes32 pass = sha3(_password, _num);
104     transferToPassword[pass] = Transfer(msg.sender, msg.value);
105 
106     uint256 index = indexToAddress[msg.sender];
107 
108     indexToAddress[msg.sender]++;
109     passwordToAddress[msg.sender][index] = pass;
110 
111 
112     emit LogDeposit(msg.sender, msg.value);
113   }
114 
115   function getAdvancedTransfer(bytes32 _password, bytes32 _num) public payable {
116     require(
117       transferToPassword[sha3(_password, _num)].amount > 0
118     );
119 
120     bytes32 pass = sha3(_password, _num);
121     address from = transferToPassword[pass].from;
122     uint256 amount = transferToPassword[pass].amount - commissionFee;
123     totalFee += commissionFee;
124 
125     transferToPassword[pass].amount = 0;
126 
127     msg.sender.transfer(amount);
128 
129     emit LogGetTransfer(from, msg.sender, amount);
130   }
131 
132   function viewIndexNumber() public view returns(uint256) {
133     return indexToAddress[msg.sender];
134   }
135 
136   function viewPassword(uint256 _index) public view returns(bytes32, uint256) {
137     bytes32 hash = passwordToAddress[msg.sender][_index];
138     uint256 value = transferToPassword[hash].amount;
139 
140     return (hash, value);
141   }
142 
143   function emergency(bytes32 _byte) public payable passwordOwner(_byte) {
144 
145     uint256 amount = transferToPassword[_byte].amount - commissionFee * 2;
146     totalFee += commissionFee * 2;
147     transferToPassword[_byte].amount = 0;
148 
149     msg.sender.transfer(amount);
150 
151     emit LogEmergency(msg.sender, amount);
152   }
153 
154   function withdrawFee() public payable onlyOwner {
155     require( totalFee > 0);
156 
157     uint256 fee = totalFee;
158     totalFee = 0;
159 
160     msg.sender.transfer(totalFee);
161   }
162 
163   function withdraw() public payable onlyOwner {
164     msg.sender.transfer(this.balance);
165   }
166 
167 
168 }