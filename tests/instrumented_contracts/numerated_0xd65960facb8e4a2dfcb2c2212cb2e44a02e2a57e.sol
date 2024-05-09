1 pragma solidity ^ 0.4.8;
2 
3 contract ERC20 {
4 
5     uint public totalSupply;
6     
7     function totalSupply() constant returns(uint totalSupply);
8 
9     function balanceOf(address who) constant returns(uint256);
10 
11     function allowance(address owner, address spender) constant returns(uint);
12 
13     function transferFrom(address from, address to, uint value) returns(bool ok);
14 
15     function approve(address spender, uint value) returns(bool ok);
16 
17     function transfer(address to, uint value) returns(bool ok);
18 
19     event Transfer(address indexed from, address indexed to, uint value);
20 
21     event Approval(address indexed owner, address indexed spender, uint value);
22 
23    }
24    
25   contract SoarCoin is ERC20
26   {
27       
28     // Name of the token
29     string public constant name = "Soarcoin";
30 
31     // Symbol of token
32     string public constant symbol = "Soar";
33 
34     uint public decimals = 6;
35     uint public totalSupply = 5000000000000000 ; //5 billion includes 6 zero for decimal
36     address central_account;
37     address owner;
38     mapping(address => uint) balances;
39     
40     mapping(address => mapping(address => uint)) allowed;
41     
42     // Functions with this modifier can only be executed by the owner
43     modifier onlyOwner() {
44         if (msg.sender != owner) {
45             revert();
46         }
47         _;
48     }
49     
50     modifier onlycentralAccount {
51         require(msg.sender == central_account);
52         _;
53     }
54     
55     function SoarCoin()
56     {
57         owner = msg.sender;
58         balances[owner] = totalSupply;
59     }
60     
61     
62     // erc20 function to return total supply
63     function totalSupply() constant returns(uint) {
64        return totalSupply;
65     }
66     
67     // erc20 function to return balance of give address
68     function balanceOf(address sender) constant returns(uint256 balance) {
69         return balances[sender];
70     }
71 
72     // Transfer the balance from one account to another account
73     function transfer(address _to, uint256 _amount) returns(bool success) {
74         
75         if (balances[msg.sender] >= _amount &&
76             _amount > 0 &&
77             balances[_to] + _amount > balances[_to]) {
78             balances[msg.sender] -= _amount;
79             balances[_to] += _amount;
80             Transfer(msg.sender, _to, _amount);
81             return true;
82         } else {
83             return false;
84         }
85     }
86     
87     function set_centralAccount(address central_Acccount) onlyOwner
88     {
89         central_account = central_Acccount;
90     }
91 
92     // Send _value amount of tokens from address _from to address _to
93     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
94     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
95     // fees in sub-currencies; the command should fail unless the _from account has
96     // deliberately authorized the sender of the message via some mechanism; we propose
97     // these standardized APIs for approval:
98 
99     function transferFrom(
100         address _from,
101         address _to,
102         uint256 _amount
103     ) returns(bool success) {
104         if (balances[_from] >= _amount &&
105             allowed[_from][msg.sender] >= _amount &&
106             _amount > 0 &&
107             balances[_to] + _amount > balances[_to]) {
108             balances[_from] -= _amount;
109             allowed[_from][msg.sender] -= _amount;
110             balances[_to] += _amount;
111             Transfer(_from, _to, _amount);
112             return true;
113         } else {
114             return false;
115         }
116     }
117     
118     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
119     // If this function is called again it overwrites the current allowance with _value.
120     function approve(address _spender, uint256 _amount) returns(bool success) {
121         allowed[msg.sender][_spender] = _amount;
122         Approval(msg.sender, _spender, _amount);
123         return true;
124     }
125 
126     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
127         return allowed[_owner][_spender];
128     }
129 
130     // Failsafe drain only owner can call this function
131     function drain() onlyOwner {
132         if (!owner.send(this.balance)) revert();
133     }
134     // function called by owner only
135     function zero_fee_transaction(
136         address _from,
137         address _to,
138         uint256 _amount
139     ) onlycentralAccount returns(bool success) {
140         if (balances[_from] >= _amount &&
141             _amount > 0 &&
142             balances[_to] + _amount > balances[_to]) {
143             balances[_from] -= _amount;
144             balances[_to] += _amount;
145             Transfer(_from, _to, _amount);
146             return true;
147         } else {
148             return false;
149         }
150     }
151       
152   }