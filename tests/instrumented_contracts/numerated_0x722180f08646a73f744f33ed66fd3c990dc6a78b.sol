1 pragma solidity ^0.4.4;
2 
3 pragma solidity ^0.4.18;
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     //assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     //assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     //assert(c >= a);
35     return c;
36   }
37 }
38 
39 contract Token {
40 
41     /// @return total amount of tokens
42     function totalSupply() constant returns (uint256 supply) {}
43 
44     /// @param _owner The address from which the balance will be retrieved
45     /// @return The balance
46     function balanceOf(address _owner) constant returns (uint256 balance) {}
47 
48     /// @notice send `_value` token to `_to` from `msg.sender`
49     /// @param _to The address of the recipient
50     /// @param _value The amount of token to be transferred
51     /// @return Whether the transfer was successful or not
52     function transfer(address _to, uint256 _value) returns (bool success) {}
53 
54     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
55     /// @param _from The address of the sender
56     /// @param _to The address of the recipient
57     /// @param _value The amount of token to be transferred
58     /// @return Whether the transfer was successful or not
59     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
60 
61     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
62     /// @param _spender The address of the account able to transfer the tokens
63     /// @param _value The amount of wei to be approved for transfer
64     /// @return Whether the approval was successful or not
65     function approve(address _spender, uint256 _value) returns (bool success) {}
66 
67     /// @param _owner The address of the account owning tokens
68     /// @param _spender The address of the account able to transfer the tokens
69     /// @return Amount of remaining tokens allowed to spent
70     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
71 
72     event Transfer(address indexed _from, address indexed _to, uint256 _value);
73     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
74 
75 }
76 
77 contract StandardToken is Token {
78     
79     using SafeMath for uint256;
80 
81     function transfer(address _to, uint256 _value) returns (bool success) {
82         //Default assumes totalSupply can't be over max (2^256 - 1).
83         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
84         //Replace the if with this one instead.
85         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
86         if (balances[msg.sender] >= _value && _value > 0) {
87             balances[msg.sender] = balances[msg.sender].sub(_value);
88             balances[_to] = balances[_to].add(_value);
89             Transfer(msg.sender, _to, _value);
90             return true;
91         } else { 
92             return false;
93         }
94     }
95 
96     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
97         //same as above. Replace this line with the following if you want to protect against wrapping uints.
98         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
99         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
100             balances[_to] = balances[_to].add(_value);
101             balances[_from] = balances[_from].sub(_value);
102             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
103             Transfer(_from, _to, _value);
104             return true;
105         } else { return false; }
106     }
107 
108     function balanceOf(address _owner) constant returns (uint256 balance) {
109         return balances[_owner];
110     }
111 
112     function approve(address _spender, uint256 _value) returns (bool success) {
113         allowed[msg.sender][_spender] = _value;
114         Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
119       return allowed[_owner][_spender];
120     }
121 
122     mapping (address => uint256) balances;
123     mapping (address => mapping (address => uint256)) allowed;
124     uint256 public totalSupply;
125 }
126 
127 contract SnapToken is StandardToken { // CHANGE THIS. Update the contract name.
128 
129     using SafeMath for uint256;
130     /* Public variables of the token */
131 
132     /*
133     
134     NOTE:
135     The following variables are OPTIONAL vanities. One does not have to include them.
136     They allow one to customise the token contract & in no way influences the core functionality.
137     Some wallets/interfaces might not even bother to look at this information.
138     */
139     string public name;                   // Token Name
140     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
141     string public symbol;                 // An identifier: eg SBX, XPR etc..
142     string public version = 'H1.0';
143     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
144     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.
145     address public fundsWallet;           // Where should the raised ETH go?
146 
147     // This is a constructor function
148     // which means the following function name has to match the contract name declared above
149     function SnapToken() {
150         balances[msg.sender] = 200000000000000000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
151         totalSupply = 200000000000000000000000000;                        // Update total supply (1000 for example) (CHANGE THIS)
152         name = "SnapToken";                                   // Set the name for display purposes (CHANGE THIS)
153         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
154         symbol = "SNPT";                                             // Set the symbol for display purposes (CHANGE THIS)
155         unitsOneEthCanBuy = 25000;                                      // Set the price of your token for the ICO (CHANGE THIS)
156         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
157     }
158 
159     function() payable{
160         totalEthInWei = totalEthInWei.add(msg.value);
161         uint256 amount = msg.value.mul(unitsOneEthCanBuy);
162         if (balances[fundsWallet] < amount) {
163             fundsWallet.transfer(msg.value);
164             return;
165         }
166         
167         if (balances[fundsWallet] < 100000000) {
168             fundsWallet.transfer(msg.value);
169             return;
170         }
171 
172         balances[fundsWallet] = balances[fundsWallet].sub(amount);
173         balances[msg.sender] = balances[msg.sender].add(amount);
174 
175         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
176 
177         //Transfer ether to fundsWallet
178         fundsWallet.transfer(msg.value);
179     }
180 
181     /* Approves and then calls the receiving contract */
182     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
183         allowed[msg.sender][_spender] = _value;
184         Approval(msg.sender, _spender, _value);
185 
186         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
187         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
188         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
189         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
190         return true;
191     }
192 }