1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   /** 
34    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35    * account.
36    */
37   constructor () public{
38     owner = msg.sender;
39   }
40 
41 
42   /**
43    * @dev Throws if called by any account other than the owner. 
44    */
45   modifier onlyOwner() {
46     require(owner==msg.sender);
47     _;
48  }
49 
50   /**
51    * @dev Allows the current owner to transfer control of the contract to a newOwner.
52    * @param newOwner The address to transfer ownership to. 
53    */
54   function transferOwnership(address newOwner) public onlyOwner {
55       owner = newOwner;
56   }
57  
58 }
59   
60 contract ERC20 {
61 
62     function totalSupply() public constant returns (uint256);
63     function balanceOf(address who) public constant returns (uint256);
64     function transfer(address to, uint256 value) public returns (bool success);
65     function transferFrom(address from, address to, uint256 value) public returns (bool success);
66     function approve(address spender, uint256 value) public returns (bool success);
67     function allowance(address owner, address spender) public constant returns (uint256);
68 
69     event Transfer(address indexed from, address indexed to, uint256 value);
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 
72 }
73 
74 contract BTNYToken is Ownable, ERC20 {
75 
76     using SafeMath for uint256;
77 
78     // Token properties
79     string public name = "Bitney";                //Token name
80     string public symbol = "BTNY";                  //Token symbol
81     uint256 public decimals = 18;
82 
83     uint256 public _totalSupply = 1000000000e18;       //100% Total Supply
84 
85     // Balances for each account
86     mapping (address => uint256) balances;
87 
88     // Owner of account approves the transfer of an amount to another account
89     mapping (address => mapping(address => uint256)) allowed;
90 
91     // how many token units a buyer gets per wei
92     uint256 public price;
93 
94     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
95 
96     // Constructor
97     // @notice CBITToken Contract
98     // @return the transaction address
99     constructor () public{
100         // Initial Owner Wallet Address
101         owner = msg.sender;
102 
103         balances[owner] = _totalSupply;
104     }
105 
106     // Payable method
107     // @notice Anyone can buy the tokens on tokensale by paying ether
108     function () external payable {
109         tokensale(msg.sender);
110     }
111 
112     // @notice tokensale
113     // @param recipient The address of the recipient
114     // @return the transaction address and send the event as Transfer
115     function tokensale(address recipient) public payable {
116         price = getPrice();
117         require(price != 0 && recipient != 0x0);
118         uint256 weiAmount = msg.value;
119         uint256 tokenToSend = weiAmount.mul(price);
120         
121         balances[owner] = balances[owner].sub(tokenToSend);
122         balances[recipient] = balances[recipient].add(tokenToSend);
123 
124         owner.transfer(msg.value);
125         emit TokenPurchase(msg.sender, recipient, weiAmount, tokenToSend);
126     }
127 
128     // @return total tokens supplied
129     function totalSupply() public constant returns (uint256) {
130         return _totalSupply;
131     }
132     
133     // What is the balance of a particular account?
134     // @param who The address of the particular account
135     // @return the balanace the particular account
136     function balanceOf(address who) public constant returns (uint256) {
137         return balances[who];
138     }
139 
140     // @notice send `value` token to `to` from `msg.sender`
141     // @param to The address of the recipient
142     // @param value The amount of token to be transferred
143     // @return the transaction address and send the event as Transfer
144     function transfer(address to, uint256 value) public returns (bool success)  {
145         require (
146             balances[msg.sender] >= value && value > 0
147         );
148         balances[msg.sender] = balances[msg.sender].sub(value);
149         balances[to] = balances[to].add(value);
150         emit Transfer(msg.sender, to, value);
151         return true;
152     }
153 
154     // @notice send `value` token to `to` from `from`
155     // @param from The address of the sender
156     // @param to The address of the recipient
157     // @param value The amount of token to be transferred
158     // @return the transaction address and send the event as Transfer
159     function transferFrom(address from, address to, uint256 value) public returns (bool success)  {
160         require (
161             allowed[from][msg.sender] >= value && balances[from] >= value && value > 0
162         );
163         balances[from] = balances[from].sub(value);
164         balances[to] = balances[to].add(value);
165         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
166         emit Transfer(from, to, value);
167         return true;
168     }
169 
170     // Allow spender to withdraw from your account, multiple times, up to the value amount.
171     // If this function is called again it overwrites the current allowance with value.
172     // @param spender The address of the sender
173     // @param value The amount to be approved
174     // @return the transaction address and send the event as Approval
175     function approve(address spender, uint256 value) public returns (bool success)  {
176         require (balances[msg.sender] >= value && value > 0);
177         allowed[msg.sender][spender] = value;
178         emit Approval(msg.sender, spender, value);
179         return true;
180     }
181 
182     // Check the allowed value for the spender to withdraw from owner
183     // @param owner The address of the owner
184     // @param spender The address of the spender
185     // @return the amount which spender is still allowed to withdraw from owner
186     function allowance(address _owner, address spender) public constant returns (uint256) {
187         return allowed[_owner][spender];
188     }
189     
190     // Get current price of a Token
191     // @return the price or token value for a ether
192     function getPrice() public pure returns (uint256 result) {
193         return 0;
194     }
195 }