1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal constant returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract Ownable {
30     address public owner;
31 
32 
33     /**
34      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35      * account.
36      */
37     function Ownable() {
38         owner = msg.sender;
39     }
40 
41 
42     /**
43      * @dev Throws if called by any account other than the owner.
44      */
45     modifier onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49 
50 
51     /**
52      * @dev Allows the current owner to transfer control of the contract to a newOwner.
53      * @param newOwner The address to transfer ownership to.
54      */
55     function transferOwnership(address newOwner) onlyOwner {
56         if (newOwner != address(0)) {
57             owner = newOwner;
58         }
59     }
60 
61 }
62 
63 contract ERC20Basic {
64     uint256 public totalSupply;
65     function balanceOf(address who) constant returns (uint256);
66     function transfer(address to, uint256 value) returns (bool);
67 
68     // KYBER-NOTE! code changed to comply with ERC20 standard
69     event Transfer(address indexed _from, address indexed _to, uint _value);
70     //event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 
73 contract BasicToken is ERC20Basic {
74     using SafeMath for uint256;
75 
76     mapping(address => uint256) balances;
77 
78     /**
79     * @dev transfer token for a specified address
80     * @param _to The address to transfer to.
81     * @param _value The amount to be transferred.
82     */
83     function transfer(address _to, uint256 _value) returns (bool) {
84         balances[msg.sender] = balances[msg.sender].sub(_value);
85         balances[_to] = balances[_to].add(_value);
86         Transfer(msg.sender, _to, _value);
87         return true;
88     }
89 
90     /**
91     * @dev Gets the balance of the specified address.
92     * @param _owner The address to query the the balance of. 
93     * @return An uint256 representing the amount owned by the passed address.
94     */
95     function balanceOf(address _owner) constant returns (uint256 balance) {
96         return balances[_owner];
97     }
98 
99 }
100 
101 contract ERC20 is ERC20Basic {
102     function allowance(address owner, address spender) constant returns (uint256);
103     function transferFrom(address from, address to, uint256 value) returns (bool);
104     function approve(address spender, uint256 value) returns (bool);
105 
106     // KYBER-NOTE! code changed to comply with ERC20 standard
107     event Approval(address indexed _owner, address indexed _spender, uint _value);
108     //event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 contract StandardToken is ERC20, BasicToken {
112 
113     mapping (address => mapping (address => uint256)) allowed;
114 
115 
116     /**
117      * @dev Transfer tokens from one address to another
118      * @param _from address The address which you want to send tokens from
119      * @param _to address The address which you want to transfer to
120      * @param _value uint256 the amout of tokens to be transfered
121      */
122     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
123         var _allowance = allowed[_from][msg.sender];
124 
125         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
126         // require (_value <= _allowance);
127 
128         // KYBER-NOTE! code changed to comply with ERC20 standard
129         balances[_from] = balances[_from].sub(_value);
130         balances[_to] = balances[_to].add(_value);
131         //balances[_from] = balances[_from].sub(_value); // this was removed
132         allowed[_from][msg.sender] = _allowance.sub(_value);
133         Transfer(_from, _to, _value);
134         return true;
135     }
136 
137     /**
138      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
139      * @param _spender The address which will spend the funds.
140      * @param _value The amount of tokens to be spent.
141      */
142     function approve(address _spender, uint256 _value) returns (bool) {
143 
144         // To change the approve amount you first have to reduce the addresses`
145         //  allowance to zero by calling `approve(_spender, 0)` if it is not
146         //  already 0 to mitigate the race condition described here:
147         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
148         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
149 
150         allowed[msg.sender][_spender] = _value;
151         Approval(msg.sender, _spender, _value);
152         return true;
153     }
154 
155     /**
156      * @dev Function to check the amount of tokens that an owner allowed to a spender.
157      * @param _owner address The address which owns the funds.
158      * @param _spender address The address which will spend the funds.
159      * @return A uint256 specifing the amount of tokens still avaible for the spender.
160      */
161     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
162         return allowed[_owner][_spender];
163     }
164 
165 }
166 
167 contract REKTTokenSale {
168     using SafeMath for uint;
169 
170     address             public admin;
171     address             public REKTMultiSigWallet;
172     REKT                public token;
173     bool                public haltSale;
174 
175     function REKTTokenSale( address _admin,
176     address _REKTMultiSigWallet,
177     REKT _token)
178     {
179         admin = _admin;
180         REKTMultiSigWallet = _REKTMultiSigWallet;
181 
182         token = _token;
183     }
184 
185     function setHaltSale( bool halt ) {
186         require( msg.sender == admin );
187         haltSale = halt;
188     }
189 
190     function() payable {
191         buy( msg.sender );
192     }
193 
194     event Buy( address _buyer, uint _tokens, uint _payedWei );
195     function buy( address recipient ) payable returns(uint){
196         require( ! haltSale );
197 
198         // send payment to wallet
199         sendETHToMultiSig( msg.value );
200         uint receivedTokens = msg.value.mul( 1000 );
201 
202         assert( token.transfer( recipient, receivedTokens ) );
203 
204 
205         Buy( recipient, receivedTokens, msg.value );
206 
207         return msg.value;
208     }
209 
210     function sendETHToMultiSig( uint value ) internal {
211         REKTMultiSigWallet.transfer( value );
212     }
213 
214     // ETH balance is always expected to be 0.
215     // but in case something went wrong, we use this function to extract the eth.
216     function emergencyDrain(ERC20 anyToken) returns(bool){
217         require( msg.sender == admin );
218 
219         if( this.balance > 0 ) {
220             sendETHToMultiSig( this.balance );
221         }
222 
223         if( anyToken != address(0x0) ) {
224             assert( anyToken.transfer(REKTMultiSigWallet, anyToken.balanceOf(this)) );
225         }
226 
227         return true;
228     }
229 }
230 
231 contract REKT is StandardToken, Ownable {
232     string  public  constant name = "REKT";
233     string  public  constant symbol = "REKT";
234     uint    public  constant decimals = 18;
235 
236     address public  tokenSaleContract;
237 
238     modifier validDestination( address to ) {
239         require(to != address(0x0));
240         require(to != address(this) );
241         _;
242     }
243 
244     function REKT( uint tokenTotalAmount, address admin ) {
245         // Mint all tokens. Then disable minting forever.
246         balances[msg.sender] = tokenTotalAmount.div(2);
247         balances[admin] = tokenTotalAmount.div(2);
248         totalSupply = tokenTotalAmount;
249         Transfer(address(0x0), msg.sender, tokenTotalAmount);
250 
251         tokenSaleContract = msg.sender;
252         transferOwnership(admin); // admin could drain tokens that were sent here by mistake
253     }
254 
255     function transfer(address _to, uint _value)
256     validDestination(_to)
257     returns (bool) {
258         return super.transfer(_to, _value);
259     }
260 
261     function setTokenSaleContract(address _tokenSaleContract) onlyOwner {
262         tokenSaleContract = _tokenSaleContract;
263     }
264 
265     function transferFrom(address _from, address _to, uint _value)
266     validDestination(_to)
267     returns (bool) {
268         return super.transferFrom(_from, _to, _value);
269     }
270 
271     event Burn(address indexed _burner, uint _value);
272 
273     function burn(uint _value)
274     returns (bool){
275         balances[msg.sender] = balances[msg.sender].sub(_value);
276         totalSupply = totalSupply.sub(_value);
277         Burn(msg.sender, _value);
278         Transfer(msg.sender, address(0x0), _value);
279         return true;
280     }
281 
282     // save some gas by making only one contract call
283     function burnFrom(address _from, uint256 _value)
284     returns (bool) {
285         assert( transferFrom( _from, msg.sender, _value ) );
286         return burn(_value);
287     }
288 
289     function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner {
290         token.transfer( owner, amount );
291     }
292 }