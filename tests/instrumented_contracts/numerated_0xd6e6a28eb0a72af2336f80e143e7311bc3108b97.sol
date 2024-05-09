1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers, truncating the quotient.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         // uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return a / b;
34     }
35 
36     /**
37     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38     */
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     /**
45     * @dev Adds two numbers, throws on overflow.
46     */
47     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48         c = a + b;
49         assert(c >= a);
50         return c;
51     }
52 }
53 
54 /**
55  * @title ERC20Basic
56  * @dev Simpler version of ERC20 interface
57  * See https://github.com/ethereum/EIPs/issues/179
58  */
59 contract ERC20Basic {
60     function totalSupply() public view returns (uint256);
61     function balanceOf(address who) public view returns (uint256);
62     function transfer(address to, uint256 value) public returns (bool);
63     event Transfer(
64         address indexed _from, 
65         address indexed _to, 
66         uint256 _value
67     );
68 } 
69 
70 /**
71  * @title Basic token
72  * @dev Basic version of StandardToken, with no allowances.
73  */
74 contract BasicToken is ERC20Basic {
75     using SafeMath for uint256;
76 
77     mapping(address => uint256) balances;
78 
79     uint256 totalSupply_;
80 
81     /**
82     * @dev Total number of tokens in existence
83     */
84     function totalSupply() public view returns (uint256) {
85         return totalSupply_;
86     }
87 
88     /**
89     * @dev Transfer token for a specified address
90     * @param _to The address to transfer to.
91     * @param _value The amount to be transferred.
92     */
93     function transfer(address _to, uint256 _value) public returns (bool) {
94         require(_to != address(0));
95         require(_value <= balances[msg.sender]);
96 
97         balances[msg.sender] = balances[msg.sender].sub(_value);
98         balances[_to] = balances[_to].add(_value);
99         emit Transfer(msg.sender, _to, _value);
100         return true;
101     }
102 
103     /**
104     * @dev Gets the balance of the specified address.
105     * @param _owner The address to query the the balance of.
106     * @return An uint256 representing the amount owned by the passed address.
107     */
108     function balanceOf(address _owner) public view returns (uint256) {
109         return balances[_owner];
110     }
111 
112 }
113 
114 
115 /**
116  * @title ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/20
118  */
119 contract ERC20 is ERC20Basic {
120     function allowance(address owner, address spender)
121         public view returns (uint256);
122 
123     function transferFrom(address from, address to, uint256 value)
124         public returns (bool);
125 
126     function approve(address spender, uint256 value) public returns (bool);
127     event Approval(
128       address indexed _owner,
129       address indexed _spender,
130       uint256 _value
131     );
132 }
133 
134 
135 /**
136  * @title Standard ERC20 token
137  *
138  * @dev Implementation of the basic standard token.
139  * https://github.com/ethereum/EIPs/issues/20
140  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
141  */
142 contract StandardToken is ERC20, BasicToken {
143 
144     mapping (address => mapping (address => uint256)) internal allowed;
145 
146 
147     /**
148     * @dev Transfer tokens from one address to another
149     * @param _from address The address which you want to send tokens from
150     * @param _to address The address which you want to transfer to
151     * @param _value uint256 the amount of tokens to be transferred
152     */
153     function transferFrom(
154         address _from,
155         address _to,
156         uint256 _value
157     )
158         public
159         returns (bool)
160     {
161         require(_to != address(0));
162         require(_value <= balances[_from]);
163         require(_value <= allowed[_from][msg.sender]);
164 
165         balances[_from] = balances[_from].sub(_value);
166         balances[_to] = balances[_to].add(_value);
167         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
168         emit Transfer(_from, _to, _value);
169         return true;
170     }
171 
172     /**
173     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
174     * Beware that changing an allowance with this method brings the risk that someone may use both the old
175     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
176     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
177     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178     * @param _spender The address which will spend the funds.
179     * @param _value The amount of tokens to be spent.
180     */
181     function approve(address _spender, uint256 _value) public returns (bool) {
182         allowed[msg.sender][_spender] = _value;
183         emit Approval(msg.sender, _spender, _value);
184         return true;
185     }
186 
187     /**
188     * @dev Function to check the amount of tokens that an owner allowed to a spender.
189     * @param _owner address The address which owns the funds.
190     * @param _spender address The address which will spend the funds.
191     * @return A uint256 specifying the amount of tokens still available for the spender.
192     */
193     function allowance(
194         address _owner,
195         address _spender
196     )
197         public
198         view
199         returns (uint256)
200     {
201         return allowed[_owner][_spender]; 
202     }
203 
204     /**
205     * @dev Increase the amount of tokens that an owner allowed to a spender.
206     * approve should be called when allowed[_spender] == 0. To increment
207     * allowed value is better to use this function to avoid 2 calls (and wait until
208     * the first transaction is mined)
209     * From MonolithDAO Token.sol
210     * @param _spender The address which will spend the funds.
211     * @param _addedValue The amount of tokens to increase the allowance by.
212     */
213     function increaseApproval(
214         address _spender,
215         uint256 _addedValue
216     )
217         public
218         returns (bool)
219     {
220         allowed[msg.sender][_spender] = (
221             allowed[msg.sender][_spender].add(_addedValue));
222         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223         return true;
224     }
225 
226     /**
227     * @dev Decrease the amount of tokens that an owner allowed to a spender.
228     * approve should be called when allowed[_spender] == 0. To decrement
229     * allowed value is better to use this function to avoid 2 calls (and wait until
230     * the first transaction is mined)
231     * From MonolithDAO Token.sol
232     * @param _spender The address which will spend the funds.
233     * @param _subtractedValue The amount of tokens to decrease the allowance by.
234     */
235     function decreaseApproval(
236         address _spender,
237         uint256 _subtractedValue
238     )
239         public
240         returns (bool)
241     {
242         uint256 oldValue = allowed[msg.sender][_spender];
243         if (_subtractedValue > oldValue) {
244             allowed[msg.sender][_spender] = 0;
245         } else {
246             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
247         }
248         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249         return true;
250     }
251 
252 } 
253 
254 contract KHToken_StandardToken is StandardToken { 
255     
256     // region{fields}
257     string public name;                         
258     string public symbol;            
259     uint8 public decimals;      
260     uint256 public claimAmount;    
261 
262     // region{Constructor}
263     // note : [(final)totalSupply] >> claimAmount * 10 ** decimals
264     // example : args << "The Kh Token No.X", "KHTX", "10000000000", "18"
265     constructor(
266         string _token_name, 
267         string _symbol, 
268         uint256 _claim_amount, 
269         uint8 _decimals
270     ) public {
271         name = _token_name;                              
272         symbol = _symbol;     
273         claimAmount = _claim_amount;                                     
274         decimals = _decimals;
275         totalSupply_ = claimAmount.mul(10 ** uint256(decimals)); 
276         balances[msg.sender] = totalSupply_;   
277         emit Transfer(0x0, msg.sender, totalSupply_); 
278     }
279 }
280 
281 contract KHToken_StandardToken_U is StandardToken { 
282     
283     // region{fields}
284     string public name;                         
285     string public symbol;            
286     uint8 public decimals;      
287     uint256 public claimAmount;    
288 
289     // region{Constructor}
290     // note : [(final)totalSupply] >> claimAmount * 10 ** decimals
291     // example : args << "The Kh Token No.X", "KHTX", "10000000000", "18"
292     constructor(
293         string _token_name, 
294         string _symbol, 
295         uint256 _claim_amount, 
296         uint8 _decimals,
297         address _initial_account
298     ) public {
299         name = _token_name;                              
300         symbol = _symbol;     
301         claimAmount = _claim_amount;                                     
302         decimals = _decimals;
303         totalSupply_ = claimAmount.mul(10 ** uint256(decimals)); 
304         balances[_initial_account] = totalSupply_;   
305         emit Transfer(0x0, _initial_account, totalSupply_); 
306     }
307 }