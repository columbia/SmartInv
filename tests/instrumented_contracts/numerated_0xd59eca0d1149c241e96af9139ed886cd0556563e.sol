1 pragma solidity ^0.4.18;
2 /*
3 Trump Coins is an ERC-20 Token Standard Compliant
4 */
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12     /**
13     * @dev Multiplies two numbers, throws on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         if (a == 0) {
17             return 0;
18         }
19         uint256 c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24     /**
25     * @dev Integer division of two numbers, truncating the quotient.
26     */
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         // assert(b > 0); // Solidity automatically throws when dividing by 0
29         // uint256 c = a / b;
30         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31         return a / b;
32     }
33 
34     /**
35     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36     */
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     /**
43     * @dev Adds two numbers, throws on overflow.
44     */
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         assert(c >= a);
48         return c;
49     }
50 }
51 
52 /**
53  * @title ERC20Basic
54  * @dev Simpler version of ERC20 interface
55  */
56 contract ERC20Basic {
57     function totalSupply() public view returns (uint256);
58     function balanceOf(address who) public view returns (uint256);
59     function transfer(address to, uint256 value) public returns (bool);
60     event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 
64 /**
65  * @title ERC20 interface
66  */
67 contract ERC20 is ERC20Basic {
68     function allowance(address owner, address spender) public view returns (uint256);
69     function transferFrom(address from, address to, uint256 value) public returns (bool);
70     function approve(address spender, uint256 value) public returns (bool);
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 /**
75  * @title Basic token
76  * @dev Basic version of StandardToken, with no allowances.
77  */
78 contract BasicToken is ERC20Basic {
79     using SafeMath for uint256;
80 
81     mapping(address => uint256) balances;
82 
83     uint256 totalSupply_;
84 
85     /**
86     * @dev total number of tokens in existence
87     */
88     function totalSupply() public view returns (uint256) {
89         return totalSupply_;
90     }
91 
92     /**
93     * @dev transfer token for a specified address
94     * @param _to The address to transfer to.
95     * @param _value The amount to be transferred.
96     */
97     function transfer(address _to, uint256 _value) public returns (bool) {
98         require(_to != address(0));
99         require(_value <= balances[msg.sender]);
100 
101         balances[msg.sender] = balances[msg.sender].sub(_value);
102         balances[_to] = balances[_to].add(_value);
103         emit Transfer(msg.sender, _to, _value);
104         return true;
105     }
106 
107     /**
108     * @dev Gets the balance of the specified address.
109     * @param _owner The address to query the the balance of.
110     * @return An uint256 representing the amount owned by the passed address.
111     */
112     function balanceOf(address _owner) public view returns (uint256 balance) {
113         return balances[_owner];
114     }
115 
116 }
117 
118 /**
119  * @title Standard ERC20 token
120  *
121  * @dev Implementation of the basic standard token.
122  */
123 contract StandardToken is ERC20, BasicToken {
124 
125     mapping (address => mapping (address => uint256)) internal allowed;
126 
127     /**
128     * @dev Transfer tokens from one address to another
129     * @param _from address The address which you want to send tokens from
130     * @param _to address The address which you want to transfer to
131     * @param _value uint256 the amount of tokens to be transferred
132     */
133     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
134         require(_to != address(0));
135         require(_value <= balances[_from]);
136         require(_value <= allowed[_from][msg.sender]);
137 
138         balances[_from] = balances[_from].sub(_value);
139         balances[_to] = balances[_to].add(_value);
140         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
141         emit Transfer(_from, _to, _value);
142         return true;
143     }
144 
145     /**
146     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147     *
148     * Beware that changing an allowance with this method brings the risk that someone may use both the old
149     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
151     * @param _spender The address which will spend the funds.
152     * @param _value The amount of tokens to be spent.
153     */
154     function approve(address _spender, uint256 _value) public returns (bool) {
155         allowed[msg.sender][_spender] = _value;
156         emit Approval(msg.sender, _spender, _value);
157         return true;
158     }
159 
160     /**
161     * @dev Function to check the amount of tokens that an owner allowed to a spender.
162     * @param _owner address The address which owns the funds.
163     * @param _spender address The address which will spend the funds.
164     * @return A uint256 specifying the amount of tokens still available for the spender.
165     */
166     function allowance(address _owner, address _spender) public view returns (uint256) {
167         return allowed[_owner][_spender];
168     }
169 
170     /**
171     * @dev Increase the amount of tokens that an owner allowed to a spender.
172     *
173     * approve should be called when allowed[_spender] == 0. To increment
174     * allowed value is better to use this function to avoid 2 calls (and wait until
175     * the first transaction is mined)
176     * @param _spender The address which will spend the funds.
177     * @param _addedValue The amount of tokens to increase the allowance by.
178     */
179     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
180         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
181         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182         return true;
183     }
184 
185     /**
186     * @dev Decrease the amount of tokens that an owner allowed to a spender.
187     *
188     * approve should be called when allowed[_spender] == 0. To decrement
189     * allowed value is better to use this function to avoid 2 calls (and wait until
190     * the first transaction is mined)
191     * @param _spender The address which will spend the funds.
192     * @param _subtractedValue The amount of tokens to decrease the allowance by.
193     */
194     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
195         uint oldValue = allowed[msg.sender][_spender];
196         if (_subtractedValue > oldValue) {
197             allowed[msg.sender][_spender] = 0;
198         } else {
199             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
200         }
201         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202         return true;
203     }
204 
205 }
206 
207 
208 contract TrumpCoins is StandardToken {
209     
210     string public name = "Trump Coins";
211     string public symbol = "TRUMP";
212     string public version = "1.0";
213     uint8 public decimals = 18;
214     
215     uint256 INITIAL_SUPPLY = 20000000000e18;
216     
217     function TrumpCoins() public {
218         totalSupply_ = INITIAL_SUPPLY;
219         balances[this] = totalSupply_;
220         allowed[this][msg.sender] = totalSupply_;
221         
222         emit Approval(this, msg.sender, balances[this]);
223     }
224 
225 }