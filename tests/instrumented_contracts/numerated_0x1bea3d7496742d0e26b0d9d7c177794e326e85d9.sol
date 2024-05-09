1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
3 pragma solidity ^0.4.21;
4 
5 contract EIP20Interface {
6     /* This is a slight change to the ERC20 base standard.
7     function totalSupply() constant returns (uint256 supply);
8     is replaced with:
9     uint256 public totalSupply;
10     This automatically creates a getter function for the totalSupply.
11     This is moved to the base contract since public getter functions are not
12     currently recognised as an implementation of the matching abstract
13     function by the compiler.
14     */
15     /// total amount of tokens
16     uint256 public totalSupply;
17 
18     /// @param _owner The address from which the balance will be retrieved
19     /// @return The balance
20     function balanceOf(address _owner) public view returns (uint256 balance);
21 
22     /// @notice send `_value` token to `_to` from `msg.sender`
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transfer(address _to, uint256 _value) public returns (bool success);
27 
28     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
29     /// @param _from The address of the sender
30     /// @param _to The address of the recipient
31     /// @param _value The amount of token to be transferred
32     /// @return Whether the transfer was successful or not
33     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
34 
35     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @param _value The amount of tokens to be approved for transfer
38     /// @return Whether the approval was successful or not
39     function approve(address _spender, uint256 _value) public returns (bool success);
40 
41     /// @param _owner The address of the account owning tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @return Amount of remaining tokens allowed to spent
44     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
45 
46     // solhint-disable-next-line no-simple-event-func-name
47     event Transfer(address indexed _from, address indexed _to, uint256 _value);
48     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49 }
50 
51 library SafeMath {
52     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         if (a == 0) {
54             return 0;
55         }
56         uint256 c = a * b;
57         assert(c / a == b);
58         return c;
59     }
60 
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         // assert(b > 0); // Solidity automatically throws when dividing by 0
63         uint256 c = a / b;
64         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65         return c;
66     }
67 
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         assert(b <= a);
70         return a - b;
71     }
72 
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         assert(c >= a);
76         return c;
77     }
78 }
79 
80 contract MOSToken is EIP20Interface {
81 
82     uint256 constant private MAX_UINT256 = 2 ** 256 - 1;
83     mapping(address => uint256) private balances;
84     mapping(address => mapping(address => uint256)) private allowed;
85     /*
86     NOTE:
87     The following variables are OPTIONAL vanities. One does not have to include them.
88     They allow one to customise the token contract & in no way influences the core functionality.
89     Some wallets/interfaces might not even bother to look at this information.
90     */
91     string public name;                   //fancy name: eg Simon Bucks
92     uint8 public decimals;                //How many decimals to show.
93     string public symbol;                 //An identifier: eg SBX
94     address public owner;
95 
96     function MOSToken() public {
97         totalSupply = 5 * (10 ** 8) * (10 ** 18);
98         // Update total supply
99         balances[msg.sender] = totalSupply;
100         // Give the creator all initial tokens
101         name = 'MOSDAO token';
102         // Set the name for display purposes
103         decimals = 18;
104         // Amount of decimals for display purposes
105         symbol = 'MOS';
106         // Set the symbol for display purposes
107         owner = msg.sender;
108     }
109 
110     function transfer(address _to, uint256 _value) public returns (bool success) {
111         require(balances[msg.sender] >= _value);
112         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
113         balances[_to] = SafeMath.add(balances[_to], _value);
114         emit Transfer(msg.sender, _to, _value);
115         //solhint-disable-line indent, no-unused-vars
116         return true;
117     }
118 
119     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
120         uint256 allowance = allowed[_from][msg.sender];
121         require(balances[_from] >= _value && allowance >= _value);
122         balances[_to] = SafeMath.add(balances[_to], _value);
123         balances[_from] = SafeMath.sub(balances[_from], _value);
124         if (allowance < MAX_UINT256) {
125             allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
126         }
127         emit Transfer(_from, _to, _value);  
128         //solhint-disable-line indent, no-unused-vars
129         return true;
130     }
131 
132     function balanceOf(address _owner) public view returns (uint256 balance) {
133         return balances[_owner];
134     }
135 
136     function approve(address _spender, uint256 _value) public returns (bool success) {
137         allowed[msg.sender][_spender] = _value;
138         emit Approval(msg.sender, _spender, _value);
139         //solhint-disable-line indent, no-unused-vars
140         return true;
141     }
142 
143     function increaseApprove(address _spender, uint256 _value) public returns (bool) {
144         return approve(_spender, SafeMath.add(allowed[msg.sender][_spender], _value));
145     }
146 
147     function decreaseApprove(address _spender, uint256 _value) public returns (bool) {
148         return approve(_spender, SafeMath.sub(allowed[msg.sender][_spender], _value));
149     }
150 
151     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
152         return allowed[_owner][_spender];
153     }
154 
155     function mint(uint256 _value) public returns (bool success) {
156         require(owner == msg.sender);
157         balances[msg.sender] = SafeMath.add(balances[msg.sender], _value);
158         totalSupply = SafeMath.add(totalSupply, _value);
159         emit Transfer(address(0), msg.sender, _value);
160         //solhint-disable-line indent, no-unused-vars
161         return true;
162     }
163 
164     function burn(uint256 _value) public returns (bool success) {
165         require(balances[msg.sender] >= _value);
166         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
167         totalSupply = SafeMath.sub(totalSupply, _value);
168         emit Transfer(msg.sender, address(0), _value);
169         //solhint-disable-line indent, no-unused-vars
170         return true;
171     }
172 }