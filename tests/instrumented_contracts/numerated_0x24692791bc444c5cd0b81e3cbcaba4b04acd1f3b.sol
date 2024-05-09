1 pragma solidity ^0.4.15;
2 /**
3 * UnikoinGold - UKG - Contract
4 * Repo at: https://github.com/unikoingold/UnikoinGold-UKG-Contract
5 */
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
13         uint256 c = a * b;
14         assert(a == 0 || c / a == b);
15         return c;
16     }
17     function div(uint256 a, uint256 b) internal constant returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27     function add(uint256 a, uint256 b) internal constant returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39     uint256 public totalSupply;
40     function balanceOf(address who) public constant returns (uint256);
41     function transfer(address to, uint256 value) public returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 /**
45  * @title ERC20 interface
46  * @dev see https://github.com/ethereum/EIPs/issues/20
47  */
48 contract ERC20 is ERC20Basic {
49     function allowance(address owner, address spender) public constant returns (uint256);
50     function transferFrom(address from, address to, uint256 value) public returns (bool);
51     function approve(address spender, uint256 value) public returns (bool);
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 /**
55  * @title Basic token
56  * @dev Basic version of StandardToken, with no allowances.
57  */
58 contract BasicToken is ERC20Basic {
59     using SafeMath for uint256;
60     mapping(address => uint256) balances;
61     /**
62     * @dev transfer token for a specified address
63     * @param _to The address to transfer to.
64     * @param _value The amount to be transferred.
65     */
66     function transfer(address _to, uint256 _value) public returns (bool) {
67         require(_to != address(0));
68         // SafeMath.sub will throw if there is not enough balance.
69         balances[msg.sender] = balances[msg.sender].sub(_value);
70         balances[_to] = balances[_to].add(_value);
71         Transfer(msg.sender, _to, _value);
72         return true;
73     }
74     /**
75     * @dev Gets the balance of the specified address.
76     * @param _owner The address to query the the balance of.
77     * @return An uint256 representing the amount owned by the passed address.
78     */
79     function balanceOf(address _owner) public constant returns (uint256 balance) {
80         return balances[_owner];
81     }
82 }
83 /**
84  * @title Standard ERC20 token
85  *
86  * @dev Implementation of the basic standard token.
87  * @dev https://github.com/ethereum/EIPs/issues/20
88  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
89  */
90 contract StandardToken is ERC20, BasicToken {
91     mapping (address => mapping (address => uint256)) allowed;
92     /**
93      * @dev Transfer tokens from one address to another
94      * @param _from address The address which you want to send tokens from
95      * @param _to address The address which you want to transfer to
96      * @param _value uint256 the amount of tokens to be transferred
97      */
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
99         require(_to != address(0));
100         uint256 _allowance = allowed[_from][msg.sender];
101         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
102         // require (_value <= _allowance);
103         balances[_from] = balances[_from].sub(_value);
104         balances[_to] = balances[_to].add(_value);
105         allowed[_from][msg.sender] = _allowance.sub(_value);
106         Transfer(_from, _to, _value);
107         return true;
108     }
109     /**
110      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
111      *
112      * Beware that changing an allowance with this method brings the risk that someone may use both the old
113      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
114      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
115      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
116      * @param _spender The address which will spend the funds.
117      * @param _value The amount of tokens to be spent.
118      */
119     function approve(address _spender, uint256 _value) public returns (bool) {
120         allowed[msg.sender][_spender] = _value;
121         Approval(msg.sender, _spender, _value);
122         return true;
123     }
124     /**
125      * @dev Function to check the amount of tokens that an owner allowed to a spender.
126      * @param _owner address The address which owns the funds.
127      * @param _spender address The address which will spend the funds.
128      * @return A uint256 specifying the amount of tokens still available for the spender.
129      */
130     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
131         return allowed[_owner][_spender];
132     }
133     /**
134      * approve should be called when allowed[_spender] == 0. To increment
135      * allowed value is better to use this function to avoid 2 calls (and wait until
136      * the first transaction is mined)
137      * From MonolithDAO Token.sol
138      */
139     function increaseApproval (address _spender, uint _addedValue)
140     returns (bool success) {
141         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
142         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143         return true;
144     }
145     function decreaseApproval (address _spender, uint _subtractedValue)
146     returns (bool success) {
147         uint oldValue = allowed[msg.sender][_spender];
148         if (_subtractedValue > oldValue) {
149             allowed[msg.sender][_spender] = 0;
150         } else {
151             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
152         }
153         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
154         return true;
155     }
156 }
157 
158 contract UnikoinGold is StandardToken {
159 
160     // ERC20 Standard
161     string public constant name = "UnikoinGold";
162     string public constant symbol = "UKG";
163     uint8 public constant decimals = 18;
164     string public version = "1.0";
165 
166     uint256 public constant EXP_18 = 18;
167     uint256 public constant TOTAL_COMMUNITY_ALLOCATION = 200 * (10**6) * 10**EXP_18;  // 200M tokens to be distributed to community
168     uint256 public constant UKG_FUND = 800 * (10**6) * 10**EXP_18;                    // 800M UKG reserved for Unikrn use
169     uint256 public constant TOTAL_TOKENS = 1000 * (10**6) * 10**EXP_18;               // 1 Billion total UKG created
170 
171     event CreateUKGEvent(address indexed _to, uint256 _value);  // Logs the creation of the token
172 
173     function UnikoinGold(address _tokenDistributionContract, address _ukgFund){
174         require(_tokenDistributionContract != 0);  // Force this value not to be initialized to 0
175         require(_ukgFund != 0);                    // Force this value not to be initialized to 0
176         require(TOTAL_TOKENS == TOTAL_COMMUNITY_ALLOCATION.add(UKG_FUND));  // Check that there are 1 Billion tokens total
177 
178         totalSupply = TOTAL_COMMUNITY_ALLOCATION.add(UKG_FUND);  // Add to totalSupply for ERC20 compliance
179 
180         balances[_tokenDistributionContract] = TOTAL_COMMUNITY_ALLOCATION;       // Transfer tokens to the distribution contract
181         Transfer(0x0, _tokenDistributionContract, TOTAL_COMMUNITY_ALLOCATION);   // Log the transfer
182         CreateUKGEvent(_tokenDistributionContract, TOTAL_COMMUNITY_ALLOCATION);  // Log the event
183 
184         balances[_ukgFund] = UKG_FUND;       // Transfer tokens to the Unikrn Wallet
185         Transfer(0x0, _ukgFund, UKG_FUND);   // Log the transfer
186         CreateUKGEvent(_ukgFund, UKG_FUND);  // Log the event
187     }
188 }