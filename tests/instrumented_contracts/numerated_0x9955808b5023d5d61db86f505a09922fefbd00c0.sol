1 pragma solidity ^0.4.8;
2 
3 contract ERC20Interface {
4     function totalSupply() public constant returns (uint256 supply);
5     function balance() public constant returns (uint256);
6     function balanceOf(address _owner) public constant returns (uint256);
7     function transfer(address _to, uint256 _value) public returns (bool success);
8     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
9     function approve(address _spender, uint256 _value) public returns (bool success);
10     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
11 
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 }
15 
16 interface Token { 
17     function totalSupply() constant public returns (uint256 supply);
18     function balanceOf(address _owner) constant public returns (uint256 balance);
19 }
20 
21 interface EOSToken {
22   function balanceOf(address who) constant public returns (uint value);
23 }
24 
25 contract EOSDRAM is ERC20Interface {
26     string public constant symbol = "DRAM";
27     string public constant name = "EOS DRAM";
28     uint8 public constant decimals = 18;
29 
30     address EOSContract = 0x86Fa049857E0209aa7D9e616F7eb3b3B78ECfdb0;
31 
32     // 1 DRAM is the equivalent of EOS 1 Kb of RAM
33     // total fixed supply is 64 GB of DRAM;
34     // total fixed supply = 64 * 1024 *1024 = 67108864
35     // unlike the EOS blockchain, 64 GB is a fixed total supply that can never be changed/increased
36     // having a fixed supply means that all future RAM increases on the EOS blockchain will have no effect here on DRAM
37     
38 
39     uint256 _totalSupply = 67108864e18;
40     
41     // as per the locked EOS contract 0x86fa049857e0209aa7d9e616f7eb3b3b78ecfdb0 there are 330687 EOS holders
42     // 10% of the total supply will be reserved for exchanges/dev and the remaining 90% will be distributed equally among the 330687 EOS holders
43     // this means each address receives 182 DRAM
44    
45    uint256 _airdropAmount = 182e18;
46     
47 
48     mapping(address => uint256) balances;
49     mapping(address => bool) initialized;
50 
51     // Owner of account approves the transfer of an amount to another account
52     mapping(address => mapping (address => uint256)) allowed;
53 
54     address public owner;
55     
56     modifier onlyOwner() {
57     require(msg.sender == owner);
58     _;
59     }
60 
61     function EOSDRAM() public {
62         owner = msg.sender;
63         initialized[msg.sender] = true;
64         //~10% reserve for exchanges and dev
65         balances[msg.sender] = 6923830e18;
66         Transfer(0, owner, 6923830e18);
67       }
68 
69     function totalSupply() public constant returns (uint256 supply) {
70         return _totalSupply;
71     }
72 
73     // What's my balance?
74     function balance() public constant returns (uint256) {
75         return getBalance(msg.sender);
76     }
77 
78     // What is the balance of a particular account?
79     function balanceOf(address _address) public constant returns (uint256) {
80         return getBalance(_address);
81     }
82 
83     // Transfer the balance from owner's account to another account
84     function transfer(address _to, uint256 _amount) public returns (bool success) {
85         initialize(msg.sender);
86 
87         if (balances[msg.sender] >= _amount
88             && _amount > 0) {
89             initialize(_to);
90             if (balances[_to] + _amount > balances[_to]) {
91 
92                 balances[msg.sender] -= _amount;
93                 balances[_to] += _amount;
94 
95                 Transfer(msg.sender, _to, _amount);
96 
97                 return true;
98             } else {
99                 return false;
100             }
101         } else {
102             return false;
103         }
104     }
105 
106     // Send _value amount of tokens from address _from to address _to
107     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
108     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
109     // fees in sub-currencies; the command should fail unless the _from account has
110     // deliberately authorized the sender of the message via some mechanism; we propose
111     // these standardized APIs for approval:
112     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
113         initialize(_from);
114 
115         if (balances[_from] >= _amount
116             && allowed[_from][msg.sender] >= _amount
117             && _amount > 0) {
118             initialize(_to);
119             if (balances[_to] + _amount > balances[_to]) {
120 
121                 balances[_from] -= _amount;
122                 allowed[_from][msg.sender] -= _amount;
123                 balances[_to] += _amount;
124 
125                 Transfer(_from, _to, _amount);
126 
127                 return true;
128             } else {
129                 return false;
130             }
131         } else {
132             return false;
133         }
134     }
135 
136     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
137     // If this function is called again it overwrites the current allowance with _value.
138     function approve(address _spender, uint256 _amount) public returns (bool success) {
139         allowed[msg.sender][_spender] = _amount;
140         Approval(msg.sender, _spender, _amount);
141         return true;
142     }
143 
144     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
145         return allowed[_owner][_spender];
146     }
147 
148     // internal private functions
149     function initialize(address _address) internal returns (bool success) {
150        // ensure we only airdrop once per address
151         if (!initialized[_address]) {
152        
153        // we verify the balance of the EOS contract
154        EOSToken token = EOSToken(EOSContract);
155        uint256 has_eos = token.balanceOf(_address);
156        if (has_eos > 0) {
157        	    // if the address has eos, we grant the DRAM airdrop
158             initialized[_address] = true;
159             balances[_address] = _airdropAmount;
160             }
161         }
162         return true;
163     }
164 
165     function getBalance(address _address) internal returns (uint256) {
166         if (!initialized[_address]) {
167             EOSToken token = EOSToken(EOSContract);
168 	    uint256 has_eos = token.balanceOf(_address);
169       	   
170       	   if (has_eos > 0) {
171             return balances[_address] + _airdropAmount;
172             }
173             else {
174             return balances[_address];
175             }
176         }
177         else {
178             return balances[_address];
179         }
180     }
181 }