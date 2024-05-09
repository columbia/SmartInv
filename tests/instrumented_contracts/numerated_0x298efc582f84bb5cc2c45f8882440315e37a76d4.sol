1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * Welcome to AKI Coin
6  *
7  * A world of luxury and comfort awaits the daring investor.
8  *
9  * Visit https://www.akicoin.io for more information
10  */
11 
12 /**
13  * @title Contract that will work with ERC223 tokens.
14  */
15  
16 contract ERC223ReceivingContract { 
17 /**
18  * @dev Standard ERC223 function that will handle incoming token transfers.
19  *
20  * @param _from  Token sender address.
21  * @param _value Amount of tokens.
22  * @param _data  Transaction metadata.
23  */
24     function tokenFallback(address _from, uint _value, bytes _data);
25 }
26 
27 /**
28  * Math operations with safety checks
29  */
30 library SafeMath {
31   function mul(uint a, uint b) internal returns (uint) {
32     uint c = a * b;
33     assert(a == 0 || c / a == b);
34     return c;
35   }
36 
37   function div(uint a, uint b) internal returns (uint) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   function sub(uint a, uint b) internal returns (uint) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   function add(uint a, uint b) internal returns (uint) {
50     uint c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 
55   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
56     return a >= b ? a : b;
57   }
58 
59   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
60     return a < b ? a : b;
61   }
62 
63   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
64     return a >= b ? a : b;
65   }
66 
67   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
68     return a < b ? a : b;
69   }
70 
71   function assert(bool assertion) internal {
72     if (!assertion) {
73       throw;
74     }
75   }
76 }
77 
78 contract ERC20CompatibleToken {
79     using SafeMath for uint;
80 
81     mapping(address => uint) balances; // List of user balances.
82 
83     event Transfer(address indexed from, address indexed to, uint value);
84   	event Approval(address indexed owner, address indexed spender, uint256 value);
85   	mapping (address => mapping (address => uint256)) internal allowed;
86 
87 
88    /**
89     * @dev Transfer tokens from one address to another
90     * @param _from address The address which you want to send tokens from
91     * @param _to address The address which you want to transfer to
92     * @param _value uint256 the amount of tokens to be transferred
93     */
94     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
95         uint codeLength;
96         bytes memory empty;
97 
98         assembly {
99             // Retrieve the size of the code on target address, this needs assembly .
100             codeLength := extcodesize(_to)
101         }
102         require(_to != address(0));
103         require(_value <= balances[_from]);
104         require(_value <= allowed[_from][msg.sender]);
105         balances[_from] = balances[_from].sub(_value);
106         balances[_to] = balances[_to].add(_value);
107         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
108         if(codeLength>0) {
109             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
110             receiver.tokenFallback(msg.sender, _value, empty);
111         }
112 
113         Transfer(_from, _to, _value);
114         return true;
115     }
116 
117   /**
118    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
119    *
120    * Beware that changing an allowance with this method brings the risk that someone may use both the old
121    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
122    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
123    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
124    * @param _spender The address which will spend the funds.
125    * @param _value The amount of tokens to be spent.
126    */
127     function approve(address _spender, uint256 _value) public returns (bool) {
128         allowed[msg.sender][_spender] = _value;
129         Approval(msg.sender, _spender, _value);
130         return true;
131     }
132 
133   /**
134    * @dev Function to check the amount of tokens that an owner allowed to a spender.
135    * @param _owner address The address which owns the funds.
136    * @param _spender address The address which will spend the funds.
137    * @return A uint256 specifying the amount of tokens still available for the spender.
138    */
139     function allowance(address _owner, address _spender) public view returns (uint256) {
140         return allowed[_owner][_spender];
141     }
142 
143   /**
144    * approve should be called when allowed[_spender] == 0. To increment
145    * allowed value is better to use this function to avoid 2 calls (and wait until
146    * the first transaction is mined)
147    * From MonolithDAO Token.sol
148    */
149     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
150         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
151         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
152         return true;
153     }
154 
155     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
156         uint oldValue = allowed[msg.sender][_spender];
157         if (_subtractedValue > oldValue) {
158             allowed[msg.sender][_spender] = 0;
159         } else {
160             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
161         }
162         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163         return true;
164     }
165 }
166 
167 contract ERC223Interface {
168     uint public totalSupply;
169     function balanceOf(address who) constant returns (uint);
170     function transfer(address to, uint value);
171     function transfer(address to, uint value, bytes data);
172 }
173 
174 
175 /**
176  * @title Based on the reference implementation of the ERC223 standard token.
177  */
178 contract AkiCoin is ERC223Interface, ERC20CompatibleToken {
179     using SafeMath for uint;
180 
181     string  public name    = "AkiCoin";
182     string  public symbol  = "AKI";
183     uint8   public decimals = 18;
184     uint256 public totalSupply = 2300000 * 10 ** 18;
185 
186     function AkiCoin(address companyWallet) {
187         balances[companyWallet] = balances[companyWallet].add(totalSupply);
188         Transfer(0x0, companyWallet, totalSupply);
189     }
190 
191     /**
192      * We don't accept payments to the token contract directly.
193      */
194     function() payable {
195         revert();
196     }
197 
198 
199     /**
200      * @dev Transfer the specified amount of tokens to the specified address.
201      *      Invokes the `tokenFallback` function if the recipient is a contract.
202      *      The token transfer fails if the recipient is a contract
203      *      but does not implement the `tokenFallback` function
204      *      or the fallback function to receive funds.
205      *
206      * @param _to    Receiver address.
207      * @param _value Amount of tokens that will be transferred.
208      * @param _data  Transaction metadata.
209      */
210     function transfer(address _to, uint _value, bytes _data) {
211         // Standard function transfer similar to ERC20 transfer with no _data .
212         // Added due to backwards compatibility reasons .
213         uint codeLength;
214 
215         assembly {
216             // Retrieve the size of the code on target address, this needs assembly .
217             codeLength := extcodesize(_to)
218         }
219 
220         balances[msg.sender] = balances[msg.sender].sub(_value);
221         balances[_to] = balances[_to].add(_value);
222         if(codeLength>0) {
223             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
224             receiver.tokenFallback(msg.sender, _value, _data);
225         }
226         Transfer(msg.sender, _to, _value);
227     }
228 
229     /**
230      * @dev Transfer the specified amount of tokens to the specified address.
231      *      This function works the Akie with the previous one
232      *      but doesn't contain `_data` param.
233      *      Added due to backwards compatibility reasons.
234      *
235      * @param _to    Receiver address.
236      * @param _value Amount of tokens that will be transferred.
237      */
238     function transfer(address _to, uint _value) {
239         uint codeLength;
240         bytes memory empty;
241 
242         assembly {
243             // Retrieve the size of the code on target address, this needs assembly .
244             codeLength := extcodesize(_to)
245         }
246 
247         balances[msg.sender] = balances[msg.sender].sub(_value);
248         balances[_to] = balances[_to].add(_value);
249         if(codeLength>0) {
250             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
251             receiver.tokenFallback(msg.sender, _value, empty);
252         }
253         Transfer(msg.sender, _to, _value);
254     }
255 
256 
257     /**
258      * @dev Returns balance of the `_owner`.
259      *
260      * @param _owner   The address whose balance will be returned.
261      * @return balance Balance of the `_owner`.
262      */
263     function balanceOf(address _owner) constant returns (uint balance) {
264         return balances[_owner];
265     }
266 }