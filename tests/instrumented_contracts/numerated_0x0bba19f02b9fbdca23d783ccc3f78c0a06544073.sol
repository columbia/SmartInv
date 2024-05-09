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
79 contract MyanmarGoldCoin is ERC20 {
80     using SafeMath for uint256;
81 
82     mapping(address => uint256) balances;
83     mapping (address => mapping (address => uint256)) internal allowed;
84 
85     uint256 totalSupply_;
86     string public constant name = "MyanmarGoldCoin"; // solium-disable-line uppercase
87     string public constant symbol = "MGC"; // solium-disable-line uppercase
88     uint8 public constant decimals = 18; // solium-disable-line uppercase
89 
90     event Burn(address indexed burner, uint256 value);
91 
92     constructor(address _icoAddress) public {
93         totalSupply_ = 1000000000 * (10 ** uint256(decimals));
94         balances[_icoAddress] = totalSupply_;
95         emit Transfer(address(0), _icoAddress, totalSupply_);
96     }
97 
98     /**
99     * @dev total number of tokens in existence
100     */
101     function totalSupply() public view returns (uint256) {
102         return totalSupply_;
103     }
104 
105     /**
106     * @dev transfer token for a specified address
107     * @param _to The address to transfer to.
108     * @param _value The amount to be transferred.
109     */
110     function transfer(address _to, uint256 _value) public returns (bool) {
111         require(_to != address(0));
112         require(_value <= balances[msg.sender]);
113 
114         balances[msg.sender] = balances[msg.sender].sub(_value);
115         balances[_to] = balances[_to].add(_value);
116         emit Transfer(msg.sender, _to, _value);
117         return true;
118     }
119 
120     /**
121     * @dev batchTransfer token for a specified addresses
122     * @param _tos The addresses to transfer to.
123     * @param _values The amounts to be transferred.
124     */
125     function batchTransfer(address[] _tos, uint256[] _values) public returns (bool) {
126         require(_tos.length == _values.length);
127         uint256 arrayLength = _tos.length;
128         for(uint256 i = 0; i < arrayLength; i++) {
129             transfer(_tos[i], _values[i]);
130         }
131         return true;
132     }
133 
134     /**
135     * @dev Gets the balance of the specified address.
136     * @param _owner The address to query the the balance of.
137     * @return An uint256 representing the amount owned by the passed address.
138     */
139     function balanceOf(address _owner) public view returns (uint256) {
140         return balances[_owner];
141     }
142 
143     /**
144     * @dev Transfer tokens from one address to another
145     * @param _from address The address which you want to send tokens from
146     * @param _to address The address which you want to transfer to
147     * @param _value uint256 the amount of tokens to be transferred
148     */
149     function transferFrom(
150         address _from,
151         address _to,
152         uint256 _value
153     )
154         public
155         returns (bool)
156     {
157         require(_to != address(0));
158         require(_value <= balances[_from]);
159         require(_value <= allowed[_from][msg.sender]);
160         
161         balances[_from] = balances[_from].sub(_value);
162         balances[_to] = balances[_to].add(_value);
163         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
164         emit Transfer(_from, _to, _value);
165         return true;
166     }
167 
168     /**
169     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
170     *
171     * Beware that changing an allowance with this method brings the risk that someone may use both the old
172     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
173     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
174     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175     * @param _spender The address which will spend the funds.
176     * @param _value The amount of tokens to be spent.
177     */
178     function approve(address _spender, uint256 _value) public returns (bool) {
179         allowed[msg.sender][_spender] = _value;
180         emit Approval(msg.sender, _spender, _value);
181         return true;
182     }
183 
184     /**
185     * @dev Function to check the amount of tokens that an owner allowed to a spender.
186     * @param _owner address The address which owns the funds.
187     * @param _spender address The address which will spend the funds.
188     * @return A uint256 specifying the amount of tokens still available for the spender.
189     */
190     function allowance(
191         address _owner,
192         address _spender
193     )
194         public
195         view
196         returns (uint256)
197     {
198         return allowed[_owner][_spender];
199     }
200 
201     /**
202     * @dev Increase the amount of tokens that an owner allowed to a spender.
203     *
204     * approve should be called when allowed[_spender] == 0. To increment
205     * allowed value is better to use this function to avoid 2 calls (and wait until
206     * the first transaction is mined)
207     * From MonolithDAO Token.sol
208     * @param _spender The address which will spend the funds.
209     * @param _addedValue The amount of tokens to increase the allowance by.
210     */
211     function increaseApproval(
212         address _spender,
213         uint _addedValue
214     )
215         public
216         returns (bool)
217     {
218         allowed[msg.sender][_spender] = (
219         allowed[msg.sender][_spender].add(_addedValue));
220         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221         return true;
222     }
223 
224     /**
225     * @dev Decrease the amount of tokens that an owner allowed to a spender.
226     *
227     * approve should be called when allowed[_spender] == 0. To decrement
228     * allowed value is better to use this function to avoid 2 calls (and wait until
229     * the first transaction is mined)
230     * From MonolithDAO Token.sol
231     * @param _spender The address which will spend the funds.
232     * @param _subtractedValue The amount of tokens to decrease the allowance by.
233     */
234     function decreaseApproval(
235         address _spender,
236         uint _subtractedValue
237     )
238         public
239         returns (bool)
240     {
241         uint oldValue = allowed[msg.sender][_spender];
242         if (_subtractedValue > oldValue) {
243             allowed[msg.sender][_spender] = 0;
244         } else {
245             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
246         }
247         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248         return true;
249     }
250 
251     /**
252     * @dev Burns a specific amount of tokens.
253     * @param _value The amount of token to be burned.
254     */
255     function burn(uint256 _value) public {
256         _burn(msg.sender, _value);
257     }
258 
259     function _burn(address _who, uint256 _value) internal {
260         require(_value <= balances[_who]);
261         // no need to require value <= totalSupply, since that would imply the
262         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
263 
264         balances[_who] = balances[_who].sub(_value);
265         totalSupply_ = totalSupply_.sub(_value);
266         emit Burn(_who, _value);
267         emit Transfer(_who, address(0), _value);
268     }
269 }