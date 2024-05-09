1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13     function div(uint256 a, uint256 b) internal constant returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21     function add(uint256 a, uint256 b) internal constant returns (uint256) {
22         uint256 c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 }
27 
28 /**
29  * @title Ownable
30  * @dev The Ownable contract has an owner address, and provides basic authorization control
31  * functions, this simplifies the implementation of "user permissions".
32  */
33 contract Ownable {
34     address public owner;
35     /**
36       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
37       * account.
38       */
39     function Ownable() {
40         owner = msg.sender;
41     }
42 
43     /**
44        * @dev Throws if called by any account other than the owner.
45        */
46     modifier onlyOwner() {
47         require(msg.sender == owner);
48         _;
49     }
50 
51     /**
52        * @dev Allows the current owner to transfer control of the contract to a newOwner.
53        * @param newOwner The address to transfer ownership to.
54        */
55     function transferOwnership(address newOwner) onlyOwner {
56         require(newOwner != address(0));
57         owner = newOwner;
58     }
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is Ownable {
66     function allowance(address owner, address spender) constant returns (uint256);
67     function transferFrom(address from, address to, uint256 value) returns (bool);
68     function transfer(address to, uint256 value) returns (bool);
69     function approve(address spender, uint256 value) returns (bool);
70     event Transfer(address indexed from, address indexed to, uint256 value);
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81     uint256 public totalSupply;
82     function balanceOf(address who) constant returns (uint256);
83 }
84 
85 
86 /**
87  * @title Basic token
88  * @dev Basic version of StandardToken, with no allowances.
89  */
90 contract BasicToken is ERC20Basic {
91     using SafeMath for uint256;
92     mapping(address => uint256) balances;
93     function balanceOf(address _owner) constant returns (uint256 balance) {
94         return balances[_owner];
95     }
96 }
97 
98 /**
99  * @title Standard ERC20 token
100  *
101  * @dev Implementation of the basic standard token.
102  * @dev https://github.com/ethereum/EIPs/issues/20
103  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
104  */
105 contract StandardToken is ERC20, BasicToken {
106 
107     mapping (address => mapping (address => uint256)) allowed;
108     function transfer(address _to, uint256 _value) returns (bool) {
109         balances[msg.sender] = balances[msg.sender].sub(_value);
110         balances[_to] = balances[_to].add(_value);
111         Transfer(msg.sender, _to, _value);
112         return true;
113     }
114     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
115         var _allowance = allowed[_from][msg.sender];
116         balances[_to] = balances[_to].add(_value);
117         balances[_from] = balances[_from].sub(_value);
118         allowed[_from][msg.sender] = _allowance.sub(_value);
119         Transfer(_from, _to, _value);
120         return true;
121     }
122     function approve(address _spender, uint256 _value) returns (bool) {
123         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
124         allowed[msg.sender][_spender] = _value;
125         Approval(msg.sender, _spender, _value);
126         return true;
127     }
128     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
129         return allowed[_owner][_spender];
130     }
131 }
132 
133 /**
134  * @title Mintable token
135  * @dev Simple ERC20 Token example, with mintable token creation
136  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
137  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
138  */
139 contract MintableToken is StandardToken {
140     event Mint(address indexed to, uint256 amount);
141     event MintFinished();
142 
143     bool public mintingFinished = false;
144 
145     address public mintAddress;
146 
147     modifier canMint() {
148         require(!mintingFinished);
149         _;
150     }
151     modifier onlyMint() {
152         require(msg.sender == mintAddress);
153         _;
154     }
155     function setMintAddress(address addr) onlyOwner public {
156         mintAddress = addr;
157     }
158 
159     /**
160    * @dev Function to mint tokens
161    * Only specified address can mint
162    * @param _to The address that will receive the minted tokens.
163    * @param _amount The amount of tokens to mint.
164    * @return A boolean that indicates if the operation was successful.
165    */
166     function mint(address _to, uint256 _amount) onlyMint canMint returns (bool) {
167         totalSupply = totalSupply.add(_amount);
168         balances[_to] = balances[_to].add(_amount);
169         Mint(_to, _amount);
170         Transfer(0x0, _to, _amount);
171         return true;
172     }
173 
174     function finishMinting() onlyOwner returns (bool) {
175         mintingFinished = true;
176         MintFinished();
177         return true;
178     }
179 }
180 
181 /**
182 * EZMarket token
183 */
184 contract EZMarket is MintableToken {
185     string public name = "EZMarket";
186     string public symbol = "EZM";
187     uint public decimals = 8;
188     function EZMarket() {
189     }
190 }