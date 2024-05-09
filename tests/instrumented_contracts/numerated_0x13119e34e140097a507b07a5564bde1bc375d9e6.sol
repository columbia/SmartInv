1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
7         // benefit is lost if 'b' is also tested.
8         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
9         if (a == 0) {
10             return 0;
11         }
12 
13         c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18  
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         // assert(b > 0); // Solidity automatically throws when dividing by 0
21         // uint256 c = a / b;
22         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23         return a / b;
24     }
25 
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         assert(b <= a);
29         return a - b;
30     }
31 
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
34         c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 }
39 
40 /**
41  * @title Owned Interface
42  * @dev Owned is interface for owner contract
43  */
44 
45 contract Owned {
46     constructor() public { owner = msg.sender; }
47     address owner;
48     
49     
50     event OwnershipRenounced(address indexed previousOwner);
51     event OwnershipTransferred(
52         address indexed previousOwner,
53         address indexed newOwner
54     );
55 
56     /**
57     * @dev Throws if called by any account other than the owner.
58     */
59     modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     /**
65     * @dev Allows the current owner to relinquish control of the contract.
66     * @notice Renouncing to ownership will leave the contract without an owner.
67     * It will not be possible to call the functions with the `onlyOwner`
68     * modifier anymore.
69    */
70     
71     function renounceOwnership() public onlyOwner {
72         emit OwnershipRenounced(owner);
73         owner = address(0);
74     }
75 
76     /**
77      * @dev Allows the current owner to transfer control of the contract to a newOwner.
78      * @param _newOwner The address to transfer ownership to.
79     */
80     function transferOwnership(address _newOwner) public onlyOwner {
81         _transferOwnership(_newOwner);
82     }
83 
84    /**
85    * @dev Transfers control of the contract to a newOwner.
86    * @param _newOwner The address to transfer ownership to.
87    */
88     function _transferOwnership(address _newOwner) internal {
89         require(_newOwner != address(0));
90         emit OwnershipTransferred(owner, _newOwner);
91         owner = _newOwner;
92     }
93 }
94 
95 /**
96  * @title InitialMTTokenIMT Interface
97  * @dev InitialMTTokenIMT is a token ERC20 contract for MTTokenIMT (MTTokenIMT.com)
98  */
99 
100 contract IMTTokenIMTInterface is Owned {
101 
102     /** total amount of tokens **/
103     uint256 public totalSupply;
104 
105     /** 
106      * @param _owner The address from which the balance will be retrieved
107      * @return The balance
108     **/
109     
110     function balanceOf(address _owner) public view returns (uint256 balance);
111 
112 
113     
114     /** @notice send `_value` token to `_to` from `msg.sender`
115      * @param _to The address of the recipient
116      * @param _value The amount of token to be transferred
117      * @return Whether the transfer was successful or not
118     **/
119      
120     function transfer(address _to, uint256 _value) public returns (bool success);
121 
122     /** 
123      * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
124      * @param _from The address of the sender
125      * @param _to The address of the recipient
126      * @param _value The amount of token to be transferred
127      * @return Whether the transfer was successful or not
128      **/
129      
130     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
131 
132     /**
133      * @notice `msg.sender` approves `_spender` to spend `_value` tokens
134      * @param _spender The address of the account able to transfer the tokens
135      * @param _value The amount of tokens to be approved for transfer
136      * @return Whether the approval was successful or not
137      **/
138      
139     function approve(address _spender, uint256 _value) public returns (bool success);
140 
141     /** @param _owner The address of the account owning tokens
142      * @param _spender The address of the account able to transfer the tokens
143      * @return Amount of remaining tokens allowed to spent
144      **/
145  
146     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
147     
148     // solhint-disable-next-line no-simple-event-func-name  
149     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
150     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
151    
152 }
153 
154 /**
155  * @title InitialMTTokenIMT
156  * @dev InitialMTTokenIMT is a token ERC20 contract for MTTokenIMT (MTTokenIMT.com)
157  */
158 contract InitialMTTokenIMT is IMTTokenIMTInterface {
159     
160     using SafeMath for uint256;
161     
162     mapping (address => uint256) public balances;
163     mapping (address => mapping (address => uint256)) public allowed;
164 
165 
166 
167     //specific events
168     event Burn(address indexed burner, uint256 value);
169 
170     
171     string public name;                   //Initial Money Token
172     uint8 public decimals;                //18
173     string public symbol;                 //IMT
174     
175     constructor (
176         uint256 _initialAmount,
177         string _tokenName,
178         uint8 _decimalUnits,
179         string _tokenSymbol
180     ) public {
181 
182         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
183         totalSupply = _initialAmount;                        // Update total supply
184         name = _tokenName;                                   // Set the name for display purposes
185         decimals = _decimalUnits;                            // Amount of decimals for display purposes
186         symbol = _tokenSymbol;                               // Set the symbol for display purposes    
187     }
188     
189     
190     function transfer(address _to, uint256 _value)  public returns (bool success) {
191         _transfer(msg.sender, _to, _value);
192         return true;
193     }
194     
195     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
196         _transferFrom(msg.sender, _from, _to, _value);
197         return true;
198     }
199 
200     function balanceOf(address _owner) public view returns (uint256 balance) {
201         return balances[_owner];
202     }
203     
204     
205     function burn(uint256 _value) public onlyOwner returns (bool success) {
206        _burn(msg.sender, _value);
207        return true;      
208     }
209 
210     function approve(address _spender, uint256 _value) public returns (bool success) {
211         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
212         allowed[msg.sender][_spender] = _value;
213         emit Approval(msg.sender, _spender, _value);
214         return true;
215     }
216 
217     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
218         return allowed[_owner][_spender];
219     }   
220 
221      /** 
222        * Specific functins for contract
223      **/
224         
225     //resend any tokens
226     function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success){
227         return IMTTokenIMTInterface(tokenAddress).transfer(owner, tokens);
228     }
229 
230     /** 
231       * internal functions
232     **/
233     
234     
235     //burn function
236     function _burn(address _who, uint256 _value) internal returns (bool success) {
237      
238         balances[_who] = balances[_who].sub(_value);
239         totalSupply = totalSupply.sub(_value);
240         emit Burn(_who, _value);
241         emit Transfer(_who, address(0), _value);
242 
243         return true;
244     }
245 
246     function _transfer(address _from, address _to, uint256 _value) internal  returns (bool success) {
247          
248         balances[_from] = balances[_from].sub(_value);
249         balances[_to] = balances[_to].add(_value);
250         emit Transfer(msg.sender, _to, _value);
251         
252         return true;
253     }
254 
255     function _transferFrom(address _who, address _from, address _to, uint256 _value) internal returns (bool success) {
256         
257         uint256 allow = allowed[_from][_who];
258         require(balances[_from] >= _value && allow >= _value);
259 
260         balances[_to] = balances[_to].add(_value);
261         balances[_from] = balances[_from].sub(_value);
262         allowed[_from][_who] = allowed[_from][_who].sub(_value);
263         
264         emit Transfer(_from, _to, _value);
265         
266         return true;
267     }
268 }