1 pragma solidity ^0.4.18;
2 
3 
4 
5 contract DragonCrowdsaleCore {
6     
7     function crowdsale( address _address )payable;
8     function precrowdsale( address _address )payable;
9 }
10 
11 contract Dragon {
12     function transfer(address receiver, uint amount)returns(bool ok);
13     function balanceOf( address _address )returns(uint256);
14 }
15 
16 contract DragonCrowdsale {
17     
18     address public owner;
19     Dragon tokenReward;
20     
21    
22     bool public crowdSaleStarted;
23     bool public crowdSaleClosed;
24     bool public  crowdSalePause;
25     
26     uint public deadline;
27     
28     address public CoreAddress;
29     DragonCrowdsaleCore  core;
30     
31     
32     
33     
34     modifier onlyOwner() {
35         if (msg.sender != owner) {
36             throw;
37         }
38         _;
39     }
40 
41     
42     
43     
44     function DragonCrowdsale(){
45         
46         crowdSaleStarted = false;
47         crowdSaleClosed = false;
48         crowdSalePause = false;
49         owner = msg.sender;
50         
51         tokenReward = Dragon( 0x814f67fa286f7572b041d041b1d99b432c9155ee );
52         
53     }
54     
55     // fallback function to receive all incoming ether funds and then forwarded to the DragonCrowdsaleCore contract 
56     function () payable {
57         
58         require ( crowdSaleClosed == false && crowdSalePause == false  );
59         
60         if ( crowdSaleStarted ) { 
61             require ( now < deadline );
62             core.crowdsale.value( msg.value )( msg.sender); // forward all ether to core contract
63             
64         } 
65         else
66         { core.precrowdsale.value( msg.value )( msg.sender); }  // forward all ether to core contract
67        
68     }
69     
70     
71    
72     // Start this to initiate crowdsale - will run for 60 days
73     function startCrowdsale() onlyOwner  {
74         
75         crowdSaleStarted = true;
76         deadline = now + 60 days;
77        
78                 
79     }
80 
81     //terminates the crowdsale
82     function endCrowdsale() onlyOwner  {
83         
84         
85         crowdSaleClosed = true;
86     }
87 
88     //pauses the crowdsale
89     function pauseCrowdsale() onlyOwner {
90         
91         crowdSalePause = true;
92         
93         
94     }
95 
96     //unpauses the crowdsale
97     function unpauseCrowdsale() onlyOwner {
98         
99         crowdSalePause = false;
100         
101         
102     }
103     
104     // set the dragon crowdsalecore contract
105     function setCore( address _core ) onlyOwner {
106         
107         require ( _core != 0x00 );
108         CoreAddress = _core;
109         core = DragonCrowdsaleCore( _core );
110         
111     }
112     
113     function transferOwnership( address _address ) onlyOwner {
114         
115         require ( _address!= 0x00 );
116         owner =  _address ;
117         
118     }
119     
120     
121     //emergency withdrawal of Dragons incase sent to this address
122     function withdrawCrowdsaleDragons() onlyOwner{
123         
124         uint256 balance = tokenReward.balanceOf( address( this ) );
125         tokenReward.transfer( msg.sender , balance );
126         
127         
128     }
129     
130     
131     
132     
133 }