1 pragma solidity ^0.4.4;
2 
3 contract ERC20Basic {
4     uint256 public totalSupply;
5     function balanceOf(address who) public constant returns (uint256 balance);
6     function transfer(address to, uint256 value) public returns (bool success);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 } 
9 
10 contract ERC20 is ERC20Basic {
11     function allowance(address owner, address spender) public constant returns (uint256 remaining);
12     function transferFrom(address from, address to, uint256 value) public returns (bool success);
13     function approve(address spender, uint256 value) public returns (bool success);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22     
23     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
24         uint256 c = a * b;
25         assert(a == 0 || c / a == b);
26         return c;
27     }
28 
29     function div(uint256 a, uint256 b) internal constant returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return c;
34     }
35 
36     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     function add(uint256 a, uint256 b) internal constant returns (uint256) {
42         uint256 c = a + b;
43         assert(c >= a);
44         return c;
45     }
46   
47 }
48 
49 /**
50  * @title Basic token
51  * @dev Basic version of StandardToken, with no allowances. 
52  */
53 contract BasicToken is ERC20Basic {
54     
55     using SafeMath for uint256;
56 
57     mapping(address => uint256) public balances;
58 
59     /**
60     * @dev transfer token for a specified address
61     * @param _to The address to transfer to.
62     * @param _value The amount to be transferred.
63     */
64     function transfer(address _to, uint256 _value) public returns (bool success)  {
65         balances[msg.sender] = balances[msg.sender].sub(_value);
66         balances[_to] = balances[_to].add(_value);
67         Transfer(msg.sender, _to, _value);
68         return true;
69     }
70 
71     /**
72     * @dev Gets the balance of the specified address.
73     * @param _owner The address to query the the balance of. 
74     * @return An uint256 representing the amount owned by the passed address.
75     */
76     function balanceOf(address _owner) public constant returns (uint256 balance)  {
77         return balances[_owner];
78     }
79  
80 }
81  
82 /**
83  * @title Standard ERC20 token
84  *
85  * @dev Implementation of the basic standard token.
86  */
87 contract StandardToken is ERC20, BasicToken {
88  
89     mapping (address => mapping (address => uint256)) allowed;
90 
91     /**
92     * @dev Transfer tokens from one address to another
93     * @param _from address The address which you want to send tokens from
94     * @param _to address The address which you want to transfer to
95     * @param _value uint256 the amout of tokens to be transfered
96     */
97     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)  {
98         uint256 _allowance = allowed[_from][msg.sender];
99 
100         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
101         // require (_value <= _allowance);
102 
103         balances[_to] = balances[_to].add(_value);
104         balances[_from] = balances[_from].sub(_value);
105         allowed[_from][msg.sender] = _allowance.sub(_value);
106         Transfer(_from, _to, _value);
107         return true;
108     }
109 
110     /**
111     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
112     * @param _spender The address which will spend the funds.
113     * @param _value The amount of tokens to be spent.
114     */
115     function approve(address _spender, uint256 _value) public returns (bool success)  {
116 
117         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
118 
119         allowed[msg.sender][_spender] = _value;
120         Approval(msg.sender, _spender, _value);
121         return true;
122     }
123 
124     /**
125     * @dev Function to check the amount of tokens that an owner allowed to a spender.
126     * @param _owner address The address which owns the funds.
127     * @param _spender address The address which will spend the funds.
128     * @return A uint256 specifing the amount of tokens still available for the spender.
129     */
130     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
131         return allowed[_owner][_spender];
132     }
133  
134 }
135  
136 /**
137  * @title Ownable
138  * @dev The Ownable contract has an owner address, and provides basic authorization control
139  * functions, this simplifies the implementation of "user permissions".
140  */
141 contract Ownable {
142     
143     address public owner;
144 
145     /**
146     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
147     * account.
148     */
149     function Ownable()  public {
150         owner = msg.sender;
151     }
152 
153     /**
154     * @dev Throws if called by any account other than the owner.
155     */
156     modifier onlyOwner() {
157         require(msg.sender == owner);
158         _;
159     }
160 
161     /**
162     * @dev Allows the current owner to transfer control of the contract to a newOwner.
163     * @param newOwner The address to transfer ownership to.
164     */
165     function transferOwnership(address newOwner) onlyOwner  public {
166         require(newOwner != address(0));      
167         owner = newOwner;
168     }
169  
170 }
171  
172 /**
173  * @title Mintable token
174  * @dev Simple ERC20 Token example, with mintable token creation
175  */
176  
177 contract MintableToken is StandardToken, Ownable {
178     
179     event Mint(address indexed to, uint256 amount);
180 
181     event MintFinished();
182 
183     bool public mintingFinished = false;
184 
185     modifier canMint() {
186         require(!mintingFinished);
187         _;
188     }
189 
190     /**
191     * @dev Function to mint tokens
192     * @param _to The address that will recieve the minted tokens.
193     * @param _amount The amount of tokens to mint.
194     * @return A boolean that indicates if the operation was successful.
195     */
196     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
197         totalSupply = totalSupply.add(_amount);
198         balances[_to] = balances[_to].add(_amount);
199         Mint(_to, _amount);
200         Transfer(address(0), _to, _amount); 
201         return true;
202     }
203 
204     /**
205     * @dev Function to stop minting new tokens.
206     * @return True if the operation was successful.
207     */
208     function finishMinting() public onlyOwner returns (bool)  {
209         mintingFinished = true;
210         MintFinished();
211         return true;
212     }
213   
214 }
215 
216 
217 // Token Contract
218 contract GWTToken is MintableToken {
219     
220     string public constant name = "Global Wind Token";
221     
222     string public constant symbol = "GWT";
223     
224     uint32 public constant decimals = 18; 
225 
226 }