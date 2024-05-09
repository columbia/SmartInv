1 pragma solidity ^0.5.11;
2 
3 library SafeMathMod {// Partial SafeMath Library
4 
5     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         require((c = a - b) < a);
7     }
8 
9     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
10         require((c = a + b) > a);
11     }
12     
13     function mul(uint256 a, uint256 b) internal pure returns(uint c) {
14     c = a * b;
15     require(a == 0 || c / a == b);
16   }
17   
18   function div(uint a, uint b) internal pure returns(uint c) {
19     require(b > 0);
20     c = a / b;
21   }
22 }
23 
24 contract ERC20Interface {
25   function totalSupply() public view returns(uint);
26   function balanceOf(address tokenOwner) public view returns(uint balance);
27   function allowance(address tokenOwner, address spender) public view returns(uint remaining);
28   function transfer(address to, uint tokens) public returns(bool success);
29   function approve(address spender, uint tokens) public returns(bool success);
30   function transferFrom(address from, address to, uint tokens) public returns(bool success);
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
41   event OwnershipTransferred(address indexed _from, address indexed _to);
42   constructor() public {
43     owner = msg.sender;
44   }
45   modifier onlyOwner {
46     require(msg.sender == owner);
47     _;
48   }
49   function transferOwnership(address newOwner) public onlyOwner {
50     owner = newOwner;
51     emit OwnershipTransferred(owner, newOwner);
52   }
53 }
54 // blacklist
55 contract UserLock is Owned {
56   mapping(address => bool) blacklist;
57   event LockUser(address indexed who);
58   event UnlockUser(address indexed who);
59   modifier permissionCheck {
60     require(!blacklist[msg.sender]);
61     _;
62   }
63   function lockUser(address who) public onlyOwner {
64     blacklist[who] = true;
65     emit LockUser(who);
66   }
67   function unlockUser(address who) public onlyOwner {
68     blacklist[who] = false;
69     emit UnlockUser(who);
70   }
71 }
72 
73 contract Tokenlock is Owned {
74   uint8 isLocked = 0;
75   event Freezed();
76   event UnFreezed();
77   modifier validLock {
78     require(isLocked == 0);
79     _;
80   }
81   function freeze() public onlyOwner {
82     isLocked = 1;
83     emit Freezed();
84   }
85   function unfreeze() public onlyOwner {
86     isLocked = 0;
87     emit UnFreezed();
88   }
89 }
90 
91 contract LG is ERC20Interface, Tokenlock, UserLock{//is inherently ERC20
92     using SafeMathMod for uint256;
93 
94     /**
95     * @constant name The name of the token
96     * @constant symbol  The symbol used to display the currency
97     * @constant decimals  The number of decimals used to dispay a balance
98     * @constant totalSupply The total number of tokens times 10^ of the number of decimals
99     * @constant MAX_UINT256 Magic number for unlimited allowance
100     * @storage balanceOf Holds the balances of all token holders
101     * @storage allowed Holds the allowable balance to be transferable by another address.
102     */
103 
104     string constant public name = "LG";
105 
106     string constant public symbol = "LG";
107 
108     uint8 constant public decimals = 6;
109 
110     uint256  _totalSupply; 
111 
112     uint256 constant private MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
113 
114     mapping (address => uint256) public balances;
115     
116     mapping (address => mapping (address => uint256)) public allowed;
117 
118     event Transfer(address indexed _from, address indexed _to, uint256 _value);
119 
120     event TransferFrom(address indexed _spender, address indexed _from, address indexed _to, uint256 _value);
121 
122     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
123 
124     constructor() public {
125         _totalSupply=15*(10**6)*(10**uint(decimals));
126         balances[owner] = _totalSupply;
127         emit Transfer(address(0), owner, _totalSupply);
128     }
129     
130     function totalSupply() public view returns(uint) {
131         return _totalSupply;
132     }
133     
134     function balanceOf(address tokenOwner) public view returns(uint balance) {
135         return balances[tokenOwner];
136     }
137     
138     /**
139     * @notice send `_value` token to `_to` from `msg.sender`
140     *
141     * @param _to The address of the recipient
142     * @param _value The amount of token to be transferred
143     * @return Whether the transfer was successful or not
144     */
145     function transfer(address _to, uint256 _value) public validLock permissionCheck returns (bool success) {
146         /* Ensures that tokens are not sent to address "0x0" */
147         require(_to != address(0));
148         /* Prevents sending tokens directly to contracts. */
149         require(isNotContract(_to));
150 
151         /* SafeMathMOd.sub will throw if there is not enough balance and if the transfer value is 0. */
152         balances[msg.sender] = balances[msg.sender].sub(_value);
153         balances[_to] = balances[_to].add(_value);
154         emit Transfer(msg.sender, _to, _value);
155         return true;
156     }
157 
158     /**
159     * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
160     *
161     * @param _from The address of the sender
162     * @param _to The address of the recipient
163     * @param _value The amount of token to be transferred
164     * @return Whether the transfer was successful or not
165     */
166     function transferFrom(address _from, address _to, uint256 _value) public validLock permissionCheck returns (bool success) {
167         /* Ensures that tokens are not sent to address "0x0" */
168         require(_to != address(0));
169         /* Ensures tokens are not sent to this contract */
170         require(_to != address(this));
171         
172         uint256 allowance = allowed[_from][msg.sender];
173         /* Ensures sender has enough available allowance OR sender is balance holder allowing single transsaction send to contracts*/
174         require(_value <= allowance || _from == msg.sender);
175 
176         /* Use SafeMathMod to add and subtract from the _to and _from addresses respectively. Prevents under/overflow and 0 transfers */
177         balances[_to] = balances[_to].add(_value);
178         balances[_from] = balances[_from].sub(_value);
179 
180         /* Only reduce allowance if not MAX_UINT256 in order to save gas on unlimited allowance */
181         /* Balance holder does not need allowance to send from self. */
182         if (allowed[_from][msg.sender] != MAX_UINT256 && _from != msg.sender) {
183             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184         }
185         emit Transfer(_from, _to, _value);
186         return true;
187     }
188 
189     /**
190     * @notice `msg.sender` approves `_spender` to spend `_value` tokens
191     *
192     * @param _spender The address of the account able to transfer the tokens
193     * @param _value The amount of tokens to be approved for transfer
194     * @return Whether the approval was successful or not
195     */
196     function approve(address _spender, uint256 _value) public validLock permissionCheck returns (bool success) {
197         /* Ensures address "0x0" is not assigned allowance. */
198         require(_spender != address(0));
199 
200         allowed[msg.sender][_spender] = _value;
201         emit Approval(msg.sender, _spender, _value);
202         return true;
203     }
204 
205     /**
206     * @param _owner The address of the account owning tokens
207     * @param _spender The address of the account able to transfer the tokens
208     * @return Amount of remaining tokens allowed to spent
209     */
210     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
211         remaining = allowed[_owner][_spender];
212     }
213     
214     // trust pay
215     function approveAndCall(address spender, uint tokens, bytes memory data) public validLock permissionCheck returns(bool success) {
216         allowed[msg.sender][spender] = tokens;
217         emit Approval(msg.sender, spender, tokens);
218         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
219         return true;
220     }
221     
222     function mintToken(address target, uint256 mintedAmount) public onlyOwner {
223         require(target != address(0));
224         balances[target] += mintedAmount;
225         _totalSupply = _totalSupply.add(mintedAmount);
226         emit Transfer(address(0), owner, mintedAmount);
227         emit Transfer(owner, target, mintedAmount);
228     }
229     
230     function () external payable {
231         revert();
232     }
233 
234     function isNotContract(address _addr) private view returns (bool) {
235         uint length;
236         assembly {
237         /* retrieve the size of the code on target address, this needs assembly */
238         length := extcodesize(_addr)
239         }
240         return (length == 0);
241     }
242 }