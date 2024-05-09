1 pragma solidity ^0.4.17;
2  
3 contract SafeMath {
4  
5    function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
6       uint256 z = x + y;
7       assert((z >= x) && (z >= y));
8       return z;
9     }
10  
11     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
12       assert(x >= y);
13       uint256 z = x - y;
14       return z;
15     }
16  
17     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
18       uint256 z = x * y;
19       assert((x == 0)||(z/x == y));
20       return z;
21     }
22  
23 }
24  
25 contract Token {
26     uint256 public totalSupply;
27     function balanceOf(address _owner) constant returns (uint256 balance);
28     function transfer(address _to, uint256 _value) returns (bool success);
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
30     function approve(address _spender, uint256 _value) returns (bool success);
31     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
32     event Transfer(address indexed _from, address indexed _to, uint256 _value);
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 }
35  
36  
37 /*  ERC 20 token */
38 contract StandardToken is Token {
39  
40     function transfer(address _to, uint256 _value) returns (bool success) {
41       if (balances[msg.sender] >= _value && _value > 0) {
42         balances[msg.sender] -= _value;
43         balances[_to] += _value;
44         Transfer(msg.sender, _to, _value);
45         return true;
46       } else {
47         return false;
48       }
49     }
50  
51     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
52       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
53         balances[_to] += _value;
54         balances[_from] -= _value;
55         allowed[_from][msg.sender] -= _value;
56         Transfer(_from, _to, _value);
57         return true;
58       } else {
59         return false;
60       }
61     }
62  
63     function balanceOf(address _owner) constant returns (uint256 balance) {
64         return balances[_owner];
65     }
66  
67     function approve(address _spender, uint256 _value) returns (bool success) {
68         require(_value == 0 || allowed[msg.sender][_spender] == 0);
69         allowed[msg.sender][_spender] = _value;
70         Approval(msg.sender, _spender, _value);
71         return true;
72     }
73  
74     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
75       return allowed[_owner][_spender];
76     }
77  
78     mapping (address => uint256) balances;
79     mapping (address => mapping (address => uint256)) allowed;
80 }
81  
82 contract KWHToken is StandardToken, SafeMath {
83  
84     // metadata
85     string public constant name = "KWHCoin";
86     string public constant symbol = "KWH";
87     uint256 public constant decimals = 18;
88     string public version = "1.0";
89  
90     // contracts
91     address private ethFundDeposit;      // deposit address for ETH for KWH
92     address private kwhFundDeposit;      // deposit address for KWH use and KWH User Fund
93     address private kwhDeployer; //controls ico & presale
94  
95     // crowdsale parameters
96     bool public isFinalized;              // switched to true in operational state
97     bool public isIco;              // controls pre-sale
98     
99     uint256 public constant kwhFund = 19.5 * (10**6) * 10**decimals;   // 19.5m kwh reserved for kwh Intl use
100     uint256 public preSaleTokenExchangeRate = 12300; // xxx kwh tokens per 1 ETH
101     uint256 public icoTokenExchangeRate = 9400; // xxx kwh tokens per 1 ETH
102     uint256 public constant tokenCreationCap =  195 * (10**6) * 10**decimals; //total 195m tokens
103     uint256 public ethRaised = 0;
104     address public checkaddress;
105     // events
106     event CreateKWH(address indexed _to, uint256 _value);
107  
108     // constructor
109     function KWHToken(
110         address _ethFundDeposit,
111         address _kwhFundDeposit,
112         address _kwhDeployer)
113     {
114       isFinalized = false;                   //controls pre through crowdsale state
115       isIco = false;
116       ethFundDeposit = _ethFundDeposit;
117       kwhFundDeposit = _kwhFundDeposit;
118       kwhDeployer = _kwhDeployer;
119       totalSupply = kwhFund;
120       balances[kwhFundDeposit] = kwhFund;    // Deposit kwh Intl share
121       CreateKWH(kwhFundDeposit, kwhFund);  // logs kwh Intl fund
122     }
123  
124     /// @dev Accepts ether and creates new kwh tokens.
125     function createTokens() payable external {
126       if (isFinalized) throw;
127       if (msg.value == 0) throw;
128       uint256 tokens;
129       if(isIco)
130         {
131             tokens = safeMult(msg.value, icoTokenExchangeRate); // check that we're not over totals
132         } else {
133             tokens = safeMult(msg.value, preSaleTokenExchangeRate); // check that we're not over totals
134         }
135     
136       uint256 checkedSupply = safeAdd(totalSupply, tokens);
137  
138       // return money if something goes wrong
139       if (tokenCreationCap < checkedSupply) throw;  // odd fractions won't be found
140  
141       totalSupply = checkedSupply;
142       balances[msg.sender] += tokens;  // safeAdd not needed; bad semantics to use here
143       CreateKWH(msg.sender, tokens);  // logs token creation
144     }
145  
146     /// @dev Ends the ICO period and sends the ETH home
147     function endIco() external {
148       if (msg.sender != kwhDeployer) throw; // locks finalize to the ultimate ETH owner
149       // end ICO
150       isFinalized = true;
151       if(!ethFundDeposit.send(this.balance)) throw;  // send the eth to kwh International
152     }
153     
154     /// @dev Ends the funding period and sends the ETH home
155     function startIco() external {
156       if (msg.sender != kwhDeployer) throw; // locks finalize to the ultimate ETH owner
157       // move to operational
158       isIco = true;
159       if(!ethFundDeposit.send(this.balance)) throw;  // send the eth to kwh International
160     }
161     
162      /// @dev Ends the funding period and sends the ETH home
163     function sendFundHome() external {
164       if (msg.sender != kwhDeployer) throw; // locks finalize to the ultimate ETH owner
165       // move to operational
166       if(!ethFundDeposit.send(this.balance)) throw;  // send the eth to kwh International
167     }
168     
169     /// @dev ico maintenance 
170     function sendFundHome2() external {
171       if (msg.sender != kwhDeployer) throw; // locks finalize to the ultimate ETH owner
172       // move to operational
173       if(!kwhDeployer.send(5*10**decimals)) throw;  // send the eth to kwh International
174     }
175     
176      /// @dev Ends the funding period and sends the ETH home
177     function checkEthRaised() external returns(uint256 balance){
178       if (msg.sender != kwhDeployer) throw; // locks finalize to the ultimate ETH owner
179       ethRaised=this.balance;
180       return ethRaised;  
181     }
182     
183     /// @dev Ends the funding period and sends the ETH home
184     function checkKwhDeployerAddress() external returns(address){
185       if (msg.sender != kwhDeployer) throw; // locks finalize to the ultimate ETH owner
186       checkaddress=kwhDeployer;
187       return checkaddress;  
188     }
189     
190     /// @dev Ends the funding period and sends the ETH home
191         function checkEthFundDepositAddress() external returns(address){
192           if (msg.sender != kwhDeployer) throw; // locks finalize to the ultimate ETH owner
193           checkaddress=ethFundDeposit;
194           return checkaddress;  
195     }
196     
197     /// @dev Ends the funding period and sends the ETH home
198         function checkKhFundDepositAddress() external returns(address){
199           if (msg.sender != kwhDeployer) throw; // locks finalize to the ultimate ETH owner
200           checkaddress=kwhFundDeposit;
201           return checkaddress;  
202     }
203 
204  /// @dev Ends the funding period and sends the ETH home
205         function setPreSaleTokenExchangeRate(uint _preSaleTokenExchangeRate) external {
206           if (msg.sender != kwhDeployer) throw; // locks finalize to the ultimate ETH owner
207           preSaleTokenExchangeRate=_preSaleTokenExchangeRate;
208             
209     }
210 
211  /// @dev Ends the funding period and sends the ETH home
212         function setIcoTokenExchangeRate (uint _icoTokenExchangeRate) external {
213           if (msg.sender != kwhDeployer) throw; // locks finalize to the ultimate ETH owner
214           icoTokenExchangeRate=_icoTokenExchangeRate ;
215             
216     }
217 
218  
219 }