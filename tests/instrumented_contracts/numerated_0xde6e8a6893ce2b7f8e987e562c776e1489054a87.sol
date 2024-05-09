1 pragma solidity ^ 0.4.18;
2 
3 
4 library SafeMath {
5     function mul(uint a, uint b) internal pure  returns(uint) {
6         uint c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function sub(uint a, uint b) internal pure  returns(uint) {
12         assert(b <= a);
13         return a - b;
14     }
15 
16     function add(uint a, uint b) internal pure  returns(uint) {
17         uint c = a + b;
18         assert(c >= a && c >= b);
19         return c;
20     }
21 }
22 
23 /**
24  * @title Ownable
25  * @dev The Ownable contract has an owner address, and provides basic authorization control
26  * functions, this simplifies the implementation of "user permissions".
27  */
28 contract Ownable {
29     address public owner;
30     
31     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33     /**
34     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35     * account.
36     */
37     function Ownable() public {
38         owner = msg.sender;
39     }
40 
41     /**
42     * @dev Throws if called by any account other than the owner.
43     */
44     modifier onlyOwner() {
45         require(msg.sender == owner);
46         _;
47     }
48 
49     /**
50     * @dev Allows the current owner to transfer control of the contract to a newOwner.
51     * @param newOwner The address to transfer ownership to.
52     */
53     function transferOwnership(address newOwner) onlyOwner public {
54         require(newOwner != address(0));
55         OwnershipTransferred(owner, newOwner);
56         owner = newOwner;
57     }
58 
59 }
60 
61 contract ERC20 {
62     uint public totalSupply;
63 
64     function balanceOf(address who) public view returns(uint);
65 
66     function allowance(address owner, address spender) public view returns(uint);
67 
68     function transfer(address to, uint value) public returns(bool ok);
69 
70     function transferFrom(address from, address to, uint value) public returns(bool ok);
71 
72     function approve(address spender, uint value) public returns(bool ok);
73 
74     event Transfer(address indexed from, address indexed to, uint value);
75     event Approval(address indexed owner, address indexed spender, uint value);
76 }
77 
78 
79 // The token
80 contract Token is ERC20, Ownable {
81     
82     using SafeMath for uint;
83     
84     // Public variables of the token
85     string public name;
86     string public symbol;
87     uint8 public decimals; // How many decimals to show.
88     string public version = "v0.1";   
89     uint public totalSupply;
90     bool public locked;           
91     mapping(address => uint) balances;
92     mapping(address => mapping(address => uint)) allowed;
93     address public crowdSaleAddress;
94     
95 
96     // Lock transfer for contributors during the ICO 
97     modifier onlyUnlocked() {
98         if (msg.sender != crowdSaleAddress && msg.sender != owner && locked) 
99             revert();
100         _;
101     }
102 
103     modifier onlyAuthorized() {
104          if (msg.sender != owner && msg.sender != crowdSaleAddress) 
105             revert();
106         _;
107     }
108 
109     // @notice The Token contract   
110     function Token(address _crowdsaleAddress) public {    
111 
112         require(_crowdsaleAddress != address(0));                  
113         locked = true; // Lock the transfer of tokens during the crowdsale       
114         totalSupply = 2600000000e8;
115         name = "Kripton";                           // Set the name for display purposes
116         symbol = "LPK";                             // Set the symbol for display purposes
117         decimals = 8;                               // Amount of decimals for display purposes         
118         crowdSaleAddress = _crowdsaleAddress;
119         balances[_crowdsaleAddress] = totalSupply;          
120     }
121 
122     // @notice unlock token for trading
123     function unlock() public onlyAuthorized {
124         locked = false;
125     }
126 
127     // @lock token from trading during ICO
128     function lock() public onlyAuthorized {
129         locked = true;
130     }
131 
132     // @notice transfer tokens to given address 
133     // @param _to {address} address or recipient
134     // @param _value {uint} amount to transfer
135     // @return  {bool} true if successful  
136     function transfer(address _to, uint _value) public onlyUnlocked returns(bool) {
137         balances[msg.sender] = balances[msg.sender].sub(_value);
138         balances[_to] = balances[_to].add(_value);
139         Transfer(msg.sender, _to, _value);
140         return true;
141     }
142 
143     // @notice transfer tokens from given address to another address
144     // @param _from {address} from whom tokens are transferred 
145     // @param _to {address} to whom tokens are transferred
146     // @parm _value {uint} amount of tokens to transfer
147     // @return  {bool} true if successful   
148     function transferFrom(address _from, address _to, uint256 _value) public onlyUnlocked returns(bool success) {
149         require(balances[_from] >= _value); // Check if the sender has enough                            
150         require(_value <= allowed[_from][msg.sender]); // Check if allowed is greater or equal        
151         balances[_from] = balances[_from].sub(_value); // Subtract from the sender
152         balances[_to] = balances[_to].add(_value); // Add the same to the recipient
153         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154         Transfer(_from, _to, _value);
155         return true;
156     }
157 
158     // @notice to query balance of account
159     // @return _owner {address} address of user to query balance 
160     function balanceOf(address _owner) public view returns(uint balance) {
161         return balances[_owner];
162     }
163 
164     /**
165     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
166     *
167     * Beware that changing an allowance with this method brings the risk that someone may use both the old
168     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171     * @param _spender The address which will spend the funds.
172     * @param _value The amount of tokens to be spent.
173     */
174     function approve(address _spender, uint _value) public returns(bool) {
175         allowed[msg.sender][_spender] = _value;
176         Approval(msg.sender, _spender, _value);
177         return true;
178     }
179 
180     // @notice to query of allowance of one user to the other
181     // @param _owner {address} of the owner of the account
182     // @param _spender {address} of the spender of the account
183     // @return remaining {uint} amount of remaining allowance
184     function allowance(address _owner, address _spender) public view returns(uint remaining) {
185         return allowed[_owner][_spender];
186     }
187 
188     /**
189     * approve should be called when allowed[_spender] == 0. To increment
190     * allowed value is better to use this function to avoid 2 calls (and wait until
191     * the first transaction is mined)
192     * From MonolithDAO Token.sol
193     */
194     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
195         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
196         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197         return true;
198     }
199 
200     
201     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
202         uint oldValue = allowed[msg.sender][_spender];
203         if (_subtractedValue > oldValue) {
204             allowed[msg.sender][_spender] = 0;
205         } else {
206             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
207         }
208         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209         return true;
210     }
211 
212 }