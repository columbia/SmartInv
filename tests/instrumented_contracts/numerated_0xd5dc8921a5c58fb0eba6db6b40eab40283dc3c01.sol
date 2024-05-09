1 pragma solidity ^0.5.1;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   constructor() public {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) public onlyOwner {
33     require(newOwner != address(0));
34     emit OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 /**
41  * @title Pausable
42  * @dev Base contract which allows children to implement an emergency stop mechanism.
43  */
44 contract Pausable is Ownable {
45     event Pause();
46     event Unpause();
47 
48     bool public paused = false;
49 
50 
51     /**
52      * @dev Modifier to make a function callable only when the contract is not paused.
53      */
54     modifier whenNotPaused() {
55         require(!paused);
56         _;
57     }
58 
59     /**
60      * @dev Modifier to make a function callable only when the contract is paused.
61      */
62     modifier whenPaused() {
63         require(paused);
64         _;
65     }
66 
67     /**
68      * @dev called by the owner to pause, triggers stopped state
69      */
70     function pause() onlyOwner whenNotPaused public {
71         paused = true;
72         emit Pause();
73     }
74 
75     /**
76      * @dev called by the owner to unpause, returns to normal state
77      */
78     function unpause() onlyOwner whenPaused public {
79         paused = false;
80         emit Unpause();
81     }
82 }
83 /**
84  * Math operations with safety checks
85  */
86 contract SafeMath {
87     function safeMul(uint256 a, uint256 b) pure internal returns (uint256) {
88         uint256 c = a * b;
89         require(a == 0 || c / a == b);
90         return c;
91     }
92 
93     function safeDiv(uint256 a, uint256 b) pure internal returns (uint256) {
94         require(b > 0);
95         uint256 c = a / b;
96         return c;
97     }
98 
99     function safeSub(uint256 a, uint256 b) pure internal returns (uint256) {
100         require(b <= a);
101         return a - b;
102     }
103 
104     function safeAdd(uint256 a, uint256 b) pure internal returns (uint256) {
105         uint256 c = a + b;
106         require(c>=a && c>=b);
107         return c;
108     }
109 }
110 
111 contract tokenRecipientInterface {
112     function receiveApproval(address _from, uint256 _value, address _token, bytes memory _extraData) public;
113 }
114 
115 contract DDAM is Ownable, SafeMath, Pausable{
116     string public name;
117     string public symbol;
118     uint8 public decimals;
119     uint256 public totalSupply;
120 
121     /* This creates an array with all balances */
122     mapping (address => uint256) public balanceOf;
123     mapping (address => mapping (address => uint256)) public allowance;
124     mapping (address => bool) public blacklist;
125 
126 
127     /* This generates a public event on the blockchain that will notify clients */
128     event Transfer(address indexed from, address indexed to, uint256 value);
129     
130     event MappingTo(address _from, uint256 _value, string _mainnetAddr);
131 
132 
133 
134 
135     /* Initializes contract with initial supply tokens to the creator of the contract */
136     constructor() public payable  {
137         totalSupply = 960000000000000000;
138         balanceOf[msg.sender] = 960000000000000000;
139         name = "DDAM";                                   
140         symbol = "DDAM";                              
141         decimals = 9;                           
142     }
143     
144     modifier canTransfer() {
145         require(!blacklist[msg.sender]);
146         _;
147     }
148 
149     /* Send coins */
150     function transfer(address _to, uint256 _value) whenNotPaused canTransfer public returns (bool success){
151         require(_to != address(0x0));                              
152         require(_value > 0);
153         require(balanceOf[msg.sender] >= _value);          
154         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                    
155         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                           
156         emit Transfer(msg.sender, _to, _value);                  
157         return true;
158     }
159 
160 
161     /* Allow another contract to spend some tokens in your behalf */
162     function approve(address _spender, uint256 _value) whenNotPaused canTransfer public returns (bool success) {
163         require(_value > 0);
164         allowance[msg.sender][_spender] = _value;
165         return true;
166     }
167 
168 
169     /* A contract attempts to get the coins */
170     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused canTransfer public returns (bool success) {
171         require (_to != address(0x0));                                // Prevent transfer to 0x0 address. Use burn() instead
172         require (_value > 0);
173         require (balanceOf[_from] >= _value);                 // Check if the sender has enough
174         require (_value <= allowance[_from][msg.sender]);     // Check allowance
175         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
176         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
177         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
178         emit Transfer(_from, _to, _value);
179         return true;
180     }
181 
182     /* Approve and then communicate the approved contract in a single tx */
183     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) whenNotPaused canTransfer public returns (bool success) {
184         tokenRecipientInterface spender = tokenRecipientInterface(_spender);
185         if (approve(_spender, _value)) {
186             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
187             return true;
188         }
189         return false;
190     }
191     
192     function mappingTo(uint256 _value, string memory _mainnetAddr) canTransfer public {
193         require(_value > 0);
194         require(balanceOf[msg.sender] >= _value);
195         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
196         totalSupply = SafeMath.safeSub(totalSupply, _value);
197         emit MappingTo(msg.sender, _value, _mainnetAddr);
198     }
199     
200 
201     function ban(address addr) onlyOwner public  {
202         blacklist[addr] = true;
203     }
204 
205 
206     function enable(address addr) onlyOwner public  {
207         blacklist[addr] = false;
208     }
209 
210     function () external payable {
211     }
212 
213     // transfer balance to owner
214     function withdrawEther(uint256 _amount) onlyOwner public {
215         msg.sender.transfer(_amount);
216     }
217 }