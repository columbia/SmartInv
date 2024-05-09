1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20 Token Interface
6  */
7 contract ERC20 {
8     uint256 public totalSupply;
9     function balanceOf(address _owner) public view returns (uint256 balance);
10     function transfer(address _to, uint256 _value) public returns (bool success);
11     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
12     function approve(address _spender, uint256 _value) public returns (bool success);
13     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
14 
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 }
18 
19 
20 /**
21  * @title ERC677 transferAndCall token interface
22  * @dev See https://github.com/ethereum/EIPs/issues/677 for specification and
23  *      discussion.
24  */
25 contract ERC677 {
26     event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
27 
28     function transferAndCall(address _to, uint _value, bytes _data) public returns (bool success);
29 }
30 
31 /**
32  * @title Receiver interface for ERC677 transferAndCall
33  * @dev See https://github.com/ethereum/EIPs/issues/677 for specification and
34  *      discussion.
35  */
36 contract ERC677Receiver {
37     function tokenFallback(address _from, uint _value, bytes _data) public;
38 }
39 
40 
41 /**
42  * @title VALID Token
43  * @dev ERC20 compatible smart contract for the VALID token. Closely follows
44  *      ConsenSys StandardToken.
45  */
46 contract ValidToken is ERC677, ERC20 {
47     // token metadata
48     string public constant name = "VALID";
49     string public constant symbol = "VLD";
50     uint8 public constant decimals = 18;
51 
52     // total supply and maximum amount of tokens
53     uint256 public constant maxSupply = 10**9 * 10**uint256(decimals);
54     // note: this equals 10**27, which is smaller than uint256 max value (~10**77)
55 
56     // token accounting
57     mapping(address => uint256) balances;
58     mapping(address => mapping(address => uint256)) internal allowed;
59 
60     // token lockups
61     mapping(address => uint256) lockups;
62     event TokensLocked(address indexed _holder, uint256 _timeout);
63 
64     // ownership
65     address public owner;
66     modifier onlyOwner() {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     // minting
72     bool public mintingDone = false;
73     modifier mintingFinished() {
74         require(mintingDone == true);
75         _;
76     }
77     modifier mintingInProgress() {
78         require(mintingDone == false);
79         _;
80     }
81 
82     // constructor
83     function ValidToken() public {
84         owner = msg.sender;
85     }
86 
87     /**
88      * @dev Allows the current owner to transfer the ownership.
89      * @param _newOwner The address to transfer ownership to.
90      */
91     function transferOwnership(address _newOwner) public onlyOwner {
92         owner = _newOwner;
93     }
94 
95     // minting functionality
96 
97     function mint(address[] _recipients, uint256[] _amounts) public mintingInProgress onlyOwner {
98         require(_recipients.length == _amounts.length);
99         require(_recipients.length < 255);
100 
101         for (uint8 i = 0; i < _recipients.length; i++) {
102             address recipient = _recipients[i];
103             uint256 amount = _amounts[i];
104 
105             // enforce maximum token supply
106             require(totalSupply + amount >= totalSupply);
107             require(totalSupply + amount <= maxSupply);
108 
109             balances[recipient] += amount;
110             totalSupply += amount;
111 
112             Transfer(0, recipient, amount);
113         }
114     }
115 
116     function lockTokens(address[] _holders, uint256[] _timeouts) public mintingInProgress onlyOwner {
117         require(_holders.length == _timeouts.length);
118         require(_holders.length < 255);
119 
120         for (uint8 i = 0; i < _holders.length; i++) {
121             address holder = _holders[i];
122             uint256 timeout = _timeouts[i];
123 
124             // make sure lockup period can not be overwritten
125             require(lockups[holder] == 0);
126 
127             lockups[holder] = timeout;
128             TokensLocked(holder, timeout);
129         }
130     }
131 
132     function finishMinting() public mintingInProgress onlyOwner {
133         // check hard cap again
134         assert(totalSupply <= maxSupply);
135 
136         mintingDone = true;
137     }
138 
139     // ERC20 functionality
140 
141     function balanceOf(address _owner) public view returns (uint256) {
142         return balances[_owner];
143     }
144 
145     function transfer(address _to, uint256 _value) public mintingFinished returns (bool) {
146         // prevent some common errors
147         require(_to != address(0x0));
148         require(_to != address(this));
149 
150         // check lockups
151         if (lockups[msg.sender] != 0) {
152             require(now >= lockups[msg.sender]);
153         }
154 
155         // check balance
156         require(balances[msg.sender] >= _value);
157         assert(balances[_to] + _value >= balances[_to]); // receiver balance overflow check
158 
159         balances[msg.sender] -= _value;
160         balances[_to] += _value;
161 
162         Transfer(msg.sender, _to, _value);
163         return true;
164     }
165 
166     function transferFrom(address _from, address _to, uint256 _value) public mintingFinished returns (bool) {
167         // prevent some common errors
168         require(_to != address(0x0));
169         require(_to != address(this));
170 
171         // check lockups
172         if (lockups[_from] != 0) {
173             require(now >= lockups[_from]);
174         }
175 
176         // check balance and allowance
177         uint256 allowance = allowed[_from][msg.sender];
178         require(balances[_from] >= _value);
179         require(allowance >= _value);
180         assert(balances[_to] + _value >= balances[_to]); // receiver balance overflow check
181 
182         allowed[_from][msg.sender] -= _value;
183         balances[_from] -= _value;
184         balances[_to] += _value;
185 
186         Transfer(_from, _to, _value);
187         return true;
188     }
189 
190     function approve(address _spender, uint256 _value) public returns (bool) {
191         // no check for zero allowance, see NOTES.md
192 
193         allowed[msg.sender][_spender] = _value;
194 
195         Approval(msg.sender, _spender, _value);
196         return true;
197     }
198 
199     function allowance(address _owner, address _spender) public view returns (uint256) {
200         return allowed[_owner][_spender];
201     }
202 
203     // ERC677 functionality
204 
205     function transferAndCall(address _to, uint _value, bytes _data) public mintingFinished returns (bool) {
206         require(transfer(_to, _value));
207 
208         Transfer(msg.sender, _to, _value, _data);
209 
210         // call receiver
211         if (isContract(_to)) {
212             ERC677Receiver receiver = ERC677Receiver(_to);
213             receiver.tokenFallback(msg.sender, _value, _data);
214         }
215         return true;
216     }
217 
218     function isContract(address _addr) private view returns (bool) {
219         uint len;
220         assembly {
221             len := extcodesize(_addr)
222         }
223         return len > 0;
224     }
225 }