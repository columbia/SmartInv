1 pragma solidity ^0.4.21;
2 
3 /***********************/
4 /* Trustedhealth Token */
5 /***********************/
6 
7 library SafeMath {
8     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
9         assert(b <= a);
10         return a - b;
11     }
12 
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a + b;
15         assert(c >= a);
16         return c;
17     }
18 }
19 
20 contract owned {
21 
22     address public owner;
23 
24     function owned() public{
25         owner = msg.sender;
26     }
27 
28     modifier onlyOwner {
29         assert(msg.sender == owner);
30         _;
31     }
32 
33     function transferOwnership(address newOwner) public onlyOwner {
34         owner = newOwner;
35     }
36 }
37 
38 /************************/
39 /* STANDARD ERC20 TOKEN */
40 /************************/
41 
42 contract ERC20Token {
43 
44     /** Functions needed to be implemented by ERC20 standard **/
45     function totalSupply() public constant returns (uint256 _totalSupply);
46     function balanceOf(address _owner) public constant returns (uint256 _balance);
47     function transfer(address _to, uint256 _amount) public returns (bool _success);
48     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool _success);
49     function approve(address _spender, uint256 _amount) public returns (bool _success);
50     function allowance(address _owner, address _spender) public constant returns (uint256 _remaining);
51 
52     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
53     event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
54 }
55 
56 
57 /**************************************/
58 /* TRUSTEDHEALTH TOKEN IMPLEMENTATION */
59 /**************************************/
60 
61 contract TrustedhealthToken is ERC20Token, owned {
62     using SafeMath for uint256;
63 
64     /* Public variables */
65     string public name = "Trustedhealth";
66     string public symbol = "TDH";
67     uint8 public decimals = 18;
68     bool public tokenFrozen;
69 
70     /* Private variables */
71     uint256 supply;
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowances;
74     mapping (address => bool) allowedToMint;
75 
76     /* Events */
77     event TokenFrozen(bool _frozen, string _reason);
78     event Mint(address indexed _to, uint256 _value);
79 
80     /**
81     * Constructor function
82     *
83     * Initializes contract.
84     **/
85     function TrustedhealthToken() public {
86         tokenFrozen = false;
87     }
88 
89     /**
90     * Internal transfer function.
91     **/
92     function _transfer(address _from, address _to, uint256 _amount) private {
93         require(_to != 0x0);
94         require(_to != address(this));
95         require(balances[_from] >= _amount);
96         balances[_to] = balances[_to].add(_amount);
97         balances[_from] = balances[_from].sub(_amount);
98         emit Transfer(_from, _to, _amount);
99     }
100 
101     /**
102     * Transfer token
103     *
104     * Send '_amount' tokens to '_to' from your address.
105     *
106     * @param _to Address of recipient.
107     * @param _amount Amount to send.
108     * @return Whether the transfer was successful or not.
109     **/
110     function transfer(address _to, uint256 _amount) public returns (bool _success) {
111         require(!tokenFrozen);
112         _transfer(msg.sender, _to, _amount);
113         return true;
114     }
115 
116     /**
117     * Set allowance
118     *
119     * Allows '_spender' to spend '_amount' tokens from your address
120     *
121     * @param _spender Address of spender.
122     * @param _amount Max amount allowed to spend.
123     * @return Whether the approve was successful or not.
124     **/
125     function approve(address _spender, uint256 _amount) public returns (bool _success) {
126         allowances[msg.sender][_spender] = _amount;
127         emit Approval(msg.sender, _spender, _amount);
128         return true;
129     }
130 
131     /**
132     *Transfer token from
133     *
134     * Send '_amount' token from address '_from' to address '_to'
135     *
136     * @param _from Address of sender.
137     * @param _to Address of recipient.
138     * @param _amount Amount of token to send.
139     * @return Whether the transfer was successful or not.
140     **/
141     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool _success) {
142         require(_amount <= allowances[_from][msg.sender]);
143         require(!tokenFrozen);
144         _transfer(_from, _to, _amount);
145         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_amount);
146         return true;
147     }
148 
149     /**
150     * Mint Tokens
151     *
152     * Adds _amount of tokens to _atAddress
153     *
154     * @param _atAddress Adds tokens to address
155     * @param _amount Amount of tokens to add
156     **/
157     function mintTokens(address _atAddress, uint256 _amount) public {
158         require(allowedToMint[msg.sender]);
159         require(balances[_atAddress].add(_amount) > balances[_atAddress]);
160         require((supply.add(_amount)) <= 201225419354262000000000000);
161         supply = supply.add(_amount);
162         balances[_atAddress] = balances[_atAddress].add(_amount);
163         emit Mint(_atAddress, _amount);
164         emit Transfer(0x0, _atAddress, _amount);
165     }
166 
167     /**
168     * Change freeze
169     *
170     * Changes status of frozen because of '_reason'
171     *
172     * @param _reason Reason for freezing or unfreezing token
173     **/
174     function changeFreezeTransaction(string _reason) public onlyOwner {
175         tokenFrozen = !tokenFrozen;
176         emit TokenFrozen(tokenFrozen, _reason);
177     }
178 
179     /**
180     * Change mint address
181     *
182     *  Changes the address to mint
183     *
184     * @param _addressToMint Address of new minter
185     **/
186     function changeAllowanceToMint(address _addressToMint) public onlyOwner {
187         allowedToMint[_addressToMint] = !allowedToMint[_addressToMint];
188     }
189 
190     /**
191     * Get allowance
192     *
193     * @return Return amount allowed to spend from '_owner' by '_spender'
194     **/
195     function allowance(address _owner, address _spender) public constant returns (uint256 _remaining) {
196         return allowances[_owner][_spender];
197     }
198 
199     /**
200     * Total amount of token
201     *
202     * @return Total amount of token
203     **/
204     function totalSupply() public constant returns (uint256 _totalSupply) {
205         return supply;
206     }
207 
208     /**
209     * Balance of address
210     *
211     * Check balance of '_owner'
212     *
213     * @param _owner Address
214     * @return Amount of token in possession
215     **/
216     function balanceOf(address _owner) public constant returns (uint256 _balance) {
217         return balances[_owner];
218     }
219 
220     /**
221     * Address allowed to mint
222     *
223     * Checks if '_address' is allowed to mint
224     *
225     * @param _address Address
226     * @return Allowance to mint
227     **/
228     function isAllowedToMint(address _address) public constant returns (bool _allowed) {
229         return allowedToMint[_address];
230     }
231 
232     /** Revert if someone sends ether to this contract **/
233     function () public {
234         revert();
235     }
236 
237     /**
238     * This part is here only for testing and will not be included into final version
239     **/
240     /**
241     function killContract() onlyOwner{
242     selfdestruct(msg.sender);
243     }
244     **/
245 }