1 pragma solidity ^ 0.5.8;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         require(c / a == b);
11         return c;
12     }
13     function div(uint256 a, uint256 b) internal pure returns(uint256) {
14         require(b > 0);
15         uint256 c = a / b;
16         return c;
17     }
18     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
19         require(b <= a);
20         uint256 c = a - b;
21         return c;
22     }
23     function add(uint256 a, uint256 b) internal pure returns(uint256) {
24         uint256 c = a + b;
25         require(c >= a && c >= b);
26         return c;
27     }
28     function mod(uint256 a, uint256 b) internal pure returns(uint256) {
29         require(b != 0);
30         return a % b;
31     }
32     function max256(uint256 a, uint256 b) internal pure returns(uint256) {
33         return a >= b ? a : b;
34     }
35     function min256(uint256 a, uint256 b) internal pure returns(uint256) {
36         return a < b ? a : b;
37     }
38 
39 }
40 
41 
42 contract owned {
43     address public owner;
44 
45     constructor() public {
46         owner = msg.sender;
47     }
48 
49     modifier onlyOwner {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     function transferOwnership(address newOwner) onlyOwner public {
55         owner = newOwner;
56     }
57 }
58 
59 interface tokenRecipient {
60   function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
61 }
62 
63 
64 contract TokenERC20 {
65     using SafeMath for uint256;
66         string public name;
67     string public symbol;
68     uint8 public decimals;
69     uint256 public totalSupply;
70 
71     mapping(address => uint256) public balanceOf;
72     mapping(address => mapping(address => uint256)) public allowance;
73 
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
77 
78     event Burn(address indexed from, uint256 value);
79 
80 
81     constructor(string memory tokenName, string memory tokenSymbol, uint8 dec) public {
82         decimals = dec;
83         name = tokenName;                                   // Set the name for display purposes
84         symbol = tokenSymbol;
85     }
86 
87     function _transfer(address _from, address _to, uint _value) internal {
88         require(_to != address(0x0));
89         balanceOf[_from] = balanceOf[_from].sub(_value);
90         balanceOf[_to] = balanceOf[_to].add(_value);
91         emit Transfer(_from, _to, _value);
92     }
93 
94     function transfer(address _to, uint256 _value) public returns(bool success) {
95         _transfer(msg.sender, _to, _value);
96         return true;
97     }
98 
99 
100     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
101         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
102         _transfer(_from, _to, _value);
103         return true;
104     }
105 
106 
107     function approve(address _spender, uint256 _value) public returns(bool success) {
108         allowance[msg.sender][_spender] = _value;
109         emit Approval(msg.sender, _spender, _value);
110         return true;
111     }
112 
113 
114     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns(bool success) {
115         tokenRecipient spender = tokenRecipient(_spender);
116         if (approve(_spender, _value)) {
117             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
118             return true;
119         }
120     }
121 
122 }
123 
124 /******************************************/
125 /*       ADVANCED TOKEN STARTS HERE       */
126 /******************************************/
127 
128 contract UPC is owned, TokenERC20  {
129 
130     string _tokenName = "Unimpededcoin";
131     string _tokenSymbol = "UPC";
132     uint8 _decimals = 8;
133 
134     address[] public frozenAddresses;
135     bool public tokenFrozen;
136 
137     struct frozenWallet {
138         bool isFrozen; //true or false
139         uint256 rewardedAmount; //amount
140         uint256 frozenAmount; //amount
141         uint256 frozenTime; // in days
142     }
143 
144     mapping(address => frozenWallet) public frozenWallets;
145 
146     constructor() TokenERC20(_tokenName, _tokenSymbol, _decimals) public {
147 
148         /*Wallet A */
149         frozenAddresses.push(address(0x0C1dDF513BdcA1b137A5daC34cdDb4297089BBCB));
150         frozenWallets[frozenAddresses[0]] = frozenWallet({
151             isFrozen: false,
152             rewardedAmount: 56567367 * 10 ** uint256(decimals),
153             frozenAmount: 0,
154             frozenTime: 0
155         });
156 
157         for (uint256 i = 0; i < frozenAddresses.length; i++) {
158             balanceOf[frozenAddresses[i]] = frozenWallets[frozenAddresses[i]].rewardedAmount;
159             totalSupply = totalSupply.add(frozenWallets[frozenAddresses[i]].rewardedAmount);
160         }
161     }
162 
163     function _transfer(address _from, address _to, uint _value) internal {
164         require(_to != address(0x0));
165         require(checkFrozenWallet(_from, _value));
166         balanceOf[_from] = balanceOf[_from].sub(_value);
167         balanceOf[_to] = balanceOf[_to].add(_value);
168         emit Transfer(_from, _to, _value);
169     }
170 
171     function checkFrozenWallet(address _from, uint _value) public view returns(bool) {
172         return (
173             _from == owner ||
174             (!tokenFrozen &&
175                 (!frozenWallets[_from].isFrozen ||
176                     now >= frozenWallets[_from].frozenTime ||
177                     balanceOf[_from].sub(_value) >= frozenWallets[_from].frozenAmount))
178         );
179     }
180 
181 
182     function burn(uint256 _value) onlyOwner public returns(bool success) {
183         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);   // Subtract from the sender
184         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
185         emit Burn(msg.sender, _value);
186         return true;
187     }
188 
189     function burnFrom(address _from, uint256 _value) public returns(bool success) {
190         balanceOf[_from] = balanceOf[_from].sub(_value);                          // Subtract from the targeted balance
191         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);   // Subtract from the sender's allowance
192         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
193         emit Burn(_from, _value);
194         return true;
195     }
196 
197     function freezeToken(bool freeze) onlyOwner public {
198         tokenFrozen = freeze;
199     }
200 }