1 /**
2  *Submitted for verification at Etherscan.io on 2019-09-30
3 */
4 
5 pragma solidity ^0.5.11;
6 
7 library SafeMathMod {// Partial SafeMath Library
8 
9     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
10         require((c = a - b) < a);
11     }
12 
13     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         require((c = a + b) > a);
15     }
16     
17     function mul(uint256 a, uint256 b) internal pure returns(uint c) {
18     c = a * b;
19     require(a == 0 || c / a == b);
20   }
21   
22   function div(uint a, uint b) internal pure returns(uint c) {
23     require(b > 0);
24     c = a / b;
25   }
26 }
27 
28 contract ERC20Interface {
29   function totalSupply() public view returns(uint);
30   function balanceOf(address tokenOwner) public view returns(uint balance);
31   function allowance(address tokenOwner, address spender) public view returns(uint remaining);
32   function transfer(address to, uint tokens) public returns(bool success);
33   function approve(address spender, uint tokens) public returns(bool success);
34   function transferFrom(address from, address to, uint tokens) public returns(bool success);
35   event Transfer(address indexed from, address indexed to, uint tokens);
36   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
37 }
38 
39 contract ApproveAndCallFallBack {
40   function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
41 }
42 
43 contract Owned {
44   address public owner;
45   event OwnershipTransferred(address indexed _from, address indexed _to);
46   constructor() public {
47     owner = msg.sender;
48   }
49   modifier onlyOwner {
50     require(msg.sender == owner);
51     _;
52   }
53   function transferOwnership(address newOwner) public onlyOwner {
54     owner = newOwner;
55     emit OwnershipTransferred(owner, newOwner);
56   }
57 }
58 // blacklist
59 contract UserLock is Owned {
60   mapping(address => bool) blacklist;
61   event LockUser(address indexed who);
62   event UnlockUser(address indexed who);
63   modifier permissionCheck {
64     require(!blacklist[msg.sender]);
65     _;
66   }
67   function lockUser(address who) public onlyOwner {
68     blacklist[who] = true;
69     emit LockUser(who);
70   }
71   function unlockUser(address who) public onlyOwner {
72     blacklist[who] = false;
73     emit UnlockUser(who);
74   }
75 }
76 
77 contract Tokenlock is Owned {
78   uint8 isLocked = 0;
79   event Freezed();
80   event UnFreezed();
81   modifier validLock {
82     require(isLocked == 0);
83     _;
84   }
85   function freeze() public onlyOwner {
86     isLocked = 1;
87     emit Freezed();
88   }
89   function unfreeze() public onlyOwner {
90     isLocked = 0;
91     emit UnFreezed();
92   }
93 }
94 
95 contract CBL is ERC20Interface, Tokenlock, UserLock{//is inherently ERC20
96     using SafeMathMod for uint256;
97 
98     /**
99     * @constant name The name of the token
100     * @constant symbol  The symbol used to display the currency
101     * @constant decimals  The number of decimals used to dispay a balance
102     * @constant totalSupply The total number of tokens times 10^ of the number of decimals
103     * @constant MAX_UINT256 Magic number for unlimited allowance
104     * @storage balanceOf Holds the balances of all token holders
105     * @storage allowed Holds the allowable balance to be transferable by another address.
106     */
107 
108     string constant public name = "CBL";
109 
110     string constant public symbol = "CBL";
111 
112     uint8 constant public decimals = 6;
113 
114     uint256  _totalSupply = 3.8e14; // 10亿
115 
116     uint256 constant private MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
117 
118     mapping (address => uint256) public balances;
119     
120     mapping (address => mapping (address => uint256)) public allowed;
121 
122     event Transfer(address indexed _from, address indexed _to, uint256 _value);
123 
124     event TransferFrom(address indexed _spender, address indexed _from, address indexed _to, uint256 _value);
125 
126     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
127 
128     constructor() public {
129         balances[owner] = _totalSupply;
130         emit Transfer(address(0), owner, _totalSupply);
131     }
132     
133     function totalSupply() public view returns(uint) {
134         return _totalSupply;
135     }
136     
137     function balanceOf(address tokenOwner) public view returns(uint balance) {
138         return balances[tokenOwner];
139     }
140     
141     /**
142     * @notice send `_value` token to `_to` from `msg.sender`
143     *
144     * @param _to The address of the recipient
145     * @param _value The amount of token to be transferred
146     * @return Whether the transfer was successful or not
147     */
148     function transfer(address _to, uint256 _value) public validLock permissionCheck returns (bool success) {
149         /* Ensures that tokens are not sent to address "0x0" */
150         require(_to != address(0));
151         /* Prevents sending tokens directly to contracts. */
152         require(isNotContract(_to));
153 
154         /* SafeMathMOd.sub will throw if there is not enough balance and if the transfer value is 0. */
155         balances[msg.sender] = balances[msg.sender].sub(_value);
156         balances[_to] = balances[_to].add(_value);
157         emit Transfer(msg.sender, _to, _value);
158         return true;
159     }
160 
161     /**
162     * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
163     *
164     * @param _from The address of the sender
165     * @param _to The address of the recipient
166     * @param _value The amount of token to be transferred
167     * @return Whether the transfer was successful or not
168     */
169     function transferFrom(address _from, address _to, uint256 _value) public validLock permissionCheck returns (bool success) {
170         /* Ensures that tokens are not sent to address "0x0" */
171         require(_to != address(0));
172         /* Ensures tokens are not sent to this contract */
173         require(_to != address(this));
174         
175         uint256 allowance = allowed[_from][msg.sender];
176         /* Ensures sender has enough available allowance OR sender is balance holder allowing single transsaction send to contracts*/
177         require(_value <= allowance || _from == msg.sender);
178 
179         /* Use SafeMathMod to add and subtract from the _to and _from addresses respectively. Prevents under/overflow and 0 transfers */
180         balances[_to] = balances[_to].add(_value);
181         balances[_from] = balances[_from].sub(_value);
182 
183         /* Only reduce allowance if not MAX_UINT256 in order to save gas on unlimited allowance */
184         /* Balance holder does not need allowance to send from self. */
185         if (allowed[_from][msg.sender] != MAX_UINT256 && _from != msg.sender) {
186             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187         }
188         emit Transfer(_from, _to, _value);
189         return true;
190     }
191 
192     /**
193     * @notice `msg.sender` approves `_spender` to spend `_value` tokens
194     *
195     * @param _spender The address of the account able to transfer the tokens
196     * @param _value The amount of tokens to be approved for transfer
197     * @return Whether the approval was successful or not
198     */
199     function approve(address _spender, uint256 _value) public validLock permissionCheck returns (bool success) {
200         /* Ensures address "0x0" is not assigned allowance. */
201         require(_spender != address(0));
202 
203         allowed[msg.sender][_spender] = _value;
204         emit Approval(msg.sender, _spender, _value);
205         return true;
206     }
207 
208     /**
209     * @param _owner The address of the account owning tokens
210     * @param _spender The address of the account able to transfer the tokens
211     * @return Amount of remaining tokens allowed to spent
212     */
213     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
214         remaining = allowed[_owner][_spender];
215     }
216     
217     // trust pay
218     function approveAndCall(address spender, uint tokens, bytes memory data) public validLock permissionCheck returns(bool success) {
219         allowed[msg.sender][spender] = tokens;
220         emit Approval(msg.sender, spender, tokens);
221         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
222         return true;
223     }
224     
225     function mintToken(address target, uint256 mintedAmount) public onlyOwner {
226         require(target != address(0));
227         balances[target] += mintedAmount;
228         _totalSupply = _totalSupply.add(mintedAmount);
229         emit Transfer(address(0), owner, mintedAmount);
230         emit Transfer(owner, target, mintedAmount);
231     }
232     
233     function () external payable {
234         revert();
235     }
236 
237     function isNotContract(address _addr) private view returns (bool) {
238         uint length;
239         assembly {
240         /* retrieve the size of the code on target address, this needs assembly */
241         length := extcodesize(_addr)
242         }
243         return (length == 0);
244     }
245 }