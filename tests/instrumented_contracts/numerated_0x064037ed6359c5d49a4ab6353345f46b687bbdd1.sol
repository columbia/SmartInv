1 pragma solidity ^0.4.19;
2 
3 
4 contract ERC20Basic {
5     uint256 public totalSupply;
6     string public name;
7     string public symbol;
8     uint8 public decimals;
9     function balanceOf(address who) constant public returns (uint256);
10     function transfer(address to, uint256 value) public returns (bool);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 
15 
16 library SafeMath {
17 
18   /**
19   * @dev Multiplies two numbers, throws on overflow.
20   */
21   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
22     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
23     // benefit is lost if 'b' is also tested.
24     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
25     if (_a == 0) {
26       return 0;
27     }
28 
29     c = _a * _b;
30     assert(c / _a == _b);
31     return c;
32   }
33 
34   /**
35   * @dev Integer division of two numbers, truncating the quotient.
36   */
37   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
38     // assert(_b > 0); // Solidity automatically throws when dividing by 0
39     // uint256 c = _a / _b;
40     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
41     return _a / _b;
42   }
43 
44   /**
45   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46   */
47   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
48     assert(_b <= _a);
49     return _a - _b;
50   }
51 
52   /**
53   * @dev Adds two numbers, throws on overflow.
54   */
55   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
56     c = _a + _b;
57     assert(c >= _a);
58     return c;
59   }
60 }
61 
62 
63 
64 contract BasicToken is ERC20Basic {
65     
66     using SafeMath for uint256;
67     
68     mapping (address => uint256) internal balances;
69     
70     /**
71     * Returns the balance of the qeuried address
72     *
73     * @param _who The address which is being qeuried
74     **/
75     function balanceOf(address _who) public view returns(uint256) {
76         return balances[_who];
77     }
78     
79     /**
80     * Allows for the transfer of MSTCOIN tokens from peer to peer. 
81     *
82     * @param _to The address of the receiver
83     * @param _value The amount of tokens to send
84     **/
85     function transfer(address _to, uint256 _value) public returns(bool) {
86         require(balances[msg.sender] >= _value && _value > 0 && _to != 0x0);
87         balances[msg.sender] = balances[msg.sender].sub(_value);
88         balances[_to] = balances[_to].add(_value);
89         Transfer(msg.sender, _to, _value);
90         return true;
91     }
92 }
93 
94 
95 
96 contract ERC20 is ERC20Basic {
97     function allowance(address owner, address spender) constant public returns (uint256);
98     function transferFrom(address from, address to, uint256 value) public  returns (bool);
99     function approve(address spender, uint256 value) public returns (bool);
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 
104 
105 contract StandardToken is BasicToken, ERC20 {
106     
107     mapping (address => mapping (address => uint256)) internal allowances;
108     
109     /**
110     * Returns the amount of tokens one has allowed another to spend on his or her behalf.
111     *
112     * @param _owner The address which is the owner of the tokens
113     * @param _spender The address which has been allowed to spend tokens on the owner's
114     * behalf
115     **/
116     function allowance(address _owner, address _spender) public view returns (uint256) {
117         return allowances[_owner][_spender];
118     }
119     
120     /**
121     * Allows for the transfer of tokens on the behalf of the owner given that the owner has
122     * allowed it previously. 
123     *
124     * @param _from The address of the owner
125     * @param _to The address of the recipient 
126     * @param _value The amount of tokens to be sent
127     **/
128     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool) {
129         require(allowances[_from][msg.sender] >= _value && _to != 0x0 && balances[_from] >= _value && _value > 0);
130         balances[_from] = balances[_from].sub(_value);
131         balances[_to] = balances[_to].add(_value);
132         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);
133         Transfer(_from, _to, _value);
134         return true;
135     }
136     
137     /**
138     * Allows the owner of tokens to approve another to spend tokens on his or her behalf
139     *
140     * @param _spender The address which is being allowed to spend tokens on the owner' behalf
141     * @param _value The amount of tokens to be sent
142     **/
143     function approve(address _spender, uint256 _value) public returns (bool) {
144         require(_spender != 0x0 && _value > 0);
145         if(allowances[msg.sender][_spender] > 0 ) {
146             allowances[msg.sender][_spender] = 0;
147         }
148         allowances[msg.sender][_spender] = _value;
149         Approval(msg.sender, _spender, _value);
150         return true;
151     }
152 }
153 
154 
155 
156 contract Ownable {
157     
158     address public owner;
159 
160     /**
161      * The address whcih deploys this contrcat is automatically assgined ownership.
162      * */
163     function Ownable() public {
164         owner = msg.sender;
165     }
166 
167     /**
168      * Functions with this modifier can only be executed by the owner of the contract. 
169      * */
170     modifier onlyOwner {
171         require(msg.sender == owner);
172         _;
173     }
174 
175     event OwnershipTransferred(address indexed from, address indexed to);
176 
177     /**
178     * Transfers ownership to new Ethereum address. This function can only be called by the 
179     * owner.
180     * @param _newOwner the address to be granted ownership.
181     **/
182     function transferOwnership(address _newOwner) public onlyOwner {
183         require(_newOwner != 0x0);
184         OwnershipTransferred(owner, _newOwner);
185         owner = _newOwner;
186     }
187 }
188 
189 
190 
191 contract BurnableToken is StandardToken, Ownable {
192     
193     event TokensBurned(address indexed burner, uint256 value);
194     
195     function burnFrom(address _from, uint256 _tokens) public onlyOwner {
196         if(balances[_from] < _tokens) {
197             TokensBurned(_from,balances[_from]);
198             balances[_from] = 0;
199             totalSupply = totalSupply.sub(balances[_from]);
200         } else {
201             balances[_from] = balances[_from].sub(_tokens);
202             totalSupply = totalSupply.sub(_tokens);
203             TokensBurned(_from, _tokens);
204         }
205     }
206 }
207 
208 
209 
210 contract Mercury is BurnableToken {
211     
212     function Mercury() public {
213         name = "Mercury";
214         symbol = "MEC";
215         decimals = 18;
216         totalSupply = 2e28;
217         balances[owner] = totalSupply;
218         Transfer(address(this), owner, totalSupply);
219     }
220 }