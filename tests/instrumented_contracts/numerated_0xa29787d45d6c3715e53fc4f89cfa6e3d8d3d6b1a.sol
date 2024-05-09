1 pragma solidity ^0.5.7;
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
15     /**
16     * @dev Integer division of two numbers, truncating the quotient.
17     */
18    function div(uint a, uint b) internal pure returns (uint c) {
19         require(b > 0);
20         c = a / b;
21     }
22     /**
23     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
24     */
25     function sub(uint a, uint b) internal pure returns (uint c) {
26         require(b <= a);
27         c = a - b;
28     }
29     /**
30     * @dev Adds two numbers, throws on overflow.
31     */
32     function add(uint a, uint b) internal pure returns (uint c) {
33         c = a + b;
34         require(c >= a);
35     }
36 }
37 
38 contract ApproveAndCallFallBack {
39     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
40 }
41 
42 contract Owned {
43     address payable public owner;
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48      * account.
49      */
50     constructor() public {
51         owner = msg.sender;
52     }
53 
54     /**
55      * @dev Throws if called by any account other than the owner.
56      */
57     modifier onlyOwner() {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     /**
63      * @dev Allows the current owner to transfer control of the contract to a newOwner.
64      * @param newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(address payable newOwner) public onlyOwner {
67         require(newOwner != address(0));
68         emit OwnershipTransferred(owner, newOwner);
69         owner = newOwner;
70     }
71 
72 }
73 
74 contract ERC20Interface {
75     function totalSupply() public view returns (uint256);
76     function balanceOf(address tokenOwner) public view returns (uint256 balance);
77     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
78     function transfer(address to, uint256 tokens) public returns (bool success);
79     function approve(address spender, uint256 tokens) public returns (bool success);
80     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
81 
82     event Transfer(address indexed from, address indexed to, uint256 tokens);
83     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
84 }
85 
86 contract Swidex is ERC20Interface, Owned {
87     
88     using SafeMath for uint256;
89     
90     mapping (address => uint256) balances;
91     mapping (address => mapping (address => uint256)) allowed;
92     
93     string public name = "Swidex";
94     string public symbol = "SWDX";
95     uint256 public decimals = 8;
96     uint256 public _totalSupply;
97     
98     uint256 public SWDXPerEther = 2000000e8;
99     uint256 public maximumSale = 2000000000e8;
100     uint256 public totalSold = 0;
101     uint256 public minimumBuy = 1 ether;
102     uint256 public maximumBuy = 20 ether;
103 
104     //mitigates the ERC20 short address attack
105     //suggested by izqui9 @ http://bit.ly/2NMMCNv
106     modifier onlyPayloadSize(uint size) {
107         assert(msg.data.length >= size + 4);
108         _;
109     }
110     
111     
112     constructor () public {
113         _totalSupply = 5000000000e8;
114         /**
115          * give the original `owner` of the contract
116          * the totalSupply
117          */
118         balances[owner] = _totalSupply;
119         emit Transfer(address(0), owner, _totalSupply);
120     }
121     //get the total totalSupply
122     function totalSupply() public view returns (uint256) {
123         return _totalSupply;
124     }
125     
126     function () payable external {
127         require(msg.value >= minimumBuy && msg.value <= maximumBuy && totalSold <= maximumSale);
128         uint256 totalBuy =  (SWDXPerEther.mul(msg.value)).div(1 ether);
129         totalSold = totalSold.add(totalBuy);
130         doTransfer(owner, msg.sender, totalBuy);
131     }
132     
133     /// @dev This is the actual transfer function in the token contract, it can
134     ///  only be called by other functions in this contract.
135     /// @param _from The address holding the tokens being transferred
136     /// @param _to The address of the recipient
137     /// @param _amount The amount of tokens to be transferred
138     /// @return True if the transfer was successful
139     function doTransfer(address _from, address _to, uint _amount) internal {
140         // Do not allow transfer to 0x0 or the token contract itself
141         require((_to != address(0)));
142         require(_amount <= balances[_from]);
143         balances[_from] = balances[_from].sub(_amount);
144         balances[_to] = balances[_to].add(_amount);
145         emit Transfer(_from, _to, _amount);
146     }
147     
148     function balanceOf(address _owner) view public returns (uint256) {
149         return balances[_owner];
150     }
151     
152     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
153         doTransfer(msg.sender, _to, _amount);
154         return true;
155     }
156     /// @return The balance of `_owner`
157     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
158         require(allowed[_from][msg.sender] >= _amount);
159         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
160         doTransfer(_from, _to, _amount);
161         return true;
162     }
163     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
164     ///  its behalf. This is a modified version of the ERC20 approve function
165     ///  to be a little bit safer
166     /// @param _spender The address of the account able to transfer the tokens
167     /// @param _amount The amount of tokens to be approved for transfer
168     /// @return True if the approval was successful
169     function approve(address _spender, uint256 _amount) public returns (bool success) {
170         // To change the approve amount you first have to reduce the addresses`
171         //  allowance to zero by calling `approve(_spender,0)` if it is not
172         //  already 0 to mitigate the race condition described here:
173         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
175         allowed[msg.sender][_spender] = _amount;
176         emit Approval(msg.sender, _spender, _amount);
177         return true;
178     }
179 
180     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
181         ApproveAndCallFallBack spender = ApproveAndCallFallBack(_spender);
182         if (approve(_spender, _value)) {
183             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
184             return true;
185         }
186     }
187     
188     function allowance(address _owner, address _spender) view public returns (uint256) {
189         return allowed[_owner][_spender];
190     }
191     
192     function withdrawFund() onlyOwner public {
193         uint256 balance = address(this).balance;
194         owner.transfer(balance);
195     }
196     
197     function burn(uint256 _value) onlyOwner public {
198         require(_value <= balances[msg.sender]);
199         address burner = msg.sender;
200         balances[burner] = balances[burner].sub(_value);
201         _totalSupply = _totalSupply.sub(_value);
202         emit Burn(burner, _value);
203     }
204     
205     function getForeignTokenBalance(ERC20Interface _tokenContract, address who) view public returns (uint) {
206         return _tokenContract.balanceOf(who);
207     }
208     
209     function withdrawForeignTokens(ERC20Interface _tokenContract) onlyOwner public returns (bool) {
210         uint256 amount = _tokenContract.balanceOf(address(this));
211         return _tokenContract.transfer(owner, amount);
212     }
213     
214     event TransferEther(address indexed _from, address indexed _to, uint256 _value);
215     event NewPrice(address indexed _changer, uint256 _lastPrice, uint256 _newPrice);
216     event Burn(address indexed _burner, uint256 value);
217 }