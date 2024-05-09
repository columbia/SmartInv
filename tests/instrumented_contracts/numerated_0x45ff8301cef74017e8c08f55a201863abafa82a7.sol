1 pragma solidity ^0.4.17;
2 
3 contract ERC20Basic {
4     uint256 public totalSupply;
5     string public name;
6     string public symbol;
7     uint8 public decimals;
8     function balanceOf(address who) constant public returns (uint256);
9     function transfer(address to, uint256 value) public returns (bool);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 
14 library SafeMath {
15     
16     function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
17         uint256 c = a * b;
18         assert(a == 0 || c / a == b);
19         return c;
20     }
21 
22     function div(uint256 a, uint256 b) internal pure  returns (uint256) {
23         uint256 c = a / b;
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         assert(b <= a);
29         return a - b;
30     }
31 
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         assert(c >= a);
35         return c;
36     }
37 }
38 
39 
40 contract Ownable {
41     
42     address public owner;
43 
44     /**
45      * The address whcih deploys this contrcat is automatically assgined ownership.
46      * */
47     function Ownable() public {
48         owner = msg.sender;
49     }
50 
51     /**
52      * Functions with this modifier can only be executed by the owner of the contract. 
53      * */
54     modifier onlyOwner {
55         require(msg.sender == owner);
56         _;
57     }
58 
59     event OwnershipTransferred(address indexed from, address indexed to);
60 
61     /**
62     * Transfers ownership to new Ethereum address. This function can only be called by the 
63     * owner.
64     * @param _newOwner the address to be granted ownership.
65     **/
66     function transferOwnership(address _newOwner) public onlyOwner {
67         require(_newOwner != 0x0);
68         OwnershipTransferred(owner, _newOwner);
69         owner = _newOwner;
70     }
71 }
72 
73 
74 contract BasicToken is ERC20Basic, Ownable {
75 
76     using SafeMath for uint256;
77 
78     mapping (address => uint256) balances;
79 
80     /**
81      * Transfers tokens from the sender's account to another given account.
82      * 
83      * @param _to The address of the recipient.
84      * @param _amount The amount of tokens to send.
85      * */
86     function transfer(address _to, uint256 _amount) public returns (bool) {
87         require(balances[msg.sender] >= _amount);
88         balances[msg.sender] = balances[msg.sender].sub(_amount);
89         balances[_to] = balances[_to].add(_amount);
90         Transfer(msg.sender, _to, _amount);
91         return true;
92     }
93 
94     /**
95      * Returns the balance of a given address.
96      * 
97      * @param _addr The address of the balance to query.
98      **/
99     function balanceOf(address _addr) public constant returns (uint256) {
100         return balances[_addr];
101     }
102 }
103 
104 
105 contract ERC20 is ERC20Basic {
106     function allowance(address owner, address spender) constant public returns (uint256);
107     function transferFrom(address from, address to, uint256 value) public  returns (bool);
108     function approve(address spender, uint256 value) public returns (bool);
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 
113 contract AdvancedToken is BasicToken, ERC20 {
114 
115     mapping (address => mapping (address => uint256)) allowances;
116 
117     /**
118      * Transfers tokens from the account of the owner by an approved spender. 
119      * The spender cannot spend more than the approved amount. 
120      * 
121      * @param _from The address of the owners account.
122      * @param _amount The amount of tokens to transfer.
123      * */
124     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
125         require(allowances[_from][msg.sender] >= _amount && balances[_from] >= _amount);
126         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_amount);
127         balances[_from] = balances[_from].sub(_amount);
128         balances[_to] = balances[_to].add(_amount);
129         Transfer(_from, _to, _amount);
130         return true;
131     }
132 
133     /**
134      * Allows another account to spend a given amount of tokens on behalf of the 
135      * sender's account.
136      * 
137      * @param _spender The address of the spenders account.
138      * @param _amount The amount of tokens the spender is allowed to spend.
139      * */
140     function approve(address _spender, uint256 _amount) public returns (bool) {
141         allowances[msg.sender][_spender] = _amount;
142         Approval(msg.sender, _spender, _amount);
143         return true;
144     }
145 
146     /**
147      * Increases the amount a given account can spend on behalf of the sender's 
148      * account.
149      * 
150      * @param _spender The address of the spenders account.
151      * @param _amount The amount of tokens the spender is allowed to spend.
152      * */
153     function increaseApproval(address _spender, uint256 _amount) public returns (bool) {
154         allowances[msg.sender][_spender] = allowances[msg.sender][_spender].add(_amount);
155         Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
156         return true;
157     }
158 
159     /**
160      * Decreases the amount of tokens a given account can spend on behalf of the 
161      * sender's account.
162      * 
163      * @param _spender The address of the spenders account.
164      * @param _amount The amount of tokens the spender is allowed to spend.
165      * */
166     function decreaseApproval(address _spender, uint256 _amount) public returns (bool) {
167         require(allowances[msg.sender][_spender] != 0);
168         if (_amount >= allowances[msg.sender][_spender]) {
169             allowances[msg.sender][_spender] = 0;
170         } else {
171             allowances[msg.sender][_spender] = allowances[msg.sender][_spender].sub(_amount);
172             Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
173         }
174     }
175 
176     /**
177      * Returns the approved allowance from an owners account to a spenders account.
178      * 
179      * @param _owner The address of the owners account.
180      * @param _spender The address of the spenders account.
181      **/
182     function allowance(address _owner, address _spender) public constant returns (uint256) {
183         return allowances[_owner][_spender];
184     }
185 
186 }
187 
188 
189 contract BurnableToken is AdvancedToken {
190 
191     event Burn(address indexed burner, uint256 value);
192 
193     /**
194      * @dev Burns a specific amount of tokens.
195      * @param _value The amount of token to be burned.
196      */
197     function burn(uint256 _value) public {
198         require(_value > 0 && _value <= balances[msg.sender]);
199         balances[msg.sender] = balances[msg.sender].sub(_value);
200         totalSupply = totalSupply.sub(_value);
201         Burn(msg.sender, _value);
202     }
203 }
204 
205 
206 contract UKW is BurnableToken {
207 
208     function UKW() public {
209         name = "Ubuntukingdomwealth";
210         symbol = "UKW";
211         decimals = 18;
212         totalSupply = 200000000e18;
213         balances[msg.sender] = totalSupply;
214     }
215 }