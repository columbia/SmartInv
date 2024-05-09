1 pragma solidity ^0.5.2;
2 
3 contract ERC20Basic {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, throws on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16         // benefit is lost if 'b' is also tested.
17         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18         if (a == 0) {
19             return 0;
20         }
21 
22         c = a * b;
23         assert(c / a == b);
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two numbers, truncating the quotient.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // assert(b > 0); // Solidity automatically throws when dividing by 0
32         // uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34         return a / b;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         assert(b <= a);
42         return a - b;
43     }
44 
45     /**
46     * @dev Adds two numbers, throws on overflow.
47     */
48     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49         c = a + b;
50         assert(c >= a);
51         return c;
52     }
53 }
54 contract BasicToken is ERC20Basic {
55     using SafeMath for uint256;
56 
57     mapping(address => uint256) balances;
58 
59     uint256 totalSupply_;
60 
61     /**
62     * @dev Total number of tokens in existence
63     */
64     function totalSupply() public view returns (uint256) {
65         return totalSupply_;
66     }
67 
68     /**
69     * @dev Transfer token for a specified address
70     * @param _to The address to transfer to.
71     * @param _value The amount to be transferred.
72     */
73     function transfer(address _to, uint256 _value) public returns (bool) {
74         require(_to != address(0));
75         require(_value <= balances[msg.sender]);
76 
77         balances[msg.sender] = balances[msg.sender].sub(_value);
78         balances[_to] = balances[_to].add(_value);
79         emit Transfer(msg.sender, _to, _value);
80         return true;
81     }
82 
83     /**
84     * @dev Gets the balance of the specified address.
85     * @param _owner The address to query the the balance of.
86     * @return An uint256 representing the amount owned by the passed address.
87     */
88     function balanceOf(address _owner) public view returns (uint256) {
89         return balances[_owner];
90     }
91 
92 }
93 contract ERC20 is ERC20Basic {
94     function allowance(address owner, address spender) public view returns (uint256);
95     function transferFrom(address from, address to, uint256 value) public returns (bool);
96     function approve(address spender, uint256 value) public returns (bool);
97 
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 contract StandardToken is ERC20, BasicToken {
101 
102     mapping (address => mapping (address => uint256)) internal allowed;
103 
104 
105     /**
106      * @dev Transfer tokens from one address to another
107      * @param _from address The address which you want to send tokens from
108      * @param _to address The address which you want to transfer to
109      * @param _value uint256 the amount of tokens to be transferred
110      */
111     function transferFrom(
112         address _from,
113         address _to,
114         uint256 _value
115     )
116         public
117         returns (bool)
118     {
119         require(_to != address(0));
120         require(_value <= balances[_from]);
121         require(_value <= allowed[_from][msg.sender]);
122 
123         balances[_from] = balances[_from].sub(_value);
124         balances[_to] = balances[_to].add(_value);
125         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126         emit Transfer(_from, _to, _value);
127         return true;
128     }
129 
130     /**
131      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
132      * Beware that changing an allowance with this method brings the risk that someone may use both the old
133      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
134      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
135      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136      * @param _spender The address which will spend the funds.
137      * @param _value The amount of tokens to be spent.
138      */
139     function approve(address _spender, uint256 _value) public returns (bool) {
140         allowed[msg.sender][_spender] = _value;
141         emit Approval(msg.sender, _spender, _value);
142         return true;
143     }
144 
145     /**
146      * @dev Function to check the amount of tokens that an owner allowed to a spender.
147      * @param _owner address The address which owns the funds.
148      * @param _spender address The address which will spend the funds.
149      * @return A uint256 specifying the amount of tokens still available for the spender.
150      */
151     function allowance(
152         address _owner,
153         address _spender
154      )
155         public
156         view
157         returns (uint256)
158     {
159         return allowed[_owner][_spender];
160     }
161 
162     /**
163      * @dev Increase the amount of tokens that an owner allowed to a spender.
164      * approve should be called when allowed[_spender] == 0. To increment
165      * allowed value is better to use this function to avoid 2 calls (and wait until
166      * the first transaction is mined)
167      * From MonolithDAO Token.sol
168      * @param _spender The address which will spend the funds.
169      * @param _addedValue The amount of tokens to increase the allowance by.
170      */
171     function increaseApproval(
172         address _spender,
173         uint256 _addedValue
174     )
175         public
176         returns (bool)
177     {
178         allowed[msg.sender][_spender] = (
179             allowed[msg.sender][_spender].add(_addedValue));
180         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181         return true;
182     }
183 
184     /**
185      * @dev Decrease the amount of tokens that an owner allowed to a spender.
186      * approve should be called when allowed[_spender] == 0. To decrement
187      * allowed value is better to use this function to avoid 2 calls (and wait until
188      * the first transaction is mined)
189      * From MonolithDAO Token.sol
190      * @param _spender The address which will spend the funds.
191      * @param _subtractedValue The amount of tokens to decrease the allowance by.
192      */
193     function decreaseApproval(
194         address _spender,
195         uint256 _subtractedValue
196     )
197         public
198         returns (bool)
199     {
200         uint256 oldValue = allowed[msg.sender][_spender];
201         if (_subtractedValue > oldValue) {
202             allowed[msg.sender][_spender] = 0;
203         } else {
204             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
205         }
206         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207         return true;
208     }
209 
210 }
211 contract FaucetToken is StandardToken {
212     string public name;
213     string public symbol;
214     uint8 public decimals;
215 
216     constructor(uint256 _initialAmount, string memory _tokenName, uint8 _decimalUnits, string memory _tokenSymbol) public {
217         totalSupply_ = _initialAmount;
218         balances[msg.sender] = _initialAmount;
219         name = _tokenName;
220         symbol = _tokenSymbol;
221         decimals = _decimalUnits;
222     }
223 
224     /**
225       * @dev Arbitrarily adds tokens to any account
226       */
227     function allocateTo(address _owner, uint256 value) public {
228         balances[_owner] += value;
229         totalSupply_ += value;
230         emit Transfer(address(this), _owner, value);
231     }
232 }