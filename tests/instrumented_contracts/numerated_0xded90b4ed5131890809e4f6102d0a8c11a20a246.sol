1 pragma solidity ^0.4.11;
2 
3 /**
4  * Thank you for checking out WubCoin
5  *
6  * WubCoin powers a new generation of electronic music producers, teachers and events.
7  * For more information visit http://wubcoin.com
8  *
9  * Copyright by Stefan K.K https://stefan.co.jp
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
95         require(_to != address(0));
96         require(_value <= balances[_from]);
97         require(_value <= allowed[_from][msg.sender]);
98 
99         balances[_from] = balances[_from].sub(_value);
100         balances[_to] = balances[_to].add(_value);
101         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
102         Transfer(_from, _to, _value);
103         return true;
104     }
105 
106   /**
107    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
108    *
109    * Beware that changing an allowance with this method brings the risk that someone may use both the old
110    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
111    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
112    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
113    * @param _spender The address which will spend the funds.
114    * @param _value The amount of tokens to be spent.
115    */
116     function approve(address _spender, uint256 _value) public returns (bool) {
117         allowed[msg.sender][_spender] = _value;
118         Approval(msg.sender, _spender, _value);
119         return true;
120     }
121 
122   /**
123    * @dev Function to check the amount of tokens that an owner allowed to a spender.
124    * @param _owner address The address which owns the funds.
125    * @param _spender address The address which will spend the funds.
126    * @return A uint256 specifying the amount of tokens still available for the spender.
127    */
128     function allowance(address _owner, address _spender) public view returns (uint256) {
129         return allowed[_owner][_spender];
130     }
131 
132   /**
133    * approve should be called when allowed[_spender] == 0. To increment
134    * allowed value is better to use this function to avoid 2 calls (and wait until
135    * the first transaction is mined)
136    * From MonolithDAO Token.sol
137    */
138     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
139         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
140         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
141         return true;
142     }
143 
144     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
145         uint oldValue = allowed[msg.sender][_spender];
146         if (_subtractedValue > oldValue) {
147             allowed[msg.sender][_spender] = 0;
148         } else {
149             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
150         }
151         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
152         return true;
153     }
154 }
155 
156 contract ERC223Interface {
157     uint public totalSupply;
158     function balanceOf(address who) constant returns (uint);
159     function transfer(address to, uint value);
160     function transfer(address to, uint value, bytes data);
161 }
162 
163 
164 /**
165  * @title Based on the reference implementation of the ERC223 standard token.
166  */
167 contract WubCoin is ERC223Interface, ERC20CompatibleToken {
168     using SafeMath for uint;
169 
170     string  public name    = "WubCoin";
171     string  public symbol  = "WUB";
172     uint8   public decimals = 18;
173     uint256 public totalSupply = 15000000 * 10 ** 18;
174 
175     function WubCoin(address companyWallet) {
176         balances[companyWallet] = balances[companyWallet].add(totalSupply);
177         Transfer(0x0, companyWallet, totalSupply);
178     }
179 
180     /**
181      * We don't accept payments to the token contract directly.
182      */
183     function() payable {
184         revert();
185     }
186 
187 
188     /**
189      * @dev Transfer the specified amount of tokens to the specified address.
190      *      Invokes the `tokenFallback` function if the recipient is a contract.
191      *      The token transfer fails if the recipient is a contract
192      *      but does not implement the `tokenFallback` function
193      *      or the fallback function to receive funds.
194      *
195      * @param _to    Receiver address.
196      * @param _value Amount of tokens that will be transferred.
197      * @param _data  Transaction metadata.
198      */
199     function transfer(address _to, uint _value, bytes _data) {
200         // Standard function transfer similar to ERC20 transfer with no _data .
201         // Added due to backwards compatibility reasons .
202         uint codeLength;
203 
204         assembly {
205             // Retrieve the size of the code on target address, this needs assembly .
206             codeLength := extcodesize(_to)
207         }
208 
209         balances[msg.sender] = balances[msg.sender].sub(_value);
210         balances[_to] = balances[_to].add(_value);
211         if(codeLength>0) {
212             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
213             receiver.tokenFallback(msg.sender, _value, _data);
214         }
215         Transfer(msg.sender, _to, _value);
216     }
217 
218     /**
219      * @dev Transfer the specified amount of tokens to the specified address.
220      *      This function works the same with the previous one
221      *      but doesn't contain `_data` param.
222      *      Added due to backwards compatibility reasons.
223      *
224      * @param _to    Receiver address.
225      * @param _value Amount of tokens that will be transferred.
226      */
227     function transfer(address _to, uint _value) {
228         uint codeLength;
229         bytes memory empty;
230 
231         assembly {
232             // Retrieve the size of the code on target address, this needs assembly .
233             codeLength := extcodesize(_to)
234         }
235 
236         balances[msg.sender] = balances[msg.sender].sub(_value);
237         balances[_to] = balances[_to].add(_value);
238         if(codeLength>0) {
239             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
240             receiver.tokenFallback(msg.sender, _value, empty);
241         }
242         Transfer(msg.sender, _to, _value);
243     }
244 
245 
246     /**
247      * @dev Returns balance of the `_owner`.
248      *
249      * @param _owner   The address whose balance will be returned.
250      * @return balance Balance of the `_owner`.
251      */
252     function balanceOf(address _owner) constant returns (uint balance) {
253         return balances[_owner];
254     }
255 }