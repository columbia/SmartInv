1 pragma solidity ^0.4.2;
2 
3 contract ERC20Interface {
4 
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10 
11     // Triggered when tokens are transferred.
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13 
14     // Triggered whenever approve(address _spender, uint256 _value) is called.
15     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 
17 }
18 
19 contract Owner {
20     //For storing the owner address
21     address public owner;
22 
23     //Constructor for assign a address for owner property(It will be address who deploy the contract) 
24     function Owner() {
25         owner = msg.sender;
26     }
27 
28     //This is modifier (a special function) which will execute before the function execution on which it applied 
29     modifier onlyOwner() {
30         if(msg.sender != owner) throw;
31         //This statement replace with the code of fucntion on which modifier is applied
32         _;
33     }
34     //Here is the example of modifier this function code replace _; statement of modifier 
35     function transferOwnership(address new_owner) onlyOwner {
36         owner = new_owner;
37     }
38 }
39 
40 contract RemiCoin is ERC20Interface,Owner {
41 
42     //Common information about coin
43     string  public name;
44     string  public symbol;
45     uint8   public decimals;
46     uint256 public totalSupply;
47     
48     //Balance property which should be always associate with an address
49     mapping(address => uint256) balances;
50     //frozenAccount property which should be associate with an address
51     mapping (address => bool) public frozenAccount;
52     // Owner of account approves the transfer of an amount to another account
53     mapping(address => mapping (address => uint256)) allowed;
54     
55     //These generates a public event on the blockchain that will notify clients
56     event FrozenFunds(address target, bool frozen);
57     
58     //Construtor for initial supply (The address who deployed the contract will get it) and important information
59     function RemiCoin(uint256 initial_supply, string _name, string _symbol, uint8 _decimal) {
60         balances[msg.sender]  = initial_supply;
61         name                  = _name;
62         symbol                = _symbol;
63         decimals              = _decimal;
64         totalSupply           = initial_supply;
65     }
66 
67     // What is the balance of a particular account?
68     function balanceOf(address _owner) constant returns (uint256 balance) {
69         return balances[_owner];
70     }
71 
72     //Function for transer the coin from one address to another
73     function transfer(address to, uint value) returns (bool success) {
74 
75         //checking account is freeze or not
76         if (frozenAccount[msg.sender]) return false;
77 
78         //checking the sender should have enough coins
79         if(balances[msg.sender] < value) return false;
80         //checking for overflows
81         if(balances[to] + value < balances[to]) return false;
82         
83         //substracting the sender balance
84         balances[msg.sender] -= value;
85         //adding the reciever balance
86         balances[to] += value;
87         
88         // Notify anyone listening that this transfer took place
89         Transfer(msg.sender, to, value);
90 
91         return true;
92     }
93 
94 
95     //Function for transer the coin from one address to another
96     function transferFrom(address from, address to, uint value) returns (bool success) {
97 
98         //checking account is freeze or not
99         if (frozenAccount[msg.sender]) return false;
100 
101         //checking the from should have enough coins
102         if(balances[from] < value) return false;
103 
104         //checking for allowance
105         if( allowed[from][msg.sender] >= value ) return false;
106 
107         //checking for overflows
108         if(balances[to] + value < balances[to]) return false;
109         
110         balances[from] -= value;
111         allowed[from][msg.sender] -= value;
112         balances[to] += value;
113         
114         // Notify anyone listening that this transfer took place
115         Transfer(from, to, value);
116 
117         return true;
118     }
119 
120     //
121     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
122         return allowed[_owner][_spender];
123     }
124 
125     //
126     function approve(address _spender, uint256 _amount) returns (bool success) {
127         allowed[msg.sender][_spender] = _amount;
128         Approval(msg.sender, _spender, _amount);
129         return true;
130     }
131     
132     //
133     function mintToken(address target, uint256 mintedAmount) onlyOwner{
134         balances[target] += mintedAmount;
135         totalSupply += mintedAmount;
136         
137         Transfer(0,owner,mintedAmount);
138         Transfer(owner,target,mintedAmount);
139     }
140 
141     //
142     function freezeAccount(address target, bool freeze) onlyOwner {
143         frozenAccount[target] = freeze;
144         FrozenFunds(target, freeze);
145     }
146 
147     //
148     function changeName(string _name) onlyOwner {
149         name = _name;
150     }
151 
152     //
153     function changeSymbol(string _symbol) onlyOwner {
154         symbol = _symbol;
155     }
156 
157     //
158     function changeDecimals(uint8 _decimals) onlyOwner {
159         decimals = _decimals;
160     }
161 }