1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 /**
39  * 
40  * This contract is used to set admin to the contract  which has some additional features such as minting , burning etc
41  * 
42  */
43     contract Owned {
44         address public owner;      
45 
46         constructor() public {
47             owner = msg.sender;
48         }
49 
50         modifier onlyOwner {
51             require(msg.sender == owner);
52             _;
53         }
54         
55         /* This function is used to transfer adminship to new owner
56          * @param  _newOwner - address of new admin or owner        
57          */
58 
59         function transferOwnership(address _newOwner) onlyOwner public {
60             require(_newOwner != address(0)); 
61             owner = _newOwner;
62         }          
63     }
64 
65 /**
66  * @title Pausable
67  * @dev Base contract which allows children to implement an emergency stop mechanism.
68  */
69 contract Pausable is Owned {
70   event Pause();
71   event Unpause();
72 
73   bool public paused = false;
74 
75 
76   /**
77    * @dev Modifier to make a function callable only when the contract is not paused.
78    */
79   modifier whenNotPaused() {
80     require(!paused);
81     _;
82   }
83 
84   /**
85    * @dev Modifier to make a function callable only when the contract is paused.
86    */
87   modifier whenPaused() {
88     require(paused);
89     _;
90   }
91 
92   /**
93    * @dev called by the owner to pause, triggers stopped state
94    */
95   function pause() onlyOwner whenNotPaused public {
96     paused = true;
97     emit Pause();
98   }
99 
100   /**
101    * @dev called by the owner to unpause, returns to normal state
102    */
103   function unpause() onlyOwner whenPaused public {
104     paused = false;
105     emit Unpause();
106   }
107 }
108 
109 
110 /**
111  * This is base ERC20 Contract , basically ERC-20 defines a common list of rules for all Ethereum tokens to follow
112  */ 
113 
114 contract ERC20 is Pausable{
115   
116   using SafeMath for uint256;
117 
118   //This creates an array with all balances 
119   mapping (address => uint256) public balanceOf;
120   mapping (address => mapping (address => uint256)) public allowed;  
121     
122   // public variables of the token  
123   string public name;
124   string public symbol;
125   uint8 public decimals = 18;
126   uint256 public totalSupply;
127    
128   // This notifies client about the approval done by owner to spender for a given value
129   event Approval(address indexed owner, address indexed spender, uint256 value);
130 
131   // This notifies client about the approval done
132   event Transfer(address indexed from, address indexed to, uint256 value);
133 
134    
135   constructor (uint256 _initialSupply,string _tokenName, string _tokenSymbol) public {    
136     totalSupply = _initialSupply * 10 ** uint256(decimals); // Update total supply with the decimal amount     
137     balanceOf[msg.sender] = totalSupply;  
138     name = _tokenName;
139     symbol = _tokenSymbol;   
140   }
141   
142     /* This function is used to transfer tokens to a particular address 
143      * @param _to receiver address where transfer is to be done
144      * @param _value value to be transferred
145      */
146 	function transfer(address _to, uint256 _value) public whenNotPaused returns (bool)  {      
147         require(balanceOf[msg.sender] > 0);                     
148         require(balanceOf[msg.sender] >= _value);                   // Check if the sender has enough  
149         require(_to != address(0));                                 // Prevent transfer to 0x0 address. Use burn() instead
150         require(_value > 0);	
151         require(_to != msg.sender);                                 // Check if sender and receiver is not same
152         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);  // Subtract value from sender
153         balanceOf[_to] = balanceOf[_to].add(_value);                // Add the value to the receiver
154         emit Transfer(msg.sender, _to, _value);                     // Notify all clients about the transfer events
155         return true;
156 	}
157 
158 	/* Send _value amount of tokens from address _from to address _to
159      * The transferFrom method is used for a withdraw workflow, allowing contracts to send
160      * tokens on your behalf
161      * @param _from address from which amount is to be transferred
162      * @param _to address to which amount is transferred
163      * @param _amount to which amount is transferred
164      */
165     function transferFrom(
166          address _from,
167          address _to,
168          uint256 _amount
169      ) public whenNotPaused returns (bool success)
170       { 
171         require(balanceOf[_from] >= _amount);
172         require(allowed[_from][msg.sender] >= _amount);
173         require(_amount > 0);
174         require(_to != address(0));           
175         require(_from!=_to);   
176         balanceOf[_from] = balanceOf[_from].sub(_amount);
177         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
178         balanceOf[_to] = balanceOf[_to].add(_amount);
179         emit Transfer(_from, _to, _amount);
180         return true;        
181     }
182     
183     /* This function allows _spender to withdraw from your account, multiple times, up to the _value amount.
184      * If this function is called again it overwrites the current allowance with _value.
185      * @param _spender address of the spender
186      * @param _amount amount allowed to be withdrawal
187      */
188      function approve(address _spender, uint256 _amount) public whenNotPaused  returns (bool success) {    
189          require(msg.sender!=_spender);  
190          allowed[msg.sender][_spender] = _amount;
191          emit Approval(msg.sender, _spender, _amount);
192          return true;
193     } 
194 
195     /* This function returns the amount of tokens approved by the owner that can be
196      * transferred to the spender's account
197      * @param _owner address of the owner
198      * @param _spender address of the spender 
199      */
200     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
201          return allowed[_owner][_spender];
202     }
203 }
204 
205 
206 //This is the Main Harambee Token Contract derived from the other two contracts Owned and ERC20
207 contract HarambeeToken is Owned, ERC20 {
208 
209     using SafeMath for uint256;
210 
211     uint256  public tokenSupply = 1000000000; 
212               
213     // This notifies clients about the amount burnt , only admin is able to burn the contract
214     event Burn(address from, uint256 value); 
215     
216     /* This is the main Token Constructor 
217      */
218 	constructor() 
219 
220 	ERC20 (tokenSupply,"Harambee","HRBE") public
221     {
222 		owner = msg.sender;
223 	}
224           
225 
226     /**
227     * This function Burns a specific amount of tokens.
228     * @param _value The amount of token to be burned.
229     */
230     function burn(uint256 _value) public onlyOwner {
231       require(_value <= balanceOf[msg.sender]);
232       // no need to require value <= totalSupply, since that would imply the
233       // sender's balance is greater than the totalSupply, which *should* be an assertion failure
234       address burner = msg.sender;
235       balanceOf[burner] = balanceOf[burner].sub(_value);
236       totalSupply = totalSupply.sub(_value);
237       emit Burn(burner, _value);
238   }
239 
240     /**
241      * This function is used to destroy the contract
242      */
243     function destroyContract() public onlyOwner{
244         selfdestruct(owner);
245     }
246 }