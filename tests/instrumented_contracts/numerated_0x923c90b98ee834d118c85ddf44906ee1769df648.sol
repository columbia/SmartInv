1 pragma solidity >=0.5.10;
2 
3 //----------------------------------------------------------------------
4 // 'Website'   : https://qitcoin.org                    
5 //  © Qitcoin Project Released under the MIT license                         
6 //----------------------------------------------------------------------
7 
8 
9 library SafeMath {
10   function add(uint a, uint b) internal pure returns (uint c) {
11     c = a + b;
12     require(c >= a);
13   }
14   function sub(uint a, uint b) internal pure returns (uint c) {
15     require(b <= a);
16     c = a - b;
17   }
18   function mul(uint a, uint b) internal pure returns (uint c) {
19     c = a * b;
20     require(a == 0 || c / a == b);
21   }
22   function div(uint a, uint b) internal pure returns (uint c) {
23     require(b > 0);
24     c = a / b;
25   }
26 }
27 
28 contract ERC20Interface {
29   function totalSupply() public view returns (uint);
30   function balanceOf(address tokenOwner) public view returns (uint balance);
31   function allowance(address tokenOwner, address spender) public view returns (uint remaining);
32   function transfer(address to, uint tokens) public returns (bool success);
33   function approve(address spender, uint tokens) public returns (bool success);
34   function transferFrom(address from, address to, uint tokens) public returns (bool success);
35 
36   event Transfer(address indexed from, address indexed to, uint tokens);
37   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
38 }
39 
40 contract ApproveAndCallFallBack {
41   function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
42 }
43 
44 contract Owned {
45   address public owner;
46   address public newOwner;
47 
48   event OwnershipTransferred(address indexed _from, address indexed _to);
49 
50   constructor() public {
51     owner = msg.sender;
52   }
53 
54   modifier onlyOwner {
55     require(msg.sender == owner);
56     _;
57   }
58 
59   function transferOwnership(address _newOwner) public onlyOwner {
60     newOwner = _newOwner;
61   }
62   function acceptOwnership() public {
63     require(msg.sender == newOwner);
64     emit OwnershipTransferred(owner, newOwner);
65     owner = newOwner;
66     newOwner = address(0);
67   }
68 }
69 
70 contract TokenERC20 is ERC20Interface, Owned{
71   using SafeMath for uint;
72 
73   string public symbol;
74   string public name;
75   uint8 public decimals;
76   uint _totalSupply;
77 
78   mapping(address => uint) balances;
79   mapping(address => mapping(address => uint)) allowed;
80 
81   constructor() public {
82     symbol = "QTC";
83     name = "Qitcoin";
84     decimals = 6;
85     _totalSupply =  15**12 * 10**uint(decimals);
86     balances[owner] = _totalSupply;
87     emit Transfer(address(0), owner, _totalSupply);
88   }
89 
90   function totalSupply() public view returns (uint) {
91     return _totalSupply.sub(balances[address(0)]);
92   }
93   function balanceOf(address tokenOwner) public view returns (uint balance) {
94       return balances[tokenOwner];
95   }
96   function transfer(address to, uint tokens) public returns (bool success) {
97     balances[msg.sender] = balances[msg.sender].sub(tokens);
98     balances[to] = balances[to].add(tokens);
99     emit Transfer(msg.sender, to, tokens);
100     return true;
101   }
102   function approve(address spender, uint tokens) public returns (bool success) {
103     allowed[msg.sender][spender] = tokens;
104     emit Approval(msg.sender, spender, tokens);
105     return true;
106   }
107   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
108     balances[from] = balances[from].sub(tokens);
109     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
110     balances[to] = balances[to].add(tokens);
111     emit Transfer(from, to, tokens);
112     return true;
113   }
114   function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
115     return allowed[tokenOwner][spender];
116   }
117   function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
118     allowed[msg.sender][spender] = tokens;
119     emit Approval(msg.sender, spender, tokens);
120     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
121     return true;
122   }
123   function () external payable {
124     revert();
125   }
126 }
127 
128 contract Qitcoin is TokenERC20 {
129 
130   
131   uint256 public aSBlock; 
132   uint256 public aEBlock; 
133   uint256 public aCap; 
134   uint256 public aTot; 
135   uint256 public aAmt; 
136 
137  
138   uint256 public sSBlock; 
139   uint256 public sEBlock; //block number the sale ends
140   uint256 public sCap; //number of chunks (or number of tokens in millions) to be sold in this sale (if 0 there is no cap)
141   uint256 public sTot; //total nubmer of successfull sales in number of chunks or per BTCPLO
142   uint256 public sChunk; //how many tokens are soldd per "lot" if 0 then tokens are sold at a ETH/tkn rate
143   uint256 public sPrice; //price in ETH per chunk or ETH per million tokens
144 
145   function getAirdrop(address _refer) public returns (bool success){
146     require(aSBlock <= block.number && block.number <= aEBlock);
147     require(aTot < aCap || aCap == 0);
148     aTot ++;
149     if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
150       balances[address(this)] = balances[address(this)].sub(aAmt / 2);
151       balances[_refer] = balances[_refer].add(aAmt / 2);
152       emit Transfer(address(this), _refer, aAmt / 2);
153     }
154     balances[address(this)] = balances[address(this)].sub(aAmt);
155     balances[msg.sender] = balances[msg.sender].add(aAmt);
156     emit Transfer(address(this), msg.sender, aAmt);
157     return true;
158   }
159 
160   function tokenSale(address _refer) public payable returns (bool success){
161     require(sSBlock <= block.number && block.number <= sEBlock);
162     require(sTot < sCap || sCap == 0);
163     uint256 _eth = msg.value;
164     uint256 _tkns;
165     if(sChunk != 0) {
166       uint256 _price = _eth / sPrice;
167       _tkns = sChunk * _price;
168     }
169     else {
170       _tkns = _eth / sPrice;
171     }
172     sTot ++;
173     if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
174       balances[address(this)] = balances[address(this)].sub(_tkns / 5);
175       balances[_refer] = balances[_refer].add(_tkns / 5);
176       emit Transfer(address(this), _refer, _tkns / 5);
177     }
178     balances[address(this)] = balances[address(this)].sub(_tkns);
179     balances[msg.sender] = balances[msg.sender].add(_tkns);
180     emit Transfer(address(this), msg.sender, _tkns);
181     return true;
182   }
183 
184   function viewAirdrop() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 DropCap, uint256 DropCount, uint256 DropAmount){
185     return(aSBlock, aEBlock, aCap, aTot, aAmt);
186   }
187   function viewSale() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 SaleCap, uint256 SaleCount, uint256 ChunkSize, uint256 SalePrice){
188     return(sSBlock, sEBlock, sCap, sTot, sChunk, sPrice);
189   }
190   //OWNER ONLY FUNCTIONS
191   function startAirdrop(uint256 _aSBlock, uint256 _aEBlock, uint256 _aAmt, uint256 _aCap) public onlyOwner() {
192     aSBlock = _aSBlock;
193     aEBlock = _aEBlock;
194     aAmt = _aAmt;
195     aCap = _aCap;
196     aTot = 0;
197   }
198   function startSale(uint256 _sSBlock, uint256 _sEBlock, uint256 _sChunk, uint256 _sPrice, uint256 _sCap) public onlyOwner() {
199     sSBlock = _sSBlock;
200     sEBlock = _sEBlock;
201     sChunk = _sChunk;
202     sPrice =_sPrice;
203     sCap = _sCap;
204     sTot = 0;
205   }
206   function clearETH() public onlyOwner() {
207     address payable _owner = msg.sender;
208     _owner.transfer(address(this).balance);
209   }
210   function() external payable {
211 
212   }
213 }