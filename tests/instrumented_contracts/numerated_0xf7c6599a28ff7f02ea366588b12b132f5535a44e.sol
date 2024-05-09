1 pragma solidity ^0.5.1;
2 
3 // Interface for interacting with Compound
4 interface CompoundContract {
5     function  supply (address asset, uint256 amount) external returns (uint256);
6     function withdraw (address asset, uint256 requestedAmount) external returns (uint256);
7 }
8 
9 // Interface for interacting with tokens
10 interface token {
11     function transfer(address _to, uint256 _value) external returns (bool success) ;
12     function approve(address _spender, uint256 _value) external returns (bool);
13     function balanceOf(address owner) external returns (uint256);
14 }
15 
16 // Basic ownership library
17  contract owned {
18         address public owner;
19 
20         constructor() public {
21             owner = msg.sender;
22         }
23 
24         modifier onlyOwner {
25             require(msg.sender == owner);
26             _;
27         }
28 
29         function transferOwnership(address newOwner) onlyOwner public {
30             owner = newOwner;
31         }
32     }
33 
34 // Here we start
35 contract CompoundPayroll is owned {
36     // first, let's define the contracts we'll be interacting with
37     address compoundAddress = 0x3FDA67f7583380E67ef93072294a7fAc882FD7E7;
38     address daiAddress = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
39     CompoundContract compound = CompoundContract(compoundAddress);
40     token dai = token(daiAddress);
41     
42     // Now let's create a payroll object
43     Salary[] public payroll;
44     mapping (address => uint) public salaryId;
45     uint public payrollLength;
46     
47     struct Salary {
48         address recipient;
49         uint payRate;
50         uint lastPaid;
51         string name;
52     }
53     
54     // An event for easier accounting
55     event MemberPaid(address recipient, uint amount, string justification);
56 
57     // The constructor is called when you init the contract    
58     constructor() public {
59         owner = msg.sender;
60         dai.approve(compoundAddress, 2 ** 128);
61         changePay(address(0), 0, now, '');
62     }
63     
64     // Sends all the current balance to Compound
65     function putInSavings() public  {
66         compound.supply(daiAddress, dai.balanceOf(address(this)));
67     }
68     
69     // Allows owner to make specific payments
70     function cashOut (uint256 amount, address recipient, string memory justification) public onlyOwner {
71         compound.withdraw(daiAddress, amount);
72         dai.transfer(recipient, amount);
73         emit MemberPaid( recipient,  amount, justification);
74 
75     }
76 
77     // Allows you to add or change a salary
78     function changePay(address recipient, uint yearlyPay, uint startingDate, string memory initials) onlyOwner public {
79         // check someone's salary ID
80         uint id = salaryId[recipient];
81         // if it returns 0 then create a new one
82         if (id == 0) {
83             salaryId[recipient] = payroll.length;
84             id = payroll.length++;
85         }
86         payroll[id] = Salary({
87             recipient: recipient, 
88             payRate: yearlyPay / 365.25 days, 
89             lastPaid:  startingDate >  0 ? startingDate : now, 
90             name: initials});
91             
92         payrollLength = payroll.length;
93     }
94 
95     // Removes a salary from the list
96     function removePay(address recipient) onlyOwner public {
97         require(salaryId[recipient] != 0);
98 
99         for (uint i = salaryId[recipient]; i<payroll.length-1; i++){
100             payroll[i] = payroll[i+1];
101             salaryId[payroll[i].recipient] = i;
102         }
103         
104         salaryId[recipient] = 0;
105         delete payroll[payroll.length-1];
106         payroll.length--;
107         payrollLength = payroll.length;
108     }
109     
110     // How much are you owed right now?
111     function getAmountOwed(address recipient) view public returns (uint256) {
112         // get salary ID
113         uint id = salaryId[recipient];
114         if (id > 0) {
115             // If it exists, calculate how much you're owed right now
116             return (now - payroll[id].lastPaid) * payroll[id].payRate;
117         } else {
118             return 0;
119         }
120     }
121     
122     //Make one salary payment
123     function paySalary(address recipient, string memory justification) public {
124         // How much are you owed right now?
125         uint amount = getAmountOwed(recipient);
126         if (amount == 0) return;
127         
128         // Take it out from savings
129         compound.withdraw(daiAddress, amount);
130         
131         // Pay it out
132         payroll[salaryId[recipient]].lastPaid = now;
133         dai.transfer(recipient, amount);
134         emit MemberPaid( recipient,  amount, justification);
135     }
136     
137     // Pay all salaries
138     function payAll() public {
139         for (uint i = 1; i<payroll.length-1; i++){
140             paySalary(payroll[i].recipient, 'payAll');
141         }
142     }
143     
144     // If pinged, save and pay everyone
145     function () external payable {
146         putInSavings();
147         payAll();
148         msg.sender.transfer(msg.value);
149     }
150     
151     // pay everyone!
152     // function() external payable {
153     //     uint totalToPay = 0;
154     //     uint payrollLength = payroll.length; 
155     //     uint[] memory payments = new uint[](payrollLength);
156     //     uint amount; 
157        
158     //   for (uint i = 1; i<payrollLength-1; i++){
159     //         amount = (now - payroll[i].lastPaid) * payroll[i].payRate;
160     //         totalToPay += amount;
161     //         payments[i] = amount;
162     //     } 
163         
164     //     compound.withdraw(daiAddress, totalToPay);
165         
166     //     require(dai.balanceOf(address(this)) <= totalToPay);
167         
168     //     for (uint i = 1; i<payrollLength-1; i++){
169     //         payroll[i].lastPaid = now;
170     //         dai.transfer(payroll[i].recipient, payments[i]);
171     //         emit MemberPaid(payroll[i].recipient, payments[i]);
172     //     }  
173                 
174     //     save();
175     //     msg.sender.transfer(msg.value);
176     // }
177 }