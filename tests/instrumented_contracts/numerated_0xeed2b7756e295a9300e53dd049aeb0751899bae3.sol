1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 contract ERC20 is ERC20Basic {
16   function allowance(address owner, address spender) public view returns (uint256);
17   function transferFrom(address from, address to, uint256 value) public returns (bool);
18   function approve(address spender, uint256 value) public returns (bool);
19   event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 contract Ownable {
23   address public owner;
24 
25 
26   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28 
29   /**
30    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
31    * account.
32    */
33   function Ownable() {
34     owner = msg.sender;
35   }
36 
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address newOwner) onlyOwner public {
52     require(newOwner != address(0));
53     OwnershipTransferred(owner, newOwner);
54     owner = newOwner;
55   }
56 
57 }
58 
59 /**
60  * @title Pausable
61  * @dev Base contract which allows children to implement an emergency stop mechanism.
62  */
63 contract Pausable is Ownable {
64   event Pause();
65   event Unpause();
66 
67   bool public paused = false;
68 
69 
70   /**
71    * @dev Modifier to make a function callable only when the contract is not paused.
72    */
73   modifier whenNotPaused() {
74     require(!paused);
75     _;
76   }
77 
78   /**
79    * @dev Modifier to make a function callable only when the contract is paused.
80    */
81   modifier whenPaused() {
82     require(paused);
83     _;
84   }
85 
86   /**
87    * @dev called by the owner to pause, triggers stopped state
88    */
89   function pause() onlyOwner whenNotPaused public {
90     paused = true;
91     Pause();
92   }
93 
94   /**
95    * @dev called by the owner to unpause, returns to normal state
96    */
97   function unpause() onlyOwner whenPaused public {
98     paused = false;
99     Unpause();
100   }
101 }
102 
103 contract StandardToken is ERC20,Pausable {
104     using SafeMath for uint256;
105 
106     mapping (address => uint256) public balances;
107     mapping (address => mapping (address => uint256)) public allowed;
108 
109     /**
110     * @dev transfer token for a specified address
111     * @param _to The address to transfer to.
112     * @param _value The amount to be transferred.
113     */
114     function transfer(address _to, uint256 _value) whenNotPaused returns (bool success) {
115         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
116         balances[msg.sender] = balances[msg.sender].sub(_value);
117         balances[_to] = balances[_to].add(_value);
118         Transfer(msg.sender, _to, _value);
119         return true;
120     }
121 
122     /**
123     * @dev Transfer tokens from one address to another
124     * @param _from address The address which you want to send tokens from
125     * @param _to address The address which you want to transfer to
126     * @param _value uint256 the amout of tokens to be transfered
127     */
128     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool success) {
129         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
130         balances[_to] = balances[_to].add(_value);
131         balances[_from] = balances[_from].sub(_value);
132         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
133         Transfer(_from, _to, _value);
134         return true;
135     }
136 
137     /**
138     * @dev Gets the balance of the specified address.
139     * @param _owner The address to query the the balance of.
140     * @return An uint256 representing the amount owned by the passed address.
141     */
142     function balanceOf(address _owner) constant returns (uint256 balance) {
143         return balances[_owner];
144     }
145 
146     /**
147     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
148     * This only works when the allowance is 0. Cannot be used to change allowance.
149     * https://github.com/ethereum/EIPs/issues/738#issuecomment-336277632
150     * @param _spender The address which will spend the funds.
151     * @param _value The amount of tokens to be spent.
152     */
153     function approve(address _spender, uint256 _value) whenNotPaused returns (bool success) {
154         require(allowed[msg.sender][_spender] == 0);
155         allowed[msg.sender][_spender] = _value;
156         Approval(msg.sender, _spender, _value);
157         return true;
158     }
159 
160     /**
161     * @dev Function to check the amount of tokens that an owner allowed to a spender.
162     * @param _owner address The address which owns the funds.
163     * @param _spender address The address which will spend the funds.
164     * @return A uint256 specifing the amount of tokens still available for the spender.
165     */
166     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
167       return allowed[_owner][_spender];
168     }
169 
170     /**
171      * To increment allowed value is better to use this function.
172      * From MonolithDAO Token.sol
173      */
174     function increaseApproval(address _spender, uint _addedValue) whenNotPaused public returns (bool) {
175         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
176         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177         return true;
178     }
179 
180     function decreaseApproval(address _spender, uint _subtractedValue) whenNotPaused public returns (bool) {
181         uint oldValue = allowed[msg.sender][_spender];
182         if (_subtractedValue > oldValue) {
183             allowed[msg.sender][_spender] = 0;
184         } else {
185             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
186         }
187         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188         return true;
189     }
190 }
191 
192 library SafeMath {
193   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
194     uint256 c = a * b;
195     assert(a == 0 || c / a == b);
196     return c;
197   }
198 
199   function div(uint256 a, uint256 b) internal constant returns (uint256) {
200     assert(b > 0); // Solidity automatically throws when dividing by 0
201     uint256 c = a / b;
202     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
203     return c;
204   }
205 
206   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
207     assert(b <= a);
208     return a - b;
209   }
210 
211   function add(uint256 a, uint256 b) internal constant returns (uint256) {
212     uint256 c = a + b;
213     assert(c >= a);
214     return c;
215   }
216 }
217 
218 
219 /* Contract class to mint tokens and transfer */
220 contract DOGToken is StandardToken {
221   using SafeMath for uint256;
222 
223   string constant public name = 'DOG: The Anti-Scam Reward Token';
224   string constant public symbol = 'DOG';
225   uint constant public decimals = 18;
226   uint256 public totalSupply;
227   uint256 public maxSupply;
228 
229   /* Contructor function to set maxSupply*/
230   function DOGToken(uint256 _maxSupply){
231     maxSupply = _maxSupply.mul(10**decimals);
232   }
233 
234   /**
235  * @dev Function to mint tokens
236  * @param _amount The amount of tokens to mint.
237  * @return A boolean that indicates if the operation was successful.
238  */
239   function mint(uint256 _amount) onlyOwner public returns (bool) {
240     require (maxSupply >= (totalSupply.add(_amount)));
241     totalSupply = totalSupply.add(_amount);
242     balances[msg.sender] = balances[msg.sender].add(_amount);
243     Transfer(address(0), msg.sender, _amount);
244     return true;
245   }
246 
247 }