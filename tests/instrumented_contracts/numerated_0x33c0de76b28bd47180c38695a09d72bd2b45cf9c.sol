1 pragma solidity ^0.4.17;
2 
3 
4 contract Ownable {
5     
6     address public owner;
7 
8     /**
9      * The address whcih deploys this contrcat is automatically assgined ownership.
10      * */
11     function Ownable() public {
12         owner = msg.sender;
13     }
14 
15     /**
16      * Functions with this modifier can only be executed by the owner of the contract. 
17      * */
18     modifier onlyOwner {
19         require(msg.sender == owner);
20         _;
21     }
22 
23     event OwnershipTransferred(address indexed from, address indexed to);
24 
25     /**
26     * Transfers ownership to new Ethereum address. This function can only be called by the 
27     * owner.
28     * @param _newOwner the address to be granted ownership.
29     **/
30     function transferOwnership(address _newOwner) public onlyOwner {
31         require(_newOwner != 0x0);
32         OwnershipTransferred(owner, _newOwner);
33         owner = _newOwner;
34     }
35 }
36 
37 
38 
39 
40 library SafeMath {
41     
42     function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
43         uint256 c = a * b;
44         assert(a == 0 || c / a == b);
45         return c;
46     }
47 
48     function div(uint256 a, uint256 b) internal pure  returns (uint256) {
49         uint256 c = a / b;
50         return c;
51     }
52 
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         assert(b <= a);
55         return a - b;
56     }
57 
58     function add(uint256 a, uint256 b) internal pure returns (uint256) {
59         uint256 c = a + b;
60         assert(c >= a);
61         return c;
62     }
63 }
64 
65 
66 
67 
68 contract ERC20Basic {
69     uint256 public totalSupply;
70     string public name;
71     string public symbol;
72     uint8 public decimals;
73     function balanceOf(address who) constant public returns (uint256);
74     function transfer(address to, uint256 value) public returns (bool);
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 
79 
80 
81 contract ERC20 is ERC20Basic {
82     function allowance(address owner, address spender) constant public returns (uint256);
83     function transferFrom(address from, address to, uint256 value) public  returns (bool);
84     function approve(address spender, uint256 value) public returns (bool);
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 
89 
90 
91 contract BasicToken is ERC20Basic {
92     
93     using SafeMath for uint256;
94     
95     mapping (address => uint256) internal balances;
96     
97     /**
98     * Returns the balance of the qeuried address
99     *
100     * @param _who The address which is being qeuried
101     **/
102     function balanceOf(address _who) public view returns(uint256) {
103         return balances[_who];
104     }
105     
106     /**
107     * Allows for the transfer of MSTCOIN tokens from peer to peer. 
108     *
109     * @param _to The address of the receiver
110     * @param _value The amount of tokens to send
111     **/
112     function transfer(address _to, uint256 _value) public returns(bool) {
113         require(balances[msg.sender] >= _value && _value > 0 && _to != 0x0);
114         balances[msg.sender] = balances[msg.sender].sub(_value);
115         balances[_to] = balances[_to].add(_value);
116         Transfer(msg.sender, _to, _value);
117         return true;
118     }
119 }
120 
121 
122 
123 
124 contract StandardToken is BasicToken, ERC20 {
125     
126     mapping (address => mapping (address => uint256)) internal allowances;
127     
128     /**
129     * Returns the amount of tokens one has allowed another to spend on his or her behalf.
130     *
131     * @param _owner The address which is the owner of the tokens
132     * @param _spender The address which has been allowed to spend tokens on the owner's
133     * behalf
134     **/
135     function allowance(address _owner, address _spender) public view returns (uint256) {
136         return allowances[_owner][_spender];
137     }
138     
139     /**
140     * Allows for the transfer of tokens on the behalf of the owner given that the owner has
141     * allowed it previously. 
142     *
143     * @param _from The address of the owner
144     * @param _to The address of the recipient 
145     * @param _value The amount of tokens to be sent
146     **/
147     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool) {
148         require(allowances[_from][msg.sender] >= _value && _to != 0x0 && balances[_from] >= _value && _value > 0);
149         balances[_from] = balances[_from].sub(_value);
150         balances[_to] = balances[_to].add(_value);
151         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);
152         Transfer(_from, _to, _value);
153         return true;
154     }
155     
156     /**
157     * Allows the owner of tokens to approve another to spend tokens on his or her behalf
158     *
159     * @param _spender The address which is being allowed to spend tokens on the owner' behalf
160     * @param _value The amount of tokens to be sent
161     **/
162     function approve(address _spender, uint256 _value) public returns (bool) {
163         require(_spender != 0x0 && _value > 0);
164         if(allowances[msg.sender][_spender] > 0 ) {
165             allowances[msg.sender][_spender] = 0;
166         }
167         allowances[msg.sender][_spender] = _value;
168         Approval(msg.sender, _spender, _value);
169         return true;
170     }
171 }
172 
173 
174 
175 
176 contract Pausable is Ownable {
177    
178     event Pause();
179     event Unpause();
180     event Freeze ();
181     event LogFreeze();
182 
183     address public constant IcoAddress = 0xe9c5c1c7dA613Ef0749492dA01129DDDbA484857;  
184     address public constant founderAddress = 0xF748D2322ADfE0E9f9b262Df6A2aD6CBF79A541A;
185 
186     bool public paused = true;
187     
188     /**
189     * @dev modifier to allow actions only when the contract IS paused or if the 
190     * owner or ICO contract is invoking the action
191     */
192     modifier whenNotPaused() {
193         require(!paused || msg.sender == IcoAddress || msg.sender == founderAddress);
194         _;
195     }
196 
197     /**
198     * @dev modifier to allow actions only when the contract IS NOT paused
199     */
200     modifier whenPaused() {
201         require(paused);
202         _;
203     }
204 
205     /**
206     * @dev called by the owner to pause, triggers stopped state
207     */
208     function pause() public onlyOwner {
209         paused = true;
210         Pause();
211     }
212     
213 
214     /**
215     * @dev called by the owner to unpause, returns to normal state
216     */
217     function unpause() public onlyOwner {
218         paused = false;
219         Unpause();
220     }
221     
222 }
223 
224 
225 
226 
227 contract PausableToken is StandardToken, Pausable {
228 
229   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
230     return super.transfer(_to, _value);
231   }
232 
233   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
234     return super.transferFrom(_from, _to, _value);
235   }
236 
237   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
238     return super.approve(_spender, _value);
239   }
240 }
241 
242 
243 
244 
245 contract MSTCOIN is PausableToken {
246     
247     function MSTCOIN() public {
248         name = "MSTCOIN";
249         symbol = "MSTCOIN";
250         decimals = 6;
251         totalSupply = 500000000e6;
252         balances[founderAddress] = totalSupply;
253         Transfer(address(this), founderAddress, totalSupply);
254     }
255     
256     event Burn(address indexed burner, uint256 value);
257     
258     /**
259     * Allows the owner to burn his own tokens.
260     * 
261     * @param _value The amount of token to be burned
262     */
263     function burn(uint256 _value) public onlyOwner {
264         _burn(msg.sender, _value);
265     }
266     
267     /**
268     * Function is internally called by the burn function. 
269     *
270     * @param _who Will always be the owners address
271     * @param _value The amount of tokens to be burned
272     **/
273     function _burn(address _who, uint256 _value) internal {
274         require(_value <= balances[_who]);
275         balances[_who] = balances[_who].sub(_value);
276         totalSupply = totalSupply.sub(_value);
277         Burn(_who, _value);
278         Transfer(_who, address(0), _value);
279     }
280 }