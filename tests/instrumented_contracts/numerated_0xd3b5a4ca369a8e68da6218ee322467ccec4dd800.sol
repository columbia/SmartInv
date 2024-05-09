1 pragma solidity 0.4.25;
2 
3 
4 /**
5  * 
6  * This contract is used to set admin to the contract  which has some additional features such as minting , burning etc
7  * 
8  */
9     contract Owned {
10         address public owner;      
11 
12         constructor() public {
13             owner = msg.sender;
14         }
15 
16         modifier onlyOwner {
17             require(msg.sender == owner);
18             _;
19         }
20         
21         /* This function is used to transfer adminship to new owner
22          * @param  _newOwner - address of new admin or owner        
23          */
24 
25         function transferOwnership(address _newOwner) onlyOwner public {
26             require(_newOwner != address(0)); 
27             owner = _newOwner;
28         }          
29     }
30 
31 /**
32  * @title Pausable
33  * @dev Base contract which allows children to implement an emergency stop mechanism.
34  */
35 contract Pausable is Owned {
36   event Pause();
37   event Unpause();
38 
39   bool public paused = false;
40 
41 
42   /**
43    * @dev Modifier to make a function callable only when the contract is not paused.
44    */
45   modifier whenNotPaused() {
46     require(!paused);
47     _;
48   }
49 
50   /**
51    * @dev Modifier to make a function callable only when the contract is paused.
52    */
53   modifier whenPaused() {
54     require(paused);
55     _;
56   }
57 
58   /**
59    * @dev called by the owner to pause, triggers stopped state
60    */
61   function pause() onlyOwner whenNotPaused public {
62     paused = true;
63     emit Pause();
64   }
65 
66   /**
67    * @dev called by the owner to unpause, returns to normal state
68    */
69   function unpause() onlyOwner whenPaused public {
70     paused = false;
71     emit Unpause();
72   }
73 }
74 
75 /**
76  * This is base ERC20 Contract , basically ERC-20 defines a common list of rules for all Ethereum tokens to follow
77  */ 
78 
79 contract ERC20 is Pausable{
80   
81   using SafeMath for uint256;
82 
83   //This creates an array with all balances 
84   mapping (address => uint256) public balanceOf;
85   mapping (address => mapping (address => uint256)) public allowed;  
86     
87   // public variables of the token  
88   string public name;
89   string public symbol;
90   uint8 public decimals = 18;
91   uint256 public totalSupply;
92    
93   // This notifies client about the approval done by owner to spender for a given value
94   event Approval(address indexed owner, address indexed spender, uint256 value);
95 
96   // This notifies client about the approval done
97   event Transfer(address indexed from, address indexed to, uint256 value);
98 
99    
100   constructor (uint256 _initialSupply,string _tokenName, string _tokenSymbol) public {    
101     totalSupply = _initialSupply * 10 ** uint256(decimals); // Update total supply with the decimal amount     
102     balanceOf[msg.sender] = totalSupply;  
103     name = _tokenName;
104     symbol = _tokenSymbol;   
105   }
106   
107     /* This function is used to transfer tokens to a particular address 
108      * @param _to receiver address where transfer is to be done
109      * @param _value value to be transferred
110      */
111 	function transfer(address _to, uint256 _value) public whenNotPaused returns (bool)  {      
112         require(balanceOf[msg.sender] > 0);                     
113         require(balanceOf[msg.sender] >= _value);                   // Check if the sender has enough  
114         require(_to != address(0));                                 // Prevent transfer to 0x0 address. Use burn() instead
115         require(_value > 0);	
116         require(_to != msg.sender);                                 // Check if sender and receiver is not same
117         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);  // Subtract value from sender
118         balanceOf[_to] = balanceOf[_to].add(_value);                // Add the value to the receiver
119         emit Transfer(msg.sender, _to, _value);                     // Notify all clients about the transfer events
120         return true;
121 	}
122 
123 	/* Send _value amount of tokens from address _from to address _to
124      * The transferFrom method is used for a withdraw workflow, allowing contracts to send
125      * tokens on your behalf
126      * @param _from address from which amount is to be transferred
127      * @param _to address to which amount is transferred
128      * @param _amount to which amount is transferred
129      */
130     function transferFrom(
131          address _from,
132          address _to,
133          uint256 _amount
134      ) public whenNotPaused returns (bool success)
135       { 
136         require(balanceOf[_from] >= _amount);
137         require(allowed[_from][msg.sender] >= _amount);
138         require(_amount > 0);
139         require(_to != address(0));           
140         require(_from!=_to);   
141         balanceOf[_from] = balanceOf[_from].sub(_amount);
142         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
143         balanceOf[_to] = balanceOf[_to].add(_amount);
144         emit Transfer(_from, _to, _amount);
145         return true;        
146     }
147     
148     /* This function allows _spender to withdraw from your account, multiple times, up to the _value amount.
149      * If this function is called again it overwrites the current allowance with _value.
150      * @param _spender address of the spender
151      * @param _amount amount allowed to be withdrawal
152      */
153      function approve(address _spender, uint256 _amount) public whenNotPaused  returns (bool success) {    
154          require(msg.sender!=_spender);  
155          allowed[msg.sender][_spender] = _amount;
156          emit Approval(msg.sender, _spender, _amount);
157          return true;
158     } 
159 
160     /* This function returns the amount of tokens approved by the owner that can be
161      * transferred to the spender's account
162      * @param _owner address of the owner
163      * @param _spender address of the spender 
164      */
165     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
166          return allowed[_owner][_spender];
167     }
168 }
169 
170 /**
171  * @title SafeMath
172  * @dev Math operations with safety checks that throw on error
173  */
174 library SafeMath {
175   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
176     if (a == 0) {
177       return 0;
178     }
179     uint256 c = a * b;
180     assert(c / a == b);
181     return c;
182   }
183 
184   function div(uint256 a, uint256 b) internal pure returns (uint256) {
185     // assert(b > 0); // Solidity automatically throws when dividing by 0
186     uint256 c = a / b;
187     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
188     return c;
189   }
190 
191   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
192     assert(b <= a);
193     return a - b;
194   }
195 
196   function add(uint256 a, uint256 b) internal pure returns (uint256) {
197     uint256 c = a + b;
198     assert(c >= a);
199     return c;
200   }
201 }
202 
203 
204 //This is the Main CryptoRiyal Token Contract derived from the other two contracts Owned and ERC20
205 contract CryptoRiyalToken is Owned, ERC20 {
206 
207     using SafeMath for uint256;
208 
209     uint256  public tokenSupply = 2000000000; 
210               
211     // This notifies clients about the amount burnt , only admin is able to burn the contract
212     event Burn(address from, uint256 value); 
213     
214     /* This is the main Token Constructor 
215      */
216 	constructor() 
217 
218 	ERC20 (tokenSupply,"CryptoRiyal","CR") public
219     {
220 		owner = msg.sender;
221         emit Transfer(address(0), msg.sender, tokenSupply);
222 	}          
223 
224     /**
225     * This function Burns a specific amount of tokens.
226     * @param _value The amount of token to be burned.
227     */
228     function burn(uint256 _value) public onlyOwner {
229       require(_value <= balanceOf[msg.sender]);
230       // no need to require value <= totalSupply, since that would imply the
231       // sender's balance is greater than the totalSupply, which *should* be an assertion failure
232       address burner = msg.sender;
233       balanceOf[burner] = balanceOf[burner].sub(_value);
234       totalSupply = totalSupply.sub(_value);
235       emit Burn(burner, _value);
236   }
237    
238 }