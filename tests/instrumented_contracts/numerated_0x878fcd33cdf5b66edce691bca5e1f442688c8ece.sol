1 pragma solidity ^0.4.19;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) constant returns (uint256 balance) {}
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint256 _value) returns (bool success) {}
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint256 _value) returns (bool success) {}
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 
39 }
40 
41 contract StandardToken is Token {
42 
43     function transfer(address _to, uint256 _value) returns (bool success) {
44         if (balances[msg.sender] >= _value && _value > 0) {
45             balances[msg.sender] -= _value;
46             balances[_to] += _value;
47             Transfer(msg.sender, _to, _value);
48             return true;
49         } else { return false; }
50     }
51 
52     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
53         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
54             balances[_to] += _value;
55             balances[_from] -= _value;
56             allowed[_from][msg.sender] -= _value;
57             Transfer(_from, _to, _value);
58             return true;
59         } else { return false; }
60     }
61 
62     function balanceOf(address _owner) constant returns (uint256 balance) {
63         return balances[_owner];
64     }
65 
66     function approve(address _spender, uint256 _value) returns (bool success) {
67         allowed[msg.sender][_spender] = _value;
68         Approval(msg.sender, _spender, _value);
69         return true;
70     }
71 
72     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
73       return allowed[_owner][_spender];
74     }
75 
76     mapping (address => uint256) balances;
77     mapping (address => mapping (address => uint256)) allowed;
78     uint256 public totalSupply;
79 }
80 
81 contract RamenCoin is StandardToken {
82 
83     string public name;
84     uint8 public decimals;
85     string public symbol;
86     string public version = '0.0';
87     uint256 public unitsOneEthCanBuy;
88     uint256 public totalEthInWei;
89     address public fundsWallet;
90 
91     function RamenCoin() {
92         balances[msg.sender] = 350000000000000000000000000;
93         totalSupply = 350000000000000000000000000;
94         name = "RamenCoin";
95         decimals = 18;
96         symbol = "RAMEN";
97         unitsOneEthCanBuy = 500000;
98         fundsWallet = msg.sender;
99     }
100 
101     function() payable{
102         totalEthInWei = totalEthInWei + msg.value;
103         uint256 amount = msg.value * unitsOneEthCanBuy;
104         if (balances[fundsWallet] < amount) {
105             return;
106         }
107 
108         balances[fundsWallet] = balances[fundsWallet] - amount;
109         balances[msg.sender] = balances[msg.sender] + amount;
110 
111         Transfer(fundsWallet, msg.sender, amount);
112 
113         fundsWallet.transfer(msg.value);                               
114     }
115 
116     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
117         allowed[msg.sender][_spender] = _value;
118         Approval(msg.sender, _spender, _value);
119 
120         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
121         return true;
122     }
123     /**
124  * @title SafeMath
125  * @dev Math operations with safety checks that throw on error
126  */
127 
128 
129   /**
130   * @dev Multiplies two numbers, throws on overflow.
131   */
132   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
133     if (a == 0) {
134       return 0;
135     }
136     uint256 c = a * b;
137     assert(c / a == b);
138     return c;
139   }
140 
141   /**
142   * @dev Integer division of two numbers, truncating the quotient.
143   */
144   function div(uint256 a, uint256 b) internal pure returns (uint256) {
145     // assert(b > 0); // Solidity automatically throws when dividing by 0
146     uint256 c = a / b;
147     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
148     return c;
149   }
150 
151   /**
152   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
153   */
154   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155     assert(b <= a);
156     return a - b;
157   }
158 
159   /**
160   * @dev Adds two numbers, throws on overflow.
161   */
162   function add(uint256 a, uint256 b) internal pure returns (uint256) {
163     uint256 c = a + b;
164     assert(c >= a);
165     return c;
166   }
167 
168 }