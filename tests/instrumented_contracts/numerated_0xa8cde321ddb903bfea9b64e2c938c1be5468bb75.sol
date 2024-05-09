1 pragma solidity ^0.4.11;
2     
3 
4   contract ERC20Interface {
5       // Get the total token supply
6       function totalSupply() constant returns (uint256 totalSupply);
7    
8       // Get the account balance of another account with address _owner
9       function balanceOf(address _owner) constant returns (uint256 balance);
10    
11       // Send _value amount of tokens to address _to
12       function transfer(address _to, uint256 _value) returns (bool success);
13    
14       // Send _value amount of tokens from address _from to address _to
15       function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
16    
17       // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
18       // If this function is called again it overwrites the current allowance with _value.
19       // this function is required for some DEX functionality
20       function approve(address _spender, uint256 _value) returns (bool success);
21    
22       // Returns the amount which _spender is still allowed to withdraw from _owner
23       function allowance(address _owner, address _spender) constant returns (uint256 remaining);
24    
25       // Triggered when tokens are transferred.
26       event Transfer(address indexed _from, address indexed _to, uint256 _value);
27    
28       // Triggered whenever approve(address _spender, uint256 _value) is called.
29       event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30   }
31    
32   contract ImmutableShares is ERC20Interface {
33       
34      string public constant symbol = "CSH";
35       string public constant name = "Cryptex Shares";
36       uint8 public constant decimals = 0;
37       uint256 _totalSupply = 53000000;
38       uint256 public totalSupply;
39       uint256 public TotalDividendsPerShare;
40       address public fallbackAccount = 0x0099F456e88E0BF635f6B2733e4228a2b5749675; 
41 
42       // Owner of this contract
43       address public owner;
44    
45       // Balances for each account
46       mapping(address => uint256) public balances;
47    
48       // Owner of account approves the transfer of an amount to another account
49       mapping(address => mapping (address => uint256)) allowed;
50 
51       // dividends paid per share
52       mapping (address => uint256) public dividendsPaidPerShare;
53    
54       // Functions with this modifier can only be executed by the owner
55       modifier onlyOwner() {
56           if (msg.sender != owner) {
57               throw;
58           }
59           _;
60       }
61    
62       // Constructor
63       function ImmutableShares() {
64           owner = msg.sender;
65           balances[owner] = _totalSupply;
66 	      totalSupply = _totalSupply;  // Update total supply
67       }
68 
69 
70 function isContract(address addr) returns (bool) {
71   uint size;
72   assembly { size := extcodesize(addr) }
73   return size > 0;
74   addr=addr;
75 }
76 
77   function changeFallbackAccount(address fallbackAccount_) {
78     if (msg.sender != owner) throw;
79     fallbackAccount = fallbackAccount_;
80   }
81 
82 //withdraw function
83    function withdrawMyDividend() payable {
84    bool IsContract = isContract(msg.sender);
85    if((balances[msg.sender] > 0) && (!IsContract)){
86      uint256 AmountToSendPerShare = TotalDividendsPerShare - dividendsPaidPerShare[msg.sender];
87      dividendsPaidPerShare[msg.sender] = TotalDividendsPerShare;
88   if((balances[msg.sender]*AmountToSendPerShare) > 0){
89      msg.sender.transfer(balances[msg.sender]*AmountToSendPerShare);}
90 }
91 
92 if((balances[msg.sender] > 0) && (IsContract)){
93      uint256 AmountToSendPerShareEx = TotalDividendsPerShare - dividendsPaidPerShare[msg.sender];
94      dividendsPaidPerShare[msg.sender] = TotalDividendsPerShare;
95      if((balances[msg.sender]*AmountToSendPerShareEx) > 0){
96      fallbackAccount.transfer(balances[msg.sender]*AmountToSendPerShareEx);}
97 }
98 
99    }
100 
101 //pay receiver’s dividends
102   function payReceiver(address ReceiverAddress) payable {
103    if(balances[ReceiverAddress] > 0){
104      uint256 AmountToSendPerShare = TotalDividendsPerShare - dividendsPaidPerShare[ReceiverAddress];
105      dividendsPaidPerShare[ReceiverAddress] = TotalDividendsPerShare;
106      if((balances[ReceiverAddress]*AmountToSendPerShare) > 0){
107      ReceiverAddress.transfer(balances[ReceiverAddress]*AmountToSendPerShare);}
108 }
109 
110 }
111    
112       function totalSupply() constant returns (uint256 totalSupply) {
113           totalSupply = _totalSupply;
114       }
115    
116       // What is the balance of a particular account?
117       function balanceOf(address _owner) constant returns (uint256 balance) {
118           return balances[_owner];
119       }
120    
121       // Transfer the balance from owner's account to another account
122       function transfer(address _to, uint256 _amount) returns (bool success) {
123           if (balances[msg.sender] >= _amount 
124               && _amount > 0
125               && balances[_to] + _amount > balances[_to]) {
126        
127        withdrawMyDividend();
128        payReceiver(_to);
129 
130               balances[msg.sender] -= _amount;
131               balances[_to] += _amount;
132               Transfer(msg.sender, _to, _amount);
133 
134        dividendsPaidPerShare[_to] = TotalDividendsPerShare;
135 
136               return true;
137 
138           } else {
139               return false;
140           }
141       }
142    
143       // Send _value amount of tokens from address _from to address _to
144       // The transferFrom method is used for a withdraw workflow, allowing contracts to send
145       // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
146       // fees in sub-currencies; the command should fail unless the _from account has
147       // deliberately authorized the sender of the message via some mechanism; we propose
148       // these standardized APIs for approval:
149       function transferFrom(
150           address _from,
151           address _to,
152           uint256 _amount
153      ) returns (bool success) {
154          if (balances[_from] >= _amount
155              && allowed[_from][msg.sender] >= _amount
156              && _amount > 0
157              && balances[_to] + _amount > balances[_to]) {
158 
159        withdrawMyDividend();
160        payReceiver(_to);
161 
162              balances[_from] -= _amount;
163              allowed[_from][msg.sender] -= _amount;
164              balances[_to] += _amount;
165              Transfer(_from, _to, _amount);
166 
167        dividendsPaidPerShare[_from] = TotalDividendsPerShare;     
168        dividendsPaidPerShare[_to] = TotalDividendsPerShare;
169 
170              return true;
171          } else {
172              return false;
173          }
174      }
175   
176      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
177      // If this function is called again it overwrites the current allowance with _value.
178      function approve(address _spender, uint256 _amount) returns (bool success) {
179          allowed[msg.sender][_spender] = _amount;
180          Approval(msg.sender, _spender, _amount);
181          return true;
182      }
183   
184      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
185          return allowed[_owner][_spender];
186      }
187 
188    /* This unnamed function is called whenever someone tries to send ether to it */
189    function () payable {
190    if(msg.value != 5300000000000000000) throw; //5.3 ether
191    TotalDividendsPerShare += (msg.value/totalSupply);
192    }
193 
194  }