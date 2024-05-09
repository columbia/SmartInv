1 pragma solidity ^0.4.25;
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
55 contract ERC20Basic {
56     uint256 public totalSupply;
57     string public name;
58     string public symbol;
59     uint8 public decimals;
60     function balanceOf(address who) constant public returns (uint256);
61     function transfer(address to, uint256 value) public returns (bool);
62     event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 
66 contract BasicToken is ERC20Basic {
67     
68     using SafeMath for uint256;
69     
70     mapping (address => uint256) internal balances;
71     
72     /**
73     * Returns the balance of the qeuried address
74     *
75     * @param _who The address which is being qeuried
76     **/
77     function balanceOf(address _who) public view returns(uint256) {
78         return balances[_who];
79     }
80     
81     /**
82     * Allows for the transfer of MSTCOIN tokens from peer to peer. 
83     *
84     * @param _to The address of the receiver
85     * @param _value The amount of tokens to send
86     **/
87     function transfer(address _to, uint256 _value) public returns(bool) {
88         require(balances[msg.sender] >= _value && _value > 0 && _to != 0x0);
89         balances[msg.sender] = balances[msg.sender].sub(_value);
90         balances[_to] = balances[_to].add(_value);
91         emit Transfer(msg.sender, _to, _value);
92         return true;
93     }
94 }
95 
96 contract ERC20 is ERC20Basic {
97     function allowance(address owner, address spender) constant public returns (uint256);
98     function transferFrom(address from, address to, uint256 value) public  returns (bool);
99     function approve(address spender, uint256 value) public returns (bool);
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 
104 contract Ownable {
105     
106     address public owner;
107 
108     /**
109      * The address whcih deploys this contrcat is automatically assgined ownership.
110      * */
111     constructor() public {
112         owner = msg.sender;
113     }
114 
115     /**
116      * Functions with this modifier can only be executed by the owner of the contract. 
117      * */
118     modifier onlyOwner {
119         require(msg.sender == owner);
120         _;
121     }
122 
123     event OwnershipTransferred(address indexed from, address indexed to);
124 
125     /**
126     * Transfers ownership to new Ethereum address. This function can only be called by the 
127     * owner.
128     * @param _newOwner the address to be granted ownership.
129     **/
130     function transferOwnership(address _newOwner) public onlyOwner {
131         require(_newOwner != 0x0);
132         emit OwnershipTransferred(owner, _newOwner);
133         owner = _newOwner;
134     }
135 }
136 
137 
138 contract StandardToken is BasicToken, ERC20, Ownable {
139     
140     address public MembershipContractAddr = 0x0;
141     
142     mapping (address => mapping (address => uint256)) internal allowances;
143     
144     function changeMembershipContractAddr(address _newAddr) public onlyOwner returns(bool) {
145         require(_newAddr != address(0));
146         MembershipContractAddr = _newAddr;
147     }
148     
149     /**
150     * Returns the amount of tokens one has allowed another to spend on his or her behalf.
151     *
152     * @param _owner The address which is the owner of the tokens
153     * @param _spender The address which has been allowed to spend tokens on the owner's
154     * behalf
155     **/
156     function allowance(address _owner, address _spender) public view returns (uint256) {
157         return allowances[_owner][_spender];
158     }
159     
160     event TransferFrom(address msgSender);
161     /**
162     * Allows for the transfer of tokens on the behalf of the owner given that the owner has
163     * allowed it previously. 
164     *
165     * @param _from The address of the owner
166     * @param _to The address of the recipient 
167     * @param _value The amount of tokens to be sent
168     **/
169     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool) {
170         require(allowances[_from][msg.sender] >= _value || msg.sender == MembershipContractAddr);
171         require(balances[_from] >= _value && _value > 0 && _to != address(0));
172         emit TransferFrom(msg.sender);
173         balances[_from] = balances[_from].sub(_value);
174         balances[_to] = balances[_to].add(_value);
175         if(msg.sender != MembershipContractAddr) {
176             allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);
177         }
178         emit Transfer(_from, _to, _value);
179         return true;
180     }
181     
182     /**
183     * Allows the owner of tokens to approve another to spend tokens on his or her behalf
184     *
185     * @param _spender The address which is being allowed to spend tokens on the owner' behalf
186     * @param _value The amount of tokens to be sent
187     **/
188     function approve(address _spender, uint256 _value) public returns (bool) {
189         require(_spender != 0x0 && _value > 0);
190         if(allowances[msg.sender][_spender] > 0 ) {
191             allowances[msg.sender][_spender] = 0;
192         }
193         allowances[msg.sender][_spender] = _value;
194         emit Approval(msg.sender, _spender, _value);
195         return true;
196     }
197 }
198 
199 
200 contract BurnableToken is StandardToken {
201     
202     address public ICOaddr;
203     address public privateSaleAddr;
204     
205     constructor() public {
206         ICOaddr = 0x837141Aec793bDAd663c71F8B2c8709731Da22B1;
207         privateSaleAddr = 0x87529BE23E0206eBedd6481fA6644d9B8B5cb9A9;
208     }
209     
210     event TokensBurned(address indexed burner, uint256 value);
211     
212     function burnFrom(address _from, uint256 _tokens) public onlyOwner {
213         require(ICOaddr == _from || privateSaleAddr == _from);
214         if(balances[_from] < _tokens) {
215             emit TokensBurned(_from,balances[_from]);
216             emit Transfer(_from, address(0), balances[_from]);
217             balances[_from] = 0;
218             totalSupply = totalSupply.sub(balances[_from]);
219         } else {
220             balances[_from] = balances[_from].sub(_tokens);
221             totalSupply = totalSupply.sub(_tokens);
222             emit TokensBurned(_from, _tokens);
223             emit Transfer(_from, address(0), _tokens);
224         }
225     }
226 }
227 
228 contract AIB is BurnableToken {
229     
230     constructor() public {
231         name = "AI Bank";
232         symbol = "AIB";
233         decimals = 18;
234         totalSupply = 856750000e18;
235         balances[owner] = totalSupply;
236         emit Transfer(address(this), owner, totalSupply);
237     }
238 }