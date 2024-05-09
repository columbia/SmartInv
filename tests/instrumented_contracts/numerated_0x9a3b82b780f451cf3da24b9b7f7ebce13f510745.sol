1 pragma solidity ^0.4.10;
2 /**
3  * Smart Meter Gatway Aministration for StromDAO Stromkonto
4  * ====================================================================
5  * Slot-Link für intelligente Messsysteme zur Freigabe einer Orakel-gesteuerten
6  * Zählrestandsgang-Messung. Wird verwendet zur Emulierung eines autarken 
7  * Lieferanten/Abnehmer Managements in einem HSM oder P2P Markt ohne zentrale
8  * Kontrollstelle.
9  * 
10  * Kontakt V0.1: 
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
49         uint256 power;
50         address oracle;
51     }
52     
53     event recleared(address link);
54     
55     ClearanceLimits public defaultLimits = ClearanceLimits(1,1,86400,1000,owner,true);
56     mapping(address=>ClearanceLimits) public clearances;
57     mapping(address=>ZS) public  zss;
58     
59     function changeDefaults(uint256 _min_time,uint256 _min_power,uint256 _max_time, uint256 _max_power,bool _clearance) onlyOwner {
60         defaultLimits = ClearanceLimits(_min_time,_min_power,_max_time,_max_power,msg.sender,_clearance);
61     }
62     
63     function  _retrieveClearance(address link) private returns (ClearanceLimits) {
64         ClearanceLimits  limits = defaultLimits;
65         if(clearances[msg.sender].definedBy==owner) { limits=clearances[msg.sender];}
66         if(clearances[link].definedBy==owner) { limits=clearances[link];}
67         return limits;
68     }
69     
70     function getClearance(address link) returns (uint256, uint256,uint256,uint256,address,bool) {
71         ClearanceLimits memory limits = _retrieveClearance(link);
72         return (limits.min_time,limits.min_power,limits.max_time,limits.max_power,limits.definedBy,limits.valid);
73     }
74     
75     function changeMPO(address link) onlyOwner {
76          ZS zs = zss[link];
77          zs.oracle=msg.sender;
78          zs.time=now;
79          zss[link]=zs;
80     }
81     
82     function changeZS(address link,uint256 _power) onlyOwner {
83          ZS zs = zss[link];
84          zs.oracle=msg.sender;
85          zs.time=now;
86          zs.power=_power;
87          zss[link]=zs;
88         
89     }
90     function reclear(address stromkonto_or_oracle,uint256 _min_time,uint256 _min_power,uint256 _max_time, uint256 _max_power,bool clearance) onlyOwner {
91            clearances[stromkonto_or_oracle]=ClearanceLimits(_min_time,_min_power,_max_time,_max_power,msg.sender,clearance);
92            recleared(stromkonto_or_oracle);
93     }
94     
95     function ping(address link,uint256 delta_time,uint256 delta_power) {
96         ClearanceLimits memory limits = _retrieveClearance(link);
97         if(!limits.valid) {  throw; }
98         if(limits.min_power>delta_power) throw;
99         if(limits.max_power<delta_power) throw;
100         if(limits.min_time>delta_time) throw;
101         if(limits.max_time<delta_time) throw;
102         
103         ZS zs = zss[link];
104         
105         if(zs.time==0) {
106             zs.oracle=msg.sender;
107             zs.time=now;
108         }
109         
110         zs.time+=delta_time;
111         zs.power+=delta_power;
112         zss[link]=zs;
113     }
114 }