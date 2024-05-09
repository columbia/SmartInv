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
45 library SafeMath {
46     function add(uint a, uint b) internal pure returns (uint c) {
47         c = a + b;
48         require(c >= a && c >= b);
49     }
50     function sub(uint a, uint b) internal pure returns (uint c) {
51         require(b <= a);
52         c = a - b;
53     }
54     function mul(uint a, uint b) internal pure returns (uint c) {
55         c = a * b;
56         require(a == 0 || b == 0 || c / a == b);
57     }
58     function div(uint a, uint b) internal pure returns (uint c) {
59         require(a > 0 && b > 0);
60         c = a / b;
61     }
62 }
63 
64 contract BasicToken is BasicTokenInterface{
65     using SafeMath for uint;
66     
67     string public name;                   //fancy name: eg Simon Bucks
68     uint8 public decimals;                //How many decimals to show.
69     string public symbol;                 //An identifier: eg SBX
70     uint public totalSupply;
71     mapping (address => uint256) internal balances;
72     
73     modifier checkpayloadsize(uint size) {
74         assert(msg.data.length >= size + 4);
75         _;
76     } 
77 
78     function transfer(address _to, uint256 _value) public checkpayloadsize(2*32) returns (bool success) {
79         require(balances[msg.sender] >= _value);
80         success = true;
81         balances[msg.sender] -= _value;
82 
83         //If sent to contract address reduce the supply
84         if(_to == address(this)){
85             totalSupply = totalSupply.sub(_value);
86         }else{
87             balances[_to] += _value;
88         }
89         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
90         return success;
91     }
92 
93     function balanceOf(address _owner) public view returns (uint256 balance) {
94         return balances[_owner];
95     }
96 
97 }
98 
99 contract ManagedToken is BasicToken {
100     address manager;
101     modifier restricted(){
102         require(msg.sender == manager,"Function can only be used by manager");
103         _;
104     }
105 
106     function setManager(address newManager) public restricted{
107         balances[newManager] = balances[manager];
108         balances[manager] = 0;
109         manager = newManager;
110     }
111 
112 }
113 
114 contract ERC20Token is ERC20TokenInterface, ManagedToken{
115 
116     mapping (address => mapping (address => uint256)) internal allowed;
117 
118     /**
119     * @dev Transfer tokens from one address to another
120     * @param _from address The address which you want to send tokens from
121     * @param _to address The address which you want to transfer to
122     * @param _value uint256 the amount of tokens to be transferred
123     */
124     function transferFrom(address _from,address _to,uint256 _value) public returns (bool) {
125         require(_to != address(0));
126         require(_value <= balances[_from]);
127         require(_value <= allowed[_from][msg.sender]);
128 
129         balances[_from] = balances[_from].sub(_value);
130         balances[_to] = balances[_to].add(_value);
131         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
132         emit Transfer(_from, _to, _value);
133         return true;
134     }
135 
136 
137     /**
138     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
139     * Beware that changing an allowance with this method brings the risk that someone may use both the old
140     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
141     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
142     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143     * @param _spender The address which will spend the funds.
144     * @param _value The amount of tokens to be spent.
145     */
146     function approve(address _spender, uint256 _value) public returns (bool) {
147         allowed[msg.sender][_spender] = _value;
148         emit Approval(msg.sender, _spender, _value);
149         return true;
150     }
151 
152     // ------------------------------------------------------------------------
153     // Token owner can approve for `spender` to transferFrom(...) `tokens`
154     // from the token owner's account. The `spender` contract function
155     // `receiveApproval(...)` is then executed
156     // ------------------------------------------------------------------------
157     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
158         allowed[msg.sender][spender] = tokens;
159         emit Approval(msg.sender, spender, tokens);
160         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
161         return true;
162     }
163 
164     /**
165     * @dev Function to check the amount of tokens that an owner allowed to a spender.
166     * @param _owner address The address which owns the funds.
167     * @param _spender address The address which will spend the funds.
168     * @return A uint256 specifying the amount of tokens still available for the spender.
169     */
170     function allowance(address _owner,address _spender) public view returns (uint256)
171     {
172         return allowed[_owner][_spender];
173     }
174 
175     //Permit manager to sweep any tokens that landed here
176     function transferTokens(address token,uint _value) public restricted returns (bool success){
177         return ERC20Token(token).transfer(msg.sender,_value);
178     }
179 
180 
181 
182 }
183 
184 contract FlairDrop is ERC20Token {
185 
186     address flairdrop;
187     uint tokenPrice;
188     event AirDropEvent(address indexed tokencontract, address[] destinations,uint[] indexed amounts);
189     
190     function() external payable {
191         buyTokens();
192     }
193 
194     function buyTokens() public payable{
195         address(manager).transfer(msg.value);
196         uint tokensBought = msg.value.div(tokenPrice);
197         balances[msg.sender] = balances[msg.sender].add(tokensBought);
198         totalSupply = totalSupply.add(tokensBought);
199         emit Transfer(address(this),msg.sender,tokensBought);
200     }
201 
202     constructor() public {
203         flairdrop = address(this);
204         name = "FlairDrop! Airdrops With Pizzazz!";
205         symbol = "FLAIRDROP";
206         decimals = 0;
207         totalSupply = 0;
208         tokenPrice = 10000000000000; //0.01 finney
209         manager = msg.sender;
210         balances[manager] = 100000000;
211         
212     }
213 
214     function airDrop(address parent, uint[] amounts, address[] droptargets) public payable {
215         if(msg.value > 0){
216             buyTokens();
217         }
218         
219         require(balances[msg.sender] >= droptargets.length,"Insufficient funds to execute this airdrop");
220         //Step 1 check our allowance with parent contract
221         ERC20TokenInterface parentContract = ERC20TokenInterface(parent);
222         uint allowance = parentContract.allowance(msg.sender, flairdrop);
223 
224         uint amount = amounts[0];
225     
226         uint x = 0;
227 
228         address target;
229         
230         while(gasleft() > 10000 && x <= droptargets.length - 1 ){
231             target = droptargets[x];
232             
233             if(amounts.length == droptargets.length){
234                 amount = amounts[x];
235             }
236             if(allowance >=amount){
237                 parentContract.transferFrom(msg.sender,target,amount);
238                 allowance -= amount;
239             }
240             x++;
241         }
242         
243         balances[msg.sender] -= x;
244         totalSupply -= x;
245         emit Transfer(msg.sender, address(0), x);
246         emit AirDropEvent(parent,droptargets,amounts);
247     }
248 
249     function setTokenPrice(uint price) public restricted{
250         tokenPrice = price;
251     }
252 
253     function getTokenPrice() public view returns(uint){
254         return tokenPrice;
255     }
256 }