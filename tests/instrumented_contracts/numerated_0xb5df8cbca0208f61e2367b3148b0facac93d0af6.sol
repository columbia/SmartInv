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
31 contract Ownable {
32 	address public owner;
33 	function Ownable() {owner = msg.sender;}
34 	modifier onlyOwner() {
35 		if (msg.sender != owner) throw;
36 		_;
37 	}
38 
39 }
40 
41 contract Token {
42     uint256 public totalSupply;
43     function balanceOf(address _owner) constant returns (uint256 balance);
44     function transfer(address _to, uint256 _value) returns (bool success);
45     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
46     function approve(address _spender, uint256 _value) returns (bool success);
47     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
48     event Transfer(address indexed _from, address indexed _to, uint256 _value);
49     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 }
51 
52 /*  ERC 20 token */
53 contract StandardToken is Token {
54 
55     function transfer(address _to, uint256 _value) returns (bool success) {
56       if (balances[msg.sender] >= _value && _value > 0) {
57         balances[msg.sender] -= _value;
58         balances[_to] += _value;
59         Transfer(msg.sender, _to, _value);
60         return true;
61       } else {
62         return false;
63       }
64     }
65 
66     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
67       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
68         balances[_to] += _value;
69         balances[_from] -= _value;
70         allowed[_from][msg.sender] -= _value;
71         Transfer(_from, _to, _value);
72         return true;
73       } else {
74         return false;
75       }
76     }
77 
78     function balanceOf(address _owner) constant returns (uint256 balance) {
79         return balances[_owner];
80     }
81 
82     function approve(address _spender, uint256 _value) returns (bool success) {
83         allowed[msg.sender][_spender] = _value;
84         Approval(msg.sender, _spender, _value);
85         return true;
86     }
87 
88     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
89       return allowed[_owner][_spender];
90     }
91 
92     mapping (address => uint256) balances;
93     mapping (address => mapping (address => uint256)) allowed;
94 }
95 
96 contract XCToken is StandardToken,SafeMath,Ownable {
97 
98     // metadata
99     string public constant name = "XC.COM(XC Program)";
100     string public constant symbol = "XC";
101     uint256 public constant decimals = 8;
102     string public version = "1.0";
103     
104     // total cap
105     uint256 public constant tokenCreationCap = 2000 * (10**6) * 10**decimals;
106     // init amount
107     uint256 public constant tokenCreationInit = 1000 * (10**6) * 10**decimals;
108     // The amount of XCTokens that can be mint
109     uint256 public constant tokenMintCap = 1000 * (10**6) * 10**decimals;
110     // The amount of XCTokens that have been minted
111     uint256 public tokenMintedSupply;
112     
113     address public initDepositAccount;
114     address public mintDepositAccount;
115     
116 	bool public mintFinished;
117 	
118 	event Mint(uint256 amount);
119 	event MintFinished();
120 
121     function XCToken(
122         address _initFundDepositAccount,
123         address _mintFundDepositAccount
124         ) {
125         initDepositAccount = _initFundDepositAccount;
126         mintDepositAccount = _mintFundDepositAccount;
127         balances[initDepositAccount] = tokenCreationInit;
128         totalSupply = tokenCreationInit;
129         tokenMintedSupply = 0;
130         mintFinished = false;
131     }
132     
133     modifier canMint() {
134 		if(mintFinished) throw;
135 		_;
136 	}
137 	
138     // The remaining amount of tokens that can be minted.
139 	function remainMintTokenAmount() constant returns (uint256 remainMintTokenAmount) {
140 	    return safeSub(tokenMintCap, tokenMintedSupply);
141 	}
142 
143 	// mint token
144 	function mint(uint256 _tokenAmount) onlyOwner canMint returns (bool) {
145 		if(_tokenAmount <= 0) throw;
146 		uint256 checkedSupply = safeAdd(tokenMintedSupply, _tokenAmount);
147 		if(checkedSupply > tokenMintCap) throw;
148 		if(checkedSupply == tokenMintCap){ // mint finish
149 		    mintFinished = true;
150 		    MintFinished();
151 		}
152 		tokenMintedSupply = checkedSupply;
153 		totalSupply = safeAdd(totalSupply, _tokenAmount);
154 		balances[mintDepositAccount] = safeAdd(balances[mintDepositAccount], _tokenAmount);
155 		Mint(_tokenAmount);
156 		return true;
157 	}
158 	
159 	// Do not allow direct deposits.
160     function () external {
161         throw;
162     }
163 	
164 }