1 pragma solidity ^0.4.18;
2 
3 /**
4  * IOwnership
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
45      * Access is restricted to the current owner
46      */
47     modifier only_owner() {
48         require(msg.sender == owner);
49         _;
50     }
51 
52 
53     /**
54      * The publisher is the inital owner
55      */
56     function Ownership() public {
57         owner = msg.sender;
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
83  * ITransferableOwnership
84  *
85  * Enhances ownership by allowing the current owner to 
86  * transfer ownership to a new owner
87  *
88  * #created 01/10/2017
89  * #author Frank Bonnet
90  */
91 interface ITransferableOwnership {
92     
93 
94     /**
95      * Transfer ownership to `_newOwner`
96      *
97      * @param _newOwner The address of the account that will become the new owner 
98      */
99     function transferOwnership(address _newOwner) public;
100 }
101 
102 
103 
104 /**
105  * TransferableOwnership
106  *
107  * Enhances ownership by allowing the current owner to 
108  * transfer ownership to a new owner
109  *
110  * #created 01/10/2017
111  * #author Frank Bonnet
112  */
113 contract TransferableOwnership is ITransferableOwnership, Ownership {
114 
115 
116     /**
117      * Transfer ownership to `_newOwner`
118      *
119      * @param _newOwner The address of the account that will become the new owner 
120      */
121     function transferOwnership(address _newOwner) public only_owner {
122         owner = _newOwner;
123     }
124 }
125 
126 
127 /**
128  * IAuthenticator 
129  *
130  * Authenticator interface
131  *
132  * #created 15/10/2017
133  * #author Frank Bonnet
134  */
135 interface IAuthenticator {
136     
137 
138     /**
139      * Authenticate 
140      *
141      * Returns whether `_account` is authenticated or not
142      *
143      * @param _account The account to authenticate
144      * @return whether `_account` is successfully authenticated
145      */
146     function authenticate(address _account) public view returns (bool);
147 }
148 
149 
150 /**
151  * IWhitelist 
152  *
153  * Whitelist authentication interface
154  *
155  * #created 04/10/2017
156  * #author Frank Bonnet
157  */
158 interface IWhitelist {
159     
160 
161     /**
162      * Returns whether an entry exists for `_account`
163      *
164      * @param _account The account to check
165      * @return whether `_account` is has an entry in the whitelist
166      */
167     function hasEntry(address _account) public view returns (bool);
168 
169 
170     /**
171      * Add `_account` to the whitelist
172      *
173      * If an account is currently disabled, the account is reenabled, otherwise 
174      * a new entry is created
175      *
176      * @param _account The account to add
177      */
178     function add(address _account) public;
179 
180 
181     /**
182      * Remove `_account` from the whitelist
183      *
184      * Will not actually remove the entry but disable it by updating
185      * the accepted record
186      *
187      * @param _account The account to remove
188      */
189     function remove(address _account) public;
190 }
191 
192 
193 /**
194  * Whitelist authentication list
195  *
196  * #created 04/10/2017
197  * #author Frank Bonnet
198  */
199 contract Whitelist is IWhitelist, IAuthenticator, TransferableOwnership {
200 
201     struct Entry {
202         uint datetime;
203         bool accepted;
204         uint index;
205     }
206 
207     mapping(address => Entry) internal list;
208     address[] internal listIndex;
209 
210 
211     /**
212      * Returns whether an entry exists for `_account`
213      *
214      * @param _account The account to check
215      * @return whether `_account` is has an entry in the whitelist
216      */
217     function hasEntry(address _account) public view returns (bool) {
218         return listIndex.length > 0 && _account == listIndex[list[_account].index];
219     }
220 
221 
222     /**
223      * Add `_account` to the whitelist
224      *
225      * If an account is currently disabled, the account is reenabled, otherwise 
226      * a new entry is created
227      *
228      * @param _account The account to add
229      */
230     function add(address _account) public only_owner {
231         if (!hasEntry(_account)) {
232             list[_account] = Entry(
233                 now, true, listIndex.push(_account) - 1);
234         } else {
235             Entry storage entry = list[_account];
236             if (!entry.accepted) {
237                 entry.accepted = true;
238                 entry.datetime = now;
239             }
240         }
241     }
242 
243 
244     /**
245      * Remove `_account` from the whitelist
246      *
247      * Will not acctually remove the entry but disable it by updating
248      * the accepted record
249      *
250      * @param _account The account to remove
251      */
252     function remove(address _account) public only_owner {
253         if (hasEntry(_account)) {
254             Entry storage entry = list[_account];
255             entry.accepted = false;
256             entry.datetime = now;
257         }
258     }
259 
260 
261     /**
262      * Authenticate 
263      *
264      * Returns whether `_account` is on the whitelist
265      *
266      * @param _account The account to authenticate
267      * @return whether `_account` is successfully authenticated
268      */
269     function authenticate(address _account) public view returns (bool) {
270         return list[_account].accepted;
271     }
272 }