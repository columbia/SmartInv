1 pragma solidity ^0.5.6;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     require(c / a == b);
10     return c;
11   }
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     require(b > 0);
14     uint256 c = a / b;
15     return c;
16   }
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     require(b <= a);
19     uint256 c = a - b;
20     return c;
21   }
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     require(c >= a && c >= b);
25     return c;
26   }
27   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
28     require(b != 0);
29     return a % b;
30   }
31   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
32     return a >= b ? a : b;
33   }
34   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
35     return a < b ? a : b;
36   }
37 
38 }
39 
40 contract owned {
41   address public owner;
42 
43   constructor() public {
44     owner = msg.sender;
45   }
46 
47   modifier onlyOwner {
48     require(msg.sender == owner);
49     _;
50   }
51 
52   function transferOwnership(address newOwner) onlyOwner public {
53     owner = newOwner;
54   }
55 }
56 
57 interface tokenRecipient {
58   function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
59 }
60 
61 
62 contract TokenERC20 {
63   using SafeMath for uint256;
64   string public name;
65   string public symbol;
66   uint8 public decimals;
67   uint256 public totalSupply;
68 
69   mapping (address => uint256) public balanceOf;
70   mapping (address => mapping (address => uint256)) public allowance;
71 
72   event Transfer(address indexed from, address indexed to, uint256 value);
73 
74   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
75 
76   event Burn(address indexed from, uint256 value);
77 
78 
79   constructor(string memory tokenName, string memory tokenSymbol, uint8 dec) public {
80     decimals = dec;
81     name = tokenName;                                   // Set the name for display purposes
82     symbol = tokenSymbol;   
83   }
84 
85   function _transfer(address _from, address _to, uint _value) internal {
86     require(_to != address(0x0));
87     balanceOf[_from] = balanceOf[_from].sub(_value);
88     balanceOf[_to] = balanceOf[_to].add(_value);
89     emit Transfer(_from, _to, _value);
90   }
91 
92   function transfer(address _to, uint256 _value) public returns (bool success) {
93     _transfer(msg.sender, _to, _value);
94     return true;
95   }
96 
97 
98   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
99     allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
100 		_transfer(_from, _to, _value);
101 		return true;
102   }
103 
104 
105   function approve(address _spender, uint256 _value) public returns (bool success) {
106     allowance[msg.sender][_spender] = _value;
107     emit Approval(msg.sender, _spender, _value);
108     return true;
109   }
110 
111 
112   function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
113     tokenRecipient spender = tokenRecipient(_spender);
114     if (approve(_spender, _value)) {
115       spender.receiveApproval(msg.sender, _value, address(this), _extraData);
116       return true;
117     }
118   }
119 
120 }
121 
122 
123 /******************************************/
124 /*       ADVANCED TOKEN STARTS HERE       */
125 /******************************************/
126 
127 contract Blockburn is owned, TokenERC20  {
128 
129   string _tokenName = "Blockburn";  
130   string _tokenSymbol = "BURN";
131   uint8 _decimals = 18;
132 
133   address[] public frozenAddresses;
134 
135   struct frozenWallet {
136     bool isFrozen; //true or false
137     uint256 rewardedAmount; //amount
138     uint256 frozenAmount; //amount
139     uint256 frozenTime; // in days
140   }
141 
142   mapping (address => frozenWallet) public frozenWallets;
143 
144   constructor() TokenERC20(_tokenName, _tokenSymbol, _decimals) public {
145 
146     /*Locked Tokens */
147     frozenAddresses.push(address(0xCC0d10070F973F03b6CF463F64CF4BB5e253C7F6));
148     frozenWallets[frozenAddresses[0]] = frozenWallet({
149       isFrozen: true,
150       rewardedAmount: 200000000 * 10 ** uint256(decimals),
151       frozenAmount: 200000000 * 10 ** uint256(decimals),
152       frozenTime: now + 360 * 1 days
153     });
154     
155     /*Available Tokens */
156     frozenAddresses.push(address(0x615faD1CC018e100b0994FfbdB6B7A00Cd83F4f9));
157     frozenWallets[frozenAddresses[1]] = frozenWallet({
158       isFrozen: true,
159       rewardedAmount: 1800000000 * 10 ** uint256(decimals),
160       frozenAmount: 0 * 10 ** uint256(decimals),
161       frozenTime: now + 1 * 1 seconds //seconds, minutes, hours, days
162     });
163 
164     for (uint256 i = 0; i < frozenAddresses.length; i++) {
165       balanceOf[frozenAddresses[i]] = frozenWallets[frozenAddresses[i]].rewardedAmount;
166       totalSupply = totalSupply.add(frozenWallets[frozenAddresses[i]].rewardedAmount);
167     }
168   }
169 
170   function _transfer(address _from, address _to, uint _value) internal {
171     require(_to != address(0x0));
172     require(checkFrozenWallet(_from, _value));
173     balanceOf[_from] = balanceOf[_from].sub(_value);      
174     balanceOf[_to] = balanceOf[_to].add(_value);     
175     emit Transfer(_from, _to, _value);
176   }
177 
178   function checkFrozenWallet(address _from, uint _value) public view returns (bool) {
179     return(
180       _from==owner || 
181       (
182         // !tokenFrozen && 
183       (!frozenWallets[_from].isFrozen || 
184        now>=frozenWallets[_from].frozenTime || 
185        balanceOf[_from].sub(_value)>=frozenWallets[_from].frozenAmount))
186     );
187   }
188 
189   function burn(uint256 _value) onlyOwner public returns (bool success) {
190     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);   // Subtract from the sender
191     totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
192     emit Burn(msg.sender, _value);
193     return true;
194   }
195 
196   function burnFrom(address _from, uint256 _value) public returns (bool success) {
197     balanceOf[_from] = balanceOf[_from].sub(_value);                          // Subtract from the targeted balance
198     allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);   // Subtract from the sender's allowance
199     totalSupply = totalSupply.sub(_value);                              // Update totalSupply
200     emit Burn(_from, _value);
201     return true;
202   }
203 }