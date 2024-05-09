1 pragma solidity ^0.4.18;
2 
3 
4 
5 contract OsherCrowdsaleCore {
6     
7     function crowdsale( address _address )payable;
8     function precrowdsale( address _address )payable;
9 }
10 
11 contract OsherCrowdsale {
12     
13     address public owner;
14     
15     
16    
17     bool public crowdSaleStarted;
18     bool public crowdSaleClosed;
19     bool public  crowdSalePause;
20     
21     uint public crowdSaleStartTime;
22     uint public preicostarted;
23     
24     uint public deadline;
25     
26     address public CoreAddress;
27     OsherCrowdsaleCore  core;
28     
29     
30     
31     
32     modifier onlyOwner() {
33         if (msg.sender != owner) {
34             throw;
35         }
36         _;
37     }
38 
39     
40     
41     
42     function OsherCrowdsale(){
43         
44         crowdSaleStarted = false;
45         crowdSaleClosed = false;
46         crowdSalePause = false;
47         preicostarted = now;
48         owner = msg.sender;
49         
50     }
51     
52     // fallback function to receive all incoming ether funds and then forwarded to the DragonCrowdsaleCore contract 
53     function () payable {
54         
55         require ( crowdSaleClosed == false && crowdSalePause == false  );
56         
57         if ( crowdSaleStarted ) { 
58             require ( now < deadline );
59             core.crowdsale.value( msg.value )( msg.sender); 
60             
61         } 
62         else
63         { core.precrowdsale.value( msg.value )( msg.sender); }
64        
65     }
66     
67     
68    
69     // Start this to initiate crowdsale - will run for 60 days
70     function startCrowdsale() onlyOwner  {
71         
72         crowdSaleStarted = true;
73         crowdSaleStartTime = now;
74         deadline = now + 60 days;
75        
76                 
77     }
78 
79     //terminates the crowdsale
80     function endCrowdsale() onlyOwner  {
81         
82         
83         crowdSaleClosed = true;
84     }
85 
86     //pauses the crowdsale
87     function pauseCrowdsale() onlyOwner {
88         
89         crowdSalePause = true;
90         
91         
92     }
93 
94     //unpauses the crowdsale
95     function unpauseCrowdsale() onlyOwner {
96         
97         crowdSalePause = false;
98         
99         
100     }
101     
102     // set the dragon crowdsalecore contract
103     function setCore( address _core ) onlyOwner {
104         
105         require ( _core != 0x00 );
106         CoreAddress = _core;
107         core = OsherCrowdsaleCore( _core );
108         
109     }
110     
111     function transferOwnership( address _address ) onlyOwner {
112         
113         require ( _address!= 0x00 );
114         owner =  _address ;
115         
116     }
117     
118     
119     
120     
121     
122     
123     
124 }