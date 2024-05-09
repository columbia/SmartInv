1 pragma solidity ^0.4.8;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Token {
30 
31     /* This is a slight change to the ERC20 base standard.
32     function totalSupply() constant returns (uint256 supply);
33     is replaced with:
34     uint256 public totalSupply;
35     This automatically creates a getter function for the totalSupply.
36     This is moved to the base contract since public getter functions are not
37     currently recognised as an implementation of the matching abstract
38     function by the compiler.
39     */
40     /// total amount of tokens
41     uint256 public totalSupply;
42 
43     /// @param _owner The address from which the balance will be retrieved
44     /// @return The balance
45     function balanceOf(address _owner) constant returns (uint256 balance);
46 
47     /// @notice send `_value` token to `_to` from `msg.sender`
48     /// @param _to The address of the recipient
49     /// @param _value The amount of token to be transferred
50     /// @return Whether the transfer was successful or not
51     function transfer(address _to, uint256 _value) returns (bool success);
52 
53     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
54     /// @param _from The address of the sender
55     /// @param _to The address of the recipient
56     /// @param _value The amount of token to be transferred
57     /// @return Whether the transfer was successful or not
58     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
59 
60     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
61     /// @param _spender The address of the account able to transfer the tokens
62     /// @param _value The amount of tokens to be approved for transfer
63     /// @return Whether the approval was successful or not
64     function approve(address _spender, uint256 _value) returns (bool success);
65 
66     /// @param _owner The address of the account owning tokens
67     /// @param _spender The address of the account able to transfer the tokens
68     /// @return Amount of remaining tokens allowed to spent
69     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
70 
71     event Transfer(address indexed _from, address indexed _to, uint256 _value);
72     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
73 }
74 
75 contract StandardToken is Token {
76 
77     using SafeMath for uint256;
78 
79     function transfer(address _to, uint256 _value) returns (bool success) {
80        
81         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
82         if (_to == 0x0) return false;
83 	    if (balances[msg.sender] >= _value && _value > 0) {
84 	    // SafeMath.sub will throw if there is not enough balance.
85 	        balances[msg.sender] = balances[msg.sender].sub(_value);
86 	        balances[_to] = balances[_to].add(_value);
87             Transfer(msg.sender, _to, _value);
88             return true;
89         } else { return false; }
90         
91     }
92 
93     function batchTransfer(address[] _receivers, uint256 _value) public returns (bool) {
94 	    uint cnt = _receivers.length;
95 	    uint256 amount = _value.mul(uint256(cnt));
96 	
97 	    require(cnt > 0 && cnt <= 20);
98 	    require(_value > 0 && balances[msg.sender] >= amount);
99 
100 	    balances[msg.sender] = balances[msg.sender].sub(amount);
101 	    for (uint i = 0; i < cnt; i++) {
102 		    balances[_receivers[i]] = balances[_receivers[i]].add(_value);
103 		    Transfer(msg.sender, _receivers[i], _value);
104 	    }
105 	    return true;
106     }
107 
108     function transferFrom(address _from, address _to, uint256 _value) returns 
109     (bool success) {
110         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= 
111         // _value && balances[_to] + _value > balances[_to]);
112         if (_to == 0x0) return false;
113 	    if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
114             balances[_to] = balances[_to].add(_value);
115             balances[_from] = balances[_from].sub(_value);
116             //allowed[_from][msg.sender] -= _value;
117 	        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
118             Transfer(_from, _to, _value);
119             return true;
120         } else { return false; }
121     }
122     function balanceOf(address _owner) constant returns (uint256 balance) {
123         return balances[_owner];
124     }
125 
126 
127     function approve(address _spender, uint256 _value) returns (bool success)   
128     {
129         allowed[msg.sender][_spender] = _value;
130         Approval(msg.sender, _spender, _value);
131         return true;
132     }
133 
134 
135     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
136         return allowed[_owner][_spender];
137     }
138     mapping (address => uint256) balances;
139     mapping (address => mapping (address => uint256)) allowed;
140 }
141 
142 contract ThanosXToken is StandardToken { 
143       
144     /* Public variables of the token */
145     /*
146     NOTE:
147     The following variables are OPTIONAL vanities. One does not have to include them.
148     They allow one to customise the token contract & in no way influences the core functionality.
149     Some wallets/interfaces might not even bother to look at this information.
150     */
151     // metadata
152     string public   name		= "ThanosX Token";
153     string public   symbol		= "TNSX";
154     string public   version		= "0.1";
155     uint256 public  decimals	= 8;
156     uint256 public constant	MILLION		= (10**8 * 10**decimals);
157 
158     function ThanosXToken() public{
159 
160         totalSupply = 100 * MILLION;
161         balances[msg.sender] = totalSupply;     // Give the creator all initial tokens
162         
163     }
164 
165     /* Approves and then calls the receiving contract */
166     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
167         allowed[msg.sender][_spender] = _value;
168         Approval(msg.sender, _spender, _value);
169         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
170         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
171         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
172         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
173         return true;
174     }
175 
176 }