1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5   function mul(uint a, uint b) internal pure returns (uint) {
6     if (a == 0) {
7       return 0;
8     }
9     uint c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) internal pure returns (uint) {
15     uint c = a / b;
16     return c;
17   }
18 
19   function sub(uint a, uint b) internal pure returns (uint) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint a, uint b) internal pure returns (uint) {
25     uint c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract owned {
32     event TransferOwnership(address _owner, address _newOwner);
33     event OwnerUpdate(address _prevOwner, address _newOwner);
34     event TransferByOwner(address fromAddress, address toAddress, uint tokens);
35     event Pause();
36     event Unpause();
37     
38     address public owner;
39     address public newOwner = 0x0;
40     bool public paused = false;
41 
42     constructor () public {
43         owner = msg.sender; 
44     }
45 
46     modifier onlyOwner {
47         require (msg.sender == owner);
48         _;
49     }
50     
51     // ------------------------------------------------------------------------
52     // Modifier to make a function callable only when the contract is not paused.
53     // ------------------------------------------------------------------------
54     modifier whenNotPaused() {
55         require(!paused);
56         _;
57     }
58     
59     // ------------------------------------------------------------------------
60     // Modifier to make a function callable only when the contract is paused.
61     // ------------------------------------------------------------------------
62     modifier whenPaused() {
63         require(paused);
64         _;
65     }
66    
67     // ------------------------------------------------------------------------
68     // transfer owner to new address
69     // ------------------------------------------------------------------------
70     function transferOwnership(address _newOwner) public onlyOwner {
71         require(_newOwner != owner);
72         newOwner = _newOwner;
73         emit TransferOwnership(owner, _newOwner);
74     }
75     
76     // ------------------------------------------------------------------------
77     // accept the ownership
78     // ------------------------------------------------------------------------
79     function acceptOwnership() public{
80         require(msg.sender == newOwner);
81         emit OwnerUpdate(owner, newOwner);
82         owner = newOwner;
83         newOwner = 0x0;
84     }
85       
86     // ------------------------------------------------------------------------
87     // called by the owner to pause, triggers stopped state
88     // ------------------------------------------------------------------------
89     function pause() public onlyOwner whenNotPaused {
90         paused = true;
91         emit Pause();
92     }
93     
94     // ------------------------------------------------------------------------
95     // called by the owner to unpause, returns to normal state
96     // ------------------------------------------------------------------------
97     function unpause() public onlyOwner whenPaused {
98         paused = false;
99         emit Unpause();
100     }
101 }
102 
103 contract ERC20Interface {
104     function totalSupply() public constant returns (uint);
105     function balanceOf(address tokenOwner) public constant returns (uint balance);
106     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
107     function transfer(address to, uint tokens) public returns (bool success);
108     function approve(address spender, uint tokens) public returns (bool success);
109     function transferFrom(address from, address to, uint tokens) public returns (bool success);
110 
111     event Transfer(address indexed from, address indexed to, uint tokens);
112     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);  
113 }
114 
115 contract  GoodsToken is ERC20Interface, owned {
116     using SafeMath for uint;   
117     string public name; 
118     string public symbol; 
119     uint public decimals;
120     uint internal maxSupply; 
121     uint public totalSupply; 
122     address public beneficiary;
123     
124     mapping (address => uint) public balances;
125     mapping(address => mapping(address => uint)) public allowed;
126   
127     constructor() public {         
128         name = "GoodsToken";    
129         symbol = "GDS";    
130         decimals = 18;
131         maxSupply = 100000000 * (10 ** decimals);   
132         totalSupply = maxSupply;//totalSupply.add(maxSupply);
133         beneficiary = msg.sender;
134         balances[beneficiary] = balances[beneficiary].add(totalSupply);
135     }
136     
137     // ------------------------------------------------------------------------
138     // Total supply
139     // ------------------------------------------------------------------------
140     function totalSupply() public constant returns (uint) {
141         return totalSupply  - balances[address(0)];
142     }
143 
144     // ------------------------------------------------------------------------
145     // Get the token balance for account tokenOwner
146     // ------------------------------------------------------------------------
147     function balanceOf(address tokenOwner) public constant returns (uint balance) {
148         return balances[tokenOwner];
149     }
150 
151     // ------------------------------------------------------------------------
152     // Transfer the balance from token owner's account to to account
153     // - Owner's account must have sufficient balance to transfer
154     // - 0 value transfers are allowed
155     // ------------------------------------------------------------------------
156     function transfer(address _to, uint _value) public whenNotPaused returns (bool success) {
157         if (balances[msg.sender] < _value) revert() ;           
158         if (balances[_to] + _value < balances[_to]) revert(); 
159         balances[msg.sender] = balances[msg.sender].sub(_value); 
160         balances[_to] = balances[_to].add(_value);
161         emit Transfer(msg.sender, _to, _value);          
162         return true;
163     }
164     
165     //----------------------------------------------------------
166     //transfer By Owner 
167     //----------------------------------------------------------------------------
168     function transferByOwner(address _from, address _to, uint _value) public onlyOwner returns (bool success) {
169         if (balances[_from] < _value) revert(); 
170         if (balances[_to] + _value < balances[_to]) revert();
171         balances[_from] = balances[_from].sub(_value);
172         balances[_to] = balances[_to].add(_value); 
173         emit Transfer(_from, _to, _value);
174         emit TransferByOwner(_from, _to, _value);
175         return true;
176     }
177     // ------------------------------------------------------------------------
178     // Token owner can approve for spender to transferFrom(...) tokens
179     // from the token owner's account
180     // recommends that there are no checks for the approval double-spend attack
181     // as this should be implemented in user interfaces 
182     // ------------------------------------------------------------------------
183     function approve(address spender, uint tokens) public whenNotPaused returns (bool success) {
184         allowed[msg.sender][spender] = tokens;
185         emit Approval(msg.sender, spender, tokens);
186         return true;
187     }
188     
189     // ------------------------------------------------------------------------
190     // Transfer tokens from the from account to the to account
191     //
192     // The calling account must already have sufficient tokens approve(...)-d
193     // for spending from the from account and
194     // - From account must have sufficient balance to transfer
195     // - Spender must have sufficient allowance to transfer
196     // - 0 value transfers are allowed
197     // ------------------------------------------------------------------------
198    function transferFrom(address _from, address _to, uint _value) public whenNotPaused returns (bool success) {
199         if (balances[_from] < _value) revert();                
200         if (balances[_to] + _value < balances[_to]) revert(); 
201         if (_value > allowed[_from][msg.sender]) revert(); 
202         balances[_from] = balances[_from].sub(_value);                     
203         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
204 		balances[_to] = balances[_to].add(_value); 
205         emit Transfer(_from, _to, _value);
206         return true;
207     }
208 
209     // ------------------------------------------------------------------------
210     // Returns the amount of tokens approved by the owner that can be
211     // transferred to the spender's account
212     // ------------------------------------------------------------------------
213     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
214         return allowed[tokenOwner][spender];
215     }
216 
217     // ------------------------------------------------------------------------
218     // Don't accept ETH
219     // ------------------------------------------------------------------------
220     function () public payable {
221         revert();  
222     }  
223 }