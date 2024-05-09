1 pragma solidity 0.5.7;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     function totalSupply() public view returns (uint256);
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Burn(address indexed burner, uint256 value);
14 }
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20     /**
21      * @dev Multiplies two numbers, throws on overflow.
22      */
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) {
25             return 0;
26         }
27         uint256 c = a * b;
28         assert(c / a == b);
29         return c;
30     }
31     /**
32      * @dev Integer division of two numbers, truncating the quotient.
33      */
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         // assert(b > 0); // Solidity automatically throws when dividing by 0
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return c;
39     }
40     /**
41      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42      */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         assert(b <= a);
45         return a - b;
46     }
47     /**
48      * @dev Adds two numbers, throws on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         assert(c >= a);
53         return c;
54     }
55 }
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances.
59  */
60 contract BasicToken is ERC20Basic {
61     using SafeMath for uint256;
62     mapping(address => uint256) balances;
63     uint256 totalSupply_;
64     uint256 burnedTotalNum_;
65 
66     /**
67      * @dev total number of tokens in existence
68      */
69     function totalSupply() public view returns (uint256) {
70         return totalSupply_;
71     }
72 
73     /**
74      * @dev total number of tokens already burned
75      */
76     function totalBurned() public view returns (uint256) {
77         return burnedTotalNum_;
78     }
79 
80     function burn(uint256 _value) public returns (bool) {
81         require(_value <= balances[msg.sender]);
82 
83         address burner = msg.sender;
84         balances[burner] = balances[burner].sub(_value);
85         totalSupply_ = totalSupply_.sub(_value);
86         burnedTotalNum_ = burnedTotalNum_.add(_value);
87 
88         emit Burn(burner, _value);
89         return true;
90     }
91 
92     /**
93      * @dev transfer token for a specified address
94      * @param _to The address to transfer to.
95      * @param _value The amount to be transferred.
96      */
97     function transfer(address _to, uint256 _value) public returns (bool) {
98         // if _to is address(0), invoke burn function.
99         if (_to == address(0)) {
100             return burn(_value);
101         }
102 
103         require(_value <= balances[msg.sender]);
104         // SafeMath.sub will throw if there is not enough balance.
105         balances[msg.sender] = balances[msg.sender].sub(_value);
106         balances[_to] = balances[_to].add(_value);
107         emit Transfer(msg.sender, _to, _value);
108         return true;
109     }
110     /**
111      * @dev Gets the balance of the specified address.
112      * @param _owner The address to query the the balance of.
113      * @return An uint256 representing the amount owned by the passed address.
114      */
115     function balanceOf(address _owner) public view returns (uint256) {
116         return balances[_owner];
117     }
118 }
119 /**
120  * @title ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/20
122  */
123 contract ERC20 is ERC20Basic {
124     function allowance(address owner, address spender) public view returns (uint256);
125     function transferFrom(address from, address to, uint256 value) public returns (bool);
126     function approve(address spender, uint256 value) public returns (bool);
127     event Approval(address indexed owner, address indexed spender, uint256 value);
128 }
129 /**
130  * @title Standard ERC20 token
131  *
132  * @dev Implementation of the basic standard token.
133  * @dev https://github.com/ethereum/EIPs/issues/20
134  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
135  */
136 contract StandardToken is ERC20, BasicToken {
137     uint private constant MAX_UINT = 2**256 - 1;
138 
139     mapping (address => mapping (address => uint256)) internal allowed;
140 
141     function burnFrom(address _owner, uint256 _value) public returns (bool) {
142         require(_owner != address(0));
143         require(_value <= balances[_owner]);
144         require(_value <= allowed[_owner][msg.sender]);
145 
146         balances[_owner] = balances[_owner].sub(_value);
147         if (allowed[_owner][msg.sender] < MAX_UINT) {
148             allowed[_owner][msg.sender] = allowed[_owner][msg.sender].sub(_value);
149         }
150         totalSupply_ = totalSupply_.sub(_value);
151         burnedTotalNum_ = burnedTotalNum_.add(_value);
152 
153         emit Burn(_owner, _value);
154         return true;
155     }
156 
157     /**
158      * @dev Transfer tokens from one address to another
159      * @param _from address The address which you want to send tokens from
160      * @param _to address The address which you want to transfer to
161      * @param _value uint256 the amount of tokens to be transferred
162      */
163     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
164         if (_to == address(0)) {
165             return burnFrom(_from, _value);
166         }
167 
168         require(_value <= balances[_from]);
169         require(_value <= allowed[_from][msg.sender]);
170         balances[_from] = balances[_from].sub(_value);
171         balances[_to] = balances[_to].add(_value);
172 
173         /// an allowance of MAX_UINT represents an unlimited allowance.
174         /// @dev see https://github.com/ethereum/EIPs/issues/717
175         if (allowed[_from][msg.sender] < MAX_UINT) {
176             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
177         }
178         emit Transfer(_from, _to, _value);
179         return true;
180     }
181     /**
182      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
183      *
184      * Beware that changing an allowance with this method brings the risk that someone may use both the old
185      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
186      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
187      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188      * @param _spender The address which will spend the funds.
189      * @param _value The amount of tokens to be spent.
190      */
191     function approve(address _spender, uint256 _value) public returns (bool) {
192         allowed[msg.sender][_spender] = _value;
193         emit Approval(msg.sender, _spender, _value);
194         return true;
195     }
196     /**
197      * @dev Function to check the amount of tokens that an owner allowed to a spender.
198      * @param _owner address The address which owns the funds.
199      * @param _spender address The address which will spend the funds.
200      * @return A uint256 specifying the amount of tokens still available for the spender.
201      */
202     function allowance(address _owner, address _spender) public view returns (uint256) {
203         return allowed[_owner][_spender];
204     }
205     /**
206      * @dev Increase the amount of tokens that an owner allowed to a spender.
207      *
208      * approve should be called when allowed[_spender] == 0. To increment
209      * allowed value is better to use this function to avoid 2 calls (and wait until
210      * the first transaction is mined)
211      * From MonolithDAO Token.sol
212      * @param _spender The address which will spend the funds.
213      * @param _addedValue The amount of tokens to increase the allowance by.
214      */
215     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
216         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
217         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218         return true;
219     }
220     /**
221      * @dev Decrease the amount of tokens that an owner allowed to a spender.
222      *
223      * approve should be called when allowed[_spender] == 0. To decrement
224      * allowed value is better to use this function to avoid 2 calls (and wait until
225      * the first transaction is mined)
226      * From MonolithDAO Token.sol
227      * @param _spender The address which will spend the funds.
228      * @param _subtractedValue The amount of tokens to decrease the allowance by.
229      */
230     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
231         uint oldValue = allowed[msg.sender][_spender];
232         if (_subtractedValue > oldValue) {
233             allowed[msg.sender][_spender] = 0;
234         } else {
235             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
236         }
237         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238         return true;
239     }
240 }
241 
242 contract LRC_v2 is StandardToken {
243     using SafeMath for uint256;
244 
245     string     public name = "LoopringCoin V2";
246     string     public symbol = "LRC";
247     uint8      public decimals = 18;
248 
249     constructor() public {
250         // @See https://etherscan.io/address/0xEF68e7C694F40c8202821eDF525dE3782458639f#readContract
251         totalSupply_ = 1395076054523857892274603100;
252 
253         balances[msg.sender] = totalSupply_;
254     }
255 
256     function batchTransfer(address[] calldata accounts, uint256[] calldata amounts)
257         external
258         returns (bool)
259     {
260         require(accounts.length == amounts.length);
261         for (uint i = 0; i < accounts.length; i++) {
262             require(transfer(accounts[i], amounts[i]), "transfer failed");
263         }
264         return true;
265     }
266 
267     function () payable external {
268         revert();
269     }
270 
271 }