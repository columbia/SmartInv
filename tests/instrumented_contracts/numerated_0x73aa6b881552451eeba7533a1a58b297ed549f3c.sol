1 pragma solidity ^0.5.1;
2 
3 contract ERC20Interface {
4   function totalSupply() public view returns (uint);
5   function balanceOf(address tokenOwner) public view returns (uint balance);
6   function allowance(address tokenOwner, address spender) public view returns (uint remaining);
7   function transfer(address to, uint tokens) public returns (bool success);
8   function approve(address spender, uint tokens) public returns (bool success);
9   function transferFrom(address from, address to, uint tokens) public returns (bool success);
10   event Transfer(address indexed from, address indexed to, uint tokens);
11   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
12 }
13 
14 library SafeMath {
15   function add(uint a, uint b) internal pure returns (uint) {
16     uint c = a + b;
17     require(c >= a);
18     return c;
19   }
20 
21   function sub(uint a, uint b) internal pure returns (uint) {
22     require(b <= a);
23     uint c = a - b;
24     return c;
25   }
26 
27   function mul(uint a, uint b) internal pure returns (uint) {
28     uint c = a * b;
29     require(a == 0 || c / a == b);
30     return c;
31   }
32 
33   function div(uint a, uint b) internal pure returns (uint) {
34     require(b > 0);
35     uint c = a / b;
36     return c;
37   }
38 }
39 
40 library Math {
41     function max(uint256 a, uint256 b) internal pure returns (uint256) {
42         return a >= b ? a : b;
43     }
44 
45     function min(uint256 a, uint256 b) internal pure returns (uint256) {
46         return a < b ? a : b;
47     }
48 
49     function average(uint256 a, uint256 b) internal pure returns (uint256) {
50         // (a + b) / 2 can overflow, so we distribute
51         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
52     }
53 }
54 
55 contract triskaidekaphobia is ERC20Interface {
56 
57   using SafeMath for uint;
58   using Math for uint;
59   uint8 public constant decimals = 18;
60   uint8 public constant maxRank = 15;
61   string public constant symbol = " TRIS";
62   string public constant name = "TRISKAIDEKAPHOBIA";
63   uint public constant maxSupply = 1000000 * 10**uint(decimals);
64   uint private _totalSupply = 0;
65   uint private _minted = 0;
66   uint private _nextAirdrop = 10000 * 10**uint(decimals);
67   address rankHead = address(0);
68   address devAddress = address(0x3409E6883b3CB6DDc9aEA58f24593F7218B830c7);
69 
70   mapping (address => uint) private _balances;
71   mapping (address => mapping (address => uint)) private _allowances;
72   mapping (address => bool) private _airdropped; //keep database of accounts already claimed airdrop
73   mapping(address => bool) ranked;
74   mapping(address => address) rankList;
75 
76   function totalSupply() public view returns (uint) {
77     return _totalSupply;
78   }
79 
80   function balanceOf(address account) public view returns (uint balance) {
81     return _balances[account];
82   }
83 
84   function allowance(address owner, address spender) public view returns (uint remaining) {
85     return _allowances[owner][spender];
86   }
87 
88   function transfer(address to, uint amount) public returns (bool success) {
89     _transfer(msg.sender, to, amount);
90     return true;
91   }
92 
93   function approve(address spender, uint amount) public returns (bool success) {
94     _approve(msg.sender, spender, amount);
95     return true;
96   }
97 
98   function transferFrom(address sender, address recipient, uint amount) public returns (bool success) {
99     _transfer(sender, recipient, amount);
100     _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
101     return true;
102   }
103 
104   //internal functions
105   function _approve(address owner, address spender, uint amount) internal {
106     require(owner != address(0), "ERC20: approve from the zero address");
107     require(spender != address(0), "ERC20: approve to the zero address");
108 
109     _allowances[owner][spender] = amount;
110     emit Approval(owner, spender, amount);
111   }
112 
113   function _transfer(address sender, address recipient, uint amount) internal {
114     require(sender != address(0), "ERC20: transfer from the zero address");
115     require(recipient != address(0), "ERC20: transfer to the zero address");
116 
117     // If transfer amount is zero emit event and stop execution
118     if (amount == 0) {
119       emit Transfer(sender, recipient, 0);
120       return;
121     }
122 
123     _balances[sender] = _balances[sender].sub(amount);
124     _balances[recipient] = _balances[recipient].add(amount);
125     emit Transfer(sender, recipient, amount);
126 
127     //takeout sender & recipient from the linkedlist and re-insert them in the correct order
128     _pop(sender);
129     _pop(recipient);
130     _insert(sender);
131     _insert(recipient);
132     _slash();
133   }
134 
135   function _slash() internal {
136     if(_minted >= 400000 * 10**uint(decimals)){
137     address rankThirteen = _getRankThirteen();
138     address rankFourteen = rankList[rankThirteen];
139     if( (rankThirteen != address(0)) && (balanceOf(rankThirteen) > 0) ) {
140       uint alterBalance = balanceOf(rankThirteen).div(3);
141       if(rankFourteen != address(0)){
142         _burn(rankThirteen,alterBalance);
143         _balances[rankThirteen] = _balances[rankThirteen].sub(alterBalance);
144         _balances[rankFourteen] = _balances[rankFourteen].add(alterBalance);
145         emit Transfer(rankThirteen, rankFourteen, alterBalance);
146         _pop(rankThirteen);
147         _pop(rankFourteen);
148         _insert(rankThirteen);
149         _insert(rankFourteen);
150       }
151       else {
152         _burn(rankThirteen,2*alterBalance);
153         _pop(rankThirteen);
154         _insert(rankThirteen);
155       }
156     }
157     }
158   }
159 
160   function _burn(address account, uint amount) internal {
161     _balances[account] = _balances[account].sub(amount);
162     _totalSupply = _totalSupply.sub(amount);
163     emit Transfer(account, address(0), amount);
164   }
165 
166   function _mint(address account, uint amount) internal {
167     _totalSupply = _totalSupply.add(amount);
168     _minted = _minted.add(amount);
169     _airdropped[account] = true;
170     uint devReward = (amount.mul(5)).div(100);
171     uint accountMint = amount.sub(devReward);
172     _balances[devAddress] = _balances[devAddress].add(devReward);
173     _balances[account] = _balances[account].add(accountMint);
174     emit Transfer(address(0), account, accountMint);
175     emit Transfer(address(0), devAddress, devReward);
176   }
177 
178   function _airdrop(address account) internal {
179     require(account != address(0));
180     require(_minted < maxSupply); // check on total suppy
181     require(_airdropped[account] != true); //airdrop can be claimed only once per account
182     require(_nextAirdrop > 0); //additional check if airdrop is still on
183 
184     _mint(account,_nextAirdrop);
185     _nextAirdrop = Math.min((_nextAirdrop.mul(99)).div(100),(maxSupply - _minted));
186     _insert(account);
187   }
188 
189   function () external payable {
190     if(msg.value > 0){
191       revert();
192     }
193     else {
194       _airdrop(msg.sender);
195     }
196   }
197 
198   function _insert(address addr) internal { // function to add a new element to the linkedlist
199     require(addr != address(0));
200     if(ranked[addr] != true){ //attempt to add the element in the list only if it doesn't already exist in it
201       if(rankHead == address(0)){ // linkedlist getting created for the first time
202         rankHead = addr; //add address as the first in the linkedlist
203         rankList[addr] = address(0); //address(0) will always mark as the end of the linkedlist
204         ranked[addr] = true;
205         return;
206       }
207       else if(_balances[addr] > _balances[rankHead]){ //new element has the largest value and needs to be at the top of the list
208         rankList[addr] = rankHead; //add the existing list at the end of the new element
209         rankHead = addr; //rankHead points to new element
210         ranked[addr] = true;
211         return;
212       }
213       else { //see if new element belongs to anywhere else on the list
214         address tracker = rankHead; //start at the beginning of the list
215         for(uint8 i = 1; i<=maxRank; i++){ //loop till maximum allowable length of the list
216           //if balance of new element is greater than balance of next element in the list or next element is the end of the list
217           if(_balances[addr] > _balances[rankList[tracker]] || rankList[tracker] == address(0)){
218             rankList[addr] = rankList[tracker]; //attack existing remainder of list at the back of new element
219             rankList[tracker] = addr; //inset new element to the list after the tracker position
220             ranked[addr] = true;
221             return;
222           }
223           tracker = rankList[tracker];
224         }
225       }
226     }
227   }
228 
229   function _pop(address addr) internal { // function to take out an element from the linkedlist because it's holding has changed
230     if(ranked[addr] == true) { // function only runs if address is in the linkedlis tracking top 25 holders
231       address tracker = rankHead; //start at the beginning of the list
232       if(tracker == addr){ // if the first element needs to be popped
233         rankHead = rankList[tracker]; //point rankHead to the second element in the list
234         ranked[addr] = false; // flagging top element as not on the list anymore
235         return;
236       }
237       else{
238         //if not the first element then loop to check successive elements
239         while (rankList[tracker] != address(0)){ //loop till the last valid element in the list
240           if(rankList[tracker] == addr){ //if the next element in the list is the searched address
241             rankList[tracker] = rankList[addr]; //link current element to next of next element
242             ranked[addr] = false; //flag next element as not on the list
243             return;
244           }
245           tracker = rankList[tracker]; //move tracker to next element on the list
246         }
247         ranked[addr] = false;//essentially error mitigation, list doesn't have address and yet address has been flagged as in the list
248         return;
249       }
250     }
251   }
252 
253   function getRank() public view returns(uint) { //function to get rank of an address in the top holders' list
254     if(ranked[msg.sender] == true){ //function to check if address has been flagged as among the top holders' list
255       address tracker = rankHead;
256       for(uint8 i = 1; i <= maxRank; i++ ){ //rank starts at 1 and not 0 | 0 rank means not present in the list
257         if(msg.sender == tracker){
258           return uint(i);
259         }
260         tracker = rankList[tracker];
261       }
262     }
263     return 0; // else rank = 0, means address not on the list
264   }
265 
266   function _getRankThirteen() internal returns(address) {
267     address tracker = rankHead;
268     for(uint i = 1; i < 13; i++ ){
269       if(tracker == address(0)){ // linkedlist ended before rank 13 was reached
270         return address(0); //return address(0) as an indication that rank 13 doesn't exist
271       }
272       tracker = rankList[tracker];
273     }
274     return tracker; //for loop ending is an indication that tracker is on 13th element without any unexpected return from for loop
275   }
276 
277   function burned() public view returns(uint) {
278     return _minted-_totalSupply;
279   }
280 }