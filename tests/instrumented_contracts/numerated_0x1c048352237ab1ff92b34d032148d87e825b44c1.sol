1 /**
2   * Legenrich LeRT Bounty Payment Contract 
3   *
4   * More at https://legenrich.com
5   *
6   * Smart contract and pyament gateway developed by https://smart2be.com, 
7   * Premium ICO campaign managing company
8   *
9   **/
10 
11 pragma solidity ^0.4.19;
12 
13 contract owned {
14     address public owner;
15 
16     function owned() public {
17         owner = msg.sender;
18     }
19 
20     modifier onlyOwner {
21         require(msg.sender == owner);
22         _;
23     }
24 
25     function transferOwnership(address newOwner) onlyOwner public {
26         owner = newOwner;
27     }
28 }
29 
30 /**
31  * @title SafeMath
32  * @dev Math operations with safety checks that throw on error
33  */
34 library SafeMath {
35 
36   /**
37   * @dev Multiplies two numbers, throws on overflow.
38   */
39   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40     if (a == 0) {
41       return 0;
42     }
43     uint256 c = a * b;
44     assert(c / a == b);
45     return c;
46   }
47 
48   /**
49   * @dev Integer division of two numbers, truncating the quotient.
50   */
51   function div(uint256 a, uint256 b) internal pure returns (uint256) {
52     // assert(b > 0); // Solidity automatically throws when dividing by 0
53     uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55     return c;
56   }
57 
58   /**
59   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
60   */
61   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62     assert(b <= a);
63     return a - b;
64   }
65 
66   /**
67   * @dev Adds two numbers, throws on overflow.
68   */
69   function add(uint256 a, uint256 b) internal pure returns (uint256) {
70     uint256 c = a + b;
71     assert(c >= a);
72     return c;
73   }
74 }
75 contract Week {
76     function get(address from_) public returns (uint256);
77 }
78 
79 contract Token {
80   /// @return total amount of tokens
81   function totalSupply() public constant returns (uint256 supply);
82 
83   /// @param _owner The address from which the balance will be retrieved
84   /// @return The balance
85   function balanceOf(address _owner) public constant returns (uint256 balance);
86 
87   /// @notice send `_value` token to `_to` from `msg.sender`
88   /// @param _to The address of the recipient
89   /// @param _value The amount of token to be transferred
90   /// @return Whether the transfer was successful or not
91   function transfer(address _to, uint256 _value) public returns (bool success);
92 
93   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
94   /// @param _from The address of the sender
95   /// @param _to The address of the recipient
96   /// @param _value The amount of token to be transferred
97   /// @return Whether the transfer was successful or not
98   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
99 
100   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
101   /// @param _spender The address of the account able to transfer the tokens
102   /// @param _value The amount of wei to be approved for transfer
103   /// @return Whether the approval was successful or not
104   function approve(address _spender, uint256 _value) public returns (bool success);
105 
106   /// @param _owner The address of the account owning tokens
107   /// @param _spender The address of the account able to transfer the tokens
108   /// @return Amount of remaining tokens allowed to spent
109   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
110 
111   event Transfer(address indexed _from, address indexed _to, uint256 _value);
112   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
113 
114   uint public decimals;
115   string public name;
116 }
117 
118 contract StandardToken is Token {
119     using SafeMath for uint256;
120 
121   function transfer(address _to, uint256 _value) public returns (bool success) {
122     if (balances[msg.sender] >= _value && balances[_to].add(_value) > balances[_to]) {
123       balances[msg.sender] = balances[msg.sender].sub(_value);
124       balances[_to] = balances[_to].add(_value);
125       Transfer(msg.sender, _to, _value);
126       return true;
127     } else { return false; }
128   }
129 
130   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
131     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to].add(_value) > balances[_to]) {
132       balances[_to] = balances[_to].add(_value);
133       balances[_from] = balances[_from].sub(_value);
134       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
135       Transfer(_from, _to, _value);
136       return true;
137     } else { return false; }
138   }
139 
140   function balanceOf(address _owner) public constant returns (uint256 balance) {
141     return balances[_owner];
142   }
143 
144   function approve(address _spender, uint256 _value) public returns (bool success) {
145     allowed[msg.sender][_spender] = _value;
146     Approval(msg.sender, _spender, _value);
147     return true;
148   }
149 
150   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
151     return allowed[_owner][_spender];
152   }
153 
154   mapping(address => uint256) balances;
155 
156   mapping (address => mapping (address => uint256)) allowed;
157 
158   uint256 public totalSupply;
159 }
160 
161 
162 contract LeRT_Bounty is owned {
163 
164     using SafeMath for uint256;
165 
166     address public token;
167 
168     mapping (address => uint256) public sent; 
169     address[] internal extention;
170 
171     event Withdraw(address user, uint256 amount, uint256 balance);
172 
173     /**
174       * @notice Construct Bounty Payment Contract
175       *           
176       *
177       */
178 
179     function LeRT_Bounty() public {
180         token = 0x13646D839725a5E88555a694ac94696824a18332;  // ERC20 Contract address
181     }
182 
183     /**
184       * @notice All payments if appears go to owner
185       *           
186       */
187     function() payable public{
188         owner.transfer(msg.value); 
189     }
190     /**
191       * @notice Owner can change ERC20 contract address
192       *   
193       * @param token_ New ERC20 contract address
194       *        
195       */
196     function changeToken(address token_) onlyOwner public {
197         token = token_;
198     }
199 
200     /**
201       * @notice Add external ERC20 tokens balances
202       *
203       * @param ext_ Address of external balances
204       *           
205       */
206     function addExtension(address ext_) onlyOwner public {
207         extention.push(ext_);
208     }
209     
210     function withdraw(uint256 amount_) public {
211         uint256 tokens;
212         uint256 remain;
213         tokens = _balanceOf(msg.sender);
214         require(tokens.sub(sent[msg.sender]) >= amount_);
215         sent[msg.sender] = sent[msg.sender].add(amount_);
216         remain = tokens.sub(sent[msg.sender]);
217         require(Token(token).transfer(msg.sender, amount_));
218         Withdraw(msg.sender, amount_, remain);
219     }
220 
221     function balanceOf(address user_) public constant returns (uint256) {
222         require(extention.length > 0);
223         uint256 balance;
224         for (uint256 i = 0; i < extention.length; i++){
225             Week eachWeek = Week(extention[i]);
226             balance = balance.add(eachWeek.get(user_));
227         }
228         return (balance.sub(sent[user_]));
229     }
230 
231     function _balanceOf(address user_) internal constant returns (uint256) {
232         require(extention.length > 0);
233         uint256 balance;
234         for (uint256 i = 0; i < extention.length; i++){
235             Week eachWeek = Week(extention[i]);
236             balance = balance.add(eachWeek.get(user_));
237         }
238         return balance;
239     }
240 
241     function balanceTotal() public constant returns (uint256){
242         return Token(token).balanceOf(this);
243     }
244   
245 }