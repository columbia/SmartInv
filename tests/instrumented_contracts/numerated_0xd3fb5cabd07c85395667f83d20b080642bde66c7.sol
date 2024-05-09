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
32     function balanceOf(address who) view public returns (uint256);
33     function transfer(address to, uint256 value) public returns (bool);
34     function allowance(address owner, address spender) view public returns (uint256);
35     function transferFrom(address from, address to, uint256 value) public returns (bool);
36     function approve(address spender, uint256 value) public returns (bool);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 
42 contract Ownable {
43     address  owner;
44 
45     function Ownable() public{
46         owner = msg.sender;
47     }
48 
49     /**
50      * @dev Throws if called by any account other than the owner.
51      */
52     modifier onlyOwner(){
53         require(msg.sender == owner);
54         _;
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) onlyOwner public{
62         assert(newOwner != address(0));
63         owner = newOwner;
64     }
65 }
66 
67 
68 contract StandardToken is ERC20 {
69     using SafeMath for uint256;
70     mapping (address => mapping (address => uint256)) allowed;
71     mapping(address => uint256) balances;
72 
73     /**
74      * @dev transfer token for a specified address
75      * @param _to The address to transfer to.
76      * @param _value The amount to be transferred.
77      */
78     function transfer(address _to, uint256 _value) public returns (bool){
79         // require(0 < _value); -- REMOVED AS REQUESTED BY AUDIT
80         require(balances[msg.sender] >= _value);
81         balances[msg.sender] = balances[msg.sender].sub(_value);
82         balances[_to] = balances[_to].add(_value);
83         emit Transfer(msg.sender, _to, _value);
84         return true;
85     }
86 
87     /**
88      * @dev Gets the balance of the specified address.
89      * @param _owner The address to query the balance of. 
90      * @return An uint256 representing the amount owned by the passed address.
91      */
92     function balanceOf(address _owner) view public returns (uint256 balance){
93         return balances[_owner];
94     }
95 
96     /**
97      * @dev Transfer tokens from one address to another
98      * @param _from address The address which you want to send tokens from
99      * @param _to address The address which you want to transfer to
100      * @param _value uint256 the amout of tokens to be transfered
101      */
102     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
103         uint256 _allowance = allowed[_from][msg.sender];
104         require (balances[_from] >= _value);
105         require (_allowance >= _value);
106         // require (_value > 0); // NOTE: Removed due to audit demand (transfer of 0 should be authorized)
107         // require ( balances[_to] + _value > balances[_to]);
108         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
109         // require (_value <= _allowance);
110         balances[_to] = balances[_to].add(_value);
111         balances[_from] = balances[_from].sub(_value);
112         allowed[_from][msg.sender] = _allowance.sub(_value);
113         emit Transfer(_from, _to, _value);
114         return true;
115     }
116 
117     /**
118      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
119      * @param _spender The address which will spend the funds.
120      * @param _value The amount of tokens to be spent.
121      */
122     function approve(address _spender, uint256 _value) public returns (bool){
123         // To change the approve amount you first have to reduce the addresses`
124         // allowance to zero by calling `approve(_spender, 0)` if it is not
125         // already 0 to mitigate the race condition described here:
126         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
127         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
128         allowed[msg.sender][_spender] = _value;
129         emit Approval(msg.sender, _spender, _value);
130         return true;
131     }
132 
133     /**
134      * @dev Function to check the amount of tokens that an owner allowed to a spender.
135      * @param _owner address The address which owns the funds.
136      * @param _spender address The address which will spend the funds.
137      * @return A uint256 specifing the amount of tokens still available for the spender.
138      */
139     function allowance(address _owner, address _spender) view public returns (uint256 remaining){
140         return allowed[_owner][_spender];
141     }
142 }
143 
144 
145 contract  Ammbr is StandardToken, Ownable {
146     string public name = '';
147     string public symbol = '';
148     uint8 public  decimals = 0;
149     uint256 public maxMintBlock = 0;
150 
151     event Mint(address indexed to, uint256 amount);
152 
153     /**
154      * @dev Function to mint tokens
155      * @param _to The address that will recieve the minted tokens.
156      * @param _amount The amount of tokens to mint.
157      * @return A boolean that indicates if the operation was successful.
158      */
159     function mint(address _to, uint256 _amount) onlyOwner  public returns (bool){
160         require(maxMintBlock == 0);
161         totalSupply = totalSupply.add(_amount);
162         balances[_to] = balances[_to].add(_amount);
163         emit Mint(_to, _amount);
164         emit Transfer(0,  _to, _amount); // ADDED AS REQUESTED BY AUDIT
165         maxMintBlock = 1;
166         return true;
167     }
168 
169     /**
170      * @dev Function is used to perform a multi-transfer operation. This could play a significant role in the Ammbr Mesh Routing protocol.
171      *  
172      * Mechanics:
173      * Sends tokens from Sender to destinations[0..n] the amount tokens[0..n]. Both arrays
174      * must have the same size, and must have a greater-than-zero length. Max array size is 127.
175      * 
176      * IMPORTANT: ANTIPATTERN
177      * This function performs a loop over arrays. Unless executed in a controlled environment,
178      * it has the potential of failing due to gas running out. This is not dangerous, yet care
179      * must be taken to prevent quality being affected.
180      * 
181      * @param destinations An array of destinations we would be sending tokens to
182      * @param tokens An array of tokens, sent to destinations (index is used for destination->token match)
183      */
184     function multiTransfer(address[] destinations, uint256[] tokens) public returns (bool success){
185         // Two variables must match in length, and must contain elements
186         // Plus, a maximum of 127 transfers are supported
187         require(destinations.length > 0);
188         require(destinations.length < 128);
189         require(destinations.length == tokens.length);
190         // Check total requested balance
191         uint8 i = 0;
192         uint256 totalTokensToTransfer = 0;
193         for (i = 0; i < destinations.length; i++){
194             require(tokens[i] > 0);            
195             // Prevent Integer-Overflow by using Safe-Math
196             totalTokensToTransfer = totalTokensToTransfer.add(tokens[i]);
197         }
198         // Do we have enough tokens in hand?
199         // Note: Although we are testing this here, the .sub() function of 
200         //       SafeMath would fail if the operation produces a negative result
201         require (balances[msg.sender] > totalTokensToTransfer);        
202         // We have enough tokens, execute the transfer
203         balances[msg.sender] = balances[msg.sender].sub(totalTokensToTransfer);
204         for (i = 0; i < destinations.length; i++){
205             // Add the token to the intended destination
206             balances[destinations[i]] = balances[destinations[i]].add(tokens[i]);
207             // Call the event...
208             emit Transfer(msg.sender, destinations[i], tokens[i]);
209         }
210         return true;
211     }
212 
213     function Ammbr(string _name , string _symbol , uint8 _decimals) public{
214         name = _name;
215         symbol = _symbol;
216         decimals = _decimals;
217     }
218 }