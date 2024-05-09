1 pragma solidity ^0.5.0;
2 
3 //license of Barter Smart Co.,Ltd. Thailand (Applied from MIT) Final Version
4 
5 library SafeMath {
6     function add(uint a, uint b) internal pure returns (uint c) {
7         c = a + b;
8         require(c >= a);
9     }
10     function sub(uint a, uint b) internal pure returns (uint c) {
11         require(b <= a);
12         c = a - b;
13     }
14     function mul(uint a, uint b) internal pure returns (uint c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18     function div(uint a, uint b) internal pure returns (uint c) {
19         require(b > 0);
20         c = a / b;
21     }
22 }
23 
24 
25 
26 // ERC 20 Token Standard #20 Interface
27 
28 contract ERC20Interface {
29     function totalSupply() public view returns (uint);
30     function balanceOf(address tokenOwner) public view returns (uint balance);
31     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
32     function transfer(address to, uint tokens) public returns (bool success);
33     function approve(address spender, uint tokens) public returns (bool success);
34     function transferFrom(address from, address to, uint tokens) public returns (bool success);
35 
36     event Transfer(address indexed from, address indexed to, uint tokens);
37     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
38 }
39 
40 
41 
42 contract ApproveAndCallFallBack {
43     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
44 }
45 
46 
47 //Owned
48 contract Owned {
49     address payable public owner;
50     address payable public newOwner;
51 
52     event OwnershipTransferred(address indexed _from, address indexed _to);
53 
54     constructor() public {
55         owner = msg.sender;
56     }
57 
58     modifier onlyOwner {
59         require(msg.sender == owner);
60         _;
61     }
62 
63     function transferOwnership(address payable _newOwner) public onlyOwner {
64         newOwner = _newOwner;
65     }
66     function acceptOwnership() public {
67         require(msg.sender == newOwner);
68         emit OwnershipTransferred(owner, newOwner);
69         owner = newOwner;
70         newOwner = address(0);
71     }
72 }
73 
74 
75 
76 contract BigPoint is ERC20Interface, Owned {
77     using SafeMath for uint;
78 
79     string public symbol;
80     string public  name;
81     uint8 public decimals;
82     uint _totalSupply;
83 
84     mapping(address => uint) balances;
85     mapping(address => mapping(address => uint)) allowed;
86 
87 
88     // ------------------------------------------------------------------------
89     // Constructor
90     // ------------------------------------------------------------------------
91     constructor() public {
92         symbol = "BIGP";
93         name = "Big Point";
94         decimals = 18;
95         _totalSupply = 21000000 * 10**uint(decimals);
96         balances[owner] = _totalSupply;
97         emit Transfer(address(0), owner, _totalSupply);
98     }
99 
100 
101     // ------------------------------------------------------------------------
102     // Total supply
103     // ------------------------------------------------------------------------
104     function totalSupply() public view returns (uint) {
105         return _totalSupply.sub(balances[address(0)]);
106     }
107 
108 
109     // ------------------------------------------------------------------------
110     // Get the token balance for account `tokenOwner`
111     // ------------------------------------------------------------------------
112     function balanceOf(address tokenOwner) public view returns (uint balance) {
113         return balances[tokenOwner];
114     }
115 
116 
117     // ------------------------------------------------------------------------
118     // Transfer the balance from token owner's account to `to` account
119     // - Owner's account must have sufficient balance to transfer
120     // - 0 value transfers are allowed
121     // ------------------------------------------------------------------------
122     function transfer(address to, uint tokens) public returns (bool success) {
123         balances[msg.sender] = balances[msg.sender].sub(tokens);
124         balances[to] = balances[to].add(tokens);
125         emit Transfer(msg.sender, to, tokens);
126         return true;
127     }
128 
129 
130     // ------------------------------------------------------------------------
131     // Token owner can approve for `spender` to transferFrom(...) `tokens`
132     // from the token owner's account
133     //
134     
135     function approve(address spender, uint tokens) public returns (bool success) {
136         allowed[msg.sender][spender] = tokens;
137         emit Approval(msg.sender, spender, tokens);
138         return true;
139     }
140 
141 
142     // ------------------------------------------------------------------------
143     // Transfer `tokens` from the `from` account to the `to` account
144     //
145     // The calling account must already have sufficient tokens approve(...)-d
146     // for spending from the `from` account and
147     
148     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
149         balances[from] = balances[from].sub(tokens);
150         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
151         balances[to] = balances[to].add(tokens);
152         emit Transfer(from, to, tokens);
153         return true;
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Returns the amount of tokens approved by the owner that can be
159     // transferred to the spender's account
160     // ------------------------------------------------------------------------
161     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
162         return allowed[tokenOwner][spender];
163     }
164 
165 
166    
167     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
168         allowed[msg.sender][spender] = tokens;
169         emit Approval(msg.sender, spender, tokens);
170         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
171         return true;
172     }
173 
174 
175    
176     
177 
178     // ------------------------------------------------------------------------
179     // Owner can transfer out any accidentally sent ERC20 tokens
180     // ------------------------------------------------------------------------
181     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
182         return ERC20Interface(tokenAddress).transfer(owner, tokens);
183     }
184     
185     
186     
187      mapping(address => uint) ShareStatus;
188     address payable[] ShareAddress;
189     uint8 public i = 0;//for adding share iteration
190     uint public fee;
191     uint public ordertoPay= 0;
192     uint256 public minBalance;
193     uint public warnRepeated;
194     
195     
196     
197     function AddShare(address payable _Share)public onlyOwner returns(bool){
198         require(balances[_Share]>0);
199          
200          
201          for(uint e =0; e<i; e++){
202         if(_Share ==ShareAddress[e]){
203           warnRepeated =1;}
204          }
205          
206          if(warnRepeated!=1){
207          
208          
209         ShareAddress.push(_Share);
210         ShareStatus[_Share]=1;
211         i++;
212         //ShareStatus = 1 => approved
213         
214          }
215         warnRepeated = 0; 
216     }
217     
218     
219     function AddShareManual(address payable _Share)public onlyOwner returns(bool){
220         require(balances[_Share]>0);
221         ShareStatus[_Share]=1;
222         ShareAddress.push(_Share);
223         i++;
224         
225         
226     }
227     
228     function viewSharePermission(address payable _Share)public view returns(bool){
229         if(ShareStatus[_Share]==1){return true;}
230         if(ShareStatus[_Share]!=1){return false;}
231     }
232     
233     
234     
235     
236     function BanThisAddress(address payable _Share)public onlyOwner returns(uint){
237         require(ShareStatus[_Share]==1);
238          ShareStatus[_Share]=0;
239          //ShareStatus = 0 => banned
240     }
241     
242     function CancelBanThisAddress(address payable _Share)public onlyOwner returns(uint){
243         require(ShareStatus[_Share]==0);
244          ShareStatus[_Share]=1;
245          //ShareStatus = 1 => unbanned
246     }
247     
248     
249     
250     function SetFeeinWei(uint _fee)public onlyOwner returns(uint){
251         fee = _fee;
252     }
253     
254     function viewFee()public onlyOwner view returns(uint){
255        return fee;
256     }
257     
258     
259     function CalWeiToPay(uint _ordertoPay, uint _ShareWei)public onlyOwner view returns(address payable, uint, uint){
260         
261         require(ShareStatus[ShareAddress[_ordertoPay]]==1 && balances[ShareAddress[_ordertoPay]]>=minBalance);
262         uint Amount_to_pay = balances[ShareAddress[_ordertoPay]].mul(_ShareWei).div(_totalSupply);
263         Amount_to_pay = Amount_to_pay.sub(fee);
264         
265         return (ShareAddress[_ordertoPay], Amount_to_pay, balances[ShareAddress[_ordertoPay]]);
266     }
267     
268     
269     
270     function CalWeiToPayByAddress(address payable _thisAddress, uint _ShareWei)public onlyOwner view returns(address payable, uint, uint){
271         
272         require(ShareStatus[_thisAddress]==1 && balances[_thisAddress]>=minBalance);
273         uint Amount_to_pay = balances[_thisAddress].mul(_ShareWei).div(_totalSupply);
274         Amount_to_pay = Amount_to_pay.sub(fee);
275         
276         return (_thisAddress , Amount_to_pay, balances[_thisAddress]);
277     }
278     
279     
280     
281     
282     function ResetOrdertoPay(uint reset)public onlyOwner returns(uint){
283         ordertoPay = reset;
284         
285     }
286     
287     function SetMinBalance(uint256 _k)public onlyOwner returns(uint){
288         minBalance = _k;
289         return minBalance;
290     }
291     
292     
293     function viewMinBalanceRequireToPayShare()public view returns(uint){
294         return minBalance;
295         
296     }
297     
298     function viewNumShare()public view returns(uint){
299         return i;
300     }
301     
302    
303         
304   
305     
306     
307     
308     
309 }