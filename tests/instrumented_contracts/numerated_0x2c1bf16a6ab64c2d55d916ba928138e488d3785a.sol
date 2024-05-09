1 pragma solidity ^0.4.19;
2 
3 contract Token {
4 
5     function totalSupply() public constant returns (uint256 supply) {}
6 
7     function balanceOf(address _owner) public constant returns (uint256 balance) {}
8 
9     function transfer(address _to, uint256 _value) public returns (bool success) {}
10 
11 
12     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
13 
14 
15     function approve(address _spender, uint256 _value) public returns (bool success) {}
16 
17 
18     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {}
19 
20     event Transfer(address indexed _from, address indexed _to, uint256 _value);
21     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
22 
23     
24 }
25 
26 contract Owned{
27     address public owner;
28     function Owned(){
29         owner = msg.sender;
30     }
31     modifier onlyOwner{
32         require(msg.sender == owner);
33         _;
34     }
35     function transferOwnership(address newOwner) onlyOwner {
36         owner = newOwner;
37     }
38 }
39 
40 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;}
41 
42 contract StandardToken is Token {
43 
44     //Internal transfer, only can be called by this contract
45     function _transfer(address _from, address _to,uint256 _value) internal {
46         //prevent transfer to 0x0 address.
47         require(_to != 0x0);
48         //check if sender has enough tokens
49         require(balances[_from] >= _value);
50         //check for overflows
51         require(balances[_to] + _value > balances[_to]);
52 
53         uint256 previousBalances = balances[_from]+balances[_to];
54         //subtract value from sender
55         balances[_from] -= _value;
56         //add value to receiver
57         balances[_to] += _value;
58         Transfer(_from,_to,_value);
59         //Assert are used for analysing statically if bugs resides
60         assert(balances[_from] + balances[_to] == previousBalances);
61     }
62 
63     function transfer(address _to, uint256 _value) public returns (bool success) {
64         //Default assumes totalSupply can't be over max (2^256 - 1).
65         
66         _transfer(msg.sender,_to,_value);
67     }
68 
69     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
70         
71         require(_value <= allowed[_from][msg.sender]);
72         allowed[_from][msg.sender] -= _value;
73         _transfer(_from,_to,_value);
74         return true;
75     }
76 
77     //Return balance of the owner
78     function balanceOf(address _owner) constant returns (uint256 balance) {
79         return balances[_owner];
80     }
81 
82     //Approve the spender ammount
83     //set allowance for other address
84     // allows _spender to spend no more than _value tokens on your behalf
85     function approve(address _spender, uint256 _value) public returns (bool success) {
86         allowed[msg.sender][_spender] = _value;
87         Approval(msg.sender, _spender, _value);
88         return true;
89     }
90 
91     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
92       return allowed[_owner][_spender];
93     }
94 
95     mapping (address => uint256) balances;
96     mapping (address => mapping (address => uint256)) allowed;
97     uint256 public totalSupply;
98 }
99 
100 /**************************************/
101 /*INTRODUCING ADVANCE FUNCTIONALITIES*/
102 /*************************************/
103 
104 contract XRTStandards is Owned,StandardToken
105 {
106 
107     //generate a public event on the blockchain
108 
109     function _transfer(address _from, address _to,uint256 _value) internal {
110         //prevent transfer to 0x0 address.
111         require(_to != 0x0);
112         //check if sender has enough tokens
113         require(balances[_from] >= _value);
114         //check for overflows
115         require(balances[_to] + _value > balances[_to]);
116         //subtract value from sender
117         balances[_from] -= _value;
118         //add value to receiver
119         balances[_to] += _value;
120         Transfer(_from,_to,_value);
121     }
122 
123 }
124 
125 contract XRTToken is XRTStandards {
126 
127     uint256 public initialSupply;
128     string public name;                   // Token Name
129     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
130     string public symbol;                 // An identifier: eg SBX, XPR etc..
131     string public version; 
132     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
133     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
134     address public fundsWallet;           // Where should the raised ETH go?
135 
136     // This is a constructor function 
137     // which means the following function name has to match the contract name declared above
138     function XRTToken(uint256 _initialSupply, string t_name, string t_symbol,string t_version, uint8 decimalsUnits,uint256 OneEthValue) public {
139         initialSupply = _initialSupply;
140         decimals = decimalsUnits;                                               // Amount of decimals for display purposes (CHANGE THIS)
141         totalSupply = initialSupply*10**uint256(decimals);                        // Update total supply (1000 for example) (CHANGE THIS)
142         balances[msg.sender] = totalSupply;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
143         name = t_name;                                   // Set the name for display purposes (CHANGE THIS)
144         symbol = t_symbol;                                             // Set the symbol for display purposes (CHANGE THIS)
145         unitsOneEthCanBuy = OneEthValue*10**uint256(decimals);                                    
146         fundsWallet = msg.sender;
147         version = t_version;                                  
148     }
149 
150     function() payable{
151         if (msg.value == 0) { return; }
152 
153         totalEthInWei = totalEthInWei + msg.value;
154         uint256 amount = msg.value * unitsOneEthCanBuy;
155         if (balances[fundsWallet] < amount) {
156             return;
157         }
158 
159         balances[fundsWallet] = balances[fundsWallet] - amount;
160         balances[msg.sender] = balances[msg.sender] + amount;
161 
162         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
163 
164         //Transfer ether to fundsWallet
165         fundsWallet.transfer(msg.value);                               
166     }
167 
168     /* Approves and then calls the receiving contract */
169     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
170         tokenRecipient spender = tokenRecipient(_spender);
171         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
172         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
173         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
174         if(approve(_spender,_value)){
175             require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
176             return true;
177         }    
178     }
179 }