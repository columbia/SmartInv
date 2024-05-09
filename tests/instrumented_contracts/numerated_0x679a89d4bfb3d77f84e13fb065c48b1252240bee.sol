1 pragma solidity ^0.4.24;
2 
3 contract BasicTokenInterface{
4     function balanceOf(address tokenOwner) public view returns (uint balance);
5     function transfer(address to, uint tokens) public returns (bool success);
6     event Transfer(address indexed from, address indexed to, uint tokens);
7 }
8 
9 // ----------------------------------------------------------------------------
10 // Contract function to receive approval and execute function in one call
11 //
12 // Borrowed from MiniMeToken
13 // ----------------------------------------------------------------------------
14 // Contract function to receive approval and execute function in one call
15 //
16 // Borrowed from MiniMeToken
17 // ----------------------------------------------------------------------------
18 contract ApproveAndCallFallBack {
19     event ApprovalReceived(address indexed from, uint256 indexed amount, address indexed tokenAddr, bytes data);
20     function receiveApproval(address from, uint256 amount, address tokenAddr, bytes data) public{
21         emit ApprovalReceived(from, amount, tokenAddr, data);
22     }
23 }
24 
25 // ----------------------------------------------------------------------------
26 // ERC Token Standard #20 Interface
27 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
28 // ----------------------------------------------------------------------------
29 contract ERC20TokenInterface is BasicTokenInterface, ApproveAndCallFallBack{
30     string public name;
31     string public symbol;
32     uint8 public decimals;
33     uint256 public totalSupply;
34 
35     function allowance(address tokenOwner, address spender) public view returns (uint remaining);   
36     function approve(address spender, uint tokens) public returns (bool success);
37     function transferFrom(address from, address to, uint tokens) public returns (bool success);
38     function transferTokens(address token, uint amount) public returns (bool success);
39     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success);
40     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
41 }
42 
43 pragma experimental "v0.5.0";
44 
45 
46 
47 library SafeMath {
48     
49     //Guard overflow by making 0 an impassable barrier
50     function add(uint a, uint b) internal pure returns (uint c) {
51         c = a + b;
52         return (c >= a && c >= b) ? c : 0;
53     }
54 
55     //Guard underflow by making 0 an impassable barrier
56     function sub(uint a, uint b) internal pure returns (uint) {
57         return (a >=b) ? (a - b): 0;
58     }
59 
60     function mul(uint a, uint b) internal pure returns (uint c) {
61         c = a * b;
62         require(a == 0 || b == 0 || c / a == b);
63         return c;
64     }
65     function div(uint a, uint b) internal pure returns (uint c) {
66         require(a > 0 && b > 0);
67         c = a / b;
68         return c;
69     }
70 }
71 
72 contract BasicToken is BasicTokenInterface{
73     using SafeMath for uint;
74     
75     string public name;                   //fancy name: eg Simon Bucks
76     uint8 public decimals;                //How many decimals to show.
77     string public symbol;                 //An identifier: eg SBX
78     uint public totalSupply;
79     mapping (address => uint256) internal balances;
80     
81     modifier checkpayloadsize(uint size) {
82         assert(msg.data.length >= size + 4);
83         _;
84     } 
85 
86     function transfer(address _to, uint256 _value) public checkpayloadsize(2*32) returns (bool success) {
87         require(balances[msg.sender] >= _value);
88         success = true;
89         balances[msg.sender] -= _value;
90 
91         //If sent to contract address reduce the supply
92         if(_to == address(this)){
93             totalSupply = totalSupply.sub(_value);
94         }else{
95             balances[_to] += _value;
96         }
97         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
98         return success;
99     }
100 
101     function balanceOf(address _owner) public view returns (uint256 balance) {
102         return balances[_owner];
103     }
104 
105 }
106 
107 contract ManagedToken is BasicToken {
108     address manager;
109     modifier restricted(){
110         require(msg.sender == manager,"Function can only be used by manager");
111         _;
112     }
113 
114     function setManager(address newManager) public restricted{
115         balances[newManager] = balances[manager];
116         balances[manager] = 0;
117         manager = newManager;
118     }
119 
120 }
121 
122 contract ERC20Token is ERC20TokenInterface, ManagedToken{
123 
124     mapping (address => mapping (address => uint256)) internal allowed;
125 
126     /**
127     * @dev Transfer tokens from one address to another
128     * @param _from address The address which you want to send tokens from
129     * @param _to address The address which you want to transfer to
130     * @param _value uint256 the amount of tokens to be transferred
131     */
132     function transferFrom(address _from,address _to,uint256 _value) public returns (bool) {
133         require(_to != address(0));
134         require(_value <= balances[_from]);
135         require(_value <= allowed[_from][msg.sender]);
136 
137         balances[_from] = balances[_from].sub(_value);
138         balances[_to] = balances[_to].add(_value);
139         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
140         emit Transfer(_from, _to, _value);
141         return true;
142     }
143 
144 
145     /**
146     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147     * Beware that changing an allowance with this method brings the risk that someone may use both the old
148     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
149     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
150     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151     * @param _spender The address which will spend the funds.
152     * @param _value The amount of tokens to be spent.
153     */
154     function approve(address _spender, uint256 _value) public returns (bool) {
155         allowed[msg.sender][_spender] = _value;
156         emit Approval(msg.sender, _spender, _value);
157         return true;
158     }
159 
160     // ------------------------------------------------------------------------
161     // Token owner can approve for `spender` to transferFrom(...) `tokens`
162     // from the token owner's account. The `spender` contract function
163     // `receiveApproval(...)` is then executed
164     // ------------------------------------------------------------------------
165     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
166         allowed[msg.sender][spender] = tokens;
167         emit Approval(msg.sender, spender, tokens);
168         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
169         return true;
170     }
171 
172     /**
173     * @dev Function to check the amount of tokens that an owner allowed to a spender.
174     * @param _owner address The address which owns the funds.
175     * @param _spender address The address which will spend the funds.
176     * @return A uint256 specifying the amount of tokens still available for the spender.
177     */
178     function allowance(address _owner,address _spender) public view returns (uint256)
179     {
180         return allowed[_owner][_spender];
181     }
182 
183     //Permit manager to sweep any tokens that landed here
184     function transferTokens(address token,uint _value) public restricted returns (bool success){
185         return ERC20Token(token).transfer(msg.sender,_value);
186     }
187 }
188 
189 contract Glitter is ERC20Token {
190 
191     uint tokenPrice;
192     string URL;
193     function() external payable {
194         buyTokens();
195     }
196 
197     function buyTokens() public payable{
198         address(manager).transfer(msg.value);
199         uint tokensBought = msg.value.div(tokenPrice).mul(uint(10) ** decimals);
200         balances[msg.sender] = balances[msg.sender].add(tokensBought);
201         totalSupply += tokensBought;
202         emit Transfer(address(this),msg.sender,tokensBought);
203     }
204     
205     constructor() public {
206         name = "Green Light Rewards ";
207         symbol = "GLITTER";
208         decimals = 8;
209         totalSupply = 1000000 * (uint(10) ** decimals);
210         tokenPrice = 10000000000000000; //0.01 ETH
211         manager = 0xa70091DD81bD0c6d54326A973dC0d7b3f47c6dFd;
212         balances[manager] = totalSupply;
213         URL = "https://www.icosuccess.com/";
214         emit Transfer(address(this),manager,balances[manager]);
215     }
216 
217     function setTokenPrice(uint price) public restricted{
218         tokenPrice = price;
219     }
220 
221     function getTokenPrice() public view returns(uint){
222         return tokenPrice;
223     }
224 }