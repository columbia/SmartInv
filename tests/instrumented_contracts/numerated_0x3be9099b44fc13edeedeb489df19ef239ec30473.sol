1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal constant returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract Ownable {
30     address public owner;
31 
32 
33     /**
34      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35      * account.
36      */
37     function Ownable() {
38         owner = msg.sender;
39     }
40 
41 
42     /**
43      * @dev Throws if called by any account other than the owner.
44      */
45     modifier onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49 
50 
51     /**
52      * @dev Allows the current owner to transfer control of the contract to a newOwner.
53      * @param newOwner The address to transfer ownership to.
54      */
55     function transferOwnership(address newOwner) onlyOwner {
56         if (newOwner != address(0)) {
57             owner = newOwner;
58         }
59     }
60 
61 }
62 
63 contract ERC20Basic {
64     uint256 public totalSupply;
65     function balanceOf(address who) constant returns (uint256);
66     function transfer(address to, uint256 value) returns (bool);
67 
68     // KYBER-NOTE! code changed to comply with ERC20 standard
69     event Transfer(address indexed _from, address indexed _to, uint _value);
70     //event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 
73 contract BasicToken is ERC20Basic {
74     using SafeMath for uint256;
75 
76     mapping(address => uint256) balances;
77 
78     /**
79     * @dev transfer token for a specified address
80     * @param _to The address to transfer to.
81     * @param _value The amount to be transferred.
82     */
83     function transfer(address _to, uint256 _value) returns (bool) {
84         balances[msg.sender] = balances[msg.sender].sub(_value);
85         balances[_to] = balances[_to].add(_value);
86         Transfer(msg.sender, _to, _value);
87         return true;
88     }
89 
90     /**
91     * @dev Gets the balance of the specified address.
92     * @param _owner The address to query the the balance of.
93     * @return An uint256 representing the amount owned by the passed address.
94     */
95     function balanceOf(address _owner) constant returns (uint256 balance) {
96         return balances[_owner];
97     }
98 
99 }
100 
101 contract ERC20 is ERC20Basic {
102     function allowance(address owner, address spender) constant returns (uint256);
103     function transferFrom(address from, address to, uint256 value) returns (bool);
104     function approve(address spender, uint256 value) returns (bool);
105 
106     // KYBER-NOTE! code changed to comply with ERC20 standard
107     event Approval(address indexed _owner, address indexed _spender, uint _value);
108     //event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 contract StandardToken is ERC20, BasicToken {
112 
113     mapping (address => mapping (address => uint256)) allowed;
114 
115 
116     /**
117      * @dev Transfer tokens from one address to another
118      * @param _from address The address which you want to send tokens from
119      * @param _to address The address which you want to transfer to
120      * @param _value uint256 the amout of tokens to be transfered
121      */
122     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
123         var _allowance = allowed[_from][msg.sender];
124 
125         balances[_from] = balances[_from].sub(_value);
126         balances[_to] = balances[_to].add(_value);
127         allowed[_from][msg.sender] = _allowance.sub(_value);
128         Transfer(_from, _to, _value);
129         return true;
130     }
131 
132     /**
133      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
134      * @param _spender The address which will spend the funds.
135      * @param _value The amount of tokens to be spent.
136      */
137     function approve(address _spender, uint256 _value) returns (bool) {
138 
139         // To change the approve amount you first have to reduce the addresses`
140         //  allowance to zero by calling `approve(_spender, 0)` if it is not
141         //  already 0 to mitigate the race condition described here:
142         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
144 
145         allowed[msg.sender][_spender] = _value;
146         Approval(msg.sender, _spender, _value);
147         return true;
148     }
149 
150     /**
151      * @dev Function to check the amount of tokens that an owner allowed to a spender.
152      * @param _owner address The address which owns the funds.
153      * @param _spender address The address which will spend the funds.
154      * @return A uint256 specifing the amount of tokens still avaible for the spender.
155      */
156     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
157         return allowed[_owner][_spender];
158     }
159 
160 }
161 
162 contract KOToken is StandardToken, Ownable {
163     string  public  constant name = "K.O Token";
164     string  public  constant symbol = "KOT";
165     uint    public  constant decimals = 18;
166 
167     bool public transferEnabled = true;
168 
169 
170     modifier validDestination( address to ) {
171         require(to != address(0x0));
172         require(to != address(this) );
173         _;
174     }
175 
176     function KOToken() {
177         // Mint all tokens. Then disable minting forever.
178         balances[msg.sender] = 2100000000 * (10 ** decimals);
179         totalSupply = balances[msg.sender];
180         Transfer(address(0x0), msg.sender, totalSupply);
181         transferOwnership(msg.sender); // admin could drain tokens that were sent here by mistake
182     }
183 
184     function transfer(address _to, uint _value)
185     validDestination(_to)
186     returns (bool) {
187         require(transferEnabled == true);
188         return super.transfer(_to, _value);
189     }
190 
191     function transferFrom(address _from, address _to, uint _value)
192     validDestination(_to)
193     returns (bool) {
194         require(transferEnabled == true);
195         return super.transferFrom(_from, _to, _value);
196     }
197 
198 
199     function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner {
200         token.transfer( owner, amount );
201     }
202 
203     function setTransferEnable(bool enable) onlyOwner {
204         transferEnabled = enable;
205     }
206 }