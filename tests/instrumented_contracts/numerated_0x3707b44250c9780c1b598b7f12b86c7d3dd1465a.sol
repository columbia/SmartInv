1 pragma solidity ^0.4.20;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
13     // benefit is lost if 'b' is also tested.
14     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15     if (a == 0) {
16       return 0;
17     }
18 
19     c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     // uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return a / b;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46     c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 contract owned {
52     address public owner;
53     
54     event Log(string s);
55     
56     constructor() public payable{
57         owner = msg.sender;
58     }
59 
60     modifier onlyOwner {
61         require(msg.sender == owner);
62         _;
63     }
64     function transferOwnership(address newOwner) onlyOwner public {
65         owner = newOwner;
66     }
67     function isOwner()public{
68         if(msg.sender==owner)emit Log("Owner");
69         else{
70             emit Log("Not Owner");
71         }
72     }
73 }
74 contract ERC20 is owned{
75     using SafeMath for *;
76     
77     string public name;
78     string public symbol;
79 
80     uint256 public totalSupply;
81     uint8 public constant decimals = 4;
82 
83     mapping(address => uint256) balances;
84     mapping(address => mapping (address => uint256)) allowed;
85     
86     event Transfer(address indexed from, address indexed to, uint tokens);
87     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
88 
89     constructor(uint256 _totalSupply,string tokenName,string tokenSymbol) public {
90         symbol = tokenSymbol;
91         name = tokenName;
92         totalSupply = _totalSupply;
93         balances[owner] = totalSupply;
94         emit Transfer(address(0), owner, totalSupply);
95     }
96 
97     function totalSupply() public view returns (uint){
98         return totalSupply;
99     }
100 
101     function balanceOf(address tokenOwner) public view returns (uint balance) {
102         return balances[tokenOwner];
103     }
104 
105     function transfer(address to, uint tokens) public returns (bool success) {
106         balances[msg.sender] = SafeMath.sub(balances[msg.sender ],tokens);
107         balances[to] = SafeMath.add(balances[to], tokens);
108         emit Transfer(msg.sender, to, tokens);
109         return true;
110     }
111 
112     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
113         balances[from] = SafeMath.sub(balances[from], tokens);
114         allowed[from][msg.sender] = SafeMath.sub(allowed[from][msg.sender],(tokens));
115         balances[to] = SafeMath.sub(balances[to],tokens);
116         emit Transfer(from, to, tokens);
117         return true;
118     }
119 
120     function approve(address spender, uint tokens) public returns (bool success) {
121         allowed[msg.sender][spender] = tokens;
122         emit Approval(msg.sender, spender, tokens);
123         return true;
124     }
125 
126     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
127         return allowed[tokenOwner][spender];
128     }
129 }
130 
131 contract NPLAY is ERC20 {
132     
133     uint256 activeUsers;
134 
135     mapping(address => bool) isRegistered;
136     mapping(address => uint256) accountID;
137     mapping(uint256 => address) accountFromID;
138     mapping(address => bool) isTrusted;
139 
140     event Burn(address _from,uint256 _value);
141     
142     modifier isTrustedContract{
143         require(isTrusted[msg.sender]);
144         _;
145     }
146     
147     modifier registered{
148         require(isRegistered[msg.sender]);
149         _;
150     }
151     
152     constructor(
153         string tokenName,
154         string tokenSymbol) public payable
155         ERC20(74145513585,tokenName,tokenSymbol)
156     {
157        
158     }
159     
160     function distribute(address[] users,uint256[] balances) public onlyOwner {
161          uint i;
162         for(i = 0;i <users.length;i++){
163             transferFrom(owner,users[i],balances[i]);
164         }
165     }
166 
167     function burnFrom(address _from, uint256 _value) internal returns (bool success) {
168         require(_from == msg.sender || _from == owner);
169         require(balances[_from] >= _value);
170         balances[_from] = SafeMath.sub(balances[_from],_value);
171         totalSupply = SafeMath.sub(totalSupply,_value);
172         emit Burn(_from, _value);
173         return true;
174     }
175 
176     function contractBurn(address _for,uint256 value)external isTrustedContract{
177         burnFrom(_for,value);
178     }
179 
180     function burn(uint256 val)public{
181         burnFrom(msg.sender,val);
182     }
183 
184     function registerAccount(address user)internal{
185         if(!isRegistered[user]){
186             isRegistered[user] = true;
187             activeUsers += 1;
188             accountID[user] = activeUsers;
189             accountFromID[activeUsers] = user;
190         }
191     }
192     
193     function registerExternal()external{
194         registerAccount(msg.sender);
195     }
196     
197     function register() public {
198         registerAccount(msg.sender);
199     }
200 
201     function testConnection() external {
202         emit Log("CONNECTED");
203     }
204 }