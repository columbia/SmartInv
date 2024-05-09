1 pragma solidity 0.4.19;
2 
3 // implement safemath as a library
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
7     uint256 c = a * b;
8     require(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     require(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     require(c >= a);
25     return c;
26   }
27   
28 }
29 
30 contract ESZCoin {
31 
32     using SafeMath for uint256;
33 
34     address     public      owner;
35     string      public      name;
36     string      public      symbol;
37     uint256     public      totalSupply;
38     uint8       public      decimals;
39     bool        public      globalTransferLock;
40 
41     mapping (address => bool)                           public      accountLock;
42     mapping (address => uint256)                        public      balances;
43     mapping (address => mapping(address => uint256))    public      allowed;
44 
45     event Transfer(address indexed _sender, address indexed _recipient, uint256 _amount);
46     event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
47     event GlobalTransfersLocked(bool indexed _transfersFrozenGlobally);
48     event GlobalTransfersUnlocked(bool indexed _transfersThawedGlobally);
49     event AccountTransfersFrozen(address indexed _eszHolder, bool indexed _accountTransfersFrozen);
50     event AccountTransfersThawed(address indexed _eszHolder, bool indexed _accountTransfersThawed);
51 
52     /**
53         @dev Checks to ensure that msg.sender is the owner
54     */
55     modifier onlyOwner() {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     /**
61         @dev Checks to ensure that global transfers are not locked
62     */
63     modifier transfersUnlocked() {
64         require(!globalTransferLock);
65         _;
66     }
67 
68     /**CONSTRUCTOR*/
69     function ESZCoin() {
70         owner = msg.sender;
71         totalSupply = 10000000000000000000000000;
72         balances[msg.sender] = totalSupply;
73         name = "ESZCoin";
74         symbol = "ESZ";
75         decimals = 18;
76         globalTransferLock = false;
77     } 
78 
79     /**
80         @dev Freezes transfers globally
81     */
82     function freezeGlobalTansfers()
83         public
84         onlyOwner
85         returns (bool)
86     {
87         globalTransferLock = true;
88         GlobalTransfersLocked(true);
89         return true;
90     }
91 
92     /**
93         @dev Thaws transfers globally
94     */
95     function thawGlobalTransfers()
96         public
97         onlyOwner
98         returns (bool)
99     {
100         globalTransferLock = false;
101         GlobalTransfersUnlocked(true);
102     }
103 
104     /**
105         @dev Freezes a particular account, preventing them from making transfers
106     */
107     function freezeAccountTransfers(
108         address _eszHolder
109     )
110         public
111         onlyOwner
112         returns (bool)
113     {
114         accountLock[_eszHolder] = true;
115         AccountTransfersFrozen(_eszHolder, true);
116         return true;
117     }
118 
119     /**
120         @dev Thaws a particular account, allowing them to make transfers again
121     */
122     function thawAccountTransfers(
123         address _eszHolder
124     )
125         public
126         onlyOwner
127         returns (bool)
128     {
129         accountLock[_eszHolder] = false;
130         AccountTransfersThawed(_eszHolder, true);
131         return true;
132     }
133 
134     /**
135         @dev Used to transfers tokens
136     */
137     function transfer(
138         address _recipient,
139         uint256 _amount
140     )
141         public
142         returns (bool)
143     {
144         require(accountLock[msg.sender] == false);
145         require(transferCheck(msg.sender, _recipient, _amount));
146         balances[msg.sender] = balances[msg.sender].sub(_amount);
147         balances[_recipient] = balances[_recipient].add(_amount);
148         Transfer(msg.sender, _recipient, _amount);
149         return true;
150     }
151 
152     /**
153         @dev Used to transfers tokens to someone on behalf of the owner account. Must be approved
154     */
155     function transferFrom(
156         address _owner,
157         address _recipient,
158         uint256 _amount
159     )
160         public
161         returns (bool)
162     {
163         require(accountLock[_owner] == false);
164         require(allowed[_owner][msg.sender] >= _amount);
165         require(transferCheck(_owner, _recipient, _amount));
166         allowed[_owner][msg.sender] = allowed[_owner][msg.sender].sub(_amount);
167         balances[_owner] = balances[_owner].sub(_amount);
168         balances[_recipient] = balances[_recipient].add(_amount);
169         Transfer(_owner, _recipient, _amount);
170         return true;
171     }
172 
173     /**
174         @dev Used to approve another account to spend on your behalf
175     */
176     function approve(
177         address _spender,
178         uint256 _amount
179     )
180         public
181         returns (bool)
182     {
183         allowed[msg.sender][_spender] = _amount;
184         Approval(msg.sender, _spender, _amount);
185         return true;
186     }
187 
188     /** INTERNALS */
189 
190     /**
191         @dev Does a sanity check of the parameters in a transfer, makes sure transfers are allowed
192     */
193     function transferCheck(
194         address _sender,
195         address _recipient,
196         uint256 _amount
197     )
198         internal
199         view
200         transfersUnlocked
201         returns (bool)
202     {
203         require(_amount > 0);
204         require(balances[_sender] >= _amount);
205         require(balances[_sender].sub(_amount) >= 0);
206         require(balances[_recipient].add(_amount) > balances[_recipient]);
207         return true;
208     }
209 
210     /** GETTERS */
211     
212     /**
213         @dev Retrieves total supply
214     */
215     function totalSupply()
216         public
217         view
218         returns (uint256)
219     {
220         return totalSupply;
221     }
222 
223     /**
224         @dev Retrieves the balance of an ESZ holder
225     */
226     function balanceOf(
227         address _eszHolder
228     )
229         public
230         view
231         returns (uint256)
232     {
233         return balances[_eszHolder];
234     }
235 
236     /**
237         @dev Retrieves the balance of spender for owner
238     */
239     function allowance(
240         address _owner,
241         address _spender
242     )
243         public
244         view
245         returns (uint256)
246     {
247         return allowed[_owner][_spender];
248     }
249 
250 }