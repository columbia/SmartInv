1 pragma solidity 0.4.18;
2 
3 // implement safemath as a library
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
7     uint256 c = a * b;
8     require(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal constant returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     require(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     require(c >= a);
25     return c;
26   }
27 }
28 
29 // Used for function invoke restriction
30 contract Administration {
31 
32     address     public owner; // temporary address
33     
34     mapping (address => bool) public moderators;
35 
36     event AddMod(address indexed _invoker, address indexed _newMod, bool indexed _modAdded);
37     event RemoveMod(address indexed _invoker, address indexed _removeMod, bool indexed _modRemoved);
38 
39     function Administration() {
40         owner = msg.sender;
41     }
42 
43     modifier onlyAdmin() {
44         require(msg.sender == owner || moderators[msg.sender] == true);
45         _;
46     }
47 
48     modifier onlyOwner() {
49         require(msg.sender == owner);
50         _; // function code inserted here
51     }
52 
53     function transferOwnership(address _newOwner) onlyOwner returns (bool success) {
54         owner = _newOwner;
55         return true;
56         
57     }
58 
59     function addModerator(address _newMod) onlyOwner returns (bool added) {
60         require(_newMod != address(0x0));
61         moderators[_newMod] = true;
62         AddMod(msg.sender, _newMod, true);
63         return true;
64     }
65     
66     function removeModerator(address _removeMod) onlyOwner returns (bool removed) {
67         require(_removeMod != address(0x0));
68         moderators[_removeMod] = false;
69         RemoveMod(msg.sender, _removeMod, true);
70         return true;
71     }
72 
73 }
74 
75 contract TokenDraft is Administration {
76     using SafeMath for uint256;
77 
78     uint256 public totalSupply;
79     uint8   public decimals;
80     string  public symbol;
81     string  public name;
82 
83     mapping (address => uint256) public balances;
84     mapping (address => mapping (address => uint256)) public allowed;
85     
86     event Transfer(address indexed _sender, address indexed _recipient, uint256 indexed _amount);
87     event Approval(address indexed _owner, address indexed _spender, uint256 indexed _allowance);
88     event BurnTokens(address indexed _burner, uint256 indexed _amountBurned, bool indexed _burned);
89 
90     function TokenDraft() {
91         // 500 million in wei
92         totalSupply = 500000000000000000000000000;
93         decimals = 18;
94         name = "TokenDraft";
95         symbol = "FAN";
96         balances[owner] = totalSupply;
97     }
98 
99     function tokenBurn(uint256 _amountBurn)
100         onlyAdmin
101         returns (bool burned)
102     {
103         require(_amountBurn > 0);
104         require(balances[msg.sender] >= _amountBurn);
105         require(totalSupply.sub(_amountBurn) >= 0);
106         balances[msg.sender] = balances[msg.sender].sub(_amountBurn);
107         totalSupply = totalSupply.sub(_amountBurn);
108         BurnTokens(msg.sender, _amountBurn, true);
109         Transfer(msg.sender, 0, _amountBurn);
110         return true;
111     }
112 
113     function transferCheck(address _sender, address _recipient, uint256 _amount)
114         private
115         constant
116         returns (bool valid)
117     {
118         require(_amount > 0);
119         require(_recipient != address(0x0));
120         require(balances[_sender] >= _amount);
121         require(balances[_sender].sub(_amount) >= 0);
122         require(balances[_recipient].add(_amount) > balances[_recipient]);
123         return true;
124     }
125 
126     function transfer(address _recipient, uint256 _amount)
127         public
128         returns (bool transferred)
129     {
130         require(transferCheck(msg.sender, _recipient, _amount));
131         balances[msg.sender] = balances[msg.sender].sub(_amount);
132         balances[_recipient] = balances[_recipient].add(_amount);
133         Transfer(msg.sender, _recipient, _amount);
134         return true;
135     }
136 
137     function transferFrom(address _owner, address _recipient, uint256 _amount)
138         public
139         returns (bool transferredFrom)
140     {
141         require(allowed[_owner][msg.sender] >= _amount);
142         require(transferCheck(_owner, _recipient, _amount));
143         require(allowed[_owner][msg.sender].sub(_amount) >= 0);
144         allowed[_owner][msg.sender] = allowed[_owner][msg.sender].sub(_amount);
145         balances[_owner] = balances[_owner].sub(_amount);
146         balances[_recipient] = balances[_recipient].add(_amount);
147         Transfer(_owner, _recipient, _amount);
148         return true;
149     }
150 
151     function approve(address _spender, uint256 _allowance)
152         public
153         returns (bool approved)
154     {
155         require(_allowance > 0);
156         allowed[msg.sender][_spender] = _allowance;
157         Approval(msg.sender, _spender, _allowance);
158         return true;
159     }
160 
161     //GETTERS//
162 
163     function balanceOf(address _tokenHolder)
164         public
165         constant
166         returns (uint256 _balance)
167     {
168         return balances[_tokenHolder];
169     }
170 
171     function allowance(address _owner, address _spender)
172         public
173         constant
174         returns (uint256 _allowance)
175     {
176         return allowed[_owner][_spender];
177     }
178 
179     function totalSupply()
180         public
181         constant
182         returns (uint256 _totalSupply)
183     {
184         return totalSupply;
185     }
186 }