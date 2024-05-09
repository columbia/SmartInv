1 pragma solidity ^0.4.21;
2 
3 
4 contract Ownable {
5     address public owner;
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9     /**
10      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
11      * account.
12      */
13     function Ownable() public {
14         owner = msg.sender;
15     }
16 
17     /**
18      * @dev Throws if called by any account other than the owner.
19      */
20     modifier onlyOwner() {
21         require(msg.sender == owner);
22         _;
23     }
24 
25     /**
26      * @dev Allows the current owner to transfer control of the contract to a newOwner.
27      * @param newOwner The address to transfer ownership to.
28      */
29     function transferOwnership(address newOwner) public onlyOwner {
30         require(newOwner != address(0));
31         emit OwnershipTransferred(owner, newOwner);
32         owner = newOwner;
33     }
34 
35 }
36 
37 /**
38  * @title SafeMath
39  * @dev Math operations with safety checks that throw on error
40  */
41 library SafeMath {
42 
43   /**
44   * @dev Multiplies two numbers, throws on overflow.
45   */
46   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47     if (a == 0) {
48       return 0;
49     }
50     uint256 c = a * b;
51     assert(c / a == b);
52     return c;
53   }
54 
55   /**
56   * @dev Integer division of two numbers, truncating the quotient.
57   */
58   function div(uint256 a, uint256 b) internal pure returns (uint256) {
59     // assert(b > 0); // Solidity automatically throws when dividing by 0
60     uint256 c = a / b;
61     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62     return c;
63   }
64 
65   /**
66   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
67   */
68   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69     assert(b <= a);
70     return a - b;
71   }
72 
73   /**
74   * @dev Adds two numbers, throws on overflow.
75   */
76   function add(uint256 a, uint256 b) internal pure returns (uint256) {
77     uint256 c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 
83 
84 interface tokenRecipient {
85     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
86 }
87 
88 contract DigiWillToken is Ownable {
89     using SafeMath for uint256;
90 
91     string public name = "DigiWillToken";           //The Token's name: e.g. DigixDAO Tokens
92     uint8 public decimals = 18;             //Number of decimals of the smallest unit
93     string public symbol = "DGW";         //An identifier: e.g. REP
94     uint public totalSupply;
95 
96     mapping (address => uint256) public balances;
97     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
98     mapping (address => mapping (address => uint256)) public allowed;
99 
100 ////////////////
101 // Constructor
102 ////////////////
103 
104     /// @notice Constructor to create a DigiWillToken
105     function DigiWillToken() public {
106         totalSupply = 200000100 * 10**18;
107         // Give the creator all initial tokens
108         balances[msg.sender] = totalSupply;
109     }
110 
111 
112 ///////////////////
113 // ERC20 Methods
114 ///////////////////
115 
116     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
117     /// @param _to The address of the recipient
118     /// @param _amount The amount of tokens to be transferred
119     /// @return Whether the transfer was successful or not
120     function transfer(address _to, uint256 _amount) public returns (bool success) {
121         doTransfer(msg.sender, _to, _amount);
122         return true;
123     }
124 
125     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
126     ///  is approved by `_from`
127     /// @param _from The address holding the tokens being transferred
128     /// @param _to The address of the recipient
129     /// @param _amount The amount of tokens to be transferred
130     /// @return True if the transfer was successful
131     function transferFrom(address _from, address _to, uint256 _amount
132     ) public returns (bool success) {
133         // The standard ERC 20 transferFrom functionality
134         require(allowed[_from][msg.sender] >= _amount);
135         allowed[_from][msg.sender] -= _amount;
136         doTransfer(_from, _to, _amount);
137         return true;
138     }
139 
140     /// @dev This is the actual transfer function in the token contract, it can
141     ///  only be called by other functions in this contract.
142     /// @param _from The address holding the tokens being transferred
143     /// @param _to The address of the recipient
144     /// @param _amount The amount of tokens to be transferred
145     /// @return True if the transfer was successful
146     function doTransfer(address _from, address _to, uint _amount) internal {
147         // Do not allow transfer to 0x0 or the token contract itself
148         require((_to != 0) && (_to != address(this)));
149         require(_amount <= balances[_from]);
150         balances[_from] = balances[_from].sub(_amount);
151         balances[_to] = balances[_to].add(_amount);
152         emit Transfer(_from, _to, _amount);
153 		}
154 
155     /// @return The balance of `_owner`
156     function balanceOf(address _owner) public constant returns (uint256 balance) {
157         return balances[_owner];
158     }
159 
160     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
161     ///  its behalf. This is a modified version of the ERC20 approve function
162     ///  to be a little bit safer
163     /// @param _spender The address of the account able to transfer the tokens
164     /// @param _amount The amount of tokens to be approved for transfer
165     /// @return True if the approval was successful
166     function approve(address _spender, uint256 _amount) public returns (bool success) {
167         // To change the approve amount you first have to reduce the addresses`
168         //  allowance to zero by calling `approve(_spender,0)` if it is not
169         //  already 0 to mitigate the race condition described here:
170         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
172 
173         allowed[msg.sender][_spender] = _amount;
174         emit Approval(msg.sender, _spender, _amount);
175         return true;
176     }
177 
178     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
179         tokenRecipient spender = tokenRecipient(_spender);
180         if (approve(_spender, _value)) {
181             spender.receiveApproval(msg.sender, _value, this, _extraData);
182             return true;
183         }
184     }
185 
186     function burn(uint256 _value) public onlyOwner {
187         require(balances[msg.sender] >= _value);
188         balances[msg.sender] = balances[msg.sender].sub(_value);
189         totalSupply = totalSupply.sub(_value);
190     }
191 
192     /// @dev This function makes it easy to read the `allowed[]` map
193     /// @param _owner The address of the account that owns the token
194     /// @param _spender The address of the account able to transfer the tokens
195     /// @return Amount of remaining tokens of _owner that _spender is allowed
196     ///  to spend
197     function allowance(address _owner, address _spender
198     ) public constant returns (uint256 remaining) {
199         return allowed[_owner][_spender];
200     }
201 
202     /// @dev This function makes it easy to get the total number of tokens
203     /// @return The total number of tokens
204     function totalSupply() public constant returns (uint) {
205         return totalSupply;
206     }
207 
208     event Transfer(
209         address indexed _from,
210         address indexed _to,
211         uint256 _amount
212         );
213 
214     event Approval(
215         address indexed _owner,
216         address indexed _spender,
217         uint256 _amount
218         );
219 
220     event Burn(
221         address indexed _burner,
222         uint256 _amount
223         );
224     
225 }