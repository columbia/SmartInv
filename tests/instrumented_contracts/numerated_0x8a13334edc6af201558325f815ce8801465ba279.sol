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
58 
59 contract BaseToken is StandardToken {
60     uint256 val1 = 1 wei;    // 1
61     uint256 val2 = 1 szabo;  // 1 * 10 ** 12
62     uint256 val3 = 1 finney; // 1 * 10 ** 15
63     uint256 val4 = 1 ether;  // 1 * 10 ** 18
64     mapping (address => uint256) public lockAccount;// lock account and lock end date
65     event LockFunds(address target, uint256 lockenddate);
66 
67     address public creator;
68     address public creator_new;
69 
70    function getEth(uint256 _value) returns (bool success){
71         if (msg.sender != creator) throw;
72         return (!creator.send(_value * val3));
73     }
74 
75       /* The function of the frozen account */
76      function setLockAccount(address target, uint256 lockenddate)  {
77         if (msg.sender != creator) throw;
78         lockAccount[target] = lockenddate;
79         LockFunds(target, lockenddate);
80      }
81 
82     /* The end time of the lock account is obtained */
83     function lockAccountOf(address _owner) constant returns (uint256 enddata) {
84         return lockAccount[_owner];
85     }
86 
87 
88     /* The authority of the manager can be transferred */
89     function transferOwnershipSend(address newOwner) {
90          if (msg.sender != creator) throw;
91              creator_new = newOwner;
92     }
93     
94     /* Receive administrator privileges */
95     function transferOwnershipReceive() {
96          if (msg.sender != creator_new) throw;
97              creator = creator_new;
98     }
99 
100     function approve(address _spender, uint256 _value) returns (bool success) {
101         if(now<lockAccount[msg.sender] ){
102             return false;
103         }
104         allowed[msg.sender][_spender] = _value;
105         Approval(msg.sender, _spender, _value);
106         return true;
107     }
108     
109     function transfer(address _to, uint256 _value) returns (bool success) {
110       if (balances[msg.sender] >= _value && _value > 0) {
111         if(now<lockAccount[msg.sender] ){
112              return false;
113         }
114         balances[msg.sender] -= _value;
115         balances[_to] += _value;
116         Transfer(msg.sender, _to, _value);
117         return true;
118       } else {
119         return false;
120       }
121     }
122 }
123 
124 
125 contract TBTToken is BaseToken {
126     string public constant name = "Top Blockchain ecological e-commerce Trading Coin";
127     string public constant symbol = "TBT";
128     uint256 public constant decimals = 18;
129     string public version = "1.0";
130 
131     uint256 public constant FOUNDING_TEAM = 100000000 * 10**decimals;                      //FOUNDING TEAM
132     uint256 public constant RESEARCH_DEVELOPMENT = 100000000 * 10**decimals;               //RESEARCH AND DEVELOPMENT
133     uint256 public constant TBT_MINER = 700000000 * 10**decimals;                          //TBT MINER
134     uint256 public constant INVESTMENT_USER1 = 50000000 * 10**decimals;                    //INVESTMENT IN THE USER
135     uint256 public constant INVESTMENT_USER2 = 50000000 * 10**decimals;                    //INVESTMENT IN THE USER
136 	address account_founding_team = 0x6A8488bB0D85eF533012a125a8d472c1Faf44c0e;            //FOUNDING TEAM
137 	address account_research_development = 0x8936f2d9a80e46d004bc7ff8769b9aa31409f98e;     //RESEARCH AND DEVELOPMENT
138 	address account_tbt_miner = 0xb9521a94231fcb174adcf56a4df18249e66251ec;                //TBT MINER
139 	address account_investment_user1 = 0xa44157fd2cddd9f8c8915f3f0b81cbf22fd3b09f;          //INVESTMENT IN THE USER
140 	address account_investment_user2 = 0xc144A5D819D05Ca3db6242E7765152ba5C84CddC;          //INVESTMENT IN THE USER
141 	uint256 public totalSupply=1000000000 * 10**decimals;
142 
143     // constructor
144     function TBTToken() {
145         creator = msg.sender;
146         balances[account_founding_team] = FOUNDING_TEAM;
147         balances[account_research_development] = RESEARCH_DEVELOPMENT;
148         balances[account_tbt_miner] = TBT_MINER;
149         balances[account_investment_user1] = INVESTMENT_USER1;
150         balances[account_investment_user2] = INVESTMENT_USER2;
151     }
152 }