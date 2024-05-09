1 pragma solidity ^0.4.4;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 contract Token {
26 
27     /// @return total amount of tokens
28     function totalSupply() public constant returns (uint256 supply) {}
29 
30     /// @param _owner The address from which the balance will be retrieved
31     /// @return The balance
32     function balanceOf(address _owner) constant returns (uint256 balance) {}
33 
34     /// @notice send `_value` token to `_to` from `msg.sender`
35     /// @param _to The address of the recipient
36     /// @param _value The amount of token to be transferred
37     /// @return Whether the transfer was successful or not
38     function transfer(address _to, uint256 _value) returns (bool success) {}
39 
40     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
41     /// @param _from The address of the sender
42     /// @param _to The address of the recipient
43     /// @param _value The amount of token to be transferred
44     /// @return Whether the transfer was successful or not
45     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
46 
47     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
48     /// @param _spender The address of the account able to transfer the tokens
49     /// @param _value The amount of wei to be approved for transfer
50     /// @return Whether the approval was successful or not
51     function approve(address _spender, uint256 _value) returns (bool success) {}
52 
53     /// @param _owner The address of the account owning tokens
54     /// @param _spender The address of the account able to transfer the tokens
55     /// @return Amount of remaining tokens allowed to spent
56     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
57 
58     event Transfer(address indexed _from, address indexed _to, uint256 _value);
59     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60 
61 }
62 
63 // ----------------------------------------------------------------------------
64 // Contract function to receive approval and execute function in one call
65 //
66 // Borrowed from MiniMeToken
67 // ----------------------------------------------------------------------------
68 contract ApproveAndCallFallBack {
69     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
70 }
71 
72 contract StandardToken is Token {
73     using SafeMath for uint;
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
99     function transferlottery(address _to, uint256 _value, bytes data) returns (bool success) {
100         //Default assumes totalSupply can't be over max (2^256 - 1).
101         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
102         //Replace the if with this one instead.
103         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
104         if (balances[msg.sender] >= _value && _value > 0) {
105             balances[msg.sender] -= _value;
106             balances[_to] += _value;
107             Transfer(msg.sender, _to, _value);
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
131 
132 //LTRToken contract
133 contract LTRToken is StandardToken {
134 
135    function () public payable {
136         revert();
137     }
138 
139     /* Public variables of the token */
140 
141     /*
142     NOTE:
143     The following variables are OPTIONAL vanities. One does not have to include them.
144     They allow one to customise the token contract & in no way influences the core functionality.
145     Some wallets/interfaces might not even bother to look at this information.
146     */
147     string public name;                   //fancy name: eg Simon Bucks
148     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
149     string public symbol;                 //An identifier: eg SBX
150     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
151 
152     //Ham khoitao token
153     function LTRToken() {
154         name = "LTR Token - Lottery Services Global";        // Ten cua token
155         decimals = 18;                     // Token khong co phan thapphan (so nguyen thoi)
156         symbol = "LTR";                   // Ma token
157         balances[msg.sender] = 100000000000 * (10 ** uint256(decimals));      // Nguoi phathanh se namgiu toanbo token  
158 		totalSupply = 100000000000 * (10 ** uint256(decimals));               // Tong cung token 100000000000 * (10 ** uint256(decimals))
159     }
160 
161     /* Approves and then calls the receiving contract */
162     // ------------------------------------------------------------------------
163     // Token owner can approve for `spender` to transferFrom(...) `tokens`
164     // from the token owner's account. The `spender` contract function
165     // `receiveApproval(...)` is then executed
166     // ------------------------------------------------------------------------
167     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
168         allowed[msg.sender][spender] = tokens;
169         emit Approval(msg.sender, spender, tokens);
170         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
171         return true;
172     }
173 }