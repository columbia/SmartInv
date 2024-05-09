1 pragma solidity >=0.4.0 < 0.7.0;
2 
3 contract ERC20Basic {
4     uint256 public totalSupply;
5     function balanceOf(address who) public constant returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11     function allowance(address owner, address spender) public constant returns (uint256);
12     function transferFrom(address from, address to, uint256 value) public returns (bool);
13     function approve(address spender, uint256 value) public returns (bool);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract LOVEAirCoffee is ERC20 {
18     
19     address owner = msg.sender;
20 
21     mapping (address => uint256) public balanceOf;
22     mapping (address => mapping (address => uint256)) public allowed;
23     
24     bool public coinWasBlocked = false;
25     bool public frozenCoin = false;
26     
27     // Public variables of the token
28     string public name="LOVE Air Coffee";
29     string public symbol="LAC";
30     uint8 public decimals = 18;
31     
32     uint256 public tokensPerOneEther;
33     
34     uint256 public minEther;
35     uint256 public maxEther;
36 
37     enum State { Disabled, Enabled }
38     
39     State public state = State.Disabled;
40 
41     // This generates a public event on the blockchain that will notify clients
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     
44     // This generates a public event on the blockchain that will notify clients
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 
47     // This notifies clients about the amount burnt
48     event Burn(address indexed from, uint256 value);
49 
50     // Only Owner
51     modifier onlyOwner() {
52         require(msg.sender == owner);
53         _;
54     }
55     
56     // Transfer Ownership
57     function transferOwnership(address newOwner) onlyOwner public {
58         if (newOwner != address(0)) {
59             owner = newOwner;
60         }
61     }
62     
63     // Constructor
64     constructor(uint256 initialSupply) public {
65         totalSupply = initialSupply * 10 ** uint256(decimals);
66         balanceOf[msg.sender]=totalSupply;
67         emit Transfer(address(0),owner,totalSupply);
68     }
69     
70     // Start Buying Tokens
71     function startBuyingTokens(uint256 _minEther,uint256 _maxEther) public onlyOwner {
72         require(state == State.Disabled);
73         require(tokensPerOneEther > 0);
74         require(_minEther > 0);
75         require(_maxEther > _minEther);
76         
77         // Hold Tokens for first stage
78         if(!coinWasBlocked){
79             frozenCoin = true;   
80             coinWasBlocked = true;
81         }
82         
83         minEther = _minEther * 10 ** uint256(decimals);
84         maxEther = _maxEther * 10 ** uint256(decimals);
85         state = State.Enabled;
86     }
87     
88     // Stop Buying Tokens
89     function stopBuyingTokens() public onlyOwner {
90         require(state == State.Enabled);
91         state = State.Disabled;
92         frozenCoin = false;
93     }
94 
95     // NewBuyPrice Price users can buy from the contract
96     function setPrices(uint256 newBuyPrice) onlyOwner public {
97         tokensPerOneEther = newBuyPrice;
98     }
99 
100     // Buy tokens
101     function () payable external {
102         require(state == State.Enabled);
103         require(tokensPerOneEther > 0);
104         require(msg.value >= minEther && msg.value <= maxEther);
105         
106         uint256 tokens = (tokensPerOneEther * msg.value);
107         _transfer(owner, msg.sender, tokens);   // makes the transferss 
108         owner.transfer(msg.value);
109     }
110     
111     // Allowance
112     function allowance(address _owner, address _spender) constant public returns (uint256) {
113         return allowed[_owner][_spender];
114     }
115     
116     // BalanceOf
117     function balanceOf(address _owner) constant public returns (uint256) {
118         return balanceOf[_owner];
119     }
120 
121     /* Internal transfer, only can be called by this contract */
122     function _transfer(address _from, address _to, uint256 _value) internal {
123         require( _to != address(this)); 
124         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
125         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
126         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
127         balanceOf[_from] -= _value;                             // Subtract from the sender
128         balanceOf[_to] += _value;                               // Add the same to the recipient
129         emit Transfer(_from, _to, _value);
130     }
131 
132     // Transfer tokens
133     function transfer(address _to, uint256 _value) public returns (bool success) {
134         require(!frozenCoin);               // Check if not frozenCoin 
135         _transfer(msg.sender, _to, _value);
136         return true;
137     }
138 
139     // Transfer tokens from other address
140     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
141         require(!frozenCoin);                               // Check if not frozenCoin
142         require(_value <= allowed[_from][msg.sender]);     // Check allowance
143         allowed[_from][msg.sender] -= _value;
144         _transfer(_from, _to, _value);
145         return true;
146     }
147 
148     //Allows `_spender` to spend no more than `_value` tokens in your behalf
149     function approve(address _spender, uint256 _value) public
150         returns (bool success) {
151         allowed[msg.sender][_spender] = _value;
152         emit Approval(msg.sender, _spender, _value);
153         return true;
154     }
155 
156     //Destroy tokens
157     function burn(uint256 _value) public returns (bool success) {
158         require(!frozenCoin);                       // Check if not hold token 
159         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
160         balanceOf[msg.sender] -= _value;            // Subtract from the sender
161         totalSupply -= _value;                      // Updates totalSupply
162         emit Burn(msg.sender, _value);
163         return true;
164     }
165 
166     //Destroy tokens from other account
167     function burnFrom(address _from, uint256 _value) public returns (bool success) {
168         require(balanceOf[_from] >= _value);              // Check if the targeted balance is enough
169         require(_value <= allowed[_from][msg.sender]);    // Check allowance
170         require(!frozenCoin);                             // Check if not frozenCoin
171         balanceOf[_from] -= _value;                       // Subtract from the targeted balance
172         allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
173         totalSupply -= _value;                            // Update totalSupply
174         emit Burn(_from, _value);
175         return true;
176     }
177 }