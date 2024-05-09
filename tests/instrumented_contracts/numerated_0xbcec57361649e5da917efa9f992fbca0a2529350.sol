1 pragma solidity ^0.4.11;
2 
3 /**
4  * ERC20 interface
5  * see https://github.com/ethereum/EIPs/issues/20
6  * and https://theethereum.wiki/w/index.php/ERC20_Token_Standard
7  */
8 contract ERC20 {
9 
10     // Get the total token supply.
11     function totalSupply() public constant returns (uint256);
12 
13     // Get the account balance of another account with address _owner.
14     function balanceOf(address _owner) public constant returns (uint256);
15 
16     // Send _value amount of tokens to address _to.
17     function transfer(address _to, uint256 _value) public returns (bool);
18 
19     /* Send _value amount of tokens from address _from to address _to.
20      * The transferFrom method is used for a withdraw workflow, allowing contracts to send tokens on your behalf,
21      * for example to "deposit" to a contract address and/or to charge fees in sub-currencies; the command should
22      * fail unless the _from account has deliberately authorized the sender of the message via the approve mechanism. */
23     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
24 
25     /* Allow _spender to withdraw from your account, multiple times, up to the _value amount.
26      * If this function is called again it overwrites the current allowance with _value. */
27     function approve(address _spender, uint256 _value) public returns (bool);
28 
29     // Returns the amount which _spender is still allowed to withdraw from _owner.
30     function allowance(address _owner, address _spender) public constant returns (uint256);
31 
32     // Event triggered when tokens are transferred.
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34 
35     // Event triggered whenever approve(address _spender, uint256 _value) is called.
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 
38 }
39 
40 /**
41  * Math operations with safety checks
42  */
43 contract SafeMath {
44 
45     function safeMul(uint a, uint b) internal pure returns (uint) {
46         uint c = a * b;
47         require(a == 0 || c / a == b);
48         return c;
49     }
50 
51     function safeDiv(uint a, uint b) internal pure returns (uint) {
52         require(b > 0);
53         uint c = a / b;
54         require(a == b * c + a % b);
55         return c;
56     }
57 
58     function safeSub(uint a, uint b) internal pure returns (uint) {
59         require(b <= a);
60         return a - b;
61     }
62 
63     function safeAdd(uint a, uint b) internal pure returns (uint) {
64         uint c = a + b;
65         require(c >= a && c >= b);
66         return c;
67     }
68 
69     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
70         return a >= b ? a : b;
71     }
72 
73     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
74         return a < b ? a : b;
75     }
76 
77     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
78         return a >= b ? a : b;
79     }
80 
81     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
82         return a < b ? a : b;
83     }
84 }
85 
86 /**
87  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
88  *
89  * Based on code by FirstBlood:
90  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
91  */
92 contract StandardToken is ERC20, SafeMath {
93 
94     uint256 internal globalSupply;
95 
96     /* Actual balances of token holders */
97     mapping (address => uint256) internal balanceMap;
98     mapping (address => mapping (address => uint256)) internal allowanceMap;
99 
100     /* Interface declaration */
101     function isToken() public pure returns (bool) {
102         return true;
103     }
104 
105     function transfer(address _to, uint256 _value) public returns (bool) {
106         require (_to != 0x0);                                           // Prevent transfer to 0x0 address. Use burn() instead
107         require (balanceMap[msg.sender] >= _value);                      // Check if the sender has enough
108         require (balanceMap[_to] + _value >= balanceMap[_to]);            // Check for overflows
109         balanceMap[msg.sender] = safeSub(balanceMap[msg.sender], _value); // Subtract from the sender
110         balanceMap[_to] = safeAdd(balanceMap[_to], _value);               // Add the same to the recipient
111         Transfer(msg.sender, _to, _value);                              // Notify anyone listening that this transfer took place
112         return true;
113     }
114 
115     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
116         require (_to != 0x0);                                           // Prevent transfer to 0x0 address. Use burn() instead
117         require (balanceMap[_from] >= _value);                           // Check if the sender has enough
118         require (balanceMap[_to] + _value >= balanceMap[_to]);            // Check for overflows
119         require (_value <= allowanceMap[_from][msg.sender]);               // Check allowance
120         balanceMap[_from] = safeSub(balanceMap[_from], _value);           // Subtract from the sender
121         balanceMap[_to] = safeAdd(balanceMap[_to], _value);               // Add the same to the recipient
122 
123         uint256 _allowance = allowanceMap[_from][msg.sender];
124         allowanceMap[_from][msg.sender] = safeSub(_allowance, _value);
125         Transfer(_from, _to, _value);
126         return true;
127     }
128 
129     function totalSupply() public constant returns (uint256) {
130         return globalSupply;
131     }
132 
133     function balanceOf(address _owner) public constant returns (uint256) {
134         return balanceMap[_owner];
135     }
136 
137     /* Allow another contract to spend some tokens on your behalf.
138      * To change the approve amount you first have to reduce the addresses allowance to zero by calling
139      * approve(_spender, 0) if it is not already 0 to mitigate the race condition described here:
140      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 */
141     function approve(address _spender, uint _value) public returns (bool) {
142         require ((_value == 0) || (allowanceMap[msg.sender][_spender] == 0));
143         allowanceMap[msg.sender][_spender] = _value;
144         Approval(msg.sender, _spender, _value);
145         return true;
146     }
147 
148     function allowance(address _owner, address _spender) public constant returns (uint) {
149         return allowanceMap[_owner][_spender];
150     }
151 }
152 
153 contract Owned {
154 
155     address internal owner;
156 
157     function Owned() public {
158         owner = msg.sender;
159     }
160 
161     modifier onlyOwner {
162         require (msg.sender == owner);
163         _;
164     }
165 
166     function transferOwnership(address newOwner) external onlyOwner {
167         owner = newOwner;
168     }
169 
170     function getOwner() public constant returns (address currentOwner) {
171         return owner;
172     }
173 }
174 
175 contract AlsToken is StandardToken, Owned {
176 
177     string public constant name = "CryptoAlias";
178     string public constant symbol = "ALS";
179     uint8 public constant decimals = 18;        // Same as ETH
180 
181     address public icoAddress;
182 
183     // ICO end time in seconds since epoch.
184     // Equivalent to Tuesday, February 20th 2018, 3 pm London time.
185     uint256 public constant icoEndTime = 1519138800;
186 
187     // 1 million ALS with 18 decimals [10 to the power of (6 + 18) tokens].
188     uint256 private constant oneMillionAls = uint256(10) ** (6 + decimals);
189 
190     bool private icoTokensWereBurned = false;
191     bool private teamTokensWereAllocated = false;
192 
193     /* Initializes the initial supply of ALS to 80 million.
194      * For more details about the token's supply and allocation see https://github.com/CryptoAlias/ALS */
195     function AlsToken() public {
196         globalSupply = 80 * oneMillionAls;
197     }
198 
199     modifier onlyAfterIco() {
200         require(now >= icoEndTime);
201         _;
202     }
203 
204     /* Sets the ICO address and allocates it 80 million tokens.
205      * Can be invoked only by the owner.
206      * Can be called only once. Once set, the ICO address can not be changed. Any subsequent calls to this method will be ignored. */
207     function setIcoAddress(address _icoAddress) external onlyOwner {
208         require (icoAddress == address(0x0));
209 
210         icoAddress = _icoAddress;
211         balanceMap[icoAddress] = 80 * oneMillionAls;
212 
213         IcoAddressSet(icoAddress);
214     }
215 
216     // Burns the tokens that were not sold during the ICO. Can be invoked only after the ICO ends.
217     function burnIcoTokens() external onlyAfterIco {
218         require (!icoTokensWereBurned);
219         icoTokensWereBurned = true;
220 
221         uint256 tokensToBurn = balanceMap[icoAddress];
222         if (tokensToBurn > 0)
223         {
224             balanceMap[icoAddress] = 0;
225             globalSupply = safeSub(globalSupply, tokensToBurn);
226         }
227 
228         Burned(icoAddress, tokensToBurn);
229     }
230 
231     function allocateTeamAndPartnerTokens(address _teamAddress, address _partnersAddress) external onlyOwner {
232         require (icoTokensWereBurned);
233         require (!teamTokensWereAllocated);
234 
235         uint256 oneTenth = safeDiv(globalSupply, 8);
236 
237         balanceMap[_teamAddress] = oneTenth;
238         globalSupply = safeAdd(globalSupply, oneTenth);
239 
240         balanceMap[_partnersAddress] = oneTenth;
241         globalSupply = safeAdd(globalSupply, oneTenth);
242 
243         teamTokensWereAllocated = true;
244 
245         TeamAndPartnerTokensAllocated(_teamAddress, _partnersAddress);
246     }
247 
248     // Event triggered when the ICO address was set.
249     event IcoAddressSet(address _icoAddress);
250 
251     // Event triggered when pre-ICO or ICO tokens were burned.
252     event Burned(address _address, uint256 _amount);
253 
254     // Event triggered when team and partner tokens were allocated.
255     event TeamAndPartnerTokensAllocated(address _teamAddress, address _partnersAddress);
256 }