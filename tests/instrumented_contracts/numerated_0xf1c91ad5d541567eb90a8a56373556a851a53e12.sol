1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * Based on code by Frederico BC: https://www.facebook.com/bangkit23
54  */
55 contract ERC20Basic {
56     function totalSupply() public view returns (uint256);
57     function balanceOf(address who) public view returns (uint256);
58     function transfer(address to, uint256 value) public returns (bool);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67     using SafeMath for uint256;
68 
69     mapping(address => uint256) balances;
70 
71     uint256 totalSupply_;
72 
73     /**
74     * @dev total number of tokens in existence
75     */
76     function totalSupply() public view returns (uint256) {
77         return totalSupply_;
78     }
79 
80     /**
81     * @dev transfer token for a specified address
82     * @param _to The address to transfer to.
83     * @param _value The amount to be transferred.
84     */
85     function transfer(address _to, uint256 _value) public returns (bool) {
86         require(_to != address(0));
87         require(_value <= balances[msg.sender]);
88 
89         // SafeMath.sub will throw if there is not enough balance.
90         balances[msg.sender] = balances[msg.sender].sub(_value);
91         balances[_to] = balances[_to].add(_value);
92         Transfer(msg.sender, _to, _value);
93         return true;
94     }
95 
96     /**
97     * @dev Gets the balance of the specified address.
98     * @param _owner The address to query the the balance of.
99     * @return An uint256 representing the amount owned by the passed address.
100     */
101     function balanceOf(address _owner) public view returns (uint256 balance) {
102         return balances[_owner];
103     }
104 
105 }
106 
107 contract ERC20 is ERC20Basic {
108     function allowance(address owner, address spender) public view returns (uint256);
109     function transferFrom(address from, address to, uint256 value) public returns (bool);
110     function approve(address spender, uint256 value) public returns (bool);
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 contract StandardToken is ERC20, BasicToken {
115 
116     mapping (address => mapping (address => uint256)) internal allowed;
117 
118 
119     /**
120     * @dev Transfer tokens from one address to another
121     * @param _from address The address which you want to send tokens from
122     * @param _to address The address which you want to transfer to
123     * @param _value uint256 the amount of tokens to be transferred
124     */
125     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
126         require(_to != address(0));
127         require(_value <= balances[_from]);
128         require(_value <= allowed[_from][msg.sender]);
129 
130         balances[_from] = balances[_from].sub(_value);
131         balances[_to] = balances[_to].add(_value);
132         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
133         Transfer(_from, _to, _value);
134         return true;
135     }
136 
137     /**
138     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
139     *
140     * Beware that changing an allowance with this method brings the risk that someone may use both the old
141     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
142     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
143     * @param _spender The address which will spend the funds.
144     * @param _value The amount of tokens to be spent.
145     */
146     function approve(address _spender, uint256 _value) public returns (bool) {
147         allowed[msg.sender][_spender] = _value;
148         Approval(msg.sender, _spender, _value);
149         return true;
150     }
151 
152     /**
153     * @dev Function to check the amount of tokens that an owner allowed to a spender.
154     * @param _owner address The address which owns the funds.
155     * @param _spender address The address which will spend the funds.
156     * @return A uint256 specifying the amount of tokens still available for the spender.
157     */
158     function allowance(address _owner, address _spender) public view returns (uint256) {
159         return allowed[_owner][_spender];
160     }
161 
162     /**
163     * @dev Increase the amount of tokens that an owner allowed to a spender.
164     *
165     * approve should be called when allowed[_spender] == 0. To increment
166     * allowed value is better to use this function to avoid 2 calls (and wait until
167     * the first transaction is mined)
168     * From MonolithDAO Token.sol
169     * @param _spender The address which will spend the funds.
170     * @param _addedValue The amount of tokens to increase the allowance by.
171     */
172     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
173         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
174         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175         return true;
176     }
177 
178     /**
179     * @dev Decrease the amount of tokens that an owner allowed to a spender.
180     *
181     * approve should be called when allowed[_spender] == 0. To decrement
182     * allowed value is better to use this function to avoid 2 calls (and wait until
183     * the first transaction is mined)
184     * From MonolithDAO Token.sol
185     * @param _spender The address which will spend the funds.
186     * @param _subtractedValue The amount of tokens to decrease the allowance by.
187     */
188     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
189         uint oldValue = allowed[msg.sender][_spender];
190         if (_subtractedValue > oldValue) {
191             allowed[msg.sender][_spender] = 0;
192         } else {
193             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
194         }
195         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196         return true;
197     }
198 
199 }
200 
201 
202 contract Jancok is StandardToken {
203 
204     string  public name     = "Frederico BC";
205     string  public symbol   = "FBC";
206     uint8 public decimals = 18;
207 
208 
209     /**
210     * @dev Constructor, takes intial Token.
211     */
212     function Jancok() public {
213         totalSupply_ = 3000000 * 1 ether;
214         balances[msg.sender] = totalSupply_;
215     }
216 
217     /**
218     * @dev Batch transfer some tokens to some addresses, address and value is one-on-one.
219     * @param _dests Array of addresses
220     * @param _values Array of transfer tokens number
221     */
222     function batchTransfer(address[] _dests, uint256[] _values) public {
223         require(_dests.length == _values.length);
224         uint256 i = 0;
225         while (i < _dests.length) {
226             transfer(_dests[i], _values[i]);
227             i += 1;
228         }
229     }
230 
231     /**
232     * @dev Batch transfer equal tokens amout to some addresses
233     * @param _dests Array of addresses
234     * @param _value Number of transfer tokens amount
235     */
236     function batchTransferSingleValue(address[] _dests, uint256 _value) public {
237         uint256 i = 0;
238         while (i < _dests.length) {
239             transfer(_dests[i], _value);
240             i += 1;
241         }
242     }
243 }