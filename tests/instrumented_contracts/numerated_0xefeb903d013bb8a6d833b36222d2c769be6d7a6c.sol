1 pragma solidity ^0.4.25;
2 
3 contract ERC20Interface {
4     // Get the total token supply
5     function totalSupply() public constant returns (uint256 tS);
6  
7     // Get the account balance of another account with address _owner
8     function balanceOf(address _owner) constant public returns (uint256 balance);
9  
10     // Send _value amount of tokens to address _to
11     function transfer(address _to, uint256 _value) public returns (bool success);
12  
13     // Send _value amount of tokens from address _from to address _to
14     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
15  
16     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
17     // If this function is called again it overwrites the current allowance with _value.
18     // this function is required for some DEX functionality
19     function approve(address _spender, uint256 _value) public returns (bool success);
20  
21     // Returns the amount which _spender is still allowed to withdraw from _owner
22     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
23 
24     // Used for burning excess tokens after ICO.
25     function burnExcess(uint256 _value) public returns (bool success);
26  
27     // Used for burning excess tokens after ICO.
28     function transferWithFee(address _to, uint256 _value, uint256 _fee) public returns (bool success);
29 
30     // Triggered when tokens are transferred.
31     event Transfer(address indexed _from, address indexed _to, uint256 _value);
32  
33     // Triggered whenever approve(address _spender, uint256 _value) is called.
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35 
36     // Triggered whenever tokens are destroyed
37     event Burn(address indexed from, uint256 value);
38 
39     // Triggered when tokens are transferred.
40     event TransferWithFee(address indexed _from, address indexed _to, uint256 _value, uint256 _fee);
41 
42 }
43  
44 contract ESOSToken is ERC20Interface {
45 
46     string public constant symbol = "ESOS";
47     string public constant name = "Eso Token";
48     uint8 public constant decimals = 18;
49     uint256 _totalSupply = 70000000 * 10 ** uint256(decimals);
50     
51     address public owner;
52 
53     mapping(address => uint256) balances;
54  
55     mapping(address => mapping (address => uint256)) allowed;
56 
57     //constructor
58     constructor() public {
59         owner = msg.sender;
60         balances[owner] = _totalSupply;
61     }
62 
63     // Handle ether mistakenly sent to contract
64     function () public payable {
65       if (msg.value > 0) {
66           if (!owner.send(msg.value)) revert();
67       }
68     }
69 
70     // Get the total token supply
71     function totalSupply() public constant returns (uint256 tS) {
72         tS = _totalSupply;
73     }
74  
75     // What is the balance of a particular account?
76     function balanceOf(address _owner) public constant returns (uint256 balance) {
77         return balances[_owner];
78     }
79  
80     // Transfer the balance from owner's account to another account
81     function transfer(address _to, uint256 _amount) public returns (bool success) {
82         if (balances[msg.sender] >= _amount 
83             && _amount > 0
84             && balances[_to] + _amount > balances[_to]) {
85             balances[msg.sender] -= _amount;
86             balances[_to] += _amount;
87             emit Transfer(msg.sender, _to, _amount);
88             return true;
89         } else {
90             return false;
91         }
92     }
93  
94     // Send _value amount of tokens from address _from to address _to
95     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
96     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
97     // fees in sub-currencies; the command should fail unless the _from account has
98     // deliberately authorized the sender of the message via some mechanism; we propose
99     // these standardized APIs for approval:
100     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
101         if (balances[_from] >= _amount
102             && allowed[_from][msg.sender] >= _amount
103             && _amount > 0
104             && balances[_to] + _amount > balances[_to]) {
105             balances[_from] -= _amount;
106             allowed[_from][msg.sender] -= _amount;
107             balances[_to] += _amount;
108             emit Transfer(_from, _to, _amount);
109             return true;
110         } else {
111             return false;
112         }
113     }
114  
115     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
116     // If this function is called again it overwrites the current allowance with _value.
117     function approve(address _spender, uint256 _amount) public returns (bool success) {
118         allowed[msg.sender][_spender] = _amount;
119         emit Approval(msg.sender, _spender, _amount);
120         return true;
121     }
122  
123     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
124         return allowed[_owner][_spender];
125     }
126 
127     // Used for burning excess tokens after ICO.
128     function burnExcess(uint256 _value) public returns (bool success) {
129         require(balanceOf(msg.sender) >= _value && msg.sender == owner && _value > 0);
130         balances[msg.sender] -= _value;
131         _totalSupply -= _value;
132         emit Burn(msg.sender, _value);
133         return true;
134     }
135 
136     // Transfer the balance from owner's account to another account plus a fee to the contract owner owner
137     function transferWithFee(address _to, uint256 _amount, uint256 _fee) public returns (bool success) {
138         if (balances[msg.sender] >= _amount + _fee
139             && _amount > 0
140             && _fee > 0
141             && balances[_to] + _amount > balances[_to]) {
142             balances[msg.sender] -= _amount + _fee;
143             balances[_to] += _amount;
144             balances[owner] += _fee;
145             emit TransferWithFee(msg.sender, _to, _amount, _fee);
146             return true;
147         } else {
148             return false;
149         }
150     }
151 }