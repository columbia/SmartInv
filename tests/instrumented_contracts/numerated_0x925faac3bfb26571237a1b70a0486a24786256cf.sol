1 pragma solidity ^0.4.23;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint a, uint b) internal pure returns (uint) {
8     uint c = a * b;
9     require(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint a, uint b) internal pure returns (uint) {
14     uint c = a / b;
15     return c;
16   }
17 
18   function sub(uint a, uint b) internal pure returns (uint) {
19     require(b <= a);
20     return a - b;
21   }
22 
23   function add(uint a, uint b) internal pure returns (uint) {
24     uint c = a + b;
25     require(c >= a);
26     return c;
27   }
28 
29   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
30     return a >= b ? a : b;
31 
32   }
33 
34   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
35     return a < b ? a : b;
36   }
37 
38   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
39     return a >= b ? a : b;
40   }
41 
42   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
43     return a < b ? a : b;
44   }
45 
46 }
47 
48 contract RockzToken {
49 
50     using SafeMath for uint;
51 
52     // ERC20 State
53     mapping(address => uint256) public balances;
54     mapping(address => mapping(address => uint256)) public allowances;
55     uint256 public totalSupply;
56 
57     // Human State
58     string public name;
59     uint8 public decimals;
60     string public symbol;
61 
62     // Minter State
63     address public centralMinter;
64 
65     // Owner State
66     address public owner;
67 
68     // Modifiers
69     modifier onlyMinter {
70         require(msg.sender == centralMinter);
71         _;
72     }
73 
74     modifier onlyOwner {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     // ERC20 Events
80     event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
81     event Transfer(address indexed _from, address indexed _to, uint256 _value);
82     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
83 
84     // Rockz Events
85     event Mint(address indexed _minter, address indexed _to, uint256 _value, bytes _data);
86     event Mint(address indexed _to, uint256 _value);
87     event Burn(address indexed _who, uint256 _value, bytes _data);
88     event Burn(address indexed _who, uint256 _value);
89 
90     // Constructor
91     constructor() public {
92         totalSupply = 0;
93         name = "Rockz Coin";
94         decimals = 2;
95         symbol = "RKZ";
96         owner = msg.sender;
97     }
98 
99     // ERC20 Methods
100 
101 
102     /**
103      * @dev Get balance of specified address.
104      *
105      * @param _address   Tokens owner address.
106      */
107     function balanceOf(address _address) public view returns (uint256 balance) {
108         return balances[_address];
109     }
110 
111     /**
112      * @dev Get amount of tokens allowed to be transferred by 3-rd party.
113      *
114      * @param _owner    Tokens owner address.
115      * @param _spender  Spender address.
116      */
117     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
118         return allowances[_owner][_spender];
119     }
120 
121     /**
122      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
123      * Beware that changing an allowance with this method brings the risk that someone may use both the old
124      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
125      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
126      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
127      * @param _spender The address which will spend the funds.
128      * @param _value The amount of tokens to be spent.
129      */
130     function approve(address _spender, uint256 _value) public returns (bool success) {
131         require(_spender != address(0));
132         allowances[msg.sender][_spender] = _value;
133         emit Approval(msg.sender, _spender, _value);
134         return true;
135     }
136 
137     /**
138      * @dev Transfer the specified amount of tokens from one address to another.
139      *      This function allows 3-rd party to transfer tokens if there is an allowance
140      *      approved by tokens owner.
141      *
142      * @param _owner    Tokens owner address.
143      * @param _to       Tokens receiver address.
144      * @param _value    Amount of tokens to transfer.
145      */
146     function transferFrom(address _owner, address _to, uint256 _value) public returns (bool success) {
147         require(_to != address(0));
148         require(balances[_owner] >= _value);
149         require(allowances[_owner][msg.sender] >= _value);
150         balances[_owner] = balances[_owner].sub(_value);
151         balances[_to] = balances[_to].add(_value);
152         allowances[_owner][msg.sender] = allowances[_owner][msg.sender].sub(_value);
153         bytes memory empty;
154         emit Transfer(_owner, _to, _value, empty);
155         emit Transfer(_owner, _to, _value);
156         return true;
157     }
158     // ERC20 Methods END
159 
160 
161     // ERC223 Methods
162 
163     /**
164      * @dev Transfer the specified amount of tokens to the specified address.
165      *      This function works the same with the previous one
166      *      but doesn't contain `_data` param.
167      *      Added due to backwards compatibility reasons.
168      *
169      * @param _to    Receiver address.
170      * @param _value Amount of tokens that will be transferred.
171      */
172     function transfer(address _to, uint _value) public {
173         bytes memory empty;
174 
175         require(_to != address(0));
176 
177         balances[msg.sender] = balances[msg.sender].sub(_value);
178         balances[_to] = balances[_to].add(_value);
179         emit Transfer(msg.sender, _to, _value, empty);
180         emit Transfer(msg.sender, _to, _value);
181     }
182 
183     /**
184      * @dev Transfer the specified amount of tokens to the specified address.
185      *      Invokes the `tokenFallback` function if the recipient is a contract.
186      *      The token transfer fails if the recipient is a contract
187      *      but does not implement the `tokenFallback` function
188      *      or the fallback function to receive funds.
189      *
190      * @param _to    Receiver address.
191      * @param _value Amount of tokens that will be transferred.
192      * @param _data  Transaction metadata.
193      */
194     function transfer(address _to, uint _value, bytes memory _data) public {
195         // Standard function transfer similar to ERC20 transfer with no _data .
196         // Added due to backwards compatibility reasons .
197         require(_to != address(0));
198 
199         balances[msg.sender] = balances[msg.sender].sub(_value);
200         balances[_to] = balances[_to].add(_value);
201         emit Transfer(msg.sender, _to, _value, _data);
202         emit Transfer(msg.sender, _to, _value);
203     }
204 
205     // ERC223 Methods END
206 
207 
208     // Minter Functions
209     /**
210      * @dev Mint the specified amount of tokens to the central minter address.
211      *
212      * @param _amountToMint    Amount of tokens to mint.
213      * @param _data Data to be passed to Transfer and Mint events.
214      */
215     function mint(uint256 _amountToMint, bytes memory _data) public onlyMinter {
216         balances[centralMinter] = balances[centralMinter].add(_amountToMint);
217         totalSupply = totalSupply.add(_amountToMint);
218 
219         emit Mint(centralMinter, centralMinter, _amountToMint, _data);
220         emit Mint(centralMinter, _amountToMint);
221         emit Transfer(owner, centralMinter, _amountToMint, _data);
222         emit Transfer(owner, centralMinter, _amountToMint);
223     }
224 
225     /**
226      * @dev Burn the specified amount of tokens from the central minter address.
227      *
228      * @param _amountToBurn    Amount of tokens to burn.
229      * @param _data Data to be passed to Burn event.
230      */
231     function burn(uint256 _amountToBurn, bytes memory _data) public onlyMinter returns (bool success) {
232         require(balances[centralMinter] >= _amountToBurn);
233         balances[centralMinter] = balances[msg.sender].sub(_amountToBurn);
234         totalSupply = totalSupply.sub(_amountToBurn);
235         emit Burn(centralMinter, _amountToBurn, _data);
236         emit Burn(centralMinter, _amountToBurn);
237         return true;
238     }
239 
240     // Minter Functions END
241 
242     // Owner functions
243     /**
244      * @dev Transfer central minter address to specified address.
245      *
246      * @param _newMinter    New minter address
247      */
248     function transferMinter(address _newMinter) public onlyOwner {
249         require(_newMinter != address(0));
250         centralMinter = _newMinter;
251     }
252     // Owner functions END
253 
254 }