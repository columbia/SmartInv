1 pragma solidity ^0.4.18;
2 
3 contract GoCryptobotCoinERC20 {
4     using SafeMath for uint256;
5 
6     string public constant name = "GoCryptobotCoin";
7     string public constant symbol = "GCC";
8     uint8 public constant decimals = 3;
9 
10     mapping(address => uint256) balances;
11     mapping (address => mapping (address => uint256)) internal allowed;
12 
13     uint256 totalSupply_;
14 
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 
18     /**
19        @dev total number of tokens in existence
20      */
21     function totalSupply() public view returns (uint256) {
22         return totalSupply_;
23     }
24 
25     /**
26        @dev Gets the balance of the specified address.
27        @param _owner The address to query the the balance of.
28        @return An uint256 representing the amount owned by the passed address.
29      */
30     function balanceOf(address _owner) public view returns (uint256 balance) {
31         return balances[_owner];
32     }
33 
34     /**
35        @dev transfer token for a specified address
36        @param _to The address to transfer to.
37        @param _value The amount to be transferred.
38      */
39     function transfer(address _to, uint256 _value) public returns (bool) {
40         require(_to != address(0));
41         require(_value <= balances[msg.sender]);
42 
43         // SafeMath.sub will throw if there is not enough balance.
44         balances[msg.sender] = balances[msg.sender].sub(_value);
45         balances[_to] = balances[_to].add(_value);
46         Transfer(msg.sender, _to, _value);
47         return true;
48     }
49 
50     /**
51        @dev Function to check the amount of tokens that an owner allowed to a spender.
52        @param _owner address The address which owns the funds.
53        @param _spender address The address which will spend the funds.
54        @return A uint256 specifying the amount of tokens still available for the spender.
55      */
56     function allowance(address _owner, address _spender) public view returns (uint256) {
57         return allowed[_owner][_spender];
58     }
59 
60     /**
61        @dev Transfer tokens from one address to another
62        @param _from address The address which you want to send tokens from
63        @param _to address The address which you want to transfer to
64        @param _value uint256 the amount of tokens to be transferred
65      */
66     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
67         require(_to != address(0));
68         require(_value <= balances[_from]);
69         require(_value <= allowed[_from][msg.sender]);
70 
71         balances[_from] = balances[_from].sub(_value);
72         balances[_to] = balances[_to].add(_value);
73         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
74         Transfer(_from, _to, _value);
75         return true;
76     }
77 
78     /**
79        @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
80       
81        Beware that changing an allowance with this method brings the risk that someone may use both the old
82        and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
83        race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
84        https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
85        @param _spender The address which will spend the funds.
86        @param _value The amount of tokens to be spent.
87      */
88     function approve(address _spender, uint256 _value) public returns (bool) {
89         allowed[msg.sender][_spender] = _value;
90         Approval(msg.sender, _spender, _value);
91         return true;
92     }
93 
94     /**
95        @dev Increase the amount of tokens that an owner allowed to a spender.
96       
97        approve should be called when allowed[_spender] == 0. To increment
98        allowed value is better to use this function to avoid 2 calls (and wait until
99        the first transaction is mined)
100        From MonolithDAO Token.sol
101        @param _spender The address which will spend the funds.
102        @param _addedValue The amount of tokens to increase the allowance by.
103      */
104     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
105         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
106         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
107         return true;
108     }
109 
110     /**
111        @dev Decrease the amount of tokens that an owner allowed to a spender.
112       
113        approve should be called when allowed[_spender] == 0. To decrement
114        allowed value is better to use this function to avoid 2 calls (and wait until
115        the first transaction is mined)
116        From MonolithDAO Token.sol
117        @param _spender The address which will spend the funds.
118        @param _subtractedValue The amount of tokens to decrease the allowance by.
119      */
120     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
121         uint oldValue = allowed[msg.sender][_spender];
122         if (_subtractedValue > oldValue) {
123             allowed[msg.sender][_spender] = 0;
124         } else {
125             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
126         }
127         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128         return true;
129     }
130 }
131 
132 contract GoCryptobotCoinERC827 is GoCryptobotCoinERC20 {
133     /**
134        @dev Addition to ERC20 token methods. It allows to
135        approve the transfer of value and execute a call with the sent data.
136 
137        Beware that changing an allowance with this method brings the risk that
138        someone may use both the old and the new allowance by unfortunate
139        transaction ordering. One possible solution to mitigate this race condition
140        is to first reduce the spender's allowance to 0 and set the desired value
141        afterwards:
142        https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143 
144        @param _spender The address that will spend the funds.
145        @param _value The amount of tokens to be spent.
146        @param _data ABI-encoded contract call to call `_to` address.
147 
148        @return true if the call function was executed successfully
149      */
150     function approve( address _spender, uint256 _value, bytes _data ) public returns (bool) {
151         require(_spender != address(this));
152         super.approve(_spender, _value);
153         require(_spender.call(_data));
154         return true;
155     }
156 
157     /**
158        @dev Addition to ERC20 token methods. Transfer tokens to a specified
159        address and execute a call with the sent data on the same transaction
160 
161        @param _to address The address which you want to transfer to
162        @param _value uint256 the amout of tokens to be transfered
163        @param _data ABI-encoded contract call to call `_to` address.
164 
165        @return true if the call function was executed successfully
166      */
167     function transfer( address _to, uint256 _value, bytes _data ) public returns (bool) {
168         require(_to != address(this));
169         super.transfer(_to, _value);
170         require(_to.call(_data));
171         return true;
172     }
173 
174     /**
175        @dev Addition to ERC20 token methods. Transfer tokens from one address to
176        another and make a contract call on the same transaction
177 
178        @param _from The address which you want to send tokens from
179        @param _to The address which you want to transfer to
180        @param _value The amout of tokens to be transferred
181        @param _data ABI-encoded contract call to call `_to` address.
182 
183        @return true if the call function was executed successfully
184      */
185     function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool) {
186         require(_to != address(this));
187         super.transferFrom(_from, _to, _value);
188         require(_to.call(_data));
189         return true;
190     }
191 
192     /**
193        @dev Addition to StandardToken methods. Increase the amount of tokens that
194        an owner allowed to a spender and execute a call with the sent data.
195 
196        approve should be called when allowed[_spender] == 0. To increment
197        allowed value is better to use this function to avoid 2 calls (and wait until
198        the first transaction is mined)
199        From MonolithDAO Token.sol
200        @param _spender The address which will spend the funds.
201        @param _addedValue The amount of tokens to increase the allowance by.
202        @param _data ABI-encoded contract call to call `_spender` address.
203      */
204     function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
205         require(_spender != address(this));
206         super.increaseApproval(_spender, _addedValue);
207         require(_spender.call(_data));
208         return true;
209     }
210 
211     /**
212        @dev Addition to StandardToken methods. Decrease the amount of tokens that
213        an owner allowed to a spender and execute a call with the sent data.
214 
215        approve should be called when allowed[_spender] == 0. To decrement
216        allowed value is better to use this function to avoid 2 calls (and wait until
217        the first transaction is mined)
218        From MonolithDAO Token.sol
219        @param _spender The address which will spend the funds.
220        @param _subtractedValue The amount of tokens to decrease the allowance by.
221        @param _data ABI-encoded contract call to call `_spender` address.
222      */
223     function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
224         require(_spender != address(this));
225         super.decreaseApproval(_spender, _subtractedValue);
226         require(_spender.call(_data));
227         return true;
228     }
229 }
230 
231 library SafeMath {
232 
233     /**
234     * @dev Multiplies two numbers, throws on overflow.
235     */
236     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
237         if (a == 0) {
238             return 0;
239         }
240         uint256 c = a * b;
241         assert(c / a == b);
242         return c;
243     }
244 
245     /**
246     * @dev Integer division of two numbers, truncating the quotient.
247     */
248     function div(uint256 a, uint256 b) internal pure returns (uint256) {
249         // assert(b > 0); // Solidity automatically throws when dividing by 0
250         uint256 c = a / b;
251         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
252         return c;
253     }
254 
255     /**
256     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
257     */
258     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
259         assert(b <= a);
260         return a - b;
261     }
262 
263     /**
264     * @dev Adds two numbers, throws on overflow.
265     */
266     function add(uint256 a, uint256 b) internal pure returns (uint256) {
267         uint256 c = a + b;
268         assert(c >= a);
269         return c;
270     }
271 }
272 
273 contract GoCryptobotCoinCore is GoCryptobotCoinERC827 {
274     function GoCryptobotCoinCore() public {
275         balances[msg.sender] = 1000000000 * (10 ** uint(decimals));
276         totalSupply_.add(balances[msg.sender]);
277     }
278 
279     function () public payable {
280         revert();
281     }
282 }