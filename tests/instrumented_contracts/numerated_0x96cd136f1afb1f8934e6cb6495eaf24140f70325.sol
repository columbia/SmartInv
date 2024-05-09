1 contract EIP20Interface {
2     /* This is a slight change to the ERC20 base standard.
3     function totalSupply() constant returns (uint256 supply);
4     is replaced with:
5     uint256 public totalSupply;
6     This automatically creates a getter function for the totalSupply.
7     This is moved to the base contract since public getter functions are not
8     currently recognised as an implementation of the matching abstract
9     function by the compiler.
10     */
11     /// total amount of tokens
12     uint256 public totalSupply;
13 
14     /// @param _owner The address from which the balance will be retrieved
15     /// @return The balance
16     function balanceOf(address _owner) public view returns (uint256 balance);
17 
18     /// @notice send `_value` token to `_to` from `msg.sender`
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transfer(address _to, uint256 _value) public returns (bool success);
23 
24     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
25     /// @param _from The address of the sender
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
30 
31     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @param _value The amount of tokens to be approved for transfer
34     /// @return Whether the approval was successful or not
35     function approve(address _spender, uint256 _value) public returns (bool success);
36 
37     /// @param _owner The address of the account owning tokens
38     /// @param _spender The address of the account able to transfer the tokens
39     /// @return Amount of remaining tokens allowed to spent
40     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
41 
42     // solhint-disable-next-line no-simple-event-func-name
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 }
46 
47 
48 contract EIP20 is EIP20Interface {
49 
50     uint256 constant private MAX_UINT256 = 2**256 - 1;
51     mapping (address => uint256) public balances;
52     mapping (address => mapping (address => uint256)) public allowed;
53     /*
54     NOTE:
55     The following variables are OPTIONAL vanities. One does not have to include them.
56     They allow one to customise the token contract & in no way influences the core functionality.
57     Some wallets/interfaces might not even bother to look at this information.
58     */
59     string public name;                   //fancy name: eg Simon Bucks
60     uint8 public decimals;                //How many decimals to show.
61     string public symbol;                 //An identifier: eg SBX
62 
63     function EIP20(
64         uint256 _initialAmount,
65         string _tokenName,
66         uint8 _decimalUnits,
67         string _tokenSymbol
68     ) public {
69         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
70         totalSupply = _initialAmount;                        // Update total supply
71         name = _tokenName;                                   // Set the name for display purposes
72         decimals = _decimalUnits;                            // Amount of decimals for display purposes
73         symbol = _tokenSymbol;                               // Set the symbol for display purposes
74     }
75 
76     function transfer(address _to, uint256 _value) public returns (bool success) {
77         require(balances[msg.sender] >= _value);
78         balances[msg.sender] -= _value;
79         balances[_to] += _value;
80         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
81         return true;
82     }
83 
84     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
85         uint256 allowance = allowed[_from][msg.sender];
86         require(balances[_from] >= _value && allowance >= _value);
87         balances[_to] += _value;
88         balances[_from] -= _value;
89         if (allowance < MAX_UINT256) {
90             allowed[_from][msg.sender] -= _value;
91         }
92         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
93         return true;
94     }
95 
96     function balanceOf(address _owner) public view returns (uint256 balance) {
97         return balances[_owner];
98     }
99 
100     function approve(address _spender, uint256 _value) public returns (bool success) {
101         allowed[msg.sender][_spender] = _value;
102         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
103         return true;
104     }
105 
106     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
107         return allowed[_owner][_spender];
108     }
109 }
110 contract RGEToken is EIP20 {
111     
112     /* ERC20 */
113     string public name = 'Rouge';
114     string public symbol = 'RGE';
115     uint8 public decimals = 6;
116     
117     /* RGEToken */
118     address owner; 
119     address public crowdsale;
120     uint public endTGE;
121     string public version = 'v1';
122     uint256 public totalSupply = 1000000000 * 10**uint(decimals);
123     uint256 public   reserveY1 =  300000000 * 10**uint(decimals);
124     uint256 public   reserveY2 =  200000000 * 10**uint(decimals);
125 
126     modifier onlyBy(address _address) {
127         require(msg.sender == _address);
128         _;
129     }
130     
131     constructor(uint _endTGE) EIP20 (totalSupply, name, decimals, symbol) public {
132         owner = msg.sender;
133         endTGE = _endTGE;
134         crowdsale = address(0);
135         balances[owner] = 0;
136         balances[crowdsale] = totalSupply;
137     }
138     
139     function startCrowdsaleY0(address _crowdsale) onlyBy(owner) public {
140         require(_crowdsale != address(0));
141         require(crowdsale == address(0));
142         require(now < endTGE);
143         crowdsale = _crowdsale;
144         balances[crowdsale] = totalSupply - reserveY1 - reserveY2;
145         balances[address(0)] -= balances[crowdsale];
146         emit Transfer(address(0), crowdsale, balances[crowdsale]);
147     }
148 
149     function startCrowdsaleY1(address _crowdsale) onlyBy(owner) public {
150         require(_crowdsale != address(0));
151         require(crowdsale == address(0));
152         require(reserveY1 > 0);
153         require(now >= endTGE + 31536000); /* Y+1 crowdsale can only start after a year */
154         crowdsale = _crowdsale;
155         balances[crowdsale] = reserveY1;
156         balances[address(0)] -= reserveY1;
157         emit Transfer(address(0), crowdsale, reserveY1);
158         reserveY1 = 0;
159     }
160 
161     function startCrowdsaleY2(address _crowdsale) onlyBy(owner) public {
162         require(_crowdsale != address(0));
163         require(crowdsale == address(0));
164         require(reserveY2 > 0);
165         require(now >= endTGE + 63072000); /* Y+2 crowdsale can only start after 2 years */
166         crowdsale = _crowdsale;
167         balances[crowdsale] = reserveY2;
168         balances[address(0)] -= reserveY2;
169         emit Transfer(address(0), crowdsale, reserveY2);
170         reserveY2 = 0;
171     }
172 
173     // in practice later than end of TGE to let people withdraw
174     function endCrowdsale() onlyBy(owner) public {
175         require(crowdsale != address(0));
176         require(now > endTGE);
177         reserveY2 += balances[crowdsale];
178         emit Transfer(crowdsale, address(0), balances[crowdsale]);
179         balances[address(0)] += balances[crowdsale];
180         balances[crowdsale] = 0;
181         crowdsale = address(0);
182     }
183 
184     /* coupon campaign factory */
185 
186     address public factory;
187 
188     function setFactory(address _factory) onlyBy(owner) public {
189         factory = _factory;
190     }
191 
192     function newCampaign(uint32 _issuance, uint256 _value) public {
193         transfer(factory,_value);
194         require(factory.call(bytes4(keccak256("createCampaign(address,uint32,uint256)")),msg.sender,_issuance,_value));
195     }
196 
197     event Burn(address indexed burner, uint256 value);
198 
199     function burn(uint256 _value) public returns (bool success) {
200         require(_value > 0);
201         require(balances[msg.sender] >= _value);
202         balances[msg.sender] -= _value;
203         totalSupply -= _value;
204         emit Transfer(msg.sender, address(0), _value);
205         emit Burn(msg.sender, _value);
206         return true;
207     }
208 
209 }