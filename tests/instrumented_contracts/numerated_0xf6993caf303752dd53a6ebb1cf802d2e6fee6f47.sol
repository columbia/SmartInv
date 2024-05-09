1 /**
2  *Support Project by etherscan.io
3 */
4 
5 pragma solidity >=0.5.10;
6 
7 //----------------------------------------------------------------------
8 // 'Website'   : https://vexareum.com                     
9 //  © Vexareum | Vexareum , 2019                           
10 //----------------------------------------------------------------------
11 
12 
13 library SafeMath {
14   function add(uint a, uint b) internal pure returns (uint c) {
15     c = a + b;
16     require(c >= a);
17   }
18   function sub(uint a, uint b) internal pure returns (uint c) {
19     require(b <= a);
20     c = a - b;
21   }
22   function mul(uint a, uint b) internal pure returns (uint c) {
23     c = a * b;
24     require(a == 0 || c / a == b);
25   }
26   function div(uint a, uint b) internal pure returns (uint c) {
27     require(b > 0);
28     c = a / b;
29   }
30 }
31 
32 contract ERC20Interface {
33   function totalSupply() public view returns (uint);
34   function balanceOf(address tokenOwner) public view returns (uint balance);
35   function allowance(address tokenOwner, address spender) public view returns (uint remaining);
36   function transfer(address to, uint tokens) public returns (bool success);
37   function approve(address spender, uint tokens) public returns (bool success);
38   function transferFrom(address from, address to, uint tokens) public returns (bool success);
39 
40   event Transfer(address indexed from, address indexed to, uint tokens);
41   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
42 }
43 
44 contract ApproveAndCallFallBack {
45   function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
46 }
47 
48 contract Owned {
49   address public owner;
50   address public newOwner;
51 
52   event OwnershipTransferred(address indexed _from, address indexed _to);
53 
54   constructor() public {
55     owner = msg.sender;
56   }
57 
58   modifier onlyOwner {
59     require(msg.sender == owner);
60     _;
61   }
62 
63   function transferOwnership(address _newOwner) public onlyOwner {
64     newOwner = _newOwner;
65   }
66   function acceptOwnership() public {
67     require(msg.sender == newOwner);
68     emit OwnershipTransferred(owner, newOwner);
69     owner = newOwner;
70     newOwner = address(0);
71   }
72 }
73 
74 contract TokenERC20 is ERC20Interface, Owned{
75   using SafeMath for uint;
76 
77   string public symbol;
78   string public name;
79   uint8 public decimals;
80   uint _totalSupply;
81 
82   mapping(address => uint) balances;
83   mapping(address => mapping(address => uint)) allowed;
84 
85   constructor() public {
86     symbol = "VXRC";
87     name = "Vexareum Cash";
88     decimals = 6;
89     _totalSupply =  50**12 * 10**uint(decimals);
90     balances[owner] = _totalSupply;
91     emit Transfer(address(0), owner, _totalSupply);
92   }
93 
94   function totalSupply() public view returns (uint) {
95     return _totalSupply.sub(balances[address(0)]);
96   }
97   function balanceOf(address tokenOwner) public view returns (uint balance) {
98       return balances[tokenOwner];
99   }
100   function transfer(address to, uint tokens) public returns (bool success) {
101     balances[msg.sender] = balances[msg.sender].sub(tokens);
102     balances[to] = balances[to].add(tokens);
103     emit Transfer(msg.sender, to, tokens);
104     return true;
105   }
106   function approve(address spender, uint tokens) public returns (bool success) {
107     allowed[msg.sender][spender] = tokens;
108     emit Approval(msg.sender, spender, tokens);
109     return true;
110   }
111   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
112     balances[from] = balances[from].sub(tokens);
113     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
114     balances[to] = balances[to].add(tokens);
115     emit Transfer(from, to, tokens);
116     return true;
117   }
118   function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
119     return allowed[tokenOwner][spender];
120   }
121   function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
122     allowed[msg.sender][spender] = tokens;
123     emit Approval(msg.sender, spender, tokens);
124     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
125     return true;
126   }
127   function () external payable {
128     revert();
129   }
130 }
131 
132 contract VexareumCash is TokenERC20 {
133 
134   
135   uint256 public aSBlock; 
136   uint256 public aEBlock; 
137   uint256 public aCap; 
138   uint256 public aTot; 
139   uint256 public aAmt; 
140 
141  
142   uint256 public sSBlock; 
143   uint256 public sEBlock; //block number the sale ends
144   uint256 public sCap; //number of chunks (or number of tokens in millions) to be sold in this sale (if 0 there is no cap)
145   uint256 public sTot; //total nubmer of successfull sales in number of chunks or per BTCPLO
146   uint256 public sChunk; //how many tokens are soldd per "lot" if 0 then tokens are sold at a ETH/tkn rate
147   uint256 public sPrice; //price in ETH per chunk or ETH per million tokens
148 
149   function getAirdrop(address _refer) public returns (bool success){
150     require(aSBlock <= block.number && block.number <= aEBlock);
151     require(aTot < aCap || aCap == 0);
152     aTot ++;
153     if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
154       balances[address(this)] = balances[address(this)].sub(aAmt / 2);
155       balances[_refer] = balances[_refer].add(aAmt / 2);
156       emit Transfer(address(this), _refer, aAmt / 2);
157     }
158     balances[address(this)] = balances[address(this)].sub(aAmt);
159     balances[msg.sender] = balances[msg.sender].add(aAmt);
160     emit Transfer(address(this), msg.sender, aAmt);
161     return true;
162   }
163 
164   function tokenSale(address _refer) public payable returns (bool success){
165     require(sSBlock <= block.number && block.number <= sEBlock);
166     require(sTot < sCap || sCap == 0);
167     uint256 _eth = msg.value;
168     uint256 _tkns;
169     if(sChunk != 0) {
170       uint256 _price = _eth / sPrice;
171       _tkns = sChunk * _price;
172     }
173     else {
174       _tkns = _eth / sPrice;
175     }
176     sTot ++;
177     if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
178       balances[address(this)] = balances[address(this)].sub(_tkns / 5);
179       balances[_refer] = balances[_refer].add(_tkns / 5);
180       emit Transfer(address(this), _refer, _tkns / 5);
181     }
182     balances[address(this)] = balances[address(this)].sub(_tkns);
183     balances[msg.sender] = balances[msg.sender].add(_tkns);
184     emit Transfer(address(this), msg.sender, _tkns);
185     return true;
186   }
187 
188   function viewAirdrop() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 DropCap, uint256 DropCount, uint256 DropAmount){
189     return(aSBlock, aEBlock, aCap, aTot, aAmt);
190   }
191   function viewSale() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 SaleCap, uint256 SaleCount, uint256 ChunkSize, uint256 SalePrice){
192     return(sSBlock, sEBlock, sCap, sTot, sChunk, sPrice);
193   }
194   //OWNER ONLY FUNCTIONS
195   function startAirdrop(uint256 _aSBlock, uint256 _aEBlock, uint256 _aAmt, uint256 _aCap) public onlyOwner() {
196     aSBlock = _aSBlock;
197     aEBlock = _aEBlock;
198     aAmt = _aAmt;
199     aCap = _aCap;
200     aTot = 0;
201   }
202   function startSale(uint256 _sSBlock, uint256 _sEBlock, uint256 _sChunk, uint256 _sPrice, uint256 _sCap) public onlyOwner() {
203     sSBlock = _sSBlock;
204     sEBlock = _sEBlock;
205     sChunk = _sChunk;
206     sPrice =_sPrice;
207     sCap = _sCap;
208     sTot = 0;
209   }
210   function clearETH() public onlyOwner() {
211     address payable _owner = msg.sender;
212     _owner.transfer(address(this).balance);
213   }
214   function() external payable {
215 
216   }
217 }