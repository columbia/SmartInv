1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6 
7  */
8 contract ERC20Interface {
9     // Get the total token supply
10     function totalSupply() constant public returns (uint256 totalSupplyTokens);
11 
12     // Get the account balance of another account with address _owner
13     function balanceOf(address _owner) constant public returns (uint256 balance);
14 
15     // Send _value amount of tokens to address _to
16     function transfer(address _to, uint256 _value) public returns (bool success);
17 
18     // Send _value amount of tokens from address _from to address _to
19     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
20 
21     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
22     // If this function is called again it overwrites the current allowance with _value.
23     // this function is required for some DEX functionality
24     function approve(address _spender, uint256 _value) public returns (bool success);
25 
26     // Returns the amount which _spender is still allowed to withdraw from _owner
27     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
28 
29     // Triggered when tokens are transferred.
30     event Transfer(address indexed _from, address indexed _to, uint256 _value);
31 
32     // Triggered whenever approve(address _spender, uint256 _value) is called.
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 }
35 
36 contract StandardToken is ERC20Interface {
37 
38     // Balances for each account
39     mapping (address => uint256) balances;
40 
41     //Total Supply
42     uint256 public totalSupply;
43 
44     // Owner of this contract
45     address public owner;
46     
47     // Owner of account approves the transfer of an amount to another account
48     mapping (address => mapping (address => uint256)) allowed;
49 
50     // Functions with this modifier can only be executed by the owner
51     modifier onlyOwner() {
52         require(msg.sender==owner);
53         _;
54     }
55 
56     function totalSupply() constant public returns (uint256 totalSupplyTokens) {
57         totalSupplyTokens = totalSupply;
58     }
59 
60     // What is the balance of a particular account?
61     function balanceOf(address _owner) constant public returns (uint256 balance) {
62         return balances[_owner];
63     }
64 
65     // Transfer the balance from owner's account to another account
66     function transfer(address _to, uint256 _amount) public returns (bool success) {
67         if (balances[msg.sender] >= _amount
68         && _amount > 0
69         && balances[_to] + _amount > balances[_to]) {
70             balances[msg.sender] -= _amount;
71             balances[_to] += _amount;
72             Transfer(msg.sender, _to, _amount);
73             return true;
74         }
75         else {
76             return false;
77         }
78     }
79 
80     // Send _value amount of tokens from address _from to address _to
81     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
82     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
83     // fees in sub-currencies; the command should fail unless the _from account has
84     // deliberately authorized the sender of the message via some mechanism; we propose
85     // these standardized APIs for approval:
86     function transferFrom(
87     address _from,
88     address _to,
89     uint256 _amount
90     ) public returns (bool success) {
91         if (balances[_from] >= _amount
92         && allowed[_from][msg.sender] >= _amount
93         && _amount > 0
94         && balances[_to] + _amount > balances[_to]) {
95             balances[_from] -= _amount;
96             allowed[_from][msg.sender] -= _amount;
97             balances[_to] += _amount;
98             Transfer(_from, _to, _amount);
99             return true;
100         }
101         else {
102             return false;
103         }
104     }
105 
106 
107     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
108     // If this function is called again it overwrites the current allowance with _value.
109     function approve(address _spender, uint256 _amount) public returns (bool success) {
110         allowed[msg.sender][_spender] = _amount;
111         Approval(msg.sender, _spender, _amount);
112         return true;
113     }
114 
115     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
116         return allowed[_owner][_spender];
117     }
118 
119 }
120 
121 contract GoldPhoenixToken is StandardToken {
122 
123      function () public{
124         //if ether is sent to this address, send it back.
125         revert();
126     }
127 
128     string public name;                   //Name of the token
129     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
130     string public symbol;                 //An identifier: eg GPHX
131     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
132 
133 
134     function GoldPhoenixToken() public {
135         owner = msg.sender;
136         totalSupply = 10000000000000000;
137         balances[owner] = totalSupply;
138         name = "GOLD PHOENIX";
139         symbol = "GPHX";
140         decimals = 8;
141     }
142 
143     /* Approves and then calls the receiving contract */
144     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
145         allowed[msg.sender][_spender] = _value;
146         Approval(msg.sender, _spender, _value);
147 
148         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
149         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
150         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
151         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
152         return true;
153     }
154 }