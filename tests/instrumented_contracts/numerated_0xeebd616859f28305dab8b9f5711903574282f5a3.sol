1 pragma solidity ^0.4.23;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Standard ERC20 token
51  *
52  * @dev Implementation of the basic standard token.
53  * @dev https://github.com/ethereum/EIPs/issues/20
54  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
55  */
56 contract ERC20StandardToken {
57   event Transfer(address indexed from, address indexed to, uint256 value);
58   event Approval(address indexed _owner, address indexed _spender, uint _value);
59 
60   mapping (address => mapping (address => uint256)) internal allowed;
61   mapping (address => uint256) public balanceOf;
62   
63   using SafeMath for uint256;
64   uint256 totalSupply_;
65 
66   /**
67    * @dev Transfer tokens from one address to another
68    * @param _from address The address which you want to send tokens from
69    * @param _to address The address which you want to transfer to
70    * @param _value uint256 the amount of tokens to be transferred
71    */
72    
73   function transferFrom(address _from,address _to,uint256 _value) public returns (bool)
74   {
75     require(_to != address(0));
76     require(_value <= balanceOf[_from]);
77     require(_value <= allowed[_from][msg.sender]);
78 
79     balanceOf[_from] = balanceOf[_from].sub(_value);
80     balanceOf[_to] = balanceOf[_to].add(_value);
81     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
82     emit Transfer(_from, _to, _value);
83     return true;
84   }
85 
86   /**
87   * @dev total number of tokens in existence
88   */
89   function totalSupply() public view returns (uint256) {
90     return totalSupply_;
91   }
92 
93   /**
94   * @dev transfer token for a specified address
95   * @param _to The address to transfer to.
96   * @param _value The amount to be transferred.
97   */
98   function transfer(address _to, uint256 _value) public returns (bool) {
99     require(_to != address(0));
100     require(_value <= balanceOf[msg.sender]);
101 
102     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
103     balanceOf[_to] = balanceOf[_to].add(_value);
104     emit Transfer(msg.sender, _to, _value);
105     return true;
106   }
107 
108 
109   /**
110    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
111    *
112    * Beware that changing an allowance with this method brings the risk that someone may use both the old
113    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
114    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
115    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
116    * @param _spender The address which will spend the funds.
117    * @param _value The amount of tokens to be spent.
118    */
119   
120   function approve(address _spender, uint256 _value) public returns (bool) {
121     allowed[msg.sender][_spender] = _value;
122     emit Approval(msg.sender, _spender, _value);
123     return true;
124   }
125 
126   /**
127    * @dev Function to check the amount of tokens that an owner allowed to a spender.
128    * @param _owner address The address which owns the funds.
129    * @param _spender address The address which will spend the funds.
130    * @return A uint256 specifying the amount of tokens still available for the spender.
131    */
132 
133   function allowance(
134     address _owner,
135     address _spender
136    )
137     public
138     view
139     returns (uint256)
140   {
141     return allowed[_owner][_spender];
142   }
143 
144   /**
145    * @dev Increase the amount of tokens that an owner allowed to a spender.
146    *
147    * approve should be called when allowed[_spender] == 0. To increment
148    * allowed value is better to use this function to avoid 2 calls (and wait until
149    * the first transaction is mined)
150    * From MonolithDAO Token.sol
151    * @param _spender The address which will spend the funds.
152    * @param _addedValue The amount of tokens to increase the allowance by.
153    */
154  
155   function increaseApproval(
156     address _spender,
157     uint _addedValue
158   )
159     public
160     returns (bool)
161   {
162     allowed[msg.sender][_spender] = (
163       allowed[msg.sender][_spender].add(_addedValue));
164     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165     return true;
166   }
167 
168   /**
169    * @dev Decrease the amount of tokens that an owner allowed to a spender.
170    *
171    * approve should be called when allowed[_spender] == 0. To decrement
172    * allowed value is better to use this function to avoid 2 calls (and wait until
173    * the first transaction is mined)
174    * From MonolithDAO Token.sol
175    * @param _spender The address which will spend the funds.
176    * @param _subtractedValue The amount of tokens to decrease the allowance by.
177    */
178    
179   function decreaseApproval(
180     address _spender,
181     uint _subtractedValue
182   )
183     public
184     returns (bool)
185   {
186     uint oldValue = allowed[msg.sender][_spender];
187     if (_subtractedValue > oldValue) {
188       allowed[msg.sender][_spender] = 0;
189     } else {
190       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
191     }
192     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193     return true;
194   }
195 
196 }
197 
198 
199 
200  /**
201  * @title Contract that will work with ERC223 tokens.
202  */
203 
204 contract addtionalERC223Interface {
205     function transfer(address to, uint256 value, bytes data) public returns (bool);
206     event Transfer(address indexed from, address indexed to, uint value, bytes data);
207 }
208 
209 contract ERC223ReceivingContract { 
210     /**
211     * @dev Standard ERC223 function that will handle incoming token transfers.
212     *
213     * @param _from  Token sender address.
214     * @param _value Amount of tokens.
215     * @param _data  Transaction metadata.
216     */
217     
218     struct TKN {
219         address sender;
220         uint value;
221         bytes data;
222         bytes4 sig;
223     }
224     
225     function tokenFallback(address _from, uint256 _value, bytes _data) public pure
226     {
227         TKN memory tkn;
228         tkn.sender = _from;
229         tkn.value = _value;
230         tkn.data = _data;
231         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
232         tkn.sig = bytes4(u);        
233     }
234 }
235 
236 
237 /**
238  * @title Reference implementation of the ERC223 standard token.
239  */
240 contract ERC223Token is addtionalERC223Interface , ERC20StandardToken {
241  
242     function _transfer(address _to, uint256 _value ) private returns (bool) {
243         require(balanceOf[msg.sender] >= _value);
244         
245         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
246         balanceOf[_to] = balanceOf[_to].add(_value);
247         
248         return true;
249     }
250 
251     function _transferFallback(address _to, uint256 _value, bytes _data) private returns (bool) {
252         require(balanceOf[msg.sender] >= _value);
253 
254         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
255         balanceOf[_to] = balanceOf[_to].add(_value);
256 
257         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
258         receiver.tokenFallback(msg.sender, _value, _data);
259         
260         emit Transfer(msg.sender, _to, _value, _data);
261         
262         return true;
263     }
264 
265     /**
266      * @dev Transfer the specified amount of tokens to the specified address.
267      *      Invokes the `tokenFallback` function if the recipient is a contract.
268      *      The token transfer fails if the recipient is a contract
269      *      but does not implement the `tokenFallback` function
270      *      or the fallback function to receive funds.
271      *
272      * @param _to    Receiver address.
273      * @param _value Amount of tokens that will be transferred.
274      * @param _data  Transaction metadata.
275      */
276     function transfer(address _to, uint256 _value, bytes _data) public returns (bool OK) {
277         // Standard function transfer similar to ERC20 transfer with no _data .
278         // Added due to backwards compatibility reasons .
279         if(isContract(_to))
280         {
281             return _transferFallback(_to,_value,_data);
282         }else{
283             _transfer(_to,_value);
284             emit Transfer(msg.sender, _to, _value, _data);
285         }
286         
287         return true;
288     }
289     
290     /**
291      * @dev Transfer the specified amount of tokens to the specified address.
292      *      This function works the same with the previous one
293      *      but doesn't contain `_data` param.
294      *      Added due to backwards compatibility reasons.
295      *
296      * @param _to    Receiver address.
297      * @param _value Amount of tokens that will be transferred.
298      */
299     function transfer(address _to, uint256 _value) public returns (bool) {
300         bytes memory empty;
301 
302         if(isContract(_to))
303         {
304             return _transferFallback(_to,_value,empty);
305         }else{
306             _transfer(_to,_value);
307             emit Transfer(msg.sender, _to, _value);
308         }
309         
310     }
311     
312     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
313     function isContract(address _addr) private view returns (bool) {
314         uint length;
315         assembly {
316             //retrieve the size of the code on target address, this needs assembly
317             length := extcodesize(_addr)
318         }
319         return (length > 0);
320     }    
321 }
322 
323 
324 contract TowaCoin is ERC223Token
325 {
326     string public name = "TOWACOIN";
327     string public symbol = "TOWA";
328     uint8 public decimals = 18;
329     
330     constructor() public{
331 	    address founder = 0x9F7d681707AA64fFdfBA162084932058bD34aBF4;
332 	    address developer = 0xE66EBB7Bd6E44413Ac1dE57ECe202c8F0CA1Efd9;
333     
334         uint256  dec = decimals;
335         totalSupply_ = 200 * 1e8 * (10**dec);
336         balanceOf[founder] = totalSupply_.mul(97).div(100);
337         balanceOf[developer] = totalSupply_.mul(3).div(100);
338     }
339     
340 }