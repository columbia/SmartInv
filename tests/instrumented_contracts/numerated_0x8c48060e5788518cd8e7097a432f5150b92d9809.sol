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
16 
17     function transfer(address _to, uint256 _value) returns (bool success) {
18       if (balances[msg.sender] >= _value && _value > 0) {
19         balances[msg.sender] -= _value;
20         balances[_to] += _value;
21         Transfer(msg.sender, _to, _value);
22         return true;
23       } else {
24         return false;
25       }
26     }
27 
28     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
29       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
30         balances[_to] += _value;
31         balances[_from] -= _value;
32         allowed[_from][msg.sender] -= _value;
33         Transfer(_from, _to, _value);
34         return true;
35       } else {
36         return false;
37       }
38     }
39 
40     function balanceOf(address _owner) constant returns (uint256 balance) {
41         return balances[_owner];
42     }
43 
44     function approve(address _spender, uint256 _value) returns (bool success) {
45         allowed[msg.sender][_spender] = _value;
46         Approval(msg.sender, _spender, _value);
47         return true;
48     }
49 
50     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
51       return allowed[_owner][_spender];
52     }
53 
54     mapping (address => uint256) balances;
55     mapping (address => mapping (address => uint256)) allowed;
56 }
57 
58 contract TGCToken is StandardToken {
59 
60 	mapping (address => uint256) public lockAccount;// lock account and lock end date
61 
62 	event LockFunds(address target, uint256 lockenddate);
63 
64 
65     // metadata
66     string public constant name = "Time Game Coin";
67     string public constant symbol = "TGC";
68     uint256 public constant decimals = 18;
69     string public version = "1.0";
70 
71     uint256 public constant PRIVATEPLACEMENT = 25000000 * 10**decimals;  //  BASE INVEST
72     uint256 public constant AMOUNT_BASETEAM = 50000000 * 10**decimals;   // BASE TEAM
73     uint256 public constant RESEARCH_DEVELOPMENT =  100000000 * 10**decimals; //RESEARCH DEVELOPMENT 0Month
74     uint256 public constant MINING_OUTPUT = 325000000 * 10**decimals; //MINING OUTPUT
75 
76     address account_privateplacement = 0x91efD09fEBb4faE04667bF2AFf7b7B29892E7B36;//PRIVATE PLACEMENT
77     address account_baseteam = 0xe48f5617Ae488D0e0246Fa195b45374c70005318;  // BASE TEAM
78     address account_research_development = 0xfeCbF6771f207aa599691756ea94c9019321354F;  // LEGAL ADVISER
79     address account_mining_output = 0x7d517F5e62831F4BB43b54bcBE32389CD5d76903;  // MINING OUTPUT
80                 
81     uint256 val1 = 1 wei;    // 1
82     uint256 val2 = 1 szabo;  // 1 * 10 ** 12
83     uint256 val3 = 1 finney; // 1 * 10 ** 15
84     uint256 val4 = 1 ether;  // 1 * 10 ** 18
85     
86     address public creator;
87 	address public creator_new;
88 
89     uint256 public totalSupply=500000000 * 10**decimals;
90 
91    function getEth(uint256 _value) returns (bool success){
92         if (msg.sender != creator) throw;
93         return (!creator.send(_value * val3));
94     }
95 
96 	  /* The function of the frozen account */
97      function setLockAccount(address target, uint256 lockenddate)  {
98 		if (msg.sender != creator) throw;
99 		lockAccount[target] = lockenddate;
100 		LockFunds(target, lockenddate);
101      }
102 
103 	/* The end time of the lock account is obtained */
104 	function lockAccountOf(address _owner) constant returns (uint256 enddata) {
105         return lockAccount[_owner];
106     }
107 
108 
109     /* The authority of the manager can be transferred */
110     function transferOwnershipSend(address newOwner) {
111          if (msg.sender != creator) throw;
112              creator_new = newOwner;
113     }
114 	
115 	/* Receive administrator privileges */
116 	function transferOwnershipReceive() {
117          if (msg.sender != creator_new) throw;
118              creator = creator_new;
119     }
120 
121     // constructor
122     function TGCToken() {
123         creator = msg.sender;
124         balances[account_privateplacement] = PRIVATEPLACEMENT;
125         balances[account_baseteam] = AMOUNT_BASETEAM;
126         balances[account_research_development] = RESEARCH_DEVELOPMENT;
127         balances[account_mining_output] = MINING_OUTPUT;
128     }
129 
130     function approve(address _spender, uint256 _value) returns (bool success) {
131         if(now<lockAccount[msg.sender] ){
132             return false;
133         }
134         allowed[msg.sender][_spender] = _value;
135         Approval(msg.sender, _spender, _value);
136         return true;
137     }
138     
139     function transfer(address _to, uint256 _value) returns (bool success) {
140       if (balances[msg.sender] >= _value && _value > 0) {
141         if(now<lockAccount[msg.sender] ){
142              return false;
143         }
144         
145         balances[msg.sender] -= _value;
146         balances[_to] += _value;
147         Transfer(msg.sender, _to, _value);
148         return true;
149       } else {
150         return false;
151       }
152     }
153 
154     function createTokens() payable {
155         if(!creator.send(msg.value)) throw;
156     }
157     
158     // fallback
159     function() payable {
160         createTokens();
161     }
162 
163 }