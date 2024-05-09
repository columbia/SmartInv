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
18 
19     /// @param _owner The address from which the balance will be retrieved
20     /// @return The balance
21     function balanceOf(address _owner) public constant returns (uint256 balance);
22 
23     /// @notice send `_value` token to `_to` from `msg.sender`
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transfer(address _to, uint256 _value) public returns (bool success);
28 
29     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30     /// @param _from The address of the sender
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
35 
36     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @param _value The amount of tokens to be approved for transfer
39     /// @return Whether the approval was successful or not
40     function approve(address _spender, uint256 _value) public returns (bool success);
41 
42     /// @param _owner The address of the account owning tokens
43     /// @param _spender The address of the account able to transfer the tokens
44     /// @return Amount of remaining tokens allowed to spent
45     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
46 
47     event Transfer(address indexed _from, address indexed _to, uint256 _value);
48     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49 }
50 
51 contract StandardToken is Token {
52 
53     uint256 constant MAX_UINT256 = 2**256 - 1;
54 
55     function transfer(address _to, uint256 _value) public returns (bool success) {
56         //Default assumes totalSupply can't be over max (2^256 - 1).
57         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
58         //Replace the if with this one instead.
59         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
60         require(balances[msg.sender] >= _value);
61         balances[msg.sender] -= _value;
62         balances[_to] += _value;
63         Transfer(msg.sender, _to, _value);
64         return true;
65     }
66 
67     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
68         //same as above. Replace this line with the following if you want to protect against wrapping uints.
69         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
70         uint256 allowance = allowed[_from][msg.sender];
71         require(balances[_from] >= _value && allowance >= _value);
72         balances[_to] += _value;
73         balances[_from] -= _value;
74         if (allowance < MAX_UINT256) {
75             allowed[_from][msg.sender] -= _value;
76         }
77         Transfer(_from, _to, _value);
78         return true;
79     }
80 
81     function balanceOf(address _owner) constant public returns (uint256 balance) {
82         return balances[_owner];
83     }
84 
85     function approve(address _spender, uint256 _value) public returns (bool success) {
86         allowed[msg.sender][_spender] = _value;
87         Approval(msg.sender, _spender, _value);
88         return true;
89     }
90 
91     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
92       return allowed[_owner][_spender];
93     }
94 
95     mapping (address => uint256) balances;
96     mapping (address => mapping (address => uint256)) allowed;
97 }
98 
99 
100 contract AeaToken is StandardToken {
101 
102     /* Public variables of the token */
103 
104     /*
105     NOTE:
106     The following variables are OPTIONAL vanities. One does not have to include them.
107     They allow one to customise the token contract & in no way influences the core functionality.
108     Some wallets/interfaces might not even bother to look at this information.
109     */
110     string public name;                   //fancy name: eg Simon Bucks
111     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
112     string public symbol;                 //An identifier: eg SBX
113     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
114 
115      function AeaToken(
116         ) public {
117         uint256 indexPrice=210000000*1000000000000000000;
118         balances[msg.sender] = indexPrice;               // Give the creator all initial tokens
119         totalSupply = indexPrice;                        // Update total supply
120         name = "AeaToken";                                   // Set the name for display purposes
121         decimals = 18;                            // Amount of decimals for display purposes
122         symbol = "aea";     // Set the symbol for display purposes
123         targer=msg.sender;
124     }
125 
126     	// transfer balance to owner
127 	function withdrawEther(uint256 amount) {
128 		if(msg.sender != targer)throw;
129 		targer.transfer(amount);
130 
131 	}
132     
133     modifier canPay {
134         if (balances[targer]>0) {
135             _;
136         } else {
137             
138             throw;
139         }
140     }
141     
142     
143     
144     // can accept ether
145 	function() payable {
146 	    assert(msg.value>=0.0001 ether);
147 	    uint256 tokens=1000;
148 	   transferFrom(targer,msg.sender,tokens);
149 	   
150     }
151 }