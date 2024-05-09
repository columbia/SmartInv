1 pragma solidity ^ 0.4.17;
2 
3 contract SafeMath {
4     function safeMul(uint a, uint b) pure internal returns(uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function safeSub(uint a, uint b) pure internal returns(uint) {
11         assert(b <= a);
12         return a - b;
13     }
14 
15     function safeAdd(uint a, uint b) pure internal returns(uint) {
16         uint c = a + b;
17         assert(c >= a && c >= b);
18         return c;
19     }
20 }
21 
22 contract ERC20 {
23     uint public totalSupply;
24 
25     function balanceOf(address who) public view returns(uint);
26 
27     function allowance(address owner, address spender) public view returns(uint);
28 
29     function transfer(address to, uint value) public returns(bool ok);
30 
31     function transferFrom(address from, address to, uint value) public returns(bool ok);
32 
33     function approve(address spender, uint value) public returns(bool ok);
34 
35     event Transfer(address indexed from, address indexed to, uint value);
36     event Approval(address indexed owner, address indexed spender, uint value);
37 }
38 
39 
40 contract Ownable {
41     address public owner;
42 
43     function Ownable() public {
44         owner = msg.sender;
45     }
46 
47     function transferOwnership(address newOwner) public onlyOwner {
48         if (newOwner != address(0)) 
49             owner = newOwner;
50     }
51 
52     function kill() public {
53         if (msg.sender == owner) 
54             selfdestruct(owner);
55     }
56 
57     modifier onlyOwner() {
58         if (msg.sender == owner)
59             _;
60     }
61 }
62 
63 
64 
65 
66 
67 // The PPP token
68 contract Token is ERC20, SafeMath, Ownable {
69     // Public variables of the token
70     string public name;
71     string public symbol;
72     uint8 public decimals; // How many decimals to show.
73     string public version = "v0.1";
74     uint public initialSupply;
75     uint public totalSupply;
76     bool public locked;   
77     address public preSaleAddress;       
78     mapping(address => uint) balances;
79     mapping(address => mapping(address => uint)) allowed;
80 
81     // Lock transfer for contributors during the ICO 
82     modifier onlyUnlocked() {
83         if (msg.sender != preSaleAddress && locked) 
84             revert();
85         _;
86     }
87 
88     modifier onlyAuthorized() {
89         if (msg.sender != owner) 
90             revert();
91         _;
92     }
93 
94     // The PPP Token created with the time at which the crowdsale ends
95     function Token() public {
96         // Lock the transfCrowdsaleer function during the crowdsale
97         locked = true;
98         initialSupply = 165000000e18;
99         totalSupply = initialSupply;
100         name = "PayPie"; // Set the name for display purposes
101         symbol = "PPP"; // Set the symbol for display purposes
102         decimals = 18; // Amount of decimals for display purposes        
103         preSaleAddress = 0xf8A15b1540d5f9D002D9cCb7FD1F23E795c2859d;      
104 
105         // Allocate tokens for pre-sale customers - private sale 
106         balances[preSaleAddress] = 82499870672369211638818601 - 2534559883e16;
107         // Allocate tokens for the team/reserve/advisors/
108         balances[0xF821Fd99BCA2111327b6a411C90BE49dcf78CE0f] = totalSupply - balances[preSaleAddress];       
109     }
110 
111     function unlock() public onlyAuthorized {
112         locked = false;
113     }
114 
115     function lock() public onlyAuthorized {
116         locked = true;
117     }
118 
119     function burn( address _member, uint256 _value) public onlyAuthorized returns(bool) {
120         balances[_member] = safeSub(balances[_member], _value);
121         totalSupply = safeSub(totalSupply, _value);
122         Transfer(_member, 0x0, _value);
123         return true;
124     }
125 
126     function transfer(address _to, uint _value) public onlyUnlocked returns(bool) {
127         balances[msg.sender] = safeSub(balances[msg.sender], _value);
128         balances[_to] = safeAdd(balances[_to], _value);
129         Transfer(msg.sender, _to, _value);
130         return true;
131     }
132 
133     
134     function transferFrom(address _from, address _to, uint256 _value) public onlyUnlocked returns(bool success) {
135         require(_to != address(0));
136         require (balances[_from] >= _value); // Check if the sender has enough                            
137         require (_value <= allowed[_from][msg.sender]); // Check if allowed is greater or equal        
138         balances[_from] = safeSub(balances[_from], _value); // Subtract from the sender
139         balances[_to] = safeAdd(balances[_to],_value); // Add the same to the recipient
140         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);  // decrease allowed amount
141         Transfer(_from, _to, _value);
142         return true;
143     }
144 
145     function balanceOf(address _owner) public view returns(uint balance) {
146         return balances[_owner];
147     }
148 
149 
150   /**
151    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152    *
153    * Beware that changing an allowance with this method brings the risk that someone may use both the old
154    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157    * @param _spender The address which will spend the funds.
158    * @param _value The amount of tokens to be spent.
159    */
160     function approve(address _spender, uint _value) public returns(bool) {
161         allowed[msg.sender][_spender] = _value;
162         Approval(msg.sender, _spender, _value);
163         return true;
164     }
165 
166 
167     function allowance(address _owner, address _spender) public view returns(uint remaining) {
168         return allowed[_owner][_spender];
169     }
170 
171 
172     /**
173    * approve should be called when allowed[_spender] == 0. To increment
174    * allowed value is better to use this function to avoid 2 calls (and wait until
175    * the first transaction is mined)
176    * From MonolithDAO Token.sol
177    */
178   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
179     allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender], _addedValue);
180     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181     return true;
182   }
183 
184   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
185     uint oldValue = allowed[msg.sender][_spender];
186     if (_subtractedValue > oldValue) {
187       allowed[msg.sender][_spender] = 0;
188     } else {
189       allowed[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);
190     }
191     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192     return true;
193   }
194 
195 }