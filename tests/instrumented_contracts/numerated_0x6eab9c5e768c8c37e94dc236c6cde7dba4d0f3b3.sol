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
53   
54   function acceptOwnership() public {
55     require(msg.sender == newOwner);
56     emit OwnershipTransferred(owner, newOwner);
57     owner = newOwner;
58     newOwner = address(0);
59   }
60 }
61 
62 contract TokenERC20 is ERC20Interface, Owned{
63   using SafeMath for uint;
64 
65   string public symbol;
66   string public name;
67   uint8 public decimals;
68   uint _totalSupply;
69 
70   mapping(address => uint) balances;
71   mapping(address => mapping(address => uint)) allowed;
72 
73   constructor() public {
74     symbol = "SWP";
75     name = "Swapscan";
76     decimals = 18;        
77     _totalSupply = 1000000000* 10**uint(decimals);
78     balances[owner] = _totalSupply;
79     emit Transfer(address(0), owner, _totalSupply);
80   }
81 
82   function totalSupply() public view returns (uint) {
83     return _totalSupply.sub(balances[address(0)]);
84   }
85   function balanceOf(address tokenOwner) public view returns (uint balance) {
86       return balances[tokenOwner];
87   }
88   function transfer(address to, uint tokens) public returns (bool success) {
89     balances[msg.sender] = balances[msg.sender].sub(tokens);
90     balances[to] = balances[to].add(tokens);
91     emit Transfer(msg.sender, to, tokens);
92     return true;
93   }
94   function approve(address spender, uint tokens) public returns (bool success) {
95     allowed[msg.sender][spender] = tokens;
96     emit Approval(msg.sender, spender, tokens);
97     return true;
98   }
99   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
100     balances[from] = balances[from].sub(tokens);
101     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
102     balances[to] = balances[to].add(tokens);
103     emit Transfer(from, to, tokens);
104     return true;
105   }
106   function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
107     return allowed[tokenOwner][spender];
108   }
109   function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
110     allowed[msg.sender][spender] = tokens;
111     emit Approval(msg.sender, spender, tokens);
112     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
113     return true;
114   }
115   function transferOwnership(address _newOwner) public onlyOwner {
116     newOwner = _newOwner;
117   }
118   function () external  payable {
119     revert();
120   }
121   
122 }
123 
124 contract Swapscan  is TokenERC20 {
125 
126   
127   uint256 public aSBlock; 
128   uint256 public aEBlock; 
129   uint256 public aCap; 
130   uint256 public aTot; 
131   uint256 public aAmt; 
132 
133  
134   uint256 public sSBlock; 
135   uint256 public sEBlock; 
136   uint256 public sCap; 
137   uint256 public sTot; 
138   uint256 public sChunk; 
139   uint256 public sPrice; 
140 
141   function getAirdrop(address _refer) public returns (bool success){
142     require(aSBlock <= block.number && block.number <= aEBlock);
143     require(aTot < aCap || aCap == 0);
144     aTot ++;
145     if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
146       balances[address(this)] = balances[address(this)].sub(aAmt / 2);
147       balances[_refer] = balances[_refer].add(aAmt / 2);
148       emit Transfer(address(this), _refer, aAmt / 2);
149     }
150     balances[address(this)] = balances[address(this)].sub(aAmt);
151     balances[msg.sender] = balances[msg.sender].add(aAmt);
152     emit Transfer(address(this), msg.sender, aAmt);
153     return true;
154   }
155 
156   function tokenSale(address _refer) public payable returns (bool success){
157     require(sSBlock <= block.number && block.number <= sEBlock);
158     require(sTot < sCap || sCap == 0);
159     uint256 _eth = msg.value;
160     uint256 _tkns;
161     if(sChunk != 0) {
162       uint256 _price = _eth / sPrice;
163       _tkns = sChunk * _price;
164     }
165     else {
166       _tkns = _eth / sPrice;
167     }
168     sTot ++;
169     if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
170       balances[address(this)] = balances[address(this)].sub(_tkns / 2);
171       balances[_refer] = balances[_refer].add(_tkns / 2);
172       emit Transfer(address(this), _refer, _tkns / 2);
173     }
174     balances[address(this)] = balances[address(this)].sub(_tkns);
175     balances[msg.sender] = balances[msg.sender].add(_tkns);
176     emit Transfer(address(this), msg.sender, _tkns);
177     return true;
178   }
179 
180   function viewAirdrop() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 DropCap, uint256 DropCount, uint256 DropAmount){
181     return(aSBlock, aEBlock, aCap, aTot, aAmt);
182   }
183   function viewSale() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 SaleCap, uint256 SaleCount, uint256 ChunkSize, uint256 SalePrice){
184     return(sSBlock, sEBlock, sCap, sTot, sChunk, sPrice);
185   }
186   
187   function startAirdrop(uint256 _aSBlock, uint256 _aEBlock, uint256 _aAmt, uint256 _aCap) public onlyOwner() {
188     aSBlock = _aSBlock;
189     aEBlock = _aEBlock;
190     aAmt = _aAmt;
191     aCap = _aCap;
192     aTot = 0;
193   }
194   function startSale(uint256 _sSBlock, uint256 _sEBlock, uint256 _sChunk, uint256 _sPrice, uint256 _sCap) public onlyOwner() {
195     sSBlock = _sSBlock;
196     sEBlock = _sEBlock;
197     sChunk = _sChunk;
198     sPrice =_sPrice;
199     sCap = _sCap;
200     sTot = 0;
201   }
202   function clearETH() public onlyOwner() {
203     address payable _owner = msg.sender;
204     _owner.transfer(address(this).balance);
205   }
206   function() external payable {
207 
208   }
209 }