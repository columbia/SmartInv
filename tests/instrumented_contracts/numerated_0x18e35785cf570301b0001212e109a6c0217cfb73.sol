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
33         emit OwnershipTransferred(owner, newOwner);
34         owner = newOwner;
35     }
36 
37 }
38 
39 /**
40  * @title SafeMath
41  * @dev Math operations with safety checks that throw on error
42  */
43 library SafeMath {
44 
45   /**
46   * @dev Multiplies two numbers, throws on overflow.
47   */
48   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49     if (a == 0) {
50       return 0;
51     }
52     uint256 c = a * b;
53     assert(c / a == b);
54     return c;
55   }
56 
57   /**
58   * @dev Integer division of two numbers, truncating the quotient.
59   */
60   function div(uint256 a, uint256 b) internal pure returns (uint256) {
61     // assert(b > 0); // Solidity automatically throws when dividing by 0
62     uint256 c = a / b;
63     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64     return c;
65   }
66 
67   /**
68   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
69   */
70   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   /**
76   * @dev Adds two numbers, throws on overflow.
77   */
78   function add(uint256 a, uint256 b) internal pure returns (uint256) {
79     uint256 c = a + b;
80     assert(c >= a);
81     return c;
82   }
83 }
84 
85 interface Raindrop {
86     function authenticate(address _sender, uint _value, uint _challenge, uint _partnerId) external;
87 }
88 
89 interface tokenRecipient {
90     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
91 }
92 
93 contract SujiToken is Ownable {
94     using SafeMath for uint256;
95 
96     string public name = "SujiToken";           //The Token's name: e.g. DigixDAO Tokens
97     uint8 public decimals = 18;             //Number of decimals of the smallest unit
98     string public symbol = "SUJ";         //An identifier: e.g. REP
99     uint public totalSupply;
100     address public raindropAddress = 0x0;
101 
102     mapping (address => uint256) public balances;
103     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
104     mapping (address => mapping (address => uint256)) public allowed;
105 
106 ////////////////
107 // Constructor
108 ////////////////
109 
110     /// @notice Constructor to create a SujiToken
111     function SujiToken() public {
112         totalSupply = 10000000000 * 10**18;
113         // Give the creator all initial tokens
114         balances[msg.sender] = totalSupply;
115     }
116 
117 
118 ///////////////////
119 // ERC20 Methods
120 ///////////////////
121 
122     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
123     /// @param _to The address of the recipient
124     /// @param _amount The amount of tokens to be transferred
125     /// @return Whether the transfer was successful or not
126     function transfer(address _to, uint256 _amount) public returns (bool success) {
127         doTransfer(msg.sender, _to, _amount);
128         return true;
129     }
130 
131     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
132     ///  is approved by `_from`
133     /// @param _from The address holding the tokens being transferred
134     /// @param _to The address of the recipient
135     /// @param _amount The amount of tokens to be transferred
136     /// @return True if the transfer was successful
137     function transferFrom(address _from, address _to, uint256 _amount
138     ) public returns (bool success) {
139         // The standard ERC 20 transferFrom functionality
140         require(allowed[_from][msg.sender] >= _amount);
141         allowed[_from][msg.sender] -= _amount;
142         doTransfer(_from, _to, _amount);
143         return true;
144     }
145 
146     /// @dev This is the actual transfer function in the token contract, it can
147     ///  only be called by other functions in this contract.
148     /// @param _from The address holding the tokens being transferred
149     /// @param _to The address of the recipient
150     /// @param _amount The amount of tokens to be transferred
151     /// @return True if the transfer was successful
152     function doTransfer(address _from, address _to, uint _amount
153     ) internal {
154         // Do not allow transfer to 0x0 or the token contract itself
155         require((_to != 0) && (_to != address(this)));
156         require(_amount <= balances[_from]);
157         balances[_from] = balances[_from].sub(_amount);
158         balances[_to] = balances[_to].add(_amount);
159         emit Transfer(_from, _to, _amount);
160     }
161 
162     /// @return The balance of `_owner`
163     function balanceOf(address _owner) public constant returns (uint256 balance) {
164         return balances[_owner];
165     }
166 
167     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
168     ///  its behalf. This is a modified version of the ERC20 approve function
169     ///  to be a little bit safer
170     /// @param _spender The address of the account able to transfer the tokens
171     /// @param _amount The amount of tokens to be approved for transfer
172     /// @return True if the approval was successful
173     function approve(address _spender, uint256 _amount) public returns (bool success) {
174         // To change the approve amount you first have to reduce the addresses`
175         //  allowance to zero by calling `approve(_spender,0)` if it is not
176         //  already 0 to mitigate the race condition described here:
177         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
179 
180         allowed[msg.sender][_spender] = _amount;
181         emit Approval(msg.sender, _spender, _amount);
182         return true;
183     }
184 
185     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
186         tokenRecipient spender = tokenRecipient(_spender);
187         if (approve(_spender, _value)) {
188             spender.receiveApproval(msg.sender, _value, this, _extraData);
189             return true;
190         }
191     }
192 
193     function burn(uint256 _value) public onlyOwner {
194         require(balances[msg.sender] >= _value);
195         balances[msg.sender] = balances[msg.sender].sub(_value);
196         totalSupply = totalSupply.sub(_value);
197     }
198 
199     /// @dev This function makes it easy to read the `allowed[]` map
200     /// @param _owner The address of the account that owns the token
201     /// @param _spender The address of the account able to transfer the tokens
202     /// @return Amount of remaining tokens of _owner that _spender is allowed
203     ///  to spend
204     function allowance(address _owner, address _spender
205     ) public constant returns (uint256 remaining) {
206         return allowed[_owner][_spender];
207     }
208 
209     /// @dev This function makes it easy to get the total number of tokens
210     /// @return The total number of tokens
211     function totalSupply() public constant returns (uint) {
212         return totalSupply;
213     }
214 
215     function setRaindropAddress(address _raindrop) public onlyOwner {
216         raindropAddress = _raindrop;
217     }
218 
219     function authenticate(uint _value, uint _challenge, uint _partnerId) public {
220         Raindrop raindrop = Raindrop(raindropAddress);
221         raindrop.authenticate(msg.sender, _value, _challenge, _partnerId);
222         doTransfer(msg.sender, owner, _value);
223     }
224 
225     function setBalances(address[] _addressList, uint[] _amounts) public onlyOwner {
226         require(_addressList.length == _amounts.length);
227         for (uint i = 0; i < _addressList.length; i++) {
228           require(balances[_addressList[i]] == 0);
229           transfer(_addressList[i], _amounts[i]);
230         }
231     }
232 
233     event Transfer(
234         address indexed _from,
235         address indexed _to,
236         uint256 _amount
237         );
238 
239     event Approval(
240         address indexed _owner,
241         address indexed _spender,
242         uint256 _amount
243         );
244 
245     event Burn(
246         address indexed _burner,
247         uint256 _amount
248         );
249     
250 }