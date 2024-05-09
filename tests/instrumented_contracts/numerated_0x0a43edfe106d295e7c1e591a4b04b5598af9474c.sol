1 library TokenLib {
2     struct Token {
3         string identity;
4         address owner;
5     }
6 
7     function id(Token storage self) returns (bytes32) {
8         return sha3(self.identity);
9     }
10 
11     function generateId(string identity) returns (bytes32) {
12         return sha3(identity);
13     }
14 
15     event Transfer(address indexed _from, address indexed _to, bytes32 _value);
16     event Approval(address indexed _owner, address indexed _spender, bytes32 _value);
17 
18     function logApproval(address _owner, address _spender, bytes32 _value) {
19         Approval(_owner, _spender, _value);
20     }
21 
22     function logTransfer(address _from, address _to, bytes32 _value) {
23         Transfer(_from, _to, _value);
24     }
25 }
26 
27 contract TokenInterface {
28     /*
29      *  Events
30      */
31     event Mint(address indexed _to, bytes32 _id);
32     event Destroy(bytes32 _id);
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35     event MinterAdded(address who);
36     event MinterRemoved(address who);
37 
38     /*
39      *  Minting
40      */
41     /// @dev Mints a new token.
42     /// @param _to Address of token owner.
43     /// @param _identity String for owner identity.
44     function mint(address _to, string _identity) returns (bool success);
45 
46     /// @dev Destroy a token
47     /// @param _id Bytes32 id of the token to destroy.
48     function destroy(bytes32 _id) returns (bool success);
49 
50     /// @dev Add a new minter
51     /// @param who Address the address that can now mint tokens.
52     function addMinter(address who) returns (bool);
53 
54     /// @dev Remove a minter
55     /// @param who Address the address that will no longer be a minter.
56     function removeMinter(address who) returns (bool);
57 
58     /*
59      *  Read and write storage functions
60      */
61 
62     /// @dev Return the number of tokens
63     function totalSupply() returns (uint supply);
64 
65     /// @dev Transfers sender token to given address. Returns success.
66     /// @param _to Address of new token owner.
67     /// @param _value Bytes32 id of the token to transfer.
68     function transfer(address _to, uint256 _value) returns (bool success);
69     function transfer(address _to, bytes32 _value) returns (bool success);
70 
71     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
72     /// @param _from Address of token owner.
73     /// @param _to Address of new token owner.
74     /// @param _value Bytes32 id of the token to transfer.
75     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
76     function transferFrom(address _from, address _to, bytes32 _value) returns (bool success);
77 
78     /// @dev Sets approval spender to transfer ownership of token. Returns success.
79     /// @param _spender Address of spender..
80     /// @param _value Bytes32 id of token that can be spend.
81     function approve(address _spender, uint256 _value) returns (bool success);
82     function approve(address _spender, bytes32 _value) returns (bool success);
83 
84     /*
85      * Read storage functions
86      */
87     /// @dev Returns id of token owned by given address (encoded as an integer).
88     /// @param _owner Address of token owner.
89     function balanceOf(address _owner) constant returns (uint256 balance);
90 
91     /// @dev Returns the token id that may transfer from _owner account by _spender..
92     /// @param _owner Address of token owner.
93     /// @param _spender Address of token spender.
94     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
95 
96     /*
97      *  Extra non ERC20 functions
98      */
99     /// @dev Returns whether the address owns a token.
100     /// @param _owner Address to check.
101     function isTokenOwner(address _owner) constant returns (bool);
102 
103     /// @dev Returns the identity of the given token id.
104     /// @param _id Bytes32 id of token to lookup.
105     function identityOf(bytes32 _id) constant returns (string identity);
106 
107     /// @dev Returns the address of the owner of the given token id.
108     /// @param _id Bytes32 id of token to lookup.
109     function ownerOf(bytes32 _id) constant returns (address owner);
110 }
111 
112 contract Devcon2Token is TokenInterface {
113     using TokenLib for TokenLib.Token;
114 
115     /*
116      *  +----------------+
117      *  | Administrative |
118      *  +----------------+
119      */
120     mapping (address => bool) public minters;
121     uint constant _END_MINTING = 1474502400;  // UTC (2016/09/22 - 00:00:00)
122 
123     function END_MINTING() constant returns (uint) {
124         return _END_MINTING;
125     }
126 
127     function Devcon2Token() {
128         minters[msg.sender] = true;
129         MinterAdded(msg.sender);
130     }
131 
132     /*
133      *  +------------+
134      *  | Token Data |
135      *  +------------+
136      */
137     uint numTokens;
138 
139     // id => Token
140     mapping (bytes32 => TokenLib.Token) tokens;
141 
142     // owner => ownedToken.id
143     mapping (address => bytes32) public ownedToken;
144 
145     // owner => spender => ownedToken.id
146     mapping (address => mapping (address => bytes32)) approvals;
147 
148     /*
149      *  Read and write storage functions
150      */
151     /// @dev Mints a new token
152     /// @param _to Address of token owner.
153     /// @param _identity String for owner identity.
154     function mint(address _to, string _identity) returns (bool success) {
155         // only mintable till end of conference
156         if (now >= _END_MINTING) throw;
157 
158         // ensure the msg.sender is allowed to mint.
159         if (!minters[msg.sender]) return false;
160 
161         // ensure that the token owner doesn't already own a token.
162         if (ownedToken[_to] != 0x0) return false;
163 
164         // generate the token id and get the token.
165         bytes32 id = TokenLib.generateId(_identity);
166         var token = tokens[id];
167 
168         // don't allow re-minting of a given identity.
169         if (id == token.id()) return false;
170 
171         // set the token data
172         token.owner = _to;
173         token.identity = _identity;
174         ownedToken[_to] = id;
175 
176         // log the minting of this token.
177         Mint(_to, id);
178 
179         // increase the supply.
180         numTokens += 1;
181 
182         return true;
183     }
184 
185     /// @dev Destroy a token
186     /// @param _id Bytes32 id of the token to be destroyed
187     function destroy(bytes32 _id) returns (bool success) {
188         // only mintable till end of conference
189         if (now >= _END_MINTING) throw;
190 
191         // ensure the msg.sender is allowed to mint.
192         if (!minters[msg.sender]) return false;
193 
194         // pull the token to destroy
195         var tokenToDestroy = tokens[_id];
196 
197         // Remove any ownership data
198         ownedToken[tokenToDestroy.owner] = 0x0;
199 
200         // Zero out the actual token data
201         tokenToDestroy.identity = '';
202         tokenToDestroy.owner = 0x0;
203 
204         // Log the destruction
205         Destroy(_id);
206 
207         // decrease the supply.
208         numTokens -= 1;
209         
210         return true;
211     }
212 
213     /// @dev Add a new minter
214     /// @param who Address the address that can now mint tokens.
215     function addMinter(address who) returns (bool) {
216         // only mintable till end of conference
217         if (now >= _END_MINTING) throw;
218 
219         // ensure the msg.sender is allowed
220         if (!minters[msg.sender]) return false;
221 
222         minters[who] = true;
223 
224         // Log it
225         MinterAdded(who);
226 
227         return true;
228     }
229 
230     /// @dev Remove a minter
231     /// @param who Address the address that will no longer be a minter.
232     function removeMinter(address who) returns (bool) {
233         // ensure the msg.sender is allowed
234         if (!minters[msg.sender]) return false;
235 
236         minters[who] = false;
237 
238         // Log it
239         MinterRemoved(who);
240 
241         return true;
242     }
243 
244     /// @dev Transfers sender token to given address. Returns success.
245     /// @param _to Address of new token owner.
246     /// @param _value Bytes32 id of the token to transfer.
247     function transfer(address _to, uint256 _value) returns (bool success) {
248         return transfer(_to, bytes32(_value));
249     }
250 
251     function transfer(address _to, bytes32 _value) returns (bool success) {
252         // dont allow the null token.
253         if (_value == 0x0) return false;
254 
255         // ensure it is actually a token
256         if (tokens[_value].id() != _value) return false;
257 
258         // ensure that the new owner doesn't already own a token.
259         if (ownedToken[_to] != 0x0) return false;
260 
261         // get the token
262         var tokenToTransfer = tokens[_value];
263 
264         // ensure msg.sender is the token owner.
265         if (tokenToTransfer.owner != msg.sender) return false;
266 
267         // set the new owner.
268         tokenToTransfer.owner = _to;
269         ownedToken[msg.sender] = 0x0;
270         ownedToken[_to] = _value;
271 
272         // log the transfer
273         //Transfer(msg.sender, _to, uint(_value));
274         TokenLib.logTransfer(msg.sender, _to, _value);
275 
276         return true;
277     }
278 
279     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
280     /// @param _from Address of token owner.
281     /// @param _to Address of new token owner.
282     /// @param _value Bytes32 id of the token to transfer.
283     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
284         return transferFrom(_from, _to, bytes32(_value));
285     }
286 
287     function transferFrom(address _from, address _to, bytes32 _value) returns (bool success) {
288         // dont allow the null token.
289         if (_value == 0x0) return false;
290 
291         // ensure it is actually a token
292         if (tokens[_value].id() != _value) return false;
293 
294         // ensure that the new owner doesn't already own a token.
295         if (ownedToken[_to] != 0x0) return false;
296 
297         // get the token
298         var tokenToTransfer = tokens[_value];
299 
300         // ensure that _from actually owns this token.
301         if (tokenToTransfer.owner != _from) return false;
302         if (ownedToken[_from] != _value) return false;
303 
304         // ensure that they are approved to transfer this token.
305         if (approvals[_from][msg.sender] != _value) return false;
306 
307         // do the transfer
308         tokenToTransfer.owner = _to;
309         ownedToken[_from] = 0x0;
310         ownedToken[_to] = _value;
311         approvals[_from][msg.sender] = 0x0;
312 
313         // log the transfer
314         Transfer(_from, _to, uint(_value));
315         TokenLib.logTransfer(_from, _to, _value);
316 
317         return true;
318     }
319 
320     /// @dev Sets approval spender to transfer ownership of token. Returns success.
321     /// @param _spender Address of spender..
322     /// @param _value Bytes32 id of token that can be spend.
323     function approve(address _spender, uint256 _value) returns (bool success) {
324         return approve(_spender, bytes32(_value));
325     }
326 
327     function approve(address _spender, bytes32 _value) returns (bool success) {
328         // dont allow the null token.
329         if (_value == 0x0) return false;
330 
331         // ensure it is actually a token
332         if (tokens[_value].id() != _value) return false;
333 
334         // get the token that is being approved.
335         var tokenToApprove = tokens[_value];
336 
337         // ensure they own this token.
338         if (tokenToApprove.owner != msg.sender) return false;
339         if (ownedToken[msg.sender] != _value) return false;
340 
341         // set the approval
342         approvals[msg.sender][_spender] = _value;
343 
344         // Log the approval
345         Approval(msg.sender, _spender, uint(_value));
346         TokenLib.logApproval(msg.sender, _spender, _value);
347 
348         return true;
349     }
350 
351     /*
352      * Read storage functions
353      */
354     /// @dev Return the number of tokens
355     function totalSupply() returns (uint supply) {
356         return numTokens;
357     }
358 
359     /// @dev Returns id of token owned by given address (encoded as an integer).
360     /// @param _owner Address of token owner.
361     function balanceOf(address _owner) constant returns (uint256 balance) {
362         return uint(ownedToken[_owner]);
363     }
364 
365     /// @dev Returns number of allowed tokens for given address.
366     /// @param _owner Address of token owner.
367     /// @param _spender Address of token spender.
368     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
369         return uint(approvals[_owner][_spender]);
370     }
371 
372     /*
373      *  Extra non ERC20 functions
374      */
375     /// @dev Returns whether the address owns a token.
376     /// @param _owner Address to check.
377     function isTokenOwner(address _owner) constant returns (bool) {
378         return (ownedToken[_owner] != 0x0 && tokens[ownedToken[_owner]].owner == _owner);
379     }
380 
381     /// @dev Returns the identity of the given token id.
382     /// @param _id Bytes32 id of token to lookup.
383     function identityOf(bytes32 _id) constant returns (string identity) {
384         return tokens[_id].identity;
385     }
386 
387     /// @dev Returns the address of the owner of the given token id.
388     /// @param _id Bytes32 id of token to lookup.
389     function ownerOf(bytes32 _id) constant returns (address owner) {
390         return tokens[_id].owner;
391     }
392 }