1 pragma solidity ^0.5.1;
2 
3 interface CompoundContract {
4     function  supply (address asset, uint256 amount) external returns (uint256);
5     function withdraw (address asset, uint256 requestedAmount) external returns (uint256);
6 }
7 
8 interface token {
9     function transfer(address _to, uint256 _value) external returns (bool success) ;
10     function approve(address _spender, uint256 _value) external returns (bool);
11     function balanceOf(address owner) external returns (uint256);
12 }
13 
14  contract owned {
15         address public owner;
16 
17         constructor() public {
18             owner = msg.sender;
19         }
20 
21         modifier onlyOwner {
22             require(msg.sender == owner);
23             _;
24         }
25 
26         function transferOwnership(address newOwner) onlyOwner public {
27             owner = newOwner;
28         }
29     }
30 
31 contract CompoundPayroll is owned {
32     address compoundAddress = 0x3FDA67f7583380E67ef93072294a7fAc882FD7E7;
33     address daiAddress = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
34     CompoundContract compound = CompoundContract(compoundAddress);
35     token dai = token(daiAddress);
36     Salary[] public payroll;
37     mapping (address => uint) public salaryId;
38     
39     event MemberPaid(address recipient, uint amount);
40     
41     struct Salary {
42         address recipient;
43         uint payRate;
44         uint lastPaid;
45         string name;
46     }
47     
48     constructor() public {
49         owner = msg.sender;
50         dai.approve(compoundAddress, 2 ** 128);
51         changePay(address(0), 0, now, '');
52     }
53     
54     function save() public  {
55         compound.supply(daiAddress, dai.balanceOf(address(this)));
56     }
57     
58     function cashOut (uint256 amount, address recipient) public onlyOwner {
59         compound.withdraw(daiAddress, amount);
60         dai.transfer(recipient, amount);
61     }
62 
63     function changePay(address recipient, uint yearlyPay, uint startingDate, string memory initials) onlyOwner public {
64         uint id = salaryId[recipient];
65         if (id == 0) {
66             salaryId[recipient] = payroll.length;
67             id = payroll.length++;
68         }
69         payroll[id] = Salary({
70             recipient: recipient, 
71             payRate: yearlyPay / 365.25 days, 
72             lastPaid:  startingDate >  0 ? startingDate : now, 
73             name: initials});
74     }
75 
76 
77     function removePay(address recipient) onlyOwner public {
78         require(salaryId[recipient] != 0);
79 
80         for (uint i = salaryId[recipient]; i<payroll.length-1; i++){
81             payroll[i] = payroll[i+1];
82             salaryId[payroll[i].recipient] = i;
83         }
84         
85         salaryId[recipient] = 0;
86         delete payroll[payroll.length-1];
87         payroll.length--;
88     }
89     
90     function getAmountOwed(address recipient) view public returns (uint256) {
91         uint id = salaryId[recipient];
92         if (id > 0) {
93             return (now - payroll[id].lastPaid) * payroll[id].payRate;
94         } else {
95             return 0;
96         }
97     }
98     
99     //pay someone
100     function paySalary(address recipient) public {
101         uint amount = getAmountOwed(recipient);
102         require(amount > 0);
103         compound.withdraw(daiAddress, amount);
104         payroll[salaryId[recipient]].lastPaid = now;
105         emit MemberPaid( recipient,  amount);
106         
107         dai.transfer(recipient, amount);
108     }
109     
110     // pay everyone!
111     function() external payable {
112         uint totalToPay = 0;
113         uint payrollLength = payroll.length; 
114         uint[] memory payments = new uint[](payrollLength);
115         uint amount; 
116        
117       for (uint i = 1; i<payrollLength-1; i++){
118             amount = (now - payroll[i].lastPaid) * payroll[i].payRate;
119             totalToPay += amount;
120             payments[i] = amount;
121         } 
122         
123         compound.withdraw(daiAddress, totalToPay);
124         
125         require(dai.balanceOf(address(this)) <= totalToPay);
126         
127         for (uint i = 1; i<payrollLength-1; i++){
128             payroll[i].lastPaid = now;
129             dai.transfer(payroll[i].recipient, payments[i]);
130             emit MemberPaid(payroll[i].recipient, payments[i]);
131         }  
132                 
133         save();
134         msg.sender.transfer(msg.value);
135     }
136 }