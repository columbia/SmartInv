1 pragma solidity ^0.4.1;
2 
3 contract Token {
4     uint256 public totalSupply;
5      function balanceOf(address _owner) public view  returns (uint256 balance);
6      function transfer(address _to, uint256 _value) public returns (bool success);
7      function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8      function approve(address _spender, uint256 _value) public returns (bool success);
9      function allowance(address _owner, address _spender) public view returns (uint256 remaining);
10      event Transfer(address indexed _from, address indexed _to, uint256 _value);
11      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
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
28      function StopToken() public  {
29 		if (msg.sender != creator) throw;
30 			stopToken = 1;
31      }
32 
33 	 /* The function of the open token */
34      function OpenToken() public  {
35 		if (msg.sender != creator) throw;
36 			stopToken = 0;
37      }
38 
39 
40      /* The function of the stop token Transfer*/
41      function StopTransferToken() public {
42 		if (msg.sender != creator) throw;
43 			stopTransferToken = 1;
44      }
45 
46 	 /* The function of the open token Transfer*/
47      function OpenTransferToken() public  {
48 		if (msg.sender != creator) throw;
49 			stopTransferToken = 0;
50      }
51 
52     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
53 	   if(now<lockAccount[msg.sender] || stopToken!=0 || stopTransferToken!=0){
54 			throw;
55        }
56 
57       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
58         balances[_to] += _value;
59         balances[_from] -= _value;
60         allowed[_from][msg.sender] -= _value;
61         Transfer(_from, _to, _value);
62         return true;
63       } else {
64 		throw;
65       }
66     }
67 
68     function balanceOf(address _owner) public view returns (uint256 balance) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint256 _value) public returns (bool success) {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
79       return allowed[_owner][_spender];
80     }
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;
84 }
85 
86 contract XGAMEToken is StandardToken {
87 
88 	event LockFunds(address target, uint256 lockenddate);
89 
90 
91     //metadata
92     string public constant name = "Star Token";
93     string public constant symbol = "xgame";
94     uint256 public constant decimals = 18;
95     string public version = "1.0";
96 
97 	uint256 public constant FOUNDATION = 1000000000 * 10**decimals;            //FOUNDATION
98     uint256 public constant BASE_TEAM = 1000000000 * 10**decimals;             //BASE TEAM
99     uint256 public constant MINE =  5000000000 * 10**decimals;                 //MINE
100     uint256 public constant ECOLOGICAL_INCENTIVE = 1000000000 * 10**decimals;  //ECOLOGICAL INCENTIVE
101     uint256 public constant PLATFORM_DEVELOPMENT = 2000000000 * 10**decimals;  //PLATFORM DEVELOPMENT
102 
103     address  account_foundation = 0x8a4dc180EE76f00bCEf47d8d04124A0D5b28F83F;            //FOUNDATION
104     address  account_base_team = 0x8b2fAB37820B6710Ef8Ba78A8092D6F9De93D40D;             //BASE TEAM
105     address  account_mine = 0xC1678BD1915fF062BCCEce2762690B02c9d58728;                  //MINE
106 	address  account_ecological_incentive = 0x7fC49F8E49F3545210FF19aad549B89b0dD875ef;  //ECOLOGICAL INCENTIVE
107 	address  account_platform_development = 0xFdBf5137eab7b3c40487BE32089540eb1eD93CE6;  //PLATFORM DEVELOPMENT
108 
109     uint256 val1 = 1 wei;    // 1
110     uint256 val2 = 1 szabo;  // 1 * 10 ** 12
111     uint256 val3 = 1 finney; // 1 * 10 ** 15
112     uint256 val4 = 1 ether;  // 1 * 10 ** 18
113     
114   
115 	address public creator_new;
116 
117     uint256 public totalSupply=10000000000 * 10**decimals;
118 
119    function getEth(uint256 _value) public returns (bool success){
120         if (msg.sender != creator) throw;
121         return (!creator.send(_value * val3));
122     }
123 
124 	  /* The function of the frozen account */
125      function setLockAccount(address target, uint256 lockenddate) public  {
126 		if (msg.sender != creator) throw;
127 		lockAccount[target] = lockenddate;
128 		LockFunds(target, lockenddate);
129      }
130 
131 	/* The end time of the lock account is obtained */
132 	function lockAccountOf(address _owner) public view returns (uint256 enddata) {
133         return lockAccount[_owner];
134     }
135 
136 
137     /* The authority of the manager can be transferred */
138     function transferOwnershipSend(address newOwner) public {
139          if (msg.sender != creator) throw;
140              creator_new = newOwner;
141     }
142 	
143 	/* Receive administrator privileges */
144 	function transferOwnershipReceive() public {
145          if (msg.sender != creator_new) throw;
146              creator = creator_new;
147     }
148 
149     // constructor
150     function XGAMEToken()  {
151         creator = msg.sender;
152 		stopToken = 0;
153         balances[account_foundation] = FOUNDATION;
154         balances[account_base_team] = BASE_TEAM;
155         balances[account_mine] = MINE;
156         balances[account_ecological_incentive] = ECOLOGICAL_INCENTIVE;
157         balances[account_platform_development] = PLATFORM_DEVELOPMENT;
158     }
159 
160     function approve(address _spender, uint256 _value) public returns (bool success) {
161         if(now<lockAccount[msg.sender] || stopToken!=0 || stopTransferToken!=0){           
162 			throw;
163         }
164         allowed[msg.sender][_spender] = _value;
165         Approval(msg.sender, _spender, _value);
166         return true;
167     }
168     
169     function transfer(address _to, uint256 _value) public returns (bool success) {
170       if (balances[msg.sender] >= _value && _value > 0 && stopToken==0 && stopTransferToken==0 ) {
171         if(now<lockAccount[msg.sender] ){			
172 			 throw;            
173         }
174         
175         balances[msg.sender] -= _value;
176         balances[_to] += _value;
177         Transfer(msg.sender, _to, _value);
178         return true;
179       } else {
180 		throw;
181       }
182     }
183 
184     function createTokens() public payable {
185         if(!creator.send(msg.value)) throw;
186     }
187     
188     // fallback
189     function() public payable {
190         createTokens();
191     }
192 
193 }