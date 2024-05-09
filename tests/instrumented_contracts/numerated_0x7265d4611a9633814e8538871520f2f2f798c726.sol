1 /*
2 Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
3 .*/
4 
5 pragma solidity ^0.4.21;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a / b;
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 contract ForeignToken {
36     function balanceOf(address _owner) constant public returns (uint256);
37     function transfer(address _to, uint256 _value) public returns (bool);
38 }
39 
40 // Abstract contract for the full ERC-20 Token standard
41 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
42 contract ARCInterface {
43     /* This is a slight change to the ERC20 base standard.
44     function totalSupply() constant returns (uint256 supply);
45     is replaced with:
46     uint256 public totalSupply;
47     This automatically creates a getter function for the totalSupply.
48     This is moved to the base contract since public getter functions are not
49     currently recognised as an implementation of the matching abstract
50     function by the compiler.
51     */
52     /// total amount of tokens
53     uint256 public totalSupply;
54 
55     /// @param _owner The address from which the balance will be retrieved
56     /// @return The balance
57     function balanceOf(address _owner) public view returns (uint256 balance);
58 
59     /// @notice send `_value` token to `_to` from `msg.sender`
60     /// @param _to The address of the recipient
61     /// @param _value The amount of token to be transferred
62     /// @return Whether the transfer was successful or not
63     function transfer(address _to, uint256 _value) public returns (bool success);
64 
65     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
66     /// @param _from The address of the sender
67     /// @param _to The address of the recipient
68     /// @param _value The amount of token to be transferred
69     /// @return Whether the transfer was successful or not
70     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
71 
72     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
73     /// @param _spender The address of the account able to transfer the tokens
74     /// @param _value The amount of tokens to be approved for transfer
75     /// @return Whether the approval was successful or not
76     function approve(address _spender, uint256 _value) public returns (bool success);
77 
78     /// @param _owner The address of the account owning tokens
79     /// @param _spender The address of the account able to transfer the tokens
80     /// @return Amount of remaining tokens allowed to spent
81     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
82 
83     // solhint-disable-next-line no-simple-event-func-name
84     event Transfer(address indexed _from, address indexed _to, uint256 _value);
85     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
86 }
87 
88 
89 contract ARCI is ARCInterface {
90 
91 	using SafeMath for uint256;
92 	address owner = msg.sender;
93 	
94     uint256 constant private MAX_UINT256 = 2**256 - 1;
95     mapping (address => uint256) public balances;
96     mapping (address => mapping (address => uint256)) public allowed;
97     /*
98     NOTE:
99     The following variables are OPTIONAL vanities. One does not have to include them.
100     They allow one to customise the token contract & in no way influences the core functionality.
101     Some wallets/interfaces might not even bother to look at this information.
102     */
103     string public name;
104     uint256 public decimals;
105     string public symbol;
106 	
107     function ARCI(
108         uint256 _initialAmount,
109         uint256 _decimalUnits,
110         string _tokenName,
111         string _tokenSymbol
112     ) public {
113         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
114         totalSupply = _initialAmount;                        // Update total supply
115         decimals = _decimalUnits;                            // Amount of decimals for display purposes
116         name = _tokenName;                                   // Set the name for display purposes
117         symbol = _tokenSymbol;                               // Set the symbol for display purposes
118     }
119 
120     function transfer(address _to, uint256 _value) public returns (bool success) {
121         require(balances[msg.sender] >= _value);
122         balances[msg.sender] -= _value;
123         balances[_to] += _value;
124         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
125         return true;
126     }
127 
128     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
129         uint256 allowance = allowed[_from][msg.sender];
130         require(balances[_from] >= _value && allowance >= _value);
131         balances[_to] += _value;
132         balances[_from] -= _value;
133         if (allowance < MAX_UINT256) {
134             allowed[_from][msg.sender] -= _value;
135         }
136         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
137         return true;
138     }
139 
140     function balanceOf(address _owner) public view returns (uint256 balance) {
141         return balances[_owner];
142     }
143 	
144 	/**
145    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
146    * @param _spender The address which will spend the funds.
147    * @param _value The amount of tokens to be spent.
148    */
149     function approve(address _spender, uint256 _value) public returns (bool success) {
150         allowed[msg.sender][_spender] = _value;
151         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
152         return true;
153     }
154 
155 	/**
156    * @dev Function to check the amount of tokens that an owner allowed to a spender.
157    * @param _owner address The address which owns the funds.
158    * @param _spender address The address which will spend the funds.
159    * @return A uint256 specifing the amount of tokens still avaible for the spender.
160    */
161     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
162         return allowed[_owner][_spender];
163     }
164 	
165 	function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
166         ForeignToken t = ForeignToken(tokenAddress);
167         uint bal = t.balanceOf(who);
168         return bal;
169     }
170 	
171 	/**
172      * @dev Throws if called by any account other than the owner.
173      */
174     modifier onlyOwner() {
175         require(msg.sender == owner);
176         _;
177     }
178 	
179 	/**
180       * @dev Allows the current owner to transfer control of the contract to a newOwner.
181       * @param newOwner The address to transfer ownership to.
182       */
183     function transferOwnership(address newOwner) onlyOwner public {
184         if (newOwner != address(0)) {
185             owner = newOwner;
186         }
187     }
188 	
189 	function withdraw() onlyOwner public {
190         uint256 etherBalance = address(this).balance;
191         owner.transfer(etherBalance);
192     }
193 	
194 	function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
195         ForeignToken token = ForeignToken(_tokenContract);
196         uint256 amount = token.balanceOf(address(this));
197         return token.transfer(owner, amount);
198     }
199 }