1 pragma solidity ^0.4.4;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10  function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract owned {
30     address public owner;
31 
32     function owned() public {
33         owner = msg.sender;
34     }
35 
36     modifier onlyOwner {
37         require(msg.sender == owner);
38         _;
39     }
40 
41     function transferOwnership(address newOwner) onlyOwner public {
42         owner = newOwner;
43     }
44 }
45 
46 contract TokenERC20 {
47 
48     /// @return total amount of tokens
49     function totalSupply() constant returns (uint256 supply) {}
50 
51     /// @param _owner The address from which the balance will be retrieved
52     /// @return The balance
53     function balanceOf(address _owner) constant returns (uint256 balance) {}
54 
55     /// @notice send `_value` token to `_to` from `msg.sender`
56     /// @param _to The address of the recipient
57     /// @param _value The amount of token to be transferred
58     /// @return Whether the transfer was successful or not
59     function transfer(address _to, uint256 _value) returns (bool success) {}
60 
61     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
62     /// @param _from The address of the sender
63     /// @param _to The address of the recipient
64     /// @param _value The amount of token to be transferred
65     /// @return Whether the transfer was successful or not
66     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
67 
68     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
69     /// @param _spender The address of the account able to transfer the tokens
70     /// @param _value The amount of wei to be approved for transfer
71     /// @return Whether the approval was successful or not
72     function approve(address _spender, uint256 _value) returns (bool success) {}
73 
74     /// @param _owner The address of the account owning tokens
75     /// @param _spender The address of the account able to transfer the tokens
76     /// @return Amount of remaining tokens allowed to spent
77     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
78 
79     event Transfer(address indexed _from, address indexed _to, uint256 _value);
80     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
81 
82 }
83 
84 contract StandardToken is TokenERC20 {
85     using SafeMath for uint256;
86     function transfer(address _to, uint256 _value) returns (bool success) {
87         //Default assumes totalSupply can't be over max (2^256 - 1).
88         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
89         //Replace the if with this one instead.
90         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
91         if (balances[msg.sender] >= _value && _value > 0) {
92             balances[msg.sender] =balances[msg.sender].sub(_value);
93             balances[_to] = balances[_to].add(_value);
94             Transfer(msg.sender, _to, _value);
95             return true;
96         } else { return false; }
97     }
98 
99     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
100         //same as above. Replace this line with the following if you want to protect against wrapping uints.
101         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
102         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
103             balances[_to] =balances[_to].add(_value);
104             balances[_from]=balances[_from].sub(_value) ;
105             allowed[_from][msg.sender] =allowed[_from][msg.sender].sub(_value);
106             Transfer(_from, _to, _value);
107             return true;
108         } else { return false; }
109     }
110 
111     function balanceOf(address _owner) constant returns (uint256 balance) {
112         return balances[_owner];
113     }
114 
115     function approve(address _spender, uint256 _value) returns (bool success) {
116         allowed[msg.sender][_spender] = _value;
117         Approval(msg.sender, _spender, _value);
118         return true;
119     }
120 
121     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
122       return allowed[_owner][_spender];
123     }
124 
125     mapping (address => uint256) balances;
126     mapping (address => mapping (address => uint256)) allowed;
127     uint256 public totalSupply;
128 }
129 
130 contract TalkCrypto is owned,StandardToken { // CHANGE THIS. Update the contract name.
131     
132     /* Public variables of the token */
133 
134     /*
135     NOTE:
136     The following variables are OPTIONAL vanities. One does not have to include them.
137     They allow one to customise the token contract & in no way influences the core functionality.
138     Some wallets/interfaces might not even bother to look at this information.
139     */
140     string public name;                   // Token Name
141     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
142     string public symbol;                 // An identifier: eg SBX, XPR etc..
143     string public version = 'H1.0'; 
144     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
145     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
146     address public fundsWallet;           // Where should the raised ETH go?
147 
148     // This is a constructor function 
149     // which means the following function name has to match the contract name declared above
150     function TalkCrypto() {
151         balances[msg.sender] = 600000000000000000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
152         totalSupply = 600000000000000000000000000;                        // Update total supply (1000 for example) (CHANGE THIS)
153         name = "TalkCrypto";                                   // Set the name for display purposes (CHANGE THIS)
154         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
155         symbol = "TCO";                                             // Set the symbol for display purposes (CHANGE THIS)
156         unitsOneEthCanBuy = 10000;                                      // Set the price of your token for the ICO (CHANGE THIS)
157         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
158     }
159 
160     function() payable{
161         totalEthInWei = totalEthInWei.add(msg.value);
162         uint256 amount = msg.value * unitsOneEthCanBuy;
163         if (balances[fundsWallet] < amount) {
164             return;
165         }
166 
167         balances[fundsWallet] = balances[fundsWallet].sub(amount);
168         balances[msg.sender] = balances[msg.sender].add(amount);
169 
170         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
171 
172         //Transfer ether to fundsWallet
173         fundsWallet.transfer(msg.value);                               
174     }
175 
176     /* Approves and then calls the receiving contract */
177     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
178         allowed[msg.sender][_spender] = _value;
179         Approval(msg.sender, _spender, _value);
180 
181         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
182         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
183         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
184         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
185         return true;
186     }
187 }