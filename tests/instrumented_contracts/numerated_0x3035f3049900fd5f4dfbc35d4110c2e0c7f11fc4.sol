1 // Congratulations! It's your free MoneyToken Promo Token
2 // More about project at MoneyToken.Com
3 // Register to receive your bonus
4 
5 //  ███╗   ███╗ ██████╗ ███╗   ██╗███████╗██╗   ██╗████████╗ ██████╗ ██╗  ██╗███████╗███╗   ██╗    ██████╗ ██████╗ ███╗   ███╗
6 //  ████╗ ████║██╔═══██╗████╗  ██║██╔════╝╚██╗ ██╔╝╚══██╔══╝██╔═══██╗██║ ██╔╝██╔════╝████╗  ██║   ██╔════╝██╔═══██╗████╗ ████║
7 //  ██╔████╔██║██║   ██║██╔██╗ ██║█████╗   ╚████╔╝    ██║   ██║   ██║█████╔╝ █████╗  ██╔██╗ ██║   ██║     ██║   ██║██╔████╔██║
8 //  ██║╚██╔╝██║██║   ██║██║╚██╗██║██╔══╝    ╚██╔╝     ██║   ██║   ██║██╔═██╗ ██╔══╝  ██║╚██╗██║   ██║     ██║   ██║██║╚██╔╝██║
9 //  ██║ ╚═╝ ██║╚██████╔╝██║ ╚████║███████╗   ██║      ██║   ╚██████╔╝██║  ██╗███████╗██║ ╚████║██╗╚██████╗╚██████╔╝██║ ╚═╝ ██║
10 //  ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝   ╚═╝      ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝╚═╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝
11                                                                                                                            
12 
13 // Platform Launched at account.moneytoken.com and available for crypto-backed loans
14 // Roger Ver, founder of Bitcoin.com, joined the MoneyToken advisory board
15 // Private Sale results: $1.5 million raised in contributions
16 // Pre-Sale results so far: over $4.5 million raised
17 // Community reach: more than 10,000 users join MoneyToken’s Telegram channel and subscribe to MoneyToken’s official Twitter account
18 
19 // The Soft Cap target has already been passed, and the Hard Cap target is in sight.
20 
21 
22 pragma solidity ^0.4.18;
23 
24 contract IMTMoneyTokenPromoInterface {
25     /* This is a slight change to the ERC20 base standard.
26     function totalSupply() constant returns (uint256 supply);
27     is replaced with:
28     uint256 public totalSupply;
29     This automatically creates a getter function for the totalSupply.
30     This is moved to the base contract since public getter functions are not
31     currently recognised as an implementation of the matching abstract
32     function by the compiler.
33     */
34     /// total amount of tokens
35     uint256 public totalSupply;
36 
37     /// @param _owner The address from which the balance will be retrieved
38     /// @return The balance
39     function balanceOf(address _owner) public view returns (uint256 balance);
40 
41     /// @notice send `_value` token to `_to` from `msg.sender`
42     /// @param _to The address of the recipient
43     /// @param _value The amount of token to be transferred
44     /// @return Whether the transfer was successful or not
45     function transfer(address _to, uint256 _value) public returns (bool success);
46 
47     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
48     /// @param _from The address of the sender
49     /// @param _to The address of the recipient
50     /// @param _value The amount of token to be transferred
51     /// @return Whether the transfer was successful or not
52     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
53 
54     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
55     /// @param _spender The address of the account able to transfer the tokens
56     /// @param _value The amount of tokens to be approved for transfer
57     /// @return Whether the approval was successful or not
58     function approve(address _spender, uint256 _value) public returns (bool success);
59 
60     /// @param _owner The address of the account owning tokens
61     /// @param _spender The address of the account able to transfer the tokens
62     /// @return Amount of remaining tokens allowed to spent
63     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
64 
65     // solhint-disable-next-line no-simple-event-func-name  
66     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
67     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
68 }
69 contract MoneyTokenPromo is IMTMoneyTokenPromoInterface {
70 
71     uint256 constant private MAX_UINT256 = 2**256 - 1;
72     mapping (address => uint256) public balances;
73     mapping (address => mapping (address => uint256)) public allowed;
74     /*
75     NOTE:
76     The following variables are OPTIONAL vanities. One does not have to include them.
77     They allow one to customise the token contract & in no way influences the core functionality.
78     Some wallets/interfaces might not even bother to look at this information.
79     */
80     string public name;                   //fancy name: eg Simon Bucks
81     uint8 public decimals;                //How many decimals to show.
82     string public symbol;                 //An identifier: eg SBX
83 
84     function MoneyTokenPromo(
85         uint256 _initialAmount,
86         string _tokenName,
87         uint8 _decimalUnits,
88         string _tokenSymbol
89     ) public {
90         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
91         totalSupply = _initialAmount;                        // Update total supply
92         name = _tokenName;                                   // Set the name for display purposes
93         decimals = _decimalUnits;                            // Amount of decimals for display purposes
94         symbol = _tokenSymbol;                               // Set the symbol for display purposes
95     }
96 
97     function transfer(address _to, uint256 _value) public returns (bool success) {
98         require(balances[msg.sender] >= _value);
99         balances[msg.sender] -= _value;
100         balances[_to] += _value;
101         Transfer(msg.sender, _to, _value);
102         return true;
103     }
104 
105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
106         uint256 allowance = allowed[_from][msg.sender];
107         require(balances[_from] >= _value && allowance >= _value);
108         balances[_to] += _value;
109         balances[_from] -= _value;
110         if (allowance < MAX_UINT256) {
111             allowed[_from][msg.sender] -= _value;
112         }
113         Transfer(_from, _to, _value);
114         return true;
115     }
116 
117     function balanceOf(address _owner) public view returns (uint256 balance) {
118         return balances[_owner];
119     }
120 
121     function approve(address _spender, uint256 _value) public returns (bool success) {
122         allowed[msg.sender][_spender] = _value;
123         Approval(msg.sender, _spender, _value);
124         return true;
125     }
126 
127     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
128         return allowed[_owner][_spender];
129     }   
130 }