1 pragma solidity ^0.4.18;
2 
3 contract Owned {
4     address public owner;
5     modifier onlyOwner() {
6         require(msg.sender == owner);
7         _;
8     }
9     
10     function Owned() public{
11         owner = msg.sender;
12     }
13     
14     function changeOwner(address _newOwner) public onlyOwner {
15         owner = _newOwner;
16     }
17 }
18 
19 
20 contract tokenRecipient { 
21   function receiveApproval (address _from, uint256 _value, address _token, bytes _extraData) public;
22 }
23 
24 contract ERC20Token {
25 
26     uint256 public totalSupply;
27     function balanceOf(address _owner) public constant returns (uint256 balance);
28     function transfer(address _to, uint256 _value) public returns (bool success);
29     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
30     function approve(address _spender, uint256 _value) public returns (bool success);
31     function allowance(address _owner, address _spender) public constant  returns (uint256 remaining);
32 
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35 }
36 
37 contract DASABI_IO_Contract is ERC20Token, Owned{
38 
39     /* Public variables of the token */
40     string  public constant name = "dasabi.io SBI";
41     string  public constant symbol = "SBI";
42     uint256 public constant decimals = 18;
43     uint256 private constant etherChange = 10**18;
44     
45     /* Variables of the token */
46     uint256 public totalSupply;
47     uint256 public totalRemainSupply;
48     uint256 public ExchangeRate;
49     
50     uint256 public CandyRate;
51     
52     bool    public crowdsaleIsOpen;
53     bool    public CandyDropIsOpen;
54     mapping (address => uint256) balances;
55     mapping (address => mapping (address => uint256)) allowances;
56     mapping (address => bool) public blacklist;
57     
58     address public multisigAddress;
59     /* Events */
60     event mintToken(address indexed _to, uint256 _value);
61     event burnToken(address indexed _from, uint256 _value);
62     
63     function () payable public {
64         require (crowdsaleIsOpen == true);
65               
66         
67         if (msg.value > 0) {
68         	mintSBIToken(msg.sender, (msg.value * ExchangeRate * 10**decimals) / etherChange);
69         }
70         
71         if(CandyDropIsOpen){
72 	        if(!blacklist[msg.sender]){
73 		        mintSBIToken(msg.sender, CandyRate * 10**decimals);
74 		        blacklist[msg.sender] = true;
75 		    }
76 	    }
77     }
78     /* Initializes contract and  sets restricted addresses */
79     function DASABI_IO_Contract() public {
80         owner = msg.sender;
81         totalSupply = 1000000000 * 10**decimals;
82         ExchangeRate = 50000;
83         CandyRate = 50;
84         totalRemainSupply = totalSupply;
85         crowdsaleIsOpen = true;
86         CandyDropIsOpen = true;
87     }
88     
89     function setExchangeRate(uint256 _ExchangeRate) public onlyOwner {
90         ExchangeRate = _ExchangeRate;
91     }
92     
93     function crowdsaleOpen(bool _crowdsaleIsOpen) public onlyOwner{
94         crowdsaleIsOpen = _crowdsaleIsOpen;
95     }
96     
97     function CandyDropOpen(bool _CandyDropIsOpen) public onlyOwner{
98         CandyDropIsOpen = _CandyDropIsOpen;
99     }
100     
101     /* Returns total supply of issued tokens */
102     function totalDistributed() public constant returns (uint256)  {   
103         return totalSupply - totalRemainSupply ;
104     }
105 
106     /* Returns balance of address */
107     function balanceOf(address _owner) public constant returns (uint256 balance) {
108         return balances[_owner];
109     }
110 
111     /* Transfers tokens from your address to other */
112     function transfer(address _to, uint256 _value) public returns (bool success) {
113         require (balances[msg.sender] >= _value);            // Throw if sender has insufficient balance
114         require (balances[_to] + _value > balances[_to]);   // Throw if owerflow detected
115         balances[msg.sender] -= _value;                     // Deduct senders balance
116         balances[_to] += _value;                            // Add recivers blaance 
117         Transfer(msg.sender, _to, _value);                  // Raise Transfer event
118         return true;
119     }
120 
121     /* Approve other address to spend tokens on your account */
122     function approve(address _spender, uint256 _value) public returns (bool success) {
123         allowances[msg.sender][_spender] = _value;          // Set allowance         
124         Approval(msg.sender, _spender, _value);             // Raise Approval event         
125         return true;
126     }
127 
128     /* Approve and then communicate the approved contract in a single tx */ 
129     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {            
130         tokenRecipient spender = tokenRecipient(_spender);              // Cast spender to tokenRecipient contract         
131         approve(_spender, _value);                                      // Set approval to contract for _value         
132         spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract         
133         return true;     
134     }     
135 
136     /* A contract attempts to get the coins */
137     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {      
138         require (balances[_from] > _value);                // Throw if sender does not have enough balance     
139         require (balances[_to] + _value > balances[_to]);  // Throw if overflow detected    
140         require (_value <= allowances[_from][msg.sender]);  // Throw if you do not have allowance       
141         balances[_from] -= _value;                          // Deduct senders balance    
142         balances[_to] += _value;                            // Add recipient blaance         
143         allowances[_from][msg.sender] -= _value;            // Deduct allowance for this address         
144         Transfer(_from, _to, _value);                       // Raise Transfer event
145         return true;     
146     }         
147 
148     /* Get the amount of allowed tokens to spend */     
149     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {         
150         return allowances[_owner][_spender];
151     }     
152         
153     /*withdraw Ether to a multisig address*/
154     function withdraw(address _multisigAddress) public onlyOwner {    
155         require(_multisigAddress != 0x0);
156         multisigAddress = _multisigAddress;
157         multisigAddress.transfer(this.balance);
158     }  
159     
160     /* Issue new tokens */     
161     function mintSBIToken(address _to, uint256 _amount) internal { 
162         require (balances[_to] + _amount > balances[_to]);      // Check for overflows
163         require (totalRemainSupply > _amount);
164         totalRemainSupply -= _amount;                           // Update total supply
165         balances[_to] += _amount;                               // Set minted coins to target
166         mintToken(_to, _amount);                                // Create Mint event       
167         Transfer(0x0, _to, _amount);                            // Create Transfer event from 0x
168     }  
169     
170     function mintTokens(address _sendTo, uint256 _sendAmount)public onlyOwner {
171         mintSBIToken(_sendTo, _sendAmount);
172     }
173     
174     /* Destroy tokens from owners account */
175     function burnTokens(uint256 _amount)public onlyOwner {
176         require (balances[msg.sender] > _amount);               // Throw if you do not have enough balance
177         totalRemainSupply += _amount;                           // Deduct totalSupply
178         balances[msg.sender] -= _amount;                             // Destroy coins on senders wallet
179         burnToken(msg.sender, _amount);                              // Raise Burn event
180     }
181 }