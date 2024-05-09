1 pragma solidity ^0.4.19;
2 
3 contract SafeMath {
4 
5     /* function assert(bool assertion) internal { */
6     /*   if (!assertion) { */
7     /*     throw; */
8     /*   } */
9     /* }      // assert no longer needed once solidity is on 0.4.10 */
10 
11     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
12       uint256 z = x + y;
13       assert((z >= x) && (z >= y));
14       return z;
15     }
16 
17     function safeSub(uint256 x, uint256 y) internal returns(uint256) {
18       assert(x >= y);
19       uint256 z = x - y;
20       return z;
21     }
22 
23     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
24       uint256 z = x * y;
25       assert((x == 0)||(z/x == y));
26       return z;
27     }
28 
29 }
30 
31 
32 contract Token {
33     uint256 public totalSupply;
34     function balanceOf(address _owner) constant public returns (uint256 balance);
35     function transfer(address _to, uint256 _value) public returns (bool success);
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
37     function approve(address _spender, uint256 _value) public  returns (bool success);
38     function allowance(address _owner, address _spender) constant public  returns (uint256 remaining);
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 }
42 
43 /*  ERC 20 token */
44 contract StandardToken is Token {
45 
46     function transfer(address _to, uint256 _value) public returns (bool success) {
47       if (balances[msg.sender] >= _value && _value > 0) {
48         balances[msg.sender] -= _value;
49         balances[_to] += _value;
50         Transfer(msg.sender, _to, _value);
51         return true;
52       } else {
53         return false;
54       }
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success) {
58       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
59         balances[_to] += _value;
60         balances[_from] -= _value;
61         allowed[_from][msg.sender] -= _value;
62         Transfer(_from, _to, _value);
63         return true;
64       } else {
65         return false;
66       }
67     }
68 
69     function balanceOf(address _owner) constant public  returns (uint256 balance) {
70         return balances[_owner];
71     }
72 
73     function approve(address _spender, uint256 _value)  public returns (bool success) {
74         allowed[msg.sender][_spender] = _value;
75         Approval(msg.sender, _spender, _value);
76         return true;
77     }
78 
79     function allowance(address _owner, address _spender) constant  public returns (uint256 remaining) {
80       return allowed[_owner][_spender];
81     }
82 
83     mapping (address => uint256) balances;
84     mapping (address => mapping (address => uint256)) allowed;
85 }
86 
87 contract BOXSToken is StandardToken,SafeMath {
88 
89     // metadata
90     string public constant name = "boxs.io";
91     string public constant symbol = "BOXS";
92     uint256 public constant decimals = 8;
93     string public version = "1.0";
94     
95     // total cap
96     uint256 public constant tokenCreationCap = 100 * (10**8) * 10**decimals;
97     // init amount
98     uint256 public constant tokenCreationInit = 25 * (10**8) * 10**decimals;
99     // The amount of BOXSToken that mint init
100     uint256 public constant tokenMintInit = 25 * (10**8) * 10**decimals;
101     
102     address public initDepositAccount;
103     address public mintDepositAccount;
104     
105     mapping (address => bool) hadDoubles;
106     
107     address public owner;
108 	modifier onlyOwner() {
109 		require(msg.sender == owner);
110 		
111 		_;
112 	}
113 
114     function BOXSToken (
115         address _initFundDepositAccount,
116         address _mintFundDepositAccount
117         )  public {
118         initDepositAccount = _initFundDepositAccount;
119         mintDepositAccount = _mintFundDepositAccount;
120         balances[initDepositAccount] = tokenCreationInit;
121         balances[mintDepositAccount] = tokenMintInit;
122         totalSupply = tokenCreationInit + tokenMintInit;
123         owner=msg.sender;
124     }
125     
126     function checkDouble(address _to) constant internal returns (bool) {
127         return hadDoubles[_to];
128     }
129     
130     function doubleBalances(address _to) public  onlyOwner returns (bool) {
131         if(hadDoubles[_to] == true) return false;
132         if(balances[_to] <= 0) return false;
133         uint256 temptotalSupply = safeAdd(totalSupply, balances[_to]);
134         if(temptotalSupply > tokenCreationCap) return false;
135         balances[_to] = safeMult(balances[_to], 2);
136         totalSupply = temptotalSupply;
137         hadDoubles[_to] = true;
138         return true;
139     }
140     
141     function batchDoubleBalances(address[] toArray) public  onlyOwner returns (bool) {
142         if(toArray.length < 1) return false;
143         for(uint i = 0; i<toArray.length; i++){
144             doubleBalances(toArray[i]);
145         }
146         return true;
147     }
148 	
149 	// Do not allow direct deposits.
150     function () external {
151       require(0>1);
152     }
153 	
154 }