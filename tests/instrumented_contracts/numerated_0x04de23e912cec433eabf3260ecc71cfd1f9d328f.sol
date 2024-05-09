1 pragma solidity ^0.4.21;
2 /**
3 * Math operations with safety checks
4 */
5 
6 library SafeMath {
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11         uint256 c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a / b;
18         //assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c>=a && c>=b);
30         return c;
31     }
32 }
33 
34 
35 contract Ownable {
36     address public owner;
37 
38     /**
39       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40       * account.
41       */
42     constructor() public {
43         owner = msg.sender;
44     }
45 
46     /**
47       * @dev Throws if called by any account other than the owner.
48       */
49     modifier onlyOwner() {
50         require(msg.sender == owner);
51         _;
52     }
53     
54     /**
55     * @dev Fix for the ERC20 short address attack.
56     */    
57     modifier onlyPayloadSize(uint size) {
58         assert(msg.data.length >= size + 4);
59         _;
60     }
61 }
62 
63 
64 contract BITCOINIMPROVE is Ownable{
65     using SafeMath for uint;
66     string public name;     
67     string public symbol;
68     uint8 public decimals;  
69     uint private _totalSupply;
70     uint public basisPointsRate = 0;
71     uint public minimumFee = 0;
72     uint public maximumFee = 0;
73 
74     
75     /* This creates an array with all balances */
76     mapping (address => uint256) internal balances;
77     mapping (address => mapping (address => uint256)) internal allowed;
78     
79     /* This generates a public event on the blockchain that will notify clients */
80     /* notify about transfer to client*/
81     event Transfer(
82         address indexed from,
83         address indexed to,
84         uint256 value
85     );
86     
87     /* notify about approval to client*/
88     event Approval(
89         address indexed _owner,
90         address indexed _spender,
91         uint256 _value
92     );
93     
94     /* notify about basisPointsRate to client*/
95     event Params(
96         uint feeBasisPoints,
97         uint maximumFee,
98         uint minimumFee
99     );
100     
101     // Called when new token are issued
102     event Issue(
103         uint amount
104     );
105 
106     // Called when tokens are redeemed
107     event Redeem(
108         uint amount
109     );
110     
111     /*
112         The contract can be initialized with a number of tokens
113         All the tokens are deposited to the owner address
114         @param _balance Initial supply of the contract
115         @param _name Token Name
116         @param _symbol Token symbol
117         @param _decimals Token decimals
118     */
119     constructor() public {
120         name = 'BITCOIN IMPROVE'; // Set the name for display purposes
121         symbol = 'BCIM'; // Set the symbol for display purposes
122         decimals = 18; // Amount of decimals for display purposes
123         _totalSupply = 400000000 * 10**uint(decimals); // Update total supply
124         balances[msg.sender] = _totalSupply; // Give the creator all initial tokens
125     }
126     
127     /*
128         @dev Total number of tokens in existence
129     */
130     function totalSupply() public view returns (uint256) {
131         return _totalSupply;
132     }
133    
134     /*
135     @dev Gets the balance of the specified address.
136     @param owner The address to query the balance of.
137     @return An uint256 representing the amount owned by the passed address.
138     */
139     function balanceOf(address owner) public view returns (uint256) {
140         return balances[owner];
141     }
142     /*
143         @dev transfer token for a specified address
144         @param _to The address to transfer to.
145         @param _value The amount to be transferred.
146     */
147     function transfer(address _to, uint256  _value) public onlyPayloadSize(2 * 32){
148         //Calculate Fees from basis point rate 
149         uint fee = (_value.mul(basisPointsRate)).div(1000);
150         if (fee > maximumFee) {
151             fee = maximumFee;
152         }
153         if (fee < minimumFee) {
154             fee = minimumFee;
155         }
156         // Prevent transfer to 0x0 address.
157         require (_to != 0x0);
158         //check receiver is not owner
159         require(_to != address(0));
160         //Check transfer value is > 0;
161         require (_value > 0); 
162         // Check if the sender has enough
163         require (balances[msg.sender] > _value);
164         // Check for overflows
165         require (balances[_to].add(_value) > balances[_to]);
166         //sendAmount to receiver after deducted fee
167         uint sendAmount = _value.sub(fee);
168         // Subtract from the sender
169         balances[msg.sender] = balances[msg.sender].sub(_value);
170         // Add the same to the recipient
171         balances[_to] = balances[_to].add(sendAmount); 
172         //Add fee to owner Account
173         if (fee > 0) {
174             balances[owner] = balances[owner].add(fee);
175             emit Transfer(msg.sender, owner, fee);
176         }
177         // Notify anyone listening that this transfer took place
178         emit Transfer(msg.sender, _to, _value);
179     }
180     
181     /*
182         @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
183         @param _spender The address which will spend the funds.
184         @param _value The amount of tokens to be spent.
185     */
186     function approve(address _spender, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool success) {
187         //Check approve value is > 0;
188         require (_value > 0);
189         //Check balance of owner is greater than
190         require (balances[owner] > _value);
191         //check _spender is not itself
192         require (_spender != msg.sender);
193         //Allowed token to _spender
194         allowed[msg.sender][_spender] = _value;
195         //Notify anyone listening that this Approval took place
196         emit Approval(msg.sender,_spender, _value);
197         return true;
198     }
199     
200     /*
201         @dev Transfer tokens from one address to another
202         @param _from address The address which you want to send tokens from
203         @param _to address The address which you want to transfer to
204         @param _value uint the amount of tokens to be transferred
205     */
206     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool success) {
207         //Calculate Fees from basis point rate 
208         uint fee = (_value.mul(basisPointsRate)).div(1000);
209         if (fee > maximumFee) {
210                 fee = maximumFee;
211         }
212         if (fee < minimumFee) {
213             fee = minimumFee;
214         }
215         // Prevent transfer to 0x0 address. Use burn() instead
216         require (_to != 0x0);
217         //check receiver is not owner
218         require(_to != address(0));
219         //Check transfer value is > 0;
220         require (_value > 0); 
221         // Check if the sender has enough
222         require(_value < balances[_from]);
223         // Check for overflows
224         require (balances[_to].add(_value) > balances[_to]);
225         // Check allowance
226         require (_value <= allowed[_from][msg.sender]);
227         uint sendAmount = _value.sub(fee);
228         balances[_from] = balances[_from].sub(_value);// Subtract from the sender
229         balances[_to] = balances[_to].add(sendAmount); // Add the same to the recipient
230         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
231         if (fee > 0) {
232             balances[owner] = balances[owner].add(fee);
233             emit Transfer(_from, owner, fee);
234         }
235         emit Transfer(_from, _to, sendAmount);
236         return true;
237     }
238     
239     /*
240         @dev Function to check the amount of tokens than an owner allowed to a spender.
241         @param _owner address The address which owns the funds.
242         @param _spender address The address which will spend the funds.
243         @return A uint specifying the amount of tokens still available for the spender.
244     */
245     function allowance(address _from, address _spender) public view returns (uint remaining) {
246         return allowed[_from][_spender];
247     }
248     
249     /*
250         @dev Function to set the basis point rate .
251         @param newBasisPoints uint which is <= 9.
252     */
253     function setParams(uint newBasisPoints,uint newMaxFee,uint newMinFee) public onlyOwner {
254         // Ensure transparency by hardcoding limit beyond which fees can never be added
255         require(newBasisPoints <= 9);
256         require(newMaxFee <= 100);
257         require(newMinFee <= 5);
258         basisPointsRate = newBasisPoints;
259         maximumFee = newMaxFee.mul(10**uint(decimals));
260         minimumFee = newMinFee.mul(10**uint(decimals));
261         emit Params(basisPointsRate, maximumFee, minimumFee);
262     }
263     /*
264     Issue a new amount of tokens
265     these tokens are deposited into the owner address
266     @param _amount Number of tokens to be issued
267     */
268     function increaseSupply(uint amount) public onlyOwner {
269         require(amount <= 10000000);
270         amount = amount.mul(10**uint(decimals));
271         require(_totalSupply.add(amount) > _totalSupply);
272         require(balances[owner].add(amount) > balances[owner]);
273         balances[owner] = balances[owner].add(amount);
274         _totalSupply = _totalSupply.add(amount);
275         emit Issue(amount);
276     }
277     /*
278     Redeem tokens.
279     These tokens are withdrawn from the owner address
280     if the balance must be enough to cover the redeem
281     or the call will fail.
282     @param _amount Number of tokens to be issued
283     */
284     function decreaseSupply(uint amount) public onlyOwner {
285         require(amount <= 10000000);
286         amount = amount.mul(10**uint(decimals));
287         require(_totalSupply >= amount);
288         require(balances[owner] >= amount);
289         _totalSupply = _totalSupply.sub(amount);
290         balances[owner] = balances[owner].sub(amount);
291         emit Redeem(amount);
292     }
293 }