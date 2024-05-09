1 pragma solidity ^0.4.19;
2 
3 /**
4  * Ownership interface
5  *
6  * Perminent ownership
7  *
8  * #created 01/10/2017
9  * #author Frank Bonnet
10  */
11 interface IOwnership {
12 
13     /**
14      * Returns true if `_account` is the current owner
15      *
16      * @param _account The address to test against
17      */
18     function isOwner(address _account) public view returns (bool);
19 
20 
21     /**
22      * Gets the current owner
23      *
24      * @return address The current owner
25      */
26     function getOwner() public view returns (address);
27 }
28 
29 
30 /**
31  * Ownership
32  *
33  * Perminent ownership
34  *
35  * #created 01/10/2017
36  * #author Frank Bonnet
37  */
38 contract Ownership is IOwnership {
39 
40     // Owner
41     address internal owner;
42 
43 
44     /**
45      * The publisher is the inital owner
46      */
47     function Ownership() public {
48         owner = msg.sender;
49     }
50 
51 
52     /**
53      * Access is restricted to the current owner
54      */
55     modifier only_owner() {
56         require(msg.sender == owner);
57         _;
58     }
59 
60 
61     /**
62      * Returns true if `_account` is the current owner
63      *
64      * @param _account The address to test against
65      */
66     function isOwner(address _account) public view returns (bool) {
67         return _account == owner;
68     }
69 
70 
71     /**
72      * Gets the current owner
73      *
74      * @return address The current owner
75      */
76     function getOwner() public view returns (address) {
77         return owner;
78     }
79 }
80 
81 
82 /**
83  * ransferable ownership interface
84  *
85  * Enhances ownership by allowing the current owner to 
86  * transfer ownership to a new owner
87  *
88  * #created 01/10/2017
89  * #author Frank Bonnet
90  */
91 interface ITransferableOwnership {
92     
93     /**
94      * Transfer ownership to `_newOwner`
95      *
96      * @param _newOwner The address of the account that will become the new owner 
97      */
98     function transferOwnership(address _newOwner) public;
99 }
100 
101 
102 /**
103  * Transferable ownership
104  *
105  * Enhances ownership by allowing the current owner to 
106  * transfer ownership to a new owner
107  *
108  * #created 01/10/2017
109  * #author Frank Bonnet
110  */
111 contract TransferableOwnership is ITransferableOwnership, Ownership {
112 
113     /**
114      * Transfer ownership to `_newOwner`
115      *
116      * @param _newOwner The address of the account that will become the new owner 
117      */
118     function transferOwnership(address _newOwner) public only_owner {
119         owner = _newOwner;
120     }
121 }
122 
123 
124 /**
125  * ERC20 compatible token interface
126  *
127  * - Implements ERC 20 Token standard
128  * - Implements short address attack fix
129  *
130  * #created 29/09/2017
131  * #author Frank Bonnet
132  */
133 interface IToken { 
134 
135     /** 
136      * Get the total supply of tokens
137      * 
138      * @return The total supply
139      */
140     function totalSupply() public view returns (uint);
141 
142 
143     /** 
144      * Get balance of `_owner` 
145      * 
146      * @param _owner The address from which the balance will be retrieved
147      * @return The balance
148      */
149     function balanceOf(address _owner) public view returns (uint);
150 
151 
152     /** 
153      * Send `_value` token to `_to` from `msg.sender`
154      * 
155      * @param _to The address of the recipient
156      * @param _value The amount of token to be transferred
157      * @return Whether the transfer was successful or not
158      */
159     function transfer(address _to, uint _value) public returns (bool);
160 
161 
162     /** 
163      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
164      * 
165      * @param _from The address of the sender
166      * @param _to The address of the recipient
167      * @param _value The amount of token to be transferred
168      * @return Whether the transfer was successful or not
169      */
170     function transferFrom(address _from, address _to, uint _value) public returns (bool);
171 
172 
173     /** 
174      * `msg.sender` approves `_spender` to spend `_value` tokens
175      * 
176      * @param _spender The address of the account able to transfer the tokens
177      * @param _value The amount of tokens to be approved for transfer
178      * @return Whether the approval was successful or not
179      */
180     function approve(address _spender, uint _value) public returns (bool);
181 
182 
183     /** 
184      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
185      * 
186      * @param _owner The address of the account owning tokens
187      * @param _spender The address of the account able to transfer the tokens
188      * @return Amount of remaining tokens allowed to spent
189      */
190     function allowance(address _owner, address _spender) public view returns (uint);
191 }
192 
193 
194 /**
195  * @title Token retrieve interface
196  *
197  * Allows tokens to be retrieved from a contract
198  *
199  * #created 29/09/2017
200  * #author Frank Bonnet
201  */
202 contract ITokenRetriever {
203 
204     /**
205      * Extracts tokens from the contract
206      *
207      * @param _tokenContract The address of ERC20 compatible token
208      */
209     function retrieveTokens(address _tokenContract) public;
210 }
211 
212 
213 /**
214  * @title Token retrieve
215  *
216  * Allows tokens to be retrieved from a contract
217  *
218  * #created 18/10/2017
219  * #author Frank Bonnet
220  */
221 contract TokenRetriever is ITokenRetriever {
222 
223     /**
224      * Extracts tokens from the contract
225      *
226      * @param _tokenContract The address of ERC20 compatible token
227      */
228     function retrieveTokens(address _tokenContract) public {
229         IToken tokenInstance = IToken(_tokenContract);
230         uint tokenBalance = tokenInstance.balanceOf(this);
231         if (tokenBalance > 0) {
232             tokenInstance.transfer(msg.sender, tokenBalance);
233         }
234     }
235 }
236 
237 
238 /**
239  * IAirdropper
240  *
241  * #created 29/03/2018
242  * #author Frank Bonnet
243  */
244 interface IAirdropper {
245 
246     /**
247      * Airdrop tokens
248      *
249      * Transfers the appropriate `_token` value for each recipient 
250      * found in `_recipients` and `_values` 
251      *
252      * @param _token Token contract to send from
253      * @param _recipients Receivers of the tokens
254      * @param _values Amounts of tokens that are transferred
255      */
256     function drop(IToken _token, address[] _recipients, uint[] _values) public;
257 }
258 
259 
260 /**
261  * Airdropper 
262  *
263  * Transfer tokens to multiple accounts at once
264  *
265  * #created 29/03/2018
266  * #author Frank Bonnet
267  */
268 contract Airdropper is TransferableOwnership {
269 
270     /**
271      * Airdrop tokens
272      *
273      * Transfers the appropriate `_token` value for each recipient 
274      * found in `_recipients` and `_values` 
275      *
276      * @param _token Token contract to send from
277      * @param _recipients Receivers of the tokens
278      * @param _values Amounts of tokens that are transferred
279      */
280     function drop(IToken _token, address[] _recipients, uint[] _values) public only_owner {
281         for (uint i = 0; i < _values.length; i++) {
282             _token.transfer(_recipients[i], _values[i]);
283         }
284     }
285 }
286 
287 
288 /**
289  * DCorp Airdropper 
290  *
291  * Transfer tokens to multiple accounts at once
292  *
293  * #created 27/03/2018
294  * #author Frank Bonnet
295  */
296 contract DCorpAirdropper is Airdropper, TokenRetriever {
297 
298     /**
299      * Failsafe mechanism
300      * 
301      * Allows the owner to retrieve tokens (other than DRPS and DRPU tokens) from the contract that 
302      * might have been send there by accident
303      *
304      * @param _tokenContract The address of ERC20 compatible token
305      */
306     function retrieveTokens(address _tokenContract) public only_owner {
307         super.retrieveTokens(_tokenContract);
308     }
309 
310 
311     // Do not accept ether
312     function () public payable {
313         revert();
314     }
315 }