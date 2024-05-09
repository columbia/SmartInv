1 pragma solidity 0.4.21;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256){
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal pure returns (uint256){
12         assert(b > 0);
13         uint256 c = a / b;
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256){
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256){
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 
30 contract ERC20 {
31     uint256 public totalSupply;
32 
33     function balanceOf(address who) constant public returns (uint256);
34 
35     function transfer(address to, uint256 value) public returns (bool);
36 
37     function allowance(address owner, address spender) constant public returns (uint256);
38 
39     function transferFrom(address from, address to, uint256 value) public returns (bool);
40 
41     function approve(address spender, uint256 value) public returns (bool);
42 
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 
45     event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 
49 contract Ownable {
50     address  owner;
51 
52     function Ownable() public{
53         owner = msg.sender;
54     }
55 
56     /**
57      * @dev Throws if called by any account other than the owner.
58      */
59     modifier onlyOwner(){
60         require(msg.sender == owner);
61         _;
62     }
63 
64     /**
65      * @dev Allows the current owner to transfer control of the contract to a newOwner.
66      * @param newOwner The address to transfer ownership to.
67      */
68     function transferOwnership(address newOwner) onlyOwner public{
69         require(newOwner != address(0));
70         owner = newOwner;
71     }
72 }
73 
74 
75 contract StandardToken is ERC20 {
76     using SafeMath for uint256;
77     mapping (address => mapping (address => uint256)) allowed;
78     mapping(address => uint256) balances;
79 
80     /**
81      * @dev transfer token for a specified address
82      * @param _to The address to transfer to.
83      * @param _value The amount to be transferred.
84      */
85     function transfer(address _to, uint256 _value) public returns (bool){
86         assert(0 < _value);
87         assert(balances[msg.sender] >= _value);
88         balances[msg.sender] = balances[msg.sender].sub(_value);
89         balances[_to] = balances[_to].add(_value);
90         emit Transfer(msg.sender, _to, _value);
91         return true;
92     }
93 
94     /**
95      * @dev Gets the balance of the specified address.
96      * @param _owner The address to query the balance of. 
97      * @return An uint256 representing the amount owned by the passed address.
98      */
99     function balanceOf(address _owner) constant public returns (uint256 balance){
100         return balances[_owner];
101     }
102 
103     /**
104      * @dev Transfer tokens from one address to another
105      * @param _from address The address which you want to send tokens from
106      * @param _to address The address which you want to transfer to
107      * @param _value uint256 the amout of tokens to be transfered
108      */
109     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
110         uint256 _allowance = allowed[_from][msg.sender];
111         assert (balances[_from] >= _value);
112         assert (_allowance >= _value);
113         assert (_value > 0);
114         // assert ( balances[_to] + _value > balances[_to]);
115         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
116         // require (_value <= _allowance);
117         balances[_to] = balances[_to].add(_value);
118         balances[_from] = balances[_from].sub(_value);
119         allowed[_from][msg.sender] = _allowance.sub(_value);
120         emit Transfer(_from, _to, _value);
121         return true;
122     }
123 
124     /**
125      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
126      * @param _spender The address which will spend the funds.
127      * @param _value The amount of tokens to be spent.
128      */
129     function approve(address _spender, uint256 _value) public returns (bool){
130         // To change the approve amount you first have to reduce the addresses`
131         // allowance to zero by calling `approve(_spender, 0)` if it is not
132         // already 0 to mitigate the race condition described here:
133         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
135         allowed[msg.sender][_spender] = _value;
136         emit Approval(msg.sender, _spender, _value);
137         return true;
138     }
139 
140     /**
141      * @dev Function to check the amount of tokens that an owner allowed to a spender.
142      * @param _owner address The address which owns the funds.
143      * @param _spender address The address which will spend the funds.
144      * @return A uint256 specifing the amount of tokens still available for the spender.
145      */
146     function allowance(address _owner, address _spender) constant public returns (uint256 remaining){
147         return allowed[_owner][_spender];
148     }
149 }
150 
151 
152 contract  Ammbr is StandardToken, Ownable {
153     string public name = '';
154     string public symbol = '';
155     uint8 public  decimals = 0;
156     uint256 public maxMintBlock = 0;
157 
158     event Mint(address indexed to, uint256 amount);
159 
160     /**
161      * @dev Function to mint tokens
162      * @param _to The address that will recieve the minted tokens.
163      * @param _amount The amount of tokens to mint.
164      * @return A boolean that indicates if the operation was successful.
165      */
166     function mint(address _to, uint256 _amount) onlyOwner  public returns (bool){
167         assert(maxMintBlock == 0);
168         totalSupply = totalSupply.add(_amount);
169         balances[_to] = balances[_to].add(_amount);
170         emit Mint(_to, _amount);
171         maxMintBlock = 1;
172         return true;
173     }
174 
175     /**
176      * @dev Function is used to perform a multi-transfer operation. This could play a significant role in the Ammbr Mesh Routing protocol.
177      *  
178      * Mechanics:
179      * Sends tokens from Sender to destinations[0..n] the amount tokens[0..n]. Both arrays
180      * must have the same size, and must have a greater-than-zero length. Max array size is 127.
181      * 
182      * IMPORTANT: ANTIPATTERN
183      * This function performs a loop over arrays. Unless executed in a controlled environment,
184      * it has the potential of failing due to gas running out. This is not dangerous, yet care
185      * must be taken to prevent quality being affected.
186      * 
187      * @param destinations An array of destinations we would be sending tokens to
188      * @param tokens An array of tokens, sent to destinations (index is used for destination->token match)
189      */
190     function multiTransfer(address[] destinations, uint[] tokens) public returns (bool success){
191         // Two variables must match in length, and must contain elements
192         // Plus, a maximum of 127 transfers are supported
193         assert(destinations.length > 0);
194         assert(destinations.length < 128);
195         assert(destinations.length == tokens.length);
196         // Check total requested balance
197         uint8 i = 0;
198         uint totalTokensToTransfer = 0;
199         for (i = 0; i < destinations.length; i++){
200             assert(tokens[i] > 0);
201             totalTokensToTransfer += tokens[i];
202         }
203         // Do we have enough tokens in hand?
204         assert (balances[msg.sender] > totalTokensToTransfer);
205         // We have enough tokens, execute the transfer
206         balances[msg.sender] = balances[msg.sender].sub(totalTokensToTransfer);
207         for (i = 0; i < destinations.length; i++){
208             // Add the token to the intended destination
209             balances[destinations[i]] = balances[destinations[i]].add(tokens[i]);
210             // Call the event...
211             emit Transfer(msg.sender, destinations[i], tokens[i]);
212         }
213         return true;
214     }
215 
216     function Ammbr(string _name , string _symbol , uint8 _decimals) public{
217         name = _name;
218         symbol = _symbol;
219         decimals = _decimals;
220     }
221 }