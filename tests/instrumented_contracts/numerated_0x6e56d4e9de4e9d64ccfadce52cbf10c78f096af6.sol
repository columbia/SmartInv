1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title Snow Coin
5  * @author lan yuhang
6  */
7 
8 contract SafeMath {
9     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b > 0);
17         uint256 c = a / b;
18         assert(a == b * c + a % b);
19         return c;
20     }
21 
22     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a && c >= b);
30         return c;
31     }
32 }
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40     address public owner;
41 
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46     /**
47     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48     * account.
49     */
50     function Ownable() public {
51         owner = msg.sender;
52     }
53 
54 
55     /**
56     * @dev Throws if called by any account other than the owner.
57     */
58     modifier onlyOwner() {
59         require(msg.sender == owner);
60         _;
61     }
62 
63 
64     /**
65     * @dev Allows the current owner to transfer control of the contract to a newOwner.
66     * @param newOwner The address to transfer ownership to.
67     */
68     function transferOwnership(address newOwner) onlyOwner public {
69         require(newOwner != address(0));
70         emit OwnershipTransferred(owner, newOwner);
71         owner = newOwner;
72     }
73 }
74 
75 /**
76  * @title Pausable
77  * @dev Base contract which allows children to implement an emergency stop mechanism.
78  */
79 contract Pausable is Ownable {
80     event Pause();
81     event Unpause();
82 
83     bool public paused = false;
84 
85 
86     /**
87     * @dev Modifier to make a function callable only when the contract is not paused.
88     */
89     modifier whenNotPaused() {
90         require(!paused);
91         _;
92     }
93 
94     /**
95     * @dev Modifier to make a function callable only when the contract is paused.
96     */
97     modifier whenPaused() {
98         require(paused);
99         _;
100     }
101 
102     /**
103     * @dev called by the owner to pause, triggers stopped state
104     */
105     function pause() onlyOwner whenNotPaused public {
106         paused = true;
107         emit Pause();
108     }
109 
110     /**
111     * @dev called by the owner to unpause, returns to normal state
112     */
113     function unpause() onlyOwner whenPaused public {
114         paused = false;
115         emit Unpause();
116     }
117 }
118 
119 contract SNC is SafeMath, Pausable {
120 
121     string public name;
122     string public symbol;
123     uint8 public decimals;
124 
125     uint256 public totalSupply;
126 
127     address public owner;
128     
129     mapping(address => uint256) public balanceOf;
130     mapping(address => mapping(address => uint256)) public allowance;
131 
132     /* This generates a public event on the blockchain that will notify clients */
133     event Transfer(address indexed from, address indexed to, uint256 value);
134 
135     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
136 
137     /* Initializes contract with initial supply tokens to the creator of the contract */
138     function SNC() public {
139         totalSupply = (10**8) * (10**8);
140         name = "Snow Coin";                                 // Set the name for display purposes
141         symbol = "SNC";                                     // Set the symbol for display purposes
142         decimals = 8;                                       // Amount of decimals for display purposes
143         owner = msg.sender;
144         balanceOf[owner] = totalSupply;                     // Give the creator all tokens
145     }
146 
147     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
148         require(_value > 0);
149         require(balanceOf[msg.sender] >= _value);              // Check if the sender has enough
150         require(balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
151         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);   // Subtract from the sender
152         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                 // Add the same to the recipient
153         emit Transfer(msg.sender, _to, _value);                  // Notify anyone listening that this transfer took place
154         return true;
155     }
156 
157     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {
158         allowance[msg.sender][_spender] = _value;            // Set allowance
159         emit Approval(msg.sender, _spender, _value);              // Raise Approval event
160         return true;
161     }
162 
163     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {
164         require(balanceOf[_from] >= _value);                  // Check if the sender has enough
165         require(balanceOf[_to] + _value >= balanceOf[_to]);   // Check for overflows
166         require(_value <= allowance[_from][msg.sender]);      // Check allowance
167         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);    // Subtract from the sender
168         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);        // Add the same to the recipient
169         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
170         emit Transfer(_from, _to, _value);
171         return true;
172     }
173 
174     function totalSupply() constant public returns (uint256 Supply) {
175         return totalSupply;
176     }
177 
178     function balanceOf(address _owner) constant public returns (uint256 balance) {
179         return balanceOf[_owner];
180     }
181 
182     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
183         return allowance[_owner][_spender];
184     }
185 
186     function() public payable {
187         revert();
188     }
189 }