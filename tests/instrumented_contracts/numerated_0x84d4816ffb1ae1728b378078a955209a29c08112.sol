1 pragma solidity ^0.4.10;
2 
3 contract Token {
4     uint256 public totalSupply;
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 /*  ERC 20 token */
15 contract StandardToken is Token {
16 	 //using SafeMath for uint256;
17 	 address public creator;
18     /*1 close token  0:open token*/
19 	uint256 public stopToken = 0;
20 
21 	mapping (address => uint256) public lockAccount;// lock account and lock end date
22 
23     /*1 close token transfer  0:open token  transfer*/
24 	uint256 public stopTransferToken = 0;
25     
26 
27      /* The function of the stop token */
28      function StopToken()  {
29 		if (msg.sender != creator) throw;
30 			stopToken = 1;
31      }
32 
33 	 /* The function of the open token */
34      function OpenToken()  {
35 		if (msg.sender != creator) throw;
36 			stopToken = 0;
37      }
38 
39 
40      /* The function of the stop token Transfer*/
41      function StopTransferToken()  {
42 		if (msg.sender != creator) throw;
43 			stopTransferToken = 1;
44      }
45 
46 	 /* The function of the open token Transfer*/
47      function OpenTransferToken()  {
48 		if (msg.sender != creator) throw;
49 			stopTransferToken = 0;
50      }
51 
52     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
53 	   if(now<lockAccount[msg.sender] || stopToken!=0 || stopTransferToken!=0){
54             return false;
55        }
56 
57       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
58         balances[_to] += _value;
59         balances[_from] -= _value;
60         allowed[_from][msg.sender] -= _value;
61         Transfer(_from, _to, _value);
62         return true;
63       } else {
64         return false;
65       }
66     }
67 
68     function balanceOf(address _owner) constant returns (uint256 balance) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint256 _value) returns (bool success) {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
79       return allowed[_owner][_spender];
80     }
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;
84 }
85 
86 contract GESToken is StandardToken {
87 
88 	event LockFunds(address target, uint256 lockenddate);
89 
90 
91     // metadata
92     string public constant name = "Game Engine Chain";
93     string public constant symbol = "GES";
94     uint256 public constant decimals = 18;
95     string public version = "1.0";
96 
97 	uint256 public constant PRIVATE_PHASE = 2000000000 * 10**decimals;        //PRIVATE PHASE
98     uint256 public constant BASE_TEAM = 2000000000 * 10**decimals;            //BASE TEAM
99     uint256 public constant PLATFORM_DEVELOPMENT = 1000000000 * 10**decimals; //PLATFORM DEVELOPMENT
100 	uint256 public constant STAGE_FOUNDATION = 500000000 * 10**decimals;     //STAGE OF FOUNDATION
101     uint256 public constant MINE =  4500000000 * 10**decimals;                //MINE
102 
103 
104     address account_private_phase = 0xcd92a976a58ce478510c957a7d83d3b582365b28;         // PRIVATE PHASE
105     address account_base_team = 0x1a8a6b0861e097e0067d6fc6f0d3797182e4e39c;             //BASE TEAM
106 	address account_platform_development = 0xc679b72826526a0960858385463b4e3931698afe;  //PLATFORM DEVELOPMENT
107 	address account_stage_foundation = 0x1f10c8810b107b2f88a21bab7d6cfe1afa56bcd8;      //STAGE OF FOUNDATION
108     address account_mine = 0xe10f697c52da461eeba0ffa3f035a22fc7d3a2ed;                  //MINE
109 
110     uint256 val1 = 1 wei;    // 1
111     uint256 val2 = 1 szabo;  // 1 * 10 ** 12
112     uint256 val3 = 1 finney; // 1 * 10 ** 15
113     uint256 val4 = 1 ether;  // 1 * 10 ** 18
114     
115   
116 	address public creator_new;
117 
118     uint256 public totalSupply=10000000000 * 10**decimals;
119 
120    function getEth(uint256 _value) returns (bool success){
121         if (msg.sender != creator) throw;
122         return (!creator.send(_value * val3));
123     }
124 
125 	  /* The function of the frozen account */
126      function setLockAccount(address target, uint256 lockenddate)  {
127 		if (msg.sender != creator) throw;
128 		lockAccount[target] = lockenddate;
129 		LockFunds(target, lockenddate);
130      }
131 
132 	/* The end time of the lock account is obtained */
133 	function lockAccountOf(address _owner) constant returns (uint256 enddata) {
134         return lockAccount[_owner];
135     }
136 
137 
138     /* The authority of the manager can be transferred */
139     function transferOwnershipSend(address newOwner) {
140          if (msg.sender != creator) throw;
141              creator_new = newOwner;
142     }
143 	
144 	/* Receive administrator privileges */
145 	function transferOwnershipReceive() {
146          if (msg.sender != creator_new) throw;
147              creator = creator_new;
148     }
149 
150     // constructor
151     function GESToken() {
152         creator = msg.sender;
153 		stopToken = 0;
154         balances[account_private_phase] = PRIVATE_PHASE;
155         balances[account_base_team] = BASE_TEAM;
156         balances[account_platform_development] = PLATFORM_DEVELOPMENT;
157         balances[account_stage_foundation] = STAGE_FOUNDATION;
158         balances[account_mine] = MINE;
159     }
160 
161     function approve(address _spender, uint256 _value) returns (bool success) {
162         if(now<lockAccount[msg.sender] || stopToken!=0 || stopTransferToken!=0){
163             return false;
164         }
165         allowed[msg.sender][_spender] = _value;
166         Approval(msg.sender, _spender, _value);
167         return true;
168     }
169     
170     function transfer(address _to, uint256 _value) returns (bool success) {
171       if (balances[msg.sender] >= _value && _value > 0 && stopToken==0 && stopTransferToken==0 ) {
172         if(now<lockAccount[msg.sender] ){
173              return false;
174         }
175         
176         balances[msg.sender] -= _value;
177         balances[_to] += _value;
178         Transfer(msg.sender, _to, _value);
179         return true;
180       } else {
181         return false;
182       }
183     }
184 
185     function createTokens() payable {
186         if(!creator.send(msg.value)) throw;
187     }
188     
189     // fallback
190     function() payable {
191         createTokens();
192     }
193 
194 }