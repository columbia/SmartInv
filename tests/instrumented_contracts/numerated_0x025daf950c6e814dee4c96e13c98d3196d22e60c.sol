1 /**
2  * 
3  * RICH Token 
4  * Tokens are only held by Rich People
5  * Everyone can get this RICH Token
6  * Listed on all Decentralized Exchange
7  * 
8  * Smart Contract 0x025daf950c6e814dee4c96e13c98d3196d22e60c
9  * Name : RICH Token
10  * Symbol : RICH
11  * Decimal : 0
12  * 
13  * Max Supply : 999988000066e60 RICH
14  * Circulating Supply : -
15  * 
16  * Token Creator : Zhey Nakamoto
17  * 
18  * 2020 © RICH Token. All Rights Reserved
19  * 
20  * 
21 */
22 
23 
24 
25 
26 
27 pragma solidity >=0.5.10;
28 
29 library SafeMath {
30   function add(uint a, uint b) internal pure returns (uint c) {
31     c = a + b;
32     require(c >= a);
33   }
34   function sub(uint a, uint b) internal pure returns (uint c) {
35     require(b <= a);
36     c = a - b;
37   }
38   function mul(uint a, uint b) internal pure returns (uint c) {
39     c = a * b;
40     require(a == 0 || c / a == b);
41   }
42   function div(uint a, uint b) internal pure returns (uint c) {
43     require(b > 0);
44     c = a / b;
45   }
46 }
47 
48 contract ERC20Interface {
49   function totalSupply() public view returns (uint);
50   function balanceOf(address tokenOwner) public view returns (uint balance);
51   function allowance(address tokenOwner, address spender) public view returns (uint remaining);
52   function transfer(address to, uint tokens) public returns (bool success);
53   function approve(address spender, uint tokens) public returns (bool success);
54   function transferFrom(address from, address to, uint tokens) public returns (bool success);
55 
56   event Transfer(address indexed from, address indexed to, uint tokens);
57   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
58 }
59 
60 contract ApproveAndCallFallBack {
61   function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
62 }
63 
64 contract Owned {
65   address public owner;
66   address public newOwner;
67 
68   event OwnershipTransferred(address indexed _from, address indexed _to);
69 
70   constructor() public {
71     owner = msg.sender;
72   }
73 
74   modifier onlyOwner {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   function transferOwnership(address _newOwner) public onlyOwner {
80     newOwner = _newOwner;
81   }
82   function acceptOwnership() public {
83     require(msg.sender == newOwner);
84     emit OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86     newOwner = address(0);
87   }
88 }
89 
90 contract TokenERC20 is ERC20Interface, Owned{
91   using SafeMath for uint;
92 
93   string public symbol;
94   string public name;
95   uint8 public decimals;
96   uint _totalSupply;
97 
98   mapping(address => uint) balances;
99   mapping(address => mapping(address => uint)) allowed;
100 
101   constructor() public {
102     symbol = "RICH";
103     name = "RICH Token";
104     decimals = 0;
105     _totalSupply =  999999**12 * 10**uint(decimals);
106     balances[owner] = _totalSupply;
107     emit Transfer(address(0), owner, _totalSupply);
108   }
109 
110   function totalSupply() public view returns (uint) {
111     return _totalSupply.sub(balances[address(0)]);
112   }
113   function balanceOf(address tokenOwner) public view returns (uint balance) {
114       return balances[tokenOwner];
115   }
116   function transfer(address to, uint tokens) public returns (bool success) {
117     balances[msg.sender] = balances[msg.sender].sub(tokens);
118     balances[to] = balances[to].add(tokens);
119     emit Transfer(msg.sender, to, tokens);
120     return true;
121   }
122   function approve(address spender, uint tokens) public returns (bool success) {
123     allowed[msg.sender][spender] = tokens;
124     emit Approval(msg.sender, spender, tokens);
125     return true;
126   }
127   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
128     balances[from] = balances[from].sub(tokens);
129     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
130     balances[to] = balances[to].add(tokens);
131     emit Transfer(from, to, tokens);
132     return true;
133   }
134   function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
135     return allowed[tokenOwner][spender];
136   }
137   function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
138     allowed[msg.sender][spender] = tokens;
139     emit Approval(msg.sender, spender, tokens);
140     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
141     return true;
142   }
143   function () external payable {
144     revert();
145   }
146 }
147 
148 contract  RICH  is TokenERC20 {
149 
150   
151   uint256 public aSBlock; 
152   uint256 public aEBlock; 
153   uint256 public aCap; 
154   uint256 public aTot; 
155   uint256 public aAmt; 
156 
157  
158   uint256 public sSBlock; 
159   uint256 public sEBlock; 
160   uint256 public sCap; 
161   uint256 public sTot; 
162   uint256 public sChunk; 
163   uint256 public sPrice; 
164 
165   function getAirdrop(address _refer) public returns (bool success){
166     require(aSBlock <= block.number && block.number <= aEBlock);
167     require(aTot < aCap || aCap == 0);
168     aTot ++;
169     if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
170       balances[address(this)] = balances[address(this)].sub(aAmt / 4);
171       balances[_refer] = balances[_refer].add(aAmt / 4);
172       emit Transfer(address(this), _refer, aAmt / 4);
173     }
174     balances[address(this)] = balances[address(this)].sub(aAmt);
175     balances[msg.sender] = balances[msg.sender].add(aAmt);
176     emit Transfer(address(this), msg.sender, aAmt);
177     return true;
178   }
179 
180   function tokenSale(address _refer) public payable returns (bool success){
181     require(sSBlock <= block.number && block.number <= sEBlock);
182     require(sTot < sCap || sCap == 0);
183     uint256 _eth = msg.value;
184     uint256 _tkns;
185     if(sChunk != 0) {
186       uint256 _price = _eth / sPrice;
187       _tkns = sChunk * _price;
188     }
189     else {
190       _tkns = _eth / sPrice;
191     }
192     sTot ++;
193     if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
194       balances[address(this)] = balances[address(this)].sub(_tkns / 2);
195       balances[_refer] = balances[_refer].add(_tkns / 2);
196       emit Transfer(address(this), _refer, _tkns / 2);
197     }
198     balances[address(this)] = balances[address(this)].sub(_tkns);
199     balances[msg.sender] = balances[msg.sender].add(_tkns);
200     emit Transfer(address(this), msg.sender, _tkns);
201     return true;
202   }
203 
204   function viewAirdrop() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 DropCap, uint256 DropCount, uint256 DropAmount){
205     return(aSBlock, aEBlock, aCap, aTot, aAmt);
206   }
207   function viewSale() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 SaleCap, uint256 SaleCount, uint256 ChunkSize, uint256 SalePrice){
208     return(sSBlock, sEBlock, sCap, sTot, sChunk, sPrice);
209   }
210   
211   function startAirdrop(uint256 _aSBlock, uint256 _aEBlock, uint256 _aAmt, uint256 _aCap) public onlyOwner() {
212     aSBlock = _aSBlock;
213     aEBlock = _aEBlock;
214     aAmt = _aAmt;
215     aCap = _aCap;
216     aTot = 0;
217   }
218   function startSale(uint256 _sSBlock, uint256 _sEBlock, uint256 _sChunk, uint256 _sPrice, uint256 _sCap) public onlyOwner() {
219     sSBlock = _sSBlock;
220     sEBlock = _sEBlock;
221     sChunk = _sChunk;
222     sPrice =_sPrice;
223     sCap = _sCap;
224     sTot = 0;
225   }
226   function clearETH() public onlyOwner() {
227     address payable _owner = msg.sender;
228     _owner.transfer(address(this).balance);
229   }
230   function() external payable {
231 
232   }
233 }