1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal constant returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 
30 contract owned {
31     address public owner;
32 
33     function owned() public {
34         owner = msg.sender;
35     }
36 
37     modifier onlyOwner {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     function transferOwnership(address newOwner) onlyOwner public {
43         owner = newOwner;
44     }
45 }
46 
47 contract SafeERC20 {
48     
49     using SafeMath for uint256;
50     
51     string public name;
52     string public symbol;
53     uint8 public decimals;
54     // 18 decimals is the strongly suggested default, avoid changing it
55     uint256 public _totalSupply;
56 
57     // This creates an array with all balances    
58     mapping (address => uint256) public balanceOf;
59     // Owner of account approves the transfer of an amount to another account
60     mapping (address => mapping(address => uint256)) allowed;
61     
62 
63     function totalSupply() public constant returns (uint256) {
64         return _totalSupply;
65     }
66     
67     
68         // @notice send `value` token to `to` from `msg.sender`
69     // @param to The address of the recipient
70     // @param value The amount of token to be transferred
71     // @return the transaction address and send the event as Transfer
72     function transfer(address to, uint256 value) public {
73         require (
74             balanceOf[msg.sender] >= value && value > 0
75         );
76         balanceOf[msg.sender] = balanceOf[msg.sender].sub(value);
77         balanceOf[to] = balanceOf[to].add(value);
78         Transfer(msg.sender, to, value);
79     }
80 
81     // @notice send `value` token to `to` from `from`
82     // @param from The address of the sender
83     // @param to The address of the recipient
84     // @param value The amount of token to be transferred
85     // @return the transaction address and send the event as Transfer
86     function transferFrom(address from, address to, uint256 value) public {
87         require (
88             allowed[from][msg.sender] >= value && balanceOf[from] >= value && value > 0
89         );
90         balanceOf[from] = balanceOf[from].sub(value);
91         balanceOf[to] = balanceOf[to].add(value);
92         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
93         Transfer(from, to, value);
94     }
95 
96     // Allow spender to withdraw from your account, multiple times, up to the value amount.
97     // If this function is called again it overwrites the current allowance with value.
98     // @param spender The address of the sender
99     // @param value The amount to be approved
100     // @return the transaction address and send the event as Approval
101     function approve(address spender, uint256 value) public {
102         require (
103             balanceOf[msg.sender] >= value && value > 0
104         );
105         allowed[msg.sender][spender] = value;
106         Approval(msg.sender, spender, value);
107     }
108 
109     // Check the allowed value for the spender to withdraw from owner
110     // @param owner The address of the owner
111     // @param spender The address of the spender
112     // @return the amount which spender is still allowed to withdraw from owner
113     function allowance(address _owner, address spender) public constant returns (uint256) {
114         return allowed[_owner][spender];
115     }
116 
117     // What is the balance of a particular account?
118     // @param who The address of the particular account
119     // @return the balanace the particular account
120 
121     event Transfer(address indexed from, address indexed to, uint256 value);
122     event Approval(address indexed owner, address indexed spender, uint256 value);
123 
124 }
125 
126 contract BITTOToken is SafeERC20, owned {
127 
128     using SafeMath for uint256;
129 
130 
131 
132     // Token properties
133     string public name = "BITTO";
134     string public symbol = "BITTO";
135     uint256 public decimals = 18;
136 
137     uint256 public _totalSupply = 33000000e18;
138     address multisig = 0x228C8c3D0878b0d3ce72381b8CC92396A03f399e;
139 
140     
141 
142     // how many token units a buyer gets per wei
143     uint public price = 800;
144 
145 
146     uint256 public fundRaised;
147 
148     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
149 
150 
151     // Constructor
152     // @notice RQXToken Contract
153     // @return the transaction address
154     function BITTOToken() public {
155  
156         balanceOf[multisig] = _totalSupply;
157 
158     }
159 
160     function transfertoken (uint256 _amount, address recipient) public onlyOwner {
161          require(recipient != 0x0);
162          require(balanceOf[owner] >= _amount);
163          balanceOf[owner] = balanceOf[owner].sub(_amount);
164          balanceOf[recipient] = balanceOf[recipient].add(_amount);
165 
166     }
167     
168     function burn(uint256 _amount) public onlyOwner{
169         require(balanceOf[owner] >= _amount);
170         balanceOf[owner] -= _amount;
171         _totalSupply -= _amount;
172     }
173     // Payable method
174     // @notice Anyone can buy the tokens on tokensale by paying ether
175     function () public payable {
176         tokensale(msg.sender);
177         
178     }
179     // update price 
180     
181     function updatePrice (uint _newpice) public onlyOwner {
182         price = _newpice;
183     }
184     // @notice tokensale
185     // @param recipient The address of the recipient
186     // @return the transaction address and send the event as Transfer
187     function tokensale(address recipient) public payable {
188         require(recipient != 0x0);
189 
190 
191         uint256 weiAmount = msg.value;
192         uint256 tokens = weiAmount.mul(price);
193 
194         // update state
195         fundRaised = fundRaised.add(weiAmount);
196 
197         balanceOf[owner] = balanceOf[owner].sub(tokens);
198         balanceOf[recipient] = balanceOf[recipient].add(tokens);
199 
200 
201 
202         TokenPurchase(msg.sender, recipient, weiAmount, tokens);
203         forwardFunds();
204     }
205 
206     // send ether to the fund collection wallet
207     // override to create custom fund forwarding mechanisms
208     function forwardFunds() internal {
209         owner.transfer(msg.value);
210     }
211 
212 }