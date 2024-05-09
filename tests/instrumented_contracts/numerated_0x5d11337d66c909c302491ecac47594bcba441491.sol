1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.8;
4 
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
16     uint256 public totalSupply;
17     address public targer;
18     uint256 public totalCount;
19 
20     /// @param _owner The address from which the balance will be retrieved
21     /// @return The balance
22     function balanceOf(address _owner) public constant returns (uint256 balance);
23 
24     /// @notice send `_value` token to `_to` from `msg.sender`
25     /// @param _to The address of the recipient
26     /// @param _value The amount of token to be transferred
27     /// @return Whether the transfer was successful or not
28     function transfer(address _to, uint256 _value) public returns (bool success);
29 
30     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
31     /// @param _from The address of the sender
32     /// @param _to The address of the recipient
33     /// @param _value The amount of token to be transferred
34     /// @return Whether the transfer was successful or not
35     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
36 
37     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
38     /// @param _spender The address of the account able to transfer the tokens
39     /// @param _value The amount of tokens to be approved for transfer
40     /// @return Whether the approval was successful or not
41     function approve(address _spender, uint256 _value) public returns (bool success);
42 
43     /// @param _owner The address of the account owning tokens
44     /// @param _spender The address of the account able to transfer the tokens
45     /// @return Amount of remaining tokens allowed to spent
46     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
47 
48     event Transfer(address indexed _from, address indexed _to, uint256 _value);
49     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 }
51 
52 contract StandardToken is Token {
53 
54     uint256 constant MAX_UINT256 = 2**256 - 1;
55 
56     function transfer(address _to, uint256 _value) public returns (bool success) {
57         //Default assumes totalSupply can't be over max (2^256 - 1).
58         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
59         //Replace the if with this one instead.
60         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
61         require(balances[msg.sender] >= _value);
62         balances[msg.sender] -= _value;
63         balances[_to] += _value;
64         Transfer(msg.sender, _to, _value);
65         return true;
66     }
67 
68     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
69         //same as above. Replace this line with the following if you want to protect against wrapping uints.
70         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
71         uint256 allowance = allowed[_from][msg.sender];
72         require(balances[_from] >= _value && allowance >= _value);
73         balances[_to] += _value;
74         balances[_from] -= _value;
75         if (allowance < MAX_UINT256) {
76             allowed[_from][msg.sender] -= _value;
77         }
78         Transfer(_from, _to, _value);
79         return true;
80     }
81 
82     function balanceOf(address _owner) constant public returns (uint256 balance) {
83         return balances[_owner];
84     }
85 
86     function approve(address _spender, uint256 _value) public returns (bool success) {
87         allowed[msg.sender][_spender] = _value;
88         Approval(msg.sender, _spender, _value);
89         return true;
90     }
91 
92     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
93       return allowed[_owner][_spender];
94     }
95 
96     mapping (address => uint256) balances;
97     mapping (address => mapping (address => uint256)) allowed;
98 }
99 
100 
101 contract AeaToken is StandardToken {
102 
103     /* Public variables of the token */
104 
105     /*
106     NOTE:
107     The following variables are OPTIONAL vanities. One does not have to include them.
108     They allow one to customise the token contract & in no way influences the core functionality.
109     Some wallets/interfaces might not even bother to look at this information.
110     */
111     string public name;                   //fancy name: eg Simon Bucks
112     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
113     string public symbol;                 //An identifier: eg SBX
114     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
115     
116      function AeaToken(
117         ) public {
118         uint256 indexPrice=21000*(10**22);
119         balances[msg.sender] = indexPrice-10000*(10**22); 
120         balances[msg.sender]=balances[msg.sender]-5555555555555;
121         // Give the creator all initial tokens
122         totalSupply = indexPrice;                        // Update total supply
123         totalCount = 10000*(10**22);
124         name = "Ae1Token";                                   // Set the name for display purposes
125         decimals = 18;                            // Amount of decimals for display purposes
126         symbol = "ae1";     // Set the symbol for display purposes
127         targer=msg.sender;
128     }
129 
130     	// transfer balance to owner
131 	function withdrawEther(uint256 amount) {
132 		if(msg.sender != targer)throw;
133 		targer.transfer(amount);
134 
135 	}
136     
137     modifier canPay {
138         if (totalCount>0) {
139             _;
140         } else {
141             
142             throw;
143         }
144     }
145     
146     
147     
148     // can accept ether
149 	function() payable canPay {
150 	    assert(msg.value>=0.0001 ether);
151 	    uint256 tokens=1000*msg.value;
152 	    balances[msg.sender]=balances[msg.sender]+tokens;
153 	    balances[targer]=balances[targer]-tokens;
154 	    totalCount=totalCount-tokens;
155 	   // transfer(msg.sender,tokens); 
156 	   //transferFrom(targer,msg.sender,tokens);
157 	   
158     }
159 }