1 pragma solidity ^0.4.4;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Token {
46 
47     /// @return total amount of tokens
48     function totalSupply() constant returns (uint256 supply) {}
49 
50     /// @param _owner The address from which the balance will be retrieved
51     /// @return The balance
52     function balanceOf(address _owner) constant returns (uint256 balance) {}
53 
54     /// @notice send `_value` token to `_to` from `msg.sender`
55     /// @param _to The address of the recipient
56     /// @param _value The amount of token to be transferred
57     /// @return Whether the transfer was successful or not
58     function transfer(address _to, uint256 _value) returns (bool success) {}
59 
60     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
61     /// @param _from The address of the sender
62     /// @param _to The address of the recipient
63     /// @param _value The amount of token to be transferred
64     /// @return Whether the transfer was successful or not
65     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
66 
67     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
68     /// @param _spender The address of the account able to transfer the tokens
69     /// @param _value The amount of wei to be approved for transfer
70     /// @return Whether the approval was successful or not
71     function approve(address _spender, uint256 _value) returns (bool success) {}
72 
73     /// @param _owner The address of the account owning tokens
74     /// @param _spender The address of the account able to transfer the tokens
75     /// @return Amount of remaining tokens allowed to spent
76     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
77 
78     event Transfer(address indexed _from, address indexed _to, uint256 _value);
79     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
80 
81 }
82 
83 contract StandardToken is Token {
84 
85     function transfer(address _to, uint256 _value) returns (bool success) {
86         //Default assumes totalSupply can't be over max (2^256 - 1).
87         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
88         //Replace the if with this one instead.
89         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
90         if (balances[msg.sender] >= _value && _value > 0) {
91             balances[msg.sender] -= _value;
92             balances[_to] += _value;
93             Transfer(msg.sender, _to, _value);
94             return true;
95         } else { return false; }
96     }
97 
98     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
99         //same as above. Replace this line with the following if you want to protect against wrapping uints.
100         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
101         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
102             balances[_to] += _value;
103             balances[_from] -= _value;
104             allowed[_from][msg.sender] -= _value;
105             Transfer(_from, _to, _value);
106             return true;
107         } else { return false; }
108     }
109 
110     function balanceOf(address _owner) constant returns (uint256 balance) {
111         return balances[_owner];
112     }
113 
114     function approve(address _spender, uint256 _value) returns (bool success) {
115         allowed[msg.sender][_spender] = _value;
116         Approval(msg.sender, _spender, _value);
117         return true;
118     }
119 
120     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
121       return allowed[_owner][_spender];
122     }
123 
124     mapping (address => uint256) balances;
125     mapping (address => mapping (address => uint256)) allowed;
126     uint256 public totalSupply;
127 }
128 
129 contract PRBCoin is StandardToken { // CHANGE THIS. Update the contract name.
130 
131     /* Public variables of the token */
132 
133     /*
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
149     function PRBCoin() {
150         balances[msg.sender] = 500000000000000000000000000;          // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
151         totalSupply = 500000000000000000000000000;                      // Update total supply (1000 for example) (CHANGE THIS)
152         name = "PRBCoin";                                   // Set the name for display purposes (CHANGE THIS)
153         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
154         symbol = "PRB";                                             // Set the symbol for display purposes (CHANGE THIS)
155         unitsOneEthCanBuy = 1630;                                      // Set the price of your token for the ICO (CHANGE THIS)
156         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
157     }
158 
159     function() payable{
160         totalEthInWei = totalEthInWei + msg.value;
161         uint256 amount = msg.value * unitsOneEthCanBuy;
162         require(balances[fundsWallet] >= amount);
163 
164         balances[fundsWallet] = balances[fundsWallet] - amount;
165         balances[msg.sender] = balances[msg.sender] + amount;
166 
167         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
168 
169         //Transfer ether to fundsWallet
170         fundsWallet.transfer(msg.value);                               
171     }
172 
173     /* Approves and then calls the receiving contract */
174     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
175         allowed[msg.sender][_spender] = _value;
176         Approval(msg.sender, _spender, _value);
177 
178         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
179         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
180         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
181         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
182         return true;
183     }
184 }