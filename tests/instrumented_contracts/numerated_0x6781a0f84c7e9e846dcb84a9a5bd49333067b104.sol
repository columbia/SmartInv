1 pragma solidity ^0.4.11;
2 library SafeMath {
3     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
4         uint256 c = a * b;
5         assert(a == 0 || c / a == b);
6         return c;
7     }
8     function div(uint256 a, uint256 b) internal constant returns (uint256) {
9         // assert(b > 0); // Solidity automatically throws when dividing by 0
10         uint256 c = a / b;
11         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
12         return c;
13     }
14     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
15         assert(b <= a);
16         return a - b;
17     }
18     function add(uint256 a, uint256 b) internal constant returns (uint256) {
19         uint256 c = a + b;
20         assert(c >= a);
21         return c;
22     }
23 }
24 contract ERC20Basic {
25     uint256 public totalSupply;
26     function balanceOf(address who) public constant returns (uint256);
27     function transfer(address to, uint256 value) public returns (bool);
28     event Transfer(address indexed from, address indexed to, uint256 value);
29 }
30 /**
31  * @title ERC20 interface
32  * @dev see https://github.com/ethereum/EIPs/issues/20
33  */
34 contract ERC20 is ERC20Basic {
35     function allowance(address owner, address spender) public constant returns (uint256);
36     function transferFrom(address from, address to, uint256 value) public returns (bool);
37     function approve(address spender, uint256 value) public returns (bool);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 contract BasicToken is ERC20Basic {
41     using SafeMath for uint256;
42     mapping(address => uint256) balances;
43     /**
44     * @dev transfer token for a specified address
45     * @param _to The address to transfer to.
46     * @param _value The amount to be transferred.
47     */
48     function transfer(address _to, uint256 _value) public returns (bool) {
49         require(_to != address(0));
50         // SafeMath.sub will throw if there is not enough balance.
51         balances[msg.sender] = balances[msg.sender].sub(_value);
52         balances[_to] = balances[_to].add(_value);
53         Transfer(msg.sender, _to, _value);
54         return true;
55     }
56     /**
57     * @dev Gets the balance of the specified address.
58     * @param _owner The address to query the the balance of.
59     * @return An uint256 representing the amount owned by the passed address.
60     */
61     function balanceOf(address _owner) public constant returns (uint256 balance) {
62         return balances[_owner];
63     }
64 }
65 contract Ownable {
66     address public owner;
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68     /**
69      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
70      * account.
71      */
72     function Ownable() {
73         owner = msg.sender;
74     }
75     /**
76      * @dev Throws if called by any account other than the owner.
77      */
78     modifier onlyOwner() {
79         require(msg.sender == owner);
80         _;
81     }
82     /**
83      * @dev Allows the current owner to transfer control of the contract to a newOwner.
84      * @param newOwner The address to transfer ownership to.
85      */
86     function transferOwnership(address newOwner) onlyOwner public {
87         require(newOwner != address(0));
88         OwnershipTransferred(owner, newOwner);
89         owner = newOwner;
90     }
91 }
92 contract StandardToken is ERC20, BasicToken {
93     mapping (address => mapping (address => uint256)) allowed;
94     /**
95      * @dev Transfer tokens from one address to another
96      * @param _from address The address which you want to send tokens from
97      * @param _to address The address which you want to transfer to
98      * @param _value uint256 the amount of tokens to be transferred
99      */
100     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
101         require(_to != address(0));
102         uint256 _allowance = allowed[_from][msg.sender];
103         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
104         // require (_value <= _allowance);
105         balances[_from] = balances[_from].sub(_value);
106         balances[_to] = balances[_to].add(_value);
107         allowed[_from][msg.sender] = _allowance.sub(_value);
108         Transfer(_from, _to, _value);
109         return true;
110     }
111     /**
112      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
113      *
114      * Beware that changing an allowance with this method brings the risk that someone may use both the old
115      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
116      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
117      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
118      * @param _spender The address which will spend the funds.
119      * @param _value The amount of tokens to be spent.
120      */
121     function approve(address _spender, uint256 _value) public returns (bool) {
122         allowed[msg.sender][_spender] = _value;
123         Approval(msg.sender, _spender, _value);
124         return true;
125     }
126     /**
127      * @dev Function to check the amount of tokens that an owner allowed to a spender.
128      * @param _owner address The address which owns the funds.
129      * @param _spender address The address which will spend the funds.
130      * @return A uint256 specifying the amount of tokens still available for the spender.
131      */
132     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
133         return allowed[_owner][_spender];
134     }
135     /**
136      * approve should be called when allowed[_spender] == 0. To increment
137      * allowed value is better to use this function to avoid 2 calls (and wait until
138      * the first transaction is mined)
139      * From MonolithDAO Token.sol
140      */
141     function increaseApproval (address _spender, uint _addedValue)
142         returns (bool success) {
143         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
144         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
145         return true;
146     }
147     function decreaseApproval (address _spender, uint _subtractedValue)
148         returns (bool success) {
149         uint oldValue = allowed[msg.sender][_spender];
150         if (_subtractedValue > oldValue) {
151             allowed[msg.sender][_spender] = 0;
152         } else {
153             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
154         }
155         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
156         return true;
157     }
158 }
159 
160 contract MintableToken is StandardToken, Ownable {
161     event Mint(address indexed to, uint256 amount);
162     event MintFinished();
163     bool public mintingFinished = false;
164     modifier canMint() {
165         require(!mintingFinished);
166         _;
167     }
168     /**
169      * @dev Function to mint tokens
170      * @param _to The address that will receive the minted tokens.
171      * @param _amount The amount of tokens to mint.
172      * @return A boolean that indicates if the operation was successful.
173      */
174     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
175         totalSupply = totalSupply.add(_amount);
176         balances[_to] = balances[_to].add(_amount);
177         Mint(_to, _amount);
178         Transfer(0x0, _to, _amount);
179         return true;
180     }
181     /**
182      * @dev Function to stop minting new tokens.
183      * @return True if the operation was successful.
184      */
185     function finishMinting() onlyOwner public returns (bool) {
186         mintingFinished = true;
187         MintFinished();
188         return true;
189     }
190 }
191 contract ZapToken is MintableToken {
192     string public name = "ZAP TOKEN";
193     string public symbol = "ZAP";
194     uint256 public decimals = 18;
195 }