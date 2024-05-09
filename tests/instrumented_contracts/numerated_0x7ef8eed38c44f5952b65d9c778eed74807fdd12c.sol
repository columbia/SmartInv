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
110             receiver.tokenFallback(_from, _value, empty);
111         }
112         Transfer(_from, _to, _value);
113         return true;
114     }
115 
116   /**
117    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
118    *
119    * Beware that changing an allowance with this method brings the risk that someone may use both the old
120    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
121    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
122    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
123    * @param _spender The address which will spend the funds.
124    * @param _value The amount of tokens to be spent.
125    */
126     function approve(address _spender, uint256 _value) public returns (bool) {
127         allowed[msg.sender][_spender] = _value;
128         Approval(msg.sender, _spender, _value);
129         return true;
130     }
131 
132   /**
133    * @dev Function to check the amount of tokens that an owner allowed to a spender.
134    * @param _owner address The address which owns the funds.
135    * @param _spender address The address which will spend the funds.
136    * @return A uint256 specifying the amount of tokens still available for the spender.
137    */
138     function allowance(address _owner, address _spender) public view returns (uint256) {
139         return allowed[_owner][_spender];
140     }
141 
142   /**
143    * approve should be called when allowed[_spender] == 0. To increment
144    * allowed value is better to use this function to avoid 2 calls (and wait until
145    * the first transaction is mined)
146    * From MonolithDAO Token.sol
147    */
148     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
149         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
150         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
151         return true;
152     }
153 
154     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
155         uint oldValue = allowed[msg.sender][_spender];
156         if (_subtractedValue > oldValue) {
157             allowed[msg.sender][_spender] = 0;
158         } else {
159             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
160         }
161         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162         return true;
163     }
164 }
165 
166 contract ERC223Interface {
167     uint public totalSupply;
168     function balanceOf(address who) constant returns (uint);
169     function transfer(address to, uint value);
170     function transfer(address to, uint value, bytes data);
171 }
172 
173 
174 /**
175  * @title Based on the reference implementation of the ERC223 standard token.
176  */
177 contract AkiCoin is ERC223Interface, ERC20CompatibleToken {
178     using SafeMath for uint;
179 
180     string  public name    = "AkiCoin";
181     string  public symbol  = "AKI";
182     uint8   public decimals = 18;
183     uint256 public totalSupply = 2300000 * 10 ** 18;
184 
185     function AkiCoin(address companyWallet) {
186         balances[companyWallet] = balances[companyWallet].add(totalSupply);
187         Transfer(0x0, companyWallet, totalSupply);
188     }
189 
190     /**
191      * We don't accept payments to the token contract directly.
192      */
193     function() payable {
194         revert();
195     }
196 
197 
198     /**
199      * @dev Transfer the specified amount of tokens to the specified address.
200      *      Invokes the `tokenFallback` function if the recipient is a contract.
201      *      The token transfer fails if the recipient is a contract
202      *      but does not implement the `tokenFallback` function
203      *      or the fallback function to receive funds.
204      *
205      * @param _to    Receiver address.
206      * @param _value Amount of tokens that will be transferred.
207      * @param _data  Transaction metadata.
208      */
209     function transfer(address _to, uint _value, bytes _data) {
210         // Standard function transfer similar to ERC20 transfer with no _data .
211         // Added due to backwards compatibility reasons .
212         uint codeLength;
213 
214         assembly {
215             // Retrieve the size of the code on target address, this needs assembly .
216             codeLength := extcodesize(_to)
217         }
218 
219         balances[msg.sender] = balances[msg.sender].sub(_value);
220         balances[_to] = balances[_to].add(_value);
221         if(codeLength>0) {
222             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
223             receiver.tokenFallback(msg.sender, _value, _data);
224         }
225         Transfer(msg.sender, _to, _value);
226     }
227 
228     /**
229      * @dev Transfer the specified amount of tokens to the specified address.
230      *      This function works the Akie with the previous one
231      *      but doesn't contain `_data` param.
232      *      Added due to backwards compatibility reasons.
233      *
234      * @param _to    Receiver address.
235      * @param _value Amount of tokens that will be transferred.
236      */
237     function transfer(address _to, uint _value) {
238         uint codeLength;
239         bytes memory empty;
240 
241         assembly {
242             // Retrieve the size of the code on target address, this needs assembly .
243             codeLength := extcodesize(_to)
244         }
245 
246         balances[msg.sender] = balances[msg.sender].sub(_value);
247         balances[_to] = balances[_to].add(_value);
248         if(codeLength>0) {
249             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
250             receiver.tokenFallback(msg.sender, _value, empty);
251         }
252         Transfer(msg.sender, _to, _value);
253     }
254 
255 
256     /**
257      * @dev Returns balance of the `_owner`.
258      *
259      * @param _owner   The address whose balance will be returned.
260      * @return balance Balance of the `_owner`.
261      */
262     function balanceOf(address _owner) constant returns (uint balance) {
263         return balances[_owner];
264     }
265 }