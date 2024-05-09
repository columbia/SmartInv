1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract ERC20Basic {
6     function totalSupply() public view returns (uint256);
7     function balanceOf(address who) public view returns (uint256);
8     function transfer(address to, uint256 value) public returns (bool);
9     event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 library SafeMath {
12 
13     /**
14     * @dev Multiplies two numbers, throws on overflow.
15     */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
18         // benefit is lost if 'b' is also tested.
19         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20         if (a == 0) {
21             return 0;
22         }
23 
24         c = a * b;
25         assert(c / a == b);
26         return c;
27     }
28 
29     /**
30     * @dev Integer division of two numbers, truncating the quotient.
31     */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // assert(b > 0); // Solidity automatically throws when dividing by 0
34         // uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36         return a / b;
37     }
38 
39     /**
40     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         assert(b <= a);
44         return a - b;
45     }
46 
47     /**
48     * @dev Adds two numbers, throws on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
51         c = a + b;
52         assert(c >= a);
53         return c;
54     }
55 }
56 contract BasicToken is ERC20Basic {
57     using SafeMath for uint256;
58 
59     mapping(address => uint256) balances;
60 
61     uint256 totalSupply_;
62 
63     /**
64     * @dev Total number of tokens in existence
65     */
66     function totalSupply() public view returns (uint256) {
67         return totalSupply_;
68     }
69 
70     /**
71     * @dev Transfer token for a specified address
72     * @param _to The address to transfer to.
73     * @param _value The amount to be transferred.
74     */
75     function transfer(address _to, uint256 _value) public returns (bool) {
76         require(_value <= balances[msg.sender]);
77         require(_to != address(0));
78 
79         balances[msg.sender] = balances[msg.sender].sub(_value);
80         balances[_to] = balances[_to].add(_value);
81         emit Transfer(msg.sender, _to, _value);
82         return true;
83     }
84 
85     /**
86     * @dev Gets the balance of the specified address.
87     * @param _owner The address to query the the balance of.
88     * @return An uint256 representing the amount owned by the passed address.
89     */
90     function balanceOf(address _owner) public view returns (uint256) {
91         return balances[_owner];
92     }
93 
94 }
95 contract ERC20 is ERC20Basic {
96     function allowance(address owner, address spender)
97     public view returns (uint256);
98 
99     function transferFrom(address from, address to, uint256 value)
100     public returns (bool);
101 
102     function approve(address spender, uint256 value) public returns (bool);
103     event Approval(
104         address indexed owner,
105         address indexed spender,
106         uint256 value
107     );
108 }
109 contract StandardToken is ERC20, BasicToken {
110 
111     mapping (address => mapping (address => uint256)) internal allowed;
112 
113 
114     /**
115      * @dev Transfer tokens from one address to another
116      * @param _from address The address which you want to send tokens from
117      * @param _to address The address which you want to transfer to
118      * @param _value uint256 the amount of tokens to be transferred
119      */
120     function transferFrom(
121         address _from,
122         address _to,
123         uint256 _value
124     )
125     public
126     returns (bool)
127     {
128         require(_value <= balances[_from]);
129         require(_value <= allowed[_from][msg.sender]);
130         require(_to != address(0));
131 
132         balances[_from] = balances[_from].sub(_value);
133         balances[_to] = balances[_to].add(_value);
134         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
135         emit Transfer(_from, _to, _value);
136         return true;
137     }
138 
139     /**
140      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
141      * Beware that changing an allowance with this method brings the risk that someone may use both the old
142      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
143      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
144      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      * @param _spender The address which will spend the funds.
146      * @param _value The amount of tokens to be spent.
147      */
148     function approve(address _spender, uint256 _value) public returns (bool) {
149         allowed[msg.sender][_spender] = _value;
150         emit Approval(msg.sender, _spender, _value);
151         return true;
152     }
153 
154     /**
155      * @dev Function to check the amount of tokens that an owner allowed to a spender.
156      * @param _owner address The address which owns the funds.
157      * @param _spender address The address which will spend the funds.
158      * @return A uint256 specifying the amount of tokens still available for the spender.
159      */
160     function allowance(
161         address _owner,
162         address _spender
163     )
164     public
165     view
166     returns (uint256)
167     {
168         return allowed[_owner][_spender];
169     }
170 
171     /**
172      * @dev Increase the amount of tokens that an owner allowed to a spender.
173      * approve should be called when allowed[_spender] == 0. To increment
174      * allowed value is better to use this function to avoid 2 calls (and wait until
175      * the first transaction is mined)
176      * From MonolithDAO Token.sol
177      * @param _spender The address which will spend the funds.
178      * @param _addedValue The amount of tokens to increase the allowance by.
179      */
180     function increaseApproval(
181         address _spender,
182         uint256 _addedValue
183     )
184     public
185     returns (bool)
186     {
187         allowed[msg.sender][_spender] = (
188         allowed[msg.sender][_spender].add(_addedValue));
189         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190         return true;
191     }
192 
193     /**
194      * @dev Decrease the amount of tokens that an owner allowed to a spender.
195      * approve should be called when allowed[_spender] == 0. To decrement
196      * allowed value is better to use this function to avoid 2 calls (and wait until
197      * the first transaction is mined)
198      * From MonolithDAO Token.sol
199      * @param _spender The address which will spend the funds.
200      * @param _subtractedValue The amount of tokens to decrease the allowance by.
201      */
202     function decreaseApproval(
203         address _spender,
204         uint256 _subtractedValue
205     )
206     public
207     returns (bool)
208     {
209         uint256 oldValue = allowed[msg.sender][_spender];
210         if (_subtractedValue >= oldValue) {
211             allowed[msg.sender][_spender] = 0;
212         } else {
213             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214         }
215         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216         return true;
217     }
218 
219 }
220 contract ImagolStandardToken is StandardToken {
221     string public name;
222     string public symbol;
223     uint8 public decimals;
224 
225     constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalTokenAmount, address _creator) public {
226         name = _name;
227         symbol = _symbol;
228         decimals = _decimals;
229         totalSupply_ = _totalTokenAmount;
230         balances[_creator] = _totalTokenAmount;
231     }
232 }