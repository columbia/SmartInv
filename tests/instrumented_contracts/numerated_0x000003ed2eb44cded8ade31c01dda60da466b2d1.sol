1 pragma solidity "0.4.20";
2 
3 contract Erc20 {
4     /** ERC20 Interface **
5     * Source: https://github.com/ethereum/EIPs/issues/20
6     * Downloaded: 2018.08.16
7     * Version without events and comments
8     * The full version can be downloaded at the source link
9     */
10 
11     string public name;
12     string public symbol;
13     uint8 public decimals;
14     
15     function approve(address, uint256) public returns (bool _success);
16     function allowance(address, address) constant public returns (uint256 _remaining);
17     function balanceOf(address) constant public returns (uint256 _balance);
18     function totalSupply() constant public returns (uint256 _totalSupply);
19     function transfer(address, uint256) public returns (bool _success);
20     function transferFrom(address, address, uint256) public returns (bool _success);
21 }
22 
23 contract Erc20Test is Erc20 {
24     /** ERC20 Test Contract with dummy data **/
25 
26     string public name;
27     string public symbol;
28     uint8 public decimals;
29 
30     function Erc20Test(string _name, string _symbol, uint8 _decimals) public {
31         name = _name;
32         symbol = _symbol;
33         decimals = _decimals;
34     }
35     
36     function approve(address, uint256) public returns (bool) {return true;}
37     function allowance(address, address) constant public returns (uint256) {return 42;}
38     function balanceOf(address) constant public returns (uint256) {return 42;}
39     function totalSupply() constant public returns (uint256) {return 42;}
40     function transfer(address, uint256) public returns (bool) {return true;}
41     function transferFrom(address, address, uint256) public returns (bool) {return true;}
42 }
43 
44 contract Accessible {
45     /** Access Right Management **
46     * Copyright 2018
47     * Florian Weigand
48     * Synalytix UG, Munich
49     * florian(at)synalytix.de
50     * Created at: 2018.03.22
51     * Last modified at: 2018.09.17
52     */
53 
54     // emergency stop
55     bool                                private stopped = false;
56     bool                                private accessForEverybody = false;
57     address                             public owner;
58     mapping(address => bool)            public accessAllowed;
59 
60     function Accessible() public {
61         owner = msg.sender;
62     }
63 
64     modifier ownership() {
65         require(owner == msg.sender);
66         _;
67     }
68 
69     modifier accessible() {
70         require(accessAllowed[msg.sender] || accessForEverybody);
71         require(!stopped);
72         _;
73     }
74 
75     function allowAccess(address _address) ownership public {
76         if (_address != address(0)) {
77             accessAllowed[_address] = true;
78         }
79     }
80 
81     function denyAccess(address _address) ownership public {
82         if (_address != address(0)) {
83             accessAllowed[_address] = false;
84         }
85     }
86 
87     function transferOwnership(address _address) ownership public {
88         if (_address != address(0)) {
89             owner = _address;
90         }
91     }
92 
93     function toggleContractStopped() ownership public {
94         stopped = !stopped;
95     }
96 
97     function toggleContractAccessForEverybody() ownership public {
98         accessForEverybody = !accessForEverybody;
99     }
100 }
101 
102 contract Erc20SummaryStorage is Accessible {
103     /** Data Storage Contract **
104     * Copyright 2018
105     * Florian Weigand
106     * Synalytix UG, Munich
107     * florian(at)synalytix.de
108     * Created at: 2018.08.02
109     * Last modified at: 2018.08.16
110     */
111        
112     /**** smart contract storage ****/
113     address[]                           public smartContracts;
114     mapping(address => bool)            public smartContractsAdded;
115     
116     /**** general storage of non-struct data which might 
117     be needed for further development of main contract ****/
118     mapping(bytes32 => uint256)         public uIntStorage;
119     mapping(bytes32 => string)          public stringStorage;
120     mapping(bytes32 => address)         public addressStorage;
121     mapping(bytes32 => bytes)           public bytesStorage;
122     mapping(bytes32 => bool)            public boolStorage;
123     mapping(bytes32 => int256)          public intStorage;
124 
125     /**** CRUD for smart contract storage ****/
126     function getSmartContractByPosition(uint position) external view returns (address) {
127         return smartContracts[position];
128     }
129 
130     function getSmartContractsLength() external view returns (uint) {
131         return smartContracts.length;
132     }
133     
134     function addSmartContractByAddress(address _contractAddress) accessible external {           
135         // empty address not allow
136         require(_contractAddress != address(0));
137         // address was not added before
138         require(!smartContractsAdded[_contractAddress]);
139         
140         // add new address
141         smartContractsAdded[_contractAddress] = true;
142         smartContracts.push(_contractAddress);
143     }
144     
145     function removeSmartContractByAddress(address _contractAddress) accessible external {
146         uint256 endPointer = smartContracts.length;
147         uint256 startPointer = 0;
148         
149         while(endPointer > startPointer) {
150             // swap replace
151             if(smartContracts[startPointer] == _contractAddress) {              
152                 // as long as the last element is target delete it before swap
153                 while(smartContracts[endPointer - 1] == _contractAddress) {
154                     endPointer = endPointer - 1;
155                     // stop if no element left
156                     if(endPointer == 0) break;
157                 }
158                 
159                 if(endPointer > startPointer) {
160                     smartContracts[startPointer] = smartContracts[endPointer - 1];
161                     endPointer = endPointer - 1;
162                 }
163             }
164             startPointer = startPointer + 1;
165         }
166         smartContracts.length = endPointer;
167         // reset, so it can be added again
168         smartContractsAdded[_contractAddress] = false;
169     }
170 
171     /**** Get Methods for additional storage ****/
172     function getAddress(bytes32 _key) external view returns (address) {
173         return addressStorage[_key];
174     }
175 
176     function getUint(bytes32 _key) external view returns (uint) {
177         return uIntStorage[_key];
178     }
179 
180     function getString(bytes32 _key) external view returns (string) {
181         return stringStorage[_key];
182     }
183 
184     function getBytes(bytes32 _key) external view returns (bytes) {
185         return bytesStorage[_key];
186     }
187 
188     function getBool(bytes32 _key) external view returns (bool) {
189         return boolStorage[_key];
190     }
191 
192     function getInt(bytes32 _key) external view returns (int) {
193         return intStorage[_key];
194     }
195 
196     /**** Set Methods for additional storage ****/
197     function setAddress(bytes32 _key, address _value) accessible external {
198         addressStorage[_key] = _value;
199     }
200 
201     function setUint(bytes32 _key, uint _value) accessible external {
202         uIntStorage[_key] = _value;
203     }
204 
205     function setString(bytes32 _key, string _value) accessible external {
206         stringStorage[_key] = _value;
207     }
208 
209     function setBytes(bytes32 _key, bytes _value) accessible external {
210         bytesStorage[_key] = _value;
211     }
212     
213     function setBool(bytes32 _key, bool _value) accessible external {
214         boolStorage[_key] = _value;
215     }
216     
217     function setInt(bytes32 _key, int _value) accessible external {
218         intStorage[_key] = _value;
219     }
220 
221     /**** Delete Methods for additional storage ****/
222     function deleteAddress(bytes32 _key) accessible external {
223         delete addressStorage[_key];
224     }
225 
226     function deleteUint(bytes32 _key) accessible external {
227         delete uIntStorage[_key];
228     }
229 
230     function deleteString(bytes32 _key) accessible external {
231         delete stringStorage[_key];
232     }
233 
234     function deleteBytes(bytes32 _key) accessible external {
235         delete bytesStorage[_key];
236     }
237     
238     function deleteBool(bytes32 _key) accessible external {
239         delete boolStorage[_key];
240     }
241     
242     function deleteInt(bytes32 _key) accessible external {
243         delete intStorage[_key];
244     }
245 }
246 
247 contract Erc20SummaryLogic is Accessible {
248     /** Logic Contract (updatable) **
249     * Copyright 2018
250     * Florian Weigand
251     * Synalytix UG, Munich
252     * florian(at)synalytix.de
253     * Created at: 2018.08.02
254     * Last modified at: 2018.08.16
255     */
256 
257     Erc20SummaryStorage erc20SummaryStorage;
258 
259     function Erc20SummaryLogic(address _erc20SummaryStorage) public {
260         erc20SummaryStorage = Erc20SummaryStorage(_erc20SummaryStorage);
261     }
262 
263     function addSmartContract(address _contractAddress) accessible public {
264         // TODO: sth like EIP-165 would be nice
265         // see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
266         // require(erc20Contract.totalSupply.selector ^ erc20Contract.balanceOf.selector ^ erc20Contract.allowance.selector ^ erc20Contract.approve.selector ^ erc20Contract.transfer.selector ^ erc20Contract.transferFrom.selector);
267 
268         // as EIP-165 is not available check for the most important functions of ERC20 to be implemented
269         Erc20 erc20Contract = Erc20(_contractAddress);
270         erc20Contract.name();
271         erc20Contract.symbol();
272         erc20Contract.decimals();
273         erc20Contract.totalSupply();
274         erc20Contract.balanceOf(0x281055Afc982d96fAB65b3a49cAc8b878184Cb16);
275 
276         // if it did not crash (because of a missing function) it should be an ERC20 contract
277         erc20SummaryStorage.addSmartContractByAddress(_contractAddress);
278     }
279 
280     function addSmartContracts(address[] _contractAddresses) accessible external {
281         for(uint i = 0; i < _contractAddresses.length; i++) {
282             addSmartContract(_contractAddresses[i]);
283         }
284     }
285 
286     function removeSmartContract(address _contractAddress) accessible external {
287         erc20SummaryStorage.removeSmartContractByAddress(_contractAddress);
288     }
289 
290     function erc20BalanceForAddress(address _queryAddress) external view returns (address[], uint[], uint8[]) {
291         uint amountOfSmartContracts = erc20SummaryStorage.getSmartContractsLength();
292         address[] memory contractAddresses = new address[](amountOfSmartContracts);
293         uint[] memory balances = new uint[](amountOfSmartContracts);
294         uint8[] memory decimals = new uint8[](amountOfSmartContracts);
295         address tempErc20ContractAddress;
296         Erc20 tempErc20Contract;
297 
298         for (uint i = 0; i < amountOfSmartContracts; i++) {
299             tempErc20ContractAddress = erc20SummaryStorage.getSmartContractByPosition(i);
300             tempErc20Contract = Erc20(tempErc20ContractAddress);
301             contractAddresses[i] = tempErc20ContractAddress;
302             balances[i] = tempErc20Contract.balanceOf(_queryAddress);
303             decimals[i] = tempErc20Contract.decimals();
304         }
305         return (contractAddresses, balances, decimals);
306     }
307 }