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
42   }
43 
44   function changeCommissionFee(uint256 _fee) public onlyOwner {
45     commissionFee = _fee;
46 
47     emit LogChangeCommissionFee(_fee);
48   }
49 
50   function changeOwner(address _newOwner) public onlyOwner {
51     address exOwner = owner;
52     owner = _newOwner;
53 
54     emit LogChangeOwner(exOwner, _newOwner);
55   }
56 
57 
58   //simple transfer
59   function deposit(bytes32 _password) public payable {
60     require(
61       msg.value > commissionFee &&
62       transferToPassword[sha3(_password)].amount == 0
63     );
64 
65     bytes32 pass = sha3(_password);
66     transferToPassword[pass] = Transfer(msg.sender, msg.value);
67 
68     uint256 index = indexToAddress[msg.sender];
69 
70     indexToAddress[msg.sender]++;
71     passwordToAddress[msg.sender][index] = pass;
72 
73     emit LogDeposit(msg.sender, msg.value);
74   }
75 
76   function getTransfer(bytes32 _password) public payable {
77     require(
78       transferToPassword[sha3(_password)].amount > 0
79     );
80 
81     bytes32 pass = sha3(_password);
82     address from = transferToPassword[pass].from;
83     uint256 amount = transferToPassword[pass].amount - commissionFee;
84     totalFee += commissionFee;
85 
86     transferToPassword[pass].amount = 0;
87 
88     msg.sender.transfer(amount);
89 
90     emit LogGetTransfer(from, msg.sender, amount);
91   }
92 
93 
94 
95   //advanced transfer
96   function AdvancedDeposit(bytes32 _password, uint256 _num) public payable {
97     require(
98       _num >= 0 && _num < 1000000 &&
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
115   function getAdvancedTransfer(bytes32 _password, uint256 _num) public payable {
116     require(
117       _num >= 0 && _num < 1000000 &&
118       transferToPassword[sha3(_password, _num)].amount > 0
119     );
120 
121     bytes32 pass = sha3(_password, _num);
122     address from = transferToPassword[pass].from;
123     uint256 amount = transferToPassword[pass].amount - commissionFee;
124     totalFee += commissionFee;
125 
126     transferToPassword[pass].amount = 0;
127 
128     msg.sender.transfer(amount);
129 
130     emit LogGetTransfer(from, msg.sender, amount);
131   }
132 
133   function viewIndexNumber() public view returns(uint256) {
134     return indexToAddress[msg.sender];
135   }
136 
137   function viewPassword(uint256 _index) public view returns(bytes32, uint256) {
138     bytes32 hash = passwordToAddress[msg.sender][_index];
139     uint256 value = transferToPassword[hash].amount;
140 
141     return (hash, value);
142   }
143 
144   function emergency(bytes32 _byte) public payable passwordOwner(_byte) {
145 
146     uint256 amount = transferToPassword[_byte].amount - commissionFee * 2;
147     totalFee += commissionFee * 2;
148     transferToPassword[_byte].amount = 0;
149 
150     msg.sender.transfer(amount);
151 
152     emit LogEmergency(msg.sender, amount);
153   }
154 
155   function withdrawFee() public payable onlyOwner {
156     require( totalFee > 0);
157 
158     uint256 fee = totalFee;
159     totalFee = 0;
160 
161     msg.sender.transfer(totalFee);
162   }
163 
164   // only emergency
165   function withdraw() public payable onlyOwner {
166     msg.sender.transfer(this.balance);
167   }
168 
169 
170 }