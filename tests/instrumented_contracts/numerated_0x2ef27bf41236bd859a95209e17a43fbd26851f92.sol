1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * 
6  * This contract is used to set admin to the contract  which has some additional features such as minting , burning etc
7  * 
8  */
9     contract Owned {
10         address public owner;
11 
12         function owned() public {
13             owner = msg.sender;
14         }
15 
16         modifier onlyOwner {
17             require(msg.sender == owner);
18             _;
19         }
20         
21         /* This function is used to transfer adminship to new owner
22          * @param  _newOwner - address of new admin or owner        
23          */
24 
25         function transferOwnership(address _newOwner) onlyOwner public {
26             owner = _newOwner;
27         }          
28     }
29 
30 
31 /**
32  * This is base ERC20 Contract , basically ERC-20 defines a common list of rules for all Ethereum tokens to follow
33  */ 
34 
35 contract ERC20 {
36   
37   using SafeMath for uint256;
38 
39   //This creates an array with all balances 
40   mapping (address => uint256) public balanceOf;
41   mapping (address => mapping (address => uint256)) allowed;  
42 
43   //This maintains list of all black list account
44   mapping(address => bool) public isblacklistedAccount;
45     
46   // public variables of the token  
47   string public name;
48   string public symbol;
49   uint8 public decimals = 4;
50   uint256 public totalSupply;
51    
52   // This notifies client about the approval done by owner to spender for a given value
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 
55   // This notifies client about the approval done
56   event Transfer(address indexed from, address indexed to, uint256 value);
57  
58   
59   function ERC20(uint256 _initialSupply,string _tokenName, string _tokenSymbol) public {    
60     totalSupply = _initialSupply * 10 ** uint256(decimals); // Update total supply with the decimal amount     
61     balanceOf[msg.sender] = totalSupply;  
62     name = _tokenName;
63     symbol = _tokenSymbol;   
64   }
65   
66     /* This function is used to transfer tokens to a particular address 
67      * @param _to receiver address where transfer is to be done
68      * @param _value value to be transferred
69      */
70 	function transfer(address _to, uint256 _value) public returns (bool) {
71         require(!isblacklistedAccount[msg.sender]);                 // Check if sender is not blacklisted
72         require(!isblacklistedAccount[_to]);                        // Check if receiver is not blacklisted
73 		require(balanceOf[msg.sender] > 0);                     
74 		require(balanceOf[msg.sender] >= _value);                   // Check if the sender has enough  
75 		require(_to != address(0));                                 // Prevent transfer to 0x0 address. Use burn() instead
76 		require(_value > 0);
77 		require(balanceOf[_to] .add(_value) >= balanceOf[_to]);     // Check for overflows 
78 		require(_to != msg.sender);                                 // Check if sender and receiver is not same
79 		balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);  // Subtract value from sender
80 		balanceOf[_to] = balanceOf[_to].add(_value);                // Add the value to the receiver
81 		Transfer(msg.sender, _to, _value);                          // Notify all clients about the transfer events
82         return true;
83 	}
84 
85 	/* Send _value amount of tokens from address _from to address _to
86      * The transferFrom method is used for a withdraw workflow, allowing contracts to send
87      * tokens on your behalf
88      * @param _from address from which amount is to be transferred
89      * @param _to address to which amount is transferred
90      * @param _amount to which amount is transferred
91      */
92     function transferFrom(
93          address _from,
94          address _to,
95          uint256 _amount
96      ) public returns (bool success)
97       {
98          if (balanceOf[_from] >= _amount
99              && allowed[_from][msg.sender] >= _amount
100              && _amount > 0
101              && balanceOf[_to].add(_amount) > balanceOf[_to])
102         {
103              balanceOf[_from] = balanceOf[_from].sub(_amount);
104              allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
105              balanceOf[_to] = balanceOf[_to].add(_amount);
106              return true;
107         } else {
108              return false;
109         }
110     }
111     
112     /* This function allows _spender to withdraw from your account, multiple times, up to the _value amount.
113      * If this function is called again it overwrites the current allowance with _value.
114      * @param _spender address of the spender
115      * @param _amount amount allowed to be withdrawal
116      */
117      function approve(address _spender, uint256 _amount) public returns (bool success) {
118          allowed[msg.sender][_spender] = _amount;
119          Approval(msg.sender, _spender, _amount);
120          return true;
121     } 
122 
123     /* This function returns the amount of tokens approved by the owner that can be
124      * transferred to the spender's account
125      * @param _owner address of the owner
126      * @param _spender address of the spender 
127      */
128     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
129          return allowed[_owner][_spender];
130     }
131 }
132 
133 
134 /**
135  * @title SafeMath
136  * @dev Math operations with safety checks that throw on error
137  */
138 library SafeMath {
139   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140     if (a == 0) {
141       return 0;
142     }
143     uint256 c = a * b;
144     assert(c / a == b);
145     return c;
146   }
147 
148   function div(uint256 a, uint256 b) internal pure returns (uint256) {
149     // assert(b > 0); // Solidity automatically throws when dividing by 0
150     uint256 c = a / b;
151     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
152     return c;
153   }
154 
155   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156     assert(b <= a);
157     return a - b;
158   }
159 
160   function add(uint256 a, uint256 b) internal pure returns (uint256) {
161     uint256 c = a + b;
162     assert(c >= a);
163     return c;
164   }
165 }
166 
167 
168 
169 //This is the Main Morph Token Contract derived from the other two contracts Owned and ERC20
170 contract MorphToken is Owned, ERC20 {
171 
172     using SafeMath for uint256;
173 
174     uint256  tokenSupply = 100000000; 
175              
176     // This notifies clients about the amount burnt , only admin is able to burn the contract
177     event Burn(address from, uint256 value); 
178     
179     /* This is the main Token Constructor 
180      * @param _centralAdmin  Address of the admin of the contract
181      */
182 	function MorphToken() 
183 
184 	ERC20 (tokenSupply,"MORPH","MORPH") public
185     {
186 		owner = msg.sender;
187 	}
188 
189        
190     /* This function is used to Blacklist a user or unblacklist already blacklisted users, blacklisted users are not able to transfer funds
191      * only admin can invoke this function
192      * @param _target address of the target 
193      * @param _isBlacklisted boolean value
194      */
195     function blacklistAccount(address _target, bool _isBlacklisted) public onlyOwner {
196         isblacklistedAccount[_target] = _isBlacklisted;       
197     }
198 
199 
200     /* This function is used to mint additional tokens
201      * only admin can invoke this function
202      * @param _mintedAmount amount of tokens to be minted  
203      */
204     function mintTokens(uint256 _mintedAmount) public onlyOwner {
205         balanceOf[owner] = balanceOf[owner].add(_mintedAmount);
206         totalSupply = totalSupply.add(_mintedAmount);
207         Transfer(0, owner, _mintedAmount);      
208     }    
209 
210      /**
211     * This function Burns a specific amount of tokens.
212     * @param _value The amount of token to be burned.
213     */
214     function burn(uint256 _value) public onlyOwner {
215       require(_value <= balanceOf[msg.sender]);
216       // no need to require value <= totalSupply, since that would imply the
217       // sender's balance is greater than the totalSupply, which *should* be an assertion failure
218       address burner = msg.sender;
219       balanceOf[burner] = balanceOf[burner].sub(_value);
220       totalSupply = totalSupply.sub(_value);
221       Burn(burner, _value);
222   }
223 }