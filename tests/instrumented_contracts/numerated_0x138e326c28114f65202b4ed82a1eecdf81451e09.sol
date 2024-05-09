1 pragma solidity ^0.5.1;
2 
3 /**
4  * @title SafeMath
5  */
6 library SafeMath {
7 
8     /**
9     * @dev Multiplies two numbers, throws on overflow.
10     */
11     function mul(uint a, uint b) internal pure returns (uint c) {
12         c = a * b;
13         require(a == 0 || c / a == b);
14     }
15 
16     /**
17     * @dev Integer division of two numbers, truncating the quotient.
18     */
19    function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 
24     /**
25     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
26     */
27     function sub(uint a, uint b) internal pure returns (uint c) {
28         require(b <= a);
29         c = a - b;
30     }
31 
32     /**
33     * @dev Adds two numbers, throws on overflow.
34     */
35     function add(uint a, uint b) internal pure returns (uint c) {
36         c = a + b;
37         require(c >= a);
38     }
39 }
40 
41 
42 
43 contract ForeignToken {
44     function balanceOf(address _owner) view public returns (uint256);
45     function transfer(address _to, uint256 _value) public returns (bool);
46 }
47 
48 contract ApproveAndCallFallBack {
49     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
50 }
51 
52 contract Owned {
53     address payable public owner;
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58      * account.
59      */
60     constructor() public {
61         owner = msg.sender;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(msg.sender == owner);
69         _;
70     }
71 
72     /**
73      * @dev Allows the current owner to transfer control of the contract to a newOwner.
74      * @param newOwner The address to transfer ownership to.
75      */
76     function transferOwnership(address payable newOwner) public onlyOwner {
77         require(newOwner != address(0));
78         emit OwnershipTransferred(owner, newOwner);
79         owner = newOwner;
80     }
81 
82 }
83 
84 contract ERC20Interface {
85     function totalSupply() public view returns (uint256);
86     function balanceOf(address tokenOwner) public view returns (uint256 balance);
87     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
88     function transfer(address to, uint256 tokens) public returns (bool success);
89     function approve(address spender, uint256 tokens) public returns (bool success);
90     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
91 
92     event Transfer(address indexed from, address indexed to, uint256 tokens);
93     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
94 }
95 
96 contract ExclusivePlatform is ERC20Interface, Owned {
97     
98     using SafeMath for uint256;
99     
100     mapping (address => uint256) balances;
101     mapping (address => mapping (address => uint256)) allowed;
102     mapping (address => bool) public blacklist;
103 
104     string public name = "Exclusive Platform";
105     string public symbol = "XPL";
106     uint256 public decimals = 8;
107     uint256 public _totalSupply;
108     
109     uint256 public XPLPerEther = 8333334e8;
110     uint256 public amountClaimable = 14999e8;
111     uint256 public minimumBuy = 1 ether / 10;
112     uint256 public maximumBuy = 30 ether;
113     uint256 public claimed = 0;
114     bool public airdropIsOn = false;
115     bool public crowdsaleIsOn = false;
116     
117     //mitigates the ERC20 short address attack
118     //suggested by izqui9 @ http://bit.ly/2NMMCNv
119     modifier onlyPayloadSize(uint size) {
120         assert(msg.data.length >= size + 4);
121         _;
122     }
123     
124     modifier onlyWhitelist() {
125         require(blacklist[msg.sender] == false);
126         _;
127     }
128     
129     constructor () public {
130         _totalSupply = 10000000000e8;
131         /**
132          * give the original `owner` of the contract
133          * the totalSupply
134          */
135         balances[owner] = _totalSupply;
136         emit Transfer(address(0), owner, _totalSupply);
137     }
138     //get the total totalSupply
139     function totalSupply() public view returns (uint256) {
140         return _totalSupply;
141     }
142     
143     function updateXPLPerEther(uint _XPLPerEther) public onlyOwner {        
144         emit NewPrice(owner, XPLPerEther, _XPLPerEther);
145         XPLPerEther = _XPLPerEther;
146     }
147     //toggle airdrop
148     function switchAirdrop() public onlyOwner {
149         airdropIsOn = !(airdropIsOn);
150     }
151     //toggle crowdsale
152     function switchCrowdsale() public onlyOwner {
153         crowdsaleIsOn = !(crowdsaleIsOn);
154     }
155     //give bonus for buy of 10 ether and above
156     function bonus(uint256 _amount) internal view returns (uint256){
157         if(_amount >= XPLPerEther.mul(10)) return ((10*_amount).div(100)).add(_amount);
158         return _amount;
159     }
160     
161     function airdrop() payable onlyWhitelist public{
162         require(claimed <= 19999 && airdropIsOn);
163         blacklist[msg.sender] = true;
164         claimed = claimed.add(1);
165         doTransfer(owner, msg.sender, amountClaimable);
166     }
167     
168     function () payable external {
169         if(msg.value >= minimumBuy){
170             require(msg.value <= maximumBuy && crowdsaleIsOn);
171             uint256 totalBuy =  (XPLPerEther.mul(msg.value)).div(1 ether);
172             totalBuy = bonus(totalBuy);
173             doTransfer(owner, msg.sender, totalBuy);
174         }else{
175             airdrop();
176         }
177     }
178     
179     function distribute(address[] calldata _addresses, uint256 _amount) external {        
180         for (uint i = 0; i < _addresses.length; i++) {transfer(_addresses[i], _amount);}
181     }
182     
183     function distributeWithAmount(address[] calldata _addresses, uint256[] calldata _amounts) external {
184         require(_addresses.length == _amounts.length);
185         for (uint i = 0; i < _addresses.length; i++) {transfer(_addresses[i], _amounts[i]);}
186     }
187     /// @dev This is the actual transfer function in the token contract, it can
188     ///  only be called by other functions in this contract.
189     /// @param _from The address holding the tokens being transferred
190     /// @param _to The address of the recipient
191     /// @param _amount The amount of tokens to be transferred
192     /// @return True if the transfer was successful
193     function doTransfer(address _from, address _to, uint _amount) internal {
194         // Do not allow transfer to 0x0 or the token contract itself
195         require((_to != address(0)));
196         require(_amount <= balances[_from]);
197         balances[_from] = balances[_from].sub(_amount);
198         balances[_to] = balances[_to].add(_amount);
199         emit Transfer(_from, _to, _amount);
200     }
201     
202     function balanceOf(address _owner) view public returns (uint256) {
203         return balances[_owner];
204     }
205     
206     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
207         doTransfer(msg.sender, _to, _amount);
208         return true;
209     }
210     /// @return The balance of `_owner`
211     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
212         require(allowed[_from][msg.sender] >= _amount);
213         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
214         doTransfer(_from, _to, _amount);
215         return true;
216     }
217     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
218     ///  its behalf. This is a modified version of the ERC20 approve function
219     ///  to be a little bit safer
220     /// @param _spender The address of the account able to transfer the tokens
221     /// @param _amount The amount of tokens to be approved for transfer
222     /// @return True if the approval was successful
223     function approve(address _spender, uint256 _amount) public returns (bool success) {
224         // To change the approve amount you first have to reduce the addresses`
225         //  allowance to zero by calling `approve(_spender,0)` if it is not
226         //  already 0 to mitigate the race condition described here:
227         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
229         allowed[msg.sender][_spender] = _amount;
230         emit Approval(msg.sender, _spender, _amount);
231         return true;
232     }
233 
234     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
235         ApproveAndCallFallBack spender = ApproveAndCallFallBack(_spender);
236         if (approve(_spender, _value)) {
237             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
238             return true;
239         }
240     }
241     
242     function allowance(address _owner, address _spender) view public returns (uint256) {
243         return allowed[_owner][_spender];
244     }
245     
246     function transferEther(address payable _receiver, uint256 _amount) public onlyOwner {
247         require(_amount <= address(this).balance);
248         emit TransferEther(address(this), _receiver, _amount);
249         _receiver.transfer(_amount);
250     }
251     
252     function withdrawFund() onlyOwner public {
253         uint256 balance = address(this).balance;
254         owner.transfer(balance);
255     }
256     
257     function burn(uint256 _value) onlyOwner public {
258         require(_value <= balances[msg.sender]);
259         address burner = msg.sender;
260         balances[burner] = balances[burner].sub(_value);
261         _totalSupply = _totalSupply.sub(_value);
262         emit Burn(burner, _value);
263     }
264     
265     function getForeignTokenBalance(address tokenAddress, address who) view public returns (uint){
266         ForeignToken t = ForeignToken(tokenAddress);
267         uint bal = t.balanceOf(who);
268         return bal;
269     }
270     
271     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
272         ForeignToken token = ForeignToken(_tokenContract);
273         uint256 amount = token.balanceOf(address(this));
274         return token.transfer(owner, amount);
275     }
276     
277      function whitelistAddresses(address[] memory _addresses) onlyOwner public {
278         for (uint i = 0; i < _addresses.length; i++) {
279             blacklist[_addresses[i]] = false;
280         }
281     }
282 
283     function blacklistAddresses(address[] memory _addresses) onlyOwner public {
284         for (uint i = 0; i < _addresses.length; i++) {
285             blacklist[_addresses[i]] = true;
286         }
287     }
288     
289     event TransferEther(address indexed _from, address indexed _to, uint256 _value);
290     event NewPrice(address indexed _changer, uint256 _lastPrice, uint256 _newPrice);
291     event Burn(address indexed _burner, uint256 value);
292 
293 }