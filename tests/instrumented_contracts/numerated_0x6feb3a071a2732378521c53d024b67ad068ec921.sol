1 pragma solidity ^0.4.19;
2 
3 /*
4 * Ramen Coin is the FIRST and ONLY cryptocurrency for Ramen Enthusiasts with a mission to fight hunger GLOBALLY.
5 *
6 *
7 * This the OFFICIAL token contract for Ramen Coin. 
8 * Our old contract address is no longer valid. DO NOT accept tokens from the old contract.
9 * Old Contract Address: (DO NOT USE) 0x878fcd33cdf5b66edce691bca5e1f442688c8ece (DO NOT USE)
10 *
11 * VALID contract address can be verified on https://ramencoin.me or our official social media channels
12 * Twitter: @RamenCoin2018
13 * Telegram: @ramencoin 
14 * Reddit: /r/RamenCoin 
15 * Facebook: RamenCoin
16 * Instagram: @ramencoin 
17 * BitcoinTalk: https://bitcointalk.org/index.php?topic=3171591
18 *
19 *
20 * Etherscan will also display our Official Links and Token Image
21 
22 */
23 
24 contract Token {
25 
26     /// @return total amount of tokens
27     function totalSupply() constant returns (uint256 supply) {}
28 
29     /// @param _owner The address from which the balance will be retrieved
30     /// @return The balance
31     function balanceOf(address _owner) constant returns (uint256 balance) {}
32 
33     /// @notice send `_value` token to `_to` from `msg.sender`
34     /// @param _to The address of the recipient
35     /// @param _value The amount of token to be transferred
36     /// @return Whether the transfer was successful or not
37     function transfer(address _to, uint256 _value) returns (bool success) {}
38 
39     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
40     /// @param _from The address of the sender
41     /// @param _to The address of the recipient
42     /// @param _value The amount of token to be transferred
43     /// @return Whether the transfer was successful or not
44     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
45 
46     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
47     /// @param _spender The address of the account able to transfer the tokens
48     /// @param _value The amount of wei to be approved for transfer
49     /// @return Whether the approval was successful or not
50     function approve(address _spender, uint256 _value) returns (bool success) {}
51 
52     /// @param _owner The address of the account owning tokens
53     /// @param _spender The address of the account able to transfer the tokens
54     /// @return Amount of remaining tokens allowed to spent
55     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
56 
57     event Transfer(address indexed _from, address indexed _to, uint256 _value);
58     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
59 
60 }
61 
62 contract StandardToken is Token {
63 
64     function transfer(address _to, uint256 _value) returns (bool success) {
65         if (balances[msg.sender] >= _value && _value > 0) {
66             balances[msg.sender] -= _value;
67             balances[_to] += _value;
68             Transfer(msg.sender, _to, _value);
69             return true;
70         } else { return false; }
71     }
72 
73     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
74         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
75             balances[_to] += _value;
76             balances[_from] -= _value;
77             allowed[_from][msg.sender] -= _value;
78             Transfer(_from, _to, _value);
79             return true;
80         } else { return false; }
81     }
82 
83     function balanceOf(address _owner) constant returns (uint256 balance) {
84         return balances[_owner];
85     }
86 
87     function approve(address _spender, uint256 _value) returns (bool success) {
88         allowed[msg.sender][_spender] = _value;
89         Approval(msg.sender, _spender, _value);
90         return true;
91     }
92 
93     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
94       return allowed[_owner][_spender];
95     }
96 
97     mapping (address => uint256) balances;
98     mapping (address => mapping (address => uint256)) allowed;
99     uint256 public totalSupply;
100 }
101 
102 contract RamenCoin is StandardToken {
103 
104     string public name;
105     uint8 public decimals;
106     string public symbol;
107     string public version = '0.0';
108     uint256 public unitsOneEthCanBuy;
109     uint256 public totalEthInWei;
110     address public fundsWallet;
111 
112     function RamenCoin() {
113         balances[msg.sender] = 350000000000000000000000000;
114         totalSupply = 350000000000000000000000000;
115         name = "Ramen Coin";
116         decimals = 18;
117         symbol = "RAMEN";
118         unitsOneEthCanBuy = 3500;
119         fundsWallet = msg.sender;
120     }
121 
122     function() payable{
123         totalEthInWei = totalEthInWei + msg.value;
124         uint256 amount = msg.value * unitsOneEthCanBuy;
125         if (balances[fundsWallet] < amount) {
126             return;
127         }
128 
129         balances[fundsWallet] = balances[fundsWallet] - amount;
130         balances[msg.sender] = balances[msg.sender] + amount;
131 
132         Transfer(fundsWallet, msg.sender, amount);
133 
134         fundsWallet.transfer(msg.value);                               
135     }
136 
137     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
138         allowed[msg.sender][_spender] = _value;
139         Approval(msg.sender, _spender, _value);
140 
141         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
142         return true;
143     }
144     /**
145  * @title SafeMath
146  * @dev Math operations with safety checks that throw on error
147  */
148 
149 
150   /**
151   * @dev Multiplies two numbers, throws on overflow.
152   */
153   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
154     if (a == 0) {
155       return 0;
156     }
157     uint256 c = a * b;
158     assert(c / a == b);
159     return c;
160   }
161 
162   /**
163   * @dev Integer division of two numbers, truncating the quotient.
164   */
165   function div(uint256 a, uint256 b) internal pure returns (uint256) {
166     // assert(b > 0); // Solidity automatically throws when dividing by 0
167     uint256 c = a / b;
168     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
169     return c;
170   }
171 
172   /**
173   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
174   */
175   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
176     assert(b <= a);
177     return a - b;
178   }
179 
180   /**
181   * @dev Adds two numbers, throws on overflow.
182   */
183   function add(uint256 a, uint256 b) internal pure returns (uint256) {
184     uint256 c = a + b;
185     assert(c >= a);
186     return c;
187   }
188 
189 }