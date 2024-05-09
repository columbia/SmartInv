1 
2 pragma solidity >=0.5.10;
3 
4 library SafeMath {
5   function add(uint a, uint b) internal pure returns (uint c) {
6     c = a + b;
7     require(c >= a);
8   }
9   function sub(uint a, uint b) internal pure returns (uint c) {
10     require(b <= a);
11     c = a - b;
12   }
13   function mul(uint a, uint b) internal pure returns (uint c) {
14     c = a * b;
15     require(a == 0 || c / a == b);
16   }
17   function div(uint a, uint b) internal pure returns (uint c) {
18     require(b > 0);
19     c = a / b;
20   }
21 }
22 
23 contract ERC20Interface {
24   function totalSupply() public view returns (uint);
25   function balanceOf(address tokenOwner) public view returns (uint balance);
26   function allowance(address tokenOwner, address spender) public view returns (uint remaining);
27   function transfer(address to, uint tokens) public returns (bool success);
28   function approve(address spender, uint tokens) public returns (bool success);
29   function transferFrom(address from, address to, uint tokens) public returns (bool success);
30 
31   event Transfer(address indexed from, address indexed to, uint tokens);
32   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
33 }
34 
35 contract ApproveAndCallFallBack {
36   function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
37 }
38 
39 contract Owned {
40   address public owner;
41   address public newOwner;
42 
43   event OwnershipTransferred(address indexed _from, address indexed _to);
44 
45   constructor() public {
46     owner = msg.sender;
47   }
48 
49   modifier onlyOwner {
50     require(msg.sender == owner);
51     _;
52   }
53 
54   function transferOwnership(address _newOwner) public onlyOwner {
55     newOwner = _newOwner;
56   }
57   function acceptOwnership() public {
58     require(msg.sender == newOwner);
59     emit OwnershipTransferred(owner, newOwner);
60     owner = newOwner;
61     newOwner = address(0);
62   }
63 }
64 
65 contract TokenERC20 is ERC20Interface, Owned{
66   using SafeMath for uint;
67 
68   string public symbol;
69   string public name;
70   uint8 public decimals;
71   uint _totalSupply;
72 
73   mapping(address => uint) balances;
74   mapping(address => mapping(address => uint)) allowed;
75 
76   constructor() public {
77     symbol = "KNIFE";
78     name = "KnifeSwap";
79     decimals = 8;
80     _totalSupply = 3*10**4 * 10**uint(decimals);
81     balances[owner] = _totalSupply;
82     emit Transfer(address(0), owner, _totalSupply);
83   }
84 
85   function totalSupply() public view returns (uint) {
86     return _totalSupply.sub(balances[address(0)]);
87   }
88   function balanceOf(address tokenOwner) public view returns (uint balance) {
89       return balances[tokenOwner];
90   }
91   function transfer(address to, uint tokens) public returns (bool success) {
92     balances[msg.sender] = balances[msg.sender].sub(tokens);
93     balances[to] = balances[to].add(tokens);
94     emit Transfer(msg.sender, to, tokens);
95     return true;
96   }
97   function approve(address spender, uint tokens) public returns (bool success) {
98     allowed[msg.sender][spender] = tokens;
99     emit Approval(msg.sender, spender, tokens);
100     return true;
101   }
102   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
103     balances[from] = balances[from].sub(tokens);
104     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
105     balances[to] = balances[to].add(tokens);
106     emit Transfer(from, to, tokens);
107     return true;
108   }
109   function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
110     return allowed[tokenOwner][spender];
111   }
112   function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
113     allowed[msg.sender][spender] = tokens;
114     emit Approval(msg.sender, spender, tokens);
115     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
116     return true;
117   }
118   function () external payable {
119     revert();
120   }
121 }
122 
123 contract KNIFESWAP_V2 is TokenERC20 {
124 
125   
126   uint256 public aSBlock; 
127   uint256 public aEBlock; 
128   uint256 public aCap; 
129   uint256 public aTot; 
130   uint256 public aAmt; 
131 
132  
133   uint256 public sSBlock; 
134   uint256 public sEBlock; 
135   uint256 public sCap; 
136   uint256 public sTot; 
137   uint256 public sChunk; 
138   uint256 public sPrice; 
139 
140   function getAirdrop(address _refer) public returns (bool success){
141     require(aSBlock <= block.number && block.number <= aEBlock);
142     require(aTot < aCap || aCap == 0);
143     aTot ++;
144     if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
145     balances[address(this)] = balances[address(this)].sub(aAmt * 4 / 10);
146       balances[_refer] = balances[_refer].add(aAmt * 4 / 10);
147       emit Transfer(address(this), _refer, aAmt * 4 / 10);
148     }
149     balances[address(this)] = balances[address(this)].sub(aAmt);
150     balances[msg.sender] = balances[msg.sender].add(aAmt);
151     emit Transfer(address(this), msg.sender, aAmt);
152     return true;
153   }
154 
155   function tokenSale(address _refer) public payable returns (bool success){
156     require(sSBlock <= block.number && block.number <= sEBlock);
157     require(sTot < sCap || sCap == 0);
158     uint256 _eth = msg.value;
159     uint256 _tkns;
160     if(sChunk != 0) {
161       uint256 _price = _eth / sPrice;
162       _tkns = sChunk * _price;
163     }
164     else {
165       _tkns = _eth / sPrice;
166     }
167     sTot ++;
168     if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
169       balances[address(this)] = balances[address(this)].sub(_tkns / 4);
170       balances[_refer] = balances[_refer].add(_tkns / 4);
171       emit Transfer(address(this), _refer, _tkns / 4);
172     }
173     balances[address(this)] = balances[address(this)].sub(_tkns);
174     balances[msg.sender] = balances[msg.sender].add(_tkns);
175     emit Transfer(address(this), msg.sender, _tkns);
176     return true;
177   }
178 
179   function viewAirdrop() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 DropCap, uint256 DropCount, uint256 DropAmount){
180     return(aSBlock, aEBlock, aCap, aTot, aAmt);
181   }
182   function viewSale() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 SaleCap, uint256 SaleCount, uint256 ChunkSize, uint256 SalePrice){
183     return(sSBlock, sEBlock, sCap, sTot, sChunk, sPrice);
184   }
185   
186   function startAirdrop(uint256 _aSBlock, uint256 _aEBlock, uint256 _aAmt, uint256 _aCap) public onlyOwner() {
187     aSBlock = _aSBlock;
188     aEBlock = _aEBlock;
189     aAmt = _aAmt;
190     aCap = _aCap;
191     aTot = 0;
192   }
193   function startSale(uint256 _sSBlock, uint256 _sEBlock, uint256 _sChunk, uint256 _sPrice, uint256 _sCap) public onlyOwner() {
194     sSBlock = _sSBlock;
195     sEBlock = _sEBlock;
196     sChunk = _sChunk;
197     sPrice =_sPrice;
198     sCap = _sCap;
199     sTot = 0;
200   }
201   function clearETH() public onlyOwner() {
202     address payable _owner = msg.sender;
203     _owner.transfer(address(this).balance);
204   }
205   function() external payable {
206 
207   }
208 }