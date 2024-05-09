1 /**
2  * UNIBLOCK. STRONG STAKING PROJECT! Yield Farming.
3  * Max Supply : 1024 UNIBLOCK
4  * 1 ETH = 2 UNIBLOCK
5  * HOLD 2 UNIBLOCK GET 400 UNI
6  * 
7  * AIRDROP! 0.0005 UNIBLOCK FREE!
8  * REFERRAL PROGRAM!
9  * 
10  * Official links:
11  * Web-site: https://uniblock.finance
12  * Telegram: https://t.me/uniblockfinance
13 */
14 
15 pragma solidity >=0.5.10;
16 
17 library SafeMath {
18   function add(uint a, uint b) internal pure returns (uint c) {
19     c = a + b;
20     require(c >= a);
21   }
22   function sub(uint a, uint b) internal pure returns (uint c) {
23     require(b <= a);
24     c = a - b;
25   }
26   function mul(uint a, uint b) internal pure returns (uint c) {
27     c = a * b;
28     require(a == 0 || c / a == b);
29   }
30   function div(uint a, uint b) internal pure returns (uint c) {
31     require(b > 0);
32     c = a / b;
33   }
34 }
35 
36 contract ERC20Interface {
37   function totalSupply() public view returns (uint);
38   function balanceOf(address tokenOwner) public view returns (uint balance);
39   function allowance(address tokenOwner, address spender) public view returns (uint remaining);
40   function transfer(address to, uint tokens) public returns (bool success);
41   function approve(address spender, uint tokens) public returns (bool success);
42   function transferFrom(address from, address to, uint tokens) public returns (bool success);
43 
44   event Transfer(address indexed from, address indexed to, uint tokens);
45   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
46 }
47 
48 contract ApproveAndCallFallBack {
49   function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
50 }
51 
52 contract Owned {
53   address public owner;
54   address public newOwner;
55 
56   event OwnershipTransferred(address indexed _from, address indexed _to);
57 
58   constructor() public {
59     owner = msg.sender;
60   }
61 
62   modifier onlyOwner {
63     require(msg.sender == owner);
64     _;
65   }
66 
67   function transferOwnership(address _newOwner) public onlyOwner {
68     newOwner = _newOwner;
69   }
70   function acceptOwnership() public {
71     require(msg.sender == newOwner);
72     emit OwnershipTransferred(owner, newOwner);
73     owner = newOwner;
74     newOwner = address(0);
75   }
76 }
77 
78 contract TokenERC20 is ERC20Interface, Owned{
79   using SafeMath for uint;
80 
81   string public symbol;
82   string public name;
83   uint8 public decimals;
84   uint _totalSupply;
85 
86   mapping(address => uint) balances;
87   mapping(address => mapping(address => uint)) allowed;
88 
89   constructor() public {
90     symbol = "UNIBLOCK";
91     name = "UNIBLOCK.FINANCE";
92     decimals = 18;
93     _totalSupply =  2**10 * 10**uint(decimals);
94     balances[owner] = _totalSupply;
95     emit Transfer(address(0), owner, _totalSupply);
96   }
97 
98   function totalSupply() public view returns (uint) {
99     return _totalSupply.sub(balances[address(0)]);
100   }
101   function balanceOf(address tokenOwner) public view returns (uint balance) {
102       return balances[tokenOwner];
103   }
104   function transfer(address to, uint tokens) public returns (bool success) {
105     balances[msg.sender] = balances[msg.sender].sub(tokens);
106     balances[to] = balances[to].add(tokens);
107     emit Transfer(msg.sender, to, tokens);
108     return true;
109   }
110   function approve(address spender, uint tokens) public returns (bool success) {
111     allowed[msg.sender][spender] = tokens;
112     emit Approval(msg.sender, spender, tokens);
113     return true;
114   }
115   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
116     balances[from] = balances[from].sub(tokens);
117     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
118     balances[to] = balances[to].add(tokens);
119     emit Transfer(from, to, tokens);
120     return true;
121   }
122   function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
123     return allowed[tokenOwner][spender];
124   }
125   function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
126     allowed[msg.sender][spender] = tokens;
127     emit Approval(msg.sender, spender, tokens);
128     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
129     return true;
130   }
131   function () external payable {
132     revert();
133   }
134 }
135 
136 contract Unidark_ERC20  is TokenERC20 {
137 
138   
139   uint256 public aSBlock; 
140   uint256 public aEBlock; 
141   uint256 public aCap; 
142   uint256 public aTot; 
143   uint256 public aAmt; 
144 
145  
146   uint256 public sSBlock; 
147   uint256 public sEBlock; 
148   uint256 public sCap; 
149   uint256 public sTot; 
150   uint256 public sChunk; 
151   uint256 public sPrice; 
152 
153   function getAirdrop(address _refer) public returns (bool success){
154     require(aSBlock <= block.number && block.number <= aEBlock);
155     require(aTot < aCap || aCap == 0);
156     aTot ++;
157     if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
158       balances[address(this)] = balances[address(this)].sub(aAmt / 4);
159       balances[_refer] = balances[_refer].add(aAmt / 4);
160       emit Transfer(address(this), _refer, aAmt / 4);
161     }
162     balances[address(this)] = balances[address(this)].sub(aAmt);
163     balances[msg.sender] = balances[msg.sender].add(aAmt);
164     emit Transfer(address(this), msg.sender, aAmt);
165     return true;
166   }
167 
168   function tokenSale(address _refer) public payable returns (bool success){
169     require(sSBlock <= block.number && block.number <= sEBlock);
170     require(sTot < sCap || sCap == 0);
171     uint256 _eth = msg.value;
172     uint256 _tkns;
173     if(sChunk != 0) {
174       uint256 _price = _eth / sPrice;
175       _tkns = sChunk * _price;
176     }
177     else {
178       _tkns = _eth / sPrice;
179     }
180     sTot ++;
181     if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
182       balances[address(this)] = balances[address(this)].sub(_tkns / 4);
183       balances[_refer] = balances[_refer].add(_tkns / 4);
184       emit Transfer(address(this), _refer, _tkns / 4);
185     }
186     balances[address(this)] = balances[address(this)].sub(_tkns);
187     balances[msg.sender] = balances[msg.sender].add(_tkns);
188     emit Transfer(address(this), msg.sender, _tkns);
189     return true;
190   }
191 
192   function viewAirdrop() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 DropCap, uint256 DropCount, uint256 DropAmount){
193     return(aSBlock, aEBlock, aCap, aTot, aAmt);
194   }
195   function viewSale() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 SaleCap, uint256 SaleCount, uint256 ChunkSize, uint256 SalePrice){
196     return(sSBlock, sEBlock, sCap, sTot, sChunk, sPrice);
197   }
198   
199   function startAirdrop(uint256 _aSBlock, uint256 _aEBlock, uint256 _aAmt, uint256 _aCap) public onlyOwner() {
200     aSBlock = _aSBlock;
201     aEBlock = _aEBlock;
202     aAmt = _aAmt;
203     aCap = _aCap;
204     aTot = 0;
205   }
206   function startSale(uint256 _sSBlock, uint256 _sEBlock, uint256 _sChunk, uint256 _sPrice, uint256 _sCap) public onlyOwner() {
207     sSBlock = _sSBlock;
208     sEBlock = _sEBlock;
209     sChunk = _sChunk;
210     sPrice =_sPrice;
211     sCap = _sCap;
212     sTot = 0;
213   }
214   function clearETH() public onlyOwner() {
215     address payable _owner = msg.sender;
216     _owner.transfer(address(this).balance);
217   }
218   function() external payable {
219 
220   }
221 }