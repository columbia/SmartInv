1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     c = _a * _b;
22     assert(c / _a == _b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // assert(_b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33     return _a / _b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     assert(_b <= _a);
41     return _a - _b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
48     c = _a + _b;
49     assert(c >= _a);
50     return c;
51   }
52 }
53 
54 
55 contract Ownable {
56     
57     address public owner;
58 
59     /**
60      * The address whcih deploys this contrcat is automatically assgined ownership.
61      * */
62     function Ownable() public {
63         owner = msg.sender;
64     }
65 
66     /**
67      * Functions with this modifier can only be executed by the owner of the contract. 
68      * */
69     modifier onlyOwner {
70         require(msg.sender == owner);
71         _;
72     }
73 
74     event OwnershipTransferred(address indexed from, address indexed to);
75 
76     /**
77     * Transfers ownership to new Ethereum address. This function can only be called by the 
78     * owner.
79     * @param _newOwner the address to be granted ownership.
80     **/
81     function transferOwnership(address _newOwner) public onlyOwner {
82         require(_newOwner != 0x0);
83         OwnershipTransferred(owner, _newOwner);
84         owner = _newOwner;
85     }
86 }
87 
88 
89 contract ERC20Basic {
90     uint256 public totalSupply;
91     string public name;
92     string public symbol;
93     uint8 public decimals;
94     function balanceOf(address who) constant public returns (uint256);
95     function transfer(address to, uint256 value) public returns (bool);
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 }
98 
99 
100 contract ERC20 is ERC20Basic {
101     function allowance(address owner, address spender) constant public returns (uint256);
102     function transferFrom(address from, address to, uint256 value) public  returns (bool);
103     function approve(address spender, uint256 value) public returns (bool);
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 
108 
109 contract BasicToken is ERC20Basic {
110     
111     using SafeMath for uint256;
112     
113     mapping (address => uint256) internal balances;
114     
115     /**
116     * Returns the balance of the qeuried address
117     *
118     * @param _who The address which is being qeuried
119     **/
120     function balanceOf(address _who) public view returns(uint256) {
121         return balances[_who];
122     }
123     
124     /**
125     * Allows for the transfer of MSTCOIN tokens from peer to peer. 
126     *
127     * @param _to The address of the receiver
128     * @param _value The amount of tokens to send
129     **/
130     function transfer(address _to, uint256 _value) public returns(bool) {
131         require(balances[msg.sender] >= _value && _value > 0 && _to != 0x0);
132         balances[msg.sender] = balances[msg.sender].sub(_value);
133         balances[_to] = balances[_to].add(_value);
134         Transfer(msg.sender, _to, _value);
135         return true;
136     }
137 }
138 
139 
140 
141 contract StandardToken is BasicToken, ERC20 {
142     
143     mapping (address => mapping (address => uint256)) internal allowances;
144     
145     /**
146     * Returns the amount of tokens one has allowed another to spend on his or her behalf.
147     *
148     * @param _owner The address which is the owner of the tokens
149     * @param _spender The address which has been allowed to spend tokens on the owner's
150     * behalf
151     **/
152     function allowance(address _owner, address _spender) public view returns (uint256) {
153         return allowances[_owner][_spender];
154     }
155     
156     /**
157     * Allows for the transfer of tokens on the behalf of the owner given that the owner has
158     * allowed it previously. 
159     *
160     * @param _from The address of the owner
161     * @param _to The address of the recipient 
162     * @param _value The amount of tokens to be sent
163     **/
164     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool) {
165         require(allowances[_from][msg.sender] >= _value && _to != 0x0 && balances[_from] >= _value && _value > 0);
166         balances[_from] = balances[_from].sub(_value);
167         balances[_to] = balances[_to].add(_value);
168         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);
169         Transfer(_from, _to, _value);
170         return true;
171     }
172     
173     /**
174     * Allows the owner of tokens to approve another to spend tokens on his or her behalf
175     *
176     * @param _spender The address which is being allowed to spend tokens on the owner' behalf
177     * @param _value The amount of tokens to be sent
178     **/
179     function approve(address _spender, uint256 _value) public returns (bool) {
180         require(_spender != 0x0 && _value > 0);
181         if(allowances[msg.sender][_spender] > 0 ) {
182             allowances[msg.sender][_spender] = 0;
183         }
184         allowances[msg.sender][_spender] = _value;
185         Approval(msg.sender, _spender, _value);
186         return true;
187     }
188 }
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
209 contract Propvesta is BurnableToken {
210 
211     string public website = "www.propvesta.com";
212     
213     function Propvesta() public {
214         name = "Propvesta";
215         symbol = "PROV";
216         decimals = 18;
217         totalSupply = 10000000000e18;
218         balances[owner] = 7000000000e18;
219         Transfer(address(this), owner, 7000000000e18);
220         balances[0x304f970BaA307238A6a4F47caa9e0d82F082e3AD] = 2000000000e18;
221         Transfer(address(this), 0x304f970BaA307238A6a4F47caa9e0d82F082e3AD, 2000000000e18);
222         balances[0x19294ceEeA1ae27c571a1C6149004A9f143e1aA5] = 1000000000e18;
223         Transfer(address(this), 0x19294ceEeA1ae27c571a1C6149004A9f143e1aA5, 1000000000e18);
224     }
225 }