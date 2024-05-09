1 pragma solidity ^0.4.10;
2 
3 /* taking ideas from FirstBlood token */
4 contract SafeMath {
5 
6     /* function assert(bool assertion) internal { */
7     /*   if (!assertion) { */
8     /*     throw; */
9     /*   } */
10     /* }      // assert no longer needed once solidity is on 0.4.10 */
11 
12     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
13       uint256 z = x + y;
14       assert((z >= x) && (z >= y));
15       return z;
16     }
17 
18     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
19       assert(x >= y);
20       uint256 z = x - y;
21       return z;
22     }
23 
24     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
25       uint256 z = x * y;
26       assert((x == 0)||(z/x == y));
27       return z;
28     }
29 
30 }
31 
32 contract Token {
33     uint256 public totalSupply;
34     function balanceOf(address _owner) constant returns (uint256 balance);
35     function transfer(address _to, uint256 _value) returns (bool success);
36     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
37     function approve(address _spender, uint256 _value) returns (bool success);
38     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 }
42 
43 
44 /*  ERC 20 token */
45 contract StandardToken is Token {
46 
47     function transfer(address _to, uint256 _value) returns (bool success) {
48       if (balances[msg.sender] >= _value && _value > 0) {
49         balances[msg.sender] -= _value;
50         balances[_to] += _value;
51         Transfer(msg.sender, _to, _value);
52         return true;
53       } else {
54         return false;
55       }
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
59       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
60         balances[_to] += _value;
61         balances[_from] -= _value;
62         allowed[_from][msg.sender] -= _value;
63         Transfer(_from, _to, _value);
64         return true;
65       } else {
66         return false;
67       }
68     }
69 
70     function balanceOf(address _owner) constant returns (uint256 balance) {
71         return balances[_owner];
72     }
73 
74     function approve(address _spender, uint256 _value) returns (bool success) {
75         allowed[msg.sender][_spender] = _value;
76         Approval(msg.sender, _spender, _value);
77         return true;
78     }
79 
80     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
81       return allowed[_owner][_spender];
82     }
83 
84     mapping (address => uint256) balances;
85     mapping (address => mapping (address => uint256)) allowed;
86 }
87 
88 contract CryptiblesVendingContract is StandardToken, SafeMath {
89 
90     // metadata
91     bool public isOpen;
92     uint256 ethDivisor = 1000000000000000000;
93     string version = "1.0";
94 
95     // Owner of this contract
96     address public owner;
97     uint256 public totalSupply;
98 
99     // contracts
100     address public ethFundDeposit;      // Address to deposit ETH to. LS Address
101 
102     // crowdsale parameters
103     uint256 public tokenExchangeRate = 1000000000000000000;
104     StandardToken cryptiToken;
105 
106     address public currentTokenOffered = 0x16b262b66E300C7410f0771eAC29246A75fb8c48;
107 
108     // events
109     event TransferCryptibles(address indexed _to, uint256 _value);
110     
111     // Functions with this modifier can only be executed by the owner
112     modifier onlyOwner() {
113         require(msg.sender == owner);
114         _;
115     }
116     
117     // constructor
118     function CryptiblesVendingContract()
119     {
120       isOpen = true;
121       totalSupply = 0;
122       owner = msg.sender;
123       cryptiToken =  StandardToken(currentTokenOffered);
124     }
125     
126     /// @dev Accepts ether and creates new Cryptible tokens.
127     function () payable {
128       require(isOpen);
129       require(msg.value != 0);
130       
131       require(cryptiToken.balanceOf(this) >= tokens);
132       
133       uint256 amountSent = msg.value;
134       uint256 tokens = safeMult(amountSent, tokenExchangeRate) / ethDivisor; // check that we're not over totals
135       totalSupply = safeAdd(totalSupply, tokens);
136       cryptiToken.transfer(msg.sender, tokens);
137       
138       TransferCryptibles(msg.sender, tokens);  // logs token transfer
139     }
140 
141     /// @dev sends the ETH home
142     function finalize() onlyOwner{
143       isOpen = false;
144       ethFundDeposit.transfer(this.balance);  // send the eth to LS
145     }
146 
147     /// @dev Allow to change the tokenExchangeRate
148     function changeTokenExchangeRate(uint256 _tokenExchangeRate) onlyOwner{
149         tokenExchangeRate = _tokenExchangeRate;
150     }
151 
152     function setETHAddress(address _ethAddr) onlyOwner{
153       ethFundDeposit = _ethAddr;
154     }
155     
156     function getRemainingTokens(address _sendTokensTo) onlyOwner{
157         require(_sendTokensTo != address(this));
158         var tokensLeft = cryptiToken.balanceOf(this);
159         cryptiToken.transfer(_sendTokensTo, tokensLeft);
160     }
161 
162     function changeIsOpenFlag(bool _value) onlyOwner{
163       isOpen = _value;
164     }
165 
166     function changeCrytiblesAddress(address _newAddr) onlyOwner{
167       currentTokenOffered = _newAddr;
168       cryptiToken =  StandardToken(currentTokenOffered);
169     }
170 }