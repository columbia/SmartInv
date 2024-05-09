1 /*
2 *	BitsumCash Ethereum Token -  2018
3 *	https://bitsumcash.org
4 *	Minimal request 0.001ETH
5 *	1ETH is equal to 1000000BSCH
6 */
7 
8 pragma solidity ^0.4.4;
9 
10 
11 contract Token {
12 
13     /// @return total amount of tokens
14     function totalSupply() constant returns (uint256 supply) {}
15 
16     /// @param _owner The address from which the balance will be retrieved
17     /// @return The balance
18     function balanceOf(address _owner) constant returns (uint256 balance) {}
19 
20     /// @notice send `_value` token to `_to` from `msg.sender`
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transfer(address _to, uint256 _value) returns (bool success) {}
25 
26     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
27     /// @param _from The address of the sender
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
32 
33     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @param _value The amount of wei to be approved for transfer
36     /// @return Whether the approval was successful or not
37     function approve(address _spender, uint256 _value) returns (bool success) {}
38 
39     /// @param _owner The address of the account owning tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @return Amount of remaining tokens allowed to spent
42     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
43 
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46     event Burn(address indexed from, uint256 value);
47 
48 }
49 
50 contract StandardToken is Token {
51 
52     function transfer(address _to, uint256 _value) returns (bool success){
53 		require(balances[msg.sender] >= _value && _value > 0);
54 		balances[msg.sender] -= _value;
55 		balances[_to] += _value;
56 		Transfer(msg.sender, _to, _value);
57 		return true;
58     }
59 
60     function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
61 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
62 		balances[_to] += _value;
63 		balances[_from] -= _value;
64 		allowed[_from][msg.sender] -= _value;
65 		Transfer(_from, _to, _value);
66 		return true;
67     }
68 
69     function balanceOf(address _owner) constant returns (uint256 balance) {
70         return balances[_owner];
71     }
72 
73     function approve(address _spender, uint256 _value) returns (bool success) {
74 		
75 		require((_value == 0) || (allowed[msg.sender][_spender] == 0));//To change _value amount first go to zero
76 		
77         allowed[msg.sender][_spender] = _value;
78         Approval(msg.sender, _spender, _value);
79         return true;
80     }
81 
82     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
83       return allowed[_owner][_spender];
84     }
85 
86     mapping (address => uint256) public balances;
87     mapping (address => mapping (address => uint256)) public allowed;
88 	
89 	uint256 public totalSupply;
90 
91 }
92 
93 contract BitsumCash is StandardToken { 
94 
95 
96     string public name;
97     uint8 public decimals;
98     string public symbol;
99     string public version = 'BSCH_Token_1.0'; 
100     uint256 public unitsOneEthCanBuy;
101     uint256 public totalEthInWei;
102     address public fundsWallet;
103 	
104 	uint256 public toWei = 1000000000000000000;
105 	uint256 public minimalPaymentInWei = 1000000000000000;//0.001ETH
106 
107 
108 	function BitsumCash() {
109 		decimals = 0;
110 		totalSupply = 17500000;
111         balances[msg.sender] = 17500000;
112         name = "BitsumCash";
113         symbol = "BSCH";
114         unitsOneEthCanBuy = 1000000;
115         fundsWallet = msg.sender;
116     }
117 
118     function() payable{
119         totalEthInWei = totalEthInWei + msg.value;
120         
121 		//Set minimal payment
122 		require(msg.value >= minimalPaymentInWei);
123 		
124 		uint256 amount = (msg.value * unitsOneEthCanBuy) / toWei;
125         require(balances[fundsWallet] >= amount);
126 
127         balances[fundsWallet] = balances[fundsWallet] - amount;
128         balances[msg.sender] = balances[msg.sender] + amount;
129 
130         Transfer(fundsWallet, msg.sender, amount);
131 
132         fundsWallet.transfer(msg.value);                               
133     }
134 
135     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
136         allowed[msg.sender][_spender] = _value;
137         Approval(msg.sender, _spender, _value);
138         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
139         return true;
140     }
141 	
142 	
143     /**
144      * Destroy tokens
145      *
146      * Remove `_value` tokens from the system irreversibly
147      *
148      * @param _value the amount of money to burn
149      */
150     function burn(uint256 _value) public returns (bool success) {
151         require(balances[msg.sender] >= _value);
152         balances[msg.sender] -= _value;
153         totalSupply -= _value;
154         emit Burn(msg.sender, _value);
155         return true;
156     }
157 
158     /**
159      * Destroy tokens from other account
160      *
161      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
162      *
163      * @param _from the address of the sender
164      * @param _value the amount of money to burn
165      */
166     function burnFrom(address _from, uint256 _value) public returns (bool success) {
167         require(balances[_from] >= _value);
168         require(_value <= allowed[_from][msg.sender]);
169         balances[_from] -= _value;
170         allowed[_from][msg.sender] -= _value;
171         totalSupply -= _value;
172         emit Burn(_from, _value);
173         return true;
174     }
175 	
176 }