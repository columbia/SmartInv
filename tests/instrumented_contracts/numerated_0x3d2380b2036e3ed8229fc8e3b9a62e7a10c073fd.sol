1 pragma solidity ^0.4.20;
2 
3 contract Token {
4     function totalSupply() constant returns (uint256 supply) {}
5     function balanceOf(address _owner) constant returns (uint256 balance) {}
6     function transfer(address _to, uint256 _value) returns (bool success) {}
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
8     function approve(address _spender, uint256 _value) returns (bool success) {}
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract StandardToken is Token {
15     function transfer(address _to, uint256 _value) returns (bool success) {
16         if (balances[msg.sender] >= _value && _value > 0) {
17             balances[msg.sender] -= _value;
18             balances[_to] += _value;
19             Transfer(msg.sender, _to, _value);
20             return true;
21         } else { return false; }
22     }
23 
24     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
25         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
26             balances[_to] += _value;
27             balances[_from] -= _value;
28             allowed[_from][msg.sender] -= _value;
29             Transfer(_from, _to, _value);
30             return true;
31         } else { return false; }
32     }
33 
34     function balanceOf(address _owner) constant returns (uint256 balance) {
35         return balances[_owner];
36     }
37 
38     function approve(address _spender, uint256 _value) returns (bool success) {
39         allowed[msg.sender][_spender] = _value;
40         Approval(msg.sender, _spender, _value);
41         return true;
42     }
43 
44     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
45       return allowed[_owner][_spender];
46     }
47 
48     mapping (address => uint256) balances;
49     mapping (address => mapping (address => uint256)) allowed;
50     uint256 public totalSupply;
51 }
52 
53 contract FairDinkums is StandardToken { 
54     string public name;                   // Token Name
55     uint8 public decimals;                // How many decimals the token has
56     string public symbol;                 // Token identifier
57     uint256 public tokensPerEth;          // How many tokens purchased per eth in ICO
58     uint256 public totalEthInWei;         // Total ethereum raised in ICO (in Wei)  
59     address public fundsWallet;           // Wallet which manages the contract
60     uint public startTime;                // Start time of the ICO
61     bool public tokenReleased;
62     uint256 public totalDividends;
63     mapping (address => uint256) public lastDividends;
64     event TokensSold(address Buyer, uint256 Qty);
65     
66     function FairDinkums() public {
67         balances[msg.sender] = 20000 * 1e18;    // 20'000 max for ICO participants
68         totalSupply = 20000 * 1e18;             // 20'000 max for ICO participants
69         name = "Fair Dinkums";                  // Fair Dinkums Token
70         decimals = 18;                          // Same as eth, 18.
71         symbol = "FDK";                         // Fair Dinkums Token => FDK
72         tokensPerEth = 1000;                    // Tokens per eth during ICO
73         fundsWallet = msg.sender;               // The owner of the contract gets the ETH to manage
74         startTime = now;                        // ICO will run for two weeks from initialisation
75         tokenReleased = false;                  // Tokens will be released after two weeks or end of ICO as chosen by contract manager
76     }
77 
78     function() public payable {
79         // The callback function serves two purposes:
80         //   1) to receive eth as a contribution during the ICO, and
81         //   2) to collect dividends after the ICO
82         // Using this pattern allows people to interact with the contract without any special API's
83         if (icoOpen()){
84             // If the ICO is still open, then we add the token balance to the contributor
85             require(msg.value > 0 && msg.value <= 20 ether);
86             totalEthInWei = totalEthInWei + msg.value;
87             uint256 amount = msg.value * tokensPerEth;
88             if ((balances[fundsWallet]) < amount) {
89                 revert();
90             }
91             TokensSold(msg.sender,amount);
92             balances[fundsWallet] = balances[fundsWallet] - amount;
93             balances[msg.sender] = balances[msg.sender] + amount;
94     
95             Transfer(fundsWallet, msg.sender, amount);
96     
97             fundsWallet.transfer(msg.value);
98         } else {
99             // If the ico is over, then the value must be zero and the updateDivs function will be called.
100             require(msg.value==0);
101             updateDivs(msg.sender,dividendsOwing(msg.sender));
102         }
103     }
104 
105     function transfer(address _to, uint256 _value) public released returns (bool success) {
106         // Record previous dividendsOwing information before transferring tokens
107         uint256 init_from = dividendsOwing(msg.sender);
108         uint256 init_to = dividendsOwing(_to);
109         // Transfer Tokens
110         require(super.transfer(_to,_value));
111         // If the transfer was successful, then update dividends as per dividendsOwing from before the transfer
112         updateDivs(msg.sender,init_from);
113         updateDivs(_to,init_to);
114         // Return success flag
115         return true;
116     }
117 
118     function icoOpen() public view returns (bool open) {
119         // ICO will be open for the sooner of 2 weeks or the token is declared released by the manager
120         return ((now < (startTime + 4 weeks)) && !tokenReleased);
121     }
122     
123     modifier released {
124         require(tokenReleased);
125         _;
126     }
127     
128     modifier isOwner {
129         require(msg.sender == fundsWallet);
130         _;
131     }
132 
133     function dividendsOwing(address _who) public view returns(uint256 owed) {
134         // Concise function to determine the amount of dividends owed to a token holder.
135         // Susceptible to small rounding errors which will be lost until the token is destroyed
136         if (totalDividends > lastDividends[_who]){
137             uint256 newDividends = totalDividends - lastDividends[_who];
138             return ((balances[_who] * newDividends) / totalSupply);
139         } else {
140             return 0;
141         }
142     }
143     
144     function updateDivs(address _who, uint256 _owing) internal {
145         if (_owing > 0){
146             if(_owing<=this.balance){
147                 _who.transfer(_owing);
148             } else {
149                 _who.transfer(this.balance);
150             }
151         }
152         lastDividends[_who] = totalDividends;
153     }
154     
155     function remainingTokens() public view returns(uint256 remaining){
156         return balances[fundsWallet];
157     }
158     
159     function releaseToken() public isOwner {
160         require(!tokenReleased);
161         tokenReleased = true;
162         // Burns unsold tokens
163         totalSupply -= balances[fundsWallet];
164         balances[fundsWallet] = 0;
165     }
166     
167     function payDividends() public payable isOwner {
168         totalDividends += msg.value;
169     }
170     
171     function withdrawDividends() public {
172         updateDivs(msg.sender,dividendsOwing(msg.sender));
173     }
174 }