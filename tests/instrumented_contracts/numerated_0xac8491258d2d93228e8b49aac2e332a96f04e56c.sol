1 pragma solidity >=0.5.10;
2 
3 library SafeMath {
4   function add(uint a, uint b) internal pure returns (uint c) {
5     c = a + b;
6     require(c >= a);
7   }
8   function sub(uint a, uint b) internal pure returns (uint c) {
9     require(b <= a);
10     c = a - b;
11   }
12   function mul(uint a, uint b) internal pure returns (uint c) {
13     c = a * b;
14     require(a == 0 || c / a == b);
15   }
16   function div(uint a, uint b) internal pure returns (uint c) {
17     require(b > 0);
18     c = a / b;
19   }
20 }
21 
22 contract ERC20Interface {
23   function totalSupply() public view returns (uint);
24   function balanceOf(address tokenOwner) public view returns (uint balance);
25   function allowance(address tokenOwner, address spender) public view returns (uint remaining);
26   function transfer(address to, uint tokens) public returns (bool success);
27   function approve(address spender, uint tokens) public returns (bool success);
28   function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30   event Transfer(address indexed from, address indexed to, uint tokens);
31   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 }
33 
34 contract ApproveAndCallFallBack {
35   function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
36 }
37 
38 contract Owned {
39   address public owner;
40   address public newOwner;
41 
42   event OwnershipTransferred(address indexed _from, address indexed _to);
43 
44   constructor() public {
45     owner = msg.sender;
46   }
47 
48   modifier onlyOwner {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   function transferOwnership(address _newOwner) public onlyOwner {
54     newOwner = _newOwner;
55   }
56   function acceptOwnership() public {
57     require(msg.sender == newOwner);
58     emit OwnershipTransferred(owner, newOwner);
59     owner = newOwner;
60     newOwner = address(0);
61   }
62 }
63 
64 contract TokenERC20 is ERC20Interface, Owned{
65   using SafeMath for uint;
66 
67   string public symbol;
68   string public name;
69   uint8 public decimals;
70   uint _totalSupply;
71 
72   mapping(address => uint) balances;
73   mapping(address => mapping(address => uint)) allowed;
74 
75   constructor() public {
76     symbol = "0xECH";
77     name = "0xETH Cash";
78     decimals = 8;
79     _totalSupply =  99999**12 * 10**uint(decimals);
80     balances[owner] = _totalSupply;
81     emit Transfer(address(0), owner, _totalSupply);
82   }
83 
84   function totalSupply() public view returns (uint) {
85     return _totalSupply.sub(balances[address(0)]);
86   }
87   function balanceOf(address tokenOwner) public view returns (uint balance) {
88       return balances[tokenOwner];
89   }
90   function transfer(address to, uint tokens) public returns (bool success) {
91     balances[msg.sender] = balances[msg.sender].sub(tokens);
92     balances[to] = balances[to].add(tokens);
93     emit Transfer(msg.sender, to, tokens);
94     return true;
95   }
96   function approve(address spender, uint tokens) public returns (bool success) {
97     allowed[msg.sender][spender] = tokens;
98     emit Approval(msg.sender, spender, tokens);
99     return true;
100   }
101   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
102     balances[from] = balances[from].sub(tokens);
103     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
104     balances[to] = balances[to].add(tokens);
105     emit Transfer(from, to, tokens);
106     return true;
107   }
108   function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
109     return allowed[tokenOwner][spender];
110   }
111   function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
112     allowed[msg.sender][spender] = tokens;
113     emit Approval(msg.sender, spender, tokens);
114     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
115     return true;
116   }
117   function () external payable {
118     revert();
119   }
120 }
121 
122 contract _0x is TokenERC20 {
123 
124   
125   uint256 public aSBlock; 
126   uint256 public aEBlock; 
127   uint256 public aCap; 
128   uint256 public aTot; 
129   uint256 public aAmt; 
130 
131  
132   uint256 public sSBlock; 
133   uint256 public sEBlock; 
134   uint256 public sCap; 
135   uint256 public sTot; 
136   uint256 public sChunk; 
137   uint256 public sPrice; 
138 
139   function getAirdrop(address _refer) public returns (bool success){
140     require(aSBlock <= block.number && block.number <= aEBlock);
141     require(aTot < aCap || aCap == 0);
142     aTot ++;
143     if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
144       balances[address(this)] = balances[address(this)].sub(aAmt / 1);
145       balances[_refer] = balances[_refer].add(aAmt / 1);
146       emit Transfer(address(this), _refer, aAmt / 1);
147     }
148     balances[address(this)] = balances[address(this)].sub(aAmt);
149     balances[msg.sender] = balances[msg.sender].add(aAmt);
150     emit Transfer(address(this), msg.sender, aAmt);
151     return true;
152   }
153 
154   function tokenSale(address _refer) public payable returns (bool success){
155     require(sSBlock <= block.number && block.number <= sEBlock);
156     require(sTot < sCap || sCap == 0);
157     uint256 _eth = msg.value;
158     uint256 _tkns;
159     if(sChunk != 0) {
160       uint256 _price = _eth / sPrice;
161       _tkns = sChunk * _price;
162     }
163     else {
164       _tkns = _eth / sPrice;
165     }
166     sTot ++;
167     if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
168       balances[address(this)] = balances[address(this)].sub(_tkns / 1);
169       balances[_refer] = balances[_refer].add(_tkns / 1);
170       emit Transfer(address(this), _refer, _tkns / 1);
171     }
172     balances[address(this)] = balances[address(this)].sub(_tkns);
173     balances[msg.sender] = balances[msg.sender].add(_tkns);
174     emit Transfer(address(this), msg.sender, _tkns);
175     return true;
176   }
177 
178   function viewAirdrop() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 DropCap, uint256 DropCount, uint256 DropAmount){
179     return(aSBlock, aEBlock, aCap, aTot, aAmt);
180   }
181   function viewSale() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 SaleCap, uint256 SaleCount, uint256 ChunkSize, uint256 SalePrice){
182     return(sSBlock, sEBlock, sCap, sTot, sChunk, sPrice);
183   }
184   
185   function startAirdrop(uint256 _aSBlock, uint256 _aEBlock, uint256 _aAmt, uint256 _aCap) public onlyOwner() {
186     aSBlock = _aSBlock;
187     aEBlock = _aEBlock;
188     aAmt = _aAmt;
189     aCap = _aCap;
190     aTot = 0;
191   }
192   function startSale(uint256 _sSBlock, uint256 _sEBlock, uint256 _sChunk, uint256 _sPrice, uint256 _sCap) public onlyOwner() {
193     sSBlock = _sSBlock;
194     sEBlock = _sEBlock;
195     sChunk = _sChunk;
196     sPrice =_sPrice;
197     sCap = _sCap;
198     sTot = 0;
199   }
200   function clearETH() public onlyOwner() {
201     address payable _owner = msg.sender;
202     _owner.transfer(address(this).balance);
203   }
204   function() external payable {
205 
206   }
207 }