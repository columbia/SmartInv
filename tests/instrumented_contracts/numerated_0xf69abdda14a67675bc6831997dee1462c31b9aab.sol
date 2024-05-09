1 pragma solidity ^0.4.21;
2 
3 interface ERC223ReceivingContract { 
4     function tokenFallback(address _from, uint _value, bytes _data) external;
5 }
6 
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
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 contract Ownable {
37     address public owner;
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40     /**
41     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
42     * account.
43     */
44     function Ownable() public {
45         owner = msg.sender;
46     }
47 
48     /**
49     * @dev Throws if called by any account other than the owner.
50     */
51     modifier onlyOwner() {
52         require(owner == msg.sender);
53         _;
54     }
55 
56     /**
57     * @dev Allows the current owner to transfer control of the contract to a newOwner.
58     * @param newOwner The address to transfer ownership to.
59     */
60     function transferOwnership(address newOwner) public onlyOwner {
61         require(newOwner != address(0));
62         emit OwnershipTransferred(owner, newOwner);
63         owner = newOwner;
64     }
65 }
66 
67 contract AlphaToken is Ownable {
68     using SafeMath for uint256;
69     event Transfer(address indexed from, address indexed to, uint tokens);
70     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
71 
72     mapping(address => uint) balances; // List of user balances.
73     mapping(address => mapping (address => uint256)) allowed;
74 
75     string _name;
76     string _symbol;
77     uint8 DECIMALS = 18;
78     // 18 decimals is the strongly suggested default, avoid changing it
79     uint256 _totalSupply;
80     uint256 _saledTotal = 0;
81     uint256 _amounToSale = 0;
82     uint _buyPrice = 4500;
83     uint256 _totalEther = 0;
84 
85     function AlphaToken(
86         string tokenName,
87         string tokenSymbol
88     ) public 
89     {
90         _totalSupply = 4000000000 * 10 ** uint256(DECIMALS);  // 实际供应总量
91         _amounToSale = _totalSupply;
92         _saledTotal = 0;
93         _name = tokenName;                                       // 设置Token名字
94         _symbol = tokenSymbol;                                   // 设置Token符号
95         owner = msg.sender;
96     }
97 
98     function name() public constant returns (string) {
99         return _name;
100     }
101 
102     function symbol() public constant returns (string) {
103         return _symbol;
104     }
105 
106     function totalSupply() public constant returns (uint256) {
107         return _totalSupply;
108     }
109 
110     function buyPrice() public constant returns (uint256) {
111         return _buyPrice;
112     }
113     
114     function decimals() public constant returns (uint8) {
115         return DECIMALS;
116     }
117 
118     function _transfer(address _from, address _to, uint _value, bytes _data) internal {
119         uint codeLength;
120         require (_to != 0x0);
121         require(balances[_from]>=_value);
122         balances[_from] = balances[_from].sub(_value);
123         balances[_to] = balances[_to].add(_value);
124         if (codeLength>0) {
125             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
126             receiver.tokenFallback(msg.sender, _value, _data);
127         }
128         emit Transfer(_from, _to, _value);
129     }
130 
131     /**
132      * @dev Transfer the specified amount of tokens to the specified address.
133      *      Invokes the `tokenFallback` function if the recipient is a contract.
134      *      The token transfer fails if the recipient is a contract
135      *      but does not implement the `tokenFallback` function
136      *      or the fallback function to receive funds.
137      *
138      * @param _to    Receiver address.
139      * @param _value Amount of tokens that will be transferred.
140      * @param _data  Transaction metadata.
141      */
142     function transfer(address _to, uint _value, bytes _data) public returns (bool ok) {
143         // Standard function transfer similar to ERC20 transfer with no _data .
144         // Added due to backwards compatibility reasons .
145         _transfer(msg.sender, _to, _value, _data);
146         return true;
147     }
148     
149     /**
150      * @dev Transfer the specified amount of tokens to the specified address.
151      *      This function works the same with the previous one
152      *      but doesn't contain `_data` param.
153      *      Added due to backwards compatibility reasons.
154      *
155      * @param _to    Receiver address.
156      * @param _value Amount of tokens that will be transferred.
157      */
158     function transfer(address _to, uint _value) public returns(bool ok) {
159         bytes memory empty;
160         _transfer(msg.sender, _to, _value, empty);
161         return true;
162     }
163 
164     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
165         return allowed[tokenOwner][spender];
166     }
167 
168     function approve(address spender, uint tokens) public returns (bool success) {
169         require(balances[msg.sender]>=tokens);
170         allowed[msg.sender][spender] = tokens;
171         emit Approval(msg.sender, spender, tokens);
172         return true;
173     }
174     
175     function transferFrom(address _from, address _to, uint _value) onlyOwner public returns (bool success) {
176         require(_value <= allowed[_from][msg.sender]);
177         bytes memory empty;
178         _transfer(_from, _to, _value, empty);
179         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
180         return true;
181     }
182     
183     /**
184      * @dev Returns balance of the `_owner`.
185      *
186      * @param _owner   The address whose balance will be returned.
187      * @return balance Balance of the `_owner`.
188      */
189     function balanceOf(address _owner) public constant returns (uint balance) {
190         return balances[_owner];
191     }
192 
193     function setPrices(uint256 newBuyPrice) onlyOwner public {
194         _buyPrice = newBuyPrice;
195     }
196 
197     /// @notice Buy tokens from contract by sending ether
198     function buyCoin() payable public returns (bool ok) {
199         uint amount = ((msg.value * _buyPrice) * 10 ** uint256(DECIMALS))/1000000000000000000;               // calculates the amount
200         require ((_amounToSale - _saledTotal)>=amount);
201         balances[msg.sender] = balances[msg.sender].add(amount);
202         _saledTotal = _saledTotal.add(amount);
203         _totalEther += msg.value;
204         return true;
205     }
206 
207     function dispatchTo(address target, uint256 amount) onlyOwner public returns (bool ok) {
208         require ((_amounToSale - _saledTotal)>=amount);
209         balances[target] = balances[target].add(amount);
210         _saledTotal = _saledTotal.add(amount);
211         return true;
212     }
213 
214     function withdrawTo(address _target, uint256 _value) onlyOwner public returns (bool ok) {
215         require(_totalEther <= _value);
216         _totalEther -= _value;
217         _target.transfer(_value);
218         return true;
219     }
220     
221     function () payable public {
222     }
223 
224 }