1 pragma solidity ^0.4.19;
2 
3 
4 contract GayCoin {
5     address public owner; // Token owner address
6     mapping (address => uint256) public balances; // balanceOf
7     // mapping (address => mapping (address => uint256)) public allowance;
8     mapping (address => mapping (address => uint256)) allowed;
9 
10     string public standard = 'Gay Coin Standart';
11     string public constant name = "GayCoin";
12     string public constant symbol = "GAY";
13     uint   public constant decimals = 18;
14     uint   public constant totalSupply = 21000000 * 1000000000000000000;
15     
16     uint   internal tokenPrice = 500000000000000;
17     
18     bool   public buyAllowed = false;
19     
20     bool   public transferBlocked = true;
21 
22     //
23     // Events
24     // This generates a publics event on the blockchain that will notify clients
25     
26     event Sent(address from, address to, uint amount);
27     event Buy(address indexed sender, uint eth, uint fbt);
28     event Withdraw(address indexed sender, address to, uint eth);
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
31 
32     //
33     // Modifiers
34 
35     modifier onlyOwner() {
36         require(msg.sender == owner);
37         _;
38     }
39 
40 
41     modifier onlyOwnerIfBlocked() {
42         if(transferBlocked) {
43             require(msg.sender == owner);   
44         }
45         _;
46     }
47 
48 
49     //
50     // Functions
51     // 
52 
53     // Constructor
54     function GayCoin() public {
55         owner = msg.sender;
56         balances[owner] = totalSupply;
57     }
58 
59     // fallback function
60     function() public payable {
61         require(buyAllowed);
62         require(msg.value >= 1);
63         require(msg.sender != owner);
64         buyTokens(msg.sender);
65     }
66 
67     /**
68     * @dev Allows the current owner to transfer control of the contract to a newOwner.
69     * @param newOwner The address to transfer ownership to.
70     */
71     function transferOwnership(address newOwner) public onlyOwner {
72       if (newOwner != address(0)) {
73         owner = newOwner;
74       }
75     }
76 
77     function safeMul(uint a, uint b) internal pure returns (uint) {
78         uint c = a * b;
79         require(a == 0 || c / a == b);
80         return c;
81     }
82 
83     function safeSub(uint a, uint b) internal pure returns (uint) {
84         require(b <= a);
85         return a - b;
86     }
87 
88     function safeAdd(uint a, uint b) internal pure returns (uint) {
89         uint c = a + b;
90         require(c>=a && c>=b);
91         return c;
92     }
93 
94 
95     // Payable function for buy coins from token owner
96     function buyTokens(address _buyer) public payable
97     {
98         require(buyAllowed);
99         require(msg.value >= tokenPrice);
100         require(_buyer != owner);
101         
102         uint256 wei_value = msg.value;
103 
104         uint256 tokens = wei_value / tokenPrice;
105         tokens = tokens;
106 
107         balances[owner] = safeSub(balances[owner], tokens);
108         balances[_buyer] = safeAdd(balances[_buyer], tokens);
109 
110         owner.transfer(this.balance);
111         
112         Buy(_buyer, msg.value, tokens);
113         
114     }
115 
116 
117     function setTokenPrice(uint _newPrice) public
118         onlyOwner
119         returns (bool success)
120     {
121         tokenPrice = _newPrice;
122         return true;
123     }
124     
125 
126     function getTokenPrice() public view
127         returns (uint price)
128     {
129         return tokenPrice;
130     }
131     
132     
133     function setBuyAllowed(bool _allowed) public
134         onlyOwner
135     {
136         buyAllowed = _allowed;
137     }
138     
139     function setTransferBlocked(bool _blocked) public
140         onlyOwner
141     {
142         transferBlocked = _blocked;
143     }
144 
145  
146     function withdrawEther(address _to) public 
147         onlyOwner
148     {
149         _to.transfer(this.balance);
150     }
151 
152 
153     /**
154      * ERC 20 token functions
155      *
156      * https://github.com/ethereum/EIPs/issues/20
157      */
158      
159     function balanceOf(address _owner) constant public returns (uint256 balance) {
160         return balances[_owner];
161     }
162     
163     function transfer(address _to, uint256 _value) public
164         onlyOwnerIfBlocked
165         returns (bool success) 
166     {
167         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
168             balances[msg.sender] -= _value;
169             balances[_to] += _value;
170             Transfer(msg.sender, _to, _value);
171             return true;
172         } else { return false; }
173     }
174 
175 
176     function transferFrom(address _from, address _to, uint256 _value) public
177         onlyOwnerIfBlocked
178         returns (bool success)
179     {
180         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
181             balances[_to] += _value;
182             balances[_from] -= _value;
183             allowed[_from][msg.sender] -= _value;
184             Transfer(_from, _to, _value);
185             return true;
186         } else { return false; }
187     }
188 
189 
190     function approve(address _spender, uint256 _value) public
191         onlyOwnerIfBlocked
192         returns (bool success)
193     {
194         allowed[msg.sender][_spender] = _value;
195         Approval(msg.sender, _spender, _value);
196         return true;
197     }
198 
199 
200     function allowance(address _owner, address _spender) public
201         onlyOwnerIfBlocked
202         constant returns (uint256 remaining)
203     {
204       return allowed[_owner][_spender];
205     }
206 
207     
208 }