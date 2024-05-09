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
108     uint256 public startTime = 1505998800;
109     uint256 public stopTime = 1508590800;
110 
111     mapping (address => uint256) public deposits;
112     mapping (address => bool) public authorised; // just to annoy the heck out of americans
113 
114     /**
115      * @dev throws if person sending is not contract owner or cs role
116      */
117     modifier onlyCSorOwner() {
118         require((msg.sender == owner) || (msg.sender==cs));
119         _;
120     }
121 
122     /**
123      * @dev throws if person sending is not authorised or sends nothing
124      */
125     modifier onlyAuthorised() {
126         require (authorised[msg.sender]);
127         require (msg.value > 0);
128         require (now >= startTime);
129         require (now <= stopTime);
130         require (!saleFinished);
131         require(!paused);
132         _;
133     }
134 
135     /**
136      * @dev set start and stop times
137      */
138     function setPeriod(uint256 start, uint256 stop) onlyOwner {
139         startTime = start;
140         stopTime = stop;
141     }
142     
143     /**
144      * @dev authorise an account to participate
145      */
146     function authoriseAccount(address whom) onlyCSorOwner {
147         authorised[whom] = true;
148     }
149 
150     /**
151      * @dev authorise a lot of accounts in one go
152      */
153     function authoriseManyAccounts(address[] many) onlyCSorOwner {
154         for (uint256 i = 0; i < many.length; i++) {
155             authorised[many[i]] = true;
156         }
157     }
158 
159     /**
160      * @dev ban an account from participation (default)
161      */
162     function blockAccount(address whom) onlyCSorOwner {
163         authorised[whom] = false;
164     }
165 
166     /**
167      * @dev set a new CS representative
168      */
169     function setCS(address newCS) onlyOwner {
170         cs = newCS;
171     }
172 
173     /**
174      * @dev call an end (e.g. because cap reached)
175      */
176     function stopSale() onlyOwner {
177         saleFinished = true;
178     }
179     
180     function SimpleSale() {
181         
182     }
183 
184     /**
185      * @dev fallback function received ether, sends it to the multisig, notes indivdual and group contributions
186      */
187     function () payable onlyAuthorised {
188         multisig.transfer(msg.value);
189         deposits[msg.sender] += msg.value;
190         totalCollected += msg.value;
191     }
192 
193     /**
194      * @dev in case somebody sends ERC2o tokens...
195      */
196     function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner {
197         token.transfer(owner, amount);
198     }
199 
200 }