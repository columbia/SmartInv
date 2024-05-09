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
60     modifier onlyRulesOwner {
61         require(rulesOwner == msg.sender, "You are not allowed to run this function, required role: Rules-Owner");
62         _;
63     }
64 
65     modifier onlyProxy {
66         require(proxyContract == msg.sender, "You are not allowed to run this function, required role: SafeBlocks-Proxy");
67         _;
68     }
69 
70     //*************************************** setters ****************************************
71 
72     function setProxyContract(address _proxy)
73     onlyContractOwner
74     public {
75         proxyContract = _proxy;
76         emit ConfigurationChanged(msg.sender, _proxy, "a new proxy contract address has been assigned");
77     }
78 
79     function setRulesOwner(address _rulesOwner)
80     public
81     onlyContractOwner {
82         rulesOwner = _rulesOwner;
83         emit ConfigurationChanged(msg.sender, _rulesOwner, "a new Rules-Owner has been assigned");
84     }
85 
86     function setVerbose(bool _verbose)
87     onlyContractOwner
88     public {
89         verbose = _verbose;
90         emit ConfigurationChanged(msg.sender, msg.sender, "a new Verbose-Mode has been assigned");
91     }
92 
93     //*************************************** firewall functionality ****************************************
94 
95     function setBypassPerContract(address _contractAddress, bool _bypass)
96     onlyRulesOwner
97     public {
98         enforceBypass[_contractAddress] = _bypass;
99         if (verbose) emit PolicyChanged(_contractAddress, address(0), address(0), _bypass ? 1 : 0);
100     }
101 
102     function setPolicyEnforcementStatus(address _contractAddress, uint _policyType, uint _policyEnforcementStatus)
103     onlyRulesOwner
104     public {
105         policiesEnforcementStatus[_contractAddress][_policyType] = _policyEnforcementStatus;
106     }
107 
108     function setBlockAllAccessPerContractFunction(address _contractAddress, bytes4 _functionSig, bool _isBlocked)
109     onlyRulesOwner
110     public {
111         blockAllAccessForFunction[_contractAddress][_functionSig] = _isBlocked;
112         if (verbose) emit AccessChanged(_contractAddress, address(0), _functionSig, _isBlocked);
113     }
114 
115     function addRule(address _contractAddress, address _destination, address _token, uint256 _tokenLimit)
116     onlyRulesOwner
117     public {
118         customerRules[_contractAddress][_destination][_token] = _tokenLimit;
119         if (verbose) emit PolicyChanged(_contractAddress, _destination, _token, _tokenLimit);
120     }
121 
122     function removeRule(address _contractAddress, address _destination, address _token)
123     onlyRulesOwner
124     public {
125         delete customerRules[_contractAddress][_destination][_token];
126         if (verbose) emit PolicyChanged(_contractAddress, _destination, _token, 0);
127     }
128 
129     function addAccess(address _contractAddress, address _destination, bytes4 _functionSig)
130     onlyRulesOwner
131     public {
132         acl[_contractAddress][_functionSig][_destination] = true;
133         if (verbose) emit AccessChanged(_contractAddress, _destination, _functionSig, true);
134     }
135 
136     function removeAccess(address _contractAddress, address _destination, bytes4 _functionSig)
137     onlyRulesOwner
138     public {
139         delete acl[_contractAddress][_functionSig][_destination];
140         if (verbose) emit AccessChanged(_contractAddress, _destination, _functionSig, false);
141     }
142 
143     /*
144      * Validating that the withdraw operation meets the constrains of the predefined security policy
145      *
146      * @returns true if the transaction meets the security policy conditions, else false.
147      */
148     function allowTransaction(address _contractAddress, uint _amount, address _destination, address _token)
149     public
150     onlyProxy
151     returns (bool){
152         if (enforceBypass[_contractAddress]) {//contract level bypass, across all policies
153             if (verbose) emit AllowTransactionEnquireResult(_contractAddress, true, _token, _amount, _destination, "1");
154             return true;
155         }
156 
157         PolicyEnforcementStatus policyEnforcementStatus = PolicyEnforcementStatus(policiesEnforcementStatus[_contractAddress][uint(PolicyType.Transactions)]);
158         if (PolicyEnforcementStatus.BlockAll == policyEnforcementStatus) {//block all activated
159             if (verbose) emit AllowTransactionEnquireResult(_contractAddress, false, _token, _amount, _destination, "2");
160             return false;
161         }
162         if (PolicyEnforcementStatus.AllowAll == policyEnforcementStatus) {//allow all activated
163             if (verbose) emit AllowTransactionEnquireResult(_contractAddress, true, _token, _amount, _destination, "3");
164             return true;
165         }
166 
167         bool transactionAllowed = isTransactionAllowed(_contractAddress, _amount, _destination, _token);
168         if (verbose) emit AllowTransactionEnquireResult(_contractAddress, transactionAllowed, _token, _amount, _destination, "4");
169         return transactionAllowed;
170     }
171 
172     /*
173     * Validating the given destination has access to the given functionSig according to the predefine access control list
174     *
175     * @returns true if access granted, else false.
176     */
177     function allowAccess(address _contractAddress, address _destination, bytes4 _functionSig)
178     public
179     onlyProxy
180     returns (bool){
181         if (enforceBypass[_contractAddress]) {//contract level bypass, across all policies
182             if (verbose) emit AllowAccessEnquireResult(_contractAddress, true, _destination, _functionSig, "1");
183             return true;
184         }
185 
186         PolicyEnforcementStatus policyEnforcementStatus = PolicyEnforcementStatus(policiesEnforcementStatus[_contractAddress][uint(PolicyType.Access)]);
187         if (PolicyEnforcementStatus.BlockAll == policyEnforcementStatus) {//block all activated
188             if (verbose) emit AllowAccessEnquireResult(_contractAddress, false, _destination, _functionSig, "2");
189             return false;
190         }
191         if (PolicyEnforcementStatus.AllowAll == policyEnforcementStatus) {//allow all activated
192             if (verbose) emit AllowAccessEnquireResult(_contractAddress, true, _destination, _functionSig, "3");
193             return true;
194         }
195 
196         bool hasAccessResult = hasAccess(_contractAddress, _destination, _functionSig);
197         if (verbose) emit AllowAccessEnquireResult(_contractAddress, hasAccessResult, _destination, _functionSig, "4");
198         return hasAccessResult;
199     }
200 
201     //*************************************** private ****************************************
202 
203     function isTransactionAllowed(address _contractAddress, uint _amount, address _destination, address _token)
204     private
205     view
206     returns (bool){
207         uint256 limit = customerRules[_contractAddress][_destination][_token];
208         uint256 anyDestinationLimit = customerRules[_contractAddress][0x0][_token];
209 
210         if (limit == 0 && anyDestinationLimit == 0) {//no rules ?? deny all
211             return false;
212         }
213         if (anyDestinationLimit > 0 && limit == 0) {
214             limit = anyDestinationLimit;
215         }
216         return _amount <= limit;
217     }
218 
219     function hasAccess(address _contractAddress, address _destination, bytes4 _functionSig)
220     private
221     view
222     returns (bool){
223         bool blockAll = blockAllAccessForFunction[_contractAddress][_functionSig];
224         if (blockAll) {
225             return false;
226         }
227         bool allowAny = acl[_contractAddress][_functionSig][0x0];
228         if (allowAny) {
229             return true;
230         }
231         bool hasAccessResult = acl[_contractAddress][_functionSig][_destination];
232         return hasAccessResult;
233     }
234 
235     //*************************************** getters ****************************************
236 
237     function getPolicyEnforcementStatus(address _contractAddress, uint _policyType)
238     public
239     view
240     onlyContractOwner
241     returns (uint){
242         return policiesEnforcementStatus[_contractAddress][_policyType];
243     }
244 
245     function getBlockAllAccessForFunction(address _contractAddress, bytes4 _functionSig)
246     public
247     view
248     onlyContractOwner
249     returns (bool){
250         blockAllAccessForFunction[_contractAddress][_functionSig];
251     }
252 
253     function getEnforceBypass(address _contractAddress)
254     public
255     view
256     onlyContractOwner
257     returns (bool){
258         return (enforceBypass[_contractAddress]);
259     }
260 
261     function getCustomerRules(address _contractAddress, address _destination, address _tokenAddress)
262     public
263     view
264     onlyContractOwner
265     returns (uint256){
266         return (customerRules[_contractAddress][_destination][_tokenAddress]);
267     }
268 }
269 // © 2018 SafeBlocks LTD.  All rights reserved.