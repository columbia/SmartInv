1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 /**
38 * Abstract contract(interface) for the full ERC 20 Token standard
39 * see https://github.com/ethereum/EIPs/issues/20
40 * This is a simple fixed supply token contract.
41 */
42 contract ERC20 {
43 
44     /**
45     * Get the total token supply
46     */
47     function totalSupply() public view returns (uint256 supply);
48 
49     /**
50     * Get the account balance of an account with address _owner
51     */
52     function balanceOf(address _owner) public view returns (uint256 balance);
53 
54     /**
55     * Send _value amount of tokens to address _to
56     * Only the owner can call this function
57     */
58     function transfer(address _to, uint256 _value) public returns (bool success);
59 
60     /**
61     * Send _value amount of tokens from address _from to address _to
62     */
63     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
64 
65     /** Allow _spender to withdraw from your account, multiple times, up to the _value amount.
66     * If this function is called again it overwrites the current allowance with _value.
67     * this function is required for some DEX functionality
68     */
69     function approve(address _spender, uint256 _value) public returns (bool success);
70 
71     /**
72     * Returns the amount which _spender is still allowed to withdraw from _owner
73     */
74     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
75 
76     /**
77     * Triggered when tokens are transferred from one address to another
78     */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82     * Triggered whenever approve(address spender, uint256 value) is called.
83     */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 
88 /**
89 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
90 
91 This is a contract for a fixed supply coin.
92 */
93 contract DevCoin is ERC20 {
94   using SafeMath for uint256;
95 
96   // meta data
97   string public constant symbol = "DEV";
98 
99   string public constant version = '1.0';
100 
101   string public constant name = "DevCoin";
102 
103   uint256 public constant decimals = 18;
104 
105   uint256 constant TOTAL_SUPPLY = 100 * (10 ** 6) * 10 ** decimals; // 100 millions
106 
107   // Owner of this contract
108   address public owner;
109 
110   // Balances for each account
111   mapping(address => uint256) internal balances;
112 
113   // Owner of account approves the transfer of an amount to another account owner -> (recipient -> amount)
114   // This is used by exchanges. The owner effectively gives an exchange POA to transfer coins using
115   // the function transferFrom()
116   mapping(address => mapping(address => uint256)) internal allowed;
117 
118   /**
119   * Constructor
120   * the creator gets all the tokens initially
121   */
122   function DevCoin() public {
123     owner = msg.sender;
124     balances[owner] = TOTAL_SUPPLY;
125   }
126 
127   /**
128     * Get the total token supply
129     */
130   function totalSupply() public view returns (uint256 supply) {
131     supply = TOTAL_SUPPLY;
132   }
133 
134   /**
135     * Get the account balance of an account with address _owner
136     */
137   function balanceOf(address _owner) public view returns (uint256 balance) {
138     return balances[_owner];
139   }
140 
141   /**
142     * Send _value amount of tokens to address _to
143     * Only the owner can call this function
144     * No need to protect balances because only sender balance is accessed here
145     */
146   function transfer(address _to, uint256 _amount) public returns (bool success) {
147     require(_to != address(0));
148     require(_amount <= balances[msg.sender]);
149 
150     // SafeMath.sub will throw if there is not enough balance of if there is an overflow
151     balances[msg.sender] = balances[msg.sender].sub(_amount);
152     balances[_to] = balances[_to].add(_amount);
153 
154     // notify
155     Transfer(msg.sender, _to, _amount);
156     return true;
157   }
158 
159   /**
160     * Send _value amount of tokens from address _from to address _to
161     */
162   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
163     // protection against integer overflow
164     require(_to != address(0));
165     require(_amount <= balances[_from]);
166     require(_amount <= allowed[_from][msg.sender]);
167 
168     balances[_from] = balances[_from].sub(_amount);
169     balances[_to] = balances[_to].add(_amount);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
171 
172     // notify
173     Transfer(_from, _to, _amount);
174     return true;
175   }
176 
177   /** Allow _spender to withdraw from your account, multiple times, up to the _value amount.
178     * If this function is called again it overwrites the current allowance with _value.
179     * this function is required for some DEX functionality
180     */
181   function approve(address _spender, uint256 _value) public returns (bool success) {
182     // no need to check sender identity as he can only modify his own allowance
183     allowed[msg.sender][_spender] = _value;
184     // notify
185     Approval(msg.sender, _spender, _value);
186     return true;
187   }
188 
189   /**
190     * Returns the amount which _spender is still allowed to withdraw from _owner
191     */
192   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
193     return allowed[_owner][_spender];
194   }
195 
196 }