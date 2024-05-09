1 pragma solidity ^0.4.15;
2 
3 contract Owned {
4 
5     // The address of the account that is the current owner 
6     address internal owner;
7 
8 
9     /**
10      * The publisher is the inital owner
11      */
12     function Owned() {
13         owner = msg.sender;
14     }
15 
16 
17     /**
18      * Access is restricted to the current owner
19      */
20     modifier only_owner() {
21         require(msg.sender == owner);
22 
23         _;
24     }
25 }
26 
27 
28 contract IOwnership {
29 
30     /**
31      * Returns true if `_account` is the current owner
32      *
33      * @param _account The address to test against
34      */
35     function isOwner(address _account) constant returns (bool);
36 
37 
38     /**
39      * Gets the current owner
40      *
41      * @return address The current owner
42      */
43     function getOwner() constant returns (address);
44 }
45 
46 
47 contract Ownership is IOwnership, Owned {
48 
49 
50     /**
51      * Returns true if `_account` is the current owner
52      *
53      * @param _account The address to test against
54      */
55     function isOwner(address _account) public constant returns (bool) {
56         return _account == owner;
57     }
58 
59 
60     /**
61      * Gets the current owner
62      *
63      * @return address The current owner
64      */
65     function getOwner() public constant returns (address) {
66         return owner;
67     }
68 }
69 
70 
71 contract ITransferableOwnership {
72 
73     /**
74      * Transfer ownership to `_newOwner`
75      *
76      * @param _newOwner The address of the account that will become the new owner 
77      */
78     function transferOwnership(address _newOwner);
79 }
80 
81 
82 contract TransferableOwnership is ITransferableOwnership, Ownership {
83 
84 
85     /**
86      * Transfer ownership to `_newOwner`
87      *
88      * @param _newOwner The address of the account that will become the new owner 
89      */
90     function transferOwnership(address _newOwner) public only_owner {
91         owner = _newOwner;
92     }
93 }
94 
95 
96 /**
97  * @title IWhitelist 
98  *
99  * Whitelist authentication interface
100  *
101  * #created 04/10/2017
102  * #author Frank Bonnet
103  */
104 contract IWhitelist {
105     
106 
107     /**
108      * Authenticate 
109      *
110      * Returns whether `_account` is on the whitelist
111      *
112      * @param _account The account to authenticate
113      * @return whether `_account` is successfully authenticated
114      */
115     function authenticate(address _account) constant returns (bool);
116 }
117 
118 
119 /**
120  * @title Whitelist 
121  *
122  * Whitelist authentication list
123  *
124  * #created 04/10/2017
125  * #author Frank Bonnet
126  */
127 contract Whitelist is IWhitelist, TransferableOwnership {
128 
129     struct Entry {
130         uint datetime;
131         bool accepted;
132         uint index;
133     }
134 
135     mapping (address => Entry) internal list;
136     address[] internal listIndex;
137 
138 
139     /**
140      * Returns whether an entry exists for `_account`
141      *
142      * @param _account The account to check
143      * @return whether `_account` is has an entry in the whitelist
144      */
145     function hasEntry(address _account) public constant returns (bool) {
146         return listIndex.length > 0 && _account == listIndex[list[_account].index];
147     }
148 
149 
150     /**
151      * Add `_account` to the whitelist
152      *
153      * If an account is currently disabled, the account is reenabled. Otherwise 
154      * a new entry is created
155      *
156      * @param _account The account to add
157      */
158     function add(address _account) public only_owner {
159         if (!hasEntry(_account)) {
160             list[_account] = Entry(
161                 now, true, listIndex.push(_account) - 1);
162         } else {
163             Entry storage entry = list[_account];
164             if (!entry.accepted) {
165                 entry.accepted = true;
166                 entry.datetime = now;
167             }
168         }
169     }
170 
171 
172     /**
173      * Remove `_account` from the whitelist
174      *
175      * Will not actually remove the entry but disable it by updating
176      * the accepted record
177      *
178      * @param _account The account to remove
179      */
180     function remove(address _account) public only_owner {
181         if (hasEntry(_account)) {
182             Entry storage entry = list[_account];
183             entry.accepted = false;
184             entry.datetime = now;
185         }
186     }
187 
188 
189     /**
190      * Authenticate 
191      *
192      * Returns whether `_account` is on the whitelist
193      *
194      * @param _account The account to authenticate
195      * @return whether `_account` is successfully authenticated
196      */
197     function authenticate(address _account) public constant returns (bool) {
198         return list[_account].accepted;
199     }
200 }