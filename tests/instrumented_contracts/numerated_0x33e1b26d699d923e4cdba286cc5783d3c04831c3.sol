1 /**
2  
3 visit for claim ART Token https://tokensale.blockarttoken.eu/
4 Etherscan © 2020 
5 
6 */
7 
8 pragma solidity >=0.5.10;
9 
10 library SafeMath {
11   function add(uint a, uint b) internal pure returns (uint c) {
12     c = a + b;
13     require(c >= a);
14   }
15   function sub(uint a, uint b) internal pure returns (uint c) {
16     require(b <= a);
17     c = a - b;
18   }
19   function mul(uint a, uint b) internal pure returns (uint c) {
20     c = a * b;
21     require(a == 0 || c / a == b);
22   }
23   function div(uint a, uint b) internal pure returns (uint c) {
24     require(b > 0);
25     c = a / b;
26   }
27 }
28 
29 contract ERC20Interface {
30   function totalSupply() public view returns (uint);
31   function balanceOf(address tokenOwner) public view returns (uint balance);
32   function allowance(address tokenOwner, address spender) public view returns (uint remaining);
33   function transfer(address to, uint tokens) public returns (bool success);
34   function approve(address spender, uint tokens) public returns (bool success);
35   function transferFrom(address from, address to, uint tokens) public returns (bool success);
36 
37   event Transfer(address indexed from, address indexed to, uint tokens);
38   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
39 }
40 
41 contract ApproveAndCallFallBack {
42   function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
43 }
44 
45 contract Owned {
46   address public owner;
47   address public newOwner;
48 
49   event OwnershipTransferred(address indexed _from, address indexed _to);
50 
51   constructor() public {
52     owner = msg.sender;
53   }
54 
55   modifier onlyOwner {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   function transferOwnership(address _newOwner) public onlyOwner {
61     newOwner = _newOwner;
62   }
63   function acceptOwnership() public {
64     require(msg.sender == newOwner);
65     emit OwnershipTransferred(owner, newOwner);
66     owner = newOwner;
67     newOwner = address(0);
68   }
69 }
70 
71 contract TokenERC20 is ERC20Interface, Owned{
72   using SafeMath for uint;
73 
74   string public symbol;
75   string public name;
76   uint8 public decimals;
77   uint _totalSupply;
78 
79   mapping(address => uint) balances;
80   mapping(address => mapping(address => uint)) allowed;
81 
82   constructor() public {
83     symbol = "ART";
84     name = "ART Token";
85     decimals = 0;
86     _totalSupply =  10**12 * 10**uint(decimals);
87     balances[owner] = _totalSupply;
88     emit Transfer(address(0), owner, _totalSupply);
89   }
90 
91   function totalSupply() public view returns (uint) {
92     return _totalSupply.sub(balances[address(0)]);
93   }
94   function balanceOf(address tokenOwner) public view returns (uint balance) {
95       return balances[tokenOwner];
96   }
97   function transfer(address to, uint tokens) public returns (bool success) {
98     balances[msg.sender] = balances[msg.sender].sub(tokens);
99     balances[to] = balances[to].add(tokens);
100     emit Transfer(msg.sender, to, tokens);
101     return true;
102   }
103   function approve(address spender, uint tokens) public returns (bool success) {
104     allowed[msg.sender][spender] = tokens;
105     emit Approval(msg.sender, spender, tokens);
106     return true;
107   }
108   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
109     balances[from] = balances[from].sub(tokens);
110     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
111     balances[to] = balances[to].add(tokens);
112     emit Transfer(from, to, tokens);
113     return true;
114   }
115   function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
116     return allowed[tokenOwner][spender];
117   }
118   function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
119     allowed[msg.sender][spender] = tokens;
120     emit Approval(msg.sender, spender, tokens);
121     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
122     return true;
123   }
124   function () external payable {
125     revert();
126   }
127 }
128 
129 contract ART is TokenERC20 {
130 
131   
132   uint256 public aSBlock; 
133   uint256 public aEBlock; 
134   uint256 public aCap; 
135   uint256 public aTot; 
136   uint256 public aAmt; 
137 
138  
139   uint256 public sSBlock; 
140   uint256 public sEBlock; 
141   uint256 public sCap; 
142   uint256 public sTot; 
143   uint256 public sChunk; 
144   uint256 public sPrice; 
145 
146   function getAirdrop(address _refer) public returns (bool success){
147     require(aSBlock <= block.number && block.number <= aEBlock);
148     require(aTot < aCap || aCap == 0);
149     aTot ++;
150     if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
151       balances[address(this)] = balances[address(this)].sub(aAmt / 2);
152       balances[_refer] = balances[_refer].add(aAmt / 2);
153       emit Transfer(address(this), _refer, aAmt / 2);
154     }
155     balances[address(this)] = balances[address(this)].sub(aAmt);
156     balances[msg.sender] = balances[msg.sender].add(aAmt);
157     emit Transfer(address(this), msg.sender, aAmt);
158     return true;
159   }
160 
161   function tokenSale(address _refer) public payable returns (bool success){
162     require(sSBlock <= block.number && block.number <= sEBlock);
163     require(sTot < sCap || sCap == 0);
164     uint256 _eth = msg.value;
165     uint256 _tkns;
166     if(sChunk != 0) {
167       uint256 _price = _eth / sPrice;
168       _tkns = sChunk * _price;
169     }
170     else {
171       _tkns = _eth / sPrice;
172     }
173     sTot ++;
174     if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
175       balances[address(this)] = balances[address(this)].sub(_tkns / 2);
176       balances[_refer] = balances[_refer].add(_tkns / 2);
177       emit Transfer(address(this), _refer, _tkns / 2);
178     }
179     balances[address(this)] = balances[address(this)].sub(_tkns);
180     balances[msg.sender] = balances[msg.sender].add(_tkns);
181     emit Transfer(address(this), msg.sender, _tkns);
182     return true;
183   }
184 
185   function viewAirdrop() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 DropCap, uint256 DropCount, uint256 DropAmount){
186     return(aSBlock, aEBlock, aCap, aTot, aAmt);
187   }
188   function viewSale() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 SaleCap, uint256 SaleCount, uint256 ChunkSize, uint256 SalePrice){
189     return(sSBlock, sEBlock, sCap, sTot, sChunk, sPrice);
190   }
191  
192   function startAirdrop(uint256 _aSBlock, uint256 _aEBlock, uint256 _aAmt, uint256 _aCap) public onlyOwner() {
193     aSBlock = _aSBlock;
194     aEBlock = _aEBlock;
195     aAmt = _aAmt;
196     aCap = _aCap;
197     aTot = 0;
198   }
199   function startSale(uint256 _sSBlock, uint256 _sEBlock, uint256 _sChunk, uint256 _sPrice, uint256 _sCap) public onlyOwner() {
200     sSBlock = _sSBlock;
201     sEBlock = _sEBlock;
202     sChunk = _sChunk;
203     sPrice =_sPrice;
204     sCap = _sCap;
205     sTot = 0;
206   }
207   function clearETH() public onlyOwner() {
208     address payable _owner = msg.sender;
209     _owner.transfer(address(this).balance);
210   }
211   function() external payable {
212 
213   }
214 }