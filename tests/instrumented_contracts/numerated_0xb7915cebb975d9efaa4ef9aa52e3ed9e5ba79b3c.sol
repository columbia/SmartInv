1 pragma solidity ^0.4.25;
2 
3 
4 //   token smart contract for trade nex
5 
6 //   This is a test contract for tradex coin
7 //		code is written by Muyiwa O. Samson
8 //		copy right : Muyiwa Samson
9 //  
10 //
11 
12 contract Token {
13 
14     ///CORE FUNCTIONS; these are standard functions that enables any token to function as a token
15     function totalSupply() constant returns (uint256 supply) {}										/// this function calls the total token supply in the contract
16 
17     function balanceOf(address _owner) constant returns (uint256 balance) {}						/// Function that is able to call all token balance of any specified contract address holding this token
18 
19     function transfer(address _to, uint256 _value) returns (bool success) {}						/// Function that enables token transfer
20 
21     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}  	/// Function that impliments the transfer of tokens by token holders to other ERC20 COMPLIENT WALLETS 
22 
23     function approve(address _spender, uint256 _value) returns (bool success) {}
24 
25     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}	/// Returns the values for token balances into contract record
26 
27     
28 	//CONTRACT EVENTS
29 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
30     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
31 
32 }
33 
34 contract StandardToken is Token {
35 
36     function transfer(address _to, uint256 _value) returns (bool success) {
37         
38         if (balances[msg.sender] >= _value && _value > 0) {
39             balances[msg.sender] -= _value;
40             balances[_to] += _value;
41             Transfer(msg.sender, _to, _value);
42             return true;
43         } else { return false; }
44     }
45 
46     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
47         
48         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
49             balances[_to] += _value;
50             balances[_from] -= _value;
51             allowed[_from][msg.sender] -= _value;
52             Transfer(_from, _to, _value);
53             return true;
54         } else { return false; }
55     }
56 
57     function balanceOf(address _owner) constant returns (uint256 balance) {
58         return balances[_owner];
59     }
60 
61     function approve(address _spender, uint256 _value) returns (bool success) {
62         allowed[msg.sender][_spender] = _value;
63         Approval(msg.sender, _spender, _value);
64         return true;
65     }
66 
67     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
68       return allowed[_owner][_spender];
69     }
70 
71     mapping (address => uint256) balances;
72     mapping (address => mapping (address => uint256)) allowed;
73     uint256 public totalSupply;
74 }
75 
76 contract Tradenexi is StandardToken { 
77 
78    
79     string public name;                   // Token Name
80     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
81     string public symbol;                 // An identifier: eg SBX, XPR etc..
82     uint256 public exchangeRate;         // How many units of your coin can be bought by 1 ETH? unitsOneEthCanBuy now etherexchange
83     address public icoWallet;           // Where should the raised ETH go?
84 
85     
86 
87 	address public creator;
88 	
89 	bool public isFunding;
90 
91     // This is a constructor function 
92     // which means the following function name has to match the contract name declared above
93     function Tradenexi() {
94         balances[msg.sender] = 1000000000000000000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 1000000000000000000. (CHANGE THIS)
95         totalSupply = 1000000000000000000000000000;                        // Update total supply (1000 for example) (CHANGE THIS)
96         name = "Trade Nexi";                                   // Set the name for display purposes (CHANGE THIS)
97         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
98         symbol = "NEXI";                                             // Set the symbol for display purposes (CHANGE THIS)
99         icoWallet = msg.sender;                                    // The owner of the contract gets ETH
100 		creator = msg.sender;
101     }
102 	
103 	  
104     function updateRate(uint256 _rate) external {
105         require(msg.sender==creator);
106         require(isFunding);
107         exchangeRate = _rate;
108 		
109 	}
110 	
111 	
112 	function ChangeicoWallet(address EthWallet) external {
113         require(msg.sender==creator);
114         icoWallet = EthWallet;
115 		
116 	}
117 	function changeCreator(address _creator) external {
118         require(msg.sender==creator);
119         creator = _creator;
120     }
121 		
122 
123 	function openSale() external {
124 		require(msg.sender==creator);
125 		isFunding = true;
126     }
127 	
128 	function closeSale() external {
129 		require(msg.sender==creator);
130 		isFunding = false;
131     }	
132 	
133 	
134 		
135     function() payable {
136         require(msg.value >= (1 ether/50));
137         require(isFunding);
138         uint256 amount = msg.value * exchangeRate;
139 		      
140         balances[icoWallet] = balances[icoWallet] - amount;
141         balances[msg.sender] = balances[msg.sender] + amount;
142 
143         Transfer(icoWallet, msg.sender, amount); // Broadcast a message to the blockchain
144 
145         //Transfer ether to fundsWallet
146         icoWallet.transfer(msg.value);                               
147     }
148 	
149 
150     /* Approves and then calls the receiving contract */
151     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
152         allowed[msg.sender][_spender] = _value;
153         emit Approval(msg.sender, _spender, _value);
154 
155         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
156         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
157         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
158         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
159         return true;
160     }
161 }