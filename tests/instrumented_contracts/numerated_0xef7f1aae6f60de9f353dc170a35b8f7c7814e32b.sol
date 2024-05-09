1 pragma solidity ^0.5.6;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     require(c / a == b);
11     return c;
12   }
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     require(b > 0);
15     uint256 c = a / b;
16     return c;
17   }
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     require(b <= a);
20     uint256 c = a - b;
21     return c;
22   }
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     require(c >= a && c >= b);
26     return c;
27   }
28   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
29     require(b != 0);
30     return a % b;
31   }
32   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
33     return a >= b ? a : b;
34   }
35   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
36     return a < b ? a : b;
37   }
38 
39 }
40 
41 
42 
43 
44 contract owned {
45   address public owner;
46 
47   constructor() public {
48     owner = msg.sender;
49   }
50 
51   modifier onlyOwner {
52     require(msg.sender == owner);
53     _;
54   }
55 
56   function transferOwnership(address newOwner) onlyOwner public {
57     owner = newOwner;
58   }
59 }
60 
61 interface tokenRecipient {
62   function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
63 }
64 
65 
66 contract TokenERC20 {
67   using SafeMath for uint256;
68   string public name;
69   string public symbol;
70   uint8 public decimals;
71   uint256 public totalSupply;
72 
73   mapping (address => uint256) public balanceOf;
74   mapping (address => mapping (address => uint256)) public allowance;
75 
76   event Transfer(address indexed from, address indexed to, uint256 value);
77 
78   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
79 
80   event Burn(address indexed from, uint256 value);
81 
82 
83   constructor(string memory tokenName, string memory tokenSymbol, uint8 dec) public {
84     decimals = dec;
85     name = tokenName;                                   // Set the name for display purposes
86     symbol = tokenSymbol;   
87   }
88 
89   function _transfer(address _from, address _to, uint _value) internal {
90     require(_to != address(0x0));
91     balanceOf[_from] = balanceOf[_from].sub(_value);
92     balanceOf[_to] = balanceOf[_to].add(_value);
93     emit Transfer(_from, _to, _value);
94   }
95 
96   function transfer(address _to, uint256 _value) public returns (bool success) {
97     _transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101 
102   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
103     allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
104 		_transfer(_from, _to, _value);
105 		return true;
106   }
107 
108 
109   function approve(address _spender, uint256 _value) public returns (bool success) {
110     allowance[msg.sender][_spender] = _value;
111     emit Approval(msg.sender, _spender, _value);
112     return true;
113   }
114 
115 
116   function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
117     tokenRecipient spender = tokenRecipient(_spender);
118     if (approve(_spender, _value)) {
119       spender.receiveApproval(msg.sender, _value, address(this), _extraData);
120       return true;
121     }
122   }
123 
124 }
125 
126 
127 /******************************************/
128 /*       ADVANCED TOKEN STARTS HERE       */
129 /******************************************/
130 
131 contract AZT is owned, TokenERC20  {
132 
133 	string _tokenName = "AZ FundChain";  
134 	string _tokenSymbol = "AZT";
135   uint8 _decimals = 18;
136 
137   address[] public frozenAddresses;
138   bool public tokenFrozen;
139 
140   struct frozenWallet {
141     bool isFrozen; //true or false
142     uint256 rewardedAmount; //amount
143     uint256 frozenAmount; //amount
144     uint256 frozenTime; // in days
145   }
146 
147   mapping (address => frozenWallet) public frozenWallets;
148 
149 
150 
151   constructor() TokenERC20(_tokenName, _tokenSymbol, _decimals) public {
152 
153     /*Wallet A */
154     frozenAddresses.push(address(0x9fd50776F133751E8Ae6abE1Be124638Bb917E05));
155     frozenWallets[frozenAddresses[0]] = frozenWallet({
156       isFrozen: true,
157       rewardedAmount: 30000000 * 10 ** uint256(decimals),
158       frozenAmount: 0 * 10 ** uint256(decimals),
159       frozenTime: now + 1 * 1 hours //seconds, minutes, hours, days
160     });
161 
162     for (uint256 i = 0; i < frozenAddresses.length; i++) {
163       balanceOf[frozenAddresses[i]] = frozenWallets[frozenAddresses[i]].rewardedAmount;
164       totalSupply = totalSupply.add(frozenWallets[frozenAddresses[i]].rewardedAmount);
165     }
166   }
167 
168   function _transfer(address _from, address _to, uint _value) internal {
169     require(_to != address(0x0));
170     require(checkFrozenWallet(_from, _value));
171     balanceOf[_from] = balanceOf[_from].sub(_value);      
172     balanceOf[_to] = balanceOf[_to].add(_value);     
173     emit Transfer(_from, _to, _value);
174   }
175 
176   function checkFrozenWallet(address _from, uint _value) public view returns (bool) {
177     return(
178       _from==owner || 
179       (!tokenFrozen && 
180       (!frozenWallets[_from].isFrozen || 
181        now>=frozenWallets[_from].frozenTime || 
182        balanceOf[_from].sub(_value)>=frozenWallets[_from].frozenAmount))
183     );
184   }
185 
186 
187   function burn(uint256 _value) onlyOwner public returns (bool success) {
188     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);   // Subtract from the sender
189     totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
190     emit Burn(msg.sender, _value);
191     return true;
192   }
193 
194   function burnFrom(address _from, uint256 _value) public returns (bool success) {
195     balanceOf[_from] = balanceOf[_from].sub(_value);                          // Subtract from the targeted balance
196     allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);   // Subtract from the sender's allowance
197     totalSupply = totalSupply.sub(_value);                              // Update totalSupply
198     emit Burn(_from, _value);
199     return true;
200   }
201 
202   function freezeToken(bool freeze) onlyOwner public {
203     tokenFrozen = freeze;
204   }
205 }