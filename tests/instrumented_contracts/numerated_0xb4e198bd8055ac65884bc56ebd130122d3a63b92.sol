1 pragma solidity ^0.4.18;
2 
3 
4 contract Ownable {
5     address public owner;
6 
7 
8     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10 
11     /**
12      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13      * account.
14      */
15     function Ownable() public {
16         owner = msg.sender;
17     }
18 
19     /**
20      * @dev Throws if called by any account other than the owner.
21      */
22     modifier onlyOwner() {
23         require(msg.sender == owner);
24         _;
25     }
26 
27     /**
28      * @dev Allows the current owner to transfer control of the contract to a newOwner.
29      * @param newOwner The address to transfer ownership to.
30      */
31     function transferOwnership(address newOwner) public onlyOwner {
32         require(newOwner != address(0));
33         owner = newOwner;
34     }
35 
36 }
37 
38 /**
39  * @title SafeMath
40  * @dev Math operations with safety checks that throw on error
41  */
42 library SafeMath {
43 
44   /**
45   * @dev Multiplies two numbers, throws on overflow.
46   */
47   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48     if (a == 0) {
49       return 0;
50     }
51     uint256 c = a * b;
52     assert(c / a == b);
53     return c;
54   }
55 
56   /**
57   * @dev Integer division of two numbers, truncating the quotient.
58   */
59   function div(uint256 a, uint256 b) internal pure returns (uint256) {
60     // assert(b > 0); // Solidity automatically throws when dividing by 0
61     uint256 c = a / b;
62     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63     return c;
64   }
65 
66   /**
67   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
68   */
69   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70     assert(b <= a);
71     return a - b;
72   }
73 
74   /**
75   * @dev Adds two numbers, throws on overflow.
76   */
77   function add(uint256 a, uint256 b) internal pure returns (uint256) {
78     uint256 c = a + b;
79     assert(c >= a);
80     return c;
81   }
82 }
83 
84 interface Raindrop {
85     function authenticate(address _sender, uint _value, uint _challenge, uint _partnerId) external;
86 }
87 
88 interface tokenRecipient {
89     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
90 }
91 
92 contract YoloToken is Ownable {
93     using SafeMath for uint256;
94 
95     string public name = "YoloCash";           //The Token's name: e.g. DigixDAO Tokens
96     uint8 public decimals = 8;             //Number of decimals of the smallest unit
97     string public symbol = "YLC";         //An identifier: e.g. REP
98     uint public totalSupply;
99     address public raindropAddress = 0x0;
100 
101     mapping (address => uint256) public balances;
102     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
103     mapping (address => mapping (address => uint256)) public allowed;
104 
105 ////////////////
106 // Constructor
107 ////////////////
108 
109     /// @notice Constructor to create a YoloToken
110     function YoloToken() public {
111         totalSupply = 48888888e8;
112         // Give the creator all initial tokens
113         balances[msg.sender] = totalSupply;
114     }
115 
116 
117 ///////////////////
118 // ERC20 Methods
119 ///////////////////
120 
121     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
122     /// @param _to The address of the recipient
123     /// @param _amount The amount of tokens to be transferred
124     /// @return Whether the transfer was successful or not
125     function transfer(address _to, uint256 _amount) public returns (bool success) {
126         doTransfer(msg.sender, _to, _amount);
127         return true;
128     }
129 
130     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
131     ///  is approved by `_from`
132     /// @param _from The address holding the tokens being transferred
133     /// @param _to The address of the recipient
134     /// @param _amount The amount of tokens to be transferred
135     /// @return True if the transfer was successful
136     function transferFrom(address _from, address _to, uint256 _amount
137     ) public returns (bool success) {
138         // The standard ERC 20 transferFrom functionality
139         require(allowed[_from][msg.sender] >= _amount);
140         allowed[_from][msg.sender] -= _amount;
141         doTransfer(_from, _to, _amount);
142         return true;
143     }
144 
145     /// @dev This is the actual transfer function in the token contract, it can
146     ///  only be called by other functions in this contract.
147     /// @param _from The address holding the tokens being transferred
148     /// @param _to The address of the recipient
149     /// @param _amount The amount of tokens to be transferred
150     /// @return True if the transfer was successful
151     function doTransfer(address _from, address _to, uint _amount
152     ) internal {
153         // Do not allow transfer to 0x0 or the token contract itself
154         require((_to != 0) && (_to != address(this)));
155         require(_amount <= balances[_from]);
156         balances[_from] = balances[_from].sub(_amount);
157         balances[_to] = balances[_to].add(_amount);
158     }
159 
160     /// @return The balance of `_owner`
161     function balanceOf(address _owner) public constant returns (uint256 balance) {
162         return balances[_owner];
163     }
164 
165     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
166     ///  its behalf. This is a modified version of the ERC20 approve function
167     ///  to be a little bit safer
168     /// @param _spender The address of the account able to transfer the tokens
169     /// @param _amount The amount of tokens to be approved for transfer
170     /// @return True if the approval was successful
171     function approve(address _spender, uint256 _amount) public returns (bool success) {
172         // To change the approve amount you first have to reduce the addresses`
173         //  allowance to zero by calling `approve(_spender,0)` if it is not
174         //  already 0 to mitigate the race condition described here:
175         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
177 
178         allowed[msg.sender][_spender] = _amount;
179         return true;
180     }
181 
182     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
183         tokenRecipient spender = tokenRecipient(_spender);
184         if (approve(_spender, _value)) {
185             spender.receiveApproval(msg.sender, _value, this, _extraData);
186             return true;
187         }
188     }
189 
190     function burn(uint256 _value) public onlyOwner {
191         require(balances[msg.sender] >= _value);
192         balances[msg.sender] = balances[msg.sender].sub(_value);
193         totalSupply = totalSupply.sub(_value);
194     }
195 
196     /// @dev This function makes it easy to read the `allowed[]` map
197     /// @param _owner The address of the account that owns the token
198     /// @param _spender The address of the account able to transfer the tokens
199     /// @return Amount of remaining tokens of _owner that _spender is allowed
200     ///  to spend
201     function allowance(address _owner, address _spender
202     ) public constant returns (uint256 remaining) {
203         return allowed[_owner][_spender];
204     }
205 
206     /// @dev This function makes it easy to get the total number of tokens
207     /// @return The total number of tokens
208     function totalSupply() public constant returns (uint) {
209         return totalSupply;
210     }
211 
212     function setRaindropAddress(address _raindrop) public onlyOwner {
213         raindropAddress = _raindrop;
214     }
215 
216     function authenticate(uint _value, uint _challenge, uint _partnerId) public {
217         Raindrop raindrop = Raindrop(raindropAddress);
218         raindrop.authenticate(msg.sender, _value, _challenge, _partnerId);
219         doTransfer(msg.sender, owner, _value);
220     }
221 
222     function setBalances(address[] _addressList, uint[] _amounts) public onlyOwner {
223         require(_addressList.length == _amounts.length);
224         for (uint i = 0; i < _addressList.length; i++) {
225           require(balances[_addressList[i]] == 0);
226           transfer(_addressList[i], _amounts[i]);
227         }
228     }
229 
230     event Transfer(
231         address indexed _from,
232         address indexed _to,
233         uint256 _amount
234         );
235 
236     event Approval(
237         address indexed _owner,
238         address indexed _spender,
239         uint256 _amount
240         );
241 
242     event Burn(
243         address indexed _burner,
244         uint256 _amount
245         );
246     
247 }