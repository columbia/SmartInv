1 pragma solidity ^0.4.24;
2 
3 /*
4 // © 2018 SafeBlocks LTD.  All rights reserved.
5 
6   _____            __          ____    _                  _
7  / ____|          / _|        |  _ \  | |                | |
8 | (___     __ _  | |_    ___  | |_) | | |   ___     ___  | | __  ___
9  \___ \   / _` | |  _|  / _ \ |  _ <  | |  / _ \   / __| | |/ / / __|
10  ____) | | (_| | | |   |  __/ | |_) | | | | (_) | | (__  |   <  \__ \
11 |_____/   \__,_| |_|    \___| |____/  |_|  \___/   \___| |_|\_\ |___/
12 
13 
14 // @author SafeBlocks
15 // @date 30/04/2018
16 */
17 contract SafeBlocksFirewall {
18 
19     event EnquireResult(address sourceAddress, bool approved, address token, uint amount, address destination, uint blockNumber, string msg);
20     event PolicyChanged(address contractAddress, address destination, address tokenAdress, uint limit);
21     event ConfigurationChanged(address sender, address newConfiguration, string message);
22 
23     address owner;
24     address rulesOwner;
25     address proxyContract;
26     bool verbose;
27 
28     mapping(address /*contractId*/ => LimitsRule) limitsRule;
29     mapping(address /*contractId*/ => uint) lastSuccessPerContract;
30     mapping(address /*contractId*/ => mapping(address /*destination*/ => uint)) lastSuccessPerContractPerDestination;
31     mapping(address /*contractId*/ => bool) blockAll;
32     mapping(address /*contractId*/ => bool) enforceBypass;
33     mapping(address /*contractId*/ => mapping(address /*destination*/ => mapping(address /*tokenAddress*/ => uint256 /*limit*/))) customerRules;
34 
35     struct LimitsRule {
36         uint perAddressLimit;
37         uint globalLimit;
38     }
39 
40     constructor() public {
41         owner = msg.sender;
42         verbose = true;
43     }
44 
45     //*************************************** modifiers ****************************************
46 
47     modifier onlyContractOwner {
48         require(owner == msg.sender, "You are not allowed to run this function, required role: Contract-Owner");
49         _;
50     }
51 
52     modifier onlyRulesOwner {
53         require(rulesOwner == msg.sender, "You are not allowed to run this function, required role: Rules-Owner");
54         _;
55     }
56 
57     modifier onlyProxy {
58         require(proxyContract == msg.sender, "You are not allowed to run this function, required role: SafeBlocks-Proxy");
59         _;
60     }
61 
62     //*************************************** setters ****************************************
63 
64     function setProxyContract(address _proxy)
65     onlyContractOwner
66     public {
67         proxyContract = _proxy;
68         emit ConfigurationChanged(msg.sender, _proxy, "a new proxy contract address has been assigned");
69     }
70 
71     function setRulesOwner(address _rulesOwner)
72     public
73     onlyContractOwner {
74         rulesOwner = _rulesOwner;
75         emit ConfigurationChanged(msg.sender, _rulesOwner, "a new Rules-Owner has been assigned");
76     }
77 
78     function setVerbose(bool _verbose)
79     onlyContractOwner
80     public {
81         verbose = _verbose;
82         emit ConfigurationChanged(msg.sender, msg.sender, "a new Verbose-Mode has been assigned");
83     }
84 
85     //*************************************** firewall functionality ****************************************
86 
87     function setBypassPerContract(address _contractAddress, bool _bypass)
88     onlyRulesOwner
89     public {
90         if (verbose) emit PolicyChanged(_contractAddress, address(0), address(0), _bypass ? 1 : 0);
91         enforceBypass[_contractAddress] = _bypass;
92         //to maintain default true we check if the enforce is set to *false*
93     }
94 
95     function setBlockAllPerContract(address _contractId, bool _isBlocked)
96     onlyRulesOwner
97     public {
98         if (verbose) emit PolicyChanged(_contractId, address(0), address(0), 0);
99         blockAll[_contractId] = _isBlocked;
100     }
101 
102     function setPerAddressLimit(address _contractId, uint _limit)
103     onlyRulesOwner
104     public {
105         if (verbose) emit PolicyChanged(_contractId, address(0), address(0), _limit);
106         limitsRule[_contractId].perAddressLimit = _limit;
107     }
108 
109     function setGlobalLimit(address _contractId, uint _limit)
110     onlyRulesOwner
111     public {
112         if (verbose) emit PolicyChanged(_contractId, address(0), address(0), _limit);
113         limitsRule[_contractId].globalLimit = _limit;
114     }
115 
116     function addRule(address _contractId, address _destination, address _token, uint256 _tokenLimit)
117     onlyRulesOwner
118     public {
119         if (verbose) emit PolicyChanged(_contractId, _destination, _token, _tokenLimit);
120         customerRules[_contractId][_destination][_token] = _tokenLimit;
121     }
122 
123     function removeRule(address _contractId, address _destination, address _token)
124     onlyRulesOwner
125     public {
126         if (verbose) emit PolicyChanged(_contractId, _destination, _token, 0);
127         delete customerRules[_contractId][_destination][_token];
128     }
129 
130     function allowTransaction(address _contractAddress, uint _amount, address _destination, address _token)
131     public
132     onlyProxy
133     returns (bool){
134         if (enforceBypass[_contractAddress]) {
135             if (verbose) emit EnquireResult(_contractAddress, true, _token, _amount, _destination, block.number, "1");
136             return true;
137         }
138         if (blockAll[_contractAddress]) {//if block all activated for this contract, deny all
139             if (verbose) emit EnquireResult(_contractAddress, false, _token, _amount, _destination, block.number, "2");
140             return false;
141         }
142         uint256 limit = customerRules[_contractAddress][_destination][_token];
143         uint256 anyDestinationLimit = customerRules[_contractAddress][0x0][_token];
144 
145         if (limit == 0 && anyDestinationLimit == 0) {//no rules ?? deny all
146             if (verbose) emit EnquireResult(_contractAddress, false, _token, _amount, _destination, block.number, "3");
147             return false;
148         }
149         if (anyDestinationLimit > 0 && limit == 0) {
150             limit = anyDestinationLimit;
151         }
152         if (_amount <= limit) {
153             if (limitsRule[_contractAddress].perAddressLimit == 0 && limitsRule[_contractAddress].globalLimit == 0) {
154                 if (verbose) emit EnquireResult(_contractAddress, true, _token, _amount, _destination, block.number, "4");
155                 return true;
156             }
157             // no need to record and check rate limits;
158             if (checkTimeFrameLimit(_contractAddress)) {
159                 if (checkAddressLimit(_contractAddress, _destination)) {
160                     lastSuccessPerContract[_contractAddress] = block.number;
161                     lastSuccessPerContractPerDestination[_contractAddress][_destination] = block.number;
162                     if (verbose) emit EnquireResult(_contractAddress, true, _token, _amount, _destination, block.number, "5");
163                     return true;
164                 }
165             }
166         }
167         if (verbose) emit EnquireResult(_contractAddress, false, _token, _amount, _destination, block.number, "6");
168         return false;
169     }
170 
171     //*************************************** private ****************************************
172 
173     function checkAddressLimit(address _contractId, address _destination)
174     private
175     view
176     returns (bool){
177         if (lastSuccessPerContractPerDestination[_contractId][_destination] > 0) {
178             if (block.number - lastSuccessPerContractPerDestination[_contractId][_destination] < limitsRule[_contractId].perAddressLimit) {
179                 return false;
180             }
181         }
182         return true;
183     }
184 
185     function checkTimeFrameLimit(address _contractId)
186     private
187     view
188     returns (bool) {
189         if (lastSuccessPerContract[_contractId] > 0) {
190             if (block.number - lastSuccessPerContract[_contractId] < limitsRule[_contractId].globalLimit) {
191                 return false;
192             }
193         }
194         return true;
195     }
196 
197     //*************************************** getters ****************************************
198 
199     function getLimits(address _contractId)
200     public
201     view
202     onlyContractOwner
203     returns (uint, uint){
204         return (limitsRule[_contractId].perAddressLimit, limitsRule[_contractId].globalLimit);
205     }
206 
207     function getLastSuccessPerContract(address _contractId)
208     public
209     view
210     onlyContractOwner
211     returns (uint){
212         return (lastSuccessPerContract[_contractId]);
213     }
214 
215     function getLastSuccessPerContractPerDestination(address _contractId, address _destination)
216     public
217     view
218     onlyContractOwner
219     returns (uint){
220         return (lastSuccessPerContractPerDestination[_contractId][_destination]);
221     }
222 
223     function getBlockAll(address _contractId)
224     public
225     view
226     onlyContractOwner
227     returns (bool){
228         return (blockAll[_contractId]);
229     }
230 
231     function getEnforceBypass(address _contractId)
232     public
233     view
234     onlyContractOwner
235     returns (bool){
236         return (enforceBypass[_contractId]);
237     }
238 
239     function getCustomerRules(address _contractId, address _destination, address _tokenAddress)
240     public
241     view
242     onlyContractOwner
243     returns (uint256){
244         return (customerRules[_contractId][_destination][_tokenAddress]);
245     }
246 }
247 // © 2018 SafeBlocks LTD.  All rights reserved.