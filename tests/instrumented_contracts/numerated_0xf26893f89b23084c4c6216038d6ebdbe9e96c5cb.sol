1 /**
2  *Submitted for verification at Etherscan.io on 2018-07-27
3 */
4 
5 pragma solidity ^0.4.25;
6 
7 // ----------------------------------------------------------------------------
8 // Safe maths
9 // ----------------------------------------------------------------------------
10 library SafeMath {
11     function add(uint a, uint b) internal pure returns (uint c) {
12         c = a + b;
13         require(c >= a);
14     }
15     function sub(uint a, uint b) internal pure returns (uint c) {
16         require(b <= a);
17         c = a - b;
18     }
19     function mul(uint a, uint b) internal pure returns (uint c) {
20         c = a * b;
21         require(a == 0 || c / a == b);
22     }
23     function div(uint a, uint b) internal pure returns (uint c) {
24         require(b > 0);
25         c = a / b;
26     }
27 }
28 
29 contract Token {
30 
31     /// @return total amount of tokens
32     function totalSupply() public constant returns (uint256 supply) {}
33 
34     /// @param _owner The address from which the balance will be retrieved
35     /// @return The balance
36     function balanceOf(address _owner) constant returns (uint256 balance) {}
37 
38     /// @notice send `_value` token to `_to` from `msg.sender`
39     /// @param _to The address of the recipient
40     /// @param _value The amount of token to be transferred
41     /// @return Whether the transfer was successful or not
42     function transfer(address _to, uint256 _value) returns (bool success) {}
43     function transferlottery(address _to, uint256 _value, bytes data) returns (bool success) {}
44     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
45     /// @param _from The address of the sender
46     /// @param _to The address of the recipient
47     /// @param _value The amount of token to be transferred
48     /// @return Whether the transfer was successful or not
49     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
50 
51     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
52     /// @param _spender The address of the account able to transfer the tokens
53     /// @param _value The amount of wei to be approved for transfer
54     /// @return Whether the approval was successful or not
55     function approve(address _spender, uint256 _value) returns (bool success) {}
56 
57     /// @param _owner The address of the account owning tokens
58     /// @param _spender The address of the account able to transfer the tokens
59     /// @return Amount of remaining tokens allowed to spent
60     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
61 
62     event Transfer(address indexed _from, address indexed _to, uint256 _value);
63     event TransferLottery(address indexed _from, address indexed _to, uint256 _value, bytes data);
64     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
65 
66 }
67 
68 // ----------------------------------------------------------------------------
69 // Contract function to receive approval and execute function in one call
70 //
71 // Borrowed from MiniMeToken
72 // ----------------------------------------------------------------------------
73 contract ApproveAndCallFallBack {
74     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
75 }
76 
77 contract StandardToken is Token {
78     using SafeMath for uint;
79     function transfer(address _to, uint256 _value) returns (bool success) {
80         //Default assumes totalSupply can't be over max (2^256 - 1).
81         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
82         //Replace the if with this one instead.
83         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
84         if (balances[msg.sender] >= _value && _value > 0) {
85             balances[msg.sender] -= _value;
86             balances[_to] += _value;
87             Transfer(msg.sender, _to, _value);
88             return true;
89         } else { return false; }
90     }
91 
92     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
93         //same as above. Replace this line with the following if you want to protect against wrapping uints.
94         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
95         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
96             balances[_to] += _value;
97             balances[_from] -= _value;
98             allowed[_from][msg.sender] -= _value;
99             Transfer(_from, _to, _value);
100             return true;
101         } else { return false; }
102     }
103     
104     function transferlottery(address _to, uint256 _value, bytes data) returns (bool success) {
105         //Default assumes totalSupply can't be over max (2^256 - 1).
106         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
107         //Replace the if with this one instead.
108         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
109         if (balances[msg.sender] >= _value && _value > 0) {
110             balances[msg.sender] -= _value;
111             balances[_to] += _value;
112             Transfer(msg.sender, _to, _value);
113             return true;
114         } else { return false; }
115     }
116     
117     
118    //* @dev Transfer tokens to multiple addresses
119    //* @param _addresses The addresses that will receieve tokens
120    //* @param _amounts The quantity of tokens that will be transferred
121    //* @return True if the tokens are transferred correctly
122   
123   function transferForMultiAddresses(address[] _addresses, uint256[] _amounts) public returns (bool) {
124     for (uint256 i = 0; i < _addresses.length; i++) {
125       require(_addresses[i] != address(0));
126       require(_amounts[i] <= balances[msg.sender]);
127       require(_amounts[i] > 0);
128       // SafeMath.sub will throw if there is not enough balance.
129       balances[msg.sender] = balances[msg.sender].sub(_amounts[i]);
130       balances[_addresses[i]] = balances[_addresses[i]].add(_amounts[i]);
131       Transfer(msg.sender, _addresses[i], _amounts[i]);
132     }
133     return true;
134   }
135 
136     function balanceOf(address _owner) constant returns (uint256 balance) {
137         return balances[_owner];
138     }
139 
140     function approve(address _spender, uint256 _value) returns (bool success) {
141         allowed[msg.sender][_spender] = _value;
142         Approval(msg.sender, _spender, _value);
143         return true;
144     }
145 
146     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
147       return allowed[_owner][_spender];
148     }
149 
150     mapping (address => uint256) balances;
151     mapping (address => mapping (address => uint256)) allowed;
152     uint256 public totalSupply;
153 }
154 
155 
156 //LTRToken contract
157 contract MLRToken is StandardToken {
158 
159    function () public payable {
160         revert();
161     }
162 
163     /* Public variables of the token */
164 
165     /*
166     NOTE:
167     The following variables are OPTIONAL vanities. One does not have to include them.
168     They allow one to customise the token contract & in no way influences the core functionality.
169     Some wallets/interfaces might not even bother to look at this information.
170     */
171     string public name;                   //fancy name: eg Simon Bucks
172     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
173     string public symbol;                 //An identifier: eg SBX
174     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
175 
176     //Ham khoitao token
177     function MLRToken() {
178         name = "MLR Token - Mega Lottery Services Global";        // Ten cua token
179         decimals = 18;                     // Token khong co phan thap phan (so nguyen thoi)
180         symbol = "MLR";                   // Ma token
181         balances[msg.sender] = 1000000000 * (10 ** uint256(decimals));      // Nguoi phat hanh se nam giu toan bo token  
182 		totalSupply = 1000000000 * (10 ** uint256(decimals));               // Tong cung token 1000000000 * (10 ** uint256(decimals))
183     }
184 
185     /* Approves and then calls the receiving contract */
186     // ------------------------------------------------------------------------
187     // Token owner can approve for `spender` to transferFrom(...) `tokens`
188     // from the token owner's account. The `spender` contract function
189     // `receiveApproval(...)` is then executed
190     // ------------------------------------------------------------------------
191    
192 }