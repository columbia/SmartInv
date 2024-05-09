1 pragma solidity 0.5.7;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  */
7 contract ERC20Basic {
8     function totalSupply() public view returns (uint256);
9     function balanceOf(address who) public view returns (uint256);
10     function transfer(address to, uint256 value) public returns (bool);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Burn(address indexed burner, uint256 value);
13 }
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19     /**
20      * @dev Multiplies two numbers, throws on overflow.
21      */
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26         uint256 c = a * b;
27         assert(c / a == b);
28         return c;
29     }
30     /**
31      * @dev Integer division of two numbers, truncating the quotient.
32      */
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         // assert(b > 0); // Solidity automatically throws when dividing by 0
35         uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37         return c;
38     }
39     /**
40      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         assert(b <= a);
44         return a - b;
45     }
46     /**
47      * @dev Adds two numbers, throws on overflow.
48      */
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         assert(c >= a);
52         return c;
53     }
54 }
55 /**
56  * @title Basic token
57  * @dev Basic version of StandardToken, with no allowances.
58  */
59 contract BasicToken is ERC20Basic {
60     using SafeMath for uint256;
61     mapping(address => uint256) balances;
62     uint256 totalSupply_;
63     uint256 burnedTotalNum_;
64 
65     /**
66      * @dev total number of tokens in existence
67      */
68     function totalSupply() public view returns (uint256) {
69         return totalSupply_;
70     }
71 
72     /**
73      * @dev total number of tokens already burned
74      */
75     function totalBurned() public view returns (uint256) {
76         return burnedTotalNum_;
77     }
78 
79     function burn(uint256 _value) public returns (bool) {
80         require(_value <= balances[msg.sender]);
81 
82         address burner = msg.sender;
83         balances[burner] = balances[burner].sub(_value);
84         totalSupply_ = totalSupply_.sub(_value);
85         burnedTotalNum_ = burnedTotalNum_.add(_value);
86 
87         emit Burn(burner, _value);
88         return true;
89     }
90 
91     /**
92      * @dev transfer token for a specified address
93      * @param _to The address to transfer to.
94      * @param _value The amount to be transferred.
95      */
96     function transfer(address _to, uint256 _value) public returns (bool) {
97         // if _to is address(0), invoke burn function.
98         if (_to == address(0)) {
99             return burn(_value);
100         }
101 
102         require(_value <= balances[msg.sender]);
103         // SafeMath.sub will throw if there is not enough balance.
104         balances[msg.sender] = balances[msg.sender].sub(_value);
105         balances[_to] = balances[_to].add(_value);
106         emit Transfer(msg.sender, _to, _value);
107         return true;
108     }
109     /**
110      * @dev Gets the balance of the specified address.
111      * @param _owner The address to query the the balance of.
112      * @return An uint256 representing the amount owned by the passed address.
113      */
114     function balanceOf(address _owner) public view returns (uint256) {
115         return balances[_owner];
116     }
117 }
118 /**
119  * @title ERC20 interface
120  */
121 contract ERC20 is ERC20Basic {
122     function allowance(address owner, address spender) public view returns (uint256);
123     function transferFrom(address from, address to, uint256 value) public returns (bool);
124     function approve(address spender, uint256 value) public returns (bool);
125     event Approval(address indexed owner, address indexed spender, uint256 value);
126 }
127 /**
128  * @title Standard ERC20 token
129  */
130 contract StandardToken is ERC20, BasicToken {
131     uint private constant MAX_UINT = 2**256 - 1;
132 
133     mapping (address => mapping (address => uint256)) internal allowed;
134 
135     function burnFrom(address _owner, uint256 _value) public returns (bool) {
136         require(_owner != address(0));
137         require(_value <= balances[_owner]);
138         require(_value <= allowed[_owner][msg.sender]);
139 
140         balances[_owner] = balances[_owner].sub(_value);
141         if (allowed[_owner][msg.sender] < MAX_UINT) {
142             allowed[_owner][msg.sender] = allowed[_owner][msg.sender].sub(_value);
143         }
144         totalSupply_ = totalSupply_.sub(_value);
145         burnedTotalNum_ = burnedTotalNum_.add(_value);
146 
147         emit Burn(_owner, _value);
148         return true;
149     }
150 
151     /**
152      * @dev Transfer tokens from one address to another
153      * @param _from address The address which you want to send tokens from
154      * @param _to address The address which you want to transfer to
155      * @param _value uint256 the amount of tokens to be transferred
156      */
157     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
158         if (_to == address(0)) {
159             return burnFrom(_from, _value);
160         }
161 
162         require(_value <= balances[_from]);
163         require(_value <= allowed[_from][msg.sender]);
164         balances[_from] = balances[_from].sub(_value);
165         balances[_to] = balances[_to].add(_value);
166 
167         if (allowed[_from][msg.sender] < MAX_UINT) {
168             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
169         }
170         emit Transfer(_from, _to, _value);
171         return true;
172     }
173     /**
174      *
175      * Beware that changing an allowance with this method brings the risk that someone may use both the old
176      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
177      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
178      * @param _spender The address which will spend the funds.
179      * @param _value The amount of tokens to be spent.
180      */
181     function approve(address _spender, uint256 _value) public returns (bool) {
182         allowed[msg.sender][_spender] = _value;
183         emit Approval(msg.sender, _spender, _value);
184         return true;
185     }
186     /**
187      * @dev Function to check the amount of tokens that an owner allowed to a spender.
188      * @param _owner address The address which owns the funds.
189      * @param _spender address The address which will spend the funds.
190      * @return A uint256 specifying the amount of tokens still available for the spender.
191      */
192     function allowance(address _owner, address _spender) public view returns (uint256) {
193         return allowed[_owner][_spender];
194     }
195     /**
196      * @dev Increase the amount of tokens that an owner allowed to a spender.
197      *
198      * approve should be called when allowed[_spender] == 0. To increment
199      * allowed value is better to use this function to avoid 2 calls (and wait until
200      * the first transaction is mined)
201      * From MonolithDAO Token.sol
202      * @param _spender The address which will spend the funds.
203      * @param _addedValue The amount of tokens to increase the allowance by.
204      */
205     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
206         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
207         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208         return true;
209     }
210     /**
211      * @dev Decrease the amount of tokens that an owner allowed to a spender.
212      *
213      * approve should be called when allowed[_spender] == 0. To decrement
214      * allowed value is better to use this function to avoid 2 calls (and wait until
215      * the first transaction is mined)
216      * From MonolithDAO Token.sol
217      * @param _spender The address which will spend the funds.
218      * @param _subtractedValue The amount of tokens to decrease the allowance by.
219      */
220     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
221         uint oldValue = allowed[msg.sender][_spender];
222         if (_subtractedValue > oldValue) {
223             allowed[msg.sender][_spender] = 0;
224         } else {
225             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
226         }
227         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228         return true;
229     }
230 }
231 
232 contract BCT is StandardToken {
233     using SafeMath for uint256;
234 
235     string     public name = "Bitcratic";
236     string     public symbol = "BCT";
237     uint8      public decimals = 18;
238 
239     constructor() public {
240         totalSupply_ = 88000000000000000000000000;
241 		
242 
243 
244         balances[msg.sender] = totalSupply_;
245     }
246 
247     function batchTransfer(address[] calldata accounts, uint256[] calldata amounts)
248         external
249         returns (bool)
250     {
251         require(accounts.length == amounts.length);
252         for (uint i = 0; i < accounts.length; i++) {
253             require(transfer(accounts[i], amounts[i]), "transfer failed");
254         }
255         return true;
256     }
257 
258     function () payable external {
259         revert();
260     }
261 
262 }