1 pragma solidity ^0.4.4;
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
41 /**
42  * Math operations with safety checks
43  */
44 contract SafeMath {
45   function safeMul(uint a, uint b) internal returns (uint) {
46     uint c = a * b;
47     assert(a == 0 || c / a == b);
48     return c;
49   }
50 
51   function safeDiv(uint a, uint b) internal returns (uint) {
52     assert(b > 0);
53     uint c = a / b;
54     assert(a == b * c + a % b);
55     return c;
56   }
57 
58   function safeSub(uint a, uint b) internal returns (uint) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   function safeAdd(uint a, uint b) internal returns (uint) {
64     uint c = a + b;
65     assert(c>=a && c>=b);
66     return c;
67   }
68 
69   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
70     return a >= b ? a : b;
71   }
72 
73   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
74     return a < b ? a : b;
75   }
76 
77   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
78     return a >= b ? a : b;
79   }
80 
81   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
82     return a < b ? a : b;
83   }
84 
85 }
86 
87 contract StandardToken is Token, SafeMath {
88 
89     function transfer(address _to, uint256 _value) returns (bool success) {
90         if (balances[msg.sender] >= _value && _value > 0) {
91             balances[msg.sender] -= _value;
92             balances[_to] += _value;
93             Transfer(msg.sender, _to, _value);
94             return true;
95         } else { return false; }
96     }
97 
98     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
99         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
100             balances[_to] += _value;
101             balances[_from] -= _value;
102             allowed[_from][msg.sender] -= _value;
103             Transfer(_from, _to, _value);
104             return true;
105         } else { return false; }
106     }
107 
108     function balanceOf(address _owner) constant returns (uint256 balance) {
109         return balances[_owner];
110     }
111 
112     function approve(address _spender, uint256 _value) returns (bool success) {
113         allowed[msg.sender][_spender] = _value;
114         Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
119       return allowed[_owner][_spender];
120     }
121 
122     mapping (address => uint256) balances;
123     mapping (address => mapping (address => uint256)) allowed;
124     uint256 public totalSupply;
125 }
126 
127 contract TKCToken is StandardToken {
128 	/**
129      * Boolean contract states
130      */
131 	bool public preIco = false; //Pre-ico state
132 	
133 	address public owner = 0x0;
134 
135     function () {
136         //if ether is sent to this address, send it back.
137         throw;
138     }
139 
140     string public name;
141     uint8 public decimals;
142     string public symbol;
143     string public version = 'H1.0';
144 
145     function TKCToken() {
146         balances[msg.sender] = 280000000000000;
147         totalSupply = 280000000000000;
148         name = "TKC";
149         decimals = 6;
150         symbol = "TKC";
151 		
152 		owner = msg.sender;
153     }
154 	
155 	function price() returns (uint){
156         return 1853;
157     }
158 	
159 	function buy() public payable returns(bool) {
160         processBuy(msg.sender, msg.value);
161 
162         return true;
163     }
164 
165     function processBuy(address _to, uint256 _value) internal returns(bool) {
166         require(_value>0);
167 
168         // Count expected tokens price
169         uint tokens = _value * price();
170 
171         // Total tokens should be more than user want's to buy
172         require(balances[owner]>tokens);
173 
174         // Add tokens to user balance and remove from totalSupply
175         balances[_to] = safeAdd(balances[_to], tokens);
176         // Remove sold tokens from total supply count
177         balances[owner] = safeSub(balances[owner], tokens);
178 
179         // /* Emit log events */
180         Transfer(owner, _to, tokens);
181 
182         return true;
183     }
184 	
185 	function bounty(uint256 price) internal returns (uint256) {
186 		if (preIco) {
187 			return price + (price * 40/100);
188         } else {
189 			return price + (price * 25/100);
190         }
191     }
192 	
193 	/**
194      * Transfer bounty to target address from bounty pool
195      */
196 	function sendBounty(address _to, uint256 _value) onlyOwner() {
197         balances[_to] = safeAdd(balances[_to], _value);
198         // /* Emit log events */
199         Transfer(owner, _to, _value);
200     }
201 	
202     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
203         allowed[msg.sender][_spender] = _value;
204         Approval(msg.sender, _spender, _value);
205 
206         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
207         return true;
208     }
209 	
210 	/**
211      * Pre-ico state.
212      */
213     function setPreIco() onlyOwner() {
214         preIco = true;
215     }
216 
217     function unPreIco() onlyOwner() {
218         preIco = false;
219     }
220 
221 	modifier onlyOwner() {
222         require(msg.sender == owner);
223         _;
224     }
225 
226 }