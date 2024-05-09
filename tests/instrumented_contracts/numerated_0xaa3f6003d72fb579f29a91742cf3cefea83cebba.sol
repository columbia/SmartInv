1 pragma solidity ^0.4.13;
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
29 contract ERC20Basic {
30     uint256 public totalSupply;
31     function balanceOf(address who) constant returns (uint256);
32     function transfer(address to, uint256 value) returns (bool);
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract ERC20 is ERC20Basic {
37     function allowance(address owner, address spender) constant returns (uint256);
38     function transferFrom(address from, address to, uint256 value) returns (bool);
39     function approve(address spender, uint256 value) returns (bool);
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 contract BasicToken is ERC20Basic {
44     using SafeMath for uint256;
45 
46     mapping(address => uint256) balances;
47 
48     /**
49     * @dev transfer token for a specified address
50     * @param _to The address to transfer to.
51     * @param _value The amount to be transferred.
52     */
53     function transfer(address _to, uint256 _value) returns (bool) {
54         balances[msg.sender] = balances[msg.sender].sub(_value);
55         balances[_to] = balances[_to].add(_value);
56         Transfer(msg.sender, _to, _value);
57         return true;
58     }
59 
60     /**
61     * @dev Gets the balance of the specified address.
62     * @param _owner The address to query the the balance of.
63     * @return An uint256 representing the amount owned by the passed address.
64     */
65     function balanceOf(address _owner) constant returns (uint256 balance) {
66         return balances[_owner];
67     }
68 
69 }
70 
71 contract StandardToken is ERC20, BasicToken {
72 
73     mapping (address => mapping (address => uint256)) allowed;
74 
75 
76     /**
77      * @dev Transfer tokens from one address to another
78      * @param _from address The address which you want to send tokens from
79      * @param _to address The address which you want to transfer to
80      * @param _value uint256 the amout of tokens to be transfered
81      */
82     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
83         var _allowance = allowed[_from][msg.sender];
84 
85         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
86         // require (_value <= _allowance);
87 
88         balances[_to] = balances[_to].add(_value);
89         balances[_from] = balances[_from].sub(_value);
90         allowed[_from][msg.sender] = _allowance.sub(_value);
91         Transfer(_from, _to, _value);
92         return true;
93     }
94 
95     /**
96      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
97      * @param _spender The address which will spend the funds.
98      * @param _value The amount of tokens to be spent.
99      */
100     function approve(address _spender, uint256 _value) returns (bool) {
101 
102         // To change the approve amount you first have to reduce the addresses`
103         //  allowance to zero by calling `approve(_spender, 0)` if it is not
104         //  already 0 to mitigate the race condition described here:
105         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
106         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
107 
108         allowed[msg.sender][_spender] = _value;
109         Approval(msg.sender, _spender, _value);
110         return true;
111     }
112 
113     /**
114      * @dev Function to check the amount of tokens that an owner allowed to a spender.
115      * @param _owner address The address which owns the funds.
116      * @param _spender address The address which will spend the funds.
117      * @return A uint256 specifing the amount of tokens still avaible for the spender.
118      */
119     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
120         return allowed[_owner][_spender];
121     }
122 
123 }
124 
125 contract MultiOwnable {
126     mapping (address => bool) owners;
127 
128     function MultiOwnable() public {
129         // Add the sender of the contract as the initial owner
130         owners[msg.sender] = true;
131     }
132 
133     /**
134      * @dev Throws if called by any account other than the owner.
135      */
136     modifier onlyOwner() {
137         require(owners[msg.sender]);
138         _;
139     }
140 
141     /**
142      * @dev Adds an owner
143      */
144     function addOwner(address newOwner) onlyOwner public {
145         // #0 is an invalid address
146         require(newOwner != address(0));
147 
148         owners[newOwner] = true;
149     }
150 
151     /**
152      * @dev Removes an owner
153      */
154     function removeOwner(address ownerToRemove) onlyOwner public {
155         owners[ownerToRemove] = false;
156     }
157 
158     /**
159      * @dev Checks if address is an owner
160      */
161     function isOwner(address possibleOwner) onlyOwner view public returns (bool) {
162         return owners[possibleOwner];
163     }
164 }
165 
166 contract MintableToken is StandardToken, MultiOwnable {
167     // Emitted when new coin is brought into the world
168     event Mint(address indexed to, uint256 amount);
169 
170     /**
171     * @dev Function to mint tokens
172     * @param _to The address that will receive the minted tokens.
173     * @param _amount The amount of tokens to mint.
174     * @return A boolean that indicates if the operation was successful.
175     */
176     function mint(address _to, uint256 _amount) onlyOwner returns (bool) {
177         totalSupply = totalSupply.add(_amount);
178         balances[_to] = balances[_to].add(_amount);
179 
180         Mint(_to, _amount);
181         Transfer(0x0, _to, _amount);
182 
183         return true;
184     }
185 }
186 
187 contract MingoCoin is MintableToken {
188     string public constant name = "MingoCoin";
189     string public constant symbol = "XMC";
190     uint8 public constant decimals = 18;
191 }