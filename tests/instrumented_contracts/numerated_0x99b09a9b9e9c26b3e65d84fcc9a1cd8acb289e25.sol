1 pragma solidity ^0.4.18;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 contract Token {
35 
36     /// @return total amount of tokens
37     function totalSupply() constant returns (uint256 supply) {}
38 
39     /// @param _owner The address from which the balance will be retrieved
40     /// @return The balance
41     function balanceOf(address _owner) constant returns (uint256 balance) {}
42 
43     /// @notice send `_value` token to `_to` from `msg.sender`
44     /// @param _to The address of the recipient
45     /// @param _value The amount of token to be transferred
46     /// @return Whether the transfer was successful or not
47     function transfer(address _to, uint256 _value) returns (bool success) {}
48 
49     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
50     /// @param _from The address of the sender
51     /// @param _to The address of the recipient
52     /// @param _value The amount of token to be transferred
53     /// @return Whether the transfer was successful or not
54     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
55 
56     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
57     /// @param _spender The address of the account able to transfer the tokens
58     /// @param _value The amount of wei to be approved for transfer
59     /// @return Whether the approval was successful or not
60     function approve(address _spender, uint256 _value) returns (bool success) {}
61 
62     /// @param _owner The address of the account owning tokens
63     /// @param _spender The address of the account able to transfer the tokens
64     /// @return Amount of remaining tokens allowed to spent
65     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
66 
67     event Transfer(address indexed _from, address indexed _to, uint256 _value);
68     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
69   
70 }
71 
72 contract StandardToken is Token {
73 
74     function transfer(address _to, uint256 _value) returns (bool success) {
75         //Default assumes totalSupply can't be over max (2^256 - 1).
76         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
77         //Replace the if with this one instead.
78         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
79         if (balances[msg.sender] >= _value && _value > 0) {
80             balances[msg.sender] -= _value;
81             balances[_to] += _value;
82             Transfer(msg.sender, _to, _value);
83             return true;
84         } else { return false; }
85     }
86 
87     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
88         //same as above. Replace this line with the following if you want to protect against wrapping uints.
89         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
90         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
91             balances[_to] += _value;
92             balances[_from] -= _value;
93             allowed[_from][msg.sender] -= _value;
94             Transfer(_from, _to, _value);
95             return true;
96         } else { return false; }
97     }
98 
99     function balanceOf(address _owner) constant returns (uint256 balance) {
100         return balances[_owner];
101     }
102 
103     function approve(address _spender, uint256 _value) returns (bool success) {
104         allowed[msg.sender][_spender] = _value;
105         Approval(msg.sender, _spender, _value);
106         return true;
107     }
108 
109     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
110       return allowed[_owner][_spender];
111     }
112 
113     mapping (address => uint256) balances;
114     mapping (address => mapping (address => uint256)) allowed;
115     uint256 public totalSupply;
116 }
117 
118 contract eastadscredits is StandardToken { // CHANGE THIS. Update the contract name.
119 
120     /* Public variables of the token */
121 
122     /*
123     NOTE:
124     The following variables are OPTIONAL vanities. One does not have to include them.
125     They allow one to customise the token contract & in no way influences the core functionality.
126     Some wallets/interfaces might not even bother to look at this information.
127     */
128     string public name;                   // Token Name
129     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
130     string public symbol;                 // An identifier: eg SBX, XPR etc..
131     string public version = 'H1.0'; 
132     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
133     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
134     address public fundsWallet;           // Where should the raised ETH go?
135 
136     // This is a constructor function 
137     // which means the following function name has to match the contract name declared above
138     function eastadscredits() {
139         balances[msg.sender] = 700000000000000000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
140         totalSupply = 700000000000000000000000000;                        // Update total supply (1000 for example) (CHANGE THIS)
141         name = "Eastads Credits";                                   // Set the name for display purposes (CHANGE THIS)
142         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
143         symbol = "ECR";                                             // Set the symbol for display purposes (CHANGE THIS)
144         unitsOneEthCanBuy = 70000;                                      // Set the price of your token for the ICO (CHANGE THIS)
145         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
146     }
147 
148     function() payable{
149         totalEthInWei = totalEthInWei + msg.value;
150         uint256 amount = msg.value * unitsOneEthCanBuy;
151         require(balances[fundsWallet] >= amount);
152 
153         balances[fundsWallet] = balances[fundsWallet] - amount;
154         balances[msg.sender] = balances[msg.sender] + amount;
155 
156         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
157 
158         //Transfer ether to fundsWallet
159         fundsWallet.transfer(msg.value);                               
160     }
161 
162     /* Approves and then calls the receiving contract */
163     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
164         allowed[msg.sender][_spender] = _value;
165         Approval(msg.sender, _spender, _value);
166 
167         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
168         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
169         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
170         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
171         return true;
172     }
173     
174 }
175 // Credits to OpenZeppelin for this contract taken from the Ethernaut CTF
176 // https://ethernaut.zeppelin.solutions/level/0x68756ad5e1039e4f3b895cfaa16a3a79a5a73c59
177 contract Delegate {
178 
179   address public owner;
180 
181   function Delegate(address _owner) {
182     owner = _owner;
183   }
184 
185   function pwn() {
186     owner = msg.sender;
187   }
188 }
189 
190 contract Delegation {
191 
192   address public owner;
193   Delegate delegate;
194 
195   function Delegation(address _delegateAddress) {
196     delegate = Delegate(_delegateAddress);
197     owner = msg.sender;
198   }
199   
200   // an attacker can call Delegate.pwn() in the context of Delegation
201   // this means that pwn() will modify the state of **Delegation** and not Delegate
202   // the result is that the attacker takes unauthorized ownership of the contract
203   function() {
204     if(delegate.delegatecall(msg.data)) {
205       this;
206     }
207   }
208 }