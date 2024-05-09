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
19     event AllowTransactionEnquireResult(address sourceAddress, bool approved, address token, uint amount, address destination, string msg);
20     event AllowAccessEnquireResult(address sourceAddress, bool approved, address destination, bytes4 functionSig, string msg);
21     event PolicyChanged(address contractAddress, address destination, address tokenAdress, uint limit);
22     event AccessChanged(address contractAddress, address destination, bytes4 functionSig, bool hasAccess);
23     event ConfigurationChanged(address sender, address newConfiguration, string message);
24 
25     enum PolicyType {//Order matters(!)
26         Transactions, //int value 0
27         Access        //int value 1
28     }
29 
30     enum PolicyEnforcementStatus {//Order matters(!)
31         BlockAll, //int value 0
32         AllowAll, //int value 1
33         Enforce   //int value 2
34     }
35 
36     address private owner;
37     address private rulesOwner;
38     address private proxyContract;
39     bool private verbose;
40 
41     mapping(address /*contractAddress*/ => bool) private enforceBypass;
42     mapping(address /*contractAddress*/ => mapping(address /*destination*/ => mapping(address /*tokenAddress*/ => uint256 /*limit*/))) private customerRules;
43     mapping(address /*contractAddress*/ => mapping(bytes4 /*function-name*/ => mapping(address /*destination*/ => bool /*has-access*/))) private acl;
44     mapping(address /*contractAddress*/ => mapping(bytes4 /*function-name*/ => bool)) private blockAllAccessForFunction;
45     mapping(address /*contractAddress*/ => mapping(uint /*policy-type*/ => uint /*enforcement status*/)) private policiesEnforcementStatus;
46 
47 
48     constructor() public {
49         owner = msg.sender;
50         verbose = false;
51     }
52 
53     //*************************************** modifiers ****************************************
54 
55     modifier onlyContractOwner {
56         require(owner == msg.sender, "You are not allowed to run this function, required role: Contract-Owner");
57         _;
58     }
59 
60     modifier onlyContractOwnerOrRulesOwner {
61         require(owner == msg.sender || rulesOwner == msg.sender, "You are not allowed to run this function, required role: Contract-Owner or Rules-Owner");
62         _;
63     }
64 
65     modifier onlyRulesOwner {
66         require(rulesOwner == msg.sender, "You are not allowed to run this function, required role: Rules-Owner");
67         _;
68     }
69 
70     modifier onlyProxy {
71         require(proxyContract == msg.sender, "You are not allowed to run this function, required role: SafeBlocks-Proxy");
72         _;
73     }
74 
75     //*************************************** setters ****************************************
76 
77     function setProxyContract(address _proxy)
78     onlyContractOwner
79     public {
80         proxyContract = _proxy;
81         emit ConfigurationChanged(msg.sender, _proxy, "a new proxy contract address has been assigned");
82     }
83 
84     function setRulesOwner(address _rulesOwner)
85     public
86     onlyContractOwner {
87         rulesOwner = _rulesOwner;
88         emit ConfigurationChanged(msg.sender, _rulesOwner, "a new Rules-Owner has been assigned");
89     }
90 
91     function setVerbose(bool _verbose)
92     onlyContractOwner
93     public {
94         verbose = _verbose;
95         emit ConfigurationChanged(msg.sender, msg.sender, "a new Verbose-Mode has been assigned");
96     }
97 
98     //*************************************** firewall functionality ****************************************
99 
100     function setBypassPerContract(address _contractAddress, bool _bypass)
101     onlyRulesOwner
102     public {
103         enforceBypass[_contractAddress] = _bypass;
104         if (verbose) emit PolicyChanged(_contractAddress, address(0), address(0), _bypass ? 1 : 0);
105     }
106 
107     function setPolicyEnforcementStatus(address _contractAddress, uint _policyType, uint _policyEnforcementStatus)
108     onlyRulesOwner
109     public {
110         policiesEnforcementStatus[_contractAddress][_policyType] = _policyEnforcementStatus;
111     }
112 
113     function setBlockAllAccessPerContractFunction(address _contractAddress, bytes4 _functionSig, bool _isBlocked)
114     onlyRulesOwner
115     public {
116         blockAllAccessForFunction[_contractAddress][_functionSig] = _isBlocked;
117         if (verbose) emit AccessChanged(_contractAddress, address(0), _functionSig, _isBlocked);
118     }
119 
120     function addRule(address _contractAddress, address _destination, address _token, uint256 _tokenLimit)
121     onlyRulesOwner
122     public {
123         customerRules[_contractAddress][_destination][_token] = _tokenLimit;
124         if (verbose) emit PolicyChanged(_contractAddress, _destination, _token, _tokenLimit);
125     }
126 
127     function removeRule(address _contractAddress, address _destination, address _token)
128     onlyRulesOwner
129     public {
130         delete customerRules[_contractAddress][_destination][_token];
131         if (verbose) emit PolicyChanged(_contractAddress, _destination, _token, 0);
132     }
133 
134     function addAccess(address _contractAddress, address _destination, bytes4 _functionSig)
135     onlyRulesOwner
136     public {
137         acl[_contractAddress][_functionSig][_destination] = true;
138         if (verbose) emit AccessChanged(_contractAddress, _destination, _functionSig, true);
139     }
140 
141     function removeAccess(address _contractAddress, address _destination, bytes4 _functionSig)
142     onlyRulesOwner
143     public {
144         delete acl[_contractAddress][_functionSig][_destination];
145         if (verbose) emit AccessChanged(_contractAddress, _destination, _functionSig, false);
146     }
147 
148     /*
149      * Validating that the withdraw operation meets the constrains of the predefined security policy
150      *
151      * @returns true if the transaction meets the security policy conditions, else false.
152      */
153     function allowTransaction(address _contractAddress, uint _amount, address _destination, address _token)
154     public
155     onlyProxy
156     returns (bool){
157         if (enforceBypass[_contractAddress]) {//contract level bypass, across all policies
158             if (verbose) emit AllowTransactionEnquireResult(_contractAddress, true, _token, _amount, _destination, "1");
159             return true;
160         }
161 
162         PolicyEnforcementStatus policyEnforcementStatus = PolicyEnforcementStatus(policiesEnforcementStatus[_contractAddress][uint(PolicyType.Transactions)]);
163         if (PolicyEnforcementStatus.BlockAll == policyEnforcementStatus) {//block all activated
164             if (verbose) emit AllowTransactionEnquireResult(_contractAddress, false, _token, _amount, _destination, "2");
165             return false;
166         }
167         if (PolicyEnforcementStatus.AllowAll == policyEnforcementStatus) {//allow all activated
168             if (verbose) emit AllowTransactionEnquireResult(_contractAddress, true, _token, _amount, _destination, "3");
169             return true;
170         }
171 
172         bool transactionAllowed = isTransactionAllowed(_contractAddress, _amount, _destination, _token);
173         if (verbose) emit AllowTransactionEnquireResult(_contractAddress, transactionAllowed, _token, _amount, _destination, "4");
174         return transactionAllowed;
175     }
176 
177     /*
178     * Validating the given destination has access to the given functionSig according to the predefine access control list
179     *
180     * @returns true if access granted, else false.
181     */
182     function allowAccess(address _contractAddress, address _destination, bytes4 _functionSig)
183     public
184     onlyProxy
185     returns (bool){
186         if (enforceBypass[_contractAddress]) {//contract level bypass, across all policies
187             if (verbose) emit AllowAccessEnquireResult(_contractAddress, true, _destination, _functionSig, "1");
188             return true;
189         }
190 
191         PolicyEnforcementStatus policyEnforcementStatus = PolicyEnforcementStatus(policiesEnforcementStatus[_contractAddress][uint(PolicyType.Access)]);
192         if (PolicyEnforcementStatus.BlockAll == policyEnforcementStatus) {//block all activated
193             if (verbose) emit AllowAccessEnquireResult(_contractAddress, false, _destination, _functionSig, "2");
194             return false;
195         }
196         if (PolicyEnforcementStatus.AllowAll == policyEnforcementStatus) {//allow all activated
197             if (verbose) emit AllowAccessEnquireResult(_contractAddress, true, _destination, _functionSig, "3");
198             return true;
199         }
200 
201         bool hasAccessResult = hasAccess(_contractAddress, _destination, _functionSig);
202         if (verbose) emit AllowAccessEnquireResult(_contractAddress, hasAccessResult, _destination, _functionSig, "4");
203         return hasAccessResult;
204     }
205 
206     //*************************************** private ****************************************
207 
208     function isTransactionAllowed(address _contractAddress, uint _amount, address _destination, address _token)
209     private
210     view
211     returns (bool){
212         uint256 limit = customerRules[_contractAddress][_destination][_token];
213         uint256 anyDestinationLimit = customerRules[_contractAddress][0x0][_token];
214 
215         if (limit == 0 && anyDestinationLimit == 0) {//no rules ?? deny all
216             return false;
217         }
218         if (anyDestinationLimit > 0 && limit == 0) {
219             limit = anyDestinationLimit;
220         }
221         return _amount <= limit;
222     }
223 
224     function hasAccess(address _contractAddress, address _destination, bytes4 _functionSig)
225     private
226     view
227     returns (bool){
228         bool blockAll = blockAllAccessForFunction[_contractAddress][_functionSig];
229         if (blockAll) {
230             return false;
231         }
232         bool allowAny = acl[_contractAddress][_functionSig][0x0];
233         if (allowAny) {
234             return true;
235         }
236         bool hasAccessResult = acl[_contractAddress][_functionSig][_destination];
237         return hasAccessResult;
238     }
239 
240     //*************************************** getters ****************************************
241 
242     function getPolicyEnforcementStatus(address _contractAddress, uint _policyType)
243     public
244     view
245     onlyContractOwner
246     returns (uint){
247         return policiesEnforcementStatus[_contractAddress][_policyType];
248     }
249 
250     function getBlockAllAccessForFunction(address _contractAddress, bytes4 _functionSig)
251     public
252     view
253     onlyContractOwner
254     returns (bool){
255         blockAllAccessForFunction[_contractAddress][_functionSig];
256     }
257 
258     function getEnforceBypass(address _contractAddress)
259     public
260     view
261     onlyContractOwnerOrRulesOwner
262     returns (bool){
263         return (enforceBypass[_contractAddress]);
264     }
265 
266     function getCustomerRules(address _contractAddress, address _destination, address _tokenAddress)
267     public
268     view
269     onlyContractOwner
270     returns (uint256){
271         return (customerRules[_contractAddress][_destination][_tokenAddress]);
272     }
273 }
274 // © 2018 SafeBlocks LTD.  All rights reserved.