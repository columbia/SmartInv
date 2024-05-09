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
39     function transferlottery(address _to, uint256 _value, bytes data) returns (bool success) {}
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
59     event TransferLottery(address indexed _from, address indexed _to, uint256 _value, bytes data);
60     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
61 
62 }
63 
64 // ----------------------------------------------------------------------------
65 // Contract function to receive approval and execute function in one call
66 //
67 // Borrowed from MiniMeToken
68 // ----------------------------------------------------------------------------
69 contract ApproveAndCallFallBack {
70     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
71 }
72 
73 contract StandardToken is Token {
74     using SafeMath for uint;
75     function transfer(address _to, uint256 _value) returns (bool success) {
76         //Default assumes totalSupply can't be over max (2^256 - 1).
77         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
78         //Replace the if with this one instead.
79         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
80         if (balances[msg.sender] >= _value && _value > 0) {
81             balances[msg.sender] -= _value;
82             balances[_to] += _value;
83             Transfer(msg.sender, _to, _value);
84             return true;
85         } else { return false; }
86     }
87 
88     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
89         //same as above. Replace this line with the following if you want to protect against wrapping uints.
90         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
91         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
92             balances[_to] += _value;
93             balances[_from] -= _value;
94             allowed[_from][msg.sender] -= _value;
95             Transfer(_from, _to, _value);
96             return true;
97         } else { return false; }
98     }
99     
100     function transferlottery(address _to, uint256 _value, bytes data) returns (bool success) {
101         //Default assumes totalSupply can't be over max (2^256 - 1).
102         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
103         //Replace the if with this one instead.
104         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
105         if (balances[msg.sender] >= _value && _value > 0) {
106             balances[msg.sender] -= _value;
107             balances[_to] += _value;
108             Transfer(msg.sender, _to, _value);
109             return true;
110         } else { return false; }
111     }
112 
113     function balanceOf(address _owner) constant returns (uint256 balance) {
114         return balances[_owner];
115     }
116 
117     function approve(address _spender, uint256 _value) returns (bool success) {
118         allowed[msg.sender][_spender] = _value;
119         Approval(msg.sender, _spender, _value);
120         return true;
121     }
122 
123     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
124       return allowed[_owner][_spender];
125     }
126 
127     mapping (address => uint256) balances;
128     mapping (address => mapping (address => uint256)) allowed;
129     uint256 public totalSupply;
130 }
131 
132 
133 //LTRToken contract
134 contract LTRToken is StandardToken {
135 
136    function () public payable {
137         revert();
138     }
139 
140     /* Public variables of the token */
141 
142     /*
143     NOTE:
144     The following variables are OPTIONAL vanities. One does not have to include them.
145     They allow one to customise the token contract & in no way influences the core functionality.
146     Some wallets/interfaces might not even bother to look at this information.
147     */
148     string public name;                   //fancy name: eg Simon Bucks
149     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
150     string public symbol;                 //An identifier: eg SBX
151     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
152 
153     //Ham khoitao token
154     function LTRToken() {
155         name = "LTR Token - Lottery Services Global";        // Ten cua token
156         decimals = 18;                     // Token khong co phan thapphan (so nguyen thoi)
157         symbol = "LTR";                   // Ma token
158         balances[msg.sender] = 100000000000 * (10 ** uint256(decimals));      // Nguoi phathanh se namgiu toanbo token  
159 		totalSupply = 100000000000 * (10 ** uint256(decimals));               // Tong cung token 100000000000 * (10 ** uint256(decimals))
160     }
161 
162     /* Approves and then calls the receiving contract */
163     // ------------------------------------------------------------------------
164     // Token owner can approve for `spender` to transferFrom(...) `tokens`
165     // from the token owner's account. The `spender` contract function
166     // `receiveApproval(...)` is then executed
167     // ------------------------------------------------------------------------
168     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
169         allowed[msg.sender][spender] = tokens;
170         emit Approval(msg.sender, spender, tokens);
171         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
172         return true;
173     }
174 }