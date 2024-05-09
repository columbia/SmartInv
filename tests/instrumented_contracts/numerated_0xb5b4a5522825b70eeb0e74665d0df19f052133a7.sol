1 pragma solidity ^0.4.19;
2 
3 /*
4 * BlockClout.com - Cryptocurrency Asset Management and A.I. Trading Bot
5 *
6 *
7 * This the authentic token contract for BlockClout. 
8 * Always refer to our website to confirm the accuracy of our smart contract and project development.
9 *
10 *
11 *
12 *
13 * Etherscan will also display our Official Links and Token Image
14 
15 */
16 
17 contract Token {
18 
19     /// @return total amount of tokens
20     function totalSupply() constant returns (uint256 supply) {}
21 
22     /// @param _owner The address from which the balance will be retrieved
23     /// @return The balance
24     function balanceOf(address _owner) constant returns (uint256 balance) {}
25 
26     /// @notice send `_value` token to `_to` from `msg.sender`
27     /// @param _to The address of the recipient
28     /// @param _value The amount of token to be transferred
29     /// @return Whether the transfer was successful or not
30     function transfer(address _to, uint256 _value) returns (bool success) {}
31 
32     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
33     /// @param _from The address of the sender
34     /// @param _to The address of the recipient
35     /// @param _value The amount of token to be transferred
36     /// @return Whether the transfer was successful or not
37     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
38 
39     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @param _value The amount of wei to be approved for transfer
42     /// @return Whether the approval was successful or not
43     function approve(address _spender, uint256 _value) returns (bool success) {}
44 
45     /// @param _owner The address of the account owning tokens
46     /// @param _spender The address of the account able to transfer the tokens
47     /// @return Amount of remaining tokens allowed to spent
48     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
49 
50     event Transfer(address indexed _from, address indexed _to, uint256 _value);
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52 
53 }
54 
55 contract StandardToken is Token {
56 
57     function transfer(address _to, uint256 _value) returns (bool success) {
58         if (balances[msg.sender] >= _value && _value > 0) {
59             balances[msg.sender] -= _value;
60             balances[_to] += _value;
61             Transfer(msg.sender, _to, _value);
62             return true;
63         } else { return false; }
64     }
65 
66     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
67         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
68             balances[_to] += _value;
69             balances[_from] -= _value;
70             allowed[_from][msg.sender] -= _value;
71             Transfer(_from, _to, _value);
72             return true;
73         } else { return false; }
74     }
75 
76     function balanceOf(address _owner) constant returns (uint256 balance) {
77         return balances[_owner];
78     }
79 
80     function approve(address _spender, uint256 _value) returns (bool success) {
81         allowed[msg.sender][_spender] = _value;
82         Approval(msg.sender, _spender, _value);
83         return true;
84     }
85 
86     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
87       return allowed[_owner][_spender];
88     }
89 
90     mapping (address => uint256) balances;
91     mapping (address => mapping (address => uint256)) allowed;
92     uint256 public totalSupply;
93 }
94 
95 contract BlockClout is StandardToken {
96 
97     string public name;
98     uint8 public decimals;
99     string public symbol;
100     string public version = '0.0';
101     uint256 public unitsOneEthCanBuy;
102     uint256 public totalEthInWei;
103     address public fundsWallet;
104 
105     function BlockClout() {
106         balances[msg.sender] = 112000000000000000000000000;
107         totalSupply = 112000000000000000000000000;
108         name = "BlockClout";
109         decimals = 18;
110         symbol = "CLOUT";
111         unitsOneEthCanBuy = 7754;
112         fundsWallet = msg.sender;
113     }
114 
115     function() payable{
116         totalEthInWei = totalEthInWei + msg.value;
117         uint256 amount = msg.value * unitsOneEthCanBuy;
118         if (balances[fundsWallet] < amount) {
119             return;
120         }
121 
122         balances[fundsWallet] = balances[fundsWallet] - amount;
123         balances[msg.sender] = balances[msg.sender] + amount;
124 
125         Transfer(fundsWallet, msg.sender, amount);
126 
127         fundsWallet.transfer(msg.value);                               
128     }
129 
130     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
131         allowed[msg.sender][_spender] = _value;
132         Approval(msg.sender, _spender, _value);
133 
134         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
135         return true;
136     }
137     /**
138  * @title SafeMath
139  * @dev Math operations with safety checks that throw on error
140  */
141 
142 
143   /**
144   * @dev Multiplies two numbers, throws on overflow.
145   */
146   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
147     if (a == 0) {
148       return 0;
149     }
150     uint256 c = a * b;
151     assert(c / a == b);
152     return c;
153   }
154 
155   /**
156   * @dev Integer division of two numbers, truncating the quotient.
157   */
158   function div(uint256 a, uint256 b) internal pure returns (uint256) {
159     // assert(b > 0); // Solidity automatically throws when dividing by 0
160     uint256 c = a / b;
161     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
162     return c;
163   }
164 
165   /**
166   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
167   */
168   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
169     assert(b <= a);
170     return a - b;
171   }
172 
173   /**
174   * @dev Adds two numbers, throws on overflow.
175   */
176   function add(uint256 a, uint256 b) internal pure returns (uint256) {
177     uint256 c = a + b;
178     assert(c >= a);
179     return c;
180   }
181 
182 }