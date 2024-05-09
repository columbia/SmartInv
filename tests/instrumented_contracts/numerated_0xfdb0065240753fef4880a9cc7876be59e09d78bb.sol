1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Ownable {
34   address public owner;
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   constructor() public {
42     owner = msg.sender;
43   }
44   /**
45    * @dev Throws if called by any account other than the owner.
46    */
47   modifier onlyOwner() {
48     require(msg.sender == owner);
49     _;
50   }
51   /**
52    * @dev Allows the current owner to transfer control of the contract to a newOwner.
53    * @param newOwner The address to transfer ownership to.
54    */
55   function transferOwnership(address newOwner) public onlyOwner {
56     require(newOwner != address(0));
57     emit OwnershipTransferred(owner, newOwner);
58     owner = newOwner;
59   }
60 }
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20Interface {
67   string public name;
68   string public symbol;
69   uint8 public decimals;
70   uint256 public totalSupply;
71   function balanceOf(address who) public view returns (uint256);
72   function transfer(address to, uint256 value) public returns (bool);
73   event Transfer(address indexed from, address indexed to, uint256 value);
74   function allowance(address owner, address spender) public view returns (uint256);
75   function transferFrom(address from, address to, uint256 value) public returns (bool);
76   function approve(address spender, uint256 value) public returns (bool);
77   event Approval(address indexed owner, address indexed spender, uint256 value);
78   
79 }
80 
81 contract ApproveAndCallFallBack {
82   function receiveApproval(address from, uint256 value, address token, bytes data) public;
83 }
84 
85 contract ERC20Token is Ownable, ERC20Interface {
86   using SafeMath for uint256;
87 
88   mapping(address => uint256) internal balances;
89   mapping(address => mapping(address => uint256)) internal allowed;
90 
91   function balanceOf(address _owner) public view returns (uint256){
92     return balances[_owner];
93   }
94   function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
95     balances[_from] = balances[_from].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     emit Transfer(_from, _to, _value);
98     return true;
99   }
100   function transfer(address _to, uint256 _value) public returns (bool) {
101     return _transfer(msg.sender,_to,_value);
102   }
103 
104   function allowance(address _owner, address _spender) public view returns (uint256) {
105     return allowed[_owner][_spender];
106   }
107 
108   function approve(address _spender, uint256 _value) public returns (bool) {
109     allowed[msg.sender][_spender] = _value;
110     emit Approval(msg.sender, _spender, _value);
111     return true;
112   }
113 
114   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
115     require(msg.sender != _from);
116     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
117     return _transfer(_from, _to, _value);
118   }
119 
120   event Burn(address indexed from, uint256 value);
121 
122   function burnFrom(address _from, uint _value) public returns (bool) {
123     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
124     balances[_from] = balances[_from].sub(_value);
125     totalSupply = totalSupply.sub(_value);
126     emit Burn(_from, _value);
127     return true;
128   }
129   function approveAndCall(address _spender, uint _value, bytes data) public returns (bool) {
130     allowed[msg.sender][_spender] = _value;
131     emit Approval(msg.sender, _spender, _value);
132     ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _value, this, data);
133     return true;
134   }
135 }
136 
137 contract CryptoCow is ERC20Token{
138   using SafeMath for uint256;
139 
140   uint256 constant _190EC6 = 1642182;
141   uint256 constant _C8763 = 821091;
142   constructor(uint256 initialSupply) public payable{
143     totalSupply = initialSupply;
144     balances[0xbeef] = initialSupply;
145     name = "CryptoCow";
146     symbol = "COW";
147     decimals = 18;
148   }
149   function () public payable{
150   }
151 
152   event Award(address indexed awardee, uint256 amount);
153 
154   function award(address _awardee, uint256 _amount) public onlyOwner {
155     balances[_awardee] = balances[_awardee].add(_amount);
156     balances[0xbeef] = balances[0xbeef].add(_amount.div(10));
157     totalSupply = totalSupply.add(_amount.mul(11).div(10));
158     emit Award(_awardee, _amount);
159   }
160 
161   function selltoken(uint256 _amount) public {
162     uint256 tokenValue = calculateTokenSell(_amount);
163     _transfer(msg.sender, 0xbeef, _amount);
164     tokenValue = tokenValue.sub(tokenValue.div(40));
165     msg.sender.transfer(tokenValue);
166   }
167 
168   function buyToken() public payable {
169     uint256 tokenBought = calculateTokenBuy(msg.value, address(this).balance.sub(msg.value));
170     tokenBought = tokenBought.sub(tokenBought.div(40));
171     _transfer(0xbeef, msg.sender, tokenBought);
172   }
173   //magic formula from EtherShrimpFarm
174   function calculateTrade(uint256 rt, uint256 rs, uint256 bs) public pure returns (uint256) {
175     //(_190EC6*bs)/(_C8763+((_190EC6*rs+_C8763*rt)/rt));
176     return _190EC6.mul(bs).div(_C8763.add(_190EC6.mul(rs).add(_C8763.mul(rt)).div(rt)));
177   }
178   function calculateTokenSell(uint256 amount) public view returns (uint256) {
179     return calculateTrade(amount, balances[0xbeef], address(this).balance);
180   }
181   function calculateTokenBuy(uint256 eth, uint256 contractBalance) public view returns (uint256) {
182     return calculateTrade(eth, contractBalance, balances[0xbeef]);
183   }
184   function calculateTokenBuySimple(uint256 eth) public view returns (uint256) {
185     return calculateTokenBuy(eth, address(this).balance);
186   }
187   function getBalance() public view returns (uint256) {
188     return address(this).balance;
189   }
190   function poolTokenBalance() public view returns (uint256) {
191     return balances[0xbeef];
192   }
193   function transferAnyERC20Token(address tokenAddress, uint _value) public onlyOwner returns (bool success) {
194     return ERC20Interface(tokenAddress).transfer(owner, _value);
195   }
196 }