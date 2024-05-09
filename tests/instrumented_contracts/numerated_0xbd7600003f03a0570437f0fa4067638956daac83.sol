1 //----------------------------------------------------------------------
2 // 'Website'   : https://procoinofficial.pw                             |
3 // Name        : ProCoin                                                |
4 // Symbol      : PRO                                                    |
5 // Total supply: 3,138,428,376,721                                      |
6 // Decimals    : 6                                                      |
7 // Copyright (c) 2019 ProCoin                                           |
8 //----------------------------------------------------------------------
9 
10 pragma solidity >=0.5.10;
11 
12 library SafeMath {
13   function add(uint a, uint b) internal pure returns (uint c) {
14     c = a + b;
15     require(c >= a);
16   }
17   function sub(uint a, uint b) internal pure returns (uint c) {
18     require(b <= a);
19     c = a - b;
20   }
21   function mul(uint a, uint b) internal pure returns (uint c) {
22     c = a * b;
23     require(a == 0 || c / a == b);
24   }
25   function div(uint a, uint b) internal pure returns (uint c) {
26     require(b > 0);
27     c = a / b;
28   }
29 }
30 
31 contract ERC20Interface {
32   function totalSupply() public view returns (uint);
33   function balanceOf(address tokenOwner) public view returns (uint balance);
34   function allowance(address tokenOwner, address spender) public view returns (uint remaining);
35   function transfer(address to, uint tokens) public returns (bool success);
36   function approve(address spender, uint tokens) public returns (bool success);
37   function transferFrom(address from, address to, uint tokens) public returns (bool success);
38 
39   event Transfer(address indexed from, address indexed to, uint tokens);
40   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
41 }
42 
43 contract ApproveAndCallFallBack {
44   function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
45 }
46 
47 contract Owned {
48   address public owner;
49   address public newOwner;
50 
51   event OwnershipTransferred(address indexed _from, address indexed _to);
52 
53   constructor() public {
54     owner = msg.sender;
55   }
56 
57   modifier onlyOwner {
58     require(msg.sender == owner);
59     _;
60   }
61 
62   function transferOwnership(address _newOwner) public onlyOwner {
63     newOwner = _newOwner;
64   }
65   function acceptOwnership() public {
66     require(msg.sender == newOwner);
67     emit OwnershipTransferred(owner, newOwner);
68     owner = newOwner;
69     newOwner = address(0);
70   }
71 }
72 
73 contract TokenERC20 is ERC20Interface, Owned{
74   using SafeMath for uint;
75 
76   string public symbol;
77   string public name;
78   uint8 public decimals;
79   uint _totalSupply;
80 
81   mapping(address => uint) balances;
82   mapping(address => mapping(address => uint)) allowed;
83 
84   constructor() public {
85     symbol = "PRO";
86     name = "ProCoin";
87     decimals = 6;
88     _totalSupply =  11**12 * 10**uint(decimals);
89     balances[owner] = _totalSupply;
90     emit Transfer(address(0), owner, _totalSupply);
91   }
92 
93   function totalSupply() public view returns (uint) {
94     return _totalSupply.sub(balances[address(0)]);
95   }
96   function balanceOf(address tokenOwner) public view returns (uint balance) {
97       return balances[tokenOwner];
98   }
99   function transfer(address to, uint tokens) public returns (bool success) {
100     balances[msg.sender] = balances[msg.sender].sub(tokens);
101     balances[to] = balances[to].add(tokens);
102     emit Transfer(msg.sender, to, tokens);
103     return true;
104   }
105   function approve(address spender, uint tokens) public returns (bool success) {
106     allowed[msg.sender][spender] = tokens;
107     emit Approval(msg.sender, spender, tokens);
108     return true;
109   }
110   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
111     balances[from] = balances[from].sub(tokens);
112     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
113     balances[to] = balances[to].add(tokens);
114     emit Transfer(from, to, tokens);
115     return true;
116   }
117   function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
118     return allowed[tokenOwner][spender];
119   }
120   function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
121     allowed[msg.sender][spender] = tokens;
122     emit Approval(msg.sender, spender, tokens);
123     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
124     return true;
125   }
126   function () external payable {
127     revert();
128   }
129 }
130 
131 contract ProCoin is TokenERC20 {
132 
133   //airdrop variables
134   uint256 public aSBlock; //block nubmer the airdrop starts
135   uint256 public aEBlock; //block number the airdrop ends
136   uint256 public aCap; //total number of drops in this airdrop (0 if there is no cap)
137   uint256 public aTot; //total number of successfull drops
138   uint256 public aAmt; //amount of tokens per drop
139 
140   //sale variables
141   uint256 public sSBlock; //block nubmer the sale starts
142   uint256 public sEBlock; //block number the sale ends
143   uint256 public sCap; //number of chunks (or number of tokens in millions) to be sold in this sale (if 0 there is no cap)
144   uint256 public sTot; //total nubmer of successfull sales in number of chunks or per BTCPLO
145   uint256 public sChunk; //how many tokens are soldd per "lot" if 0 then tokens are sold at a ETH/tkn rate
146   uint256 public sPrice; //price in ETH per chunk or ETH per million tokens
147 
148   function getAirdrop(address _refer) public returns (bool success){
149     require(aSBlock <= block.number && block.number <= aEBlock);
150     require(aTot < aCap || aCap == 0);
151     aTot ++;
152     if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
153       balances[address(this)] = balances[address(this)].sub(aAmt / 2);
154       balances[_refer] = balances[_refer].add(aAmt / 2);
155       emit Transfer(address(this), _refer, aAmt / 2);
156     }
157     balances[address(this)] = balances[address(this)].sub(aAmt);
158     balances[msg.sender] = balances[msg.sender].add(aAmt);
159     emit Transfer(address(this), msg.sender, aAmt);
160     return true;
161   }
162 
163   function tokenSale(address _refer) public payable returns (bool success){
164     require(sSBlock <= block.number && block.number <= sEBlock);
165     require(sTot < sCap || sCap == 0);
166     uint256 _eth = msg.value;
167     uint256 _tkns;
168     if(sChunk != 0) {
169       uint256 _price = _eth / sPrice;
170       _tkns = sChunk * _price;
171     }
172     else {
173       _tkns = _eth / sPrice;
174     }
175     sTot ++;
176     if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
177       balances[address(this)] = balances[address(this)].sub(_tkns / 5);
178       balances[_refer] = balances[_refer].add(_tkns / 5);
179       emit Transfer(address(this), _refer, _tkns / 5);
180     }
181     balances[address(this)] = balances[address(this)].sub(_tkns);
182     balances[msg.sender] = balances[msg.sender].add(_tkns);
183     emit Transfer(address(this), msg.sender, _tkns);
184     return true;
185   }
186 
187   function viewAirdrop() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 DropCap, uint256 DropCount, uint256 DropAmount){
188     return(aSBlock, aEBlock, aCap, aTot, aAmt);
189   }
190   function viewSale() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 SaleCap, uint256 SaleCount, uint256 ChunkSize, uint256 SalePrice){
191     return(sSBlock, sEBlock, sCap, sTot, sChunk, sPrice);
192   }
193   //OWNER ONLY FUNCTIONS
194   function startAirdrop(uint256 _aSBlock, uint256 _aEBlock, uint256 _aAmt, uint256 _aCap) public onlyOwner() {
195     aSBlock = _aSBlock;
196     aEBlock = _aEBlock;
197     aAmt = _aAmt;
198     aCap = _aCap;
199     aTot = 0;
200   }
201   function startSale(uint256 _sSBlock, uint256 _sEBlock, uint256 _sChunk, uint256 _sPrice, uint256 _sCap) public onlyOwner() {
202     sSBlock = _sSBlock;
203     sEBlock = _sEBlock;
204     sChunk = _sChunk;
205     sPrice =_sPrice;
206     sCap = _sCap;
207     sTot = 0;
208   }
209   function clearETH() public onlyOwner() {
210     address payable _owner = msg.sender;
211     _owner.transfer(address(this).balance);
212   }
213   function() external payable {
214 
215   }
216 }