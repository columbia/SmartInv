1 pragma solidity ^ 0.4.11;
2 
3 
4 contract Dragon {
5     function transfer( address _to, uint256 _amount )returns(bool ok);
6 }
7 
8 
9 contract DragonDistributions {
10     
11 
12     address public dragon;
13     uint256 public clock;
14     address public prime;
15     address public film;
16     address public northadvisor;
17     address public southadvisor;
18     
19     uint public filmamount;
20     bool public filmpaid;
21     
22     mapping ( address => uint256 ) public  balanceOf;
23     mapping ( address => bool ) public  distributionOne;
24     mapping ( address => bool ) public  distributionTwo;
25     mapping ( address => bool ) public  distributionThree;
26     mapping ( address => bool ) public  advisors;
27    
28     uint256 public awardAmount       =  45000000000000;
29     uint256 public awardAmountPrime  = 100000000000000;
30     
31     
32     
33     
34     
35     function DragonDistributions () {
36         
37         dragon = 0x814F67fA286f7572B041D041b1D99b432c9155Ee; // Hard code Dragon address
38         prime =  0x243098c1e16973c7e3e969c289c5b87808e359c1; // prime Advisor Address
39         film =   0xdFCf69C8FeD25F5150Db719BAd4EfAb64F628d31;// filmmaker address
40         
41         northadvisor = 0x74Fc8fA4F99b6c19C250E4Fc6952051a95F6060D;
42         southadvisor = 0xCC3c6A89B5b8a054f21bCEff58B6429447cd8e5E;
43         
44         clock = now;
45         
46         filmamount = 2500000000000;
47         
48         balanceOf[ film ] = awardAmount + filmamount; // award amount plus film maker
49         balanceOf[ northadvisor ] = awardAmount;
50         balanceOf[ southadvisor ] = awardAmount;
51         
52         balanceOf[ prime ] = awardAmountPrime;
53         
54         advisors [ film ] = true;
55         advisors [ northadvisor ] = true;
56         advisors [ southadvisor ] = true;
57         
58         filmpaid = false;
59         
60         
61         
62         
63     }
64     
65      modifier onlyPrime() {
66         if (msg.sender != prime) {
67             throw;
68         }
69         _;
70     }
71 
72     modifier onlyFilm() {
73         if ( msg.sender != film ) {
74             throw;
75         }
76         _;
77     }
78 
79 
80     function withdrawDragons()
81     {
82         uint256 total = 0;
83         
84         require ( advisors[msg.sender] == true );
85         
86         Dragon drg = Dragon ( dragon );
87         
88         if ( distributionOne[ msg.sender ] == false ){
89             distributionOne[ msg.sender ] = true;
90             total += 15000000000000;
91             balanceOf[ msg.sender ] -= 15000000000000; 
92             
93         }
94         
95         if ( distributionTwo[ msg.sender ] == false && now > clock + 22 days  ){
96             
97             
98             distributionTwo[ msg.sender ] = true;
99             total += 15000000000000;
100             balanceOf[ msg.sender ] -= 15000000000000; 
101             
102         }
103         
104         if ( distributionThree[ msg.sender ] == false && now > clock + 387 days ){
105             distributionThree[ msg.sender ] = true;
106             total += 15000000000000;
107             balanceOf[ msg.sender ] -= 15000000000000; 
108             
109         }
110         
111         
112         drg.transfer ( msg.sender, total);
113         
114         
115     } 
116     
117     
118     function withdrawDragonsPrime() onlyPrime {
119         
120          uint _amount = balanceOf[ prime ];
121          balanceOf[ prime ] = 0; 
122          Dragon drg = Dragon ( dragon );
123          drg.transfer ( prime , _amount );
124  
125     }
126     
127     function withdrawDragonsFilm() onlyFilm {
128         
129         if ( filmpaid == true ) throw;
130          filmpaid = true;
131          uint _amount = filmamount;
132          balanceOf[ film ] -= filmamount; 
133          Dragon drg = Dragon ( dragon );
134          drg.transfer ( film , _amount );
135  
136     }
137     
138 }