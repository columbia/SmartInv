1 /*
2 
3   Copyright 2018 bZeroX, LLC
4   Inspired by TokenRegistry.sol, Copyright 2017 ZeroEx Intl.
5 
6   Licensed under the Apache License, Version 2.0 (the "License");
7   you may not use this file except in compliance with the License.
8   You may obtain a copy of the License at
9 
10     http://www.apache.org/licenses/LICENSE-2.0
11 
12   Unless required by applicable law or agreed to in writing, software
13   distributed under the License is distributed on an "AS IS" BASIS,
14   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
15   See the License for the specific language governing permissions and
16   limitations under the License.
17 
18 */
19 
20 pragma solidity 0.4.24;
21 
22 /**
23  * @title Ownable
24  * @dev The Ownable contract has an owner address, and provides basic authorization control
25  * functions, this simplifies the implementation of "user permissions".
26  */
27 contract Ownable {
28   address public owner;
29 
30 
31   event OwnershipRenounced(address indexed previousOwner);
32   event OwnershipTransferred(
33     address indexed previousOwner,
34     address indexed newOwner
35   );
36 
37 
38   /**
39    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40    * account.
41    */
42   constructor() public {
43     owner = msg.sender;
44   }
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54   /**
55    * @dev Allows the current owner to relinquish control of the contract.
56    */
57   function renounceOwnership() public onlyOwner {
58     emit OwnershipRenounced(owner);
59     owner = address(0);
60   }
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param _newOwner The address to transfer ownership to.
65    */
66   function transferOwnership(address _newOwner) public onlyOwner {
67     _transferOwnership(_newOwner);
68   }
69 
70   /**
71    * @dev Transfers control of the contract to a newOwner.
72    * @param _newOwner The address to transfer ownership to.
73    */
74   function _transferOwnership(address _newOwner) internal {
75     require(_newOwner != address(0));
76     emit OwnershipTransferred(owner, _newOwner);
77     owner = _newOwner;
78   }
79 }
80 
81 /// @title Oracle Registry - Oracles added to the bZx network by decentralized governance
82 contract OracleRegistry is Ownable {
83 
84     event LogAddOracle(
85         address indexed oracle,
86         string name
87     );
88 
89     event LogRemoveOracle(
90         address indexed oracle,
91         string name
92     );
93 
94     event LogOracleNameChange(address indexed oracle, string oldName, string newName);
95 
96     mapping (address => OracleMetadata) public oracles;
97     mapping (string => address) internal oracleByName;
98 
99     address[] public oracleAddresses;
100 
101     struct OracleMetadata {
102         address oracle;
103         string name;
104     }
105 
106     modifier oracleExists(address _oracle) {
107         require(oracles[_oracle].oracle != address(0), "OracleRegistry::oracle doesn't exist");
108         _;
109     }
110 
111     modifier oracleDoesNotExist(address _oracle) {
112         require(oracles[_oracle].oracle == address(0), "OracleRegistry::oracle exists");
113         _;
114     }
115 
116     modifier nameDoesNotExist(string _name) {
117         require(oracleByName[_name] == address(0), "OracleRegistry::name exists");
118         _;
119     }
120 
121     modifier addressNotNull(address _address) {
122         require(_address != address(0), "OracleRegistry::address is null");
123         _;
124     }
125 
126     /// @dev Allows owner to add a new oracle to the registry.
127     /// @param _oracle Address of new oracle.
128     /// @param _name Name of new oracle.
129     function addOracle(
130         address _oracle,
131         string _name)
132         public
133         onlyOwner
134         oracleDoesNotExist(_oracle)
135         addressNotNull(_oracle)
136         nameDoesNotExist(_name)
137     {
138         oracles[_oracle] = OracleMetadata({
139             oracle: _oracle,
140             name: _name
141         });
142         oracleAddresses.push(_oracle);
143         oracleByName[_name] = _oracle;
144         emit LogAddOracle(
145             _oracle,
146             _name
147         );
148     }
149 
150     /// @dev Allows owner to remove an existing oracle from the registry.
151     /// @param _oracle Address of existing oracle.
152     function removeOracle(address _oracle, uint _index)
153         public
154         onlyOwner
155         oracleExists(_oracle)
156     {
157         require(oracleAddresses[_index] == _oracle, "OracleRegistry::invalid index");
158 
159         oracleAddresses[_index] = oracleAddresses[oracleAddresses.length - 1];
160         oracleAddresses.length -= 1;
161 
162         OracleMetadata storage oracle = oracles[_oracle];
163         emit LogRemoveOracle(
164             oracle.oracle,
165             oracle.name
166         );
167         delete oracleByName[oracle.name];
168         delete oracles[_oracle];
169     }
170 
171     /// @dev Allows owner to modify an existing oracle's name.
172     /// @param _oracle Address of existing oracle.
173     /// @param _name New name.
174     function setOracleName(address _oracle, string _name)
175         public
176         onlyOwner
177         oracleExists(_oracle)
178         nameDoesNotExist(_name)
179     {
180         OracleMetadata storage oracle = oracles[_oracle];
181         emit LogOracleNameChange(_oracle, oracle.name, _name);
182         delete oracleByName[oracle.name];
183         oracleByName[_name] = _oracle;
184         oracle.name = _name;
185     }
186 
187     /// @dev Checks if an oracle exists in the registry
188     /// @param _oracle Address of registered oracle.
189     /// @return True if exists, False otherwise.
190     function hasOracle(address _oracle)
191         public
192         view
193         returns (bool) {
194         return (oracles[_oracle].oracle == _oracle);
195     }
196 
197     /// @dev Provides a registered oracle's address when given the oracle name.
198     /// @param _name Name of registered oracle.
199     /// @return Oracle's address.
200     function getOracleAddressByName(string _name)
201         public
202         view
203         returns (address) {
204         return oracleByName[_name];
205     }
206 
207     /// @dev Provides a registered oracle's metadata, looked up by address.
208     /// @param _oracle Address of registered oracle.
209     /// @return Oracle metadata.
210     function getOracleMetaData(address _oracle)
211         public
212         view
213         returns (
214             address,  //oracleAddress
215             string   //name
216         )
217     {
218         OracleMetadata memory oracle = oracles[_oracle];
219         return (
220             oracle.oracle,
221             oracle.name
222         );
223     }
224 
225     /// @dev Provides a registered oracle's metadata, looked up by name.
226     /// @param _name Name of registered oracle.
227     /// @return Oracle metadata.
228     function getOracleByName(string _name)
229         public
230         view
231         returns (
232             address,  //oracleAddress
233             string    //name
234         )
235     {
236         address _oracle = oracleByName[_name];
237         return getOracleMetaData(_oracle);
238     }
239 
240     /// @dev Returns an array containing all oracle addresses.
241     /// @return Array of oracle addresses.
242     function getOracleAddresses()
243         public
244         view
245         returns (address[])
246     {
247         return oracleAddresses;
248     }
249 
250     /// @dev Returns an array of oracle addresses, an array with the length of each oracle name, and a concatenated string of oracle names
251     /// @return Array of oracle names, array of name lengths, concatenated string of all names
252     function getOracleList()
253         public
254         view
255         returns (address[], uint[], string)
256     {
257         if (oracleAddresses.length == 0)
258             return;
259 
260         address[] memory addresses = oracleAddresses;
261         uint[] memory nameLengths = new uint[](oracleAddresses.length);
262         string memory allStrings;
263         
264         for (uint i = 0; i < oracleAddresses.length; i++) {
265             string memory tmp = oracles[oracleAddresses[i]].name;
266             nameLengths[i] = bytes(tmp).length;
267             allStrings = strConcat(allStrings, tmp);
268         }
269 
270         return (addresses, nameLengths, allStrings);
271     }
272 
273     /// @dev Concatenates two strings
274     /// @return concatenated string
275     function strConcat(
276         string _a,
277         string _b)
278         internal
279         pure
280         returns (string)
281     {
282         bytes memory _ba = bytes(_a);
283         bytes memory _bb = bytes(_b);
284         string memory ab = new string(_ba.length + _bb.length);
285         bytes memory bab = bytes(ab);
286         uint k = 0;
287         for (uint i = 0; i < _ba.length; i++)
288             bab[k++] = _ba[i];
289         for (i = 0; i < _bb.length; i++)
290             bab[k++] = _bb[i];
291         
292         return string(bab);
293     }
294 }