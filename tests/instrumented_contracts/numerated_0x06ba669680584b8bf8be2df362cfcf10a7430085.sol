1 pragma solidity ^0.4.10;
2 /**
3  * Smart Meter Gatway Aministration for StromDAO Stromkonto
4  * ====================================================================
5  * Slot-Link für intelligente Messsysteme zur Freigabe einer Orakel-gesteuerten
6  * Zählrestandsgang-Messung. Wird verwendet zur Emulierung eines autarken 
7  * Lieferanten/Abnehmer Managements in einem HSM oder P2P Markt ohne zentrale
8  * Kontrollstelle.
9  * 
10  * Kontakt V0.1.1: 
11  * Thorsten Zoerner <thorsten.zoerner(at)stromdao.de)
12  * https://stromdao.de/
13  */
14 
15 
16 contract owned {
17      address public owner;
18 
19     function owned() {
20         owner = msg.sender;
21     }
22 
23     modifier onlyOwner {
24         if (msg.sender != owner) throw;
25         _;
26     }
27 
28     function transferOwnership(address newOwner) onlyOwner {
29         owner = newOwner;
30     }
31 }
32 
33 contract GWALink is owned {
34     uint80 constant None = uint80(0); 
35     
36     // Freigaben für einzelne Nodes
37     struct ClearanceLimits {
38         uint256 min_time;
39         uint256 min_power;
40         uint256 max_time;
41         uint256 max_power;
42         address definedBy;
43         bool valid;
44     }
45     
46     // Representation eines Zählerstandes
47     struct ZS {
48         uint256 time;
49         uint256 power_in;
50         uint256 power_out;
51         address oracle;
52     }
53     
54     event recleared(address link);
55     event pinged(address link,uint256 time,uint256 power_in,uint256 power_out);
56     
57     ClearanceLimits public defaultLimits = ClearanceLimits(1,1,86400,1000,owner,true);
58   
59     mapping(address=>ZS) public zss;
60     
61     function changeClearance(uint256 _min_time,uint256 _min_power,uint256 _max_time, uint256 _max_power,bool _clearance) onlyOwner {
62         defaultLimits = ClearanceLimits(_min_time,_min_power,_max_time,_max_power,msg.sender,_clearance);
63     }
64     
65 
66     
67     function changeZS(address link,address oracle,uint256 _power_in,uint256 _power_out) onlyOwner {
68          ZS zs = zss[link];
69          zs.oracle=oracle;
70          zs.time=now;
71          zs.power_in=_power_in;
72          zs.power_out=_power_out;
73          zss[link]=zs;
74         
75     }
76 
77     
78     function ping(address link,uint256 delta_time,uint256 delta_power_in,uint256 delta_power_out) {
79         ClearanceLimits  limits = defaultLimits;
80         if(!limits.valid) {  throw; }
81         if((limits.min_power>delta_power_in)&&(limits.min_power>delta_power_out) ) throw;
82         if((limits.max_power<delta_power_in)&&(limits.max_power<delta_power_out)) throw;
83         if(limits.min_time>delta_time) throw;
84         if(limits.max_time<delta_time) throw;
85         
86         ZS zs = zss[link];
87         
88         if(zs.time==0) {
89             zs.oracle=msg.sender;
90             zs.time=now;
91         } else {
92             if((zs.oracle!=msg.sender) &&(zs.oracle!=owner)) throw;
93         }
94         
95         zs.time+=delta_time;
96         zs.power_in+=delta_power_in;
97         zs.power_out+=delta_power_out;
98         zss[link]=zs;
99         pinged(link,zs.time,zs.power_in,zs.power_out);
100     }
101 }