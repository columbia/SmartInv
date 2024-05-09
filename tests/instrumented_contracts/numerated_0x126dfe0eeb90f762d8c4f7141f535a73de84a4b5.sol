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
70     function cashOut (uint256 amount, address recipient) public onlyOwner {
71         compound.withdraw(daiAddress, amount);
72         dai.transfer(recipient, amount);
73     }
74 
75     // Allows you to add or change a salary
76     function changePay(address recipient, uint yearlyPay, uint startingDate, string memory initials) onlyOwner public {
77         // check someone's salary ID
78         uint id = salaryId[recipient];
79         // if it returns 0 then create a new one
80         if (id == 0) {
81             salaryId[recipient] = payroll.length;
82             id = payroll.length++;
83         }
84         payroll[id] = Salary({
85             recipient: recipient, 
86             payRate: yearlyPay / 365.25 days, 
87             lastPaid:  startingDate >  0 ? startingDate : now, 
88             name: initials});
89             
90         payrollLength = payroll.length;
91     }
92 
93     // Removes a salary from the list
94     function removePay(address recipient) onlyOwner public {
95         require(salaryId[recipient] != 0);
96 
97         for (uint i = salaryId[recipient]; i<payroll.length-1; i++){
98             payroll[i] = payroll[i+1];
99             salaryId[payroll[i].recipient] = i;
100         }
101         
102         salaryId[recipient] = 0;
103         delete payroll[payroll.length-1];
104         payroll.length--;
105         payrollLength = payroll.length;
106     }
107     
108     // How much are you owed right now?
109     function getAmountOwed(address recipient) view public returns (uint256) {
110         // get salary ID
111         uint id = salaryId[recipient];
112         if (id > 0) {
113             // If it exists, calculate how much you're owed right now
114             return (now - payroll[id].lastPaid) * payroll[id].payRate;
115         } else {
116             return 0;
117         }
118     }
119     
120     //Make one salary payment
121     function paySalary(address recipient, string memory justification) public {
122         // How much are you owed right now?
123         uint amount = getAmountOwed(recipient);
124         if (amount > 0) return;
125         
126         // Take it out from savings
127         compound.withdraw(daiAddress, amount);
128         
129         // Pay it out
130         payroll[salaryId[recipient]].lastPaid = now;
131         dai.transfer(recipient, amount);
132         emit MemberPaid( recipient,  amount, justification);
133     }
134     
135     // Pay all salaries
136     function payAll() public {
137         for (uint i = 1; i<payroll.length-1; i++){
138             paySalary(payroll[i].recipient, '');
139         }
140     }
141     
142     // If pinged, save and pay everyone
143     function () external payable {
144         putInSavings();
145         payAll();
146         msg.sender.transfer(msg.value);
147     }
148     
149     // pay everyone!
150     // function() external payable {
151     //     uint totalToPay = 0;
152     //     uint payrollLength = payroll.length; 
153     //     uint[] memory payments = new uint[](payrollLength);
154     //     uint amount; 
155        
156     //   for (uint i = 1; i<payrollLength-1; i++){
157     //         amount = (now - payroll[i].lastPaid) * payroll[i].payRate;
158     //         totalToPay += amount;
159     //         payments[i] = amount;
160     //     } 
161         
162     //     compound.withdraw(daiAddress, totalToPay);
163         
164     //     require(dai.balanceOf(address(this)) <= totalToPay);
165         
166     //     for (uint i = 1; i<payrollLength-1; i++){
167     //         payroll[i].lastPaid = now;
168     //         dai.transfer(payroll[i].recipient, payments[i]);
169     //         emit MemberPaid(payroll[i].recipient, payments[i]);
170     //     }  
171                 
172     //     save();
173     //     msg.sender.transfer(msg.value);
174     // }
175 }