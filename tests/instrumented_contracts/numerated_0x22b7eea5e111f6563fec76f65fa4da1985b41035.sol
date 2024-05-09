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
113     
114    //* @dev Transfer tokens to multiple addresses
115    //* @param _addresses The addresses that will receieve tokens
116    //* @param _amounts The quantity of tokens that will be transferred
117    //* @return True if the tokens are transferred correctly
118   
119   function transferForMultiAddresses(address[] _addresses, uint256[] _amounts) public returns (bool) {
120     for (uint256 i = 0; i < _addresses.length; i++) {
121       require(_addresses[i] != address(0));
122       require(_amounts[i] <= balances[msg.sender]);
123       require(_amounts[i] > 0);
124       // SafeMath.sub will throw if there is not enough balance.
125       balances[msg.sender] = balances[msg.sender].sub(_amounts[i]);
126       balances[_addresses[i]] = balances[_addresses[i]].add(_amounts[i]);
127       Transfer(msg.sender, _addresses[i], _amounts[i]);
128     }
129     return true;
130   }
131 
132     function balanceOf(address _owner) constant returns (uint256 balance) {
133         return balances[_owner];
134     }
135 
136     function approve(address _spender, uint256 _value) returns (bool success) {
137         allowed[msg.sender][_spender] = _value;
138         Approval(msg.sender, _spender, _value);
139         return true;
140     }
141 
142     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
143       return allowed[_owner][_spender];
144     }
145 
146     mapping (address => uint256) balances;
147     mapping (address => mapping (address => uint256)) allowed;
148     uint256 public totalSupply;
149 }
150 
151 
152 //LTRToken contract
153 contract LTRToken is StandardToken {
154 
155    function () public payable {
156         revert();
157     }
158 
159     /* Public variables of the token */
160 
161     /*
162     NOTE:
163     The following variables are OPTIONAL vanities. One does not have to include them.
164     They allow one to customise the token contract & in no way influences the core functionality.
165     Some wallets/interfaces might not even bother to look at this information.
166     */
167     string public name;                   //fancy name: eg Simon Bucks
168     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
169     string public symbol;                 //An identifier: eg SBX
170     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
171 
172     //Ham khoitao token
173     function LTRToken() {
174         name = "LTR Token - Lottery Services Global";        // Ten cua token
175         decimals = 18;                     // Token khong co phan thap phan (so nguyen thoi)
176         symbol = "LTR";                   // Ma token
177         balances[msg.sender] = 100000000000 * (10 ** uint256(decimals));      // Nguoi phat hanh se nam giu toan bo token  
178 		totalSupply = 100000000000 * (10 ** uint256(decimals));               // Tong cung token 100000000000 * (10 ** uint256(decimals))
179     }
180 
181     /* Approves and then calls the receiving contract */
182     // ------------------------------------------------------------------------
183     // Token owner can approve for `spender` to transferFrom(...) `tokens`
184     // from the token owner's account. The `spender` contract function
185     // `receiveApproval(...)` is then executed
186     // ------------------------------------------------------------------------
187     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
188         allowed[msg.sender][spender] = tokens;
189         emit Approval(msg.sender, spender, tokens);
190         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
191         return true;
192     }
193 }