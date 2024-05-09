1 pragma solidity ^0.4.0;
2 
3 library TokenEventLib {
4     /*
5      * When underlying solidity issue is fixed this library will not be needed.
6      * https://github.com/ethereum/solidity/issues/1215
7      */
8     event Transfer(address indexed _from,
9                    address indexed _to);
10     event Approval(address indexed _owner,
11                    address indexed _spender);
12 
13     function _Transfer(address _from, address _to) internal {
14         Transfer(_from, _to);
15     }
16 
17     function _Approval(address _owner, address _spender) internal {
18         Approval(_owner, _spender);
19     }
20 }
21 
22 contract TokenInterface {
23     /*
24      *  Events
25      */
26     event Mint(address indexed _owner);
27     event Destroy(address _owner);
28     event Transfer(address indexed _from, address indexed _to, uint256 _value);
29     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30     event MinterAdded(address who);
31     event MinterRemoved(address who);
32 
33     /*
34      *  Minting
35      */
36     /// @dev Mints a new token.
37     /// @param _owner Address of token owner.
38     function mint(address _owner) returns (bool success);
39 
40     /// @dev Destroy a token
41     /// @param _owner Bytes32 id of the owner of the token
42     function destroy(address _owner) returns (bool success);
43 
44     /// @dev Add a new minter
45     /// @param who Address the address that can now mint tokens.
46     function addMinter(address who) returns (bool);
47 
48     /// @dev Remove a minter
49     /// @param who Address the address that will no longer be a minter.
50     function removeMinter(address who) returns (bool);
51 
52     /*
53      *  Read and write storage functions
54      */
55 
56     /// @dev Return the number of tokens
57     function totalSupply() constant returns (uint supply);
58 
59     /// @dev Transfers sender token to given address. Returns success.
60     /// @param _to Address of new token owner.
61     /// @param _value Bytes32 id of the token to transfer.
62     function transfer(address _to, uint256 _value) returns (bool success);
63 
64     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
65     /// @param _from Address of token owner.
66     /// @param _to Address of new token owner.
67     /// @param _value Bytes32 id of the token to transfer.
68     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
69 
70     /// @dev Sets approval spender to transfer ownership of token. Returns success.
71     /// @param _spender Address of spender..
72     /// @param _value Bytes32 id of token that can be spend.
73     function approve(address _spender, uint256 _value) returns (bool success);
74 
75     /*
76      * Read storage functions
77      */
78     /// @dev Returns id of token owned by given address (encoded as an integer).
79     /// @param _owner Address of token owner.
80     function balanceOf(address _owner) constant returns (uint256 balance);
81 
82     /// @dev Returns the token id that may transfer from _owner account by _spender..
83     /// @param _owner Address of token owner.
84     /// @param _spender Address of token spender.
85     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
86 
87     /*
88      *  Extra non ERC20 functions
89      */
90     /// @dev Returns whether the address owns a token.
91     /// @param _owner Address to check.
92     function isTokenOwner(address _owner) constant returns (bool);
93 }
94 
95 contract IndividualityTokenInterface {
96     /*
97      * Read storage functions
98      */
99 
100     /// @dev Returns id of token owned by given address (encoded as an integer).
101     /// @param _owner Address of token owner.
102     function balanceOf(address _owner) constant returns (uint256 balance);
103 
104     /// @dev Returns the token id that may transfer from _owner account by _spender..
105     /// @param _owner Address of token owner.
106     /// @param _spender Address of token spender.
107     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
108 
109     /*
110      *  Write storage functions
111      */
112 
113     /// @dev Transfers sender token to given address. Returns success.
114     /// @param _to Address of new token owner.
115     /// @param _value Bytes32 id of the token to transfer.
116     function transfer(address _to, uint256 _value) public returns (bool success);
117     function transfer(address _to) public returns (bool success);
118 
119     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
120     /// @param _from Address of token owner.
121     /// @param _to Address of new token owner.
122     /// @param _value Bytes32 id of the token to transfer.
123     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
124     function transferFrom(address _from, address _to) public returns (bool success);
125 
126     /// @dev Sets approval spender to transfer ownership of token. Returns success.
127     /// @param _spender Address of spender..
128     /// @param _value Bytes32 id of token that can be spend.
129     function approve(address _spender, uint256 _value) public returns (bool success);
130     function approve(address _spender) public returns (bool success);
131 
132     /*
133      *  Extra non ERC20 functions
134      */
135 
136     /// @dev Returns whether the address owns a token.
137     /// @param _owner Address to check.
138     function isTokenOwner(address _owner) constant returns (bool);
139 }
140 
141 
142 contract IndividualityToken is TokenInterface, IndividualityTokenInterface {
143     function IndividualityToken() {
144         minters[msg.sender] = true;
145         MinterAdded(msg.sender);
146     }
147 
148     modifier minterOnly {
149         if(!minters[msg.sender]) throw;
150         _;
151     }
152 
153     // address => canmint
154     mapping (address => bool) minters;
155     
156     // owner => balance
157     mapping (address => uint) balances;
158 
159     // owner => spender => balance
160     mapping (address => mapping (address => uint)) approvals;
161 
162     uint numTokens;
163 
164     /// @dev Mints a new token.
165     /// @param _to Address of token owner.
166     function mint(address _to) minterOnly returns (bool success) {
167         // ensure that the token owner doesn't already own a token.
168         if (balances[_to] != 0x0) return false;
169 
170         balances[_to] = 1;
171 
172         // log the minting of this token.
173         Mint(_to);
174         Transfer(0x0, _to, 1);
175         TokenEventLib._Transfer(0x0, _to);
176 
177         // increase the supply.
178         numTokens += 1;
179 
180         return true;
181     }
182     
183     // @dev Mint many new tokens
184     function mint(address[] _to) minterOnly returns (bool success) {
185         for(uint i = 0; i < _to.length; i++) {
186             if(balances[_to[i]] != 0x0) return false;
187             balances[_to[i]] = 1;
188             Mint(_to[i]);
189             Transfer(0x0, _to[i], 1);
190             TokenEventLib._Transfer(0x0, _to[i]);
191         }
192         numTokens += _to.length;
193         return true;
194     }
195 
196     /// @dev Destroy a token
197     /// @param _owner address owner of the token to destroy
198     function destroy(address _owner) minterOnly returns (bool success) {
199         if(balances[_owner] != 1) throw;
200         
201         balances[_owner] = 0;
202         numTokens -= 1;
203         Destroy(_owner);
204         return true;
205     }
206 
207     /// @dev Add a new minter
208     /// @param who Address the address that can now mint tokens.
209     function addMinter(address who) minterOnly returns (bool) {
210         minters[who] = true;
211         MinterAdded(who);
212     }
213 
214     /// @dev Remove a minter
215     /// @param who Address the address that will no longer be a minter.
216     function removeMinter(address who) minterOnly returns (bool) {
217         minters[who] = false;
218         MinterRemoved(who);
219     }
220 
221     /// @dev Return the number of tokens
222     function totalSupply() constant returns (uint supply) {
223         return numTokens;
224     }
225 
226     /// @dev Returns id of token owned by given address (encoded as an integer).
227     /// @param _owner Address of token owner.
228     function balanceOf(address _owner) constant returns (uint256 balance) {
229         if (_owner == 0x0) {
230             return 0;
231         } else {
232             return balances[_owner];
233         }
234     }
235 
236     /// @dev Returns the token id that may transfer from _owner account by _spender..
237     /// @param _owner Address of token owner.
238     /// @param _spender Address of token spender.
239     function allowance(address _owner,
240                        address _spender) constant returns (uint256 remaining) {
241         return approvals[_owner][_spender];
242     }
243 
244     /// @dev Transfers sender token to given address. Returns success.
245     /// @param _to Address of new token owner.
246     /// @param _value Bytes32 id of the token to transfer.
247     function transfer(address _to,
248                       uint256 _value) public returns (bool success) {
249         if (_value != 1) {
250             // 1 is the only value that makes any sense here.
251             return false;
252         } else if (_to == 0x0) {
253             // cannot transfer to the null address.
254             return false;
255         } else if (balances[msg.sender] == 0x0) {
256             // msg.sender is not a token owner
257             return false;
258         } else if (balances[_to] != 0x0) {
259             // cannot transfer to an address that already owns a token.
260             return false;
261         }
262 
263         balances[msg.sender] = 0;
264         balances[_to] = 1;
265         Transfer(msg.sender, _to, 1);
266         TokenEventLib._Transfer(msg.sender, _to);
267 
268         return true;
269     }
270 
271     /// @dev Transfers sender token to given address. Returns success.
272     /// @param _to Address of new token owner.
273     function transfer(address _to) public returns (bool success) {
274         return transfer(_to, 1);
275     }
276 
277     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
278     /// @param _from Address of token owner.
279     /// @param _to Address of new token owner.
280     /// @param _value Bytes32 id of the token to transfer.
281     function transferFrom(address _from,
282                           address _to,
283                           uint256 _value) public returns (bool success) {
284         if (_value != 1) {
285             // Cannot transfer anything other than 1 token.
286             return false;
287         } else if (_to == 0x0) {
288             // Cannot transfer to the null address
289             return false;
290         } else if (balances[_from] == 0x0) {
291             // Cannot transfer if _from is not a token owner
292             return false;
293         } else if (balances[_to] != 0x0) {
294             // Cannot transfer to an existing token owner
295             return false;
296         } else if (approvals[_from][msg.sender] == 0) {
297             // The approved token doesn't match the token being transferred.
298             return false;
299         }
300 
301         // null out the approval
302         approvals[_from][msg.sender] = 0x0;
303 
304         // remove the token from the sender.
305         balances[_from] = 0;
306 
307         // assign the token to the new owner
308         balances[_to] = 1;
309 
310         // log the transfer
311         Transfer(_from, _to, 1);
312         TokenEventLib._Transfer(_from, _to);
313 
314         return true;
315     }
316 
317     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
318     /// @param _from Address of token owner.
319     /// @param _to Address of new token owner.
320     function transferFrom(address _from, address _to) public returns (bool success) {
321         return transferFrom(_from, _to, 1);
322     }
323 
324     /// @dev Sets approval spender to transfer ownership of token. Returns success.
325     /// @param _spender Address of spender..
326     /// @param _value Bytes32 id of token that can be spend.
327     function approve(address _spender,
328                      uint256 _value) public returns (bool success) {
329         if (_value != 1) {
330             // cannot approve any value other than 1
331             return false;
332         } else if (_spender == 0x0) {
333             // cannot approve the null address as a spender.
334             return false;
335         } else if (balances[msg.sender] == 0x0) {
336             // cannot approve if not a token owner.
337             return false;
338         }
339 
340         approvals[msg.sender][_spender] = 1;
341 
342         Approval(msg.sender, _spender, 1);
343         TokenEventLib._Approval(msg.sender, _spender);
344 
345         return true;
346     }
347 
348     /// @dev Sets approval spender to transfer ownership of token. Returns success.
349     /// @param _spender Address of spender..
350     function approve(address _spender) public returns (bool success) {
351         return approve(_spender, 1);
352     }
353 
354     /*
355      *  Extra non ERC20 functions
356      */
357     /// @dev Returns whether the address owns a token.
358     /// @param _owner Address to check.
359     function isTokenOwner(address _owner) constant returns (bool) {
360         return balances[_owner] != 0;
361     }
362 }