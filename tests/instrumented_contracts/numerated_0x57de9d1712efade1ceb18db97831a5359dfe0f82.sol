1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Controlled {
30     address public controller;
31     /// @notice The address of the controller is the only address that can call
32     ///  a function with this modifier
33     modifier onlyController { require(msg.sender == controller); _; }
34 
35     // @notice Constructor
36     constructor() public { controller = msg.sender;}
37 
38     /// @notice Changes the controller of the contract
39     /// @param _newController The new controller of the contract
40     function changeController(address _newController) public onlyController {
41         controller = _newController;
42     }
43 }
44 
45 // ERC Token Standard #20 Interface
46 contract ERC20Interface {
47     function totalSupply() public constant returns (uint);
48     function balanceOf(address tokenOwner) public constant returns (uint balance);
49     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
50     function transfer(address to, uint tokens) public returns (bool success);
51     function approve(address spender, uint tokens) public returns (bool success);
52     function transferFrom(address from, address to, uint tokens) public returns (bool success);
53 
54     event Transfer(address indexed from, address indexed to, uint tokens);
55     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
56 }
57 
58 contract SofiaToken is ERC20Interface,Controlled {
59 
60     using SafeMath for uint;
61 
62     string public symbol;
63     string public  name;
64     uint8 public decimals;
65     uint public totalSupply;
66 
67     mapping(address => uint) balances;
68     mapping(address => mapping(address => uint)) allowed;
69 
70     /*
71      * @notice 'constructor()' initiates the Token by setting its funding
72        parameters
73      * @param _totalSupply Total supply of tokens
74      */
75     constructor(uint _totalSupply) public {
76       symbol = "SFX";
77       name = "Sofia Token";
78       decimals = 18;
79       totalSupply = _totalSupply.mul(1 ether);
80       balances[msg.sender] = totalSupply; //transfer all Tokens to contract creator
81       emit Transfer(address(0),controller,totalSupply);
82     }
83 
84     /*
85      * @notice ERC20 Standard method to return total number of tokens
86      */
87     function totalSupply() public view returns (uint){
88       return totalSupply;
89     }
90 
91     /*
92      * @notice ERC20 Standard method to return the token balance of an address
93      * @param tokenOwner Address to query
94      */
95     function balanceOf(address tokenOwner) public view returns (uint balance){
96        return balances[tokenOwner];
97     }
98 
99     /*
100      * @notice ERC20 Standard method to return spending allowance
101      * @param tokenOwner Owner of the tokens, who allows
102      * @param spender Token spender
103      */
104     function allowance(address tokenOwner, address spender) public view returns (uint remaining){
105       if (allowed[tokenOwner][spender] < balances[tokenOwner]) {
106         return allowed[tokenOwner][spender];
107       }
108       return balances[tokenOwner];
109     }
110 
111     /*
112      * @notice ERC20 Standard method to tranfer tokens
113      * @param to Address where the tokens will be transfered to
114      * @param tokens Number of tokens to be transfered
115      */
116     function transfer(address to, uint tokens) public  returns (bool success){
117       return doTransfer(msg.sender,to,tokens);
118     }
119 
120     /*
121      * @notice ERC20 Standard method to transfer tokens on someone elses behalf
122      * @param from Address where the tokens are held
123      * @param to Address where the tokens will be transfered to
124      * @param tokens Number of tokens to be transfered
125      */
126     function transferFrom(address from, address to, uint tokens) public returns (bool success){
127       if(allowed[from][msg.sender] > 0 && allowed[from][msg.sender] >= tokens)
128       {
129         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
130         return doTransfer(from,to,tokens);
131       }
132       return false;
133     }
134 
135     /*
136      * @notice method that does the actual transfer of the tokens, to be used by both transfer and transferFrom methods
137      * @param from Address where the tokens are held
138      * @param to Address where the tokens will be transfered to
139      * @param tokens Number of tokens to be transfered
140      */
141     function doTransfer(address from,address to, uint tokens) internal returns (bool success){
142         if( tokens > 0 && balances[from] >= tokens){
143             balances[from] = balances[from].sub(tokens);
144             balances[to] = balances[to].add(tokens);
145             emit Transfer(from,to,tokens);
146             return true;
147         }
148         return false;
149     }
150 
151     /*
152      * @notice ERC20 Standard method to give a spender an allowance
153      * @param spender Address that wil receive the allowance
154      * @param tokens Number of tokens in the allowance
155      */
156     function approve(address spender, uint tokens) public returns (bool success){
157       if(balances[msg.sender] >= tokens){
158         allowed[msg.sender][spender] = tokens;
159         emit Approval(msg.sender,spender,tokens);
160         return true;
161       }
162       return false;
163     }
164 
165     /*
166      * @notice revert any incoming ether
167      */
168     function () public payable {
169         revert();
170     }
171 
172   /*
173    * @notice a specific amount of tokens. Only controller can burn tokens
174    * @param _value The amount of token to be burned.
175    */
176   function burn(uint _value) public onlyController{
177     require(_value <= balances[msg.sender]);
178     balances[msg.sender] = balances[msg.sender].sub(_value);
179     totalSupply = totalSupply.sub(_value);
180     emit Burn(msg.sender, _value);
181     emit Transfer(msg.sender, address(0), _value);
182   }
183 
184   /*
185    * Events
186    */
187   event Transfer(address indexed from, address indexed to, uint tokens);
188   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
189   event Burn(address indexed burner, uint value);
190 }