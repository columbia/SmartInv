1 contract Base 
2 {
3     function add(uint256 x, uint256 y) internal returns (uint256) {
4         uint256 z = x + y;
5         if((z >= x) && (z >= y))
6         {
7           return z;
8         }
9         else
10         {
11             throw;
12         }
13         
14     }
15 
16     function sub(uint256 x, uint256 y) internal returns (uint256) {
17         if(x >= y)
18         {
19            uint256 z = x - y;
20            return z;
21         }
22         else
23         {
24             throw;
25         }
26     }
27 
28     function mul(uint256 x, uint256 y) internal returns (uint256) {
29         uint256 z = x * y;
30         if((x == 0) || (z / x == y))
31         {
32             return z;
33         }
34         else
35         {
36             throw;
37         }
38     }
39     
40     address Owner_01;
41     address Owner_02;
42     address Owner_03;
43     
44     function Base()
45     {
46         Owner_01 = msg.sender;
47     }
48     
49     event Deposit(address indexed sender, uint value);
50     event Withdraw(address indexed sender, uint value);
51     event Log(string message);
52 }
53 
54 contract SiriusFund is Base
55 {
56     uint public TotalInvested;
57     uint public Available;
58     uint public InvestorsQty;
59     mapping (address => uint) public Investors;
60     address Owner_0l;
61     address Owner_02;
62     address Owner_03;
63     
64     function initSiriusFund()
65     {
66         Owner_0l = msg.sender;
67     }
68     
69     function SetScndOwner(address addr) public anyOwner
70     {
71         Owner_02 = addr;
72     }
73     
74     function SetThrdOwner(address addr) public anyOwner
75     {
76         Owner_03 = addr;
77     }
78     
79     function() 
80     {
81         DepositFund();
82     }
83     
84     function DepositFund() public
85     {
86         if(msg.value>= 1 ether)
87         {
88             if(Investors[msg.sender]==0)InvestorsQty++;
89             Investors[msg.sender]+=msg.value;
90             TotalInvested+=msg.value;
91             Available+=msg.value;
92             Deposit(msg.sender,msg.value);
93         }   
94     }
95     
96     function withdraw(address _addr, uint _wei) public anyOwner
97     {
98         if(Investors[_addr]==0)throw;
99         if(_addr.send(_wei))
100         {
101              Available-=_wei;
102              Withdraw(_addr,_wei);
103         }
104     }
105     
106     modifier anyOwner()
107     {
108         if ( msg.sender != Owner_01 && msg.sender != Owner_02 && msg.sender != Owner_03)throw;
109         _
110     }
111 }