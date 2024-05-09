1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.8;
4 
5 contract ERC20Basic {
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
17     address public target;
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
52 contract StandardToken is ERC20Basic {
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
101 contract Best1CoinToken is StandardToken {
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
115     bool public canIssue;
116      /// Emitted for each sucuessful token purchase.
117     event Issue(address addr, uint ethAmount, uint tokenAmount);
118      function Best1CoinToken(
119         ) public {
120         uint256 indexPrice=21000*(10**22);
121         balances[msg.sender] = indexPrice-10000*(10**22); 
122         // Give the creator all initial tokens
123         totalSupply = indexPrice;                        // Update total supply
124         totalCount = 10000*(10**22);
125         name = "Best1CoinToken";                                   // Set the name for display purposes
126         decimals = 18;                            // Amount of decimals for display purposes
127         symbol = "B1C";     // Set the symbol for display purposes
128         target=msg.sender;
129         canIssue=true;
130     }
131 
132     	// transfer balance to owner
133 	function withdrawEther(uint256 amount) {
134 		if(msg.sender != target)throw;
135 		target.transfer(amount);
136 
137 	}
138     
139     modifier canPay {
140         if (totalCount>0) {
141             _;
142         } else {
143             
144             throw;
145         }
146     }
147     
148     
149     
150     // can accept ether
151 	function() payable canPay {
152 	    
153 	    assert(msg.value>=0.01 ether);
154 	    if(msg.sender!=target){
155 	        uint256 tokens=1000*msg.value;
156 	        if(canIssue){
157 	            if(tokens>totalCount){
158                     balances[msg.sender] += tokens;
159                     balances[target] =balances[target]-tokens+totalCount;
160 	                totalCount=0;
161 	                canIssue=false;
162 	            }else{
163 	                balances[msg.sender]=balances[msg.sender]+tokens;
164 	                totalCount=totalCount-tokens;
165 	            }
166 	            Issue(msg.sender,msg.value,tokens);
167 	        }
168 	    }
169 	    
170 	    if (!target.send(msg.value)) {
171             throw;
172         }
173 	 
174     }
175 }