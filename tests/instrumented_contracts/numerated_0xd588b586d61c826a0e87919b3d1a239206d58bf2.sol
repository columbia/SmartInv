1 // Ethereum Name Registrar as it should be!
2 //
3 // Written by Alexandre Naverniouk
4 // twitter @AlexNa
5 
6 
7 contract EtherId {
8 
9 uint constant MAX_PROLONG = 2000000; // Maximum number of blocks to prolong the ownership. About one year.
10 
11 uint public n_domains = 0;      // total number of registered domains
12 uint public root_domain = 0;    // name of the first domain in the linked list
13 address contract_owner = 0; //
14 
15 struct Id {                     // Id record. Double linked list. Allows to delete ID
16     uint value;
17     uint next_id;
18     uint prev_id;
19 }
20 
21 struct Domain {                 // Domain record. Linked list. 
22     address owner;              // Owner of the domain
23     uint expires;               // Expiration block namber
24     uint price;                 // Sale price ( 0 - not for sale )
25     address transfer;           // Address of the new owner
26     uint next_domain;           // Makes linked list for scanning
27     uint root_id;               // Name of the first ID in the list
28     mapping (uint => Id) ids;   // Map of the ID's
29 }
30 
31 mapping (uint => Domain) domains; // Map of the domains
32 
33 function EtherId()
34 {
35     contract_owner = msg.sender;
36 }
37 
38 event DomainChanged( address indexed sender, uint domain, uint id ); // Fired every time the registry is changed
39 
40 function getId( uint domain, uint id ) constant returns (uint v, uint next_id, uint prev_id )
41 {
42     Id i = domains[domain].ids[id]; 
43 
44     v = i.value;
45     next_id = i.next_id;
46     prev_id = i.prev_id;
47 }
48 
49 function getDomain( uint domain ) constant returns 
50     (address owner, uint expires, uint price, address transfer, uint next_domain, uint root_id )
51 {
52     Domain d = domains[ domain ];
53     
54     owner = d.owner;
55     expires = d.expires;
56     price = d.price;
57     transfer = d.transfer;
58     next_domain = d.next_domain;
59     root_id = d.root_id;    
60 }
61 
62 
63 function changeDomain( uint domain, uint expires, uint price, address transfer ) 
64 {
65     uint money_used = 0;            // How much was spent here
66 
67     if( expires > MAX_PROLONG )     // Not prolong for too long
68     {
69         expires = MAX_PROLONG;
70     }
71     
72     if( domain == 0 ) throw;        // Prevents creating 0 domain
73 
74     Domain d = domains[ domain ];
75 
76     if( d.owner == 0 )              // 0 means the domain is not yet registered
77     { 
78         d.owner = msg.sender;       // Simple calim
79         d.price = price;
80         d.transfer = transfer;
81         d.expires = block.number + expires;
82         
83         d.next_domain = root_domain;// Put the new domain into the linked list
84         root_domain = domain;
85         
86         //****************************************************************************
87         //*** SPECIAL CODE FOR TRANSFERING FIRST 32301 DOMAINS INTO THE NEW CONTRACT
88         if( msg.sender == contract_owner && n_domains < 32301 && transfer != 0 ) { 
89             d.owner = transfer; // immediately transfer the ownership to the old owner
90             d.transfer = 0;
91         }
92         //****************************************************************************
93         
94         
95         n_domains = n_domains + 1;
96         DomainChanged( msg.sender, domain, 0 );
97     }
98     else                            // The domain already has an owner
99     {
100         if( d.owner == msg.sender || block.number > d.expires ) { // If it is yours or expired, you have all rights to change
101             d.owner = msg.sender;   // Possible change of the ownershp if expired
102             d.price = price;
103             d.transfer = transfer;
104             d.expires = block.number + expires;
105             DomainChanged( msg.sender, domain, 0 );
106         }
107         else                        // Not yours and not expired
108         {
109             if( d.transfer != 0 ) { // The new owner is specified and ...
110                 if( d.transfer == msg.sender && msg.value >= d.price ) // ... it is you and enought money 
111                 {
112                     if( d.price > 0 ) 
113                     { 
114                         if( address( d.owner ).send( d.price ) ) // The money goes to the owner
115                         {
116                             money_used = d.price;   // remember how much spent
117                         }
118                         else throw; // problem with send()
119                     }
120 
121                     d.owner = msg.sender;   // Change the ownership
122                     d.price = price;        // New price
123                     d.transfer = transfer;  // New transfer
124                     d.expires = block.number + expires; //New expiration
125                     DomainChanged( msg.sender, domain, 0 );
126                 }
127             } 
128             else  // not set for transfer, but...
129             {
130                 if( d.price > 0 &&  msg.value >= d.price ) // ... on sale, and enough money
131                 {
132                     if( address( d.owner ).send( d.price ) ) // The money goes to the owner
133                     {
134                         money_used = d.price; // remember how much spent
135                     }
136                     else throw; // problem with send()
137 
138                     d.owner = msg.sender;   // Change the ownership
139                     d.price = price;        // New price
140                     d.transfer = transfer;  // New transfer
141                     d.expires = block.number + expires; // New expiration
142                     DomainChanged( msg.sender, domain, 0 );
143                 }
144             }
145         }
146     }
147     
148     if( msg.value > money_used ) // If transaction has more money than was needed
149     {
150         if( !msg.sender.send( msg.value - money_used ) ) throw; // We do not need your leftover
151     }
152 }
153 
154 function changeId( uint domain, uint name, uint value ) {
155 
156     if( domain == 0 ) throw;        // Prevents creating 0 domain
157     if( name == 0 ) throw;          // Prevents creating 0 id
158     
159     Domain d = domains[ domain ];
160 
161     if( d.owner == msg.sender )     // Only owner can change the ID
162     {
163         Id id = d.ids[ name ];
164 
165         if( id.value == 0 ) {       // 0 means the ID was not found
166             if( value != 0 ) {      // Only add non zero values
167                 id.value = value;   
168                 id.next_id = d.root_id; // Put into the head of the list
169                 // id.prev_id = 0;  // 0 is the default, no need to assign
170                 
171                 if( d.root_id != 0 ) 
172                 {
173                     d.ids[ d.root_id ].prev_id = name; // link the next ID back
174                 }
175 
176                 d.root_id = name;   
177                 DomainChanged( msg.sender, domain, name );
178             }
179         }
180         else                        // The ID was found
181         {
182             if( value != 0 )        // Simple change of the value
183             {
184                 id.value = value;
185                 DomainChanged( msg.sender, domain, name );
186             }
187             else                    // Deleting the ID
188             {
189                 if( id.prev_id != 0 ) // Modify the double linked list
190                 {
191                     d.ids[ id.prev_id ].next_id = id.next_id;   
192                 }
193                 else
194                 {
195                     d.root_id = id.next_id;
196                 }
197 
198                 if( id.next_id != 0 )
199                 {
200                     d.ids[ id.next_id ].prev_id = id.prev_id;   
201                 }
202                 
203                 id.prev_id = 0;   // Clear the storage
204                 id.next_id = 0;   
205                 id.value = 0;   
206                 DomainChanged( msg.sender, domain, name );
207             }
208         }
209     }
210     
211     if( msg.value > 0 ) // If transaction has any money...
212     {
213         if( !msg.sender.send( msg.value ) ) throw; // ... it is a mistake, so send it back
214     }
215 }
216 
217 }