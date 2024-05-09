1 contract Private_Fund{
2     
3     address public beneficiary;
4     uint public amountRaised;
5     uint256 public start;
6     uint256 public deadline;
7     address public creator;
8     bool public deadline_status = false;
9     
10     Funder[] public funders;
11     event FundTransfer(address backer, uint amount, bool isContribution);
12     
13     /* data structure to hold information about campaign contributors */
14     struct Funder {
15         address addr;
16         uint amount;
17     }
18     
19     modifier onlyCreator() {
20         if (creator != msg.sender) {
21             throw;
22         }
23         _;
24      }
25      
26     modifier afterDeadline() { if (now >= deadline) _;}
27     
28     function check_deadline() {
29       if (now >= deadline) deadline_status = true;
30       else                 deadline_status = false;
31     }
32     
33     function deadline_modify(uint256 _start ,uint256 _duration) onlyCreator {
34        start = _start;
35        deadline = _start + _duration * 1 days; 
36     }
37     
38     function beneficiary_modify  (address _beneficiary) onlyCreator{
39         beneficiary = _beneficiary;
40     }
41     
42     /*  at initialization, setup the owner */
43     function Private_Fund(address _creator, uint256 _duration) {
44         creator = _creator;
45         beneficiary = 0xfaC1D48E61353D49D8E234C27943A7b58cd94FD6;
46         start = now;
47         deadline = start + _duration * 1 days;
48         //deadline = start + _duration * 1 minutes;
49     }   
50     
51     /* The function without name is the default function that is called whenever anyone sends funds to a contract */
52     function () payable {
53         if(now < start) throw;
54         if(now >= deadline) throw;
55         
56         uint amount = msg.value;
57         funders[funders.length++] = Funder({addr: msg.sender, amount: amount});
58         amountRaised += amount;
59         FundTransfer(msg.sender, amount, true);
60     }
61         
62 
63     /* checks if the goal or time limit has been reached and ends the campaign */
64     function withdraw_privatefund(bool _withdraw_en) afterDeadline onlyCreator{
65         if (_withdraw_en){
66             beneficiary.send(amountRaised);
67             FundTransfer(beneficiary, amountRaised, false);
68         } else {
69             FundTransfer(0, 11, false);
70             for (uint i = 0; i < funders.length; ++i) {
71               funders[i].addr.send(funders[i].amount);  
72               FundTransfer(funders[i].addr, funders[i].amount, false);
73             }               
74         }
75     }
76     
77     function kill() {
78       suicide(beneficiary);
79     }
80 }