1 
2 // File: contracts/utility/interfaces/IOwned.sol
3 
4 pragma solidity ^0.4.24;
5 
6 /*
7     Owned contract interface
8 */
9 contract IOwned {
10     // this function isn't abstract since the compiler emits automatically generated getter functions as external
11     function owner() public view returns (address) {}
12 
13     function transferOwnership(address _newOwner) public;
14     function acceptOwnership() public;
15 }
16 
17 // File: contracts/utility/Owned.sol
18 
19 pragma solidity ^0.4.24;
20 
21 
22 /*
23     Provides support and utilities for contract ownership
24 */
25 contract Owned is IOwned {
26     address public owner;
27     address public newOwner;
28 
29     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
30 
31     /**
32         @dev constructor
33     */
34     constructor() public {
35         owner = msg.sender;
36     }
37 
38     // allows execution by the owner only
39     modifier ownerOnly {
40         require(msg.sender == owner);
41         _;
42     }
43 
44     /**
45         @dev allows transferring the contract ownership
46         the new owner still needs to accept the transfer
47         can only be called by the contract owner
48 
49         @param _newOwner    new contract owner
50     */
51     function transferOwnership(address _newOwner) public ownerOnly {
52         require(_newOwner != owner);
53         newOwner = _newOwner;
54     }
55 
56     /**
57         @dev used by a new owner to accept an ownership transfer
58     */
59     function acceptOwnership() public {
60         require(msg.sender == newOwner);
61         emit OwnerUpdate(owner, newOwner);
62         owner = newOwner;
63         newOwner = address(0);
64     }
65 }
66 
67 // File: contracts/utility/Utils.sol
68 
69 pragma solidity ^0.4.24;
70 
71 /*
72     Utilities & Common Modifiers
73 */
74 contract Utils {
75     /**
76         constructor
77     */
78     constructor() public {
79     }
80 
81     // verifies that an amount is greater than zero
82     modifier greaterThanZero(uint256 _amount) {
83         require(_amount > 0);
84         _;
85     }
86 
87     // validates an address - currently only checks that it isn't null
88     modifier validAddress(address _address) {
89         require(_address != address(0));
90         _;
91     }
92 
93     // verifies that the address is different than this contract address
94     modifier notThis(address _address) {
95         require(_address != address(this));
96         _;
97     }
98 
99 }
100 
101 // File: contracts/BancorConverterRegistry.sol
102 
103 pragma solidity ^0.4.24;
104 
105 
106 
107 /**
108     Bancor Converter Registry
109 
110     The bancor converter registry keeps converter addresses by token addresses and vice versa.
111     The owner can update converter addresses so that a the token address always points to
112     the updated list of converters for each token.
113 
114     The contract also allows to iterate through all the tokens in the network.
115 
116     Note that converter addresses for each token are returned in ascending order (from oldest
117     to latest).
118 */
119 contract BancorConverterRegistry is Owned, Utils {
120     mapping (address => bool) private tokensRegistered;         // token address -> registered or not
121     mapping (address => address[]) private tokensToConverters;  // token address -> converter addresses
122     mapping (address => address) private convertersToTokens;    // converter address -> token address
123     address[] public tokens;                                    // list of all token addresses
124 
125     // triggered when a converter is added to the registry
126     event ConverterAddition(address indexed _token, address _address);
127 
128     // triggered when a converter is removed from the registry
129     event ConverterRemoval(address indexed _token, address _address);
130 
131     /**
132         @dev constructor
133     */
134     constructor() public {
135     }
136 
137     /**
138         @dev returns the number of tokens in the registry
139 
140         @return number of tokens
141     */
142     function tokenCount() public view returns (uint256) {
143         return tokens.length;
144     }
145 
146     /**
147         @dev returns the number of converters associated with the given token
148         or 0 if the token isn't registered
149 
150         @param _token   token address
151 
152         @return number of converters
153     */
154     function converterCount(address _token) public view returns (uint256) {
155         return tokensToConverters[_token].length;
156     }
157 
158     /**
159         @dev returns the converter address associated with the given token
160         or zero address if no such converter exists
161 
162         @param _token   token address
163         @param _index   converter index
164 
165         @return converter address
166     */
167     function converterAddress(address _token, uint32 _index) public view returns (address) {
168         if (_index >= tokensToConverters[_token].length)
169             return address(0);
170 
171         return tokensToConverters[_token][_index];
172     }
173 
174     /**
175         @dev returns the token address associated with the given converter
176         or zero address if no such converter exists
177 
178         @param _converter   converter address
179 
180         @return token address
181     */
182     function tokenAddress(address _converter) public view returns (address) {
183         return convertersToTokens[_converter];
184     }
185 
186     /**
187         @dev adds a new converter address for a given token to the registry
188         throws if the converter is already registered
189 
190         @param _token       token address
191         @param _converter   converter address
192     */
193     function registerConverter(address _token, address _converter)
194         public
195         ownerOnly
196         validAddress(_token)
197         validAddress(_converter)
198     {
199         require(convertersToTokens[_converter] == address(0));
200 
201         // add the token to the list of tokens
202         if (!tokensRegistered[_token]) {
203             tokens.push(_token);
204             tokensRegistered[_token] = true;
205         }
206 
207         tokensToConverters[_token].push(_converter);
208         convertersToTokens[_converter] = _token;
209 
210         // dispatch the converter addition event
211         emit ConverterAddition(_token, _converter);
212     }
213 
214     /**
215         @dev removes an existing converter from the registry
216         note that the function doesn't scale and might be needed to be called
217         multiple times when removing an older converter from a large converter list
218 
219         @param _token   token address
220         @param _index   converter index
221     */
222     function unregisterConverter(address _token, uint32 _index)
223         public
224         ownerOnly
225         validAddress(_token)
226     {
227         require(_index < tokensToConverters[_token].length);
228 
229         address converter = tokensToConverters[_token][_index];
230 
231         // move all newer converters 1 position lower
232         for (uint32 i = _index + 1; i < tokensToConverters[_token].length; i++) {
233             tokensToConverters[_token][i - 1] = tokensToConverters[_token][i];
234         }
235 
236         // decrease the number of converters defined for the token by 1
237         tokensToConverters[_token].length--;
238         
239         // removes the converter from the converters -> tokens list
240         delete convertersToTokens[converter];
241 
242         // dispatch the converter removal event
243         emit ConverterRemoval(_token, converter);
244     }
245 }
