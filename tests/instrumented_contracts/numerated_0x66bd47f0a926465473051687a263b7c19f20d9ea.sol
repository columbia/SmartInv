1 pragma solidity ^0.4.18;
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
45 contract Token{
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
85     using SafeMath for uint256;
86 
87     function transfer(address _to, uint256 _value) returns (bool success) {
88         //Default assumes totalSupply can't be over max (2^256 - 1).
89         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
90         //Replace the if with this one instead.
91         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
92         if (balances[msg.sender] >= _value && _value > 0) {
93             balances[msg.sender]=balances[msg.sender].sub(_value);
94             balances[_to]=balances[_to].add(_value);
95             Transfer(msg.sender, _to, _value);
96             return true;
97         } else { return false; }
98     }
99 
100     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
101         //same as above. Replace this line with the following if you want to protect against wrapping uints.
102         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
103         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
104             balances[_to] = balances[_to].add(_value);
105             balances[_from] = balances[_from].sub(_value);
106             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
107             Transfer(_from, _to, _value);
108             return true;
109         } else { return false; }
110     }
111 
112     function balanceOf(address _owner) constant returns (uint256 balance) {
113         return balances[_owner];
114     }
115 
116     function approve(address _spender, uint256 _value) returns (bool success) {
117         allowed[msg.sender][_spender] = _value;
118         Approval(msg.sender, _spender, _value);
119         return true;
120     }
121 
122     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
123       return allowed[_owner][_spender];
124     }
125 
126     mapping (address => uint256) balances;
127     mapping (address => mapping (address => uint256)) allowed;
128     uint256 public totalSupply;
129 }
130 
131 contract GoldCoins is StandardToken { // CHANGE THIS. Update the contract name.
132 
133     /* Public variables of the token */
134 
135     /*
136     NOTE:
137     The following variables are OPTIONAL vanities. One does not have to include them.
138     They allow one to customise the token contract & in no way influences the core functionality.
139     Some wallets/interfaces might not even bother to look at this information.
140     */
141     string public name;                   // Token Name
142     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
143     string public symbol;                 // An identifier: eg SBX, XPR etc..
144     string public version = 'H1.0'; 
145     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
146     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
147     address public fundsWallet;           // Where should the raised ETH go?
148 
149     // This is a constructor function 
150     // which means the following function name has to match the contract name declared above
151     function GoldCoins() {
152         balances[msg.sender] = 1000000000000000000000000;               
153         totalSupply = 1000000000000000000000000;                        
154         name = "SuperMario Coins";                                   
155         decimals = 18;                                               
156         symbol = "SMC";                                             
157         unitsOneEthCanBuy = 1000;                                      
158         fundsWallet = msg.sender;                                    
159     }
160 
161     function() payable{
162         totalEthInWei = totalEthInWei.add(msg.value);
163         uint256 amount = msg.value.mul(unitsOneEthCanBuy);
164         if (balances[fundsWallet] < amount) {
165             return;
166         }
167 
168         balances[fundsWallet] = balances[fundsWallet].sub(amount);
169         balances[msg.sender] = balances[msg.sender].add(amount);
170 
171         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
172 
173         //Transfer ether to fundsWallet
174         fundsWallet.transfer(msg.value);                               
175     }
176 
177     /* Approves and then calls the receiving contract */
178     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
179         allowed[msg.sender][_spender] = _value;
180         Approval(msg.sender, _spender, _value);
181 
182         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
183         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
184         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
185         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
186         return true;
187     }
188 }
189 
190 //created by jb