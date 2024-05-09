1 pragma solidity ^0.4.0;
2 
3 // ERC Token Standard #20 Interface
4 // https://github.com/ethereum/EIPs/issues/20
5 contract ERC20Interface {
6 	// Get the total token supply
7 	function totalSupply() public constant returns (uint256);
8 	
9 	// Get the account balance of another account with address _owner
10 	function balanceOf(address _owner) public constant returns (uint256);
11 	
12 	// Send _value amount of tokens to address _to
13 	function transfer(address _to, uint256 _value) public returns (bool);
14 	
15 	// Send _value amount of tokens from address _from to address _to
16 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
17 	
18 	// Allow _spender to withdraw from your account, multiple times, up to the _value amount.
19 	// If this function is called again it overwrites the current allowance with _value.
20 	// this function is required for some DEX functionality
21 	function approve(address _spender, uint256 _value) public returns (bool);
22 	
23 	// Returns the amount which _spender is still allowed to withdraw from _owner
24 	function allowance(address _owner, address _spender) public constant returns (uint256);
25 	
26 	// Triggered when tokens are transferred.
27 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
28 	
29 	// Triggered whenever approve(address _spender, uint256 _value) is called.
30 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
31 }
32 
33 contract RandomToken {
34     function balanceOf(address _owner) public view returns (uint256);
35     function transfer(address _to, uint256 _value) public returns (bool);
36 }
37 
38 contract Number1Dime is ERC20Interface {
39     bool public is_purchase_allowed;
40     bool public is_transfer_allowed;
41     uint256 public totSupply = 0;
42     uint256 public totContribution = 0;
43     address owner;
44     
45     mapping(address => uint256) balances;
46     mapping(address => mapping(address => uint256)) allowed;
47     
48     modifier onlyOwner() {
49         if (msg.sender != owner) { revert(); }
50         _;
51     }
52     
53     modifier transferAllowed() {
54         if (! is_transfer_allowed) { revert(); }
55         _;
56     }
57     
58     modifier purchaseAllowed() {
59         if (! is_purchase_allowed) { revert(); }
60         _;
61     }
62     
63     function Number1Dime() public {
64         owner = msg.sender;
65         enableTransfer(false);
66         enablePurchase(false);
67     }
68 
69     function name() public pure returns (string)    { return "Number One Dime"; }
70     function symbol() public pure returns (string)  { return "N1D"; }
71     function decimals() public pure returns (uint8) { return 0; }
72     
73     function get_balance(address a) public view returns (uint256) { return a.balance; }
74     
75     function get_stats() public view onlyOwner returns (uint256 _totSupply, uint256 _totContribution) {
76         _totSupply = totSupply;
77         _totContribution = totContribution;
78     }
79     
80     function enablePurchase(bool _enab) public onlyOwner returns (bool) {
81         return is_purchase_allowed = _enab;
82     }
83     
84     function enableTransfer(bool _enab) public onlyOwner returns (bool) {
85         return is_transfer_allowed = _enab;
86     }
87     
88     function totalSupply() public view returns (uint256) {
89         return totSupply;
90     }
91     
92     function balanceOf(address a) public view returns (uint256) {
93         return balances[a];
94     }
95 
96     function transfer(address _to, uint256 _amount) public transferAllowed returns (bool) {
97         if ( 
98                 _amount > 0
99             &&  balances[msg.sender] >= _amount
100             &&  balances[_to] + _amount > balances[_to]
101         ) {
102             balances[msg.sender] -= _amount;
103             balances[_to] += _amount;
104             Transfer(msg.sender, _to, _amount);
105             return true;
106         } else {
107             return false;
108         }
109     }
110  
111     function transferFrom(
112         address _from,
113         address _to,
114         uint256 _amount
115     ) public transferAllowed returns (bool) {
116         if (
117                 _amount > 0
118             &&  balances[_from] >= _amount
119             &&  allowed[_from][msg.sender] >= _amount
120             &&  balances[_to] + _amount > balances[_to]
121         ) {
122             balances[_from] -= _amount;
123             allowed[_from][msg.sender] -= _amount;
124             balances[_to] += _amount;
125             Transfer(_from, _to, _amount);
126             return true;
127         }
128         else {
129             return false;
130         }
131     }
132  
133     function approve(address _spender, uint256 _amount) public returns (bool) {
134         allowed[msg.sender][_spender] = _amount;
135         Approval(msg.sender, _spender, _amount);
136         return true;
137     }
138  
139     function allowance(address _owner, address _spender) public view returns (uint256) {
140         return allowed[_owner][_spender];
141     }
142     
143     function() public payable purchaseAllowed {
144         if (msg.value == 0) { return; }
145 
146         totContribution += msg.value;
147         uint256 tokensIssued = msg.value;
148         totSupply += tokensIssued;
149         owner.transfer(msg.value);
150         balances[msg.sender] += tokensIssued;
151         Transfer(address(this), msg.sender, tokensIssued);
152     }
153     
154     function withdrawForeignTokens(address _tokenContract) public onlyOwner returns (bool) {
155         RandomToken token = RandomToken(_tokenContract);
156         uint256 amount = token.balanceOf(address(this));
157         return token.transfer(owner, amount);
158     }
159 }