1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes  _extraData) external; 
5 }
6 
7 
8 
9 
10 //begin Ownable.sol
11 
12 /**
13  * @title Ownable
14  * @dev The Ownable contract has an owner address, and provides basic authorization control
15  * functions, this simplifies the implementation of "user permissions".
16  */
17 contract Ownable {
18   address public owner;
19 
20 
21   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23 
24   /**
25    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26    * account.
27    */
28   function Ownable() public {
29     owner = msg.sender;
30   }
31 
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41 
42   /**
43    * @dev Allows the current owner to transfer control of the contract to a newOwner.
44    * @param newOwner The address to transfer ownership to.
45    */
46   function transferOwnership(address newOwner) public onlyOwner {
47     require(newOwner != address(0));
48     OwnershipTransferred(owner, newOwner);
49     owner = newOwner;
50   }
51 
52 }
53 
54 //end Ownable.sol
55 
56 // ----------------- 
57 //begin Pausable.sol
58 
59 
60 
61 /**
62  * @title Pausable
63  * @dev Base contract which allows children to implement an emergency stop mechanism.
64  */
65 contract Pausable is Ownable {
66   event Pause();
67   event Unpause();
68 
69   bool public paused = false;
70 
71 
72   /**
73    * @dev Modifier to make a function callable only when the contract is not paused.
74    */
75   modifier whenNotPaused() {
76     require(!paused);
77     _;
78   }
79 
80   /**
81    * @dev Modifier to make a function callable only when the contract is paused.
82    */
83   modifier whenPaused() {
84     require(paused);
85     _;
86   }
87 
88   /**
89    * @dev called by the owner to pause, triggers stopped state
90    */
91   function pause() onlyOwner whenNotPaused public {
92     paused = true;
93     Pause();
94   }
95 
96   /**
97    * @dev called by the owner to unpause, returns to normal state
98    */
99   function unpause() onlyOwner whenPaused public {
100     paused = false;
101     Unpause();
102   }
103 }
104 
105 //end Pausable.sol
106 
107 
108 
109 
110 
111 
112 
113 contract IABToken is Pausable {
114     // Public variables of the token
115     string public name;
116     string public symbol;
117     uint8 public decimals = 3;
118     // 18 decimals is the strongly suggested default, avoid changing it
119     uint256 public totalSupply;
120 
121     // This creates an array with all balances
122     mapping (address => uint256) public balanceOf;
123     mapping (address => mapping (address => uint256)) public allowance;
124 
125     // This generates a public event on the blockchain that will notify clients
126     event Transfer(address indexed from, address indexed to, uint256 value);
127     
128     // This generates a public event on the blockchain that will notify clients
129     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
130 
131     // This notifies clients about the amount burnt
132     event Burn(address indexed from, uint256 value);
133 
134     /**
135      * Constructor function
136      *
137      * Initializes contract with initial supply tokens to the creator of the contract
138      */
139     constructor(
140        // uint256 initialSupply,
141         //string memory tokenName,
142         //string memory tokenSymbol
143     ) public {
144         totalSupply = 100000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
145         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
146         name = "InternetAnywhere";                                   // Set the name for display purposes
147         symbol = "IABT";                               // Set the symbol for display purposes
148     }
149 
150     /**
151      * Internal transfer, only can be called by this contract
152      */
153     function _transfer(address _from, address _to, uint _value) internal {
154         // Prevent transfer to 0x0 address. Use burn() instead
155         require(_to != address(0x0));
156         // Check if the sender has enough
157         require(balanceOf[_from] >= _value);
158         // Check for overflows
159         require(balanceOf[_to] + _value >= balanceOf[_to]);
160         // Save this for an assertion in the future
161         uint previousBalances = balanceOf[_from] + balanceOf[_to];
162         // Subtract from the sender
163         balanceOf[_from] -= _value;
164         // Add the same to the recipient
165         balanceOf[_to] += _value;
166         emit Transfer(_from, _to, _value);
167         // Asserts are used to use static analysis to find bugs in your code. They should never fail
168         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
169     }
170 
171     /**
172      * Transfer tokens
173      *
174      * Send `_value` tokens to `_to` from your account
175      *
176      * @param _to The address of the recipient
177      * @param _value the amount to send
178      */
179     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
180         _transfer(msg.sender, _to, _value);
181         return true;
182     }
183 
184 
185 
186     /**
187      * Destroy tokens
188      *
189      * Remove `_value` tokens from the system irreversibly
190      *
191      * @param _value the amount of money to burn
192      */
193     function burn(uint256 _value) public returns (bool success) {
194         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
195         balanceOf[msg.sender] -= _value;            // Subtract from the sender
196         totalSupply -= _value;                      // Updates totalSupply
197         emit Burn(msg.sender, _value);
198         return true;
199     }
200     
201     
202 
203 }