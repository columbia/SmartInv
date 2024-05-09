1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8     function totalSupply() public view returns (uint256);
9     function balanceOf(address who) public view returns (uint256);
10     function transfer(address to, uint256 value) public returns (bool);
11     event Transfer(address indexed from, address indexed to, uint256 value);    
12 
13     function allowance(address owner, address spender)
14         public view returns (uint256);
15 
16     function transferFrom(address from, address to, uint256 value)
17         public returns (bool);
18 
19     function approve(address spender, uint256 value) public returns (bool);
20     event Approval(
21         address indexed owner,
22         address indexed spender,
23         uint256 value
24     );
25 }
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32     /**
33     * @dev Multiplies two numbers, throws on overflow.
34     */
35     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
36         if (a == 0) {
37             return 0;
38         }
39         c = a * b;
40         assert(c / a == b);
41         return c;
42     }
43 
44     /**
45     * @dev Integer division of two numbers, truncating the quotient.
46     */
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         // assert(b > 0); // Solidity automatically throws when dividing by 0
49         // uint256 c = a / b;
50         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51         return a / b;
52     }
53 
54     /**
55     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
56     */
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         assert(b <= a);
59         return a - b;
60     }
61 
62     /**
63     * @dev Adds two numbers, throws on overflow.
64     */
65     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
66         c = a + b;
67         assert(c >= a);
68         return c;
69     }
70 }
71 
72 /**
73  * @title Standard ERC20 token
74  *
75  * @dev Implementation of the basic standard token.
76  * @dev https://github.com/ethereum/EIPs/issues/20
77  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
78  */
79 contract DatEatToken is ERC20 {
80     using SafeMath for uint256;
81 
82     mapping(address => uint256) balances;
83     mapping (address => mapping (address => uint256)) internal allowed;
84     mapping (address => uint256) public freezedAccounts;
85 
86     uint256 totalSupply_;
87     string public constant name = "DatEatToken"; // solium-disable-line uppercase
88     string public constant symbol = "DTE"; // solium-disable-line uppercase
89     uint8 public constant decimals = 18; // solium-disable-line uppercase
90 
91     uint256 constant icoSupply = 200000000 * (10 ** uint256(decimals));
92     uint256 constant founderSupply = 60000000 * (10 ** uint256(decimals));
93     uint256 constant defoundSupply = 50000000 * (10 ** uint256(decimals));
94     uint256 constant year1Supply = 75000000 * (10 ** uint256(decimals));
95     uint256 constant year2Supply = 75000000 * (10 ** uint256(decimals));
96     uint256 constant bountyAndBonusSupply = 40000000 * (10 ** uint256(decimals));
97 
98     uint256 constant founderFrozenUntil = 1559347200; // 2019/06/01
99     uint256 constant defoundFrozenUntil = 1546300800; // 2019/01/01
100     uint256 constant year1FrozenUntil = 1559347200; // 2019/06/01
101     uint256 constant year2FrozenUntil = 1590969600; // 2020/06/01
102 
103     event Burn(address indexed burner, uint256 value);
104 
105     constructor(
106         address _icoAddress, 
107         address _founderAddress,
108         address _defoundAddress, 
109         address _year1Address, 
110         address _year2Address, 
111         address _bountyAndBonusAddress
112     ) public {
113         totalSupply_ = 500000000 * (10 ** uint256(decimals));
114         balances[_icoAddress] = icoSupply;
115         balances[_bountyAndBonusAddress] = bountyAndBonusSupply;
116         emit Transfer(address(0), _icoAddress, icoSupply);
117         emit Transfer(address(0), _bountyAndBonusAddress, bountyAndBonusSupply);
118 
119         _setFreezedBalance(_founderAddress, founderSupply, founderFrozenUntil);
120         _setFreezedBalance(_defoundAddress, defoundSupply, defoundFrozenUntil);
121         _setFreezedBalance(_year1Address, year1Supply, year1FrozenUntil);
122         _setFreezedBalance(_year2Address, year2Supply, year2FrozenUntil);
123     }
124 
125     /**
126     * @dev total number of tokens in existence
127     */
128     function totalSupply() public view returns (uint256) {
129         return totalSupply_;
130     }
131 
132     /**
133     * @dev transfer token for a specified address
134     * @param _to The address to transfer to.
135     * @param _value The amount to be transferred.
136     */
137     function transfer(address _to, uint256 _value) public returns (bool) {
138         require(_to != address(0));
139         require(_value <= balances[msg.sender]);
140         // solium-disable-next-line security/no-block-members
141         require(freezedAccounts[msg.sender] == 0 || freezedAccounts[msg.sender] < block.timestamp);
142         // solium-disable-next-line security/no-block-members
143         require(freezedAccounts[_to] == 0 || freezedAccounts[_to] < block.timestamp);
144 
145         balances[msg.sender] = balances[msg.sender].sub(_value);
146         balances[_to] = balances[_to].add(_value);
147         emit Transfer(msg.sender, _to, _value);
148         return true;
149     }
150 
151     /**
152     * @dev batchTransfer token for a specified addresses
153     * @param _tos The addresses to transfer to.
154     * @param _values The amounts to be transferred.
155     */
156     function batchTransfer(address[] _tos, uint256[] _values) public returns (bool) {
157         require(_tos.length == _values.length);
158         uint256 arrayLength = _tos.length;
159         for(uint256 i = 0; i < arrayLength; i++) {
160             transfer(_tos[i], _values[i]);
161         }
162         return true;
163     }
164 
165     /**
166     * @dev Gets the balance of the specified address.
167     * @param _owner The address to query the the balance of.
168     * @return An uint256 representing the amount owned by the passed address.
169     */
170     function balanceOf(address _owner) public view returns (uint256) {
171         return balances[_owner];
172     }
173 
174     /**
175     * @dev Transfer tokens from one address to another
176     * @param _from address The address which you want to send tokens from
177     * @param _to address The address which you want to transfer to
178     * @param _value uint256 the amount of tokens to be transferred
179     */
180     function transferFrom(
181         address _from,
182         address _to,
183         uint256 _value
184     )
185         public
186         returns (bool)
187     {
188         require(_to != address(0));
189         require(_value <= balances[_from]);
190         require(_value <= allowed[_from][msg.sender]);
191         // solium-disable-next-line security/no-block-members
192         require(freezedAccounts[_from] == 0 || freezedAccounts[_from] < block.timestamp);
193         // solium-disable-next-line security/no-block-members
194         require(freezedAccounts[_to] == 0 || freezedAccounts[_to] < block.timestamp);
195 
196         balances[_from] = balances[_from].sub(_value);
197         balances[_to] = balances[_to].add(_value);
198         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
199         emit Transfer(_from, _to, _value);
200         return true;
201     }
202 
203     /**
204     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
205     *
206     * Beware that changing an allowance with this method brings the risk that someone may use both the old
207     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
208     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
209     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210     * @param _spender The address which will spend the funds.
211     * @param _value The amount of tokens to be spent.
212     */
213     function approve(address _spender, uint256 _value) public returns (bool) {
214         allowed[msg.sender][_spender] = _value;
215         emit Approval(msg.sender, _spender, _value);
216         return true;
217     }
218 
219     /**
220     * @dev Function to check the amount of tokens that an owner allowed to a spender.
221     * @param _owner address The address which owns the funds.
222     * @param _spender address The address which will spend the funds.
223     * @return A uint256 specifying the amount of tokens still available for the spender.
224     */
225     function allowance(
226         address _owner,
227         address _spender
228     )
229         public
230         view
231         returns (uint256)
232     {
233         return allowed[_owner][_spender];
234     }
235 
236     /**
237     * @dev Increase the amount of tokens that an owner allowed to a spender.
238     *
239     * approve should be called when allowed[_spender] == 0. To increment
240     * allowed value is better to use this function to avoid 2 calls (and wait until
241     * the first transaction is mined)
242     * From MonolithDAO Token.sol
243     * @param _spender The address which will spend the funds.
244     * @param _addedValue The amount of tokens to increase the allowance by.
245     */
246     function increaseApproval(
247         address _spender,
248         uint _addedValue
249     )
250         public
251         returns (bool)
252     {
253         allowed[msg.sender][_spender] = (
254         allowed[msg.sender][_spender].add(_addedValue));
255         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256         return true;
257     }
258 
259     /**
260     * @dev Decrease the amount of tokens that an owner allowed to a spender.
261     *
262     * approve should be called when allowed[_spender] == 0. To decrement
263     * allowed value is better to use this function to avoid 2 calls (and wait until
264     * the first transaction is mined)
265     * From MonolithDAO Token.sol
266     * @param _spender The address which will spend the funds.
267     * @param _subtractedValue The amount of tokens to decrease the allowance by.
268     */
269     function decreaseApproval(
270         address _spender,
271         uint _subtractedValue
272     )
273         public
274         returns (bool)
275     {
276         uint oldValue = allowed[msg.sender][_spender];
277         if (_subtractedValue > oldValue) {
278             allowed[msg.sender][_spender] = 0;
279         } else {
280             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
281         }
282         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
283         return true;
284     }
285 
286     /**
287      * Set balance and freeze time for address
288      */
289     function _setFreezedBalance(address _owner, uint256 _amount, uint _lockedUntil) internal {
290         require(_owner != address(0));
291         require(balances[_owner] == 0);
292         freezedAccounts[_owner] = _lockedUntil;
293         balances[_owner] = _amount;     
294     }
295 
296     /**
297     * @dev Burns a specific amount of tokens.
298     * @param _value The amount of token to be burned.
299     */
300     function burn(uint256 _value) public {
301         _burn(msg.sender, _value);
302     }
303 
304     function _burn(address _who, uint256 _value) internal {
305         require(_value <= balances[_who]);
306         // no need to require value <= totalSupply, since that would imply the
307         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
308 
309         balances[_who] = balances[_who].sub(_value);
310         totalSupply_ = totalSupply_.sub(_value);
311         emit Burn(_who, _value);
312         emit Transfer(_who, address(0), _value);
313     }
314 
315     // do not send eth to this contract
316     function () external payable {
317         revert();
318     }
319 }