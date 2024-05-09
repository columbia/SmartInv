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
38     /*  at initialization, setup the owner */
39     function Private_Fund(address _creator, address _beneficiary, uint256 _duration) {
40         creator = _creator;
41         beneficiary = _beneficiary;
42         start = now;
43         //deadline = _start + _duration * 1 days;
44         deadline = start + _duration * 1 minutes;
45     }   
46     
47     /* The function without name is the default function that is called whenever anyone sends funds to a contract */
48     function () payable {
49         if(now < start) throw;
50         if(now >= deadline) throw;
51         
52         uint amount = msg.value;
53         funders[funders.length++] = Funder({addr: msg.sender, amount: amount});
54         amountRaised += amount;
55         FundTransfer(msg.sender, amount, true);
56     }
57         
58 
59     /* checks if the goal or time limit has been reached and ends the campaign */
60     function withdraw_privatefund(bool _withdraw_en) afterDeadline onlyCreator{
61         if (_withdraw_en){
62             beneficiary.send(amountRaised);
63             FundTransfer(beneficiary, amountRaised, false);
64         } else {
65             FundTransfer(0, 11, false);
66             for (uint i = 0; i < funders.length; ++i) {
67               funders[i].addr.send(funders[i].amount);  
68               FundTransfer(funders[i].addr, funders[i].amount, false);
69             }               
70         }
71     }
72     
73     function kill() {
74       suicide(beneficiary);
75     }
76 }