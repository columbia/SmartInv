1 /*
2 
3   Copyright 2017 ZeroEx Intl.
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   you may not use this file except in compliance with the License.
7   You may obtain a copy of the License at
8 
9     http://www.apache.org/licenses/LICENSE-2.0
10 
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 
17 */
18 
19 pragma solidity 0.4.11;
20 
21 /*
22  * Ownable
23  *
24  * Base contract with an owner.
25  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
26  */
27 contract Ownable {
28     address public owner;
29 
30     function Ownable() {
31         owner = msg.sender;
32     }
33 
34     modifier onlyOwner() {
35         require(msg.sender == owner);
36         _;
37     }
38 
39     function transferOwnership(address newOwner) onlyOwner {
40         if (newOwner != address(0)) {
41             owner = newOwner;
42         }
43     }
44 }
45 
46 
47 /// @title Token Registry - Stores metadata associated with ERC20 tokens. See ERC22 https://github.com/ethereum/EIPs/issues/22
48 /// @author Amir Bandeali - <amir@0xProject.com>, Will Warren - <will@0xProject.com>
49 contract TokenRegistry is Ownable {
50 
51     event LogAddToken(
52         address indexed token,
53         string name,
54         string symbol,
55         uint8 decimals,
56         bytes ipfsHash,
57         bytes swarmHash
58     );
59 
60     event LogRemoveToken(
61         address indexed token,
62         string name,
63         string symbol,
64         uint8 decimals,
65         bytes ipfsHash,
66         bytes swarmHash
67     );
68 
69     event LogTokenNameChange(address indexed token, string oldName, string newName);
70     event LogTokenSymbolChange(address indexed token, string oldSymbol, string newSymbol);
71     event LogTokenIpfsHashChange(address indexed token, bytes oldIpfsHash, bytes newIpfsHash);
72     event LogTokenSwarmHashChange(address indexed token, bytes oldSwarmHash, bytes newSwarmHash);
73 
74     mapping (address => TokenMetadata) public tokens;
75     mapping (string => address) tokenBySymbol;
76     mapping (string => address) tokenByName;
77 
78     address[] public tokenAddresses;
79 
80     struct TokenMetadata {
81         address token;
82         string name;
83         string symbol;
84         uint8 decimals;
85         bytes ipfsHash;
86         bytes swarmHash;
87     }
88 
89     modifier tokenExists(address _token) {
90         require(tokens[_token].token != address(0));
91         _;
92     }
93 
94     modifier tokenDoesNotExist(address _token) {
95         require(tokens[_token].token == address(0));
96         _;
97     }
98 
99     modifier nameDoesNotExist(string _name) {
100       require(tokenByName[_name] == address(0));
101       _;
102     }
103 
104     modifier symbolDoesNotExist(string _symbol) {
105         require(tokenBySymbol[_symbol] == address(0));
106         _;
107     }
108 
109     modifier addressNotNull(address _address) {
110         require(_address != address(0));
111         _;
112     }
113 
114 
115     /// @dev Allows owner to add a new token to the registry.
116     /// @param _token Address of new token.
117     /// @param _name Name of new token.
118     /// @param _symbol Symbol for new token.
119     /// @param _decimals Number of decimals, divisibility of new token.
120     /// @param _ipfsHash IPFS hash of token icon.
121     /// @param _swarmHash Swarm hash of token icon.
122     function addToken(
123         address _token,
124         string _name,
125         string _symbol,
126         uint8 _decimals,
127         bytes _ipfsHash,
128         bytes _swarmHash)
129         public
130         onlyOwner
131         tokenDoesNotExist(_token)
132         addressNotNull(_token)
133         symbolDoesNotExist(_symbol)
134         nameDoesNotExist(_name)
135     {
136         tokens[_token] = TokenMetadata({
137             token: _token,
138             name: _name,
139             symbol: _symbol,
140             decimals: _decimals,
141             ipfsHash: _ipfsHash,
142             swarmHash: _swarmHash
143         });
144         tokenAddresses.push(_token);
145         tokenBySymbol[_symbol] = _token;
146         tokenByName[_name] = _token;
147         LogAddToken(
148             _token,
149             _name,
150             _symbol,
151             _decimals,
152             _ipfsHash,
153             _swarmHash
154         );
155     }
156 
157     /// @dev Allows owner to remove an existing token from the registry.
158     /// @param _token Address of existing token.
159     function removeToken(address _token, uint _index)
160         public
161         onlyOwner
162         tokenExists(_token)
163     {
164         require(tokenAddresses[_index] == _token);
165 
166         tokenAddresses[_index] = tokenAddresses[tokenAddresses.length - 1];
167         tokenAddresses.length -= 1;
168 
169         TokenMetadata storage token = tokens[_token];
170         LogRemoveToken(
171             token.token,
172             token.name,
173             token.symbol,
174             token.decimals,
175             token.ipfsHash,
176             token.swarmHash
177         );
178         delete tokenBySymbol[token.symbol];
179         delete tokenByName[token.name];
180         delete tokens[_token];
181     }
182 
183     /// @dev Allows owner to modify an existing token's name.
184     /// @param _token Address of existing token.
185     /// @param _name New name.
186     function setTokenName(address _token, string _name)
187         public
188         onlyOwner
189         tokenExists(_token)
190         nameDoesNotExist(_name)
191     {
192         TokenMetadata storage token = tokens[_token];
193         LogTokenNameChange(_token, token.name, _name);
194         delete tokenByName[token.name];
195         tokenByName[_name] = _token;
196         token.name = _name;
197     }
198 
199     /// @dev Allows owner to modify an existing token's symbol.
200     /// @param _token Address of existing token.
201     /// @param _symbol New symbol.
202     function setTokenSymbol(address _token, string _symbol)
203         public
204         onlyOwner
205         tokenExists(_token)
206         symbolDoesNotExist(_symbol)
207     {
208         TokenMetadata storage token = tokens[_token];
209         LogTokenSymbolChange(_token, token.symbol, _symbol);
210         delete tokenBySymbol[token.symbol];
211         tokenBySymbol[_symbol] = _token;
212         token.symbol = _symbol;
213     }
214 
215     /// @dev Allows owner to modify an existing token's IPFS hash.
216     /// @param _token Address of existing token.
217     /// @param _ipfsHash New IPFS hash.
218     function setTokenIpfsHash(address _token, bytes _ipfsHash)
219         public
220         onlyOwner
221         tokenExists(_token)
222     {
223         TokenMetadata storage token = tokens[_token];
224         LogTokenIpfsHashChange(_token, token.ipfsHash, _ipfsHash);
225         token.ipfsHash = _ipfsHash;
226     }
227 
228     /// @dev Allows owner to modify an existing token's Swarm hash.
229     /// @param _token Address of existing token.
230     /// @param _swarmHash New Swarm hash.
231     function setTokenSwarmHash(address _token, bytes _swarmHash)
232         public
233         onlyOwner
234         tokenExists(_token)
235     {
236         TokenMetadata storage token = tokens[_token];
237         LogTokenSwarmHashChange(_token, token.swarmHash, _swarmHash);
238         token.swarmHash = _swarmHash;
239     }
240 
241     /*
242      * Web3 call functions
243      */
244 
245     /// @dev Provides a registered token's address when given the token symbol.
246     /// @param _symbol Symbol of registered token.
247     /// @return Token's address.
248     function getTokenAddressBySymbol(string _symbol) constant returns (address) {
249         return tokenBySymbol[_symbol];
250     }
251 
252     /// @dev Provides a registered token's address when given the token name.
253     /// @param _name Name of registered token.
254     /// @return Token's address.
255     function getTokenAddressByName(string _name) constant returns (address) {
256         return tokenByName[_name];
257     }
258 
259     /// @dev Provides a registered token's metadata, looked up by address.
260     /// @param _token Address of registered token.
261     /// @return Token metadata.
262     function getTokenMetaData(address _token)
263         public
264         constant
265         returns (
266             address,  //tokenAddress
267             string,   //name
268             string,   //symbol
269             uint8,    //decimals
270             bytes,    //ipfsHash
271             bytes     //swarmHash
272         )
273     {
274         TokenMetadata memory token = tokens[_token];
275         return (
276             token.token,
277             token.name,
278             token.symbol,
279             token.decimals,
280             token.ipfsHash,
281             token.swarmHash
282         );
283     }
284 
285     /// @dev Provides a registered token's metadata, looked up by name.
286     /// @param _name Name of registered token.
287     /// @return Token metadata.
288     function getTokenByName(string _name)
289         public
290         constant
291         returns (
292             address,  //tokenAddress
293             string,   //name
294             string,   //symbol
295             uint8,    //decimals
296             bytes,    //ipfsHash
297             bytes     //swarmHash
298         )
299     {
300         address _token = tokenByName[_name];
301         return getTokenMetaData(_token);
302     }
303 
304     /// @dev Provides a registered token's metadata, looked up by symbol.
305     /// @param _symbol Symbol of registered token.
306     /// @return Token metadata.
307     function getTokenBySymbol(string _symbol)
308         public
309         constant
310         returns (
311             address,  //tokenAddress
312             string,   //name
313             string,   //symbol
314             uint8,    //decimals
315             bytes,    //ipfsHash
316             bytes     //swarmHash
317         )
318     {
319         address _token = tokenBySymbol[_symbol];
320         return getTokenMetaData(_token);
321     }
322 
323     /// @dev Returns an array containing all token addresses.
324     /// @return Array of token addresses.
325     function getTokenAddresses()
326         public
327         constant
328         returns (address[])
329     {
330         return tokenAddresses;
331     }
332 }