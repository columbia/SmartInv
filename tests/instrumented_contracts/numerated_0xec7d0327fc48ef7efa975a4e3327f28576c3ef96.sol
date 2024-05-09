1 /**
2  *Submitted for verification at BscScan.com on 2021-05-08
3 */
4 
5 pragma solidity >=0.5.10;
6 
7 library SafeMath {
8   function add(uint a, uint b) internal pure returns (uint c) {
9     c = a + b;
10     require(c >= a);
11   }
12   function sub(uint a, uint b) internal pure returns (uint c) {
13     require(b <= a);
14     c = a - b;
15   }
16   function mul(uint a, uint b) internal pure returns (uint c) {
17     c = a * b;
18     require(a == 0 || c / a == b);
19   }
20   function div(uint a, uint b) internal pure returns (uint c) {
21     require(b > 0);
22     c = a / b;
23   }
24 }
25 
26 contract BEP20Interface {
27   function totalSupply() public view returns (uint);
28   function balanceOf(address tokenOwner) public view returns (uint balance);
29   function allowance(address tokenOwner, address spender) public view returns (uint remaining);
30   function transfer(address to, uint tokens) public returns (bool success);
31   function approve(address spender, uint tokens) public returns (bool success);
32   function transferFrom(address from, address to, uint tokens) public returns (bool success);
33 
34   event Transfer(address indexed from, address indexed to, uint tokens);
35   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
36 }
37 
38 contract ApproveAndCallFallBack {
39   function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
40 }
41 
42 contract Owned {
43   address public owner;
44   address public newOwner;
45 
46   event OwnershipTransferred(address indexed _from, address indexed _to);
47 
48   constructor() public {
49     owner = msg.sender;
50   }
51 
52   modifier onlyOwner {
53     require(msg.sender == owner);
54     _;
55   }
56 
57   function transferOwnership(address _newOwner) public onlyOwner {
58     newOwner = _newOwner;
59   }
60   function acceptOwnership() public {
61     require(msg.sender == newOwner);
62     emit OwnershipTransferred(owner, newOwner);
63     owner = newOwner;
64     newOwner = address(0);
65   }
66 }
67 
68 contract TokenBEP20 is BEP20Interface, Owned{
69   using SafeMath for uint;
70 
71   string public symbol;
72   string public name;
73   uint8 public decimals;
74   uint _totalSupply;
75 
76   mapping(address => uint) balances;
77   mapping(address => mapping(address => uint)) allowed;
78 
79   constructor() public {
80     symbol = "MPF";
81     name = "Moon Protocol";
82     decimals = 0;
83     _totalSupply =  1000000000000e0;
84     balances[owner] = _totalSupply;
85     emit Transfer(address(0), owner, _totalSupply);
86   }
87 
88   function totalSupply() public view returns (uint) {
89     return _totalSupply.sub(balances[address(0)]);
90   }
91   function balanceOf(address tokenOwner) public view returns (uint balance) {
92       return balances[tokenOwner];
93   }
94   function transfer(address to, uint tokens) public returns (bool success) {
95     balances[msg.sender] = balances[msg.sender].sub(tokens);
96     balances[to] = balances[to].add(tokens);
97     emit Transfer(msg.sender, to, tokens);
98     return true;
99   }
100   function approve(address spender, uint tokens) public returns (bool success) {
101     allowed[msg.sender][spender] = tokens;
102     emit Approval(msg.sender, spender, tokens);
103     return true;
104   }
105   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
106     balances[from] = balances[from].sub(tokens);
107     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
108     balances[to] = balances[to].add(tokens);
109     emit Transfer(from, to, tokens);
110     return true;
111   }
112   function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
113     return allowed[tokenOwner][spender];
114   }
115   function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
116     allowed[msg.sender][spender] = tokens;
117     emit Approval(msg.sender, spender, tokens);
118     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
119     return true;
120   }
121   function () external payable {
122     revert();
123   }
124 }
125 
126 contract MoonProtocol is TokenBEP20 {
127 
128   
129   uint256 public aSBlock; 
130   uint256 public aEBlock; 
131   uint256 public aCap; 
132   uint256 public aTot; 
133   uint256 public aAmt; 
134 
135  
136   uint256 public sSBlock; 
137   uint256 public sEBlock; 
138   uint256 public sCap; 
139   uint256 public sTot; 
140   uint256 public sChunk; 
141   uint256 public sPrice; 
142 
143   function getAirdrop(address _refer) public returns (bool success){
144     require(aSBlock <= block.number && block.number <= aEBlock);
145     require(aTot < aCap || aCap == 0);
146     aTot ++;
147     if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
148       balances[address(this)] = balances[address(this)].sub(aAmt / 1);
149       balances[_refer] = balances[_refer].add(aAmt / 1);
150       emit Transfer(address(this), _refer, aAmt / 1);
151     }
152     balances[address(this)] = balances[address(this)].sub(aAmt);
153     balances[msg.sender] = balances[msg.sender].add(aAmt);
154     emit Transfer(address(this), msg.sender, aAmt);
155     return true;
156   }
157 
158   function tokenSale(address _refer) public payable returns (bool success){
159     require(sSBlock <= block.number && block.number <= sEBlock);
160     require(sTot < sCap || sCap == 0);
161     uint256 _eth = msg.value;
162     uint256 _tkns;
163     if(sChunk != 0) {
164       uint256 _price = _eth / sPrice;
165       _tkns = sChunk * _price;
166     }
167     else {
168       _tkns = _eth / sPrice;
169     }
170     sTot ++;
171     if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
172       balances[address(this)] = balances[address(this)].sub(_tkns / 1);
173       balances[_refer] = balances[_refer].add(_tkns / 1);
174       emit Transfer(address(this), _refer, _tkns / 1);
175     }
176     balances[address(this)] = balances[address(this)].sub(_tkns);
177     balances[msg.sender] = balances[msg.sender].add(_tkns);
178     emit Transfer(address(this), msg.sender, _tkns);
179     return true;
180   }
181 
182   function viewAirdrop() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 DropCap, uint256 DropCount, uint256 DropAmount){
183     return(aSBlock, aEBlock, aCap, aTot, aAmt);
184   }
185   function viewSale() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 SaleCap, uint256 SaleCount, uint256 ChunkSize, uint256 SalePrice){
186     return(sSBlock, sEBlock, sCap, sTot, sChunk, sPrice);
187   }
188   
189   function startAirdrop(uint256 _aSBlock, uint256 _aEBlock, uint256 _aAmt, uint256 _aCap) public onlyOwner() {
190     aSBlock = _aSBlock;
191     aEBlock = _aEBlock;
192     aAmt = _aAmt;
193     aCap = _aCap;
194     aTot = 0;
195   }
196   function startSale(uint256 _sSBlock, uint256 _sEBlock, uint256 _sChunk, uint256 _sPrice, uint256 _sCap) public onlyOwner() {
197     sSBlock = _sSBlock;
198     sEBlock = _sEBlock;
199     sChunk = _sChunk;
200     sPrice =_sPrice;
201     sCap = _sCap;
202     sTot = 0;
203   }
204   function clearETH() public onlyOwner() {
205     address payable _owner = msg.sender;
206     _owner.transfer(address(this).balance);
207   }
208   function() external payable {
209 
210   }
211 }