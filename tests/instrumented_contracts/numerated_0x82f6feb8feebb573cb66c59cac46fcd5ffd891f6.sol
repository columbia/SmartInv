1 pragma solidity ^0.4.19;
2 
3 /**
4 * @title Baikal Maining Contract
5 * @dev The main token contract
6 */
7 
8 
9 
10 contract Bam {
11     address public owner; // Token owner address
12     mapping (address => uint256) public balances; // balanceOf
13     // mapping (address => mapping (address => uint256)) public allowance;
14     mapping (address => mapping (address => uint256)) allowed;
15 
16     string public standard = 'Baikal Mining';
17     string public constant name = "Baikal Mining";
18     string public constant symbol = "BAM";
19     uint   public constant decimals = 18;
20     uint   public constant totalSupply = 34550000 * 1000000000000000000;
21     
22     uint   internal tokenPrice = 700000000000000;
23     
24     bool   public buyAllowed = true;
25     
26     bool   public transferBlocked = true;
27 
28     //
29     // Events
30     // This generates a publics event on the blockchain that will notify clients
31     
32     event Sent(address from, address to, uint amount);
33     event Buy(address indexed sender, uint eth, uint fbt);
34     event Withdraw(address indexed sender, address to, uint eth);
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 
38     //
39     // Modifiers
40 
41     modifier onlyOwner() {
42         require(msg.sender == owner);
43         _;
44     }
45 
46 
47     modifier onlyOwnerIfBlocked() {
48         if(transferBlocked) {
49             require(msg.sender == owner);   
50         }
51         _;
52     }
53 
54 
55     //
56     // Functions
57     // 
58 
59     // Constructor
60     function Bam() public {
61         owner = msg.sender;
62         balances[owner] = totalSupply;
63     }
64 
65     // fallback function
66     function() public payable {
67         require(buyAllowed);
68         require(msg.value >= 1);
69         require(msg.sender != owner);
70         buyTokens(msg.sender);
71     }
72 
73     /**
74     * @dev Allows the current owner to transfer control of the contract to a newOwner.
75     * @param newOwner The address to transfer ownership to.
76     */
77     function transferOwnership(address newOwner) public onlyOwner {
78       if (newOwner != address(0)) {
79         owner = newOwner;
80       }
81     }
82 
83     function safeMul(uint a, uint b) internal pure returns (uint) {
84         uint c = a * b;
85         require(a == 0 || c / a == b);
86         return c;
87     }
88 
89     function safeSub(uint a, uint b) internal pure returns (uint) {
90         require(b <= a);
91         return a - b;
92     }
93 
94     function safeAdd(uint a, uint b) internal pure returns (uint) {
95         uint c = a + b;
96         require(c>=a && c>=b);
97         return c;
98     }
99 
100 
101     // Payable function for buy coins from token owner
102     function buyTokens(address _buyer) public payable
103     {
104         require(buyAllowed);
105         require(msg.value >= tokenPrice);
106         require(_buyer != owner);
107         
108         uint256 wei_value = msg.value;
109 
110         uint256 tokens = wei_value / tokenPrice;
111         tokens = tokens;
112 
113         balances[owner] = safeSub(balances[owner], tokens);
114         balances[_buyer] = safeAdd(balances[_buyer], tokens);
115 
116         owner.transfer(this.balance);
117         
118         Buy(_buyer, msg.value, tokens);
119         
120     }
121 
122 
123     function setTokenPrice(uint _newPrice) public
124         onlyOwner
125         returns (bool success)
126     {
127         tokenPrice = _newPrice;
128         return true;
129     }
130     
131 
132     function getTokenPrice() public view
133         returns (uint price)
134     {
135         return tokenPrice;
136     }
137     
138     
139     function setBuyAllowed(bool _allowed) public
140         onlyOwner
141     {
142         buyAllowed = _allowed;
143     }
144     
145     function setTransferBlocked(bool _blocked) public
146         onlyOwner
147     {
148         transferBlocked = _blocked;
149     }
150 
151  
152     function withdrawEther(address _to) public 
153         onlyOwner
154     {
155         _to.transfer(this.balance);
156     }
157 
158 
159     /**
160      * ERC 20 token functions
161      *
162      * https://github.com/ethereum/EIPs/issues/20
163      */
164      
165     function balanceOf(address _owner) constant public returns (uint256 balance) {
166         return balances[_owner];
167     }
168     
169     function transfer(address _to, uint256 _value) public
170         onlyOwnerIfBlocked
171         returns (bool success) 
172     {
173         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
174             balances[msg.sender] -= _value;
175             balances[_to] += _value;
176             Transfer(msg.sender, _to, _value);
177             return true;
178         } else { return false; }
179     }
180 
181 
182     function transferFrom(address _from, address _to, uint256 _value) public
183         onlyOwnerIfBlocked
184         returns (bool success)
185     {
186         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
187             balances[_to] += _value;
188             balances[_from] -= _value;
189             allowed[_from][msg.sender] -= _value;
190             Transfer(_from, _to, _value);
191             return true;
192         } else { return false; }
193     }
194 
195 
196     function approve(address _spender, uint256 _value) public
197         onlyOwnerIfBlocked
198         returns (bool success)
199     {
200         allowed[msg.sender][_spender] = _value;
201         Approval(msg.sender, _spender, _value);
202         return true;
203     }
204 
205 
206     function allowance(address _owner, address _spender) public
207         onlyOwnerIfBlocked
208         constant returns (uint256 remaining)
209     {
210       return allowed[_owner][_spender];
211     }
212 
213     
214 }