1 pragma solidity ^0.4.16;
2 
3 
4 
5 
6 contract ERC20 {
7     uint256 public totalSupply;
8     function balanceOf(address who) constant returns (uint256);
9 
10     function transfer(address to, uint256 value) returns (bool);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12 
13     function allowance(address owner, address spender) constant returns (uint256);
14     function transferFrom(address from, address to, uint256 value) returns (bool);
15 
16     function approve(address spender, uint256 value) returns (bool);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 library SafeMath {
21   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
22       uint256 c = a * b;
23       assert(a == 0 || c / a == b);
24       return c;
25     }
26 
27   function div(uint256 a, uint256 b) internal constant returns (uint256) {
28       // assert(b > 0); // Solidity automatically throws when dividing by 0
29       uint256 c = a / b;
30       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31       return c;
32     }
33 
34   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
35       assert(b <= a);
36       return a - b;
37     }
38 
39   function add(uint256 a, uint256 b) internal constant returns (uint256) {
40       uint256 c = a + b;
41       assert(c >= a);
42       return c;
43     }
44 }
45 
46 contract StandardToken is ERC20 {
47     using SafeMath for uint256;
48     mapping(address => uint256) balances;
49     mapping (address => mapping (address => uint256)) allowed;
50 
51   /**
52   * @dev transfer token for a specified address
53   * @param _to The address to transfer to.
54   * @param _value The amount to be transferred.
55   */
56   function transfer(address _to, uint256 _value) returns (bool) {
57       balances[msg.sender] = balances[msg.sender].sub(_value);
58       balances[_to] = balances[_to].add(_value);
59       Transfer(msg.sender, _to, _value);
60       return true;
61     }
62 
63   function balanceOf(address _owner) constant returns (uint256 balance) {
64       return balances[_owner];
65     }
66   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
67       var _allowance = allowed[_from][msg.sender];
68 
69       // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
70       // require (_value <= _allowance);
71 
72       balances[_to] = balances[_to].add(_value);
73       balances[_from] = balances[_from].sub(_value);
74       allowed[_from][msg.sender] = _allowance.sub(_value);
75       Transfer(_from, _to, _value);
76       return true;
77     }
78 
79   function approve(address _spender, uint256 _value) returns (bool) {
80 
81       // To change the approve amount you first have to reduce the addresses`
82       //  allowance to zero by calling `approve(_spender, 0)` if it is not
83       //  already 0 to mitigate the race condition described here:
84       //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
85       require((_value == 0) || (allowed[msg.sender][_spender] == 0));
86 
87       allowed[msg.sender][_spender] = _value;
88       Approval(msg.sender, _spender, _value);
89       return true;
90     }
91 
92   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
93       return allowed[_owner][_spender];
94     }
95 
96 
97 
98 }
99 
100 contract Ownable {
101   address public owner;
102 
103 
104   /**
105    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
106    * account.
107    */
108   function Ownable() {
109       owner = msg.sender;
110     }
111 
112 
113   /**
114    * @dev Throws if called by any account other than the owner.
115    */
116   modifier onlyOwner() {
117       require(msg.sender == owner);
118       _;
119     }
120 
121 
122   /**
123    * @dev Allows the current owner to transfer control of the contract to a newOwner.
124    * @param newOwner The address to transfer ownership to.
125    */
126   function transferOwnership(address newOwner) onlyOwner {
127       require(newOwner != address(0));
128       owner = newOwner;
129     }
130 
131 }
132 
133 
134 contract Token is StandardToken, Ownable {
135     using SafeMath for uint256;
136 
137   // start and end block where investments are allowed (both inclusive)
138     uint256 public startBlock;
139     uint256 public endBlock;
140   // address where funds are collected
141     address public wallet;
142 
143   // how many token units a buyer gets per wei
144     uint256 public tokensPerEther;
145 
146   // amount of raised money in wei
147     uint256 public weiRaised;
148 
149     uint256 public cap;
150     uint256 public issuedTokens;
151     string public name = "Realestateco.in";
152     string public symbol = "REAL";
153     uint public decimals = 4;
154     uint public INITIAL_SUPPLY = 80000000000000;
155     uint factor;
156     bool internal isCrowdSaleRunning;
157     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
158 
159 
160     function Token() {
161 
162         wallet = address(0x879bf61F63a8C58D802EC612Aa8E868882E532c6);
163         tokensPerEther = 331;
164         endBlock = block.number + 400000;
165 
166         totalSupply = INITIAL_SUPPLY;
167         balances[msg.sender] = INITIAL_SUPPLY;
168         startBlock = block.number;
169         cap = INITIAL_SUPPLY;
170         issuedTokens = 0;
171         factor = 10**14;
172         isCrowdSaleRunning = true;
173         }
174 
175     // crowdsale entrypoint
176     // fallback function can be used to buy tokens
177 
178   function () payable {
179       buyTokens(msg.sender);
180     }
181 
182   function stopCrowdSale() onlyOwner {
183     isCrowdSaleRunning = false;
184   }
185 
186   // low level token purchase function
187   function buyTokens(address beneficiary) payable {
188       require(beneficiary != 0x0);
189       require(validPurchase());
190 
191       uint256 weiAmount = msg.value;
192       // calculate token amount to be created
193       uint256 tokens = weiAmount.mul(tokensPerEther).div(factor);
194 
195 
196       // check if the tokens are more than the cap
197       require(issuedTokens.add(tokens) <= cap);
198       // update state
199       weiRaised = weiRaised.add(weiAmount);
200       issuedTokens = issuedTokens.add(tokens);
201 
202       forwardFunds();
203       // transfer the token
204       issueToken(beneficiary,tokens);
205       TokenPurchase(msg.sender, beneficiary, msg.value, tokens);
206 
207     }
208 
209   // can be issued to anyone without owners concent but as this method is internal only buyToken is calling it.
210   function issueToken(address beneficiary, uint256 tokens) internal {
211 
212       balances[owner] = balances[owner].sub(tokens);
213       balances[beneficiary] = balances[beneficiary].add(tokens);
214     }
215 
216   // send ether to the fund collection wallet
217   // override to create custom fund forwarding mechanisms
218   function forwardFunds() internal {
219       // to normalize the input
220       wallet.transfer(msg.value);
221 
222     }
223 
224   // @return true if the transaction can buy tokens
225   function validPurchase() internal constant returns (bool) {
226       uint256 current = block.number;
227       bool withinPeriod = current >= startBlock && current <= endBlock;
228       bool nonZeroPurchase = msg.value != 0;
229       return withinPeriod && nonZeroPurchase && isCrowdSaleRunning;
230     }
231 
232   // @return true if crowdsale event has ended
233   function hasEnded() public constant returns (bool) {
234       return (block.number > endBlock) && isCrowdSaleRunning;
235     }
236 
237 }