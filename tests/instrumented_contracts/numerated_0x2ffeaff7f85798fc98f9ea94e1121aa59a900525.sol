1 pragma solidity ^0.5.1;
2 
3 contract ERC20 {
4   function transferFrom(address from, address to, uint256 value) public returns (bool);
5 }
6 
7 contract Ownable {
8   address public owner;
9 
10 
11   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21 
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 /**
45  * @title Pausable
46  * @dev Base contract which allows children to implement an emergency stop mechanism.
47  */
48 contract Pausable is Ownable {
49     event Pause();
50     event Unpause();
51 
52     bool public paused = false;
53 
54 
55     /**
56      * @dev Modifier to make a function callable only when the contract is not paused.
57      */
58     modifier whenNotPaused() {
59         require(!paused);
60         _;
61     }
62 
63     /**
64      * @dev Modifier to make a function callable only when the contract is paused.
65      */
66     modifier whenPaused() {
67         require(paused);
68         _;
69     }
70 
71     /**
72      * @dev called by the owner to pause, triggers stopped state
73      */
74     function pause() onlyOwner whenNotPaused public {
75         paused = true;
76         emit Pause();
77     }
78 
79     /**
80      * @dev called by the owner to unpause, returns to normal state
81      */
82     function unpause() onlyOwner whenPaused public {
83         paused = false;
84         emit Unpause();
85     }
86 }
87 /**
88  * Math operations with safety checks
89  */
90 contract SafeMath {
91     function safeMul(uint256 a, uint256 b) pure internal returns (uint256) {
92         uint256 c = a * b;
93         require(a == 0 || c / a == b);
94         return c;
95     }
96 
97     function safeDiv(uint256 a, uint256 b) pure internal returns (uint256) {
98         require(b > 0);
99         uint256 c = a / b;
100         return c;
101     }
102 
103     function safeSub(uint256 a, uint256 b) pure internal returns (uint256) {
104         require(b <= a);
105         return a - b;
106     }
107 
108     function safeAdd(uint256 a, uint256 b) pure internal returns (uint256) {
109         uint256 c = a + b;
110         require(c>=a && c>=b);
111         return c;
112     }
113 }
114 
115 contract tokenRecipientInterface {
116     function receiveApproval(address _from, uint256 _value, address _token, bytes memory _extraData) public;
117 }
118 
119 contract TZVC is Ownable, SafeMath, Pausable{
120     string public name;
121     string public symbol;
122     uint8 public decimals;
123     uint256 public totalSupply;
124     uint256 public tokenLeft;
125     address public tokenAddress;
126 
127     /* This creates an array with all balances */
128     mapping (address => uint256) public balanceOf;
129     mapping (address => mapping (address => uint256)) public allowance;
130 
131 
132     /* This generates a public event on the blockchain that will notify clients */
133     event Transfer(address indexed from, address indexed to, uint256 value);
134     
135     // ZVC to TZVC
136     event Mapping(address _from, uint256 _value, bytes _extraData);
137     
138     event Burn(address _from, uint256 _value, string _zvAddr);
139 
140 
141 
142 
143     /* Initializes contract with initial supply tokens to the creator of the contract */
144     constructor(address _tokenAddress) public payable  {
145         tokenLeft = 90000000000000000;              // Give the creator all initial tokens
146         totalSupply = 90000000000000000;                        // Update total supply
147         name = "TZVC";                                   // Set the name for display purposes
148         symbol = "TZVC";                               // Set the symbol for display purposes
149         decimals = 9;                            // Amount of decimals for display purposes
150         tokenAddress = _tokenAddress;
151     }
152 
153     /* Send coins */
154     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool success){
155         require(_to != address(0x0));                               // Prevent transfer to 0x0 address. Use burn() instead
156         require(_value > 0);
157         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
158         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
159         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
160         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
161         return true;
162     }
163 
164 
165     /* Allow another contract to spend some tokens in your behalf */
166     function approve(address _spender, uint256 _value) whenNotPaused public returns (bool success) {
167         require(_value > 0);
168         allowance[msg.sender][_spender] = _value;
169         return true;
170     }
171 
172 
173     /* A contract attempts to get the coins */
174     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool success) {
175         require (_to != address(0x0));                                // Prevent transfer to 0x0 address. Use burn() instead
176         require (_value > 0);
177         require (balanceOf[_from] >= _value);                 // Check if the sender has enough
178         require (_value <= allowance[_from][msg.sender]);     // Check allowance
179         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
180         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
181         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
182         emit Transfer(_from, _to, _value);
183         return true;
184     }
185 
186     /* Approve and then communicate the approved contract in a single tx */
187     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) whenNotPaused public returns (bool success) {
188         tokenRecipientInterface spender = tokenRecipientInterface(_spender);
189         if (approve(_spender, _value)) {
190             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
191             return true;
192         }
193         return false;
194     }
195     
196     function receiveApproval(address _from, uint256 _value, address _token, bytes memory _extraData) public {
197         require(_token == tokenAddress);
198         require(_value > 0);
199         require(_value <= tokenLeft);
200         ERC20 token = ERC20(_token);
201         if (token.transferFrom(_from, address(this), _value)) {
202             balanceOf[_from] = SafeMath.safeAdd(balanceOf[_from], _value);
203             tokenLeft = SafeMath.safeSub(tokenLeft, _value);
204             emit Mapping(_from, _value, _extraData);
205         }
206     }
207     
208     function burn(uint256 _value, string memory _zvAddr) public {
209         require(_value > 0);
210         require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
211         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);// Subtract from the sender
212         totalSupply = SafeMath.safeSub(totalSupply, _value);
213         emit Burn(msg.sender, _value, _zvAddr);// Notify
214     }
215 
216     function () external payable {
217     }
218 
219     // transfer balance to owner
220     function withdrawEther(uint256 _amount) public onlyOwner{
221         msg.sender.transfer(_amount);
222     }
223 }