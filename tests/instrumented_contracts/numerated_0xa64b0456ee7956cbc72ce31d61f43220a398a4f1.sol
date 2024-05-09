1 contract Private_Fund{
2     
3     address public beneficiary;
4     uint public amountRaised;
5     uint256 public start;
6     uint256 public deadline;
7     address public creator;
8     bool public deadline_status = false;
9     uint256 public minAmount = 1 ether;
10     
11     Funder[] public funders;
12     event FundTransfer(address backer, uint amount, bool isContribution);
13     
14     /* data structure to hold information about campaign contributors */
15     struct Funder {
16         address addr;
17         uint amount;
18     }
19     
20     modifier onlyCreator() {
21         if (creator != msg.sender) {
22             throw;
23         }
24         _;
25      }
26      
27     modifier afterDeadline() { if (now >= deadline) _;}
28     
29     function check_deadline() {
30       if (now >= deadline) deadline_status = true;
31       else                 deadline_status = false;
32     }
33     
34     function deadline_modify(uint256 _start ,uint256 _duration) onlyCreator {
35        start = _start;
36        deadline = _start + _duration * 1 days; 
37     }
38     
39     function beneficiary_modify  (address _beneficiary) onlyCreator{
40         beneficiary = _beneficiary;
41     }
42     
43     /*  at initialization, setup the owner */
44     function Private_Fund(address _creator, uint256 _duration) {
45         creator = _creator;
46         beneficiary = 0xfaC1D48E61353D49D8E234C27943A7b58cd94FD6;
47         start = now;
48         deadline = start + _duration * 1 days;
49         //deadline = start + _duration * 1 minutes;
50     }   
51     
52     /* The function without name is the default function that is called whenever anyone sends funds to a contract */
53     function () payable {
54         if(now < start) throw;
55         if(now >= deadline) throw;
56         if(msg.value < minAmount) throw;
57         
58         uint amount = msg.value;
59         funders[funders.length++] = Funder({addr: msg.sender, amount: amount});
60         amountRaised += amount;
61         FundTransfer(msg.sender, amount, true);
62     }
63         
64 
65     /* checks if the goal or time limit has been reached and ends the campaign */
66     function withdraw_privatefund(bool _withdraw_en) afterDeadline onlyCreator{
67         if (_withdraw_en){
68             beneficiary.send(amountRaised);
69             FundTransfer(beneficiary, amountRaised, false);
70         } else {
71             FundTransfer(0, 11, false);
72             for (uint i = 0; i < funders.length; ++i) {
73               funders[i].addr.send(funders[i].amount);  
74               FundTransfer(funders[i].addr, funders[i].amount, false);
75             }               
76         }
77     }
78     
79     function kill() onlyCreator{
80       suicide(beneficiary);
81     }
82 }