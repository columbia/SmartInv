1 /*
2 
3   Copyright 2017 ZeroEx Intl.
4   Modifications Copyright 2018 bZeroX, LLC
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
81 contract TokenRegistry is Ownable {
82 
83     event LogAddToken(
84         address indexed token,
85         string name,
86         string symbol,
87         uint8 decimals,
88         string url
89     );
90 
91     event LogRemoveToken(
92         address indexed token,
93         string name,
94         string symbol,
95         uint8 decimals,
96         string url
97     );
98 
99     event LogTokenNameChange(address indexed token, string oldName, string newName);
100     event LogTokenSymbolChange(address indexed token, string oldSymbol, string newSymbol);
101     event LogTokenURLChange(address indexed token, string oldURL, string newURL);
102 
103     mapping (address => TokenMetadata) public tokens;
104     mapping (string => address) internal tokenBySymbol;
105     mapping (string => address) internal tokenByName;
106 
107     address[] public tokenAddresses;
108 
109     struct TokenMetadata {
110         address token;
111         string name;
112         string symbol;
113         uint8 decimals;
114         string url;
115     }
116 
117     modifier tokenExists(address _token) {
118         require(tokens[_token].token != address(0), "TokenRegistry::token doesn't exist");
119         _;
120     }
121 
122     modifier tokenDoesNotExist(address _token) {
123         require(tokens[_token].token == address(0), "TokenRegistry::token exists");
124         _;
125     }
126 
127     modifier nameDoesNotExist(string _name) {
128         require(tokenByName[_name] == address(0), "TokenRegistry::name exists");
129         _;
130     }
131 
132     modifier symbolDoesNotExist(string _symbol) {
133         require(tokenBySymbol[_symbol] == address(0), "TokenRegistry::symbol exists");
134         _;
135     }
136 
137     modifier addressNotNull(address _address) {
138         require(_address != address(0), "TokenRegistry::address is null");
139         _;
140     }
141 
142     /// @dev Allows owner to add a new token to the registry.
143     /// @param _token Address of new token.
144     /// @param _name Name of new token.
145     /// @param _symbol Symbol for new token.
146     /// @param _decimals Number of decimals, divisibility of new token.
147     /// @param _url URL of token icon.
148     function addToken(
149         address _token,
150         string _name,
151         string _symbol,
152         uint8 _decimals,
153         string _url)
154         public
155         onlyOwner
156         tokenDoesNotExist(_token)
157         addressNotNull(_token)
158         symbolDoesNotExist(_symbol)
159         nameDoesNotExist(_name)
160     {
161         tokens[_token] = TokenMetadata({
162             token: _token,
163             name: _name,
164             symbol: _symbol,
165             decimals: _decimals,
166             url: _url
167         });
168         tokenAddresses.push(_token);
169         tokenBySymbol[_symbol] = _token;
170         tokenByName[_name] = _token;
171         emit LogAddToken(
172             _token,
173             _name,
174             _symbol,
175             _decimals,
176             _url
177         );
178     }
179 
180     /// @dev Allows owner to remove an existing token from the registry.
181     /// @param _token Address of existing token.
182     function removeToken(address _token, uint _index)
183         public
184         onlyOwner
185         tokenExists(_token)
186     {
187         require(tokenAddresses[_index] == _token, "TokenRegistry::invalid index");
188 
189         tokenAddresses[_index] = tokenAddresses[tokenAddresses.length - 1];
190         tokenAddresses.length -= 1;
191 
192         TokenMetadata storage token = tokens[_token];
193         emit LogRemoveToken(
194             token.token,
195             token.name,
196             token.symbol,
197             token.decimals,
198             token.url
199         );
200         delete tokenBySymbol[token.symbol];
201         delete tokenByName[token.name];
202         delete tokens[_token];
203     }
204 
205     /// @dev Allows owner to modify an existing token's name.
206     /// @param _token Address of existing token.
207     /// @param _name New name.
208     function setTokenName(address _token, string _name)
209         public
210         onlyOwner
211         tokenExists(_token)
212         nameDoesNotExist(_name)
213     {
214         TokenMetadata storage token = tokens[_token];
215         emit LogTokenNameChange(_token, token.name, _name);
216         delete tokenByName[token.name];
217         tokenByName[_name] = _token;
218         token.name = _name;
219     }
220 
221     /// @dev Allows owner to modify an existing token's symbol.
222     /// @param _token Address of existing token.
223     /// @param _symbol New symbol.
224     function setTokenSymbol(address _token, string _symbol)
225         public
226         onlyOwner
227         tokenExists(_token)
228         symbolDoesNotExist(_symbol)
229     {
230         TokenMetadata storage token = tokens[_token];
231         emit LogTokenSymbolChange(_token, token.symbol, _symbol);
232         delete tokenBySymbol[token.symbol];
233         tokenBySymbol[_symbol] = _token;
234         token.symbol = _symbol;
235     }
236 
237     /// @dev Allows owner to modify an existing token's icon URL.
238     /// @param _token URL of token token.
239     /// @param _url New URL to token icon.
240     function setTokenURL(address _token, string _url)
241         public
242         onlyOwner
243         tokenExists(_token)
244     {
245         TokenMetadata storage token = tokens[_token];
246         emit LogTokenURLChange(_token, token.url, _url);
247         token.url = _url;
248     }
249 
250     /*
251      * View functions
252      */
253     /// @dev Provides a registered token's address when given the token symbol.
254     /// @param _symbol Symbol of registered token.
255     /// @return Token's address.
256     function getTokenAddressBySymbol(string _symbol) 
257         public
258         view 
259         returns (address)
260     {
261         return tokenBySymbol[_symbol];
262     }
263 
264     /// @dev Provides a registered token's address when given the token name.
265     /// @param _name Name of registered token.
266     /// @return Token's address.
267     function getTokenAddressByName(string _name) 
268         public
269         view
270         returns (address)
271     {
272         return tokenByName[_name];
273     }
274 
275     /// @dev Provides a registered token's metadata, looked up by address.
276     /// @param _token Address of registered token.
277     /// @return Token metadata.
278     function getTokenMetaData(address _token)
279         public
280         view
281         returns (
282             address,  //tokenAddress
283             string,   //name
284             string,   //symbol
285             uint8,    //decimals
286             string    //url
287         )
288     {
289         TokenMetadata memory token = tokens[_token];
290         return (
291             token.token,
292             token.name,
293             token.symbol,
294             token.decimals,
295             token.url
296         );
297     }
298 
299     /// @dev Provides a registered token's metadata, looked up by name.
300     /// @param _name Name of registered token.
301     /// @return Token metadata.
302     function getTokenByName(string _name)
303         public
304         view
305         returns (
306             address,  //tokenAddress
307             string,   //name
308             string,   //symbol
309             uint8,    //decimals
310             string    //url
311         )
312     {
313         address _token = tokenByName[_name];
314         return getTokenMetaData(_token);
315     }
316 
317     /// @dev Provides a registered token's metadata, looked up by symbol.
318     /// @param _symbol Symbol of registered token.
319     /// @return Token metadata.
320     function getTokenBySymbol(string _symbol)
321         public
322         view
323         returns (
324             address,  //tokenAddress
325             string,   //name
326             string,   //symbol
327             uint8,    //decimals
328             string    //url
329         )
330     {
331         address _token = tokenBySymbol[_symbol];
332         return getTokenMetaData(_token);
333     }
334 
335     /// @dev Returns an array containing all token addresses.
336     /// @return Array of token addresses.
337     function getTokenAddresses()
338         public
339         view
340         returns (address[])
341     {
342         return tokenAddresses;
343     }
344 }