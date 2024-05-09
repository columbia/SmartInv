1 pragma solidity ^0.4.18;
2 
3 /// Abstract contract for the full ERC 20 Token standard
4 /// https://github.com/ethereum/EIPs/issues/20
5 contract Token {
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
16     //uint256 public totalSupply;
17     function totalSupply() constant returns (uint256 supply);
18 
19     /// @param _owner The address from which the balance will be retrieved
20     /// @return The balance
21     function balanceOf(address _owner) constant returns (uint256 balance);
22 
23     /// @notice send `_value` token to `_to` from `msg.sender`
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transfer(address _to, uint256 _value) returns (bool success);
28 
29     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30     /// @param _from The address of the sender
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
35 
36     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @param _value The amount of wei to be approved for transfer
39     /// @return Whether the approval was successful or not
40     function approve(address _spender, uint256 _value) returns (bool success);
41 
42     /// @param _owner The address of the account owning tokens
43     /// @param _spender The address of the account able to transfer the tokens
44     /// @return Amount of remaining tokens allowed to spent
45     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
46 
47     event Transfer(address indexed _from, address indexed _to, uint256 _value);
48     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49 }
50 
51 /// PostDragon token, ERC20 compliant
52 contract YouLongToken is Token {
53     string public symbol = "YLO";
54     string public name = "YouLongToken";       //The Token's name
55     uint8 public constant decimals = 4;           //Number of decimals of the smallest unit
56     uint256 _totalSupply = 1 * (10**9) * (10**4); // 1 Billion;
57     address owner;
58 
59     // Balances for each account
60     mapping(address => uint256) balances;
61 
62     // Owner of account approves the transfer of an amount to another account
63     mapping(address => mapping (address => uint256)) allowed;
64 
65     modifier onlyOwner() {
66       assert(msg.sender == owner);
67       _;
68     }
69 
70     modifier onlyPayloadSize(uint size) {
71       if(msg.data.length < size + 4) {
72         throw;
73       }
74       _;
75     }
76 
77     // Constructor
78     function YouLongToken() {
79         owner = msg.sender;
80         balances[msg.sender] = _totalSupply;
81     }
82 
83     // get the token total supply
84     function totalSupply() constant returns (uint256 totalSupply) {
85         return _totalSupply;
86     }
87 
88     /**
89     * @dev Gets the balance of the specified address.
90     * @param _owner The address to query the the balance of.
91     * @return An uint representing the amount owned by the passed address.
92     **/
93     function balanceOf(address _owner) constant returns (uint256 balance) {
94         return balances[_owner];
95     }
96 
97     /**
98     * @dev transfer token for a specified address
99     * @param _to The address to transfer to.
100     * @param _value The amount to be transferred.
101     **/
102     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool success) {
103         if (balances[msg.sender] >= _value
104             && _value > 0
105             && balances[_to] + _value > balances[_to]) {
106             balances[msg.sender] -= _value;
107             balances[_to] += _value;
108             Transfer(msg.sender, _to, _value);
109             return true;
110         } else {
111             return false;
112         }
113     }
114 
115     // Send _value amount of tokens from address _from to address _to
116     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
117     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
118     // fees in sub-currencies; the command should fail unless the _from account has
119     // deliberately authorized the sender of the message via some mechanism; we propose
120     // these standardized APIs for approval:
121     function transferFrom(
122         address _from,
123         address _to,
124         uint256 _amount
125     ) onlyPayloadSize(3 * 32) public returns (bool success) {
126         if (balances[_from] >= _amount
127             && allowed[_from][msg.sender] >= _amount
128             && _amount > 0
129             && balances[_to] + _amount > balances[_to]) {
130             balances[_from] -= _amount;
131             allowed[_from][msg.sender] -= _amount;
132             balances[_to] += _amount;
133             Transfer(_from, _to, _amount);
134             return true;
135         } else {
136             return false;
137         }
138     }
139 
140     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
141     // If this function is called again it overwrites the current allowance with _value.
142     function approve(address _spender, uint256 _amount) public returns (bool success) {
143         allowed[msg.sender][_spender] = _amount;
144         Approval(msg.sender, _spender, _amount);
145         return true;
146     }
147 
148     /**
149     * @dev Function to check the amount of tokens than an owner allowed to a spender.
150     * @param _owner address The address which owns the funds.
151     * @param _spender address The address which will spend the funds.
152     * @return A uint specifing the amount of tokens still avaible for the spender.
153     **/
154     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
155         return allowed[_owner][_spender];
156     }
157 }