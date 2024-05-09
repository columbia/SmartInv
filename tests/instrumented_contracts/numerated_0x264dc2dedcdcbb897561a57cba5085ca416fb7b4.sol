1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         assert(a == b * c);
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a - b;
26         assert(b <= a);
27         assert(a == c + b);
28         return c;
29     }
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         assert(c >= a);
34         assert(a == c - b);
35         return c;
36     }
37 }
38 contract QunQunTokenIssue {
39 
40     address public tokenContractAddress;
41     uint16  public lastRate = 950; // the second year inflate rate is 950/10000
42     uint256 public lastBlockNumber;
43     uint256 public lastYearTotalSupply = 15 * 10 ** 26; //init issue
44     uint8   public inflateCount = 0;
45     bool    public isFirstYear = true; //not inflate in 2018
46 
47     function QunQunTokenIssue (address _tokenContractAddress) public{
48         tokenContractAddress = _tokenContractAddress;
49         lastBlockNumber = block.number;
50     }
51 
52     function getRate() internal returns (uint256){
53         if(inflateCount == 10){
54             // decreasing 0.5% per year until the overall inflation rate reaches 1%.
55             if(lastRate > 100){
56                 lastRate -= 50;
57             }
58             // reset count
59             inflateCount = 0;
60         }
61         // inflate 1/10 each time
62         return SafeMath.div(lastRate, 10);
63     }
64 
65     // anyone can call this function
66     function issue() public  {
67         //ensure first year can not inflate
68         if(isFirstYear){
69             // 2102400 blocks is about one year, suppose it takes 15 seconds to generate a new block
70             require(SafeMath.sub(block.number, lastBlockNumber) > 2102400);
71             isFirstYear = false;
72         }
73         // 210240 blocks is about one tenth year, ensure only 10 times inflation per year
74         require(SafeMath.sub(block.number, lastBlockNumber) > 210240);
75         QunQunToken tokenContract = QunQunToken(tokenContractAddress);
76         //adjust total supply every year
77         if(inflateCount == 10){
78             lastYearTotalSupply = tokenContract.totalSupply();
79         }
80         uint256 amount = SafeMath.div(SafeMath.mul(lastYearTotalSupply, getRate()), 10000);
81         require(amount > 0);
82         tokenContract.issue(amount);
83         lastBlockNumber = block.number;
84         inflateCount += 1;
85     }
86 }
87 
88 
89 interface tokenRecipient {
90     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
91 }
92 
93 contract QunQunToken {
94 
95     // Public variables of the token
96     string public name = 'QunQunCommunities';
97 
98     string public symbol = 'QUN';
99 
100     uint8 public decimals = 18;
101 
102     uint256 public totalSupply = 15 * 10 ** 26;
103 
104     address public issueContractAddress;
105     address public owner;
106 
107     // This creates an array with all balances
108     mapping (address => uint256) public balanceOf;
109 
110     mapping (address => mapping (address => uint256)) public allowance;
111 
112     // This generates a public event on the blockchain that will notify clients
113     event Transfer(address indexed from, address indexed to, uint256 value);
114     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
115     // This notifies clients about the amount burnt
116     event Burn(address indexed from, uint256 value);
117     event Issue(uint256 amount);
118 
119     /**
120      * Constrctor function
121      *
122      * Initializes contract with initial supply tokens to the creator of the contract
123      */
124     function QunQunToken() public {
125         owner = msg.sender;
126         balanceOf[owner] = totalSupply;
127         // create new issue contract
128         issueContractAddress = new QunQunTokenIssue(address(this));
129     }
130 
131     /**
132      * issue new token
133      *
134      * Initializes contract with initial supply tokens to the creator of the contract
135      */
136     function issue(uint256 amount) public {
137         require(msg.sender == issueContractAddress);
138         balanceOf[owner] = SafeMath.add(balanceOf[owner], amount);
139         totalSupply = SafeMath.add(totalSupply, amount);
140         Issue(amount);
141     }
142 
143     /**
144       * @dev Gets the balance of the specified address.
145       * @param _owner The address to query the the balance of.
146       * @return An uint256 representing the amount owned by the passed address.
147       */
148     function balanceOf(address _owner) public view returns (uint256 balance) {
149         return balanceOf[_owner];
150     }
151 
152     /**
153       * Internal transfer, only can be called by this contract
154       */
155     function _transfer(address _from, address _to, uint _value) internal {
156         // Prevent transfer to 0x0 address. Use burn() instead
157         require(_to != 0x0);
158         // Check if the sender has enough
159         require(balanceOf[_from] >= _value);
160         // Check for overflows
161         require(balanceOf[_to] + _value > balanceOf[_to]);
162         // Save this for an assertion in the future
163         uint previousBalances = balanceOf[_from] + balanceOf[_to];
164         // Subtract from the sender
165         balanceOf[_from] -= _value;
166         // Add the same to the recipient
167         balanceOf[_to] += _value;
168         Transfer(_from, _to, _value);
169         // Asserts are used to use static analysis to find bugs in your code. They should never fail
170         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
171     }
172 
173     /**
174      * Transfer tokens
175      *
176      * Send `_value` tokens to `_to` from your account
177      *
178      * @param _to The address of the recipient
179      * @param _value the amount to send
180      */
181     function transfer(address _to, uint256 _value) public returns (bool success){
182         _transfer(msg.sender, _to, _value);
183         return true;
184     }
185 
186     /**
187      * Transfer tokens from other address
188      *
189      * Send `_value` tokens to `_to` in behalf of `_from`
190      *
191      * @param _from The address of the sender
192      * @param _to The address of the recipient
193      * @param _value the amount to send
194      */
195     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
196         require(_value <= allowance[_from][msg.sender]);
197         // Check allowance
198         allowance[_from][msg.sender] -= _value;
199         _transfer(_from, _to, _value);
200         return true;
201     }
202 
203     /**
204      * Set allowance for other address
205      *
206      * Allows `_spender` to spend no more than `_value` tokens in your behalf
207      *
208      * @param _spender The address authorized to spend
209      * @param _value the max amount they can spend
210      */
211     function approve(address _spender, uint256 _value) public returns (bool success) {
212         require(_value <= balanceOf[msg.sender]);
213         allowance[msg.sender][_spender] = _value;
214         Approval(msg.sender, _spender, _value);
215         return true;
216     }
217 
218     /**
219      * Set allowance for other address and notify
220      *
221      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
222      *
223      * @param _spender The address authorized to spend
224      * @param _value the max amount they can spend
225      * @param _extraData some extra information to send to the approved contract
226      */
227     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
228         tokenRecipient spender = tokenRecipient(_spender);
229         if (approve(_spender, _value)) {
230             spender.receiveApproval(msg.sender, _value, this, _extraData);
231             return true;
232         }
233     }
234 
235     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
236         return allowance[_owner][_spender];
237     }
238 
239     /**
240      * Destroy tokens
241      *
242      * Remove `_value` tokens from the system irreversibly
243      *
244      * @param _value the amount of money to burn
245      */
246     function burn(uint256 _value) public returns (bool success) {
247         require(balanceOf[msg.sender] >= _value);
248         // Check if the sender has enough
249         balanceOf[msg.sender] -= _value;
250         // Subtract from the sender
251         totalSupply -= _value;
252         // Updates totalSupply
253         Burn(msg.sender, _value);
254         return true;
255     }
256 
257     /**
258      * Destroy tokens from other account
259      *
260      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
261      *
262      * @param _from the address of the sender
263      * @param _value the amount of money to burn
264      */
265     function burnFrom(address _from, uint256 _value) public returns (bool success) {
266         require(balanceOf[_from] >= _value);
267         // Check if the targeted balance is enough
268         require(_value <= allowance[_from][msg.sender]);
269         // Check allowance
270         balanceOf[_from] -= _value;
271         // Subtract from the targeted balance
272         allowance[_from][msg.sender] -= _value;
273         // Subtract from the sender's allowance
274         totalSupply -= _value;
275         // Update totalSupply
276         Burn(_from, _value);
277         return true;
278     }
279 
280 }