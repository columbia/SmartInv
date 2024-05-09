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
67 // The ETHD Token 
68 contract Token is ERC20,  Ownable {
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
92 
93     // allow burning of tokens only by authorized users 
94     modifier onlyAuthorized() {
95         if (msg.sender != owner && msg.sender != crowdSaleAddress ) 
96             revert();
97         _;
98     }
99 
100 
101     // The Token 
102     function Token(address _crowdSaleAddress) public {
103         
104         locked = true;  // Lock the transfCrowdsaleer function during the crowdsale
105         totalSupply = 21000000e18; 
106         name = "Lottery Token"; // Set the name for display purposes
107         symbol = "ETHD"; // Set the symbol for display purposes
108         decimals = 18; // Amount of decimals for display purposes
109         crowdSaleAddress = _crowdSaleAddress;                                  
110         balances[crowdSaleAddress] = totalSupply;
111     }
112 
113     function unlock() public onlyAuthorized {
114         locked = false;
115     }
116 
117     function lock() public onlyAuthorized {
118         locked = true;
119     }
120     
121 
122     function burn( address _member, uint256 _value) public onlyAuthorized returns(bool) {
123         balances[_member] = balances[_member].sub(_value);
124         totalSupply = totalSupply.sub(_value);
125         Transfer(_member, 0x0, _value);
126         return true;
127     }
128 
129     function transfer(address _to, uint _value) public onlyUnlocked returns(bool) {
130         balances[msg.sender] = balances[msg.sender].sub(_value);
131         balances[_to] = balances[_to].add(_value);
132         Transfer(msg.sender, _to, _value);
133         return true;
134     }
135 
136     
137     function transferFrom(address _from, address _to, uint256 _value) public onlyUnlocked returns(bool success) {
138         require (balances[_from] >= _value); // Check if the sender has enough                            
139         require (_value <= allowed[_from][msg.sender]); // Check if allowed is greater or equal        
140         balances[_from] = balances[_from].sub(_value); // Subtract from the sender
141         balances[_to] = balances[_to].add(_value); // Add the same to the recipient
142         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143         Transfer(_from, _to, _value);
144         return true;
145     }
146 
147     function balanceOf(address _owner) public view returns(uint balance) {
148         return balances[_owner];
149     }
150 
151 
152     /**
153     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154     *
155     * Beware that changing an allowance with this method brings the risk that someone may use both the old
156     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
157     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
158     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159     * @param _spender The address which will spend the funds.
160     * @param _value The amount of tokens to be spent.
161     */
162     function approve(address _spender, uint _value) public returns(bool) {
163         allowed[msg.sender][_spender] = _value;
164         Approval(msg.sender, _spender, _value);
165         return true;
166     }
167 
168 
169     function allowance(address _owner, address _spender) public constant returns(uint remaining) {
170         return allowed[_owner][_spender];
171     }
172 
173     /**
174     * approve should be called when allowed[_spender] == 0. To increment
175     * allowed value is better to use this function to avoid 2 calls (and wait until
176     * the first transaction is mined)
177     * From MonolithDAO Token.sol
178     */
179     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
180         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
181         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182         return true;
183     }
184 
185     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
186         uint oldValue = allowed[msg.sender][_spender];
187         if (_subtractedValue > oldValue) {
188         allowed[msg.sender][_spender] = 0;
189         } else {
190         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
191         }
192         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193         return true;
194     }
195 
196 }