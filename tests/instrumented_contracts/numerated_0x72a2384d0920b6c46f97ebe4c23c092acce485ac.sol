1 pragma solidity ^0.4.21;
2 
3 contract EIP20Interface {
4     /* This is a slight change to the ERC20 base standard.
5     function totalSupply() constant returns (uint256 supply);
6     is replaced with:
7     uint256 public totalSupply;
8     This automatically creates a getter function for the totalSupply.
9     This is moved to the base contract since public getter functions are not
10     currently recognised as an implementation of the matching abstract
11     function by the compiler.
12     */
13     /// total amount of tokens
14     uint256 public totalSupply;
15 
16     /// @param _owner The address from which the balance will be retrieved
17     /// @return The balance
18     function balanceOf(address _owner) public view returns (uint256 balance);
19 
20     /// @notice send `_value` token to `_to` from `msg.sender`
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transfer(address _to, uint256 _value) public returns (bool success);
25 
26     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
27     /// @param _from The address of the sender
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
32 
33     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @param _value The amount of tokens to be approved for transfer
36     /// @return Whether the approval was successful or not
37     function approve(address _spender, uint256 _value) public returns (bool success);
38 
39     /// @param _owner The address of the account owning tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @return Amount of remaining tokens allowed to spent
42     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
43 
44     // solhint-disable-next-line no-simple-event-func-name
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 }
48 
49 contract EIP20 is EIP20Interface {
50 
51     uint256 constant private MAX_UINT256 = 2**256 - 1;
52     mapping (address => uint256) public balances;
53     mapping (address => mapping (address => uint256)) public allowed;
54     
55     
56     string public name;                   
57     uint8 public decimals;                
58     string public symbol;                 
59 
60     function EIP20(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
61         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
62         totalSupply = _initialAmount;                        // Update total supply
63         name = _tokenName;                                   // Set the name for display purposes
64         decimals = _decimalUnits;                            // Amount of decimals for display purposes
65         symbol = _tokenSymbol;                               // Set the symbol for display purposes
66     }
67 
68     function transfer(address _to, uint256 _value) public returns (bool success) {
69         require(balances[msg.sender] >= _value);
70         balances[msg.sender] -= _value;
71         balances[_to] += _value;
72         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
73         return true;
74     }
75 
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
77         uint256 allowance = allowed[_from][msg.sender];
78         require(balances[_from] >= _value && allowance >= _value);
79         balances[_to] += _value;
80         balances[_from] -= _value;
81         if (allowance < MAX_UINT256) {
82             allowed[_from][msg.sender] -= _value;
83         }
84         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
85         return true;
86     }
87 
88     function balanceOf(address _owner) public view returns (uint256 balance) {
89         return balances[_owner];
90     }
91 
92     function approve(address _spender, uint256 _value) public returns (bool success) {
93         allowed[msg.sender][_spender] = _value;
94         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
95         return true;
96     }
97 
98     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
99         return allowed[_owner][_spender];
100     }
101 }
102 contract RGEToken is EIP20 {
103     
104     /* ERC20 */
105     string public name = 'Rouge';
106     string public symbol = 'RGE';
107     uint8 public decimals = 8;
108     
109     /* RGEToken */
110     address owner; 
111     address public crowdsale;
112     uint public endTGE;
113     string public version = 'v0.2';
114     uint256 public totalSupply = 1000000000 * 10**uint(decimals);
115     uint256 public   reserveY1 =  300000000 * 10**uint(decimals);
116     uint256 public   reserveY2 =  200000000 * 10**uint(decimals);
117 
118     modifier onlyBy(address _account) {
119         require(msg.sender == _account);
120         _;
121     }
122     
123     constructor() EIP20 (totalSupply, name, decimals, symbol) public {
124         owner = msg.sender;
125         crowdsale = address(0);
126     }
127     
128     function startCrowdsaleY0(address _crowdsale) onlyBy(owner) public {
129         require(_crowdsale != address(0));
130         require(crowdsale == address(0));
131         crowdsale = _crowdsale;
132         balances[crowdsale] = totalSupply - reserveY1 - reserveY2;
133         emit Transfer(address(0), crowdsale, balances[crowdsale]);
134     }
135 
136     function startCrowdsaleY1(address _crowdsale) onlyBy(owner) public {
137         require(_crowdsale != address(0));
138         require(crowdsale == address(0));
139         require(reserveY1 > 0);
140         crowdsale = _crowdsale;
141         balances[crowdsale] = reserveY1;
142         emit Transfer(address(0), crowdsale, reserveY1);
143         reserveY1 = 0;
144     }
145 
146     function startCrowdsaleY2(address _crowdsale) onlyBy(owner) public {
147         require(_crowdsale != address(0));
148         require(crowdsale == address(0));
149         require(reserveY2 > 0);
150         crowdsale = _crowdsale;
151         balances[crowdsale] = reserveY2;
152         emit Transfer(address(0), crowdsale, reserveY2);
153         reserveY2 = 0;
154     }
155 
156     // in practice later than end of TGE to let people withdraw
157     function endCrowdsale() onlyBy(owner) public {
158         require(crowdsale != address(0));
159         require(now > endTGE);
160         reserveY2 += balances[crowdsale];
161         emit Transfer(crowdsale, address(0), balances[crowdsale]);
162         balances[crowdsale] = 0;
163         crowdsale = address(0);
164     }
165 
166     event Burn(address indexed burner, uint256 value);
167 
168     function burn(uint256 _value) public returns (bool success) {
169         require(_value > 0);
170         require(balances[msg.sender] >= _value);
171         balances[msg.sender] -= _value;
172         totalSupply -= _value;
173         emit Transfer(msg.sender, address(0), _value);
174         emit Burn(msg.sender, _value);
175         return true;
176     }
177 
178 }