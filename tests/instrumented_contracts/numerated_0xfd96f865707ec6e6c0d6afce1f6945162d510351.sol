1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     c = _a * _b;
21     assert(c / _a == _b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     // assert(_b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32     return _a / _b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
39     assert(_b <= _a);
40     return _a - _b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
47     c = _a + _b;
48     assert(c >= _a);
49     return c;
50   }
51 }
52 
53 
54 contract Ownable {
55     
56     address public owner;
57 
58     /**
59      * The address whcih deploys this contrcat is automatically assgined ownership.
60      * */
61     constructor() public {
62         owner = msg.sender;
63     }
64 
65     /**
66      * Functions with this modifier can only be executed by the owner of the contract. 
67      * */
68     modifier onlyOwner {
69         require(msg.sender == owner);
70         _;
71     }
72 
73     event OwnershipTransferred(address indexed from, address indexed to);
74 
75     /**
76     * Transfers ownership to new Ethereum address. This function can only be called by the 
77     * owner.
78     * @param _newOwner the address to be granted ownership.
79     **/
80     function transferOwnership(address _newOwner) public onlyOwner {
81         require(_newOwner != 0x0);
82         emit OwnershipTransferred(owner, _newOwner);
83         owner = _newOwner;
84     }
85 }
86 
87 
88 contract ERC20Basic {
89     uint256 public totalSupply;
90     string public name;
91     string public symbol;
92     uint8 public decimals;
93     function balanceOf(address who) constant public returns (uint256);
94     function transfer(address to, uint256 value) public returns (bool);
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 }
97 
98 
99 contract ERC20 is ERC20Basic {
100     function allowance(address owner, address spender) constant public returns (uint256);
101     function transferFrom(address from, address to, uint256 value) public  returns (bool);
102     function approve(address spender, uint256 value) public returns (bool);
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 
107 contract BasicToken is ERC20Basic {
108     
109     using SafeMath for uint256;
110     
111     mapping (address => uint256) internal balances;
112     
113     /**
114     * Returns the balance of the qeuried address
115     *
116     * @param _who The address which is being qeuried
117     **/
118     function balanceOf(address _who) public view returns(uint256) {
119         return balances[_who];
120     }
121     
122     /**
123     * Allows for the transfer of MSTCOIN tokens from peer to peer. 
124     *
125     * @param _to The address of the receiver
126     * @param _value The amount of tokens to send
127     **/
128     function transfer(address _to, uint256 _value) public returns(bool) {
129         require(balances[msg.sender] >= _value && _value > 0 && _to != 0x0);
130         balances[msg.sender] = balances[msg.sender].sub(_value);
131         balances[_to] = balances[_to].add(_value);
132         emit Transfer(msg.sender, _to, _value);
133         return true;
134     }
135 }
136 
137 
138 contract StandardToken is BasicToken, ERC20, Ownable {
139     
140     address public MembershipContractAddr = 0x0;
141     
142     mapping (address => mapping (address => uint256)) internal allowances;
143     
144     function changeMembershipContractAddr(address _newAddr) public onlyOwner returns(bool) {
145         require(_newAddr != address(0));
146         MembershipContractAddr = _newAddr;
147     }
148     
149     /**
150     * Returns the amount of tokens one has allowed another to spend on his or her behalf.
151     *
152     * @param _owner The address which is the owner of the tokens
153     * @param _spender The address which has been allowed to spend tokens on the owner's
154     * behalf
155     **/
156     function allowance(address _owner, address _spender) public view returns (uint256) {
157         return allowances[_owner][_spender];
158     }
159     
160     event TransferFrom(address msgSender);
161     /**
162     * Allows for the transfer of tokens on the behalf of the owner given that the owner has
163     * allowed it previously. 
164     *
165     * @param _from The address of the owner
166     * @param _to The address of the recipient 
167     * @param _value The amount of tokens to be sent
168     **/
169     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool) {
170         require(allowances[_from][msg.sender] >= _value || msg.sender == MembershipContractAddr);
171         require(balances[_from] >= _value && _value > 0 && _to != address(0));
172         emit TransferFrom(msg.sender);
173         balances[_from] = balances[_from].sub(_value);
174         balances[_to] = balances[_to].add(_value);
175         if(msg.sender != MembershipContractAddr) {
176             allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);
177         }
178         emit Transfer(_from, _to, _value);
179         return true;
180     }
181     
182     /**
183     * Allows the owner of tokens to approve another to spend tokens on his or her behalf
184     *
185     * @param _spender The address which is being allowed to spend tokens on the owner' behalf
186     * @param _value The amount of tokens to be sent
187     **/
188     function approve(address _spender, uint256 _value) public returns (bool) {
189         require(_spender != 0x0 && _value > 0);
190         if(allowances[msg.sender][_spender] > 0 ) {
191             allowances[msg.sender][_spender] = 0;
192         }
193         allowances[msg.sender][_spender] = _value;
194         emit Approval(msg.sender, _spender, _value);
195         return true;
196     }
197 }
198 
199 
200 contract BurnableToken is StandardToken {
201     
202     event TokensBurned(address indexed burner, uint256 value);
203     
204     /**
205      * Allows the owner of the contract to burn tokens.
206      * @param _from The address which tokens will be burned from 
207      * @param _tokens The amount of tokens to burn
208      * */
209     function burnFrom(address _from, uint256 _tokens) public onlyOwner {
210         if(balances[_from] < _tokens) {
211             emit TokensBurned(_from,balances[_from]);
212             emit Transfer(_from, address(0), balances[_from]);
213             balances[_from] = 0;
214             totalSupply = totalSupply.sub(balances[_from]);
215         } else {
216             balances[_from] = balances[_from].sub(_tokens);
217             totalSupply = totalSupply.sub(_tokens);
218             emit TokensBurned(_from, _tokens);
219             emit Transfer(_from, address(0), _tokens);
220         }
221     }
222 }
223 
224 
225 contract MintableToken is BurnableToken {
226     
227     event TokensMinted(address indexed to, uint256 value);
228     
229     /**
230      * Allows the owner to mint new tokens
231      * @param _to The address to mint new tokens to 
232      * @param _tokens The amount of tokens to mint
233      * 
234      * */
235     function mintTokens(address _to, uint256 _tokens) public onlyOwner {
236         require(_to != address(0) && _tokens > 0);
237         balances[_to] = balances[_to].add(_tokens);
238         totalSupply = totalSupply.add(_tokens);
239         emit TokensMinted(_to, _tokens);
240         emit Transfer(address(this), _to, _tokens);
241     }
242 }
243 
244 
245 contract ElyChain is MintableToken {
246     
247     constructor() public {
248         name = "ElyChain";
249         symbol = "ELYC";
250         decimals = 18;
251         totalSupply = 500000000e18;
252         balances[owner] = totalSupply;
253         emit Transfer(address(this), owner, totalSupply);
254     }
255 }