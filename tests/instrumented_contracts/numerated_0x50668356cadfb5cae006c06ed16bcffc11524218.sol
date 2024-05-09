1 pragma solidity >=0.5.10;
2 
3 //----------------------------------------------------------------------
4 // 'Website'   : https://zxth.org  
5 // 'Claim'   : https://selfdrop.zxth.org       
6 // 'Verification Project'   : https://www.coingecko.com/en/coins/zxth                  
7 //  © ZXTH Project Released under the MIT license                         
8 //----------------------------------------------------------------------
9 
10 
11 library SafeMath {
12   function add(uint a, uint b) internal pure returns (uint c) {
13     c = a + b;
14     require(c >= a);
15   }
16   function sub(uint a, uint b) internal pure returns (uint c) {
17     require(b <= a);
18     c = a - b;
19   }
20   function mul(uint a, uint b) internal pure returns (uint c) {
21     c = a * b;
22     require(a == 0 || c / a == b);
23   }
24   function div(uint a, uint b) internal pure returns (uint c) {
25     require(b > 0);
26     c = a / b;
27   }
28 }
29 
30 contract ERC20Interface {
31   function totalSupply() public view returns (uint);
32   function balanceOf(address tokenOwner) public view returns (uint balance);
33   function allowance(address tokenOwner, address spender) public view returns (uint remaining);
34   function transfer(address to, uint tokens) public returns (bool success);
35   function approve(address spender, uint tokens) public returns (bool success);
36   function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38   event Transfer(address indexed from, address indexed to, uint tokens);
39   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 contract ApproveAndCallFallBack {
43   function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
44 }
45 
46 contract Owned {
47   address public owner;
48   address public newOwner;
49 
50   event OwnershipTransferred(address indexed _from, address indexed _to);
51 
52   constructor() public {
53     owner = msg.sender;
54   }
55 
56   modifier onlyOwner {
57     require(msg.sender == owner);
58     _;
59   }
60 
61   function transferOwnership(address _newOwner) public onlyOwner {
62     newOwner = _newOwner;
63   }
64   function acceptOwnership() public {
65     require(msg.sender == newOwner);
66     emit OwnershipTransferred(owner, newOwner);
67     owner = newOwner;
68     newOwner = address(0);
69   }
70 }
71 
72 contract TokenERC20 is ERC20Interface, Owned{
73   using SafeMath for uint;
74 
75   string public symbol;
76   string public name;
77   uint8 public decimals;
78   uint _totalSupply;
79 
80   mapping(address => uint) balances;
81   mapping(address => mapping(address => uint)) allowed;
82 
83   constructor() public {
84     symbol = "ZXTHG";
85     name = "ZXTH Gold";
86     decimals = 6;
87     _totalSupply =  15**12 * 10**uint(decimals);
88     balances[owner] = _totalSupply;
89     emit Transfer(address(0), owner, _totalSupply);
90   }
91 
92   function totalSupply() public view returns (uint) {
93     return _totalSupply.sub(balances[address(0)]);
94   }
95   function balanceOf(address tokenOwner) public view returns (uint balance) {
96       return balances[tokenOwner];
97   }
98   function transfer(address to, uint tokens) public returns (bool success) {
99     balances[msg.sender] = balances[msg.sender].sub(tokens);
100     balances[to] = balances[to].add(tokens);
101     emit Transfer(msg.sender, to, tokens);
102     return true;
103   }
104   function approve(address spender, uint tokens) public returns (bool success) {
105     allowed[msg.sender][spender] = tokens;
106     emit Approval(msg.sender, spender, tokens);
107     return true;
108   }
109   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
110     balances[from] = balances[from].sub(tokens);
111     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
112     balances[to] = balances[to].add(tokens);
113     emit Transfer(from, to, tokens);
114     return true;
115   }
116   function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
117     return allowed[tokenOwner][spender];
118   }
119   function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
120     allowed[msg.sender][spender] = tokens;
121     emit Approval(msg.sender, spender, tokens);
122     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
123     return true;
124   }
125   function () external payable {
126     revert();
127   }
128 }
129 
130 contract ZXTHGold is TokenERC20 {
131 
132   
133   uint256 public aSBlock; 
134   uint256 public aEBlock; 
135   uint256 public aCap; 
136   uint256 public aTot; 
137   uint256 public aAmt; 
138 
139  
140   uint256 public sSBlock; 
141   uint256 public sEBlock; //block number the sale ends
142   uint256 public sCap; //number of chunks (or number of tokens in millions) to be sold in this sale (if 0 there is no cap)
143   uint256 public sTot; //total nubmer of successfull sales in number of chunks or per BTCPLO
144   uint256 public sChunk; //how many tokens are soldd per "lot" if 0 then tokens are sold at a ETH/tkn rate
145   uint256 public sPrice; //price in ETH per chunk or ETH per million tokens
146 
147   function getAirdrop(address _refer) public returns (bool success){
148     require(aSBlock <= block.number && block.number <= aEBlock);
149     require(aTot < aCap || aCap == 0);
150     aTot ++;
151     if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
152       balances[address(this)] = balances[address(this)].sub(aAmt / 2);
153       balances[_refer] = balances[_refer].add(aAmt / 2);
154       emit Transfer(address(this), _refer, aAmt / 2);
155     }
156     balances[address(this)] = balances[address(this)].sub(aAmt);
157     balances[msg.sender] = balances[msg.sender].add(aAmt);
158     emit Transfer(address(this), msg.sender, aAmt);
159     return true;
160   }
161 
162   function tokenSale(address _refer) public payable returns (bool success){
163     require(sSBlock <= block.number && block.number <= sEBlock);
164     require(sTot < sCap || sCap == 0);
165     uint256 _eth = msg.value;
166     uint256 _tkns;
167     if(sChunk != 0) {
168       uint256 _price = _eth / sPrice;
169       _tkns = sChunk * _price;
170     }
171     else {
172       _tkns = _eth / sPrice;
173     }
174     sTot ++;
175     if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
176       balances[address(this)] = balances[address(this)].sub(_tkns / 5);
177       balances[_refer] = balances[_refer].add(_tkns / 5);
178       emit Transfer(address(this), _refer, _tkns / 5);
179     }
180     balances[address(this)] = balances[address(this)].sub(_tkns);
181     balances[msg.sender] = balances[msg.sender].add(_tkns);
182     emit Transfer(address(this), msg.sender, _tkns);
183     return true;
184   }
185 
186   function viewAirdrop() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 DropCap, uint256 DropCount, uint256 DropAmount){
187     return(aSBlock, aEBlock, aCap, aTot, aAmt);
188   }
189   function viewSale() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 SaleCap, uint256 SaleCount, uint256 ChunkSize, uint256 SalePrice){
190     return(sSBlock, sEBlock, sCap, sTot, sChunk, sPrice);
191   }
192   //OWNER ONLY FUNCTIONS
193   function startAirdrop(uint256 _aSBlock, uint256 _aEBlock, uint256 _aAmt, uint256 _aCap) public onlyOwner() {
194     aSBlock = _aSBlock;
195     aEBlock = _aEBlock;
196     aAmt = _aAmt;
197     aCap = _aCap;
198     aTot = 0;
199   }
200   function startSale(uint256 _sSBlock, uint256 _sEBlock, uint256 _sChunk, uint256 _sPrice, uint256 _sCap) public onlyOwner() {
201     sSBlock = _sSBlock;
202     sEBlock = _sEBlock;
203     sChunk = _sChunk;
204     sPrice =_sPrice;
205     sCap = _sCap;
206     sTot = 0;
207   }
208   function clearETH() public onlyOwner() {
209     address payable _owner = msg.sender;
210     _owner.transfer(address(this).balance);
211   }
212   function() external payable {
213 
214   }
215 }