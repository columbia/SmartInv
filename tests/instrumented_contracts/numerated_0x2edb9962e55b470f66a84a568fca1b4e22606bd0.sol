1 pragma solidity ^0.4.24;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() constant returns (uint256 supply) {}
7     
8 
9     /// @param _owner The address from which the balance will be retrieved
10     /// @return The balance
11     function balanceOf(address _owner) constant returns (uint256 balance) {}
12 
13     /// @notice send `_value` token to `_to` from `msg.sender`
14     /// @param _to The address of the recipient
15     /// @param _value The amount of token to be transferred
16     /// @return Whether the transfer was successful or not
17     function transfer(address _to, uint256 _value) returns (bool success) {}
18 
19 
20 
21     event Transfer(address indexed _from, address indexed _to, uint256 _value);
22 
23 }
24 
25 contract StandardToken is Token {
26 
27     function transfer(address _to, uint256 _value) returns (bool success) {
28         //Default assumes totalSupply can't be over max (2^256 - 1).
29         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
30         //Replace the if with this one instead.
31         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
32         if (balances[msg.sender] >= _value && _value > 0) {
33             balances[msg.sender] -= _value;
34             balances[_to] += _value;
35             Transfer(msg.sender, _to, _value);
36             return true;
37         } else { return false; }
38     }
39 
40 
41     function balanceOf(address _owner) constant returns (uint256 balance) {
42         return balances[_owner];
43     }
44 
45 
46     mapping (address => uint256) balances;
47     mapping (address => mapping (address => uint256)) allowed;
48     uint256 public totalSupply;
49 }
50 
51 contract Plumix is StandardToken { 
52 
53     /* Public variables of the token */
54 
55    
56     string public name;                   
57     uint8 public decimals;                
58     string public symbol;                 
59     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
60     uint256 public minSales;                 // Minimum amount to be bought (0.01ETH)
61     uint256 public totalEthInWei;         
62     address internal fundsWallet;           
63     uint256 public airDropBal;
64     uint256 public icoSales;
65     uint256 public icoSalesBal;
66     uint256 public icoSalesCount;
67     bool public distributionClosed;
68 
69     
70     modifier canDistr() {
71         require(!distributionClosed);
72         _;
73     }
74     
75     address owner = msg.sender;
76     
77      modifier onlyOwner() {
78         require(msg.sender == owner);
79         _;
80     }
81     
82     
83     event Airdrop(address indexed _owner, uint _amount, uint _balance);
84     event DistrClosed();
85     event DistrStarted();
86     event Burn(address indexed burner, uint256 value);
87     
88     
89     function endDistribution() onlyOwner canDistr public returns (bool) {
90         distributionClosed = true;
91         emit DistrClosed();
92         return true;
93     }
94     
95     function startDistribution() onlyOwner public returns (bool) {
96         distributionClosed = false;
97         emit DistrStarted();
98         return true;
99     }
100     
101 
102     function Plumix() {
103         balances[msg.sender] = 10000000000e18;               
104         totalSupply = 10000000000e18;                        
105         airDropBal = 1500000000e18;
106         icoSales = 5000000000e18;
107         icoSalesBal = 5000000000e18;
108         name = "Plumix";                                   
109         decimals = 18;                                               
110         symbol = "PLXT";                                             
111         unitsOneEthCanBuy = 10000000;
112         minSales = 1 ether / 100; // 0.01ETH
113         icoSalesCount = 0;
114         fundsWallet = msg.sender;                                   
115         distributionClosed = true;
116         
117     }
118 
119     function() public canDistr payable{
120         totalEthInWei = totalEthInWei + msg.value;
121         uint256 amount = msg.value * unitsOneEthCanBuy;
122         require(msg.value >= minSales);
123         require(amount <= icoSalesBal);
124         
125 
126         balances[fundsWallet] = balances[fundsWallet] - amount;
127         balances[msg.sender] = balances[msg.sender] + amount;
128 
129         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
130 
131         
132         fundsWallet.transfer(msg.value);
133         
134         icoSalesCount = icoSalesCount + amount;
135         icoSalesBal = icoSalesBal - amount;
136         if (icoSalesCount >= icoSales) {
137             distributionClosed = true;
138         }
139     }
140     
141     
142  function doAirdrop(address _participant, uint _amount) internal {
143 
144         require( _amount > 0 );      
145 
146         require( _amount <= airDropBal );
147         
148         balances[_participant] = balances[_participant] + _amount;
149         airDropBal = airDropBal - _amount ;
150      
151      // Airdrop log
152     emit Airdrop(_participant, _amount, balances[_participant]);  
153      }
154      
155      
156          function adminClaimAirdrop(address _participant, uint _amount) public onlyOwner {        
157         doAirdrop(_participant, _amount);
158     }
159 
160     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
161         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
162     }
163      
164     
165     function burn(uint256 _value) onlyOwner public {
166         require(_value <= balances[msg.sender]);
167 
168 
169         address burner = msg.sender;
170         balances[burner] = balances[burner] - _value;
171         totalSupply = totalSupply - _value;
172         emit Burn(burner, _value);
173     }
174 
175 }