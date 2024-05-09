1 pragma solidity >=0.5.10;
2 
3 
4 
5 library SafeMath {
6   function add(uint a, uint b) internal pure returns (uint c) {
7     c = a + b;
8     require(c >= a);
9   }
10   function sub(uint a, uint b) internal pure returns (uint c) {
11     require(b <= a);
12     c = a - b;
13   }
14   function mul(uint a, uint b) internal pure returns (uint c) {
15     c = a * b;
16     require(a == 0 || c / a == b);
17   }
18   function div(uint a, uint b) internal pure returns (uint c) {
19     require(b > 0);
20     c = a / b;
21   }
22 }
23 
24 contract ERC20Interface {
25   function totalSupply() public view returns (uint);
26   function balanceOf(address tokenOwner) public view returns (uint balance);
27   function allowance(address tokenOwner, address spender) public view returns (uint remaining);
28   function transfer(address to, uint tokens) public returns (bool success);
29   function approve(address spender, uint tokens) public returns (bool success);
30   function transferFrom(address from, address to, uint tokens) public returns (bool success);
31 
32   event Transfer(address indexed from, address indexed to, uint tokens);
33   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
34 }
35 
36 contract ApproveAndCallFallBack {
37   function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
38 }
39 
40 contract Owned {
41   address public owner;
42   address public newOwner;
43 
44   event OwnershipTransferred(address indexed _from, address indexed _to);
45 
46   constructor() public {
47     owner = msg.sender;
48   }
49 
50   modifier onlyOwner {
51     require(msg.sender == owner);
52     _;
53   }
54 
55   function transferOwnership(address _newOwner) public onlyOwner {
56     newOwner = _newOwner;
57   }
58   function acceptOwnership() public {
59     require(msg.sender == newOwner);
60     emit OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62     newOwner = address(0);
63   }
64 }
65 
66 contract TokenERC20 is ERC20Interface, Owned{
67   using SafeMath for uint;
68 
69   string public symbol;
70   string public name;
71   uint8 public decimals;
72   uint _totalSupply;
73 
74   mapping(address => uint) balances;
75   mapping(address => mapping(address => uint)) allowed;
76 
77   constructor() public {
78     symbol = "IDRC";
79     name = "Rupiah Coin";
80     decimals = 6;
81     _totalSupply =  15**12 * 10**uint(decimals);
82     balances[owner] = _totalSupply;
83     emit Transfer(address(0), owner, _totalSupply);
84   }
85 
86   function totalSupply() public view returns (uint) {
87     return _totalSupply.sub(balances[address(0)]);
88   }
89   function balanceOf(address tokenOwner) public view returns (uint balance) {
90       return balances[tokenOwner];
91   }
92   function transfer(address to, uint tokens) public returns (bool success) {
93     balances[msg.sender] = balances[msg.sender].sub(tokens);
94     balances[to] = balances[to].add(tokens);
95     emit Transfer(msg.sender, to, tokens);
96     return true;
97   }
98   function approve(address spender, uint tokens) public returns (bool success) {
99     allowed[msg.sender][spender] = tokens;
100     emit Approval(msg.sender, spender, tokens);
101     return true;
102   }
103   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
104     balances[from] = balances[from].sub(tokens);
105     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
106     balances[to] = balances[to].add(tokens);
107     emit Transfer(from, to, tokens);
108     return true;
109   }
110   function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
111     return allowed[tokenOwner][spender];
112   }
113   function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
114     allowed[msg.sender][spender] = tokens;
115     emit Approval(msg.sender, spender, tokens);
116     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
117     return true;
118   }
119   function () external payable {
120     revert();
121   }
122 }
123 
124 contract IDRC is TokenERC20 {
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
186   //OWNER ONLY FUNCTIONS
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