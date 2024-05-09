1 pragma solidity ^0.4.17;
2 
3 //Developed by Zenos Pavlakou
4 
5 library SafeMath {
6     
7     function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
8         uint256 c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 
31 contract Ownable {
32     
33     address public owner;
34 
35     /**
36      * The address whcih deploys this contrcat is automatically assgined ownership.
37      * */
38     function Ownable() public {
39         owner = msg.sender;
40     }
41 
42     /**
43      * Functions with this modifier can only be executed by the owner of the contract. 
44      * */
45     modifier onlyOwner {
46         require(msg.sender == owner);
47         _;
48     }
49 }
50 
51 
52 contract ERC20Basic {
53     uint256 public totalSupply;
54     function balanceOf(address who) constant public returns (uint256);
55     function transfer(address to, uint256 value) public returns (bool);
56     event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 
60 contract ERC20 is ERC20Basic {
61     function allowance(address owner, address spender) constant public returns (uint256);
62     function transferFrom(address from, address to, uint256 value) public  returns (bool);
63     function approve(address spender, uint256 value) public returns (bool);
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 
68 contract BasicToken is ERC20Basic, Ownable {
69 
70     using SafeMath for uint256;
71 
72     mapping (address => uint256) balances;
73 
74     modifier onlyPayloadSize(uint size) {
75         if (msg.data.length < size + 4) {
76         revert();
77         }
78         _;
79     }
80 
81     /**
82      * Transfers ACO tokens from the sender's account to another given account.
83      * 
84      * @param _to The address of the recipient.
85      * @param _amount The amount of tokens to send.
86      * */
87     function transfer(address _to, uint256 _amount) public onlyPayloadSize(2 * 32) returns (bool) {
88         require(balances[msg.sender] >= _amount);
89         balances[msg.sender] = balances[msg.sender].sub(_amount);
90         balances[_to] = balances[_to].add(_amount);
91         Transfer(msg.sender, _to, _amount);
92         return true;
93     }
94 
95     /**
96      * Returns the balance of a given address.
97      * 
98      * @param _addr The address of the balance to query.
99      **/
100     function balanceOf(address _addr) public constant returns (uint256) {
101         return balances[_addr];
102     }
103 }
104 
105 
106 contract AdvancedToken is BasicToken, ERC20 {
107 
108     mapping (address => mapping (address => uint256)) allowances;
109 
110     /**
111      * Transfers tokens from the account of the owner by an approved spender. 
112      * The spender cannot spend more than the approved amount. 
113      * 
114      * @param _from The address of the owners account.
115      * @param _amount The amount of tokens to transfer.
116      * */
117     function transferFrom(address _from, address _to, uint256 _amount) public onlyPayloadSize(3 * 32) returns (bool) {
118         require(allowances[_from][msg.sender] >= _amount && balances[_from] >= _amount);
119         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_amount);
120         balances[_from] = balances[_from].sub(_amount);
121         balances[_to] = balances[_to].add(_amount);
122         Transfer(_from, _to, _amount);
123         return true;
124     }
125 
126     /**
127      * Allows another account to spend a given amount of tokens on behalf of the 
128      * owner's account. If the owner has previously allowed a spender to spend
129      * tokens on his or her behalf and would like to change the approval amount,
130      * he or she will first have to set the allowance back to 0 and then update
131      * the allowance.
132      * 
133      * @param _spender The address of the spenders account.
134      * @param _amount The amount of tokens the spender is allowed to spend.
135      * */
136     function approve(address _spender, uint256 _amount) public returns (bool) {
137         require((_amount == 0) || (allowances[msg.sender][_spender] == 0));
138         allowances[msg.sender][_spender] = _amount;
139         Approval(msg.sender, _spender, _amount);
140         return true;
141     }
142 
143 
144     /**
145      * Returns the approved allowance from an owners account to a spenders account.
146      * 
147      * @param _owner The address of the owners account.
148      * @param _spender The address of the spenders account.
149      **/
150     function allowance(address _owner, address _spender) public constant returns (uint256) {
151         return allowances[_owner][_spender];
152     }
153 }
154 
155 
156 contract MintableToken is AdvancedToken {
157 
158     bool public mintingFinished;
159 
160     event TokensMinted(address indexed to, uint256 amount);
161     event MintingFinished();
162 
163     /**
164      * Generates new ACO tokens during the ICO, after which the minting period 
165      * will terminate permenantly. This function can only be called by the ICO 
166      * contract.
167      * 
168      * @param _to The address of the account to mint new tokens to.
169      * @param _amount The amount of tokens to mint. 
170      * */
171     function mint(address _to, uint256 _amount) external onlyOwner onlyPayloadSize(2 * 32) returns (bool) {
172         require(_to != 0x0 && _amount > 0 && !mintingFinished);
173         balances[_to] = balances[_to].add(_amount);
174         totalSupply = totalSupply.add(_amount);
175         Transfer(0x0, _to, _amount);
176         TokensMinted(_to, _amount);
177         return true;
178     }
179 
180     /**
181      * Terminates the minting period permenantly. This function can only be called
182      * by the ICO contract only when the duration of the ICO has ended. 
183      * */
184     function finishMinting() external onlyOwner {
185         require(!mintingFinished);
186         mintingFinished = true;
187         MintingFinished();
188     }
189     
190     /**
191      * Returns true if the minting period has ended, false otherwhise.
192      * */
193     function mintingFinished() public constant returns (bool) {
194         return mintingFinished;
195     }
196 }
197 
198 contract ACO is MintableToken {
199 
200     uint8 public decimals;
201     string public name;
202     string public symbol;
203 
204     function ACO() public {
205         totalSupply = 0;
206         decimals = 18;
207         name = "ACO";
208         symbol = "ACO";
209     }
210 }