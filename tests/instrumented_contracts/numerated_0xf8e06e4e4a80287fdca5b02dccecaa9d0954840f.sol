1 pragma solidity ^ 0.4.17;
2 
3 
4 library SafeMath {
5     function mul(uint a, uint b) pure internal returns(uint) {
6         uint c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11 
12     function sub(uint a, uint b) pure internal returns(uint) {
13         assert(b <= a);
14         return a - b;
15     }
16 
17     function add(uint a, uint b) pure internal returns(uint) {
18         uint c = a + b;
19         assert(c >= a && c >= b);
20         return c;
21     }
22 }
23 
24 
25 contract ERC20 {
26     uint public totalSupply;
27 
28     function balanceOf(address who) public view returns(uint);
29 
30     function allowance(address owner, address spender) public view returns(uint);
31 
32     function transfer(address to, uint value) public returns(bool ok);
33 
34     function transferFrom(address from, address to, uint value) public returns(bool ok);
35 
36     function approve(address spender, uint value) public returns(bool ok);
37 
38     event Transfer(address indexed from, address indexed to, uint value);
39     event Approval(address indexed owner, address indexed spender, uint value);
40 }
41 
42 
43 contract Ownable {
44     address public owner;
45 
46     function Ownable() public {
47         owner = msg.sender;
48     }
49 
50     function transferOwnership(address newOwner) public onlyOwner {
51         if (newOwner != address(0)) 
52             owner = newOwner;
53     }
54 
55     function kill() public {
56         if (msg.sender == owner) 
57             selfdestruct(owner);
58     }
59 
60     modifier onlyOwner() {
61         if (msg.sender == owner)
62             _;
63     }
64 }
65 
66 
67 // The token
68 contract Token is ERC20, Ownable {
69 
70     using SafeMath for uint;
71     // Public variables of the token
72     string public name;
73     string public symbol;
74     uint8 public decimals; // How many decimals to show.
75     string public version = "v0.1";       
76     uint public totalSupply;
77     bool public locked;
78     address public crowdSaleAddress;
79     
80 
81 
82     mapping(address => uint) balances;
83     mapping(address => mapping(address => uint)) allowed;
84 
85     // tokens are locked during the ICO. Allow transfer of tokens after ICO. 
86     modifier onlyUnlocked() {
87         if (msg.sender != crowdSaleAddress && locked) 
88             revert();
89         _;
90     }
91 
92     // allow burning of tokens only by authorized users 
93     modifier onlyAuthorized() {
94         if (msg.sender != owner && msg.sender != crowdSaleAddress) 
95             revert();
96         _;
97     }
98 
99     // The Token 
100     function Token(address _crowdSaleAddress) public {
101         
102         locked = true;  // Lock the Crowdsale function during the crowdsale
103         totalSupply = 300000000e18; 
104         name = "TGAME"; // Set the name for display purposes
105         symbol = "TGAME"; // Set the symbol for display purposes
106         decimals = 18; // Amount of decimals for display purposes
107         crowdSaleAddress = _crowdSaleAddress;                             
108         balances[crowdSaleAddress] = totalSupply;
109     }
110 
111 
112     function updateCrowdsaleAddress(address _crowdSaleAddress) public onlyOwner() {
113 
114           crowdSaleAddress = _crowdSaleAddress; 
115     }
116 
117     function unlock() public onlyAuthorized {
118         locked = false;
119     }
120 
121     function lock() public onlyAuthorized {
122         locked = true;
123     }
124     
125     function burn( address _member, uint256 _value) public onlyAuthorized returns(bool) {
126         balances[_member] = balances[_member].sub(_value);
127         totalSupply = totalSupply.sub(_value);
128         Transfer(_member, 0x0, _value);
129         return true;
130     }
131 
132     function returnTokens(address _member, uint256 _value) public onlyAuthorized returns(bool) {
133         balances[_member] = balances[_member].sub(_value);
134         balances[crowdSaleAddress] = balances[crowdSaleAddress].add(_value);
135         Transfer(_member, crowdSaleAddress, _value);
136         return true;
137     }
138 
139     function transfer(address _to, uint _value) public onlyUnlocked returns(bool) {
140         balances[msg.sender] = balances[msg.sender].sub(_value);
141         balances[_to] = balances[_to].add(_value);
142         Transfer(msg.sender, _to, _value);
143         return true;
144     }
145     
146     function transferFrom(address _from, address _to, uint256 _value) public onlyUnlocked returns(bool success) {
147         require(balances[_from] >= _value); // Check if the sender has enough                            
148         require(_value <= allowed[_from][msg.sender]); // Check if allowed is greater or equal        
149         balances[_from] = balances[_from].sub(_value); // Subtract from the sender
150         balances[_to] = balances[_to].add(_value); // Add the same to the recipient
151         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152         Transfer(_from, _to, _value);
153         return true;
154     }
155 
156     function balanceOf(address _owner) public view returns(uint balance) {
157         return balances[_owner];
158     }
159 
160 
161     /**
162     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
163     *
164     * Beware that changing an allowance with this method brings the risk that someone may use both the old
165     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
166     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
167     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168     * @param _spender The address which will spend the funds.
169     * @param _value The amount of tokens to be spent.
170     */
171     function approve(address _spender, uint _value) public returns(bool) {
172         allowed[msg.sender][_spender] = _value;
173         Approval(msg.sender, _spender, _value);
174         return true;
175     }
176 
177     function allowance(address _owner, address _spender) public view returns(uint remaining) {
178         return allowed[_owner][_spender];
179     }
180 
181     /**
182     * approve should be called when allowed[_spender] == 0. To increment
183     * allowed value is better to use this function to avoid 2 calls (and wait until
184     * the first transaction is mined)
185     * From MonolithDAO Token.sol
186     */
187     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
188         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
189         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190         return true;
191     }
192 
193     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
194         uint oldValue = allowed[msg.sender][_spender];
195         if (_subtractedValue > oldValue) {
196             allowed[msg.sender][_spender] = 0;
197         } else {
198             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
199         }
200         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201         return true;
202     }
203 
204 }