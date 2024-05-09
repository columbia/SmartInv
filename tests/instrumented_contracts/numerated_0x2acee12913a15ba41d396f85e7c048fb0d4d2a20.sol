1 /**
2  * Copyright 2017–2018, bZeroX, LLC. All Rights Reserved.
3  * Licensed under the Apache License, Version 2.0.
4  */
5  
6 pragma solidity 0.5.2;
7 
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipRenounced(address indexed previousOwner);
19   event OwnershipTransferred(
20     address indexed previousOwner,
21     address indexed newOwner
22   );
23 
24 
25   /**
26    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
27    * account.
28    */
29   constructor() public {
30     owner = msg.sender;
31   }
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41   /**
42    * @dev Allows the current owner to relinquish control of the contract.
43    * @notice Renouncing to ownership will leave the contract without an owner.
44    * It will not be possible to call the functions with the `onlyOwner`
45    * modifier anymore.
46    */
47   function renounceOwnership() public onlyOwner {
48     emit OwnershipRenounced(owner);
49     owner = address(0);
50   }
51 
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param _newOwner The address to transfer ownership to.
55    */
56   function transferOwnership(address _newOwner) public onlyOwner {
57     _transferOwnership(_newOwner);
58   }
59 
60   /**
61    * @dev Transfers control of the contract to a newOwner.
62    * @param _newOwner The address to transfer ownership to.
63    */
64   function _transferOwnership(address _newOwner) internal {
65     require(_newOwner != address(0));
66     emit OwnershipTransferred(owner, _newOwner);
67     owner = _newOwner;
68   }
69 }
70 
71 contract OracleRegistry is Ownable {
72 
73     event LogAddOracle(
74         address indexed oracle,
75         string name
76     );
77 
78     event LogRemoveOracle(
79         address indexed oracle,
80         string name
81     );
82 
83     event LogOracleNameChange(address indexed oracle, string oldName, string newName);
84 
85     mapping (address => OracleMetadata) public oracles;
86     mapping (string => address) internal oracleByName;
87 
88     address[] public oracleAddresses;
89 
90     struct OracleMetadata {
91         address oracle;
92         string name;
93     }
94 
95     modifier oracleExists(address _oracle) {
96         require(oracles[_oracle].oracle != address(0), "OracleRegistry::oracle doesn't exist");
97         _;
98     }
99 
100     modifier oracleDoesNotExist(address _oracle) {
101         require(oracles[_oracle].oracle == address(0), "OracleRegistry::oracle exists");
102         _;
103     }
104 
105     modifier nameDoesNotExist(string memory _name) {
106         require(oracleByName[_name] == address(0), "OracleRegistry::name exists");
107         _;
108     }
109 
110     modifier addressNotNull(address _address) {
111         require(_address != address(0), "OracleRegistry::address is null");
112         _;
113     }
114 
115     /// @dev Allows owner to add a new oracle to the registry.
116     /// @param _oracle Address of new oracle.
117     /// @param _name Name of new oracle.
118     function addOracle(
119         address _oracle,
120         string memory _name)
121         public
122         onlyOwner
123         oracleDoesNotExist(_oracle)
124         addressNotNull(_oracle)
125         nameDoesNotExist(_name)
126     {
127         oracles[_oracle] = OracleMetadata({
128             oracle: _oracle,
129             name: _name
130         });
131         oracleAddresses.push(_oracle);
132         oracleByName[_name] = _oracle;
133         emit LogAddOracle(
134             _oracle,
135             _name
136         );
137     }
138 
139     /// @dev Allows owner to remove an existing oracle from the registry.
140     /// @param _oracle Address of existing oracle.
141     function removeOracle(address _oracle, uint256 _index)
142         public
143         onlyOwner
144         oracleExists(_oracle)
145     {
146         require(oracleAddresses[_index] == _oracle, "OracleRegistry::invalid index");
147 
148         oracleAddresses[_index] = oracleAddresses[oracleAddresses.length - 1];
149         oracleAddresses.length -= 1;
150 
151         OracleMetadata storage oracle = oracles[_oracle];
152         emit LogRemoveOracle(
153             oracle.oracle,
154             oracle.name
155         );
156         delete oracleByName[oracle.name];
157         delete oracles[_oracle];
158     }
159 
160     /// @dev Allows owner to modify an existing oracle's name.
161     /// @param _oracle Address of existing oracle.
162     /// @param _name New name.
163     function setOracleName(address _oracle, string memory _name)
164         public
165         onlyOwner
166         oracleExists(_oracle)
167         nameDoesNotExist(_name)
168     {
169         OracleMetadata storage oracle = oracles[_oracle];
170         emit LogOracleNameChange(_oracle, oracle.name, _name);
171         delete oracleByName[oracle.name];
172         oracleByName[_name] = _oracle;
173         oracle.name = _name;
174     }
175 
176     /// @dev Checks if an oracle exists in the registry
177     /// @param _oracle Address of registered oracle.
178     /// @return True if exists, False otherwise.
179     function hasOracle(address _oracle)
180         public
181         view
182         returns (bool) {
183         return (oracles[_oracle].oracle == _oracle);
184     }
185 
186     /// @dev Provides a registered oracle's address when given the oracle name.
187     /// @param _name Name of registered oracle.
188     /// @return Oracle's address.
189     function getOracleAddressByName(string memory _name)
190         public
191         view
192         returns (address) {
193         return oracleByName[_name];
194     }
195 
196     /// @dev Provides a registered oracle's metadata, looked up by address.
197     /// @param _oracle Address of registered oracle.
198     /// @return Oracle metadata.
199     function getOracleMetaData(address _oracle)
200         public
201         view
202         returns (
203             address,  //oracleAddress
204             string memory   //name
205         )
206     {
207         OracleMetadata memory oracle = oracles[_oracle];
208         return (
209             oracle.oracle,
210             oracle.name
211         );
212     }
213 
214     /// @dev Provides a registered oracle's metadata, looked up by name.
215     /// @param _name Name of registered oracle.
216     /// @return Oracle metadata.
217     function getOracleByName(string memory _name)
218         public
219         view
220         returns (
221             address,  //oracleAddress
222             string memory    //name
223         )
224     {
225         address _oracle = oracleByName[_name];
226         return getOracleMetaData(_oracle);
227     }
228 
229     /// @dev Returns an array containing all oracle addresses.
230     /// @return Array of oracle addresses.
231     function getOracleAddresses()
232         public
233         view
234         returns (address[] memory)
235     {
236         return oracleAddresses;
237     }
238 
239     /// @dev Returns an array of oracle addresses, an array with the length of each oracle name, and a concatenated string of oracle names
240     /// @return Array of oracle names, array of name lengths, concatenated string of all names
241     function getOracleList()
242         public
243         view
244         returns (address[] memory, uint256[] memory, string memory)
245     {
246         address[] memory addresses = oracleAddresses;
247         uint256[] memory nameLengths = new uint256[](oracleAddresses.length);
248         string memory allStrings;
249 
250         if (oracleAddresses.length == 0)
251             return (addresses,nameLengths,allStrings);
252         
253         for (uint256 i = 0; i < oracleAddresses.length; i++) {
254             string memory tmp = oracles[oracleAddresses[i]].name;
255             nameLengths[i] = bytes(tmp).length;
256             allStrings = strConcat(allStrings, tmp);
257         }
258 
259         return (addresses, nameLengths, allStrings);
260     }
261 
262     /// @dev Concatenates two strings
263     /// @return concatenated string
264     function strConcat(
265         string  memory _a,
266         string  memory _b)
267         internal
268         pure
269         returns (string memory)
270     {
271         bytes memory _ba = bytes(_a);
272         bytes memory _bb = bytes(_b);
273         string memory ab = new string(_ba.length + _bb.length);
274         bytes memory bab = bytes(ab);
275         uint256 k = 0;
276         uint256 i;
277         for (i = 0; i < _ba.length; i++)
278             bab[k++] = _ba[i];
279         for (i = 0; i < _bb.length; i++)
280             bab[k++] = _bb[i];
281         
282         return string(bab);
283     }
284 }