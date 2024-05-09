1 pragma solidity ^0.4.0;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 contract EtherOlympics is Ownable {
44     mapping(bytes3 => uint16) iocCountryCodesToPriceMap;
45     event newTeamCreated(bytes32 teamName, bytes3 country1, bytes3 country2, bytes3 country3,
46         bytes3 country4, bytes3 country5, bytes3 country6);
47     
48     function() public payable { }
49 
50     function EtherOlympics() public {
51         iocCountryCodesToPriceMap['GER'] = 9087;
52         iocCountryCodesToPriceMap['NOR'] = 8748;
53         iocCountryCodesToPriceMap['USA'] = 7051;
54         iocCountryCodesToPriceMap['FRA'] = 6486;
55         iocCountryCodesToPriceMap['CAN'] = 6486;
56         iocCountryCodesToPriceMap['NED'] = 4412;
57         iocCountryCodesToPriceMap['JPN'] = 3544;
58         iocCountryCodesToPriceMap['AUT'] = 3507;
59         iocCountryCodesToPriceMap['SWE'] = 3507;
60         iocCountryCodesToPriceMap['SUI'] = 3431;
61         iocCountryCodesToPriceMap['KOR'] = 3318;
62         iocCountryCodesToPriceMap['CHN'] = 2941;
63         iocCountryCodesToPriceMap['CZE'] = 1961;
64         iocCountryCodesToPriceMap['ITA'] = 1395;
65         iocCountryCodesToPriceMap['AUS'] = 1207;
66         iocCountryCodesToPriceMap['POL'] = 867;
67         iocCountryCodesToPriceMap['GBR'] = 792;
68         iocCountryCodesToPriceMap['FIN'] = 792;
69         iocCountryCodesToPriceMap['BEL'] = 490;
70         iocCountryCodesToPriceMap['SLO'] = 490;
71         iocCountryCodesToPriceMap['SVK'] = 452;
72         iocCountryCodesToPriceMap['LAT'] = 377;
73         iocCountryCodesToPriceMap['LIE'] = 377;
74         iocCountryCodesToPriceMap['BLR'] = 339;
75         iocCountryCodesToPriceMap['HUN'] = 339;
76         iocCountryCodesToPriceMap['ESP'] = 339;
77         iocCountryCodesToPriceMap['NZL'] = 113;
78         iocCountryCodesToPriceMap['UKR'] = 113;
79         iocCountryCodesToPriceMap['KAZ'] = 113;
80         iocCountryCodesToPriceMap['IRL'] = 50;
81         iocCountryCodesToPriceMap['JAM'] = 50;
82         iocCountryCodesToPriceMap['SRB'] = 50;
83         iocCountryCodesToPriceMap['PHI'] = 50;
84         iocCountryCodesToPriceMap['IND'] = 50;
85         iocCountryCodesToPriceMap['THA'] = 50;
86         iocCountryCodesToPriceMap['MEX'] = 50;
87         iocCountryCodesToPriceMap['PRK'] = 50;
88         iocCountryCodesToPriceMap['BRA'] = 50;
89         iocCountryCodesToPriceMap['EST'] = 50;
90         iocCountryCodesToPriceMap['GHA'] = 50;
91         iocCountryCodesToPriceMap['GRE'] = 50;
92         iocCountryCodesToPriceMap['ISL'] = 50;
93 
94     }
95 
96     function createTeam(bytes32 _teamName, bytes3 _country1, bytes3 _country2, bytes3 _country3,   bytes3 _country4, bytes3 _country5, bytes3 _country6) public payable {
97         require (msg.value > 99999999999999999);
98         
99         require (block.number < 5100000);
100 
101         require (_country1 != _country2);
102         require (_country1 != _country3);
103         require (_country1 != _country4);
104         require (_country1 != _country5);
105         require (_country1 != _country6);
106         require (_country2 != _country3);
107         require (_country2 != _country4);
108         require (_country2 != _country5);
109         require (_country2 != _country6);
110         require (_country3 != _country4);
111         require (_country3 != _country5);
112         require (_country3 != _country6);
113         require (_country4 != _country5);
114         require (_country4 != _country6);
115         require (_country5 != _country6);
116 
117         require (iocCountryCodesToPriceMap[_country1] > 0);
118         require (iocCountryCodesToPriceMap[_country2] > 0);
119         require (iocCountryCodesToPriceMap[_country3] > 0);
120         require (iocCountryCodesToPriceMap[_country4] > 0);
121         require (iocCountryCodesToPriceMap[_country5] > 0);
122         require (iocCountryCodesToPriceMap[_country6] > 0);
123 
124         require (iocCountryCodesToPriceMap[_country1] +
125         iocCountryCodesToPriceMap[_country2] +
126         iocCountryCodesToPriceMap[_country3] +
127         iocCountryCodesToPriceMap[_country4] +
128         iocCountryCodesToPriceMap[_country5] +
129         iocCountryCodesToPriceMap[_country6] < 12000);
130         
131         newTeamCreated( _teamName, _country1, _country2, _country3, _country4, _country5, _country6);
132 
133     }
134 
135     function withdraw(address payTo, uint256 amount) onlyOwner {
136         require(amount <= this.balance);
137         assert(payTo.send(amount));
138     }
139 
140 }