1 pragma solidity 0.4.24;
2 
3 
4 interface ChickenHunt {
5 
6   /* FUNCTION */
7 
8   function callFor(
9     address _to, 
10     uint256 _value, 
11     uint256 _gas, 
12     bytes _code
13   ) external payable returns (bool);
14 
15   function addPet(
16     uint256 _huntingPower,
17     uint256 _offensePower,
18     uint256 _defense,
19     uint256 _chicken,
20     uint256 _ethereum,
21     uint256 _max
22   ) external;
23 
24   function changePet(
25     uint256 _id,
26     uint256 _chicken,
27     uint256 _ethereum,
28     uint256 _max
29   ) external;
30 
31   function addItem(
32     uint256 _huntingMultiplier,
33     uint256 _offenseMultiplier,
34     uint256 _defenseMultiplier,
35     uint256 _price
36   ) external;
37 
38   function setDepot(uint256 _price, uint256 _max) external;
39 
40   function setConfiguration(
41     uint256 _chickenA,
42     uint256 _ethereumA,
43     uint256 _maxA,
44     uint256 _chickenB,
45     uint256 _ethereumB,
46     uint256 _maxB
47   ) external;
48 
49   function setDistribution(
50     uint256 _dividendRate,
51     uint256 _altarCut,
52     uint256 _storeCut,
53     uint256 _devCut
54   )
55     external;
56 
57   function setCooldownTime(uint256 _cooldownTime) external;
58   function setNameAndSymbol(string _name, string _symbol) external;
59   function setDeveloper(address _developer) external;
60   function join() external;
61   function withdraw() external;
62 
63 }
64 
65 
66 /**
67  * @title ChickenHuntCommittee
68  * @author M.H. Kang
69  * @notice Wrapper solution to unintended flaw that
70  * the committee could use ChickenHunt contract ether with callFor function.
71  * This vulnerability was discovered by 'blah'. I appreciate it!
72  */
73 contract CHCommitteeWrapper {
74 
75   /* STORAGE */
76 
77   ChickenHunt public chickenHunt;
78   address public committee;
79 
80   /* CONSTRUCTOR */
81 
82   constructor(address _chickenHunt) public {
83     committee = msg.sender;
84     chickenHunt = ChickenHunt(_chickenHunt);
85     chickenHunt.join();
86   }
87 
88   /* FUNCTION */
89 
90   function () public payable {}
91 
92   function callFor(address _to, uint256 _gas, bytes _code)
93     external
94     payable
95     onlyCommittee
96     returns (bool)
97   {
98     return chickenHunt.callFor.value(msg.value)(_to, msg.value, _gas, _code);
99   }
100 
101   function addPet(
102     uint256 _huntingPower,
103     uint256 _offensePower,
104     uint256 _defense,
105     uint256 _chicken,
106     uint256 _ethereum,
107     uint256 _max
108   )
109     external
110     onlyCommittee
111   {
112     chickenHunt.addPet(
113       _huntingPower, 
114       _offensePower, 
115       _defense, 
116       _chicken, 
117       _ethereum, 
118       _max
119     );
120   }
121 
122   function changePet(
123     uint256 _id,
124     uint256 _chicken,
125     uint256 _ethereum,
126     uint256 _max
127   )
128     external
129     onlyCommittee
130   {
131     chickenHunt.changePet(
132       _id,
133       _chicken,
134       _ethereum,
135       _max
136     );
137   }
138 
139   function addItem(
140     uint256 _huntingMultiplier,
141     uint256 _offenseMultiplier,
142     uint256 _defenseMultiplier,
143     uint256 _price
144   )
145     external
146     onlyCommittee
147   {
148     chickenHunt.addItem(
149       _huntingMultiplier,
150       _offenseMultiplier,
151       _defenseMultiplier,
152       _price
153     );
154   }
155 
156   function setDepot(uint256 _price, uint256 _max) external onlyCommittee {
157     chickenHunt.setDepot(_price, _max);
158   }
159 
160   function setConfiguration(
161     uint256 _chickenA,
162     uint256 _ethereumA,
163     uint256 _maxA,
164     uint256 _chickenB,
165     uint256 _ethereumB,
166     uint256 _maxB
167   )
168     external
169     onlyCommittee
170   {
171     chickenHunt.setConfiguration(
172       _chickenA,
173       _ethereumA,
174       _maxA,
175       _chickenB,
176       _ethereumB,
177       _maxB
178     );
179   }
180 
181   function setDistribution(
182     uint256 _dividendRate,
183     uint256 _altarCut,
184     uint256 _storeCut,
185     uint256 _devCut
186   )
187     external
188     onlyCommittee
189   {
190     chickenHunt.setDistribution(
191       _dividendRate,
192       _altarCut,
193       _storeCut,
194       _devCut
195     );
196   }
197 
198   function setCooldownTime(uint256 _cooldownTime) external onlyCommittee {
199     chickenHunt.setCooldownTime(_cooldownTime);
200   }
201 
202   function setNameAndSymbol(string _name, string _symbol)
203     external
204     onlyCommittee
205   {
206     chickenHunt.setNameAndSymbol(_name, _symbol);
207   }
208 
209   function setDeveloper(address _developer) external onlyCommittee {
210     chickenHunt.setDeveloper(_developer);
211   }
212 
213   function withdraw() external {
214     chickenHunt.withdraw();
215     committee.transfer(address(this).balance);
216   }
217 
218   function setCommittee(address _committee) external onlyCommittee {
219     committee = _committee;
220   }
221 
222   /* MODIFIER */
223 
224   modifier onlyCommittee {
225     require(msg.sender == committee);
226     _;
227   }
228 
229 }