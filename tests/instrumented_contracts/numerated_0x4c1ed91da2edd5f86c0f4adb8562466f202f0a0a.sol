1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 // Owned contract
5 // ----------------------------------------------------------------------------
6 contract Owned {
7     address public owner;
8     address public newOwner;
9 
10     event OwnershipTransferred(address indexed _from, address indexed _to);
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address _newOwner) public onlyOwner {
18         newOwner = _newOwner;
19     }
20     function acceptOwnership() public {
21         require(msg.sender == newOwner);
22         emit OwnershipTransferred(owner, newOwner);
23         owner = newOwner;
24         newOwner = address(0);
25     }
26 }
27 
28 // ----------------------------------------------------------------------------
29 // Safe maths
30 // ----------------------------------------------------------------------------
31 library SafeMath {
32     function add(uint a, uint b) internal pure returns (uint c) {
33         c = a + b;
34         require(c >= a);
35     }
36     function sub(uint a, uint b) internal pure returns (uint c) {
37         require(b <= a);
38         c = a - b;
39     }
40     function mul(uint a, uint b) internal pure returns (uint c) {
41         c = a * b;
42         require(a == 0 || c / a == b);
43     }
44     function div(uint a, uint b) internal pure returns (uint c) {
45         require(b > 0);
46         c = a / b;
47     }
48 }
49 
50 // ----------------------------------------------------------------------------
51 // ERC Token Standard #20 Interface
52 // ----------------------------------------------------------------------------
53 contract ERC20Interface {
54     function totalSupply() public constant returns (uint);
55     function balanceOf(address tokenOwner) public constant returns (uint balance);
56     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
57     function transfer(address to, uint tokens) public returns (bool success);
58     function approve(address spender, uint tokens) public returns (bool success);
59     function transferFrom(address from, address to, uint tokens) public returns (bool success);
60 
61     event Transfer(address indexed from, address indexed to, uint tokens);
62     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
63 }
64 
65 contract BelottoCoin is ERC20Interface, Owned{
66     using SafeMath for uint;
67     
68     string public symbol;
69     string public name;
70     uint8 public decimals;
71     uint public _totalSupply;
72     mapping(address => uint) balances;
73     mapping(address => mapping(address => uint)) allowed;
74 
75     // ------------------------------------------------------------------------
76     // Constructor
77     // ------------------------------------------------------------------------
78     function BelottoCoin(address _owner) public{
79         symbol = "BEL";
80         name = "Belotto";
81         decimals = 18;
82         owner = _owner;
83         _totalSupply = totalSupply();
84         balances[owner] = _totalSupply;
85         emit Transfer(address(0),owner,_totalSupply);
86     }
87     
88     function sender() public view returns (address sender){
89         return msg.sender;
90     }
91 
92     function totalSupply() public constant returns (uint){
93        return 1200000000 * 10**uint(decimals);
94     }
95 
96     // ------------------------------------------------------------------------
97     // Get the token balance for account `tokenOwner`
98     // ------------------------------------------------------------------------
99     function balanceOf(address tokenOwner) public constant returns (uint balance) {
100         return balances[tokenOwner];
101     }
102 
103     // ------------------------------------------------------------------------
104     // Transfer the balance from token owner's account to `to` account
105     // - Owner's account must have sufficient balance to transfer
106     // - 0 value transfers are allowed
107     // ------------------------------------------------------------------------
108     function transfer(address to, uint tokens) public returns (bool success) {
109         // prevent transfer to 0x0, use burn instead
110         require(to != 0x0);
111         require(balances[msg.sender] >= tokens );
112         require(balances[to] + tokens >= balances[to]);
113         balances[msg.sender] = balances[msg.sender].sub(tokens);
114         balances[to] = balances[to].add(tokens);
115         emit Transfer(msg.sender,to,tokens);
116         return true;
117     }
118     
119     // ------------------------------------------------------------------------
120     // Token owner can approve for `spender` to transferFrom(...) `tokens`
121     // from the token owner's account
122     // ------------------------------------------------------------------------
123     function approve(address spender, uint tokens) public returns (bool success){
124         allowed[msg.sender][spender] = tokens;
125         emit Approval(msg.sender,spender,tokens);
126         return true;
127     }
128 
129     // ------------------------------------------------------------------------
130     // Transfer `tokens` from the `from` account to the `to` account
131     // 
132     // The calling account must already have sufficient tokens approve(...)-d
133     // for spending from the `from` account and
134     // - From account must have sufficient balance to transfer
135     // - Spender must have sufficient allowance to transfer
136     // - 0 value transfers are allowed
137     // ------------------------------------------------------------------------
138     function transferFrom(address from, address to, uint tokens) public returns (bool success){
139         require(tokens <= allowed[from][msg.sender]); //check allowance
140         require(balances[from] >= tokens);
141         balances[from] = balances[from].sub(tokens);
142         balances[to] = balances[to].add(tokens);
143         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
144         emit Transfer(from,to,tokens);
145         return true;
146     }
147     // ------------------------------------------------------------------------
148     // Returns the amount of tokens approved by the owner that can be
149     // transferred to the spender's account
150     // ------------------------------------------------------------------------
151     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
152         return allowed[tokenOwner][spender];
153     }
154     
155     event Burn(address indexed burner, uint256 value);
156 
157     function burn(uint256 _value) public {
158         require(_value <= balances[msg.sender]);
159         address burner = msg.sender;
160         balances[burner] = balances[burner].sub(_value);
161         Burn(burner, _value);
162     }
163 }