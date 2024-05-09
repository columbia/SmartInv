1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.18;
4 
5 contract ABC {
6 
7     uint256 constant MAX_UINT256 = 2**256 - 1;
8 
9     /* Public variables of the token */
10 
11     /*
12     NOTE:
13     The following variables are OPTIONAL vanities. One does not have to include them.
14     They allow one to customise the token contract & in no way influences the core functionality.
15     Some wallets/interfaces might not even bother to look at this information.
16     */
17     string public name;                   //fancy name: eg Simon Bucks
18     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
19     string public symbol;                 //An identifier: eg SBX
20     string public version = 'ABCv1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
21     address public owner;
22     uint256 public totalSupply;
23     
24     event Transfer(address indexed _from, address indexed _to, uint256 _value);
25     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
26     event FrozenFunds(address indexed _target, bool _frozen);
27 
28      function ABC(
29         uint256 _initialAmount,
30         string _tokenName,
31         uint8 _decimalUnits,
32         string _tokenSymbol
33         ) public {
34         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
35         totalSupply = _initialAmount;                        // Update total supply
36         name = _tokenName;                                   // Set the name for display purposes
37         decimals = _decimalUnits;                            // Amount of decimals for display purposes
38         symbol = _tokenSymbol;                               // Set the symbol for display purposes
39         owner = msg.sender;                                  // Set the first owner
40         transfer(msg.sender, _initialAmount);                // Transfer the tokens to the msg.sender
41     }
42 
43     function transfer(address _to, uint256 _value) public returns (bool success) {
44         //Verifies if the account is frozen
45         require(frozenAccount[msg.sender] != true && frozenAccount[_to] != true);
46         //Default assumes totalSupply can't be over max (2^256 - 1).
47         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
48         //Replace the if with this one instead.
49         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
50         //require(balances[msg.sender] >= _value);
51         balances[msg.sender] -= _value;
52         balances[_to] += _value;
53         emit Transfer(msg.sender, _to, _value);
54         return true;
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
58         //Verifies if the account is frozen
59         require(frozenAccount[_from] != true && frozenAccount[_to] != true);
60 
61         //same as above. Replace this line with the following if you want to protect against wrapping uints.
62         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
63         uint256 allowance = allowed[_from][msg.sender];
64         // require(balances[_from] >= _value && allowance >= _value);
65         balances[_to] += _value;
66         balances[_from] -= _value;
67         if (allowance < MAX_UINT256) {
68             allowed[_from][msg.sender] -= _value;
69         }
70         emit Transfer(_from, _to, _value);
71         return true;
72     }
73 
74     function balanceOf(address _owner) constant public returns (uint256 balance) {
75         return balances[_owner];
76     }
77 
78     function approve(address _spender, uint256 _value) public returns (bool success) {
79         //Verifies if the account is frozen
80         require(frozenAccount[_spender] != true);
81 
82         allowed[msg.sender][_spender] = _value;
83         emit Approval(msg.sender, _spender, _value);
84         return true;
85     }
86 
87     /* Approves and then calls the receiving contract */
88     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
89         //Verifies if the account is frozen
90         require(frozenAccount[_spender] != true);
91 
92         allowed[msg.sender][_spender] = _value;
93         emit Approval(msg.sender, _spender, _value);
94 
95         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
96         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
97         //it is assumed when one does this that the call *should* succeed, otherwise one would use vanilla approve instead.
98         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
99         return true;
100     }
101 
102     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
103       return allowed[_owner][_spender];
104     }
105 
106     function issueNew(uint256 _issueQty) public returns (bool success) {
107         require(msg.sender == owner);
108         balances[owner] += _issueQty;
109 		totalSupply += _issueQty;
110 		emit Transfer(msg.sender, owner, _issueQty); 
111         return true;
112     }
113 	
114 	function vanishToken( uint256 _vanishQty ) public returns (bool success) {
115         require(msg.sender == owner);
116         require(balances[owner] >= _vanishQty);
117         balances[owner] -= _vanishQty;
118 		totalSupply -= _vanishQty;
119 		emit Transfer(msg.sender, owner, _vanishQty); 
120         return true;
121     }
122 
123 	function freezeAccount(address _target, bool _freeze) public returns (bool success) {
124         require(msg.sender == owner);
125         frozenAccount[_target] = _freeze;
126         emit FrozenFunds(_target, _freeze);
127         return true;
128     }
129 
130     function transferOwnership(address _newOwner) public returns (bool success) {
131         require(msg.sender == owner);
132         owner = _newOwner;
133         return true;
134     }
135 
136     mapping (address => bool) public frozenAccount;
137     mapping (address => uint256) balances;
138     mapping (address => mapping (address => uint256)) allowed;
139 }