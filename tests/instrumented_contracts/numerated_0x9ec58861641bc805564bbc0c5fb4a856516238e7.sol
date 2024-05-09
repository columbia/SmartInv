1 // Appics token smart contract.
2 // Developed by Phenom.Team <info@phenom.team>
3 
4 pragma solidity ^ 0.4.15;
5 
6 /**
7  *   @title SafeMath
8  *   @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12         uint256 c = a * b;
13         assert(a == 0 || c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal constant returns(uint256) {
18         assert(b > 0);
19         uint256 c = a / b;
20         assert(a == b * c + a % b);
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal constant returns(uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal constant returns(uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 
37 /**
38  *   @title ERC20
39  *   @dev Standart ERC20 token interface
40  */
41 contract ERC20 {
42     uint256 public totalSupply = 0;
43     mapping(address => uint256) balances;
44     mapping(address => mapping(address => uint256)) allowed;
45     function balanceOf(address _owner) public constant returns(uint256);
46     function transfer(address _to, uint256 _value) public returns(bool);
47     function transferFrom(address _from, address _to, uint256 _value) public returns(bool);
48     function approve(address _spender, uint256 _value) public returns(bool);
49     function allowance(address _owner, address _spender) public constant returns(uint256);
50     event Transfer(address indexed _from, address indexed _to, uint256 _value);
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52 }
53 
54 
55 /**
56  *   @title 
57  *   @dev Appics token contract
58  */
59 contract AppicsToken is ERC20 {
60     using SafeMath for uint256;
61     string public name = "Appics";
62     string public symbol = "XAP";
63     uint256 public decimals = 18;
64 
65     // Ico contract address
66     address public ico;
67     event Burn(address indexed from, uint256 value);
68 
69     // Disables/enables token transfers
70     bool public tokensAreFrozen = true;
71 
72     // Allows execution by the ico only
73     modifier icoOnly {
74         require(msg.sender == ico);
75         _;
76     }
77 
78    /**
79     *   @dev Contract constructor function sets Ico address
80     *   @param _ico          ico address
81     */
82     function AppicsToken(address _ico) public {
83         ico = _ico;
84     }
85 
86    /**
87     *   @dev Mint tokens
88     *   @param _holder       beneficiary address the tokens will be issued to
89     *   @param _value        number of tokens to issue
90     */
91     function mintTokens(address _holder, uint256 _value) external icoOnly {
92         require(_value > 0);
93         balances[_holder] = balances[_holder].add(_value);
94         totalSupply = totalSupply.add(_value);
95         Transfer(0x0, _holder, _value);
96     }
97 
98    /**
99     *   @dev Enables token transfers
100     */
101     function defrostTokens() external icoOnly {
102       tokensAreFrozen = false;
103     }
104 
105     /**
106     *   @dev Disables token transfers
107     */
108     function frostTokens() external icoOnly {
109       tokensAreFrozen = true;
110     }
111 
112    /**
113     *   @dev Burn Tokens
114     *   @param _investor     token holder address which the tokens will be burnt
115     *   @param _value        number of tokens to burn
116     */
117     function burnTokens(address _investor, uint256 _value) external icoOnly {
118         require(balances[_investor] > 0);
119         totalSupply = totalSupply.sub(_value);
120         balances[_investor] = balances[_investor].sub(_value);
121         Burn(_investor, _value);
122     }
123 
124    /**
125     *   @dev Get balance of investor
126     *   @param _owner        investor's address
127     *   @return              balance of investor
128     */
129     function balanceOf(address _owner) public constant returns(uint256) {
130       return balances[_owner];
131     }
132 
133    /**
134     *   @dev Send coins
135     *   throws on any error rather then return a false flag to minimize
136     *   user errors
137     *   @param _to           target address
138     *   @param _amount       transfer amount
139     *
140     *   @return true if the transfer was successful
141     */
142     function transfer(address _to, uint256 _amount) public returns(bool) {
143         require(!tokensAreFrozen);
144         balances[msg.sender] = balances[msg.sender].sub(_amount);
145         balances[_to] = balances[_to].add(_amount);
146         Transfer(msg.sender, _to, _amount);
147         return true;
148     }
149 
150    /**
151     *   @dev An account/contract attempts to get the coins
152     *   throws on any error rather then return a false flag to minimize user errors
153     *
154     *   @param _from         source address
155     *   @param _to           target address
156     *   @param _amount       transfer amount
157     *
158     *   @return true if the transfer was successful
159     */
160     function transferFrom(address _from, address _to, uint256 _amount) public returns(bool) {
161         require(!tokensAreFrozen);
162         balances[_from] = balances[_from].sub(_amount);
163         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
164         balances[_to] = balances[_to].add(_amount);
165         Transfer(_from, _to, _amount);
166         return true;
167     }
168 
169    /**
170     *   @dev Allows another account/contract to spend some tokens on its behalf
171     *   throws on any error rather then return a false flag to minimize user errors
172     *
173     *   also, to minimize the risk of the approve/transferFrom attack vector
174     *   approve has to be called twice in 2 separate transactions - once to
175     *   change the allowance to 0 and secondly to change it to the new allowance
176     *   value
177     *
178     *   @param _spender      approved address
179     *   @param _amount       allowance amount
180     *
181     *   @return true if the approval was successful
182     */
183     function approve(address _spender, uint256 _amount) public returns(bool) {
184         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
185         allowed[msg.sender][_spender] = _amount;
186         Approval(msg.sender, _spender, _amount);
187         return true;
188     }
189 
190    /**
191     *   @dev Function to check the amount of tokens that an owner allowed to a spender.
192     *
193     *   @param _owner        the address which owns the funds
194     *   @param _spender      the address which will spend the funds
195     *
196     *   @return              the amount of tokens still avaible for the spender
197     */
198     function allowance(address _owner, address _spender) public constant returns(uint256) {
199         return allowed[_owner][_spender];
200     }
201 }