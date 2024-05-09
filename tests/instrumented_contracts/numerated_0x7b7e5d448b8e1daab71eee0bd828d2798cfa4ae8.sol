1 pragma solidity ^0.4.18;
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
29 contract owned {
30     address public owner;
31 
32     function owned() public {
33         owner = msg.sender;
34     }
35 
36     modifier onlyOwner {
37         require(msg.sender == owner);
38         _;
39     }
40 
41     function transferOwnership(address newOwner) onlyOwner public {
42         owner = newOwner;
43     }
44 }
45 
46 interface tokenRecipient {
47     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
48     }
49 
50 
51 contract ERC20 {
52 
53     function balanceOf(address _to) public constant returns (uint256);
54     function transfer(address to, uint256 value) public;
55     function transferFrom(address from, address to, uint256 value) public;
56     function approve(address spender, uint256 value) public;
57     function allowance(address owner, address spender) public constant returns(uint256);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 contract StandardToken is ERC20{
63     using SafeMath for uint256;
64     // Balances for each account
65     mapping (address => uint256) balances;
66     // Owner of account approves the transfer of an amount to another account
67     mapping (address => mapping(address => uint256)) allowed;
68 
69     // What is the balance of a particular account?
70     // @param who The address of the particular account
71     // @return the balanace the particular account
72     function balanceOf(address _to) public constant returns (uint256) {
73         return balances[_to];
74     }
75 
76     // @notice send `value` token to `to` from `msg.sender`
77     // @param to The address of the recipient
78     // @param value The amount of token to be transferred
79     // @return the transaction address and send the event as Transfer
80     function transfer(address to, uint256 value) public {
81         require (
82             balances[msg.sender] >= value && value > 0
83         );
84         balances[msg.sender] = balances[msg.sender].sub(value);
85         balances[to] = balances[to].add(value);
86         Transfer(msg.sender, to, value);
87     }
88 
89 
90     // @notice send `value` token to `to` from `from`
91     // @param from The address of the sender
92     // @param to The address of the recipient
93     // @param value The amount of token to be transferred
94     // @return the transaction address and send the event as Transfer
95     function transferFrom(address from, address to, uint256 value) public {
96         require (
97             allowed[from][msg.sender] >= value && balances[from] >= value && value > 0
98         );
99         balances[from] = balances[from].sub(value);
100         balances[to] = balances[to].add(value);
101         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
102         Transfer(from, to, value);
103     }
104 
105     // Allow spender to withdraw from your account, multiple times, up to the value amount.
106     // If this function is called again it overwrites the current allowance with value.
107     // @param spender The address of the sender
108     // @param value The amount to be approved
109     // @return the transaction address and send the event as Approval
110     function approve(address spender, uint256 value) public {
111         require (
112             balances[msg.sender] >= value && value > 0
113         );
114         allowed[msg.sender][spender] = value;
115         Approval(msg.sender, spender, value);
116     }
117 
118     // Check the allowed value for the spender to withdraw from owner
119     // @param owner The address of the owner
120     // @param spender The address of the spender
121     // @return the amount which spender is still allowed to withdraw from owner
122     function allowance(address _owner, address spender) public constant returns (uint256) {
123         return allowed[_owner][spender];
124     }
125 }
126 
127    /**
128 Describle contact TokenMoney
129 */
130 contract TokenMoney is owned,StandardToken {
131 
132   //name of contact
133     string public name = "TokenMoney";
134     
135     //symbol of contact
136     string public symbol = "TOM";
137     
138     //ddecimals 
139     uint8 public decimals = 18;
140     
141  
142 //total amount
143     uint256 public totalSupply;
144     uint256 public initialSupply;
145     //
146     
147     //version
148     string public version = "v1.0";
149     
150    
151     //create an array with all blance
152     mapping (address => uint256) public balanceOf;
153     mapping (address => mapping (address => uint256)) public allowance;
154 
155     // This generate public event on blockchain  contact Erc20 that will notify client
156     event Transfer(address indexed from, address indexed to, uint256 value);
157 
158 
159     function TokenMoney() public {
160         initialSupply = 3600000;
161         totalSupply = initialSupply * 10 ** uint256(decimals);  
162         balanceOf[msg.sender] = totalSupply;                
163                                     
164     }
165 
166   /**
167      * Internal transfer, only can be called by this contract
168      */
169     function _transfer(address _from, address _to, uint _value) internal {
170         // Prevent transfer to 0x0 address. Use burn() instead
171         require(_to != 0x0);
172         // Check if the sender has enough
173         require(balanceOf[_from] >= _value);
174         // Check for overflows
175         require(balanceOf[_to] + _value > balanceOf[_to]);
176         // Save this for an assertion in the future
177         uint previousBalances = balanceOf[_from] + balanceOf[_to];
178         // Subtract from the sender
179         balanceOf[_from] -= _value;
180         // Add the same to the recipient
181         balanceOf[_to] += _value;
182         Transfer(_from, _to, _value);
183         // Asserts are used to use static analysis to find bugs in your code. They should never fail
184         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
185     }
186 
187   /**
188      * Transfer tokens
189      *
190      * Send `_value` tokens to `_to` from your account
191      *
192      * @param _to The address of the recipient
193      * @param _value the amount to send
194      */
195     function transfer(address _to, uint256 _value) public {
196         _transfer(msg.sender, _to, _value);
197     }
198 }