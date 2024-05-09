1 // File: contracts/SafeMath.sol
2 pragma solidity ^0.4.8;
3 contract SafeMath {
4     function safeAdd(uint256 _x, uint256 _y) internal returns(uint256) {
5       uint256 z = _x + _y;
6       assert((z >= _x) && (z >= _y));
7       return z;
8     }
9     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
10         assert(_x >= _y);
11         return _x - _y;
12     }
13 }
14 // File: contracts/ERC20Interface.sol
15 pragma solidity ^0.4.8;
16 // ERC Token Standard #20 Interface
17 // https://github.com/ethereum/EIPs/issues/20
18 contract ERC20Interface {
19     /* -------------Function----------------------------*/
20     // Get the total token supply
21     function totalSupply() public constant returns (uint256 _totalSupply);
22      // Get the account balance of another account with address _owner
23     function balanceOf(address _owner) public constant returns (uint256 balance);
24      // Send _value amount of tokens to address _to
25     function transfer(address _to, uint256 _value) public returns (bool success);
26      // Send _value amount of tokens from address _from to address _to
27     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
28      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
29     // If this function is called again it overwrites the current allowance with _value.
30     // this function is required for some DEX functionality
31     function approve(address _spender, uint256 _value) public returns (bool success);
32      // Returns the amount which _spender is still allowed to withdraw from _owner
33     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
34     /* -------------Event----------------------------*/
35      // Triggered when tokens are transferred.
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37      // Triggered whenever approve(address _spender, uint256 _value) is called.
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 }
40 // File: contracts/StandardToken.sol
41 pragma solidity ^0.4.8;
42 contract StandardToken is ERC20Interface, SafeMath{
43     /* Public variables of the token */
44     string  public name;
45     string  public symbol;
46     uint8   public decimals;
47     uint256 internal total;
48     /* This creates an array with all balances */
49     mapping (address => uint256) balances;
50     /* This creates an array with all allowance */
51     mapping (address => mapping (address => uint256)) allowed;
52     //
53     function totalSupply() public constant returns (uint256 _totalSupply) {
54         _totalSupply = total;
55     }
56     // @_owner
57     function balanceOf(address _owner) public constant returns (uint256 balance) {
58         balance = balances[_owner];
59     }
60     /// @notice Send `_value` tokens to `_to` from your account
61     /// @param _to The address of the recipient
62     /// @param _value the amount to send
63     function transfer(address _to, uint256 _value) public returns (bool success){
64         if (
65             balances[msg.sender] >= _value &&
66             _value > 0 &&
67             balances[_to] + _value > balances[_to]
68         ) {
69             //
70             balances[msg.sender] = safeSub(balances[msg.sender],_value);
71             balances[_to] = safeAdd(balances[_to], _value);
72             // Event
73             Transfer(msg.sender, _to, _value);
74             return true;
75         } else {
76             return false;
77         }
78     }
79     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
80     /// @param _from The address of the sender
81     /// @param _to The address of the recipient
82     /// @param _value the amount to send
83     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
84         if (balances[_from] >= _value
85             && allowed[_from][msg.sender] >= _value
86             && _value > 0
87             && balances[_to] + _value > balances[_to]) {
88             //
89             balances[_from] = safeSub(balances[_from],_value);
90             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);
91             balances[_to] = safeAdd(balances[_to],_value);
92             // Event
93             Transfer(_from, _to, _value);
94             return true;
95         } else {
96             return false;
97         }
98     }
99     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
100     /// @param _spender The address authorized to spend
101     /// @param _value the max amount they can spend
102     function approve(address _spender, uint256 _value) public returns (bool success) {
103         allowed[msg.sender][_spender] = _value;
104         // Event
105         Approval(msg.sender, _spender, _value);
106         return true;
107     }
108     // @notice
109     // @param _owner
110     // @param _spender
111     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
112         return allowed[_owner][_spender];
113     }
114 }
115 // File: contracts/ICO_Token.sol
116 pragma solidity ^0.4.8;
117 contract ICO_Token is StandardToken {
118     /* Initializes contract with initial supply tokens to the creator of the contract */
119     function ICO_Token (
120         uint256 initialSupply,
121         string tokenName,
122         uint8 decimalUnits,
123         string tokenSymbol
124         ) public {
125         balances[msg.sender] = initialSupply;              // Give the creator all initial tokens
126         total = initialSupply;                        // Update total supply
127         name = tokenName;                                   // Set the name for display purposes
128         symbol = tokenSymbol;                               // Set the symbol for display purposes
129         decimals = decimalUnits;                            // Amount of decimals for display purposes
130     }
131 }