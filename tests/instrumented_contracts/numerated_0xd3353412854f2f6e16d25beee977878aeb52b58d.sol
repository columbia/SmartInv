1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title ERC20 interface
5  * @dev cutdown simply to allow removal of tokens sent to contract
6  */
7 contract ERC20 {
8   function transfer(address to, uint256 value) returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 
12 
13 /**
14  * @title Ownable
15  * @dev The Ownable contract has an owner address, and provides basic authorization control
16  * functions, this simplifies the implementation of "user permissions".
17  */
18 contract Ownable {
19   address public owner;
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   function Ownable() {
27     owner = msg.sender;
28   }
29 
30 
31   /**
32    * @dev Throws if called by any account other than the owner.
33    */
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38 
39 
40   /**
41    * @dev Allows the current owner to transfer control of the contract to a newOwner.
42    * @param newOwner The address to transfer ownership to.
43    */
44   function transferOwnership(address newOwner) onlyOwner {
45     if (newOwner != address(0)) {
46       owner = newOwner;
47     }
48   }
49 
50 }
51 
52 
53 /**
54  * @title Pausable
55  * @dev Base contract which allows children to implement an emergency stop mechanism.
56  */
57 contract Pausable is Ownable {
58   event Pause();
59   event Unpause();
60 
61   bool public paused = false;
62 
63 
64   /**
65    * @dev modifier to allow actions only when the contract IS paused
66    */
67   modifier whenNotPaused() {
68     require(!paused);
69     _;
70   }
71 
72   /**
73    * @dev modifier to allow actions only when the contract IS NOT paused
74    */
75   modifier whenPaused {
76     require(paused);
77     _;
78   }
79 
80   /**
81    * @dev called by the owner to pause, triggers stopped state
82    */
83   function pause() onlyOwner whenNotPaused returns (bool) {
84     paused = true;
85     Pause();
86     return true;
87   }
88 
89   /**
90    * @dev called by the owner to unpause, returns to normal state
91    */
92   function unpause() onlyOwner whenPaused returns (bool) {
93     paused = false;
94     Unpause();
95     return true;
96   }
97 }
98 
99 // 200 000 000 ether = A56FA5B99019A5C8000000 = 88 bits. We have 256.
100 // we do NOT need safemath.
101 
102 contract SimpleSale is Ownable,Pausable {
103 
104     address public multisig = 0xc862705dDA23A2BAB54a6444B08a397CD4DfCD1c;
105     address public cs;
106     uint256 public totalCollected;
107     bool    public saleFinished;
108     bool    public freeForAll = true;
109     uint256 public startTime = 1505998800;
110     uint256 public stopTime = 1508590800;
111 
112     mapping (address => uint256) public deposits;
113     mapping (address => bool) public authorised; // just to annoy the heck out of americans
114 
115     /**
116      * @dev throws if person sending is not contract owner or cs role
117      */
118     modifier onlyCSorOwner() {
119         require((msg.sender == owner) || (msg.sender==cs));
120         _;
121     }
122 
123     /**
124      * @dev throws if person sending is not authorised or sends nothing
125      */
126     modifier onlyAuthorised() {
127         require (authorised[msg.sender] || freeForAll);
128         require (msg.value > 0);
129         require (now >= startTime);
130         require (now <= stopTime);
131         require (!saleFinished);
132         require(!paused);
133         _;
134     }
135 
136     /**
137      * @dev set start and stop times
138      */
139     function setPeriod(uint256 start, uint256 stop) onlyOwner {
140         startTime = start;
141         stopTime = stop;
142     }
143     
144     /**
145      * @dev authorise an account to participate
146      */
147     function authoriseAccount(address whom) onlyCSorOwner {
148         authorised[whom] = true;
149     }
150 
151     /**
152      * @dev authorise a lot of accounts in one go
153      */
154     function authoriseManyAccounts(address[] many) onlyCSorOwner {
155         for (uint256 i = 0; i < many.length; i++) {
156             authorised[many[i]] = true;
157         }
158     }
159 
160     /**
161      * @dev ban an account from participation (default)
162      */
163     function blockAccount(address whom) onlyCSorOwner {
164         authorised[whom] = false;
165     }
166 
167     /**
168      * @dev set a new CS representative
169      */
170     function setCS(address newCS) onlyOwner {
171         cs = newCS;
172     }
173     
174     function requireAuthorisation(bool state) {
175         freeForAll = !state;
176     }
177 
178     /**
179      * @dev call an end (e.g. because cap reached)
180      */
181     function stopSale() onlyOwner {
182         saleFinished = true;
183     }
184     
185 
186     /**
187      * @dev fallback function received ether, sends it to the multisig, notes indivdual and group contributions
188      */
189     function () payable onlyAuthorised {
190         multisig.transfer(msg.value);
191         deposits[msg.sender] += msg.value;
192         totalCollected += msg.value;
193     }
194 
195     /**
196      * @dev in case somebody sends ERC2o tokens...
197      */
198     function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner {
199         token.transfer(owner, amount);
200     }
201 
202 }