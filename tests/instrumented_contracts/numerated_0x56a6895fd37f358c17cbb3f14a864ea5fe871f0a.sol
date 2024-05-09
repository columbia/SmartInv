1 pragma solidity 0.4.25;
2 
3 
4 interface IOrbsValidatorsRegistry {
5 
6     event ValidatorLeft(address indexed validator);
7     event ValidatorRegistered(address indexed validator);
8     event ValidatorUpdated(address indexed validator);
9 
10     /// @dev register a validator and provide registration data.
11     /// the new validator entry will be owned and identified by msg.sender.
12     /// if msg.sender is already registered as a validator in this registry the
13     /// transaction will fail.
14     /// @param name string The name of the validator
15     /// @param ipAddress bytes4 The validator node ip address. If another validator previously registered this ipAddress the transaction will fail
16     /// @param website string The website of the validator
17     /// @param orbsAddress bytes20 The validator node orbs public address. If another validator previously registered this orbsAddress the transaction will fail
18     function register(
19         string name,
20         bytes4 ipAddress,
21         string website,
22         bytes20 orbsAddress
23     )
24         external;
25 
26     /// @dev update the validator registration data entry associated with msg.sender.
27     /// msg.sender must be registered in this registry contract.
28     /// @param name string The name of the validator
29     /// @param ipAddress bytes4 The validator node ip address. If another validator previously registered this ipAddress the transaction will fail
30     /// @param website string The website of the validator
31     /// @param orbsAddress bytes20 The validator node orbs public address. If another validator previously registered this orbsAddress the transaction will fail
32     function update(
33         string name,
34         bytes4 ipAddress,
35         string website,
36         bytes20 orbsAddress
37     )
38         external;
39 
40     /// @dev deletes a validator registration entry associated with msg.sender.
41     function leave() external;
42 
43     /// @dev returns validator registration data.
44     /// @param validator address address of the validator.
45     function getValidatorData(address validator)
46         external
47         view
48         returns (
49             string name,
50             bytes4 ipAddress,
51             string website,
52             bytes20 orbsAddress
53         );
54 
55     /// @dev returns the blocks in which a validator was registered and last updated.
56     /// if validator does not designate a registered validator this method returns zero values.
57     /// @param validator address of a validator
58     function getRegistrationBlockNumber(address validator)
59         external
60         view
61         returns (uint registeredOn, uint lastUpdatedOn);
62 
63     /// @dev Checks if validator is currently registered as a validator.
64     /// @param validator address address of the validator
65     /// @return true iff validator belongs to a registered validator
66     function isValidator(address validator) external view returns (bool);
67 
68     /// @dev returns the orbs node public address of a specific validator.
69     /// @param validator address address of the validator
70     /// @return an Orbs node address
71     function getOrbsAddress(address validator)
72         external
73         view
74         returns (bytes20 orbsAddress);
75 }
76 
77 
78 /// @title Orbs Validators Registry smart contract.
79 contract OrbsValidatorsRegistry is IOrbsValidatorsRegistry {
80 
81     // The validator registration data object.
82     struct ValidatorData {
83         string name;
84         bytes4 ipAddress;
85         string website;
86         bytes20 orbsAddress;
87         uint registeredOnBlock;
88         uint lastUpdatedOnBlock;
89     }
90 
91     // The version of the current validators data registration smart contract.
92     uint public constant VERSION = 1;
93 
94     // A mapping from validator's Ethereum address to registration data.
95     mapping(address => ValidatorData) internal validatorsData;
96 
97     // Lookups for IP Address & Orbs Address for uniqueness checks. Useful also be used for as a public lookup index.
98     mapping(bytes4 => address) public lookupByIp;
99     mapping(bytes20 => address) public lookupByOrbsAddr;
100 
101     /// @dev check that the caller is a validator.
102     modifier onlyValidator() {
103         require(isValidator(msg.sender), "You must be a registered validator");
104         _;
105     }
106 
107     /// @dev register a validator and provide registration data.
108     /// the new validator entry will be owned and identified by msg.sender.
109     /// if msg.sender is already registered as a validator in this registry the
110     /// transaction will fail.
111     /// @param name string The name of the validator
112     /// @param ipAddress bytes4 The validator node ip address. If another validator previously registered this ipAddress the transaction will fail
113     /// @param website string The website of the validator
114     /// @param orbsAddress bytes20 The validator node orbs public address. If another validator previously registered this orbsAddress the transaction will fail
115     function register(
116         string name,
117         bytes4 ipAddress,
118         string website,
119         bytes20 orbsAddress
120     )
121         external
122     {
123         address sender = msg.sender;
124         require(bytes(name).length > 0, "Please provide a valid name");
125         require(bytes(website).length > 0, "Please provide a valid website");
126         require(!isValidator(sender), "Validator already exists");
127         require(ipAddress != bytes4(0), "Please pass a valid ip address represented as an array of exactly 4 bytes");
128         require(orbsAddress != bytes20(0), "Please provide a valid Orbs Address");
129         require(lookupByIp[ipAddress] == address(0), "IP address already in use");
130         require(lookupByOrbsAddr[orbsAddress] == address(0), "Orbs Address is already in use by another validator");
131 
132         lookupByIp[ipAddress] = sender;
133         lookupByOrbsAddr[orbsAddress] = sender;
134 
135         validatorsData[sender] = ValidatorData({
136             name: name,
137             ipAddress: ipAddress,
138             website: website,
139             orbsAddress: orbsAddress,
140             registeredOnBlock: block.number,
141             lastUpdatedOnBlock: block.number
142         });
143 
144         emit ValidatorRegistered(sender);
145     }
146 
147     /// @dev update the validator registration data entry associated with msg.sender.
148     /// msg.sender must be registered in this registry contract.
149     /// @param name string The name of the validator
150     /// @param ipAddress bytes4 The validator node ip address. If another validator previously registered this ipAddress the transaction will fail
151     /// @param website string The website of the validator
152     /// @param orbsAddress bytes20 The validator node orbs public address. If another validator previously registered this orbsAddress the transaction will fail
153     function update(
154         string name,
155         bytes4 ipAddress,
156         string website,
157         bytes20 orbsAddress
158     )
159         external
160         onlyValidator
161     {
162         address sender = msg.sender;
163         require(bytes(name).length > 0, "Please provide a valid name");
164         require(bytes(website).length > 0, "Please provide a valid website");
165         require(ipAddress != bytes4(0), "Please pass a valid ip address represented as an array of exactly 4 bytes");
166         require(orbsAddress != bytes20(0), "Please provide a valid Orbs Address");
167         require(isIpFreeToUse(ipAddress), "IP Address is already in use by another validator");
168         require(isOrbsAddressFreeToUse(orbsAddress), "Orbs Address is already in use by another validator");
169 
170         ValidatorData storage data = validatorsData[sender];
171 
172         // Remove previous key from lookup.
173         delete lookupByIp[data.ipAddress];
174         delete lookupByOrbsAddr[data.orbsAddress];
175 
176         // Set new keys in lookup.
177         lookupByIp[ipAddress] = sender;
178         lookupByOrbsAddr[orbsAddress] = sender;
179 
180         data.name = name;
181         data.ipAddress = ipAddress;
182         data.website = website;
183         data.orbsAddress = orbsAddress;
184         data.lastUpdatedOnBlock = block.number;
185 
186         emit ValidatorUpdated(sender);
187     }
188 
189     /// @dev deletes a validator registration entry associated with msg.sender.
190     function leave() external onlyValidator {
191         address sender = msg.sender;
192 
193         ValidatorData storage data = validatorsData[sender];
194 
195         delete lookupByIp[data.ipAddress];
196         delete lookupByOrbsAddr[data.orbsAddress];
197 
198         delete validatorsData[sender];
199 
200         emit ValidatorLeft(sender);
201     }
202 
203     /// @dev returns the blocks in which a validator was registered and last updated.
204     /// if validator does not designate a registered validator this method returns zero values.
205     /// @param validator address of a validator
206     function getRegistrationBlockNumber(address validator)
207         external
208         view
209         returns (uint registeredOn, uint lastUpdatedOn)
210     {
211         require(isValidator(validator), "Unlisted Validator");
212 
213         ValidatorData storage entry = validatorsData[validator];
214         registeredOn = entry.registeredOnBlock;
215         lastUpdatedOn = entry.lastUpdatedOnBlock;
216     }
217 
218     /// @dev returns the orbs node public address of a specific validator.
219     /// @param validator address address of the validator
220     /// @return an Orbs node address
221     function getOrbsAddress(address validator)
222         external
223         view
224         returns (bytes20)
225     {
226         return validatorsData[validator].orbsAddress;
227     }
228 
229     /// @dev returns validator registration data.
230     /// @param validator address address of the validator.
231     function getValidatorData(address validator)
232         public
233         view
234         returns (
235             string memory name,
236             bytes4 ipAddress,
237             string memory website,
238             bytes20 orbsAddress
239         )
240     {
241         ValidatorData storage entry = validatorsData[validator];
242         name = entry.name;
243         ipAddress = entry.ipAddress;
244         website = entry.website;
245         orbsAddress = entry.orbsAddress;
246     }
247 
248     /// @dev Checks if validator is currently registered as a validator.
249     /// @param validator address address of the validator
250     /// @return true iff validator belongs to a registered validator
251     function isValidator(address validator) public view returns (bool) {
252         return validatorsData[validator].registeredOnBlock > 0;
253     }
254 
255     /// @dev INTERNAL. Checks if ipAddress is currently available to msg.sender.
256     /// @param ipAddress bytes4 ip address to check for uniqueness
257     /// @return true iff ipAddress is currently not registered for any validator other than msg.sender.
258     function isIpFreeToUse(bytes4 ipAddress) internal view returns (bool) {
259         return
260             lookupByIp[ipAddress] == address(0) ||
261             lookupByIp[ipAddress] == msg.sender;
262     }
263 
264     /// @dev INTERNAL. Checks if orbsAddress is currently available to msg.sender.
265     /// @param orbsAddress bytes20 ip address to check for uniqueness
266     /// @return true iff orbsAddress is currently not registered for a validator other than msg.sender.
267     function isOrbsAddressFreeToUse(bytes20 orbsAddress)
268         internal
269         view
270         returns (bool)
271     {
272         return
273             lookupByOrbsAddr[orbsAddress] == address(0) ||
274             lookupByOrbsAddr[orbsAddress] == msg.sender;
275     }
276 }