1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'NTS' Nauticus Token Fixed Supply
5 //
6 // Symbol      : NTS
7 // Name        : NauticusToken
8 // Total supply: 2,500,000,000.000000000000000000
9 // Decimals    : 18
10 //
11 // (c) Nauticus 
12 // ----------------------------------------------------------------------------
13 
14 /**
15  * @dev the Permission contract provides basic access control.
16  */
17 contract Permission {
18     address public owner;
19 	function Permission() public {
20         owner = msg.sender;
21     }
22 
23 	modifier onlyOwner() { 
24 		require(msg.sender == owner);
25 		_;
26 	}
27 
28 	function changeOwner(address newOwner) onlyOwner public returns (bool) {
29 		require(newOwner != address(0));
30 		owner = newOwner;
31         return true;
32 	}
33 		
34 }	
35 
36 /**
37  * @dev maintains the safety of mathematical operations.
38  */
39 library Math {
40 
41 	function add(uint a, uint b) internal pure returns (uint c) {
42 		c = a + b;
43 		//require(c >= a);
44 		//require(c >= b);
45 	}
46 
47 	function sub(uint a, uint b) internal pure returns (uint c) {
48 		require(b <= a);
49 		c = a - b;
50 	}
51 
52 	function mul(uint a, uint b) internal pure returns (uint c) {
53 		c = a * b;
54 		require(a == 0 || c / a == b);
55 	}
56 
57 	function div(uint a, uint b) internal pure returns (uint c) {
58 		require(b > 0);
59 		c = a / b;
60 	}
61 }
62 
63 
64 /**
65  * @dev implements ERC20 standard, contains the token logic.
66  */
67 contract NauticusToken is Permission {
68 
69     //Transfer and Approval events
70     event Approval(address indexed owner, address indexed spender, uint val);
71     event Transfer(address indexed sender, address indexed recipient, uint val);
72 
73     //implement Math lib for safe mathematical transactions.
74     using Math for uint;
75     
76     //Inception and Termination of Nauticus ICO
77     //          DD/MM/YYYY
78     // START    18/03/2018 NOON GMT
79     // END      18/05/2018 NOON GMT
80     //          
81     uint public constant inception = 1521331200;
82     uint public constant termination = 1526601600;
83 
84     //token details
85     string public constant name = "NauticusToken";
86 	string public constant symbol = "NTS";
87 	uint8 public constant decimals = 18;
88 
89     //number of tokens that exist, totally.
90     uint public totalSupply;
91     
92     //if the tokens have been minted.
93     bool public minted = false;
94 
95     //hardcap, maximum amount of tokens that can exist
96     uint public constant hardCap = 2500000000000000000000000000;
97     
98     //if if users are able to transfer tokens between each toher.
99     bool public transferActive = false;
100     
101     //mappings for token balances and allowances.
102     mapping(address => uint) balances;
103     mapping(address => mapping(address => uint)) allowed;
104     
105     /*
106         MODIFIERS
107     */
108 	modifier canMint(){
109 	    require(!minted);
110 	    _;
111 	}
112 	
113 	/*modifier ICOActive() { 
114 		require(now > inception * 1 seconds && now < termination * 1 seconds); 
115 		_; 
116 	}*/
117 	
118 	modifier ICOTerminated() {
119 	    require(now > termination * 1 seconds);
120 	    _;
121 	}
122 
123 	modifier transferable() { 
124 		//if you are NOT owner
125 		if(msg.sender != owner) {
126 			require(transferActive);
127 		}
128 		_;
129 	}
130 	
131     /*
132         FUNCTIONS
133     */  
134     /**
135         @dev approves a spender to spend an amount.
136         @param spender address of the spender
137         @param val the amount they will be approved to spend.
138         @return true
139      */
140     function approve(address spender, uint val) public returns (bool) {
141         allowed[msg.sender][spender] = val;
142         Approval(msg.sender, spender, val);
143         return true;
144     }
145 
146     /**
147         @dev function to transfer tokens inter-user
148         @param to address of the recipient of the tokens
149         @param val the amount to transfer
150         @return true
151      */
152 	function transfer(address to, uint val) transferable ICOTerminated public returns (bool) {
153 		//only send to a valid address
154 		require(to != address(0));
155 		require(val <= balances[msg.sender]);
156 
157 		//deduct the val from sender
158 		balances[msg.sender] = balances[msg.sender] - val;
159 
160 		//give the val to the recipient
161 		balances[to] = balances[to] + val;
162 
163 		//emit transfer event 
164 		Transfer(msg.sender, to, val);
165 		return true;
166 	}
167 
168     /**
169         @dev returns the balance of NTS for an address
170         @return balance NTS balance
171      */
172 	function balanceOf(address client) public constant returns (uint) {
173 		return balances[client];
174 	}
175 
176     /**
177         @dev transfer tokens from one address to another, independant of executor.
178         @param from the address of the sender of the tokens.
179         @param recipient the recipient of the tokens
180         @param val the amount of tokens
181         @return true
182      */
183 	function transferFrom(address from, address recipient, uint val) transferable ICOTerminated public returns (bool) {
184 		//to and from must be valid addresses
185 		require(recipient != address(0));
186 		require(from != address(0));
187 		//tokens must exist in from account
188 		require(val <= balances[from]);
189         allowed[from][msg.sender] = allowed[from][msg.sender].sub(val);
190 		balances[from] = balances[from] - val;
191 		balances[recipient] = balances[recipient] + val;
192 
193 		Transfer(from,recipient,val);
194         return true;
195 	}
196 	
197     /**
198         @dev allows Nauticus to toggle disable all inter-user transfers, ICE.
199         @param newTransferState whether inter-user transfers are allowed.
200         @return true
201      */
202 	function toggleTransfer(bool newTransferState) onlyOwner public returns (bool) {
203 	    require(newTransferState != transferActive);
204 	    transferActive = newTransferState;
205 	    return true;
206 	}
207 	
208     /**
209         @dev mint the appropriate amount of tokens, which is relative to tokens sold, unless hardcap is reached.
210         @param tokensToExist the amount of tokens purchased on the Nauticus platform.
211         @return true
212      */
213 	function mint(uint tokensToExist) onlyOwner ICOTerminated canMint public returns (bool) {
214 	    tokensToExist > hardCap ? totalSupply = hardCap : totalSupply = tokensToExist;
215 	    balances[owner] = balances[owner].add(totalSupply);
216         minted = true;
217         transferActive = true;
218 	    return true;
219 	    
220 	}
221     /**
222         @dev allocate an allowance to a user
223         @param holder person who holds the allowance
224         @param recipient the recipient of a transfer from the holder
225         @return remaining tokens left in allowance
226      */
227 	
228     function allowance(address holder, address recipient) public constant returns (uint) {
229         return allowed[holder][recipient];
230     }
231     
232     /**
233         @dev constructor, nothing needs to happen upon contract creation, left blank.
234      */
235     function NauticusToken () public {}
236 	
237 }