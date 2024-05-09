1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4   address public owner;
5 
6   event OwnershipRenounced(address indexed previousOwner);
7 
8   event OwnershipTransferred(
9     address indexed previousOwner,
10     address indexed newOwner
11   );
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18     constructor () public {
19             owner = msg.sender;
20     }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) public onlyOwner {
35     require(newOwner != address(0));
36     emit OwnershipTransferred(owner, newOwner);
37     owner = newOwner;
38   }
39 
40   /**
41    * @dev Allows the current owner to relinquish control of the contract.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47   
48 }
49 
50 
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     emit Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     emit Unpause();
88   }
89 }
90  
91  
92 library SafeMath {
93     
94   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
95     uint256 c = a * b;
96     assert(a == 0 || c / a == b);
97     return c;
98   }
99 
100   function div(uint256 a, uint256 b) internal pure returns (uint256) {
101     assert(b > 0); // Solidity automatically throws when dividing by 0
102     uint256 c = a / b;
103     assert(a == b * c + a % b); // There is no case in which this doesn't hold
104     return c;
105   }
106 
107   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108     assert(b <= a);
109     return a - b;
110   }
111 
112   function add(uint256 a, uint256 b) internal pure returns (uint256) {
113     uint256 c = a + b;
114     assert(c >= a);
115     return c;
116   }
117 }
118 
119  
120 contract TokenERC20 {
121     function balanceOf(address who) public constant returns (uint);
122     function allowance(address owner, address spender) public constant returns (uint);
123     
124     function transfer(address to, uint value) public  returns (bool ok);
125     function transferFrom(address from, address to, uint value) public  returns (bool ok);
126     
127     function approve(address spender, uint value) public returns (bool ok);
128     
129     function burn(uint256 _value) public returns (bool success);
130     function burnFrom(address _from, uint256 _value) public returns (bool success);
131     
132     event Transfer(address indexed from, address indexed to, uint value);
133     event Approval(address indexed owner, address indexed spender, uint value);
134     event Burn(address indexed from, uint256 value);
135 
136 } 
137 
138 contract TokenERC20Standart is TokenERC20, Pausable{
139     
140         using SafeMath for uint256;
141         
142         string public name;                         // token name
143         uint256 public decimals;                    // Amount of decimals for display purposes 
144         string public symbol;                       // symbol token
145         string public version;                      // contract version 
146         uint256 public totalSupply; 
147             
148         // create array with all blances    
149         mapping(address => uint) public balances;
150         mapping(address => mapping(address => uint)) public allowed;
151         
152         /**
153         * @dev Fix for the ERC20 short address attack.
154         */
155         modifier onlyPayloadSize(uint size) {
156             require(msg.data.length >= size + 4) ;
157             _;
158         }
159             
160        
161         function balanceOf(address tokenOwner) public constant whenNotPaused  returns (uint balance) {
162              return balances[tokenOwner];
163         }
164  
165         function transfer(address to, uint256 tokens) public  whenNotPaused onlyPayloadSize(2*32) returns (bool success) {
166             _transfer(msg.sender, to, tokens);
167             return true;
168         }
169  
170 
171         function approve(address spender, uint tokens) public whenNotPaused returns (bool success) {
172             allowed[msg.sender][spender] = tokens;
173             emit Approval(msg.sender, spender, tokens);
174             return true;
175         }
176  
177         function transferFrom(address from, address to, uint tokens) public whenNotPaused onlyPayloadSize(3*32) returns (bool success) {
178             balances[from] = balances[from].sub(tokens);
179             allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
180             balances[to] = balances[to].add(tokens);
181             emit Transfer(from, to, tokens);
182             return true;
183         }
184 
185         function allowance(address tokenOwner, address spender) public  whenNotPaused constant returns (uint remaining) {
186             return allowed[tokenOwner][spender];
187         }
188 
189         function sell(address _recipient, uint256 _value) internal whenNotPaused returns (bool success) {
190             _transfer (owner, _recipient, _value);
191             return true;
192         }
193         
194         function _transfer(address _from, address _to, uint _value) internal {
195             assert(_value > 0);
196             require (_to != 0x0);                              
197             require (balances[_from] >= _value);               
198             require (balances[_to] + _value >= balances[_to]);
199             balances[_from] = balances[_from].sub(_value);                        
200             balances[_to] = balances[_to].add(_value);                           
201             emit Transfer(_from, _to, _value);
202         }
203 
204         function burn(uint256 _value) public returns (bool success) {
205             require(balances[msg.sender] >= _value);                             // Check if the sender has enough
206             balances[msg.sender] =  balances[msg.sender].sub(_value);            // Subtract from the sender
207             totalSupply = totalSupply.sub(_value);                              // Updates totalSupply
208             emit Burn(msg.sender, _value);
209             return true;
210         }
211 
212         function burnFrom(address _from, uint256 _value) public returns (bool success) {
213             require(balances[_from] >= _value);                                      // Check if the targeted balance is enough
214             require(_value <= allowed[_from][msg.sender]);                          // Check allowance
215             balances[_from] =  balances[_from].sub(_value);                         // Subtract from the targeted balance
216             allowed[_from][msg.sender] =   allowed[_from][msg.sender].sub(_value);   // Subtract from the sender's allowance
217             totalSupply = totalSupply.sub(_value);                                      // Update totalSupply
218             emit Burn(_from, _value);
219             return true;
220         }
221 
222 
223 }
224 
225 
226 contract BexProContract is TokenERC20Standart{
227     
228     using SafeMath for uint256;
229     mapping (address => bool) public frozenAccount;
230     event FrozenFunds(address target, bool frozen);
231 
232     constructor () public {
233         name = "BEXPRO";                        // Set the name for display purposes
234         decimals = 18;                          // Amount of decimals for display purposes
235         symbol = "BPRO";                        // Set the symbol for display purposes
236         owner = msg.sender;                     // Set contract owner
237         version = "1";                         // Set contract version 
238         totalSupply = 502000000 * 10 ** uint256(decimals);
239         balances[msg.sender] = totalSupply; // Give the creator all initial tokens
240         emit Transfer(address(0x0), msg.sender, totalSupply);
241     }
242     
243      function _transfer(address _from, address _to, uint _value) internal {
244         require (_to != 0x0);                               
245         require (balances[_from] >= _value);               
246         require (balances[_to] + _value >= balances[_to]); 
247         require(!frozenAccount[_from]);                     
248         require(!frozenAccount[_to]);                       
249         balances[_from] = balances[_from].sub(_value);                        
250         balances[_to] = balances[_to].add(_value);                           
251         emit Transfer(_from, _to, _value);
252     }
253     
254     function transfer(address _to, uint _value) public returns (bool) {
255         super._transfer(msg.sender, _to, _value);
256         return true;
257     }
258     
259     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
260         require(!frozenAccount[_from]);                     
261         require(!frozenAccount[_to]);  
262         return super.transferFrom(_from, _to, _value);
263     }
264     
265     function () public payable {
266         revert();
267     }
268    
269     function freezeAccount(address target, bool freeze) onlyOwner public {
270         frozenAccount[target] = freeze;
271         emit FrozenFunds(target, freeze);
272     }
273 }