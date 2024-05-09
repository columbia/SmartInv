1 pragma solidity ^ 0.4.17;
2 
3 library SafeMath {
4     function mul(uint a, uint b) pure internal returns(uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10 
11     function sub(uint a, uint b) pure internal returns(uint) {
12         assert(b <= a);
13         return a - b;
14     }
15 
16     function add(uint a, uint b) pure internal returns(uint) {
17         uint c = a + b;
18         assert(c >= a && c >= b);
19         return c;
20     }
21 }
22 
23 contract ERC20 {
24     uint public totalSupply;
25 
26     function balanceOf(address who) public view returns(uint);
27 
28     function allowance(address owner, address spender) public view returns(uint);
29 
30     function transfer(address to, uint value) public returns(bool ok);
31 
32     function transferFrom(address from, address to, uint value) public returns(bool ok);
33 
34     function approve(address spender, uint value) public returns(bool ok);
35 
36     event Transfer(address indexed from, address indexed to, uint value);
37     event Approval(address indexed owner, address indexed spender, uint value);
38 }
39 
40 
41 contract Ownable {
42     address public owner;
43 
44     function Ownable() public {
45         owner = msg.sender;
46     }
47 
48     function transferOwnership(address newOwner) public onlyOwner {
49         if (newOwner != address(0)) 
50             owner = newOwner;
51     }
52 
53     function kill() public {
54         if (msg.sender == owner) 
55             selfdestruct(owner);
56     }
57 
58     modifier onlyOwner() {
59         if (msg.sender == owner)
60             _;
61     }
62 }
63 
64 
65 
66 
67 
68 
69 // The token
70 contract Token is ERC20,  Ownable {
71 
72     using SafeMath for uint;
73     // Public variables of the token
74     string public name;
75     string public symbol;
76     uint8 public decimals; // How many decimals to show.
77     string public version = "v0.1";       
78     uint public totalSupply;
79     bool public locked;
80     address public crowdSaleAddress;
81     
82 
83 
84     mapping(address => uint) balances;
85     mapping(address => mapping(address => uint)) allowed;
86 
87     // tokens are locked during the ICO. Allow transfer of tokens after ICO. 
88     modifier onlyUnlocked() {
89         if (msg.sender != crowdSaleAddress && locked) 
90             revert();
91         _;
92     }
93 
94 
95     // allow burning of tokens only by authorized users 
96     modifier onlyAuthorized() {
97         if (msg.sender != owner && msg.sender != crowdSaleAddress ) 
98             revert();
99         _;
100     }
101 
102 
103     // The Token 
104     function Token(address _crowdSaleAddress) public {
105         
106         locked = true;  // Lock the Crowdsale function during the crowdsale
107         totalSupply = 60000000e18; 
108         name = "Requitix"; // Set the name for display purposes
109         symbol = "RQX"; // Set the symbol for display purposes
110         decimals = 18; // Amount of decimals for display purposes
111         crowdSaleAddress = _crowdSaleAddress;                                  
112         balances[crowdSaleAddress] = totalSupply;
113     }
114 
115     function unlock() public onlyAuthorized {
116         locked = false;
117     }
118 
119     function lock() public onlyAuthorized {
120         locked = true;
121     }
122     
123 
124     function burn( address _member, uint256 _value) public onlyAuthorized returns(bool) {
125         balances[_member] = balances[_member].sub(_value);
126         totalSupply = totalSupply.sub(_value);
127         Transfer(_member, 0x0, _value);
128         return true;
129     }
130 
131     function transfer(address _to, uint _value) public onlyUnlocked returns(bool) {
132         balances[msg.sender] = balances[msg.sender].sub(_value);
133         balances[_to] = balances[_to].add(_value);
134         Transfer(msg.sender, _to, _value);
135         return true;
136     }
137 
138     
139     function transferFrom(address _from, address _to, uint256 _value) public onlyUnlocked returns(bool success) {
140         require (balances[_from] >= _value); // Check if the sender has enough                            
141         require (_value <= allowed[_from][msg.sender]); // Check if allowed is greater or equal        
142         balances[_from] = balances[_from].sub(_value); // Subtract from the sender
143         balances[_to] = balances[_to].add(_value); // Add the same to the recipient
144         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
145         Transfer(_from, _to, _value);
146         return true;
147     }
148 
149     function balanceOf(address _owner) public view returns(uint balance) {
150         return balances[_owner];
151     }
152 
153 
154     /**
155     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
156     *
157     * Beware that changing an allowance with this method brings the risk that someone may use both the old
158     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
159     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
160     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161     * @param _spender The address which will spend the funds.
162     * @param _value The amount of tokens to be spent.
163     */
164     function approve(address _spender, uint _value) public returns(bool) {
165         allowed[msg.sender][_spender] = _value;
166         Approval(msg.sender, _spender, _value);
167         return true;
168     }
169 
170 
171     function allowance(address _owner, address _spender) public view returns(uint remaining) {
172         return allowed[_owner][_spender];
173     }
174 
175     /**
176     * approve should be called when allowed[_spender] == 0. To increment
177     * allowed value is better to use this function to avoid 2 calls (and wait until
178     * the first transaction is mined)
179     * From MonolithDAO Token.sol
180     */
181     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
182         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
183         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184         return true;
185     }
186 
187     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
188         uint oldValue = allowed[msg.sender][_spender];
189         if (_subtractedValue > oldValue) {
190         allowed[msg.sender][_spender] = 0;
191         } else {
192         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
193         }
194         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195         return true;
196     }
197 
198 }