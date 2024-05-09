1 /**
2  * Copyright 2017-2019, bZeroX, LLC. All Rights Reserved.
3  * Licensed under the Apache License, Version 2.0.
4  */
5 
6 pragma solidity 0.5.8;
7 pragma experimental ABIEncoderV2;
8 
9 
10 /**
11  * @title Ownable
12  * @dev The Ownable contract has an owner address, and provides basic authorization control
13  * functions, this simplifies the implementation of "user permissions".
14  */
15 contract Ownable {
16   address public owner;
17 
18 
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
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param _newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address _newOwner) public onlyOwner {
46     _transferOwnership(_newOwner);
47   }
48 
49   /**
50    * @dev Transfers control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function _transferOwnership(address _newOwner) internal {
54     require(_newOwner != address(0));
55     emit OwnershipTransferred(owner, _newOwner);
56     owner = _newOwner;
57   }
58 }
59 
60 contract TokenizedRegistry is Ownable {
61 
62     mapping (address => TokenMetadata) public tokens;
63     mapping (string => address) internal tokenBySymbol;
64     mapping (string => address) internal tokenByName;
65 
66     address[] public tokenAddresses;
67 
68     struct TokenMetadata {
69         address token;
70         address asset; // iToken -> loanToken, pToken -> tradeToken
71         string name;
72         string symbol;
73         uint256 tokenType; // 0=no type set, 1=iToken, 2=pToken
74         uint256 index;
75     }
76 
77     modifier tokenExists(address _token) {
78         require(tokens[_token].token != address(0), "token doesn't exist");
79         _;
80     }
81 
82     modifier tokenDoesNotExist(address _token) {
83         require(tokens[_token].token == address(0), "token exists");
84         _;
85     }
86 
87     modifier nameDoesNotExist(string memory _name) {
88         require(tokenByName[_name] == address(0), "name exists");
89         _;
90     }
91 
92     modifier symbolDoesNotExist(string memory _symbol) {
93         require(tokenBySymbol[_symbol] == address(0), "symbol exists");
94         _;
95     }
96 
97     modifier addressNotNull(address _address) {
98         require(_address != address(0), "address is null");
99         _;
100     }
101 
102     function addTokens(
103         address[] memory _tokens,
104         address[] memory _assets,
105         string[] memory _names,
106         string[] memory _symbols,
107         uint256[] memory _types)
108         public
109         onlyOwner
110     {
111         require(_tokens.length == _assets.length
112                 && _assets.length == _names.length
113                 && _names.length == _symbols.length
114                 && _symbols.length == _types.length, "array length mismatch");
115 
116         for(uint256 i=0; i < _tokens.length; i++) {
117             addToken(
118                 _tokens[i],
119                 _assets[i],
120                 _names[i],
121                 _symbols[i],
122                 _types[i]
123             );
124         }
125     }
126 
127     function removeTokens(
128         address[] memory _tokens)
129         public
130         onlyOwner
131     {
132         for(uint256 i=0; i < _tokens.length; i++) {
133             removeToken(_tokens[i]);
134         }
135     }
136 
137     /// @dev Allows owner to add a new token to the registry.
138     /// @param _token Address of new token.
139     /// @param _asset Asset address of new token.
140     /// @param _name Name of new token.
141     /// @param _symbol Symbol for new token.
142     /// @param _type TokenType (iToken, pToken, etc.) for new token.
143     function addToken(
144         address _token,
145         address _asset,
146         string memory _name,
147         string memory _symbol,
148         uint256 _type)
149         public
150         onlyOwner
151         tokenDoesNotExist(_token)
152         addressNotNull(_token)
153         symbolDoesNotExist(_symbol)
154         nameDoesNotExist(_name)
155     {
156         tokens[_token] = TokenMetadata({
157             token: _token,
158             asset: _asset,
159             name: _name,
160             symbol: _symbol,
161             tokenType: _type,
162             index: tokenAddresses.length
163         });
164         tokenAddresses.push(_token);
165         tokenBySymbol[_symbol] = _token;
166         tokenByName[_name] = _token;
167     }
168 
169     /// @dev Allows owner to remove an existing token from the registry.
170     /// @param _token Address of existing token.
171     function removeToken(
172         address _token)
173         public
174         onlyOwner
175         tokenExists(_token)
176     {
177         uint256 _index = tokens[_token].index;
178         require(tokenAddresses[_index] == _token, "invalid index");
179 
180         tokenAddresses[_index] = tokenAddresses[tokenAddresses.length - 1];
181         tokenAddresses.length -= 1;
182         tokens[tokenAddresses[_index]].index = _index;
183 
184         TokenMetadata memory token = tokens[_token];
185         delete tokenBySymbol[token.symbol];
186         delete tokenByName[token.name];
187         delete tokens[_token];
188     }
189 
190     /// @dev Allows owner to modify an existing token's name.
191     /// @param _token Address of existing token.
192     /// @param _name New name.
193     function setTokenName(address _token, string memory _name)
194         public
195         onlyOwner
196         tokenExists(_token)
197         nameDoesNotExist(_name)
198     {
199         TokenMetadata storage token = tokens[_token];
200         delete tokenByName[token.name];
201         tokenByName[_name] = _token;
202         token.name = _name;
203     }
204 
205     /// @dev Allows owner to modify an existing token's symbol.
206     /// @param _token Address of existing token.
207     /// @param _symbol New symbol.
208     function setTokenSymbol(address _token, string memory _symbol)
209         public
210         onlyOwner
211         tokenExists(_token)
212         symbolDoesNotExist(_symbol)
213     {
214         TokenMetadata storage token = tokens[_token];
215         delete tokenBySymbol[token.symbol];
216         tokenBySymbol[_symbol] = _token;
217         token.symbol = _symbol;
218     }
219 
220 
221     /*
222      * View functions
223      */
224     /// @dev Provides a registered token's address when given the token symbol.
225     /// @param _symbol Symbol of registered token.
226     /// @return Token's address.
227     function getTokenAddressBySymbol(string memory _symbol)
228         public
229         view
230         returns (address)
231     {
232         return tokenBySymbol[_symbol];
233     }
234 
235     /// @dev Provides a registered token's address when given the token name.
236     /// @param _name Name of registered token.
237     /// @return Token's address.
238     function getTokenAddressByName(string memory _name)
239         public
240         view
241         returns (address)
242     {
243         return tokenByName[_name];
244     }
245 
246     /// @dev Provides a registered token's metadata, looked up by address.
247     /// @param _token Address of registered token.
248     /// @return Token metadata.
249     function getTokenByAddress(address _token)
250         public
251         view
252         returns (TokenMetadata memory)
253     {
254         return tokens[_token];
255     }
256 
257     /// @dev Provides a registered token's metadata, looked up by name.
258     /// @param _name Name of registered token.
259     /// @return Token metadata.
260     function getTokenByName(string memory _name)
261         public
262         view
263         returns (TokenMetadata memory)
264     {
265         address _token = tokenByName[_name];
266         return getTokenByAddress(_token);
267     }
268 
269     /// @dev Provides a registered token's metadata, looked up by symbol.
270     /// @param _symbol Symbol of registered token.
271     /// @return Token metadata.
272     function getTokenBySymbol(string memory _symbol)
273         public
274         view
275         returns (TokenMetadata memory)
276     {
277         address _token = tokenBySymbol[_symbol];
278         return getTokenByAddress(_token);
279     }
280 
281     /// @dev Returns an array containing all token addresses.
282     /// @return Array of token addresses.
283     function getTokenAddresses()
284         public
285         view
286         returns (address[] memory)
287     {
288         return tokenAddresses;
289     }
290 
291     /// @dev Provides a list of registered token metadata.
292     /// @param _start The starting token to return.
293     /// @param _count The total amount of tokens to return if they exist. Amount returned can be less.
294     /// @param _tokenType Only return tokens matching this type (0 == return all).
295     /// @return Token metadata list.
296     function getTokens(
297         uint256 _start,
298         uint256 _count,
299         uint256 _tokenType)
300         public
301         view
302         returns (TokenMetadata[] memory tokenData)
303     {
304         uint256 end = min256(tokenAddresses.length, add(_start, _count));
305         if (end == 0 || _start >= end) {
306             return tokenData;
307         }
308 
309         uint256 actualSize;
310         TokenMetadata[] memory tokenDataComplete = new TokenMetadata[](end-_start);
311         end = end-_start;
312         uint256 i;
313         for (i=0; i < end-_start; i++) {
314             TokenMetadata memory token = tokens[tokenAddresses[i+_start]];
315             if (_tokenType > 0 && token.tokenType != _tokenType) {
316                 if (end < tokenAddresses.length)
317                     end++;
318 
319                 continue;
320             }
321             actualSize++;
322             tokenDataComplete[i] = token;
323         }
324         
325         if (tokenDataComplete.length == actualSize) {
326             return tokenDataComplete;
327         } else {
328             // clean up data
329             tokenData = new TokenMetadata[](actualSize);
330             uint256 j;
331             for (i=0; i < tokenDataComplete.length; i++) {
332                 if (tokenDataComplete[i].token != address(0)) {
333                     tokenData[j] = tokenDataComplete[i];
334                     j++;
335                 }
336             }
337             return tokenData;
338         }
339     }
340 
341     function isTokenType(
342         address _token,
343         uint256 _tokenType)
344         public
345         view
346         returns (bool valid)
347     {
348         (valid,) = _getTokenForType(
349             _token,
350             _tokenType
351         );
352     }
353 
354     function getTokenAsset(
355         address _token,
356         uint256 _tokenType)
357         public
358         view
359         returns (address)
360     {
361         bool valid;
362         TokenMetadata memory token;
363         (valid, token) = _getTokenForType(
364             _token,
365             _tokenType
366         );
367         if (valid) {
368             return token.asset;
369         } else {
370             return address(0);
371         }
372     }
373 
374     function _getTokenForType(
375         address _token,
376         uint256 _tokenType)
377         internal
378         view
379         returns (bool valid, TokenMetadata memory token)
380     {
381         token = tokens[_token];
382         if (token.token != address(0)
383             && token.token == _token
384             && (_tokenType == 0
385                 || token.tokenType == _tokenType))
386         {
387             valid = true;
388         } else {
389             valid = false;
390         }
391     }
392 
393     function add(
394         uint256 _a,
395         uint256 _b)
396         internal
397         pure
398         returns (uint256 c)
399     {
400         c = _a + _b;
401         assert(c >= _a);
402         return c;
403     }
404 
405     function min256(
406         uint256 _a,
407         uint256 _b)
408         internal
409         pure
410         returns (uint256)
411     {
412         return _a < _b ? _a : _b;
413     }
414 }