1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.16;
4 
5 
6 pragma solidity ^0.4.16;
7 
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal constant returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal constant returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 contract Ownable {
35     address public owner;
36 
37 
38     /**
39      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40      * account.
41      */
42     function Ownable() {
43         owner = msg.sender;
44     }
45 
46 
47     /**
48      * @dev Throws if called by any account other than the owner.
49      */
50     modifier onlyOwner() {
51         require(msg.sender == owner);
52         _;
53     }
54 
55 
56     /**
57      * @dev Allows the current owner to transfer control of the contract to a newOwner.
58      * @param newOwner The address to transfer ownership to.
59      */
60     function transferOwnership(address newOwner) onlyOwner {
61         if (newOwner != address(0)) {
62             owner = newOwner;
63         }
64     }
65 
66 }
67 
68 contract ERC20Basic {
69     uint256 public totalSupply;
70     function balanceOf(address who) constant returns (uint256);
71     function transfer(address to, uint256 value) returns (bool);
72 
73     // KYBER-NOTE! code changed to comply with ERC20 standard
74     event Transfer(address indexed _from, address indexed _to, uint _value);
75     //event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 contract BasicToken is ERC20Basic {
79     using SafeMath for uint256;
80 
81     mapping(address => uint256) balances;
82 
83     /**
84     * @dev transfer token for a specified address
85     * @param _to The address to transfer to.
86     * @param _value The amount to be transferred.
87     */
88     function transfer(address _to, uint256 _value) returns (bool) {
89         balances[msg.sender] = balances[msg.sender].sub(_value);
90         balances[_to] = balances[_to].add(_value);
91         Transfer(msg.sender, _to, _value);
92         return true;
93     }
94 
95     /**
96     * @dev Gets the balance of the specified address.
97     * @param _owner The address to query the the balance of.
98     * @return An uint256 representing the amount owned by the passed address.
99     */
100     function balanceOf(address _owner) constant returns (uint256 balance) {
101         return balances[_owner];
102     }
103 
104 }
105 
106 contract ERC20 is ERC20Basic {
107     function allowance(address owner, address spender) constant returns (uint256);
108     function transferFrom(address from, address to, uint256 value) returns (bool);
109     function approve(address spender, uint256 value) returns (bool);
110 
111     event Approval(address indexed _owner, address indexed _spender, uint _value);
112 }
113 
114 contract StandardToken is ERC20, BasicToken {
115 
116     mapping (address => mapping (address => uint256)) allowed;
117 
118 
119     /**
120      * @dev Transfer tokens from one address to another
121      * @param _from address The address which you want to send tokens from
122      * @param _to address The address which you want to transfer to
123      * @param _value uint256 the amout of tokens to be transfered
124      */
125     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
126         var _allowance = allowed[_from][msg.sender];
127 
128         balances[_from] = balances[_from].sub(_value);
129         balances[_to] = balances[_to].add(_value);
130         allowed[_from][msg.sender] = _allowance.sub(_value);
131         Transfer(_from, _to, _value);
132         return true;
133     }
134 
135     /**
136      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
137      * @param _spender The address which will spend the funds.
138      * @param _value The amount of tokens to be spent.
139      */
140     function approve(address _spender, uint256 _value) returns (bool) {
141 
142         // To change the approve amount you first have to reduce the addresses`
143         //  allowance to zero by calling `approve(_spender, 0)` if it is not
144         //  already 0 to mitigate the race condition described here:
145         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
147 
148         allowed[msg.sender][_spender] = _value;
149         Approval(msg.sender, _spender, _value);
150         return true;
151     }
152 
153     /**
154      * @dev Function to check the amount of tokens that an owner allowed to a spender.
155      * @param _owner address The address which owns the funds.
156      * @param _spender address The address which will spend the funds.
157      * @return A uint256 specifing the amount of tokens still avaible for the spender.
158      */
159     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
160         return allowed[_owner][_spender];
161     }
162 
163 }
164 
165 contract DataKyc is StandardToken, Ownable {
166     
167     string public constant name = "Data Know Your Customer";                   //fancy name: eg Simon Bucks
168     uint8 public constant decimals = 18;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
169     string public constant symbol = "DKYC";                 //An identifier: eg SBX
170     string public constant version = 'v0.2';       //dkyc 0.1 standard. Just an arbitrary versioning scheme.
171 
172 
173     bool public transferEnabled = true;
174 
175 
176     modifier validDestination( address to ) {
177         require(to != address(0x0));
178         require(to != address(this) );
179         _;
180     }
181 
182     function DataKyc() {
183         // Mint all tokens. Then disable minting forever.
184         totalSupply = 100000000 * 10 ** uint256(decimals);
185         balances[msg.sender] = totalSupply;
186         Transfer(address(0x0), msg.sender, totalSupply);
187         transferOwnership(msg.sender); // admin could drain tokens that were sent here by mistake
188     }
189 
190     function transfer(address _to, uint _value)
191     validDestination(_to)
192     returns (bool) {
193         require(transferEnabled == true);
194         return super.transfer(_to, _value);
195     }
196 
197     function transferFrom(address _from, address _to, uint _value)
198     validDestination(_to)
199     returns (bool) {
200         require(transferEnabled == true);
201         return super.transferFrom(_from, _to, _value);
202     }
203 
204 
205     function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner {
206         token.transfer( owner, amount );
207     }
208 
209     function setTransferEnable(bool enable) onlyOwner {
210         transferEnabled = enable;
211     }
212 }