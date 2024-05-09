1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title Ownership interface
5  *
6  * Perminent ownership
7  *
8  * #created 01/10/2017
9  * #author Frank Bonnet
10  */
11 contract IOwnership {
12 
13     /**
14      * Returns true if `_account` is the current owner
15      *
16      * @param _account The address to test against
17      */
18     function isOwner(address _account) constant returns (bool);
19 
20 
21     /**
22      * Gets the current owner
23      *
24      * @return address The current owner
25      */
26     function getOwner() constant returns (address);
27 }
28 
29 
30 /**
31  * @title Ownership
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
47     function Ownership() {
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
66     function isOwner(address _account) public constant returns (bool) {
67         return _account == owner;
68     }
69 
70 
71     /**
72      * Gets the current owner
73      *
74      * @return address The current owner
75      */
76     function getOwner() public constant returns (address) {
77         return owner;
78     }
79 }
80 
81 
82 /**
83  * @title Transferable ownership interface
84  *
85  * Enhances ownership by allowing the current owner to 
86  * transfer ownership to a new owner
87  *
88  * #created 01/10/2017
89  * #author Frank Bonnet
90  */
91 contract ITransferableOwnership {
92     
93 
94     /**
95      * Transfer ownership to `_newOwner`
96      *
97      * @param _newOwner The address of the account that will become the new owner 
98      */
99     function transferOwnership(address _newOwner);
100 }
101 
102 
103 /**
104  * @title Transferable ownership
105  *
106  * Enhances ownership by allowing the current owner to 
107  * transfer ownership to a new owner
108  *
109  * #created 01/10/2017
110  * #author Frank Bonnet
111  */
112 contract TransferableOwnership is ITransferableOwnership, Ownership {
113 
114 
115     /**
116      * Transfer ownership to `_newOwner`
117      *
118      * @param _newOwner The address of the account that will become the new owner 
119      */
120     function transferOwnership(address _newOwner) public only_owner {
121         owner = _newOwner;
122     }
123 }
124 
125 
126 /**
127  * @title IAuthenticator 
128  *
129  * Authenticator interface
130  *
131  * #created 15/10/2017
132  * #author Frank Bonnet
133  */
134 contract IAuthenticator {
135     
136 
137     /**
138      * Authenticate 
139      *
140      * Returns whether `_account` is authenticated or not
141      *
142      * @param _account The account to authenticate
143      * @return whether `_account` is successfully authenticated
144      */
145     function authenticate(address _account) constant returns (bool);
146 }
147 
148 
149 /**
150  * @title IWhitelist 
151  *
152  * Whitelist authentication interface
153  *
154  * #created 04/10/2017
155  * #author Frank Bonnet
156  */
157 contract IWhitelist is IAuthenticator {
158     
159 
160     /**
161      * Returns whether an entry exists for `_account`
162      *
163      * @param _account The account to check
164      * @return whether `_account` is has an entry in the whitelist
165      */
166     function hasEntry(address _account) constant returns (bool);
167 
168 
169     /**
170      * Add `_account` to the whitelist
171      *
172      * If an account is currently disabled, the account is reenabled, otherwise 
173      * a new entry is created
174      *
175      * @param _account The account to add
176      */
177     function add(address _account);
178 
179 
180     /**
181      * Remove `_account` from the whitelist
182      *
183      * Will not actually remove the entry but disable it by updating
184      * the accepted record
185      *
186      * @param _account The account to remove
187      */
188     function remove(address _account);
189 }
190 
191 
192 /**
193  * @title Whitelist 
194  *
195  * Whitelist authentication list
196  *
197  * #created 04/10/2017
198  * #author Frank Bonnet
199  */
200 contract Whitelist is IWhitelist, TransferableOwnership {
201 
202     struct Entry {
203         uint datetime;
204         bool accepted;
205         uint index;
206     }
207 
208     mapping (address => Entry) internal list;
209     address[] internal listIndex;
210 
211 
212     /**
213      * Returns whether an entry exists for `_account`
214      *
215      * @param _account The account to check
216      * @return whether `_account` is has an entry in the whitelist
217      */
218     function hasEntry(address _account) public constant returns (bool) {
219         return listIndex.length > 0 && _account == listIndex[list[_account].index];
220     }
221 
222 
223     /**
224      * Add `_account` to the whitelist
225      *
226      * If an account is currently disabled, the account is reenabled, otherwise 
227      * a new entry is created
228      *
229      * @param _account The account to add
230      */
231     function add(address _account) public only_owner {
232         if (!hasEntry(_account)) {
233             list[_account] = Entry(
234                 now, true, listIndex.push(_account) - 1);
235         } else {
236             Entry storage entry = list[_account];
237             if (!entry.accepted) {
238                 entry.accepted = true;
239                 entry.datetime = now;
240             }
241         }
242     }
243 
244 
245     /**
246      * Remove `_account` from the whitelist
247      *
248      * Will not acctually remove the entry but disable it by updating
249      * the accepted record
250      *
251      * @param _account The account to remove
252      */
253     function remove(address _account) public only_owner {
254         if (hasEntry(_account)) {
255             Entry storage entry = list[_account];
256             entry.accepted = false;
257             entry.datetime = now;
258         }
259     }
260 
261 
262     /**
263      * Authenticate 
264      *
265      * Returns whether `_account` is on the whitelist
266      *
267      * @param _account The account to authenticate
268      * @return whether `_account` is successfully authenticated
269      */
270     function authenticate(address _account) public constant returns (bool) {
271         return list[_account].accepted;
272     }
273 }